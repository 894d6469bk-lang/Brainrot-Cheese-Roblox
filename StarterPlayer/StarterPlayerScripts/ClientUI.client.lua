--!strict
--[[
	Simple client UI for Brainrot Cheese
	Creates a basic shop + rebirth + steal buttons
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
if not remotes then
	warn("Remotes folder not found")
	return
end

local BuyBrainrotRE = remotes:WaitForChild("BuyBrainrot")
local RebirthRE = remotes:WaitForChild("Rebirth")
local StealRE = remotes:WaitForChild("Steal")
local GetShopDataRE = remotes:WaitForChild("GetShopData")
local NotifyRE = remotes:WaitForChild("Notify")

-- Create simple ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotCheeseUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 320, 0, 420)
main.Position = UDim2.new(1, -340, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
main.BorderSizePixel = 0
main.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "\ud83e\udda7 BRAINROT CHEESE"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = main

-- Cheese display
local cheeseLabel = Instance.new("TextLabel")
cheeseLabel.Name = "CheeseLabel"
cheeseLabel.Size = UDim2.new(1, -20, 0, 30)
cheeseLabel.Position = UDim2.new(0, 10, 0, 45)
cheeseLabel.BackgroundTransparency = 1
cheeseLabel.Text = "Cheese: 0"
cheeseLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
cheeseLabel.Font = Enum.Font.Gotham
cheeseLabel.TextSize = 18
cheeseLabel.TextXAlignment = Enum.TextXAlignment.Left
cheeseLabel.Parent = main

-- Rebirth button
local rebirthBtn = Instance.new("TextButton")
rebirthBtn.Size = UDim2.new(1, -20, 0, 36)
rebirthBtn.Position = UDim2.new(0, 10, 0, 85)
rebirthBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 200)
rebirthBtn.Text = "REBIRTH (reset for multiplier)"
rebirthBtn.TextColor3 = Color3.new(1,1,1)
rebirthBtn.Font = Enum.Font.GothamBold
rebirthBtn.TextSize = 14
rebirthBtn.Parent = main
Instance.new("UICorner", rebirthBtn).CornerRadius = UDim.new(0, 8)

rebirthBtn.MouseButton1Click:Connect(function()
	RebirthRE:FireServer()
end)

-- Shop scroll
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 0, 260)
scroll.Position = UDim2.new(0, 10, 0, 130)
scroll.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = main
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 8)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scroll

-- Populate shop
local function refreshShop(shopData)
	for _, child in ipairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end

	local y = 0
	for _, entry in ipairs(shopData) do
		local name = entry.Name
		local data = entry.Data

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -10, 0, 50)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
		btn.Text = name .. "\n" .. data.Rarity .. " | +" .. data.Income .. "/s | " .. data.Price .. " Cheese"
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 13
		btn.TextWrapped = true
		btn.Parent = scroll
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		btn.MouseButton1Click:Connect(function()
			BuyBrainrotRE:FireServer(name)
		end)

		y += 56
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

GetShopDataRE:FireServer()
GetShopDataRE.OnClientEvent:Connect(refreshShop)

-- Live cheese update
task.spawn(function()
	while true do
		task.wait(0.5)
		local ls = player:FindFirstChild("leaderstats")
		if ls and ls:FindFirstChild("Cheese") then
			cheeseLabel.Text = "Cheese: " .. ls.Cheese.Value .. "  |  Rebirths: " .. (ls.Rebirths and ls.Rebirths.Value or 0)
		end
	end
end)

-- Notifications
NotifyRE.OnClientEvent:Connect(function(type_, message)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = type_ == "Success" and "Success" or "Error",
			Text = message,
			Duration = 4,
		})
	end)
end)

print("ClientUI loaded")
