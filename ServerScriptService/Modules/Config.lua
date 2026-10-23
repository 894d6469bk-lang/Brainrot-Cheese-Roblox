--!strict
local Config = {}

Config.StartingTungCoin = 150
Config.StarterBrainrot = "Noobini Pizzanini"
Config.BaseIncomeTick = 1

Config.OfflineIncomeCapHours = 8
Config.OfflineIncomeMultiplier = 0.6

Config.RebirthRequirement = 75000
Config.RebirthMultiplierPerLevel = 0.3

Config.StealCooldown = 20
Config.StealSuccessChance = 0.45
Config.StealProtectionPassReduces = 0.15

-- Lucky events
Config.LuckyEventIntervalSeconds = 90
Config.LuckyEventDuration = 30
Config.LuckyEventIncomeMulti = 3
Config.LuckyEventXPMulti = 2

-- Combat
Config.StartingXP = 0
Config.StartingPower = 10
Config.StartingLevel = 1
Config.XPPerLevelBase = 100
Config.PowerPerLevel = 8

Config.TransformCooldown = 12
Config.TransformDuration = 50
Config.TransformPowerMultiplier = {
	Common = 1.2,
	Rare = 1.5,
	Epic = 2.0,
	Legendary = 2.8,
	Mythic = 4.0,
	Secret = 6.0,
}

Config.PassiveXPPerSecond = 2
Config.FarmXPAmount = 30
Config.FarmCooldown = 2
Config.FarmPadBonusXP = 50

Config.AttackCooldown = 1.0
Config.BaseDamage = 18
Config.DamagePerPower = 0.45
Config.KillTungCoinReward = 400
Config.KillXPReward = 100
Config.KillPowerSteal = 4
Config.DeathTungCoinLossPercent = 0.07

-- Killstreak
Config.KillstreakTimeout = 20
Config.KillstreakBonusPerKill = 0.25
Config.KillstreakMaxBonus = 3.0

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
