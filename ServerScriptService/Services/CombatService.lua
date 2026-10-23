--!strict
--[[
	CombatService - Transform + Morph + Farm + Kill + Killstreak
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(script.Parent.Parent.Modules.Config)
local BrainrotData = require(script.Parent.Parent.Modules.BrainrotData)

local CombatService = {}

-- lazy require to avoid circular
local function getEventService()
	return require(script.Parent.EventService)
end

local function getLeaderstats(player: Player)
	return player:FindFirstChild("leaderstats")
end

local function getPower(player: Player): number
	local ls = getLeaderstats(player)
	return (ls and ls:FindFirstChild("Power") and ls.Power.Value) or Config.StartingPower
end

local function getLevel(player: Player): number
	local ls = getLeaderstats(player)
	return (ls and ls:FindFirstChild("Level") and ls.Level.Value) or 1
end

local function addXP(player: Player, amount: number)
	local ls = getLeaderstats(player)
	if not ls or not ls:FindFirstChild("XP") then return end

	local multi = 1
	pcall(function()
		multi = getEventService().GetXPMulti()
	end)
	amount = math.floor(amount * multi)

	ls.XP.Value += amount

	local needed = getLevel(player) * Config.XPPerLevelBase
	while ls.XP.Value >= needed do
		ls.XP.Value -= needed
		ls.Level.Value += 1
		if ls:FindFirstChild("Power") then
			ls.Power.Value += Config.PowerPerLevel
		end
		needed = ls.Level.Value * Config.XPPerLevelBase

		local remotes = ReplicatedStorage:FindFirstChild("Remotes")
		if remotes and remotes:FindFirstChild("Notify") then
			remotes.Notify:FireClient(player, "Success", "LEVEL UP! Level " .. ls.Level.Value .. " | Power +" .. Config.PowerPerLevel)
		end
	end
end

local function clearMorph(player: Player)
	local char = player.Character
	if not char then return end

	local aura = char:FindFirstChild("BrainrotAura")
	if aura then aura:Destroy() end
	local tag = char:FindFirstChild("BrainrotTag")
	if tag then tag:Destroy() end

	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		pcall(function()
			local function setScale(name, val)
				local obj = humanoid:FindFirstChild(name)
				if obj and obj:IsA("NumberValue") then obj.Value = val end
			end
			setScale("BodyDepthScale", 1)
			setScale("BodyHeightScale", 1)
			setScale("BodyWidthScale", 1)
			setScale("HeadScale", 1)
		end)
	end

	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.Color = Color3.fromRGB(163, 162, 165)
			part.Material = Enum.Material.Plastic
		end
	end
end

local function applyVisualMorph(player: Player, brainrotName: string, rarity: string)
	local char = player.Character
	if not char then return end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	clearMorph(player)

	local color = Config.MorphColors[rarity] or Color3.fromRGB(255, 255, 255)
	local scaleMul = Config.MorphScale[rarity] or 1.2

	pcall(function()
		local function setScale(name, val)
			local obj = humanoid:FindFirstChild(name)
			if obj and obj:IsA("NumberValue") then obj.Value = val end
		end
		setScale("BodyDepthScale", scaleMul)
		setScale("BodyHeightScale", scaleMul)
		setScale("BodyWidthScale", scaleMul)
		setScale("HeadScale", math.min(scaleMul * 1.15, 2.5))
	end)

	for _, part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.Color = color
			part.Material = Enum.Material.Neon
		end
	end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		local bb = Instance.new("BillboardGui")
		bb.Name = "BrainrotTag"
		bb.Size = UDim2.new(0, 200, 0, 50)
		bb.StudsOffset = Vector3.new(0, 3 + scaleMul, 0)
		bb.AlwaysOnTop = true
		bb.Parent = char

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = brainrotName
		label.TextColor3 = color
		label.TextStrokeTransparency = 0.3
		label.Font = Enum.Font.GothamBold
		label.TextScaled = true
		label.Parent = bb

		local attachment = Instance.new("Attachment")
		attachment.Name = "BrainrotAura"
		attachment.Parent = hrp

		local particles = Instance.new("ParticleEmitter")
		particles.Color = ColorSequence.new(color)
		particles.Size = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.8),
			NumberSequenceKeypoint.new(1, 0),
		})
		particles.Lifetime = NumberRange.new(0.6, 1.2)
		particles.Rate = 25 + (scaleMul * 15)
		particles.Speed = NumberRange.new(2, 5)
		particles.SpreadAngle = Vector2.new(360, 360)
		particles.LightEmission = 0.8
		particles.Parent = attachment
	end
end

function CombatService.Transform(player: Player, brainrotName: string?): (boolean, string)
	local now = os.time()
	local last = player:GetAttribute("LastTransform") or 0
	if now - last < Config.TransformCooldown then
		return false, "Transform on cooldown (" .. (Config.TransformCooldown - (now - last)) .. "s)"
	end

	if player:GetAttribute("IsTransformed") then
		player:SetAttribute("IsTransformed", false)
		player:SetAttribute("TransformBrainrot", nil)
		player:SetAttribute("TransformEnd", 0)
		player:SetAttribute("TransformPowerMulti", 1)
		clearMorph(player)
		return true, "De-transformed back to human"
	end

	local owned = player:FindFirstChild("OwnedBrainrots")
	if not owned then return false, "No brainrots owned" end

	local chosen = brainrotName
	if not chosen or not owned:FindFirstChild(chosen) then
		local bestName, bestIncome = nil, -1
		for _, v in ipairs(owned:GetChildren()) do
			local data = BrainrotData.Get(v.Name)
			if data and data.Income > bestIncome then
				bestIncome = data.Income
				bestName = v.Name
			end
		end
		chosen = bestName or Config.StarterBrainrot
	end

	if not owned:FindFirstChild(chosen) then
		return false, "You don't own that brainrot"
	end

	local data = BrainrotData.Get(chosen)
	if not data then return false, "Invalid brainrot" end

	player:SetAttribute("IsTransformed", true)
	player:SetAttribute("TransformBrainrot", chosen)
	player:SetAttribute("TransformEnd", now + Config.TransformDuration)
	player:SetAttribute("LastTransform", now)

	local multi = Config.TransformPowerMultiplier[data.Rarity] or 1.2
	player:SetAttribute("TransformPowerMulti", multi)

	applyVisualMorph(player, chosen, data.Rarity)

	return true, "TRANSFORMED into " .. chosen .. "! Power x" .. multi .. " for " .. Config.TransformDuration .. "s"
