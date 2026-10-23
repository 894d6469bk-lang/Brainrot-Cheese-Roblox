--!strict
--[[
	Adds ProximityPrompts to Farm pads and Claim pads after map builds
]]

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CombatService = require(script.Parent.CombatService)
local PlotService = require(script.Parent.PlotService)
local EventService = require(script.Parent.EventService)
local Config = require(script.Parent.Parent.Modules.Config)

local ProximityService = {}

local function getNotify()
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	if remotes then return remotes:FindFirstChild("Notify") end
	return nil
end

local function setup()
	local map = Workspace:WaitForChild("BrainrotMap", 15)
	if not map then
		warn("ProximityService: BrainrotMap not found")
		return
	end

	-- Farm pads
	for _, obj in ipairs(map:GetDescendants()) do
		if obj:IsA("BasePart") and obj:GetAttribute("IsFarmPad") then
			local existing = obj:FindFirstChildOfClass("ProximityPrompt")
			if existing then existing:Destroy() end

			local prompt = Instance.new("ProximityPrompt")
			prompt.ActionText = "Farm XP"
			prompt.ObjectText = "XP Pad"
			prompt.HoldDuration = 0.3
			prompt.MaxActivationDistance = 12
			prompt.RequiresLineOfSight = false
			prompt.Parent = obj

			prompt.Triggered:Connect(function(player)
				local multi = EventService.GetXPMulti()
				local success, msg = CombatService.FarmXP(player)
				-- extra pad bonus
				if success then
					local ls = player:FindFirstChild("leaderstats")
					if ls and ls:FindFirstChild("XP") then
						local bonus = math.floor(Config.FarmPadBonusXP * multi)
						ls.XP.Value += bonus
					end
				end
				local n = getNotify()
				if n then
					n:FireClient(player, success and "Success" or "Error", msg .. (success and " (+pad bonus)" or ""))
				end
			end)
		end
	end

	-- Claim pads
	for i = 1, 8 do
		local plotFolder = map:FindFirstChild("Plot_" .. i)
		if plotFolder then
			local pad = plotFolder:FindFirstChild("ClaimPad")
			if pad and pad:IsA("BasePart") then
				local existing = pad:FindFirstChildOfClass("ProximityPrompt")
				if existing then existing:Destroy() end

				local prompt = Instance.new("ProximityPrompt")
				prompt.ActionText = "Claim Base"
				prompt.ObjectText = "Plot " .. i
				prompt.HoldDuration = 0.5
				prompt.MaxActivationDistance = 10
				prompt.RequiresLineOfSight = false
				prompt.Parent = pad

				local plotId = i
				prompt.Triggered:Connect(function(player)
					local success, msg = PlotService.Claim(player, plotId)
					local n = getNotify()
					if n then
						n:FireClient(player, success and "Success" or "Error", msg)
					end
				end)
			end
		end
	end

	print("ProximityService ready - Farm + Claim prompts live")
end

task.spawn(setup)

return ProximityService
