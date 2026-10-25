# Tung Tung Brainrot

Clean neon brainrot tycoon + PvP for Roblox.

## What works
- Neon arena map (clear visibility, light fog)
- TungCoin economy + brainrot shop
- TRANSFORM (visual morph by rarity)
- Farm XP button + **E on blue pads**
- **E on green pads** to claim a base (8 plots)
- Attack nearest / kill / killstreak
- Lucky server events
- Steal brainrots + rebirth

## Studio setup
1. Copy `ServerScriptService` and `StarterPlayer` structure into your place
2. File -> Experience Settings -> Security -> Enable Studio Access to API Services
3. Press Play

## Controls
- **E** near blue pad = Farm XP
- **E** near green pad = Claim base
- UI buttons: Transform, Farm, Attack, Rebirth, buy brainrots

## Structure
```
ServerScriptService/
  Main (Script)
  Modules/ Config, BrainrotData, DataStoreService
  Services/ MapBuilder, PlayerService, BrainrotService,
            CombatService, EventService, PlotService,
            ProximityService, MonetizationService, RemoteService
StarterPlayer/StarterPlayerScripts/
  ClientUI (LocalScript)
```
