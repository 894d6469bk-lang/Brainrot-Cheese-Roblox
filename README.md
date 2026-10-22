# \ud83e\udda7 Brainrot Cheese - Roblox Game

Viral meme/brainrot tycoon + PvP combat game. Collect brainrots, farm cheese, **transform into a brainrot**, farm XP & Power, and **kill other players**.

## Current Features (Oct 2026 meta)

### Core Loop
- Collect & buy brainrots (income generators)
- Steal other players' brainrots
- Offline earnings (up to 8 hours)
- Rebirth system for permanent multipliers

### NEW: Combat System (the viral part)
- **TRANSFORM** into one of your brainrots (power multiplier based on rarity)
- **FARM XP** actively + passive XP while transformed
- Level up \u2192 gain Power
- **ATTACK** nearest players \u2192 deal damage based on Power
- **KILL** players for Cheese + XP + steal some of their Power
- Death penalty: lose a small % of cheese (keeps tension high)

### Brainrots included
Common \u2192 Secret: Noobini Pizzanini, Tralalero Tralala, Tung Tung Sahur, Strawberry Elephant, Phoenix, 67, Smurf Cat, Headless Horseman and more.

## How to use in Roblox Studio

1. Create a new place or open yours
2. Copy the folder structure into ServerScriptService and StarterPlayer
3. Enable API Services (for DataStore)
4. Replace Game Pass / Dev Product IDs in `Config.lua` with your own
5. Playtest!

## Structure
```
ServerScriptService/
  Main.server.lua
  Modules/
    Config.lua
    BrainrotData.lua
    DataStoreService.lua
  Services/
    PlayerService.lua
    BrainrotService.lua
    CombatService.lua      <-- NEW
    MonetizationService.lua
    RemoteService.lua
StarterPlayer/
  StarterPlayerScripts/
    ClientUI.client.lua
```

## Next steps to make it fire
- Add actual character morphs / particle effects when transforming
- Arena / safe zone for bases
- Lucky blocks & server events
- More monetization (2x XP, Power boost passes)
- Mobile-friendly controls

Let's print cheese. \ud83e\udda7\ud83d\udcb0
