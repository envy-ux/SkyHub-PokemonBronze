# Sky Hub • Pokémon Bronze v3

## Load

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/envy-ux/SkyHub-PokemonBronze/main/SkyHub_v3/SkyHub.lua"))()
```

Or use `loader.lua` from this folder (same URL).

## New in v3
- **One-Shot Kill** (toggle + Kill Enemy Now button)
- **Force 100% Catch** (any ball)
- **Always Throw Master Ball**
- GET / POST + Battle remote paths for PlaceId `122591147665527`
- Legacy `_p` still supported if present

## Tabs
Main · Battle · Items · Catch · Teleport · Visual · Misc

Press **K** to toggle UI.

### Battle
- One-Shot Kill (enemy HP → 0 loop)
- Unlimited Pokémon HP / God Mode
- Auto Battle / Auto Catch
- Force Win · Skip Anim · Max Party HP

### Catch
- Force 100% Catch
- Always Master Ball
- Force Master Ball Catch Now
- Force Any Ball Success Now
- Shiny Only · Run

### Items
Rare Candy · Master Ball · Ultra/Great/Quick · Max Potion · Full Restore · Revive · Money / BP / Tix

### Note
This reupload does not expose classic `_p`. Features fire every known remote path (GET, POST, BattleFunction, BattleEvent, BattleRequest). Some actions stay client-side only if the server owns the data.

### Files
| File | Purpose |
|------|---------|
| `SkyHub.lua` | Main script |
| `loader.lua` | One-line loadstring |
| `README.md` | This file |
