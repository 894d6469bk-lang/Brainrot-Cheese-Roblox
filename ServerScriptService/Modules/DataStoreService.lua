--!strict
--[[
	Simple DataStore wrapper for saving player progress
	Now includes XP, Power, Level
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local DATA_STORE_NAME = "BrainrotCheese_v2"  -- bumped version for new stats
local playerStore = DataStoreService:GetDataStore(DATA_STORE_NAME)

local DataModule = {}

function DataModule.Load(player: Player)
	local success, data = pcall(function()
		return playerStore:GetAsync("Player_" .. player.UserId)
	end)

	if success and data then
		return data
	end

	-- Default data
	return {
		Cheese = 150,
		Rebirths = 0,
		OwnedBrainrots = {"Noobini Pizzanini"},
		LastSteal = 0,
		Level = 1,
		XP = 0,
		Power = 10,
	}
end

function DataModule.Save(player: Player, data)
	local success, err = pcall(function()
		playerStore:SetAsync("Player_" .. player.UserId, data)
	end)
	if not success then
		warn("Failed to save data for " .. player.Name .. ": " .. tostring(err))
	end
end

local function collectData(player: Player)
	local data = {
		Cheese = player.leaderstats and player.leaderstats.Cheese and player.leaderstats.Cheese.Value or 0,
		Rebirths = player.leaderstats and player.leaderstats.Rebirths and player.leaderstats.Rebirths.Value or 0,
		OwnedBrainrots = {},
		LastSteal = player:GetAttribute("LastSteal") or 0,
		Level = player.leaderstats and player.leaderstats.Level and player.leaderstats.Level.Value or 1,
		XP = player.leaderstats and player.leaderstats.XP and player.leaderstats.XP.Value or 0,
		Power = player.leaderstats and player.leaderstats.Power and player.leaderstats.Power.Value or 10,
	}
	local owned = player:FindFirstChild("OwnedBrainrots")
	if owned then
		for _, v in ipairs(owned:GetChildren()) do
			table.insert(data.OwnedBrainrots, v.Name)
		end
	end
	return data
end

-- Auto save every 60 seconds + on leave
task.spawn(function()
	while true do
		task.wait(60)
		for _, player in ipairs(Players:GetPlayers()) do
			if player:GetAttribute("DataLoaded") then
				DataModule.Save(player, collectData(player))
			end
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	if player:GetAttribute("DataLoaded") then
		DataModule.Save(player, collectData(player))
	end
end)

return DataModule
