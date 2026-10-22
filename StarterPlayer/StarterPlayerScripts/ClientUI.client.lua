--!strict
--[[
	Client UI for Brainrot Cheese
	Shop + Rebirth + Steal + TRANSFORM + FARM XP + ATTACK
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

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
local TransformRE = remotes:WaitForChild("Transform")
local FarmXPRE = remotes:WaitForChild("FarmXP")
local AttackRE = remotes:WaitForChild("Attack")

-- Create simple ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotCheeseUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main frame (shop)
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

-- Cheese + Level + Power display
local cheeseLabel = Instance.new("TextLabel")
cheeseLabel.Name = "CheeseLabel"
cheeseLabel.Size = UDim2.new(1, -20, 0, 45)
cheeseLabel.Position = UDim2.new(0, 10, 0, 40)
cheeseLabel.BackgroundTransparency = 1
cheeseLabel.Text = "Cheese: 0\nLvl 1 | XP 0 | Power 10"
cheeseLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
cheeseLabel.Font = Enum.Font.Gotham
cheeseLabel.TextSize = 15
cheeseLabel.TextXAlignment = Enum.TextXAlignment.Left
cheeseLabel.TextYAlignment = Enum.TextYAlignment.Top
cheeseLabel.Parent = main

-- Combat buttons row
local combatFrame = Instance.new("Frame")
combatFrame.Size = UDim2.new(1, -20, 0, 70)
combatFrame.Position = UDim2.new(0, 10, 0, 90)
combatFrame.BackgroundTransparency = 1
combatFrame.Parent = main

local transformBtn = Instance.new("TextButton")
transformBtn.Size = UDim2.new(0.48, 0, 0, 32)
transformBtn.Position = UDim2.new(0, 0, 0, 0)
transformBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 120)
transformBtn.Text = "TRANSFORM"
transformBtn.TextColor3 = Color3.new(1,1,1)
transformBtn.Font = Enum.Font.GothamBold
transformBtn.TextSize = 13
transformBtn.Parent = combatFrame
Instance.new("UICorner", transformBtn).CornerRadius = UDim.new(0, 6)

local farmBtn = Instance.new("TextButton")
farmBtn.Size = UDim2.new(0.48, 0, 0, 32)
farmBtn.Position = UDim2.new(0.52, 0, 0, 0)
farmBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 255)
farmBtn.Text = "FARM XP"
farmBtn.TextColor3 = Color3.new(1,1,1)
farmBtn.Font = Enum.Font.GothamBold
farmBtn.TextSize = 13
farmBtn.Parent = combatFrame
Instance.new("UICorner", farmBtn).CornerRadius = UDim.new(0, 6)

local attackBtn = Instance.new("TextButton")
attackBtn.Size = UDim2.new(1, 0, 0, 32)
attackBtn.Position = UDim2.new(0, 0, 0, 36)
attackBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
attackBtn.Text = "ATTACK NEAREST PLAYER"
attackBtn.TextColor3 = Color3.new(1,1,1)
attackBtn.Font = Enum.Font.GothamBold
attackBtn.TextSize = 13
attackBtn.Parent = combatFrame
Instance.new("UICorner", attackBtn).CornerRadius = UDim.new(0, 6)

transformBtn.MouseButton1Click:Connect(function()
	TransformRE:FireServer(nil) -- auto pick strongest
end)

farmBtn.MouseButton1Click:Connect(function()
	FarmXPRE:FireServer()
end)

-- Attack nearest player
local function getNearestPlayer()
	local myChar = player.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
	local myPos = myChar.HumanoidRootPart.Position
	local nearest, nearestDist = nil, math.huge

	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (other.Character.HumanoidRootPart.Position - myPos).Magnitude
			if dist < nearestDist and dist < 80 then -- max range 80 studs
				nearestDist = dist
				nearest = other
			end
		end
	end
	return nearest
end

attackBtn.MouseButton1Click:Connect(function()
	local target = getNearestPlayer()
	if target then
		AttackRE:FireServer(target.UserId)
	else
		pcall(function()
			StarterGui:SetCore("SendNotification", {
				Title = "Error",
				Text = "No player nearby to attack!",
				Duration = 3,
			})
		end)
	end
end)

-- Rebirth button
local rebirthBtn = Instance.new("TextButton")
rebirthBtn.Size = UDim2.new(1, -20, 0, 32)
rebirthBtn.Position = UDim2.new(0, 10, 0, 168)
rebirthBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 200)
rebirthBtn.Text = "REBIRTH (reset for multiplier)"
rebirthBtn.TextColor3 = Color3.new(1,1,1)
rebirthBtn.Font = Enum.Font.GothamBold
rebirthBtn.TextSize = 13
rebirthBtn.Parent = main
Instance.new("UICorner", rebirthBtn).CornerRadius = UDim.new(0, 8)

rebirthBtn.MouseButton1Click:Connect(function()
	RebirthRE:FireServer()
end)

-- Shop scroll
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 0, 200)
scroll.Position = UDim2.new(0, 10, 0, 208)
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
		btn.Size = UDim2.new(1, -10, 0, 48)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
		btn.Text = name .. "\n" .. data.Rarity .. " | +" .. data.Income .. "/s | " .. data.Price .. " Cheese"
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 12
		btn.TextWrapped = true
		btn.Parent = scroll
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		btn.MouseButton1Click:Connect(function()
			BuyBrainrotRE:FireServer(name)
		end)

		y += 54
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

GetShopDataRE:FireServer()
GetShopDataRE.OnClientEvent:Connect(refreshShop)

-- Live stats update
task.spawn(function()
	while true do
		task.wait(0.4)
		local ls = player:FindFirstChild("leaderstats")
		if ls then
			local cheese = ls:FindFirstChild("Cheese") and ls.Cheese.Value or 0
			local level = ls:FindFirstChild("Level") and ls.Level.Value or 1
			local xp = ls:FindFirstChild("XP") and ls.XP.Value or 0
			local power = ls:FindFirstChild("Power") and ls.Power.Value or 10
			local rebirths = ls:FindFirstChild("Rebirths") and ls.Rebirths.Value or 0

			local transformText = ""
			if player:GetAttribute("IsTransformed") then
				transformText = " | \ud83d\udd25 " .. (player:GetAttribute("TransformBrainrot") or "BRAINROT")
			end

			cheeseLabel.Text = "Cheese: " .. cheese .. "  |  Rebirths: " .. rebirths .. "\nLvl " .. level .. " | XP " .. xp .. " | Power " .. power .. transformText
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

print("ClientUI loaded - Combat system ready")
