--!strict
local Players = game:GetService("Players")

local Config = require(script.Parent.Parent.Modules.Config)
local BrainrotData = require(script.Parent.Parent.Modules.BrainrotData)

local BrainrotService = {}

local function getIncomeMultiplier(player: Player): number
	local rebirths = player.leaderstats and player.leaderstats.Rebirths and player.leaderstats.Rebirths.Value or 0
	return 1 + (rebirths * Config.RebirthMultiplierPerLevel)
end

local function getPlayerIncome(player: Player): number
	local owned = player:FindFirstChild("OwnedBrainrots")
	if not owned then return 0 end

	local total = 0
	for _, brainrotValue in ipairs(owned:GetChildren()) do
		local data = BrainrotData.Get(brainrotValue.Name)
		if data then
			total += data.Income
		end
	end
	return math.floor(total * getIncomeMultiplier(player))
end

task.spawn(function()
	while true do
		task.wait(Config.BaseIncomeTick)
		for _, player in ipairs(Players:GetPlayers()) do
			if player:GetAttribute("DataLoaded") then
				local leaderstats = player:FindFirstChild("leaderstats")
				if leaderstats and leaderstats:FindFirstChild("TungCoin") then
					leaderstats.TungCoin.Value += getPlayerIncome(player)
				end
			end
		end
	end
end)

function BrainrotService.BuyBrainrot(player: Player, brainrotName: string): (boolean, string)
	local data = BrainrotData.Get(brainrotName)
	if not data then return false, "Invalid brainrot" end
	if data.Price <= 0 and brainrotName ~= Config.StarterBrainrot then return false, "Cannot buy this" end

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return false, "No stats" end
	local tung = leaderstats:FindFirstChild("TungCoin")
	if not tung or tung.Value < data.Price then return false, "Not enough Tung Tung Sahur Coins" end

	local owned = player:FindFirstChild("OwnedBrainrots")
	if not owned then return false, "No owned folder" end
	if owned:FindFirstChild(brainrotName) then return false, "Already own this" end

	tung.Value -= data.Price

	local new = Instance.new("StringValue")
	new.Name = brainrotName
	new.Value = brainrotName
	new.Parent = owned

	leaderstats.Brainrots.Value = #owned:GetChildren()

	return true, "Bought " .. brainrotName .. "!"
end

function BrainrotService.DoRebirth(player: Player): (boolean, string)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return false, "No stats" end

	local tung = leaderstats.TungCoin
	if tung.Value < Config.RebirthRequirement then
		return false, "Need at least " .. Config.RebirthRequirement .. " TungCoins to rebirth"
	end

	tung.Value = Config.StartingTungCoin
	leaderstats.Rebirths.Value += 1

	local owned = player:FindFirstChild("OwnedBrainrots")
	if owned then
		for _, v in ipairs(owned:GetChildren()) do
			v:Destroy()
		end
		local starter = Instance.new("StringValue")
		starter.Name = Config.StarterBrainrot
		starter.Value = Config.StarterBrainrot
		starter.Parent = owned
	end

	leaderstats.Brainrots.Value = 1

	return true, "Rebirth successful! Multiplier is now x" .. string.format("%.2f", 1 + leaderstats.Rebirths.Value * Config.RebirthMultiplierPerLevel)
end

function BrainrotService.TrySteal(thief: Player, victim: Player): (boolean, string)
	if thief == victim then return false, "Can't steal from yourself" end

	local now = os.time()
	local last = thief:GetAttribute("LastSteal") or 0
	if now - last < Config.StealCooldown then
		return false, "Steal on cooldown (" .. (Config.StealCooldown - (now - last)) .. "s)"
	end

	local victimOwned = victim:FindFirstChild("OwnedBrainrots")
	if not victimOwned or #victimOwned:GetChildren() <= 1 then
		return false, "Victim has nothing worth stealing"
	end

	if math.random() > Config.StealSuccessChance then
		thief:SetAttribute("LastSteal", now)
		return false, "Steal failed! Cooldown started."
	end

	local candidates = {}
	for _, v in ipairs(victimOwned:GetChildren()) do
		if v.Name ~= Config.StarterBrainrot then
			table.insert(candidates, v)
		end
	end
	if #candidates == 0 then return false, "Nothing to steal" end

	local chosen = candidates[math.random(1, #candidates)]
	local name = chosen.Name

	chosen:Destroy()
	victim.leaderstats.Brainrots.Value = #victimOwned:GetChildren()

	local thiefOwned = thief:FindFirstChild("OwnedBrainrots")
	if thiefOwned and not thiefOwned:FindFirstChild(name) then
		local new = Instance.new("StringValue")
		new.Name = name
		new.Value = name
		new.Parent = thiefOwned
		thief.leaderstats.Brainrots.Value = #thiefOwned:GetChildren()
	end

	thief:SetAttribute("LastSteal", now)
	return true, "Successfully stole " .. name .. "!"
end

return BrainrotService
