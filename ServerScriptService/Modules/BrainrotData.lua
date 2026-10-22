--!strict
local BrainrotData = {}

BrainrotData.List = {
	-- Common
	["Noobini Pizzanini"] = {Rarity = "Common", Income = 8, Price = 0, Description = "Starter pizza noob."},
	["Tim Cheese"] = {Rarity = "Common", Income = 18, Price = 150, Description = "Walking cheese block."},
	["Skibidi Toilet"] = {Rarity = "Common", Income = 25, Price = 400, Description = "Classic toilet head."},

	-- Rare
	["Tralalero Tralala"] = {Rarity = "Rare", Income = 70, Price = 1200, Description = "Three-legged shark with kicks."},
	["Tung Tung Tung Sahur"] = {Rarity = "Rare", Income = 110, Price = 2800, Description = "Wooden drum with bat."},
	["Brr Brr Patapim"] = {Rarity = "Rare", Income = 140, Price = 4500, Description = "The chaotic one."},

	-- Epic
	["Bombardiro Crocodilo"] = {Rarity = "Epic", Income = 320, Price = 15000, Description = "Croc + bomber jet."},
	["Ballerina Cappuccina"] = {Rarity = "Epic", Income = 410, Price = 22000, Description = "Elegant chaos."},
	["Coffin Tung Tung Sahur"] = {Rarity = "Epic", Income = 480, Price = 35000, Description = "Even more cursed."},

	-- Legendary
	["La Vaca Saturno Saturnita"] = {Rarity = "Legendary", Income = 1100, Price = 90000, Description = "Cosmic cow."},
	["La Grande Combinasion"] = {Rarity = "Legendary", Income = 1450, Price = 140000, Description = "The big combination."},
	["Bombombini Gusini"] = {Rarity = "Legendary", Income = 1700, Price = 200000, Description = "Goose of mass destruction."},

	-- Mythic
	["Strawberry Elephant"] = {Rarity = "Mythic", Income = 4500, Price = 600000, Description = "Red elephant of power."},
	["Job Job Job Sahur"] = {Rarity = "Mythic", Income = 6200, Price = 950000, Description = "The working man."},

	-- Secret
	["67"] = {Rarity = "Secret", Income = 25000, Price = 5000000, Description = "Nobody knows. Everyone fears."},
	["Smurf Cat"] = {Rarity = "Secret", Income = 18000, Price = 3200000, Description = "Blue menace."},
}

function BrainrotData.Get(name: string)
	return BrainrotData.List[name]
end

function BrainrotData.GetAll()
	return BrainrotData.List
end

function BrainrotData.GetSortedByPrice()
	local sorted = {}
	for name, data in pairs(BrainrotData.List) do
		table.insert(sorted, {Name = name, Data = data})
	end
	table.sort(sorted, function(a, b)
		return a.Data.Price < b.Data.Price
	end)
	return sorted
end

return BrainrotData
