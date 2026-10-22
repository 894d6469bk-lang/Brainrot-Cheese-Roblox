--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(script.Parent.Parent.Modules.Config)
local BrainrotData = require(script.Parent.Parent.Modules.BrainrotData)

local BrainrotService = {}

local function getIncomeMultiplier(player: Player): number
	local rebirths = player.leaderstats and player.leaderstats.Rebirths and player.leaderstats.Rebirths.Value or 0
	local multi = 1 + (rebirths * Config.RebirthMultiplierPerLevel)

	-- Check DoubleCheese Game Pass later
	return multi
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

-- Income loop
task.spawn(function()
	while true do
		task.wait(Config.BaseIncomeTick)
		for _, player in ipairs(Players:GetPlayers()) do
			if player:GetAttribute("DataLoaded") then
				local leaderstats = player:FindFirstChild("leaderstats")
				if leaderstats and leaderstats:FindFirstChild("Cheese") then
					leaderstats.Cheese.Value += getPlayerIncome(player)
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
	local cheese = leaderstats:FindFirstChild("Cheese")
	if not cheese or cheese.Value < data.Price then return false, "Not enough Cheese" end

	local owned = player:FindFirstChild("OwnedBrainrots")
	if not owned then return false, "No owned folder" end
	if owned:FindFirstChild(brainrotName) then return false, "Already own this" end

	cheese.Value -= data.Price

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

	local cheese = leaderstats.Cheese
	if cheese.Value < Config.RebirthRequirement then
		return false, "Need at least " .. Config.RebirthRequirement .. " Cheese to rebirth"
	end

	-- Reset cheese and owned (keep only starter)
	cheese.Value = Config.StartingCheese
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

-- Steal logic
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

	-- Random chance
	if math.random() > Config.StealSuccessChance then
		thief:SetAttribute("LastSteal", now)
		return false, "Steal failed! Cooldown started."
	end

	-- Pick a random non-starter brainrot from victim
	local candidates = {}
	for _, v in ipairs(victimOwned:GetChildren()) do
		if v.Name ~= Config.StarterBrainrot then
			table.insert(candidates, v)
		end
	end
	if #candidates == 0 then return false, "Nothing to steal" end

	local chosen = candidates[math.random(1, #candidates)]
	local name = chosen.Name

	-- Remove from victim
	chosen:Destroy()
	victim.leaderstats.Brainrots.Value = #victimOwned:GetChildren()

	-- Give to thief
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
