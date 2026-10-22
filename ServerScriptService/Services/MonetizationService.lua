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
	if not leaderstats or not leaderstats:FindFirstChild("Cheese") then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	-- You will replace these 0s with real ProductIds later
	local rewards = {
		[Config.DevProducts.CheesePackSmall] = 5000,
		[Config.DevProducts.CheesePackMedium] = 50000,
		[Config.DevProducts.CheesePackLarge] = 500000,
		[Config.DevProducts.CheesePackMega] = 5000000,
	}

	local amount = rewards[receiptInfo.ProductId]
	if amount then
		leaderstats.Cheese.Value += amount
		print(player.Name .. " purchased cheese pack +