--!strict
--[[
	Client UI - Tung Tung Sahur Coin + Transform + Combat
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
local TransformRE = remotes:WaitForChild("Transform")
local FarmXPRE = remotes:WaitForChild("FarmXP")
local AttackRE = remotes:WaitForChild("Attack")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 320, 0, 440)
main.Position = UDim2.new(1, -340, 0.5, -220)
main.BackgroundColor3 = Color3.fromRGB(18, 16, 28)
main.BorderSizePixel = 0
main.Parent = screenGui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 255, 200)
stroke.Thickness = 2
stroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 38)
title.BackgroundTransparency = 1
title.Text = "\ud83d\udd25 TUNG TUNG BRAINROT"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.Parent = main

local coinLabel = Instance.new("TextLabel")
coinLabel.Name = "CoinLabel"
coinLabel.Size = UDim2.new(1, -20, 0, 48)
coinLabel.Position = UDim2.new(0, 10, 0, 38)
coinLabel.BackgroundTransparency = 1
coinLabel.Text = "TungCoins: 0\nLvl 1 | XP 0 | Power 10"
coinLabel.TextColor3 = Color3.fromRGB(255, 220, 80)
coinLabel.Font = Enum.Font.Gotham
coinLabel.TextSize = 14
coinLabel.TextXAlignment = Enum.TextXAlignment.Left
coinLabel.TextYAlignment = Enum.TextYAlignment.Top
coinLabel.Parent = main

local combatFrame = Instance.new("Frame")
combatFrame.Size = UDim2.new(1, -20, 0, 70)
combatFrame.Position = UDim2.new(0, 10, 0, 90)
combatFrame.BackgroundTransparency = 1
combatFrame.Parent = main

local transformBtn = Instance.new("TextButton")
transformBtn.Size = UDim2.new(0.48, 0, 0, 32)
transformBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 130)
transformBtn.Text = "TRANSFORM"
transformBtn.TextColor3 = Color3.new(1,1,1)
transformBtn.Font = Enum.Font.GothamBold
transformBtn.TextSize = 13
transformBtn.Parent = combatFrame
Instance.new("UICorner", transformBtn).CornerRadius = UDim.new(0, 6)

local farmBtn = Instance.new("TextButton")
farmBtn.Size = UDim2.new(0.48, 0, 0, 32)
farmBtn.Position = UDim2.new(0.52, 0, 0, 0)
farmBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 255)
farmBtn.Text = "FARM XP"
farmBtn.TextColor3 = Color3.new(1,1,1)
farmBtn.Font = Enum.Font.GothamBold
farmBtn.TextSize = 13
farmBtn.Parent = combatFrame
Instance.new("UICorner", farmBtn).CornerRadius = UDim.new(0, 6)

local attackBtn = Instance.new("TextButton")
attackBtn.Size = UDim2.new(1, 0, 0, 32)
attackBtn.Position = UDim2.new(0, 0, 0, 36)
attackBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 50)
attackBtn.Text = "ATTACK NEAREST"
attackBtn.TextColor3 = Color3.new(1,1,1)
attackBtn.Font = Enum.Font.GothamBold
attackBtn.TextSize = 13
attackBtn.Parent = combatFrame
Instance.new("UICorner", attackBtn).CornerRadius = UDim.new(0, 6)

transformBtn.MouseButton1Click:Connect(function()
	TransformRE:FireServer(nil)
end)

farmBtn.MouseButton1Click:Connect(function()
	FarmXPRE:FireServer()
end)

local function getNearestPlayer()
	local myChar = player.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
	local myPos = myChar.HumanoidRootPart.Position
	local nearest, nearestDist = nil, math.huge
	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= player and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (other.Character.HumanoidRootPart.Position - myPos).Magnitude
			if dist < nearestDist and dist < 80 then
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
				Text = "No player nearby!",
				Duration = 3,
			})
		end)
	end
end)

local rebirthBtn = Instance.new("TextButton")
rebirthBtn.Size = UDim2.new(1, -20, 0, 30)
rebirthBtn.Position = UDim2.new(0, 10, 0, 168)
rebirthBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 220)
rebirthBtn.Text = "REBIRTH"
rebirthBtn.TextColor3 = Color3.new(1,1,1)
rebirthBtn.Font = Enum.Font.GothamBold
rebirthBtn.TextSize = 13
rebirthBtn.Parent = main
Instance.new("UICorner", rebirthBtn).CornerRadius = UDim.new(0, 8)
rebirthBtn.MouseButton1Click:Connect(function()
	RebirthRE:FireServer()
end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 0, 220)
scroll.Position = UDim2.new(0, 10, 0, 206)
scroll.BackgroundColor3 = Color3.fromRGB(28, 24, 42)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = main
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 8)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = scroll

local function refreshShop(shopData)
	for _, child in ipairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	local y = 0
	for _, entry in ipairs(shopData) do
		local name = entry.Name
		local data = entry.Data
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -8, 0, 46)
		btn.BackgroundColor3 = Color3.fromRGB(40, 35, 60)
		btn.Text = name .. "\n" .. data.Rarity .. " | +" .. data.Income .. "/s | " .. data.Price .. " TungCoins"
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 12
		btn.TextWrapped = true
		btn.Parent = scroll
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
		btn.MouseButton1Click:Connect(function()
			BuyBrainrotRE:FireServer(name)
		end)
		y += 52
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, y + 8)
end

GetShopDataRE:FireServer()
GetShopDataRE.OnClientEvent:Connect(refreshShop)

task.spawn(function()
	while true do
		task.wait(0.4)
		local ls = player:FindFirstChild("leaderstats")
		if ls then
			local coin = ls:FindFirstChild("TungCoin") and ls.TungCoin.Value or 0
			local level = ls:FindFirstChild("Level") and ls.Level.Value or 1
			local xp = ls:FindFirstChild("XP") and ls.XP.Value or 0
			local power = ls:FindFirstChild("Power") and ls.Power.Value or 10
			local rebirths = ls:FindFirstChild("Rebirths") and ls.Rebirths.Value or 0
			local transformText = ""
			if player:GetAttribute("IsTransformed") then
				transformText = " | \ud83d\udd25 " .. (player:GetAttribute("TransformBrainrot") or "BRAINROT")
			end
			coinLabel.Text = "TungCoins: " .. coin .. "  |  Rebirths: " .. rebirths .. "\nLvl " .. level .. " | XP " .. xp .. " | Power " .. power .. transformText
		end
	end
end)

NotifyRE.OnClientEvent:Connect(function(type_, message)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = type_ == "Success" and "Success" or "Error",
			Text = message,
			Duration = 4,
		})
	end)
end)

print("ClientUI loaded - TungCoin + Morph ready")
