--!strict
--[[
	Clean, visible UI - always on screen
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild("Remotes", 15)
if not remotes then
	warn("[ClientUI] No Remotes")
	return
end

local function RE(name: string): RemoteEvent
	return remotes:WaitForChild(name) :: RemoteEvent
end

local BuyRE = RE("BuyBrainrot")
local RebirthRE = RE("Rebirth")
local GetShopRE = RE("GetShopData")
local NotifyRE = RE("Notify")
local TransformRE = RE("Transform")
local FarmRE = RE("FarmXP")
local AttackRE = RE("Attack")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(300, 460)
panel.Position = UDim2.new(1, -320, 0.5, -230)
panel.BackgroundColor3 = Color3.fromRGB(16, 14, 26)
panel.BorderSizePixel = 0
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

local border = Instance.new("UIStroke")
border.Color = Color3.fromRGB(0, 255, 200)
border.Thickness = 2
border.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 36)
title.BackgroundTransparency = 1
title.Text = "TUNG TUNG BRAINROT"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.Parent = panel

local stats = Instance.new("TextLabel")
stats.Name = "Stats"
stats.Size = UDim2.new(1, -16, 0, 44)
stats.Position = UDim2.fromOffset(8, 36)
stats.BackgroundTransparency = 1
stats.Text = "TungCoins: 0\nLvl 1 | XP 0 | Power 15"
stats.TextColor3 = Color3.fromRGB(255, 220, 80)
stats.Font = Enum.Font.Gotham
stats.TextSize = 13
stats.TextXAlignment = Enum.TextXAlignment.Left
stats.TextYAlignment = Enum.TextYAlignment.Top
stats.Parent = panel

local tip = Instance.new("TextLabel")
tip.Size = UDim2.new(1, -16, 0, 28)
tip.Position = UDim2.fromOffset(8, 78)
tip.BackgroundTransparency = 1
tip.Text = "Walk to blue pads + press E to Farm"
tip.TextColor3 = Color3.fromRGB(160, 160, 180)
tip.Font = Enum.Font.Gotham
tip.TextSize = 11
tip.TextXAlignment = Enum.TextXAlignment.Left
tip.Parent = panel

local function btn(text: string, color: Color3, pos: UDim2, size: UDim2): TextButton
	local b = Instance.new("TextButton")
	b.Size = size
	b.Position = pos
	b.BackgroundColor3 = color
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.Parent = panel
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end

local transformBtn = btn("TRANSFORM", Color3.fromRGB(255, 50, 130), UDim2.fromOffset(8, 110), UDim2.new(0.48, -10, 0, 34))
local farmBtn = btn("FARM XP", Color3.fromRGB(40, 160, 255), UDim2.new(0.52, 2, 0, 110), UDim2.new(0.48, -10, 0, 34))
local attackBtn = btn("ATTACK NEAREST", Color3.fromRGB(200, 35, 55), UDim2.fromOffset(8, 150), UDim2.new(1, -16, 0, 34))
local rebirthBtn = btn("REBIRTH", Color3.fromRGB(150, 40, 220), UDim2.fromOffset(8, 190), UDim2.new(1, -16, 0, 30))

transformBtn.MouseButton1Click:Connect(function()
	TransformRE:FireServer(nil)
end)
farmBtn.MouseButton1Click:Connect(function()
	FarmRE:FireServer()
end)
rebirthBtn.MouseButton1Click:Connect(function()
	RebirthRE:FireServer()
end)

local function nearest()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
	local pos = char.HumanoidRootPart.Position
	local best, bestD = nil, 90
	for _, o in ipairs(Players:GetPlayers()) do
		if o ~= player and o.Character and o.Character:FindFirstChild("HumanoidRootPart") then
			local d = (o.Character.HumanoidRootPart.Position - pos).Magnitude
			if d < bestD then
				bestD = d
				best = o
			end
		end
	end
	return best
end

attackBtn.MouseButton1Click:Connect(function()
	local t = nearest()
	if t then
		AttackRE:FireServer(t.UserId)
	else
		pcall(function()
			StarterGui:SetCore("SendNotification", { Title = "", Text = "No player nearby", Duration = 2 })
		end)
	end
end)

-- Shop list
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 0, 220)
scroll.Position = UDim2.fromOffset(8, 228)
scroll.BackgroundColor3 = Color3.fromRGB(26, 22, 40)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = panel
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 8)
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.Parent = scroll

GetShopRE.OnClientEvent:Connect(function(shopData)
	for _, c in ipairs(scroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	local y = 0
	for _, entry in ipairs(shopData) do
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, -6, 0, 42)
		b.BackgroundColor3 = Color3.fromRGB(38, 32, 58)
		b.Text = entry.Name .. "\n" .. entry.Data.Rarity .. " | +" .. entry.Data.Income .. "/s | " .. entry.Data.Price
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Font = Enum.Font.Gotham
		b.TextSize = 11
		b.TextWrapped = true
		b.Parent = scroll
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
		local name = entry.Name
		b.MouseButton1Click:Connect(function()
			BuyRE:FireServer(name)
		end)
		y += 46
	end
	scroll.CanvasSize = UDim2.fromOffset(0, y + 6)
end)
GetShopRE:FireServer()

task.spawn(function()
	while true do
		task.wait(0.35)
		local ls = player:FindFirstChild("leaderstats")
		if ls then
			local coin = ls:FindFirstChild("TungCoin") and ls.TungCoin.Value or 0
			local lvl = ls:FindFirstChild("Level") and ls.Level.Value or 1
			local xp = ls:FindFirstChild("XP") and ls.XP.Value or 0
			local pow = ls:FindFirstChild("Power") and ls.Power.Value or 15
			local rb = ls:FindFirstChild("Rebirths") and ls.Rebirths.Value or 0
			local extra = ""
			if player:GetAttribute("IsTransformed") then
				extra = " | " .. tostring(player:GetAttribute("TransformBrainrot") or "MORPH")
			end
			stats.Text = "TungCoins: " .. coin .. " | Rebirths: " .. rb .. "\nLvl " .. lvl .. " | XP " .. xp .. " | Power " .. pow .. extra
		end
	end
end)

NotifyRE.OnClientEvent:Connect(function(kind, message)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = kind == "Success" and "OK" or "Hey",
			Text = tostring(message),
			Duration = 3.5,
		})
	end)
end)

print("[ClientUI] Ready")
