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

-- ========== COMBAT / POWER SYSTEM (NEW) ==========
Config.StartingXP = 0
Config.StartingPower = 10
Config.StartingLevel = 1

-- XP needed for next level: Level * XPPerLevelBase
Config.XPPerLevelBase = 100
Config.PowerPerLevel = 8                 -- +8 Power every level

-- Transform into your Brainrot
Config.TransformCooldown = 15            -- seconds between transforms
Config.TransformDuration = 45            -- how long you stay as brainrot
Config.TransformPowerMultiplier = {      -- power boost while transformed by rarity
	Common = 1.2,
	Rare = 1.5,
	Epic = 2.0,
	Legendary = 2.8,
	Mythic = 4.0,
	Secret = 6.0,
}

-- Farming XP (passive while transformed + active)
Config.PassiveXPPerSecond = 2            -- while transformed
Config.FarmXPAmount = 25                 -- when you press Farm button / collect
Config.FarmCooldown = 3

-- PvP Kill
Config.AttackCooldown = 1.2              -- seconds between attacks
Config.BaseDamage = 15                   -- base damage
Config.DamagePerPower = 0.4              -- extra damage from Power stat
Config.KillCheeseReward = 350            -- cheese for killing someone
Config.KillXPReward = 80                 -- XP for a kill
Config.KillPowerSteal = 3                -- steal a bit of victim power
Config.DeathCheeseLossPercent = 0.08     -- lose 8% cheese on death (not too punishing)

-- Game Passes (replace 0 with real IDs)
Config.GamePasses = {
	DoubleCheese = 0,
	VIP = 0,
	AutoCollect = 0,
	StealProtection = 0,
	LuckyBoost = 0,
	DoubleXP = 0,
	PowerBoost = 0,
}

-- Dev Products
Config.DevProducts = {
	CheesePackSmall = 0,
	CheesePackMedium = 0,
	CheesePackLarge = 0,
	CheesePackMega = 0,
}

return Config
