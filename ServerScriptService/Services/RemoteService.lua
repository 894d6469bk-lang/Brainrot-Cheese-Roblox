--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BrainrotService = require(script.Parent.BrainrotService)
local CombatService = require(script.Parent.CombatService)
local BrainrotData = require(script.Parent.Parent.Modules.BrainrotData)

-- Create Remotes folder if missing
local remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not remotes then
	remotes = Instance.new("Folder")
	remotes.Name = "Remotes"
	remotes.Parent = ReplicatedStorage
end

local function getOrCreateRemote(name: string)
	local r = remotes:FindFirstChild(name)
	if not r then
		r = Instance.new("RemoteEvent")
		r.Name = name
		r.Parent = remotes
	end
	return r
end

local BuyBrainrotRE = getOrCreateRemote("BuyBrainrot")
local RebirthRE = getOrCreateRemote("Rebirth")
local StealRE = getOrCreateRemote("Steal")
local GetShopDataRE = getOrCreateRemote("GetShopData")
local NotifyRE = getOrCreateRemote("Notify")

-- NEW combat remotes
local TransformRE = getOrCreateRemote("Transform")
local FarmXPRE = getOrCreateRemote("FarmXP")
local AttackRE = getOrCreateRemote("Attack")
local GetCombatStatsRE = getOrCreateRemote("GetCombatStats")

-- Buy
BuyBrainrotRE.OnServerEvent:Connect(function(player, brainrotName)
	if typeof(brainrotName) ~= "string" then return end
	local success, msg = BrainrotService.BuyBrainrot(player, brainrotName)
	NotifyRE:FireClient(player, success and "Success" or "Error", msg)
end)

-- Rebirth
RebirthRE.OnServerEvent:Connect(function(player)
	local success, msg = BrainrotService.DoRebirth(player)
	NotifyRE:FireClient(player, success and "Success" or "Error", msg)
end)

-- Steal (player clicks another player)
StealRE.OnServerEvent:Connect(function(player, victimUserId)
	if typeof(victimUserId) ~= "number" then return end
	local victim = Players:GetPlayerByUserId(victimUserId)
	if not victim then
		NotifyRE:FireClient(player, "Error", "Player not found")
		return
	end
	local success, msg = BrainrotService.TrySteal(player, victim)
	NotifyRE:FireClient(player, success and "Success" or "Error", msg)
	if success then
		NotifyRE:FireClient(victim, "Error", player.Name .. " stole one of your brainrots!")
	end
end)

-- Shop data request
GetShopDataRE.OnServerEvent:Connect(function(player)
	GetShopDataRE:FireClient(player, BrainrotData.GetSortedByPrice())
end)

-- ========== COMBAT REMOTES ==========
TransformRE.OnServerEvent:Connect(function(player, brainrotName)
	local success, msg = CombatService.Transform(player, brainrotName)
	NotifyRE:FireClient(player, success and "Success" or "Error", msg)
end)

FarmXPRE.OnServerEvent:Connect(function(player)
	local success, msg = CombatService.FarmXP(player)
	NotifyRE:FireClient(player, success and "Success" or "Error", msg)
end)

AttackRE.OnServerEvent:Connect(function(player, victimUserId)
	if typeof(victimUserId) ~= "number" then return end
	local success, msg = CombatService.Attack(player, victimUserId)
	NotifyRE:FireClient(player, success and "Success" or "Error", msg)
end)

GetCombatStatsRE.OnServerEvent:Connect(function(player)
	GetCombatStatsRE:FireClient(player, CombatService.GetStats(player))
end)

print("RemoteService ready - all events created (including Combat)")
