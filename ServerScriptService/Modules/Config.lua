--!strict
local Config = {}

-- Currency is now TUNG TUNG SAHUR COIN (TungCoin)
Config.StartingTungCoin = 150
Config.StarterBrainrot = "Noobini Pizzanini"
Config.BaseIncomeTick = 1

-- Offline earnings
Config.OfflineIncomeCapHours = 8
Config.OfflineIncomeMultiplier = 0.6

-- Rebirth
Config.RebirthRequirement = 75000
Config.RebirthMultiplierPerLevel = 0.3

-- Steal
Config.StealCooldown = 25
Config.StealSuccessChance = 0.40
Config.StealProtectionPassReduces = 0.15

-- Lucky / Event
Config.LuckyEventChancePerMinute = 0.08
Config.LuckyBlockRewardMultiplier = 3

-- Combat / Power
Config.StartingXP = 0
Config.StartingPower = 10
Config.StartingLevel = 1
Config.XPPerLevelBase = 100
Config.PowerPerLevel = 8

Config.TransformCooldown = 15
Config.TransformDuration = 45
Config.TransformPowerMultiplier = {
	Common = 1.2,
	Rare = 1.5,
	Epic = 2.0,
	Legendary = 2.8,
	Mythic = 4.0,
	Secret = 6.0,
}

Config.PassiveXPPerSecond = 2
Config.FarmXPAmount = 25
Config.FarmCooldown = 3

Config.AttackCooldown = 1.2
Config.BaseDamage = 15
Config.DamagePerPower = 0.4
Config.KillTungCoinReward = 350
Config.KillXPReward = 80
Config.KillPowerSteal = 3
Config.DeathTungCoinLossPercent = 0.08

-- Visual Morph colors by rarity
Config.MorphColors = {
	Common = Color3.fromRGB(180, 180, 180),
	Rare = Color3.fromRGB(80, 160, 255),
	Epic = Color3.fromRGB(180, 70, 255),
	Legendary = Color3.fromRGB(255, 180, 40),
	Mythic = Color3.fromRGB(255, 60, 120),
	Secret = Color3.fromRGB(0, 255, 200),
}

Config.MorphScale = {
	Common = 1.1,
	Rare = 1.25,
	Epic = 1.4,
	Legendary = 1.6,
	Mythic = 1.85,
	Secret = 2.2,
}

-- Game Passes (replace 0 with real IDs)
Config.GamePasses = {
	DoubleTungCoin = 0,
	VIP = 0,
	AutoCollect = 0,
	StealProtection = 0,
	LuckyBoost = 0,
	DoubleXP = 0,
	PowerBoost = 0,
}

Config.DevProducts = {
	TungPackSmall = 0,
	TungPackMedium = 0,
	TungPackLarge = 0,
	TungPackMega = 0,
}

return Config
