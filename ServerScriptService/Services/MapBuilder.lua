--!strict
--[[
	Clean neon map - clear visibility, no heavy fog
]]

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local MapBuilder = {}

local function makePart(props: {[string]: any}): Part
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = if props.CanCollide == nil then true else props.CanCollide
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Material = props.Material or Enum.Material.SmoothPlastic
	for k, v in pairs(props) do
		if k ~= "Material" and k ~= "CanCollide" then
			(p :: any)[k] = v
		end
	end
	return p
end

function MapBuilder.Build()
	local old = Workspace:FindFirstChild("Baseplate")
	if old then old:Destroy() end
	local oldMap = Workspace:FindFirstChild("BrainrotMap")
	if oldMap then oldMap:Destroy() end

	local map = Instance.new("Folder")
	map.Name = "BrainrotMap"
	map.Parent = Workspace

	-- Ground (dark but clear)
	makePart({
		Name = "Ground",
		Size = Vector3.new(500, 3, 500),
		Position = Vector3.new(0, -1.5, 0),
		Color = Color3.fromRGB(25, 22, 35),
		Parent = map,
	})

	-- Subtle grid
	for i = -4, 4 do
		makePart({
			Name = "Grid",
			Size = Vector3.new(480, 0.15, 1),
			Position = Vector3.new(0, 0.1, i * 55),
			Color = Color3.fromRGB(80, 40, 120),
			Material = Enum.Material.Neon,
			Transparency = 0.7,
			CanCollide = false,
			Parent = map,
		})
		makePart({
			Name = "Grid",
			Size = Vector3.new(1, 0.15, 480),
			Position = Vector3.new(i * 55, 0.1, 0),
			Color = Color3.fromRGB(80, 40, 120),
			Material = Enum.Material.Neon,
			Transparency = 0.7,
			CanCollide = false,
			Parent = map,
		})
	end

	-- Arena floor
	local arenaR = 50
	makePart({
		Name = "ArenaFloor",
		Size = Vector3.new(arenaR * 2, 1, arenaR * 2),
		Position = Vector3.new(0, 0.5, 0),
		Color = Color3.fromRGB(40, 15, 55),
		Parent = map,
	})

	-- Arena border glow
	makePart({
		Name = "ArenaBorder",
		Size = Vector3.new(arenaR * 2 + 3, 2, arenaR * 2 + 3),
		Position = Vector3.new(0, 1, 0),
		Color = Color3.fromRGB(255, 50, 140),
		Material = Enum.Material.Neon,
		Transparency = 0.4,
		CanCollide = false,
		Parent = map,
	})

	-- 8 pillars
	for i = 0, 7 do
		local a = (i / 8) * math.pi * 2
		local x = math.cos(a) * (arenaR + 1)
		local z = math.sin(a) * (arenaR + 1)
		makePart({
			Name = "Pillar",
			Size = Vector3.new(3.5, 16, 3.5),
			Position = Vector3.new(x, 8, z),
			Color = Color3.fromRGB(255, 70 + i * 12, 160),
			Material = Enum.Material.Neon,
			Parent = map,
		})
	end

	-- Center monument
	local mon = makePart({
		Name = "Monument",
		Size = Vector3.new(7, 20, 7),
		Position = Vector3.new(0, 10, 0),
		Color = Color3.fromRGB(0, 255, 200),
		Material = Enum.Material.Neon,
		Parent = map,
	})
	makePart({
		Name = "MonTop",
		Size = Vector3.new(12, 2.5, 12),
		Position = Vector3.new(0, 21, 0),
		Color = Color3.fromRGB(255, 210, 40),
		Material = Enum.Material.Neon,
		Parent = map,
	})

	local bb = Instance.new("BillboardGui")
	bb.Size = UDim2.fromOffset(280, 70)
	bb.StudsOffset = Vector3.new(0, 12, 0)
	bb.AlwaysOnTop = true
	bb.Parent = mon
	local tl = Instance.new("TextLabel")
	tl.Size = UDim2.fromScale(1, 1)
	tl.BackgroundTransparency = 1
	tl.Text = "TUNG TUNG ARENA"
	tl.TextColor3 = Color3.fromRGB(0, 255, 200)
	tl.Font = Enum.Font.GothamBlack
	tl.TextScaled = true
	tl.Parent = bb

	-- 8 plots
	local plotDist = 125
	for i = 0, 7 do
		local a = (i / 8) * math.pi * 2 + math.pi / 8
		local x = math.cos(a) * plotDist
		local z = math.sin(a) * plotDist
		local folder = Instance.new("Folder")
		folder.Name = "Plot_" .. (i + 1)
		folder.Parent = map

		makePart({
			Name = "PlotFloor",
			Size = Vector3.new(36, 1.2, 36),
			Position = Vector3.new(x, 0.6, z),
			Color = Color3.fromRGB(32, 28, 48),
			Parent = folder,
		})

		makePart({
			Name = "PlotEdge",
			Size = Vector3.new(38, 0.3, 38),
			Position = Vector3.new(x, 1.3, z),
			Color = Color3.fromRGB(130 + i * 12, 50, 255),
			Material = Enum.Material.Neon,
			Transparency = 0.35,
			CanCollide = false,
			Parent = folder,
		})

		makePart({
			Name = "House",
			Size = Vector3.new(14, 10, 2),
			Position = Vector3.new(x, 5.5, z - 10),
			Color = Color3.fromRGB(50, 40, 75),
			Parent = folder,
		})
		makePart({
			Name = "Roof",
			Size = Vector3.new(16, 1.5, 12),
			Position = Vector3.new(x, 11, z - 5),
			Color = Color3.fromRGB(255, 90, 150),
			Material = Enum.Material.Neon,
			Parent = folder,
		})

		local pad = makePart({
			Name = "ClaimPad",
			Size = Vector3.new(9, 0.4, 9),
			Position = Vector3.new(x, 1.3, z + 8),
			Color = Color3.fromRGB(0, 255, 170),
			Material = Enum.Material.Neon,
			Parent = folder,
		})
		pad:SetAttribute("PlotId", i + 1)
	end

	-- Farm pads
	local farms = {
		Vector3.new(80, 0.8, 80),
		Vector3.new(-80, 0.8, 80),
		Vector3.new(80, 0.8, -80),
		Vector3.new(-80, 0.8, -80),
		Vector3.new(0, 0.8, 95),
		Vector3.new(0, 0.8, -95),
	}
	for i, pos in ipairs(farms) do
		local farm = makePart({
			Name = "FarmPad",
			Size = Vector3.new(14, 0.5, 14),
			Position = pos,
			Color = Color3.fromRGB(40, 170, 255),
			Material = Enum.Material.Neon,
			Parent = map,
		})
		farm:SetAttribute("IsFarmPad", true)

		local fbb = Instance.new("BillboardGui")
		fbb.Size = UDim2.fromOffset(110, 36)
		fbb.StudsOffset = Vector3.new(0, 3.5, 0)
		fbb.AlwaysOnTop = true
		fbb.Parent = farm
		local fl = Instance.new("TextLabel")
		fl.Size = UDim2.fromScale(1, 1)
		fl.BackgroundTransparency = 1
		fl.Text = "FARM XP [E]"
		fl.TextColor3 = Color3.fromRGB(120, 220, 255)
		fl.Font = Enum.Font.GothamBold
		fl.TextScaled = true
		fl.Parent = fbb
	end

	-- Spawn
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "MainSpawn"
	spawn.Size = Vector3.new(14, 1, 14)
	spawn.Position = Vector3.new(0, 1.5, 65)
	spawn.Color = Color3.fromRGB(0, 255, 200)
	spawn.Material = Enum.Material.Neon
	spawn.Anchored = true
	spawn.Duration = 0
	spawn.Neutral = true
	spawn.Parent = map

	makePart({
		Name = "SpawnPlat",
		Size = Vector3.new(28, 1, 28),
		Position = Vector3.new(0, 0.5, 65),
		Color = Color3.fromRGB(30, 35, 55),
		Parent = map,
	})

	-- LIGHTING - CLEAR, not muddy
	Lighting.Brightness = 2.2
	Lighting.Ambient = Color3.fromRGB(70, 60, 90)
	Lighting.OutdoorAmbient = Color3.fromRGB(80, 70, 100)
	Lighting.FogColor = Color3.fromRGB(40, 30, 55)
	Lighting.FogStart = 200
	Lighting.FogEnd = 600
	Lighting.ClockTime = 20.5
	Lighting.GlobalShadows = false

	local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
	if not atmo then
		atmo = Instance.new("Atmosphere")
		atmo.Parent = Lighting
	end
	atmo.Density = 0.12
	atmo.Offset = 0.1
	atmo.Color = Color3.fromRGB(90, 70, 130)
	atmo.Decay = Color3.fromRGB(50, 40, 70)
	atmo.Glare = 0.15
	atmo.Haze = 0.4

	local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
	if not bloom then
		bloom = Instance.new("BloomEffect")
		bloom.Parent = Lighting
	end
	bloom.Intensity = 0.6
	bloom.Size = 18
	bloom.Threshold = 0.9

	-- remove heavy color correction if any
	local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
	if cc then cc:Destroy() end

	print("[MapBuilder] Clean neon map built")
end

MapBuilder.Build()
return MapBuilder
