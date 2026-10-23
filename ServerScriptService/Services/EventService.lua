--!strict
--[[
	Lucky server events + killstreak tracking
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(script.Parent.Parent.Modules.Config)

local EventService = {}

local luckyActive = false
local luckyEndTime = 0

local function getNotify()
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	if remotes then return remotes:FindFirstChild("Notify") end
	return nil
end

local function broadcast(msg: string)
	local n = getNotify()
	if not n then return end
	for _, p in ipairs(Players:GetPlayers()) do
		n:FireClient(p, "Success", msg)
	end
end

function EventService.IsLuckyActive(): boolean
	return luckyActive and os.time() < luckyEndTime
end

function EventService.GetIncomeMulti(): number
	if EventService.IsLuckyActive() then
		return Config.LuckyEventIncomeMulti
	end
	return 1
end

function EventService.GetXPMulti(): number
	if EventService.IsLuckyActive() then
		return Config.LuckyEventXPMulti
	end
	return 1
end

-- Killstreak
function EventService.RegisterKill(player: Player): number
	local now = os.time()
	local last = player:GetAttribute("LastKillTime") or 0
	local streak = player:GetAttribute("Killstreak") or 0

	if now - last <= Config.KillstreakTimeout then
		streak += 1
	else
		streak = 1
	end

	player:SetAttribute("Killstreak", streak)
	player:SetAttribute("LastKillTime", now)

	local bonus = math.min(1 + (streak - 1) * Config.KillstreakBonusPerKill, Config.KillstreakMaxBonus)

	if streak >= 3 then
		local n = getNotify()
		if n then
			n:FireClient(player, "Success", "KILLSTREAK x" .. streak .. "! Bonus x" .. string.format("%.1f", bonus))
		end
	end

	return bonus
end

function EventService.ResetKillstreak(player: Player)
	player:SetAttribute("Killstreak", 0)
end

-- Lucky event loop
task.spawn(function()
	while true do
		task.wait(Config.LuckyEventIntervalSeconds)
		if #Players:GetPlayers() == 0 then continue end

		luckyActive = true
		luckyEndTime = os.time() + Config.LuckyEventDuration
		broadcast("LUCKY EVENT! x" .. Config.LuckyEventIncomeMulti .. " TungCoins + x" .. Config.LuckyEventXPMulti .. " XP for " .. Config.LuckyEventDuration .. "s!")

		task.wait(Config.LuckyEventDuration)
		luckyActive = false
		broadcast("Lucky event ended. Next one soon...")
	end
end)

print("EventService ready (Lucky Events + Killstreak)")
return EventService
