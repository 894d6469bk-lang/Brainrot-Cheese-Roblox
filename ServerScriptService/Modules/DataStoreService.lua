--!strict
--[[
	DataStore - Tung Tung Sahur Coin economy + combat stats
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local DATA_STORE_NAME = "BrainrotTung_v1"
local playerStore = DataStoreService:GetDataStore(DATA_STORE_NAME)

local DataModule = {}

function DataModule.Load(player: Player)
	local success, data = pcall(function()
		return playerStore:GetAsync("Player_" .. player.UserId)
	end)

	if success and data then
		-- migrate old Cheese field if present
		if data.Cheese and not data.TungCoin then
			data.TungCoin = data.Cheese
		end
		return data
	end

	return {
		TungCoin = 150,
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
	local ls = player:FindFirstChild("leaderstats")
	local data = {
		TungCoin = ls and ls:FindFirstChild("TungCoin") and ls.TungCoin.Value or 0,
		Rebirths = ls and ls:FindFirstChild("Rebirths") and ls.Rebirths.Value or 0,
		OwnedBrainrots = {},
		LastSteal = player:GetAttribute("LastSteal") or 0,
		Level = ls and ls:FindFirstChild("Level") and ls.Level.Value or 1,
		XP = ls and ls:FindFirstChild("XP") and ls.XP.Value or 0,
		Power = ls and ls:FindFirstChild("Power") and ls.Power.Value or 10,
	}
	local owned = player:FindFirstChild("OwnedBrainrots")
	if owned then
		for _, v in ipairs(owned:GetChildren()) do
			table.insert(data.OwnedBrainrots, v.Name)
		end
	end
	return data
end

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
