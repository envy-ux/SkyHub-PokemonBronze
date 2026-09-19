# Sky Hub • Pokémon Bronze v3

**Executor:** Solora (Android / emulator)  
**PlaceId:** 122591147665527  

## How to run (Solora)

1. Open Solora → Script editor
2. Paste the **full** `SkyHub.lua` (preferred while debugging) **or** run the loader:
   ```lua
   loadstring(game:HttpGet("https://raw.githubusercontent.com/envy-ux/SkyHub-PokemonBronze/main/SkyHub_v3/SkyHub.lua"))()
   ```
3. Execute
4. Watch Solora console for:
   - `[SkyHub] start`
   - `[SkyHub] rayfield ok`
   - `[SkyHub] window ok`
   - `[SkyHub] tabs ok`
   - `[SkyHub] FULLY LOADED`
5. **Open UI:** tap the floating **Sky Hub** ShowText button (no K key needed)

## Features

| Tab | Features |
|-----|----------|
| Main | WalkSpeed, JumpPower, Noclip, Walk on Water, Infinite Repel, Anti-AFK, Heal Party, Open PC |
| Battle | One-Shot Kill toggle + Kill Now, Unlimited HP, God Mode, Auto Battle/Catch, Force Win, Skip Anim, Max Party HP |
| Items | Rare Candy / Master Ball / Ultra Ball / potions / revives (GET/POST + bag tries) |
| Catch | Force 100% Catch, Always Master Ball, Force Master Ball Now, Shiny Only, Run |
| Teleport | Lab, cities, routes, Rejoin, Server Hop |
| Visual | Player ESP, Fullbright, No Fog |
| Misc | FPS Boost, Destroy UI |

## Notes

- No classic `_p` on this PlaceId — all combat/item paths go through `GET` / `POST` / `BattleEvent` / `BattleRequest` / `BattleFunction`
- Client-only movement (speed/noclip) is proven
- One-Shot / Force Catch / Items need a live battle test — report results
- Game F9 asset errors (sounds/animations) are **not** script errors — ignore them
- Use **Solora’s own console** for `[SkyHub]` prints, not Roblox F9

## Files

- `SkyHub.lua` — full hub (Solora-ready)
- `loader.lua` — one-liner loadstring
