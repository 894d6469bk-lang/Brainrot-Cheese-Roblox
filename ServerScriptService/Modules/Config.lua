--!strict
local Config = {}

Config.StartingTungCoin = 200
Config.StarterBrainrot = "Noobini Pizzanini"
Config.BaseIncomeTick = 1

Config.OfflineIncomeCapHours = 8
Config.OfflineIncomeMultiplier = 0.6

Config.RebirthRequirement = 50000
Config.RebirthMultiplierPerLevel = 0.25

Config.StealCooldown = 18
Config.StealSuccessChance = 0.50

Config.LuckyEventIntervalSeconds = 75
Config.LuckyEventDuration = 25
Config.LuckyEventIncomeMulti = 3
Config.LuckyEventXPMulti = 2

Config.StartingXP = 0
Config.StartingPower = 15
Config.StartingLevel = 1
Config.XPPerLevelBase = 80
Config.PowerPerLevel = 10

Config.TransformCooldown = 10
Config.TransformDuration = 40
Config.TransformPowerMultiplier = {
	Common = 1.3,
	Rare = 1.6,
	Epic = 2.1,
	Legendary = 3.0,
	Mythic = 4.5,
	Secret = 7.0,
}

Config.PassiveXPPerSecond = 3
Config.FarmXPAmount = 40
Config.FarmCooldown = 1.5
Config.FarmPadBonusXP = 60

Config.AttackCooldown = 0.9
Config.BaseDamage = 20
Config.DamagePerPower = 0.5
Config.KillTungCoinReward = 500
Config.KillXPReward = 120
Config.KillPowerSteal = 5
Config.DeathTungCoinLossPercent = 0.05

Config.KillstreakTimeout = 18
Config.KillstreakBonusPerKill = 0.3
Config.KillstreakMaxBonus = 3.5

Config.MorphColors = {
	Common = Color3.fromRGB(200, 200, 200),
	Rare = Color3.fromRGB(70, 150, 255),
	Epic = Color3.fromRGB(170, 60, 255),
	Legendary = Color3.fromRGB(255, 190, 30),
	Mythic = Color3.fromRGB(255, 50, 110),
	Secret = Color3.fromRGB(0, 255, 210),
}

Config.MorphScale = {
	Common = 1.15,
	Rare = 1.3,
	Epic = 1.5,
	Legendary = 1.7,
	Mythic = 2.0,
	Secret = 2.4,
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
