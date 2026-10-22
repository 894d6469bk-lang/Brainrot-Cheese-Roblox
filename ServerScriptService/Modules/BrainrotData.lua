--!strict
--[[
	BrainrotData.lua
	All the meme brainrots and their stats
]]

local BrainrotData = {}

-- Rarity order: Common < Rare < Epic < Legendary < Mythic < Secret
BrainrotData.List = {
	["Noobini Pizzanini"] = {
		Rarity = "Common",
		Income = 5,
		Price = 0, -- starter
		Description = "The classic pizza noob. Pure beginner cheese.",
	},
	["Tim Cheese"] = {
		Rarity = "Common",
		Income = 12,
		Price = 100,
		Description = "A walking block of cheese. Meta.",
	},
	["Tralalero Tralala"] = {
		Rarity = "Rare",
		Income = 45,
		Price = 750,
		Description = "Three-legged shark with sneakers. Iconic.",
	},
	["Tung Tung Tung Sahur"] = {
		Rarity = "Rare",
		Income = 80,
		Price = 2000,
		Description = "Wooden drum man with a baseball bat. Terrifying.",
	},
	["Bombardiro Crocodilo"] = {
		Rarity = "Epic",
		Income = 250,
		Price = 8000,
		Description = "Crocodile + bomber jet hybrid. Absolute unit.",
	},
	["Ballerina Cappuccina"] = {
		Rarity = "Epic",
		Income = 320,
		Price = 12000,
		Description = "Elegant but completely unhinged.",
	},
	["La Vaca Saturno Saturnita"] = {
		Rarity = "Legendary",
		Income = 900,
		Price = 50000,
		Description = "Cosmic cow from another dimension.",
	},
	["Strawberry Elephant"] = {
		Rarity = "Mythic",
		Income = 3500,
		Price = 250000,
		Description = "The red elephant of pure brainrot power.",
	},
	["67"] = {
		Rarity = "Secret",
		Income = 15000,
		Price = 2000000,
		Description = "Nobody knows what 67 is. Everyone fears it.",
	},
}

function BrainrotData.Get(name: string)
	return BrainrotData.List[name]
end

function BrainrotData.GetAll()
	return BrainrotData.List
end

function BrainrotData.GetByRarity(rarity: string)
	local result = {}
	for name, data in pairs(BrainrotData.List) do
		if data.Rarity == rarity then
			result[name] = data
		end
	end
	return result
end

return BrainrotData
