--!strict
local Config = {}

Config.StartingCheese = 150
Config.StarterBrainrot = "Noobini Pizzanini"
Config.BaseIncomeTick = 1

-- Offline earnings (key retention feature from viral games)
Config.OfflineIncomeCapHours = 8          -- max 8 hours offline earnings
Config.OfflineIncomeMultiplier = 0.6      -- 60% of normal rate while offline

-- Rebirth
Config.RebirthRequirement = 75000
Config.RebirthMultiplierPerLevel = 0.3    -- +30% per rebirth

-- Steal (make it more central like the top games)
Config.StealCooldown = 25
Config.StealSuccessChance = 0.40          -- 40% base chance
Config.StealProtectionPassReduces = 0.15  -- VIP/protection reduces chance against you

-- Lucky / Event system
Config.LuckyEventChancePerMinute = 0.08   -- small chance every minute for server event
Config.LuckyBlockRewardMultiplier = 3     -- temporary boost

-- Game Passes (replace 0 with real IDs)
Config.GamePasses = {
	DoubleCheese = 0,
	VIP = 0,
	AutoCollect = 0,
	StealProtection = 0,
	LuckyBoost = 0,
}

-- Dev Products
Config.DevProducts = {
	CheesePackSmall = 0,
	CheesePackMedium = 0,
	CheesePackLarge = 0,
	CheesePackMega = 0,
}

return Config
