--!strict
--[[
	CombatService - Become a Brainrot, Farm XP/Power, Kill other players
	Viral PvP loop for maximum engagement
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(script.Parent.Parent.Modules.Config)
local BrainrotData = require(script.Parent.Parent.Modules.BrainrotData)

local CombatService = {}

-- Helpers
local function getLeaderstats(player: Player)
	return player:FindFirstChild("leaderstats")
end

local function getXP(player: Player): number
	local ls = getLeaderstats(player)
	return (ls and ls:FindFirstChild("XP") and ls.XP.Value) or 0
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

	ls.XP.Value += amount

	-- Level up check
	local needed = getLevel(player) * Config.XPPerLevelBase
	while ls.XP.Value >= needed do
		ls.XP.Value -= needed
		ls.Level.Value += 1
		if ls:FindFirstChild("Power") then
			ls.Power.Value += Config.PowerPerLevel
		end
		needed = ls.Level.Value * Config.XPPerLevelBase

		-- Fire notification via remote if exists
		local remotes = ReplicatedStorage:FindFirstChild("Remotes")
		if remotes and remotes:FindFirstChild("Notify") then
			remotes.Notify:FireClient(player, "Success", "LEVEL UP! Now Level " .. ls.Level.Value .. " | Power +" .. Config.PowerPerLevel)
		end
	end
end

-- ========== TRANSFORM INTO BRAINROT ==========
function CombatService.Transform(player: Player, brainrotName: string?): (boolean, string)
	local now = os.time()
	local last = player:GetAttribute("LastTransform") or 0
	if now - last < Config.TransformCooldown then
		return false, "Transform on cooldown (" .. (Config.TransformCooldown - (now - last)) .. "s)"
	end

	-- If already transformed, cancel
	if player:GetAttribute("IsTransformed") then
		player:SetAttribute("IsTransformed", false)
		player:SetAttribute("TransformBrainrot", nil)
		player:SetAttribute("TransformEnd", 0)
		player:SetAttribute("TransformPowerMulti", 1)
		return true, "De-transformed back to human"
	end

	local owned = player:FindFirstChild("OwnedBrainrots")
	if not owned then return false, "No brainrots owned" end

	-- Pick brainrot (requested or strongest owned)
	local chosen = brainrotName
	if not chosen or not owned:FindFirstChild(chosen) then
		-- Auto pick highest rarity / income
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

	return true, "TRANSFORMED into " .. chosen .. "! Power x" .. multi .. " for " .. Config.TransformDuration .. "s"
end

-- Auto de-transform when time ends
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

					local remotes = ReplicatedStorage:FindFirstChild("Remotes")
					if remotes and remotes:FindFirstChild("Notify") then
						remotes.Notify:FireClient(player, "Error", "Transform ended. Farm more XP!")
					end
				end
			end
		end
	end
end)

-- Passive XP while transformed
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

-- ========== FARM XP ==========
function CombatService.FarmXP(player: Player): (boolean, string)
	local now = os.time()
	local last = player:GetAttribute("LastFarm") or 0
	if now - last < Config.FarmCooldown then
		return false, "Farm on cooldown"
	end

	player:SetAttribute("LastFarm", now)

	local amount = Config.FarmXPAmount
	if player:GetAttribute("IsTransformed") then
		amount = math.floor(amount * 1.75) -- bonus while transformed
	end

	addXP(player, amount)
	return true, "+" .. amount .. " XP farmed!"
end

-- ========== ATTACK / KILL ==========
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

	-- Calculate damage
	local power = getPower(attacker)
	local multi = 1
	if attacker:GetAttribute("IsTransformed") then
		multi = attacker:GetAttribute("TransformPowerMulti") or 1
	end

	local damage = math.floor((Config.BaseDamage + power * Config.DamagePerPower) * multi)

	-- Apply damage via Humanoid
	local char = victim.Character
	if not char then return false, "Victim has no character" end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then return false, "Victim already dead" end

	humanoid:TakeDamage(damage)

	-- Check if kill
	if humanoid.Health <= 0 then
		-- REWARDS
		local aLS = getLeaderstats(attacker)
		local vLS = getLeaderstats(victim)

		if aLS and aLS:FindFirstChild("Cheese") then
			aLS.Cheese.Value += Config.KillCheeseReward
		end
		addXP(attacker, Config.KillXPReward)

		if aLS and aLS:FindFirstChild("Power") and vLS and vLS:FindFirstChild("Power") then
			local stolen = math.min(Config.KillPowerSteal, vLS.Power.Value)
			vLS.Power.Value = math.max(Config.StartingPower, vLS.Power.Value - stolen)
			aLS.Power.Value += stolen
		end

		-- Victim loses some cheese
		if vLS and vLS:FindFirstChild("Cheese") then
			local loss = math.floor(vLS.Cheese.Value * Config.DeathCheeseLossPercent)
			vLS.Cheese.Value = math.max(0, vLS.Cheese.Value - loss)
		end

		local remotes = ReplicatedStorage:FindFirstChild("Remotes")
		if remotes and remotes:FindFirstChild("Notify") then
			remotes.Notify:FireClient(attacker, "Success", "KILLED " .. victim.Name .. "! +" .. Config.KillCheeseReward .. " Cheese +" .. Config.KillXPReward .. " XP")
			remotes.Notify:FireClient(victim, "Error", attacker.Name .. " killed you! Lost some cheese...")
		end

		return true, "KILL! You destroyed " .. victim.Name
	end

	return true, "Hit " .. victim.Name .. " for " .. damage .. " damage! (HP left: " .. math.floor(humanoid.Health) .. ")"
end

-- Get current combat stats for UI
function CombatService.GetStats(player: Player)
	return {
		XP = getXP(player),
		Power = getPower(player),
		Level = getLevel(player),
		IsTransformed = player:GetAttribute("IsTransformed") or false,
		TransformBrainrot = player:GetAttribute("TransformBrainrot"),
		TransformEnd = player:GetAttribute("TransformEnd") or 0,
	}
end

return CombatService
