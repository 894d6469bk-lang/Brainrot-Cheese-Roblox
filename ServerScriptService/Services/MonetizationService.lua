--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local Config = require(script.Parent.Parent.Modules.Config)

local MonetizationService = {}

function MonetizationService.HasPass(player: Player, passName: string): boolean
	local passId = Config.GamePasses[passName]
	if not passId or passId == 0 then return false end

	local success, owns = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, passId)
	end)
	return success and owns
end

MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats or not leaderstats:FindFirstChild("TungCoin") then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local rewards = {
		[Config.DevProducts.TungPackSmall] = 5000,
		[Config.DevProducts.TungPackMedium] = 50000,
		[Config.DevProducts.TungPackLarge] = 500000,
		[Config.DevProducts.TungPackMega] = 5000000,
	}

	local amount = rewards[receiptInfo.ProductId]
	if amount then
		leaderstats.TungCoin.Value += amount
		print(player.Name .. " purchased TungCoin pack +" .. amount)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	return Enum.ProductPurchaseDecision.NotProcessedYet
end

print("MonetizationService ready (TungCoin)")
return MonetizationService
