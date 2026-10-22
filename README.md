# 🦧 Brainrot Cheese 🦠

**Meme & Italian Brainrot themed Roblox game** — collect absurd brainrots, they print cash (cheese), upgrade, steal vibes, and monetize with Game Passes.

Made for maximum Gen Alpha chaos + real Robux cheese.

## How to use this in Roblox Studio

1. Open **Roblox Studio** → New Baseplate
2. Create folders in **ServerScriptService**:
   - `Modules`
   - `Services`
3. Copy the scripts from this repo into the right places (see structure below)
4. In **Workspace** create a folder called `Brainrots` (for models later)
5. Publish the place and enable monetization in Creator Hub

## Project Structure

```
ServerScriptService/
  ├─ Services/
  │   ├─ PlayerService.lua          # Leaderstats + data
  │   ├─ BrainrotService.lua        # Spawn & income logic
  │   └─ MonetizationService.lua    # Game Passes & Dev Products
  └─ Modules/
      ├─ BrainrotData.lua           # All the meme characters
      └─ Config.lua                 # Prices, rates, etc.

StarterPlayer/StarterPlayerScripts/
  └─ ClientUI.lua                   # Simple GUI (optional)
```

## Core Loop (easy money)

1. Player joins → gets free starter brainrot
2. Brainrots generate **Cheese** every second
3. Buy better brainrots with Cheese
4. Game Passes: 2x Cheese, VIP, Auto Collect, etc.
5. Developer Products: Cheese packs

## Popular Brainrots included
- Tralalero Tralala
- Tung Tung Tung Sahur
- Bombardiro Crocodilo
- Ballerina Cappuccina
- Strawberry Elephant
- and more pure chaos

## Monetization ready
Scripts include placeholders for Game Pass IDs. Just create them in Creator Hub and paste the IDs.

## Next steps I can add
- Full tycoon plot system
- Stealing from other players
- Rebirth system
- More brainrots + mutations
- Proper UI with TweenService
- DataStore saving

Just tell me what you want next and I’ll push more code.

**Let’s make some cheese.** 🦠
