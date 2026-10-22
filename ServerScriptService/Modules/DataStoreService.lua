--!strict
--[[
	Simple DataStore wrapper for saving player progress
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local DATA_STORE_NAME = "BrainrotCheese_v1"
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
		Cheese = 100,
		Rebirths = 0,
		OwnedBrainrots = {"Noobini Pizzanini"},
		LastSteal = 0,
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

-- Auto save every 60 seconds + on leave
task.spawn(function()
	while true do
		task.wait(60)
		for _, player in ipairs(Players:GetPlayers()) do
			if player:GetAttribute("DataLoaded") then
				local data = {
					Cheese = player.leaderstats.Cheese.Value,
					Rebirths = player.leaderstats.Rebirths.Value,
					OwnedBrainrots = {},
					LastSteal = player:GetAttribute("LastSteal") or 0,
				}
				local owned = player:FindFirstChild("OwnedBrainrots")
				if owned then
					for _, v in ipairs(owned:GetChildren()) do
						table.insert(data.OwnedBrainrots, v.Name)
					end
				end
				DataModule.Save(player, data)
			end
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	if player:GetAttribute("DataLoaded") then
		local data = {
			Cheese = player.leaderstats and player.leaderstats.Cheese and player.leaderstats.Cheese.Value or 0,
			Rebirths = player.leaderstats and player.leaderstats.Rebirths and player.leaderstats.Rebirths.Value or 0,
			OwnedBrainrots = {},
			LastSteal = player:GetAttribute("LastSteal") or 0,
		}
		local owned = player:FindFirstChild("OwnedBrainrots")
		if owned then
			for _, v in ipairs(owned:GetChildren()) do
				table.insert(data.OwnedBrainrots, v.Name)
			end
		end
		DataModule.Save(player, data)
	end
end)

return DataModule
