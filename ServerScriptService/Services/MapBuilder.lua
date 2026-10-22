--!strict
--[[
	MapBuilder - Procedural gaamato brainrot map
	Runs once on server start. Creates:
	- Neon central PvP Arena
	- 8 player plot bases in a circle
	- Farm pads (XP zones)
	- Spawn plaza with Tung Tung vibe
	- Atmosphere lighting + fog
]]

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local MapBuilder = {}

local function part(props)
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = true
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	for k, v in pairs(props) do
		p[k] = v
	end
	return p
end

local function neonPart(props)
	props.Material = Enum.Material.Neon
	return part(props)
end

function MapBuilder.Build()
	-- Clear default baseplate if present
	local baseplate = Workspace:FindFirstChild("Baseplate")
	if baseplate then baseplate:Destroy() end

	local mapFolder = Workspace:FindFirstChild("BrainrotMap")
	if mapFolder then mapFolder:Destroy() end
	mapFolder = Instance.new("Folder")
	mapFolder.Name = "BrainrotMap"
	mapFolder.Parent = Workspace

	-- ========== GROUND ==========
	local ground = part({
		Name = "Ground",
		Size = Vector3.new(600, 4, 600),
		Position = Vector3.new(0, -2, 0),
		Color = Color3.fromRGB(20, 18, 30),
		Material = Enum.Material.SmoothPlastic,
		Parent = mapFolder,
	})

	-- Grid neon lines on ground (visual)
	for i = -5, 5 do
		local lineX = neonPart({
			Name = "GridX",
			Size = Vector3.new(580, 0.2, 1.5),
			Position = Vector3.new(0, 0.2, i * 50),
			Color = Color3.fromRGB(60, 20, 90),
			Transparency = 0.55,
			CanCollide = false,
			Parent = mapFolder,
		})
		local lineZ = neonPart({
			Name = "GridZ",
			Size = Vector3.new(1.5, 0.2, 580),
			Position = Vector3.new(i * 50, 0.2, 0),
			Color = Color3.fromRGB(60, 20, 90),
			Transparency = 0.55,
			CanCollide = false,
			Parent = mapFolder,
		})
	end

	-- ========== CENTRAL ARENA (PvP) ==========
	local arenaRadius = 55
	local arenaFloor = neonPart({
		Name = "ArenaFloor",
		Size = Vector3.new(arenaRadius * 2, 1, arenaRadius * 2),
		Position = Vector3.new(0, 0.5, 0),
		Color = Color3.fromRGB(40, 10, 50),
		Shape = Enum.PartType.Cylinder,
		Orientation = Vector3.new(0, 0, 90),
		Parent = mapFolder,
	})
	-- fix cylinder orientation - use Block with round look instead
	arenaFloor:Destroy()
	arenaFloor = part({
		Name = "ArenaFloor",
		Size = Vector3.new(arenaRadius * 2, 1.2, arenaRadius * 2),
		Position = Vector3.new(0, 0.6, 0),
		Color = Color3.fromRGB(35, 12, 45),
		Material = Enum.Material.SmoothPlastic,
		Parent = mapFolder,
	})

	-- Arena ring (neon)
	local ring = neonPart({
		Name = "ArenaRing",
		Size = Vector3.new(arenaRadius * 2 + 4, 3, arenaRadius * 2 + 4),
		Position = Vector3.new(0, 1.5, 0),
		Color = Color3.fromRGB(255, 40, 120),
		Transparency = 0.3,
		CanCollide = false,
		Parent = mapFolder,
	})
	-- hollow effect: smaller inner transparent
	local ringInner = part({
		Name = "ArenaRingInner",
		Size = Vector3.new(arenaRadius * 2 - 2, 3.5, arenaRadius * 2 - 2),
		Position = Vector3.new(0, 1.5, 0),
		Transparency = 1,
		CanCollide = false,
		Parent = mapFolder,
	})

	-- Arena pillars
	for i = 0, 7 do
		local angle = (i / 8) * math.pi * 2
		local x = math.cos(angle) * (arenaRadius + 2)
		local z = math.sin(angle) * (arenaRadius + 2)
		neonPart({
			Name = "ArenaPillar",
			Size = Vector3.new(4, 18, 4),
			Position = Vector3.new(x, 9, z),
			Color = Color3.fromRGB(255, 60 + i * 10, 150),
			Parent = mapFolder,
		})
	end

	-- Center monument (Tung Tung vibe)
	local monument = neonPart({
		Name = "TungMonument",
		Size = Vector3.new(8, 22, 8),
		Position = Vector3.new(0, 11, 0),
		Color = Color3.fromRGB(0, 255, 200),
		Parent = mapFolder,
	})
	local monTop = neonPart({
		Name = "MonumentTop",
		Size = Vector3.new(14, 3, 14),
		Position = Vector3.new(0, 23, 0),
		Color = Color3.fromRGB(255, 200, 50),
		Parent = mapFolder,
	})

	-- Billboard on monument
	local bb = Instance.new("BillboardGui")
	bb.Size = UDim2.new(0, 300, 0, 80)
	bb.StudsOffset = Vector3.new(0, 14, 0)
	bb.AlwaysOnTop = true
	bb.Parent = monument
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 1, 0)
	title.BackgroundTransparency = 1
	title.Text = "\ud83d\udd25 TUNG TUNG ARENA \ud83d\udd25"
	title.TextColor3 = Color3.fromRGB(0, 255, 200)
	title.TextStrokeTransparency = 0.2
	title.Font = Enum.Font.GothamBlack
	title.TextScaled = true
	title.Parent = bb

	-- ========== PLAYER PLOTS (8 bases in circle) ==========
	local plotDistance = 140
	local plotSize = 40
	for i = 0, 7 do
		local angle = (i / 8) * math.pi * 2 + math.pi / 8
		local x = math.cos(angle) * plotDistance
		local z = math.sin(angle) * plotDistance

		local plotFolder = Instance.new("Folder")
		plotFolder.Name = "Plot_" .. (i + 1)
		plotFolder.Parent = mapFolder

		-- Plot floor
		part({
			Name = "PlotFloor",
			Size = Vector3.new(plotSize, 1.5, plotSize),
			Position = Vector3.new(x, 0.75, z),
			Color = Color3.fromRGB(30, 25, 45),
			Material = Enum.Material.SmoothPlastic,
			Parent = plotFolder,
		})

		-- Plot border neon
		neonPart({
			Name = "PlotBorder",
			Size = Vector3.new(plotSize + 2, 0.4, plotSize + 2),
			Position = Vector3.new(x, 1.6, z),
			Color = Color3.fromRGB(120 + i * 15, 40, 255),
			Transparency = 0.4,
			CanCollide = false,
			Parent = plotFolder,
		})

		-- Small house / base structure
		part({
			Name = "BaseWall",
			Size = Vector3.new(18, 12, 2),
			Position = Vector3.new(x, 7, z - 12),
			Color = Color3.fromRGB(45, 35, 70),
			Parent = plotFolder,
		})
		part({
			Name = "BaseRoof",
			Size = Vector3.new(20, 2, 16),
			Position = Vector3.new(x, 14, z - 6),
			Color = Color3.fromRGB(255, 80, 140),
			Material = Enum.Material.Neon,
			Parent = plotFolder,
		})

		-- Claim pad
		local pad = neonPart({
			Name = "ClaimPad",
			Size = Vector3.new(10, 0.5, 10),
			Position = Vector3.new(x, 1.5, z + 8),
			Color = Color3.fromRGB(0, 255, 180),
			Parent = plotFolder,
		})
		pad:SetAttribute("PlotId", i + 1)
	end

	-- ========== FARM ZONES (XP pads) ==========
	local farmPositions = {
		Vector3.new(90, 1, 90),
		Vector3.new(-90, 1, 90),
		Vector3.new(90, 1, -90),
		Vector3.new(-90, 1, -90),
		Vector3.new(0, 1, 100),
		Vector3.new(0, 1, -100),
	}
	for i, pos in ipairs(farmPositions) do
		local farm = neonPart({
			Name = "FarmPad_" .. i,
			Size = Vector3.new(16, 0.6, 16),
			Position = pos,
			Color = Color3.fromRGB(50, 180, 255),
			Parent = mapFolder,
		})
		farm:SetAttribute("IsFarmPad", true)

		local farmBB = Instance.new("BillboardGui")
		farmBB.Size = UDim2.new(0, 120, 0, 40)
		farmBB.StudsOffset = Vector3.new(0, 4, 0)
		farmBB.AlwaysOnTop = true
		farmBB.Parent = farm
		local fl = Instance.new("TextLabel")
		fl.Size = UDim2.new(1, 0, 1, 0)
		fl.BackgroundTransparency = 1
		fl.Text = "\u26a1 FARM XP"
		fl.TextColor3 = Color3.fromRGB(100, 220, 255)
		fl.Font = Enum.Font.GothamBold
		fl.TextScaled = true
		fl.Parent = farmBB
	end

	-- ========== SPAWN ==========
	local spawnLoc = Instance.new("SpawnLocation")
	spawnLoc.Name = "MainSpawn"
	spawnLoc.Size = Vector3.new(16, 1, 16)
	spawnLoc.Position = Vector3.new(0, 2, 70)
	spawnLoc.Color = Color3.fromRGB(0, 255, 200)
	spawnLoc.Material = Enum.Material.Neon
	spawnLoc.Anchored = true
	spawnLoc.Duration = 0
	spawnLoc.Neutral = true
	spawnLoc.Parent = mapFolder

	-- Spawn platform
	part({
		Name = "SpawnPlatform",
		Size = Vector3.new(30, 1.5, 30),
		Position = Vector3.new(0, 0.75, 70),
		Color = Color3.fromRGB(25, 30, 50),
		Parent = mapFolder,
	})

	-- ========== LIGHTING / ATMOSPHERE ==========
	Lighting.Brightness = 1.5
	Lighting.Ambient = Color3.fromRGB(40, 30, 60)
	Lighting.OutdoorAmbient = Color3.fromRGB(50, 35, 70)
	Lighting.FogColor = Color3.fromRGB(30, 15, 45)
	Lighting.FogEnd = 400
	Lighting.FogStart = 80
	Lighting.ClockTime = 22 -- night vibe
	Lighting.GlobalShadows = true

	-- Atmosphere
	local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
	if not atmo then
		atmo = Instance.new("Atmosphere")
		atmo.Parent = Lighting
	end
	atmo.Density = 0.35
	atmo.Color = Color3.fromRGB(80, 40, 120)
	atmo.Decay = Color3.fromRGB(40, 20, 60)
	atmo.Glare = 0.3
	atmo.Haze = 1.5

	-- Bloom for neon glow
	local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
	if not bloom then
		bloom = Instance.new("BloomEffect")
		bloom.Parent = Lighting
	end
	bloom.Intensity = 0.9
	bloom.Size = 24
	bloom.Threshold = 0.85

	print("\ud83c\udf0c Brainrot Map BUILT - Arena + 8 Plots + Farm Pads + Neon night vibe")
end

-- Auto build on require
MapBuilder.Build()

return MapBuilder
