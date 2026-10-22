--!strict
--[[
	PlayerService.lua
	Handles leaderstats, starting cheese, and basic player setup
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(script.Parent.Parent.Modules.Config)
local BrainrotData = require(script.Parent.Parent.Modules.BrainrotData)

local PlayerService = {}

local function setupLeaderstats(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local cheese = Instance.new("IntValue")
	cheese.Name = "Cheese"
	cheese.Value = Config.StartingCheese
	cheese.Parent = leaderstats

	local brainrots = Instance.new("IntValue")
	brainrots.Name = "Brainrots"
	brainrots.Value = 1
	brainrots.Parent = leaderstats
end

local function giveStarterBrainrot(player: Player)
	-- Store owned brainrots in a folder under player
	local owned = Instance.new("Folder")
	owned.Name = "OwnedBrainrots"
	owned.Parent = player

	local starter = Instance.new("StringValue")
	starter.Name = Config.StarterBrainrot
	starter.Value = Config.StarterBrainrot
	starter.Parent = owned
end

Players.PlayerAdded:Connect(function(player)
	setupLeaderstats(player)
	giveStarterBrainrot(player)
	print(player.Name .. " joined the brainrot. Welcome to the cheese.")
end)

return PlayerService
