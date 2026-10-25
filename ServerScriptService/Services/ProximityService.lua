--!strict
--[[
	Reliable E-key prompts on Farm + Claim pads
]]

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(script.Parent.Parent.Modules.Config)

local ProximityService = {}

local function notify(player: Player, ok: boolean, msg: string)
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	if not remotes then return end
	local n = remotes:FindFirstChild("Notify")
	if n then
		n:FireClient(player, ok and "Success" or "Error", msg)
	end
end

local function setup()
	local map = Workspace:WaitForChild("BrainrotMap", 20)
	if not map then
		warn("[ProximityService] No BrainrotMap")
		return
	end

	-- Wait a frame so other services exist
	task.wait(0.5)

	local CombatService = require(script.Parent.CombatService)
	local PlotService = require(script.Parent.PlotService)
	local EventService = require(script.Parent.EventService)

	-- Farm pads
	for _, obj in ipairs(map:GetDescendants()) do
		if obj:IsA("BasePart") and obj:GetAttribute("IsFarmPad") == true then
			local old = obj:FindFirstChildOfClass("ProximityPrompt")
			if old then old:Destroy() end

			local prompt = Instance.new("ProximityPrompt")
			prompt.Name = "FarmPrompt"
			prompt.ActionText = "Farm XP"
			prompt.ObjectText = "XP Pad"
			prompt.KeyboardKeyCode = Enum.KeyCode.E
			prompt.HoldDuration = 0
			prompt.MaxActivationDistance = 14
			prompt.RequiresLineOfSight = false
			prompt.Style = Enum.ProximityPromptStyle.Default
			prompt.Parent = obj

			prompt.Triggered:Connect(function(player: Player)
				local ok, msg = CombatService.FarmXP(player)
				if ok then
					local multi = EventService.GetXPMulti()
					local bonus = math.floor(Config.FarmPadBonusXP * multi)
					local ls = player:FindFirstChild("leaderstats")
					if ls and ls:FindFirstChild("XP") then
						ls.XP.Value += bonus
					end
					notify(player, true, msg .. " (+" .. bonus .. " pad bonus)")
				else
					notify(player, false, msg)
				end
			end)
		end
	end

	-- Claim pads
	for i = 1, 8 do
		local folder = map:FindFirstChild("Plot_" .. i)
		if not folder then continue end
		local pad = folder:FindFirstChild("ClaimPad")
		if not pad or not pad:IsA("BasePart") then continue end

		local old = pad:FindFirstChildOfClass("ProximityPrompt")
		if old then old:Destroy() end

		local prompt = Instance.new("ProximityPrompt")
		prompt.Name = "ClaimPrompt"
		prompt.ActionText = "Claim Base"
		prompt.ObjectText = "Plot " .. i
		prompt.KeyboardKeyCode = Enum.KeyCode.E
		prompt.HoldDuration = 0.4
		prompt.MaxActivationDistance = 12
		prompt.RequiresLineOfSight = false
		prompt.Parent = pad

		local plotId = i
		prompt.Triggered:Connect(function(player: Player)
			local ok, msg = PlotService.Claim(player, plotId)
			notify(player, ok, msg)
		end)
	end

	print("[ProximityService] E prompts ready on Farm + Claim pads")
end

task.defer(setup)

return ProximityService
