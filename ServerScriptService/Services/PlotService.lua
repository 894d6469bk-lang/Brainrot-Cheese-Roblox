--!strict
--[[
	Plot claiming - stand on ClaimPad and take a base
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotService = {}

-- plotId -> userId
local ownedPlots: {[number]: number} = {}

local function getNotify()
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	if remotes then return remotes:FindFirstChild("Notify") end
	return nil
end

function PlotService.Claim(player: Player, plotId: number): (boolean, string)
	if typeof(plotId) ~= "number" then return false, "Invalid plot" end
	if plotId < 1 or plotId > 8 then return false, "Plot does not exist" end

	-- already owns a plot?
	for id, uid in pairs(ownedPlots) do
		if uid == player.UserId then
			if id == plotId then
				return false, "You already own this plot"
			end
			-- release old
			ownedPlots[id] = nil
		end
	end

	local current = ownedPlots[plotId]
	if current and current ~= player.UserId then
		local owner = Players:GetPlayerByUserId(current)
		if owner then
			return false, "Plot owned by " .. owner.Name
		end
	end

	ownedPlots[plotId] = player.UserId
	player:SetAttribute("PlotId", plotId)

	-- visual: color the claim pad
	local map = Workspace:FindFirstChild("BrainrotMap")
	if map then
		local plotFolder = map:FindFirstChild("Plot_" .. plotId)
		if plotFolder then
			local pad = plotFolder:FindFirstChild("ClaimPad")
			if pad and pad:IsA("BasePart") then
				pad.Color = Color3.fromRGB(255, 200, 50)
			end
		end
	end

	return true, "Claimed Plot " .. plotId .. "! This is your base."
end

function PlotService.GetOwner(plotId: number): number?
	return ownedPlots[plotId]
end

Players.PlayerRemoving:Connect(function(player)
	local pid = player:GetAttribute("PlotId")
	if pid and ownedPlots[pid] == player.UserId then
		ownedPlots[pid] = nil
		local map = Workspace:FindFirstChild("BrainrotMap")
		if map then
			local plotFolder = map:FindFirstChild("Plot_" .. pid)
			if plotFolder then
				local pad = plotFolder:FindFirstChild("ClaimPad")
				if pad and pad:IsA("BasePart") then
					pad.Color = Color3.fromRGB(0, 255, 180)
				end
			end
		end
	end
end)

print("PlotService ready")
return PlotService
