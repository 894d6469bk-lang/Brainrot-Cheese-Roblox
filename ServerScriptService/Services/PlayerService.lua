--!strict
local Players = game:GetService("Players")
local Config = require(script.Parent.Parent.Modules.Config)
local DataModule = require(script.Parent.Parent.Modules.DataStoreService)

local PlayerService = {}

local function setupPlayer(player: Player)
	local data = DataModule.Load(player)

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local tung = Instance.new("IntValue")
	tung.Name = "TungCoin"
	tung.Value = data.TungCoin or Config.StartingTungCoin
	tung.Parent = leaderstats

	local brainrots = Instance.new("IntValue")
	brainrots.Name = "Brainrots"
	brainrots.Value = #(data.OwnedBrainrots or {Config.StarterBrainrot})
	brainrots.Parent = leaderstats

	local rebirths = Instance.new("IntValue")
	rebirths.Name = "Rebirths"
	rebirths.Value = data.Rebirths or 0
	rebirths.Parent = leaderstats

	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Value = data.Level or Config.StartingLevel
	level.Parent = leaderstats

	local xp = Instance.new("IntValue")
	xp.Name = "XP"
	xp.Value = data.XP or Config.StartingXP
	xp.Parent = leaderstats

	local power = Instance.new("IntValue")
	power.Name = "Power"
	power.Value = data.Power or Config.StartingPower
	power.Parent = leaderstats

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
	player:SetAttribute("IsTransformed", false)
	player:SetAttribute("TransformPowerMulti", 1)
	player:SetAttribute("DataLoaded", true)

	print(player.Name .. " loaded. TungCoin: " .. tung.Value .. " | Level: " .. level.Value .. " | Power: " .. power.Value)
end

Players.PlayerAdded:Connect(setupPlayer)
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(setupPlayer, player)
end

return PlayerService
