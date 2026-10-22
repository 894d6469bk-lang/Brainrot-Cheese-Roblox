--!strict
--[[
	Config.lua
	Central settings for Brainrot Cheese
]]

local Config = {}

Config.StartingCheese = 50
Config.StarterBrainrot = "Noobini Pizzanini"

-- Income multiplier base
Config.BaseIncomeTick = 1 -- every 1 second

-- Game Pass IDs (replace with your real ones from Creator Hub)
Config.GamePasses = {
	DoubleCheese = 0,      -- 2x cheese income
	VIP = 0,               -- VIP tag + extra starter
	AutoCollect = 0,       -- auto collect nearby
	LuckBoost = 0,         -- better rare spawns
}

-- Developer Product IDs
Config.DevProducts = {
	CheesePackSmall = 0,   -- +1,000 Cheese
	CheesePackMedium = 0,  -- +10,000 Cheese
	CheesePackLarge = 0,   -- +100,000 Cheese
}

return Config
