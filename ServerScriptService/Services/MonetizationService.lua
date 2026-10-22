--!strict
--[[
	MonetizationService.lua
	Handles Game Passes and Developer Products
	Replace the 0 IDs in Config.lua with real ones from Creator Hub
]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local Config = require(script.Parent.Parent.Modules.Config)

local MonetizationService = {}

-- Check if player owns a Game Pass
function MonetizationService.HasPass(player: Player, passName: string): boolean
	local passId = Config.GamePasses[passName]
	if not passId or passId == 0 then return false end

	local success, hasPass = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, passId)
	end)
	return success and hasPass
end

-- Process receipt for Developer Products
MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	local cheese = leaderstats:FindFirstChild("Cheese")
	if not cheese then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- Map product IDs to rewards (update these when you create real products)
	local rewards = {
		[Config.DevProducts.CheesePackSmall] = 1000,
		[Config.DevProducts.CheesePackMedium] = 10000,
		[Config.DevProducts.CheesePackLarge] = 100000,
	}

	local amount = rewards[receiptInfo.ProductId]
	if amount then
		cheese.Value += amount
		print(player.Name .. " bought cheese pack! +" .. amount)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	return Enum.ProductPurchaseDecision.NotProcessedYet
end

print("MonetizationService loaded. Ready for the cheese.")

return MonetizationService
