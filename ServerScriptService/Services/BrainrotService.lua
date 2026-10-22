--!strict
--[[
	BrainrotService.lua
	Handles income generation from owned brainrots
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Config = require(script.Parent.Parent.Modules.Config)
local BrainrotData = require(script.Parent.Parent.Modules.BrainrotData)

local BrainrotService = {}

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
	return total
end

-- Simple income loop every second
task.spawn(function()
	while true do
		task.wait(Config.BaseIncomeTick)
		for _, player in ipairs(Players:GetPlayers()) do
			local leaderstats = player:FindFirstChild("leaderstats")
			if leaderstats then
				local cheese = leaderstats:FindFirstChild("Cheese")
				if cheese then
					local income = getPlayerIncome(player)
					-- TODO: apply 2x Game Pass multiplier here
					cheese.Value += income
				end
			end
		end
	end
end)

-- Buy brainrot function (can be called from RemoteEvent later)
function BrainrotService.BuyBrainrot(player: Player, brainrotName: string): boolean
	local data = BrainrotData.Get(brainrotName)
	if not data then return false end

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return false end
	local cheese = leaderstats:FindFirstChild("Cheese")
	if not cheese or cheese.Value < data.Price then return false end

	local owned = player:FindFirstChild("OwnedBrainrots")
	if not owned then return false end

	-- Already own it?
	if owned:FindFirstChild(brainrotName) then return false end

	cheese.Value -= data.Price

	local newBrainrot = Instance.new("StringValue")
	newBrainrot.Name = brainrotName
	newBrainrot.Value = brainrotName
	newBrainrot.Parent = owned

	local brainrotsStat = leaderstats:FindFirstChild("Brainrots")
	if brainrotsStat then
		brainrotsStat.Value += 1
	end

	print(player.Name .. " just bought " .. brainrotName .. "! More cheese incoming.")
	return true
end

return BrainrotService
