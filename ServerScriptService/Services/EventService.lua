--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(script.Parent.Parent.Modules.Config)

local EventService = {}

local luckyActive = false
local luckyEnd = 0

local function broadcast(msg: string)
	local remotes = ReplicatedStorage:FindFirstChild("Remotes")
	local n = remotes and remotes:FindFirstChild("Notify")
	if not n then return end
	for _, p in ipairs(Players:GetPlayers()) do
		n:FireClient(p, "Success", msg)
	end
end

function EventService.IsLuckyActive(): boolean
	return luckyActive and os.time() < luckyEnd
end

function EventService.GetIncomeMulti(): number
	return EventService.IsLuckyActive() and Config.LuckyEventIncomeMulti or 1
end

function EventService.GetXPMulti(): number
	return EventService.IsLuckyActive() and Config.LuckyEventXPMulti or 1
end

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
		local remotes = ReplicatedStorage:FindFirstChild("Remotes")
		local n = remotes and remotes:FindFirstChild("Notify")
		if n then
			n:FireClient(player, "Success", "KILLSTREAK x" .. streak .. "!")
		end
	end
	return bonus
end

function EventService.ResetKillstreak(player: Player)
	player:SetAttribute("Killstreak", 0)
end

task.spawn(function()
	while true do
		task.wait(Config.LuckyEventIntervalSeconds)
		if #Players:GetPlayers() == 0 then continue end
		luckyActive = true
		luckyEnd = os.time() + Config.LuckyEventDuration
		broadcast("LUCKY EVENT! x3 TungCoins + x2 XP for " .. Config.LuckyEventDuration .. "s!")
		task.wait(Config.LuckyEventDuration)
		luckyActive = false
		broadcast("Lucky event over.")
	end
end)

return EventService