end

task.spawn(function()
	while true do
		task.wait(1)
		local now = os.time()
		for _, player in ipairs(Players:GetPlayers()) do
			if player:GetAttribute("IsTransformed") then
				local endTime = player:GetAttribute("TransformEnd") or 0
				if now >= endTime then
					player:SetAttribute("IsTransformed", false)
					player:SetAttribute("TransformBrainrot", nil)
					player:SetAttribute("TransformPowerMulti", 1)
					clearMorph(player)
					local remotes = ReplicatedStorage:FindFirstChild("Remotes")
					if remotes and remotes:FindFirstChild("Notify") then
						remotes.Notify:FireClient(player, "Error", "Transform ended. Farm more XP!")
					end
				end
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(1)
		for _, player in ipairs(Players:GetPlayers()) do
			if player:GetAttribute("IsTransformed") and player:GetAttribute("DataLoaded") then
				addXP(player, Config.PassiveXPPerSecond)
			end
		end
	end
end)

function CombatService.FarmXP(player: Player): (boolean, string)
	local now = os.time()
	local last = player:GetAttribute("LastFarm") or 0
	if now - last < Config.FarmCooldown then
		return false, "Farm on cooldown"
	end

	player:SetAttribute("LastFarm", now)

	local amount = Config.FarmXPAmount
	if player:GetAttribute("IsTransformed") then
		amount = math.floor(amount * 1.75)
	end

	addXP(player, amount)
	return true, "+" .. amount .. " XP farmed!"
end

function CombatService.Attack(attacker: Player, victimUserId: number): (boolean, string)
	if typeof(victimUserId) ~= "number" then return false, "Invalid target" end

	local victim = Players:GetPlayerByUserId(victimUserId)
	if not victim then return false, "Player not found" end
	if attacker == victim then return false, "Can't attack yourself" end

	local now = tick()
	local last = attacker:GetAttribute("LastAttack") or 0
	if now - last < Config.AttackCooldown then
		return false, "Attack on cooldown"
	end
	attacker:SetAttribute("LastAttack", now)

	local power = getPower(attacker)
	local multi = 1
	if attacker:GetAttribute("IsTransformed") then
		multi = attacker:GetAttribute("TransformPowerMulti") or 1
	end

	local damage = math.floor((Config.BaseDamage + power * Config.DamagePerPower) * multi)

	local char = victim.Character
	if not char then return false, "Victim has no character" end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return false, "Victim already dead" end

	humanoid:TakeDamage(damage)

	if humanoid.Health <= 0 then
		local streakBonus = 1
		pcall(function()
			streakBonus = getEventService().RegisterKill(attacker)
		end)
		pcall(function()
			getEventService().ResetKillstreak(victim)
		end)

		local aLS = getLeaderstats(attacker)
		local vLS = getLeaderstats(victim)

		local coinReward = math.floor(Config.KillTungCoinReward * streakBonus)
		if aLS and aLS:FindFirstChild("TungCoin") then
			aLS.TungCoin.Value += coinReward
		end
		addXP(attacker, math.floor(Config.KillXPReward * streakBonus))

		if aLS and aLS:FindFirstChild("Power") and vLS and vLS:FindFirstChild("Power") then
			local stolen = math.min(Config.KillPowerSteal, vLS.Power.Value)
			vLS.Power.Value = math.max(Config.StartingPower, vLS.Power.Value - stolen)
			aLS.Power.Value += stolen
		end

		if vLS and vLS:FindFirstChild("TungCoin") then
			local loss = math.floor(vLS.TungCoin.Value * Config.DeathTungCoinLossPercent)
			vLS.TungCoin.Value = math.max(0, vLS.TungCoin.Value - loss)
		end

		local remotes = ReplicatedStorage:FindFirstChild("Remotes")
		if remotes and remotes:FindFirstChild("Notify") then
			remotes.Notify:FireClient(attacker, "Success", "KILLED " .. victim.Name .. "! +" .. coinReward .. " TungCoins")
			remotes.Notify:FireClient(victim, "Error", attacker.Name .. " killed you!")
		end

		return true, "KILL! " .. victim.Name
	end

	return true, "Hit " .. victim.Name .. " for " .. damage .. " dmg"
end

function CombatService.GetStats(player: Player)
	return {
		XP = getLeaderstats(player) and getLeaderstats(player).XP and getLeaderstats(player).XP.Value or 0,
		Power = getPower(player),
		Level = getLevel(player),
		IsTransformed = player:GetAttribute("IsTransformed") or false,
		TransformBrainrot = player:GetAttribute("TransformBrainrot"),
	}
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(0.5)
		if player:GetAttribute("IsTransformed") then
			local name = player:GetAttribute("TransformBrainrot")
			local data = name and BrainrotData.Get(name)
			if data then
				applyVisualMorph(player, name, data.Rarity)
			end
		end
	end)
end)

return CombatService
