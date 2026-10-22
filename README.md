# \ud83d\udd25 Tung Tung Brainrot (Roblox)

Viral brainrot tycoon + PvP. Currency = **Tung Tung Sahur Coin (TungCoin)**.

## Features

### Economy
- Collect brainrots \u2192 earn **TungCoins**/sec
- Steal other players' brainrots
- Rebirth for permanent multipliers
- Offline earnings

### Combat + Visual Morph
- **TRANSFORM** into your strongest brainrot
- Real visual morph: neon body color by rarity, scale up, particle aura, floating name tag
- Farm XP (button + passive while transformed)
- Level \u2192 Power
- Attack & kill players for TungCoins + XP + steal Power

### Gaamato Map (auto-built)
`MapBuilder` runs on server start and creates:
- Neon night atmosphere (fog + bloom)
- Central **Tung Tung Arena** with pillars & monument
- 8 player plots in a circle (bases)
- Farm XP pads around the map
- Spawn plaza

Just hit Play \u2014 no manual map building needed for a solid test environment.

## Structure
```
ServerScriptService/
  Main.server.lua
  Modules/ Config, BrainrotData, DataStoreService
  Services/
    MapBuilder.lua      <-- procedural map
    PlayerService.lua
    BrainrotService.lua
    CombatService.lua    <-- morph + combat
    MonetizationService.lua
    RemoteService.lua
StarterPlayer/StarterPlayerScripts/
  ClientUI.client.lua
```

## Setup in Studio
1. Copy folders into your place
2. Enable API Services (DataStore)
3. Play \u2014 map builds automatically
4. Replace Game Pass / Dev Product IDs in Config.lua

## Next upgrades
- Real custom character models per brainrot (MeshParts / accessories)
- Plot claiming system tied to player
- Safe zones on plots
- More map props & music

Print TungCoins. \ud83d\udd25\ud83d\udcb0
