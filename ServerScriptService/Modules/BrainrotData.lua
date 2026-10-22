--!strict
-- Updated with current viral names (Oct 2026 meta)

local BrainrotData = {}

BrainrotData.List = {
	-- Common (easy early game)
	["Noobini Pizzanini"] = {Rarity = "Common", Income = 10, Price = 0, Description = "Starter. Everyone starts here."},
	["Tim Cheese"] = {Rarity = "Common", Income = 22, Price = 200, Description = "Pure cheese energy."},
	["Skibidi Toilet"] = {Rarity = "Common", Income = 35, Price = 500, Description = "Never dies."},

	-- Rare
	["Tralalero Tralala"] = {Rarity = "Rare", Income = 85, Price = 1500, Description = "Three-legged shark legend."},
	["Tung Tung Tung Sahur"] = {Rarity = "Rare", Income = 130, Price = 3200, Description = "Still one of the most searched."},
	["Brr Brr Patapim"] = {Rarity = "Rare", Income = 160, Price = 5000, Description = "Chaos incarnate."},

	-- Epic
	["Bombardiro Crocodilo"] = {Rarity = "Epic", Income = 380, Price = 18000, Description = "Croc bomber. Classic."},
	["Ballerina Cappuccina"] = {Rarity = "Epic", Income = 450, Price = 26000, Description = "Elegant menace."},
	["Coffin Tung Tung Sahur"] = {Rarity = "Epic", Income = 520, Price = 40000, Description = "Even more cursed version."},

	-- Legendary
	["La Vaca Saturno Saturnita"] = {Rarity = "Legendary", Income = 1300, Price = 110000, Description = "Cosmic cow."},
	["La Grande Combinasion"] = {Rarity = "Legendary", Income = 1650, Price = 160000, Description = "The big one."},
	["Bombombini Gusini"] = {Rarity = "Legendary", Income = 1900, Price = 220000, Description = "Goose of destruction."},

	-- Mythic (high demand names)
	["Strawberry Elephant"] = {Rarity = "Mythic", Income = 5500, Price = 750000, Description = "One of the most valuable in the meta."},
	["Job Job Job Sahur"] = {Rarity = "Mythic", Income = 7200, Price = 1100000, Description = "The working man."},
	["Plant Bros"] = {Rarity = "Mythic", Income = 6800, Price = 950000, Description = "Current event favorite."},

	-- Secret / high end
	["67"] = {Rarity = "Secret", Income = 28000, Price = 6000000, Description = "Nobody knows. Everyone wants."},
	["Phoenix"] = {Rarity = "Secret", Income = 42000, Price = 12000000, Description = "Top tier secret energy."},
	["Smurf Cat"] = {Rarity = "Secret", Income = 21000, Price = 4500000, Description = "Blue menace."},
	["Headless Horseman"] = {Rarity = "Secret", Income = 35000, Price = 9000000, Description = "Spooky season king."},
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
