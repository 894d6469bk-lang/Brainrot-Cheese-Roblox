--!strict
local Config = {}

Config.StartingCheese = 100
Config.StarterBrainrot = "Noobini Pizzanini"
Config.BaseIncomeTick = 1

-- Rebirth settings
Config.RebirthRequirement = 50000      -- minimum cheese needed to rebirth
Config.RebirthMultiplierPerLevel = 0.25 -- +25% income per rebirth

-- Steal settings
Config.StealCooldown = 30               -- seconds
Config.StealSuccessChance = 0.35      -- 35% chance
Config.StealCooldownOnFail = 15

-- Game Pass IDs (REPLACE THESE with real IDs from Creator Hub)
Config.GamePasses = {
	DoubleCheese = 0,
	VIP = 0,
	AutoCollect = 0,
	LuckBoost = 0,
	StealProtection = 0,
}

-- Developer Product IDs (REPLACE THESE)
Config.DevProducts = {
	CheesePackSmall = 0,   -- +5,000
	CheesePackMedium = 0,  -- +50,000
	CheesePackLarge = 0,   -- +500,000
	CheesePackMega = 0,    -- +5,000,000
}

Config.DevProductRewards = {
	-- these will be filled when you set real product IDs
}

return Config
