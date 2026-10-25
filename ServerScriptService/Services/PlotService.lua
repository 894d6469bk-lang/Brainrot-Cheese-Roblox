--!strict
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local PlotService = {}
local owned: {[number]: number} = {}

function PlotService.Claim(player: Player, plotId: number): (boolean, string)
	if typeof(plotId) ~= "number" or plotId < 1 or plotId > 8 then
		return false, "Invalid plot"
	end

	for id, uid in pairs(owned) do
		if uid == player.UserId and id ~= plotId then
			owned[id] = nil
		end
	end

	local cur = owned[plotId]
	if cur and cur ~= player.UserId then
		local owner = Players:GetPlayerByUserId(cur)
		return false, owner and ("Owned by " .. owner.Name) or "Plot taken"
	end

	owned[plotId] = player.UserId
	player:SetAttribute("PlotId", plotId)

	local map = Workspace:FindFirstChild("BrainrotMap")
	if map then
		local folder = map:FindFirstChild("Plot_" .. plotId)
		local pad = folder and folder:FindFirstChild("ClaimPad")
		if pad and pad:IsA("BasePart") then
			pad.Color = Color3.fromRGB(255, 200, 40)
		end
	end

	return true, "Claimed Plot " .. plotId .. "!"
end

Players.PlayerRemoving:Connect(function(player)
	local pid = player:GetAttribute("PlotId")
	if pid and owned[pid] == player.UserId then
		owned[pid] = nil
		local map = Workspace:FindFirstChild("BrainrotMap")
		local folder = map and map:FindFirstChild("Plot_" .. pid)
		local pad = folder and folder:FindFirstChild("ClaimPad")
		if pad and pad:IsA("BasePart") then
			pad.Color = Color3.fromRGB(0, 255, 170)
		end
	end
end)

return PlotService
