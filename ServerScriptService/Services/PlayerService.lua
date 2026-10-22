--!strict
local Players = game:GetService("Players")
local Config = require(script.Parent.Parent.Modules.Config)
local BrainrotData = require(script.Parent.Parent.Modules.BrainrotData)
local DataModule = require(script.Parent.Parent.Modules.DataStoreService)

local PlayerService = {}

local function setupPlayer(player: Player)
	local data = DataModule.Load(player)

	-- Leaderstats
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local cheese = Instance.new("IntValue")
	cheese.Name = "Cheese"
	cheese.Value = data.Cheese or Config.StartingCheese
	cheese.Parent = leaderstats

	local brainrots = Instance.new("IntValue")
	brainrots.Name = "Brainrots"
	brainrots.Value = #(data.OwnedBrainrots or {Config.StarterBrainrot})
	brainrots.Parent = leaderstats

	local rebirths = Instance.new("IntValue")
	rebirths.Name = "Rebirths"
	rebirths.Value = data.Rebirths or 0
	rebirths.Parent = leaderstats

	-- Owned brainrots folder
	local owned = Instance.new("Folder")
	owned.Name = "OwnedBrainrots"
	owned.Parent = player

	for _, name in ipairs(data.OwnedBrainrots or {Config.StarterBrainrot}) do
		local v = Instance.new("StringValue")
		v.Name = name
		v.Value = name
		v.Parent = owned
	end

	player:SetAttribute("LastSteal", data.LastSteal or 0)
	player:SetAttribute("DataLoaded", true)

	print(player.Name .. " loaded. Cheese: " .. cheese.Value .. " | Rebirths: " .. rebirths.Value)
end

Players.PlayerAdded:Connect(setupPlayer)

-- In case players are already in (Studio testing)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(setupPlayer, player)
end

return PlayerService
