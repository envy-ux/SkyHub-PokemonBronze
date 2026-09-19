--[[
    SKY HUB • POKÉMON BRONZE PREMIUM v3
    PlaceId target: 122591147665527 (+ other PBB / Project Bronze reuploads)
    New: One-Shot Kill • Force 100% Catch / Master Ball
    GET/POST + Battle remote aware (no classic _p required)
]]

pcall(function()
    local old = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    old:Destroy()
end)
task.wait(0.25)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local RS = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local Humanoid, Root
if Character then
    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    Root = Character:FindFirstChild("HumanoidRootPart")
end
if not Character then
    task.spawn(function()
        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        Humanoid = Character:WaitForChild("Humanoid")
        Root = Character:WaitForChild("HumanoidRootPart")
    end)
end

local State = {
    Speed = 16,
    Jump = 50,
    InfiniteRepel = false,
    AutoBattle = false,
    AutoCatch = false,
    WalkOnWater = false,
    Noclip = false,
    ESP = false,
    GodMode = false,
    UnlimitedHP = false,
    ShinyOnly = false,
    AntiAFK = true,
    OneShotKill = false,
    ForceCatch = false,
    AlwaysMasterBall = false,
}

local function Notify(title, content)
    pcall(function()
        Rayfield:Notify({
            Title = title or "Sky Hub",
            Content = content or "",
            Duration = 3,
            Image = "check",
        })
    end)
end

local function SafeCall(fn)
    local ok, err = pcall(fn)
    if not ok then warn("[SkyHub]", err) end
    return ok
end

-- ══════════════════════════════════════
-- REMOTE HELPERS (PlaceId 122591147665527 style)
-- ══════════════════════════════════════

local function GetRemote(name)
    local folder = RS:FindFirstChild("Remote")
    if folder then
        local r = folder:FindFirstChild(name)
        if r then return r end
    end
    return RS:FindFirstChild(name)
end

local function InvokeGET(...)
    local ok, res = pcall(function()
        local g = RS:FindFirstChild("GET")
        if g and g:IsA("RemoteFunction") then
            return g:InvokeServer(...)
        end
    end)
    return ok and res or nil
end

local function FirePOST(...)
    SafeCall(function()
        local p = RS:FindFirstChild("POST")
        if p and p:IsA("RemoteEvent") then
            p:FireServer(...)
        end
    end)
end

local function BattleInvoke(...)
    local ok, res = pcall(function()
        local bf = GetRemote("BattleFunction")
        if bf and bf:IsA("RemoteFunction") then
            return bf:InvokeServer(...)
        end
    end)
    return ok and res or nil
end

local function BattleFire(...)
    SafeCall(function()
        local be = GetRemote("BattleEvent")
        if be and be:IsA("RemoteEvent") then
            be:FireServer(...)
        end
        local br = GetRemote("BattleRequest")
        if br and br:IsA("RemoteEvent") then
            br:FireServer(...)
        end
    end)
end

-- try resolve legacy _p if any copy still has it
local _p = rawget(getgenv(), "_p") or rawget(_G, "_p") or rawget(shared, "_p")

-- ══════════════════════════════════════
-- WINDOW
-- ══════════════════════════════════════

local Window = Rayfield:CreateWindow({
    Name = "Sky Hub • Pokémon Bronze v3",
    Icon = 0,
    LoadingTitle = "Sky Hub",
    LoadingSubtitle = "Pokémon Bronze Premium v3",
    ShowText = "Sky Hub",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "SkyHub_PBB_v3"
    },
    Discord = { Enabled = false, Invite = "", RememberJoins = false },
    KeySystem = false,
})

local MainTab = Window:CreateTab("Main", "zap")
local BattleTab = Window:CreateTab("Battle", "swords")
local ItemsTab = Window:CreateTab("Items", "package")
local CatchTab = Window:CreateTab("Catch", "sparkles")
local TeleportTab = Window:CreateTab("Teleport", "map-pin")
local VisualTab = Window:CreateTab("Visual", "eye")
local MiscTab = Window:CreateTab("Misc", "settings")

-- ══════════════════════════════════════
-- MAIN
-- ══════════════════════════════════════

MainTab:CreateSection("Movement")

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Flag = "Speed",
    Callback = function(v)
        State.Speed = v
        if Humanoid then Humanoid.WalkSpeed = v end
    end,
})

MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 5,
    CurrentValue = 50,
    Flag = "Jump",
    Callback = function(v)
        State.Jump = v
        if Humanoid then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = v
        end
    end,
})

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(v) State.Noclip = v end,
})

MainTab:CreateToggle({
    Name = "Walk on Water",
    CurrentValue = false,
    Flag = "WalkOnWater",
    Callback = function(v) State.WalkOnWater = v end,
})

MainTab:CreateSection("Utility")

MainTab:CreateToggle({
    Name = "Infinite Repel",
    CurrentValue = false,
    Flag = "InfiniteRepel",
    Callback = function(v)
        State.InfiniteRepel = v
        SafeCall(function()
            if _p and _p.Repel then
                _p.Repel.steps = v and 999999 or 0
            end
        end)
        -- also try GET/POST path
        if v then
            FirePOST("repel", 999999)
            InvokeGET("repel", 999999)
        end
    end,
})

MainTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Flag = "AntiAFK",
    Callback = function(v) State.AntiAFK = v end,
})

MainTab:CreateButton({
    Name = "Heal Party",
    Callback = function()
        SafeCall(function()
            if _p and _p.Network then
                _p.Network:get("PDS", "heal")
            end
        end)
        InvokeGET("heal")
        FirePOST("heal")
        BattleFire("heal")
        SafeCall(function()
            if _p and _p.PlayerData and _p.PlayerData.party then
                for _, mon in pairs(_p.PlayerData.party) do
                    if type(mon) == "table" and mon.maxHP then
                        mon.hp = mon.maxHP
                        mon.HP = mon.maxHP
                        mon.currentHP = mon.maxHP
                    end
                end
            end
        end)
        Notify("Sky Hub", "Party heal attempted")
    end,
})

MainTab:CreateButton({
    Name = "Open PC",
    Callback = function()
        SafeCall(function()
            if _p and _p.Menu and _p.Menu.pc then
                _p.Menu.pc:open()
            end
        end)
        FirePOST("openPC")
        InvokeGET("openPC")
        Notify("Sky Hub", "PC open attempted")
    end,
})

-- ══════════════════════════════════════
-- BATTLE + ONE-SHOT KILL + UNLIMITED HP
-- ══════════════════════════════════════

BattleTab:CreateSection("One-Shot Kill")

BattleTab:CreateToggle({
    Name = "One-Shot Kill (enemy HP → 0)",
    CurrentValue = false,
    Flag = "OneShotKill",
    Callback = function(v)
        State.OneShotKill = v
        Notify("Battle", v and "One-Shot Kill ON" or "One-Shot Kill OFF")
    end,
})

BattleTab:CreateButton({
    Name = "Kill Enemy Now",
    Callback = function()
        SafeCall(function()
            -- legacy
            if _p and _p.Battle and _p.Battle.currentBattle then
                local b = _p.Battle.currentBattle
                if b.foeSide and b.foeSide.active then
                    for _, mon in pairs(b.foeSide.active) do
                        if type(mon) == "table" then
                            mon.hp = 0
                            mon.HP = 0
                            mon.currentHP = 0
                            mon.fainted = true
                        end
                    end
                end
            end
        end)
        -- remote paths
        BattleFire("kill")
        BattleFire("faint")
        BattleFire("oneShot")
        BattleInvoke("kill")
        BattleInvoke("setHP", 0)
        FirePOST("battle", "kill")
        FirePOST("setEnemyHP", 0)
        Notify("Battle", "Kill Enemy fired")
    end,
})

BattleTab:CreateSection("Unlimited HP / God Mode")

BattleTab:CreateToggle({
    Name = "Unlimited Pokémon HP",
    CurrentValue = false,
    Flag = "UnlimitedHP",
    Callback = function(v)
        State.UnlimitedHP = v
        Notify("Sky Hub", v and "Unlimited HP ON" or "Unlimited HP OFF")
    end,
})

BattleTab:CreateToggle({
    Name = "God Mode (battle)",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(v) State.GodMode = v end,
})

BattleTab:CreateSection("Auto")

BattleTab:CreateToggle({
    Name = "Auto Battle (Rematch)",
    CurrentValue = false,
    Flag = "AutoBattle",
    Callback = function(v) State.AutoBattle = v end,
})

BattleTab:CreateToggle({
    Name = "Auto Catch",
    CurrentValue = false,
    Flag = "AutoCatch",
    Callback = function(v) State.AutoCatch = v end,
})

BattleTab:CreateSection("Actions")

BattleTab:CreateButton({
    Name = "Force Win / Forfeit",
    Callback = function()
        SafeCall(function()
            if _p and _p.Battle and _p.Battle.currentBattle then
                _p.Battle.currentBattle:forfeit()
            end
        end)
        BattleFire("forfeit")
        BattleFire("run")
        BattleInvoke("forfeit")
        Notify("Sky Hub", "Force battle end attempted")
    end,
})

BattleTab:CreateButton({
    Name = "Skip Battle Animation",
    Callback = function()
        SafeCall(function()
            if _p and _p.Battle then
                _p.Battle.speed = 10
            end
        end)
        BattleFire("speed", 10)
        Notify("Sky Hub", "Battle speed boosted")
    end,
})

BattleTab:CreateButton({
    Name = "Max All Party HP Now",
    Callback = function()
        SafeCall(function()
            if _p and _p.PlayerData and _p.PlayerData.party then
                for _, mon in pairs(_p.PlayerData.party) do
                    if type(mon) == "table" and mon.maxHP then
                        mon.hp = mon.maxHP
                        mon.HP = mon.maxHP
                        mon.currentHP = mon.maxHP
                    end
                end
            end
        end)
        FirePOST("maxPartyHP")
        InvokeGET("maxPartyHP")
        Notify("Sky Hub", "Party HP maxed")
    end,
})

-- ══════════════════════════════════════
-- ITEMS
-- ══════════════════════════════════════

ItemsTab:CreateSection("Rare Candies")

local function TryGive(itemName, amount)
    local ok = false

    SafeCall(function()
        if _p and _p.PlayerData then
            if _p.PlayerData.bag then
                _p.PlayerData.bag[itemName] = (_p.PlayerData.bag[itemName] or 0) + amount
                ok = true
            end
            if _p.PlayerData.items then
                _p.PlayerData.items[itemName] = (_p.PlayerData.items[itemName] or 0) + amount
                ok = true
            end
            if _p.PlayerData.inventory then
                _p.PlayerData.inventory[itemName] = (_p.PlayerData.inventory[itemName] or 0) + amount
                ok = true
            end
        end
    end)

    SafeCall(function()
        if _p and _p.Network then
            _p.Network:get("PDS", "giveItem", itemName, amount)
            _p.Network:post("PDS", "giveItem", itemName, amount)
            ok = true
        end
    end)

    -- modern GET/POST paths for this PlaceId
    local r1 = InvokeGET("giveItem", itemName, amount)
    local r2 = InvokeGET("item", itemName, amount)
    FirePOST("giveItem", itemName, amount)
    FirePOST("item", itemName, amount)
    FirePOST("addItem", itemName, amount)
    if r1 or r2 then ok = true end

    SafeCall(function()
        if getgenv().giveItem then
            getgenv().giveItem(itemName, amount)
            ok = true
        end
    end)

    Notify("Items", (ok and "Tried give: " or "No confirmed hook: ") .. itemName .. " x" .. tostring(amount))
end

ItemsTab:CreateButton({
    Name = "Rare Candy x50",
    Callback = function() TryGive("Rare Candy", 50) end,
})

ItemsTab:CreateButton({
    Name = "Rare Candy x200",
    Callback = function() TryGive("Rare Candy", 200) end,
})

ItemsTab:CreateButton({
    Name = "Rare Candy x999",
    Callback = function() TryGive("Rare Candy", 999) end,
})

ItemsTab:CreateSection("Balls")

ItemsTab:CreateButton({
    Name = "Master Ball x20",
    Callback = function() TryGive("Master Ball", 20) end,
})

ItemsTab:CreateButton({
    Name = "Master Ball x100",
    Callback = function() TryGive("Master Ball", 100) end,
})

ItemsTab:CreateButton({
    Name = "Ultra Ball x50",
    Callback = function() TryGive("Ultra Ball", 50) end,
})

ItemsTab:CreateButton({
    Name = "Great Ball x50",
    Callback = function() TryGive("Great Ball", 50) end,
})

ItemsTab:CreateButton({
    Name = "Quick Ball x30",
    Callback = function() TryGive("Quick Ball", 30) end,
})

ItemsTab:CreateSection("Healing")

ItemsTab:CreateButton({
    Name = "Max Potion x30",
    Callback = function() TryGive("Max Potion", 30) end,
})

ItemsTab:CreateButton({
    Name = "Full Restore x30",
    Callback = function() TryGive("Full Restore", 30) end,
})

ItemsTab:CreateButton({
    Name = "Revive x20",
    Callback = function() TryGive("Revive", 20) end,
})

ItemsTab:CreateButton({
    Name = "Max Revive x15",
    Callback = function() TryGive("Max Revive", 15) end,
})

ItemsTab:CreateSection("Currency")

ItemsTab:CreateButton({
    Name = "Add $100000",
    Callback = function()
        SafeCall(function()
            if _p and _p.PlayerData then
                if _p.PlayerData.money then _p.PlayerData.money = _p.PlayerData.money + 100000 end
                if _p.PlayerData.cash then _p.PlayerData.cash = _p.PlayerData.cash + 100000 end
            end
            if _p and _p.Network then
                _p.Network:get("PDS", "addMoney", 100000)
            end
        end)
        FirePOST("addMoney", 100000)
        InvokeGET("addMoney", 100000)
        Notify("Items", "Money add attempted")
    end,
})

ItemsTab:CreateButton({
    Name = "Add 500 BP",
    Callback = function()
        SafeCall(function()
            if _p and _p.PlayerData and _p.PlayerData.bp then
                _p.PlayerData.bp = _p.PlayerData.bp + 500
            end
            if _p and _p.Network then
                _p.Network:get("PDS", "addBP", 500)
            end
        end)
        FirePOST("addBP", 500)
        Notify("Items", "BP add attempted")
    end,
})

ItemsTab:CreateButton({
    Name = "Add 5000 Tix",
    Callback = function()
        SafeCall(function()
            if _p and _p.PlayerData and _p.PlayerData.tix then
                _p.PlayerData.tix = _p.PlayerData.tix + 5000
            end
            if _p and _p.Network then
                _p.Network:get("PDS", "addTix", 5000)
            end
        end)
        FirePOST("addTix", 5000)
        Notify("Items", "Tix add attempted")
    end,
})

ItemsTab:CreateParagraph({
    Title = "Item note",
    Content = "This copy uses GET/POST remotes. Client bag edits may be ignored if the server owns inventory. Buttons still fire every known path.",
})

-- ══════════════════════════════════════
-- CATCH / FORCE 100% / MASTER BALL
-- ══════════════════════════════════════

CatchTab:CreateSection("Force Catch (100%)")

CatchTab:CreateToggle({
    Name = "Force 100% Catch (any ball)",
    CurrentValue = false,
    Flag = "ForceCatch",
    Callback = function(v)
        State.ForceCatch = v
        Notify("Catch", v and "Force 100% Catch ON" or "Force 100% Catch OFF")
    end,
})

CatchTab:CreateToggle({
    Name = "Always Throw Master Ball",
    CurrentValue = false,
    Flag = "AlwaysMasterBall",
    Callback = function(v)
        State.AlwaysMasterBall = v
        Notify("Catch", v and "Always Master Ball ON" or "Always Master Ball OFF")
    end,
})

CatchTab:CreateButton({
    Name = "Force Master Ball Catch Now",
    Callback = function()
        -- every known throw path
        SafeCall(function()
            if _p and _p.Battle then
                if _p.Battle.throwBall then _p.Battle:throwBall("Master Ball") end
                if _p.Battle.currentBattle and _p.Battle.currentBattle.throwBall then
                    _p.Battle.currentBattle:throwBall("Master Ball")
                end
            end
        end)
        BattleFire("throwBall", "Master Ball")
        BattleFire("catch", "Master Ball")
        BattleFire("ball", "Master Ball")
        BattleInvoke("throwBall", "Master Ball")
        BattleInvoke("catch", "Master Ball")
        FirePOST("throwBall", "Master Ball")
        FirePOST("catch", "Master Ball")
        InvokeGET("throwBall", "Master Ball")
        Notify("Catch", "Force Master Ball fired")
    end,
})

CatchTab:CreateButton({
    Name = "Force Any Ball Success Now",
    Callback = function()
        BattleFire("forceCatch")
        BattleFire("catchSuccess")
        BattleFire("setCatchRate", 255)
        BattleInvoke("forceCatch")
        BattleInvoke("setCatchRate", 255)
        FirePOST("forceCatch")
        FirePOST("catchRate", 255)
        Notify("Catch", "Force catch success fired")
    end,
})

CatchTab:CreateSection("Shiny Catcher")

CatchTab:CreateToggle({
    Name = "Shiny Only Mode",
    CurrentValue = false,
    Flag = "ShinyOnly",
    Callback = function(v)
        State.ShinyOnly = v
        Notify("Catch", v and "Shiny Only ON" or "Shiny Only OFF")
    end,
})

CatchTab:CreateToggle({
    Name = "Auto Catch (any)",
    CurrentValue = false,
    Flag = "AutoCatch2",
    Callback = function(v) State.AutoCatch = v end,
})

CatchTab:CreateButton({
    Name = "Run From Battle",
    Callback = function()
        SafeCall(function()
            if _p and _p.Battle and _p.Battle.currentBattle then
                if _p.Battle.currentBattle.run then
                    _p.Battle.currentBattle:run()
                elseif _p.Battle.run then
                    _p.Battle:run()
                end
            end
        end)
        BattleFire("run")
        BattleInvoke("run")
        Notify("Catch", "Run attempted")
    end,
})

CatchTab:CreateParagraph({
    Title = "Catch tip",
    Content = "Force 100% + Always Master Ball work best together. One-Shot Kill is under Battle tab. All paths fire GET/POST + Battle remotes for this PlaceId.",
})

-- ══════════════════════════════════════
-- TELEPORT
-- ══════════════════════════════════════

TeleportTab:CreateSection("Locations")

local Locations = {
    {Name = "Pokémon Lab", Pos = Vector3.new(0, 5, 0)},
    {Name = "Silvent City", Pos = Vector3.new(150, 5, 200)},
    {Name = "Rosecove City", Pos = Vector3.new(400, 5, 100)},
    {Name = "Anthian City", Pos = Vector3.new(600, 5, -50)},
    {Name = "Battle Colosseum", Pos = Vector3.new(800, 5, 300)},
    {Name = "Victory Road", Pos = Vector3.new(1000, 5, 500)},
    {Name = "Dig Site", Pos = Vector3.new(250, 5, -200)},
    {Name = "Route 1", Pos = Vector3.new(50, 5, 50)},
}

for _, loc in ipairs(Locations) do
    TeleportTab:CreateButton({
        Name = loc.Name,
        Callback = function()
            if Root then Root.CFrame = CFrame.new(loc.Pos) end
            Notify("Teleport", "→ " .. loc.Name)
        end,
    })
end

TeleportTab:CreateSection("Server")

TeleportTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

TeleportTab:CreateButton({
    Name = "Server Hop (low players)",
    Callback = function()
        SafeCall(function()
            local data = HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=50"
            ))
            for _, s in ipairs(data.data or {}) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                    break
                end
            end
        end)
    end,
})

-- ══════════════════════════════════════
-- VISUAL
-- ══════════════════════════════════════

VisualTab:CreateSection("ESP & Light")

VisualTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(v) State.ESP = v end,
})

VisualTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(v)
        if v then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end
    end,
})

VisualTab:CreateToggle({
    Name = "No Fog",
    CurrentValue = false,
    Flag = "NoFog",
    Callback = function(v)
        Lighting.FogEnd = v and 100000 or 1000
    end,
})

-- ══════════════════════════════════════
-- MISC
-- ══════════════════════════════════════

MiscTab:CreateSection("Performance")

MiscTab:CreateButton({
    Name = "FPS Boost",
    Callback = function()
        SafeCall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                end
            end
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
        end)
        Notify("Sky Hub", "FPS Boost applied")
    end,
})

MiscTab:CreateSection("Player")

MiscTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        if Humanoid then Humanoid.Health = 0 end
    end,
})

MiscTab:CreateParagraph({
    Title = "Sky Hub v3",
    Content = "Press K to toggle.\nOne-Shot Kill + Force 100% Catch + Always Master Ball added.\nTargets GET/POST + Battle remotes for PlaceId 122591147665527.",
})

-- ══════════════════════════════════════
-- LOOPS
-- ══════════════════════════════════════

-- Unlimited HP + One-Shot Kill loop
task.spawn(function()
    while task.wait(0.12) do
        if State.UnlimitedHP or State.GodMode then
            SafeCall(function()
                if _p and _p.PlayerData and _p.PlayerData.party then
                    for _, mon in pairs(_p.PlayerData.party) do
                        if type(mon) == "table" and mon.maxHP then
                            mon.hp = mon.maxHP
                            mon.HP = mon.maxHP
                            mon.currentHP = mon.maxHP
                            if mon.fainted then mon.fainted = false end
                        end
                    end
                end
                if _p and _p.Battle and _p.Battle.currentBattle then
                    local b = _p.Battle.currentBattle
                    if b.yourSide and b.yourSide.active then
                        for _, mon in pairs(b.yourSide.active) do
                            if type(mon) == "table" and mon.maxHP then
                                mon.hp = mon.maxHP
                                mon.HP = mon.maxHP
                            end
                        end
                    end
                end
            end)
        end

        if State.OneShotKill then
            SafeCall(function()
                if _p and _p.Battle and _p.Battle.currentBattle then
                    local b = _p.Battle.currentBattle
                    if b.foeSide and b.foeSide.active then
                        for _, mon in pairs(b.foeSide.active) do
                            if type(mon) == "table" then
                                mon.hp = 0
                                mon.HP = 0
                                mon.currentHP = 0
                                mon.fainted = true
                            end
                        end
                    end
                end
            end)
            -- keep pressure on remote path
            BattleFire("setEnemyHP", 0)
        end
    end
end)

-- Force Catch / Always Master Ball loop
task.spawn(function()
    while task.wait(0.35) do
        if State.AlwaysMasterBall or State.ForceCatch or State.AutoCatch then
            if State.AlwaysMasterBall then
                BattleFire("throwBall", "Master Ball")
                BattleInvoke("throwBall", "Master Ball")
                FirePOST("throwBall", "Master Ball")
            end
            if State.ForceCatch then
                BattleFire("forceCatch")
                BattleFire("setCatchRate", 255)
                BattleInvoke("forceCatch")
                FirePOST("forceCatch")
            end
            if State.AutoCatch and not State.AlwaysMasterBall then
                BattleFire("throwBall", "Ultra Ball")
                BattleFire("catch")
            end
        end
    end
end)

-- Speed / Jump keep
RunService.Heartbeat:Connect(function()
    if not Character or not Humanoid or not Root then return end
    if State.Speed ~= 16 and Humanoid.WalkSpeed ~= State.Speed then
        Humanoid.WalkSpeed = State.Speed
    end
    if State.Jump ~= 50 then
        Humanoid.JumpPower = State.Jump
        Humanoid.UseJumpPower = true
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if State.Noclip and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Walk on water
RunService.Heartbeat:Connect(function()
    if State.WalkOnWater and Root then
        local ray = Ray.new(Root.Position, Vector3.new(0, -5, 0))
        local hit = workspace:FindPartOnRay(ray, Character)
        if hit and (hit.Name:lower():find("water") or hit.Material == Enum.Material.Water) then
            Root.Velocity = Vector3.new(Root.Velocity.X, 2, Root.Velocity.Z)
        end
    end
end)

-- Infinite Repel
task.spawn(function()
    while task.wait(2) do
        if State.InfiniteRepel then
            SafeCall(function()
                if _p and _p.Repel then
                    _p.Repel.steps = 999999
                end
            end)
            FirePOST("repel", 999999)
        end
    end
end)

-- Anti-AFK
task.spawn(function()
    while task.wait(60) do
        if State.AntiAFK then
            SafeCall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
end)

-- ESP
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "SkyHubESP"
ESPFolder.Parent = CoreGui

RunService.RenderStepped:Connect(function()
    if not State.ESP then
        for _, c in pairs(ESPFolder:GetChildren()) do c:Destroy() end
        return
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPFolder:FindFirstChild(plr.Name) then
                local bill = Instance.new("BillboardGui")
                bill.Name = plr.Name
                bill.Adornee = plr.Character.HumanoidRootPart
                bill.Size = UDim2.new(0, 100, 0, 30)
                bill.StudsOffset = Vector3.new(0, 3, 0)
                bill.AlwaysOnTop = true
                bill.Parent = ESPFolder
                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Text = plr.Name
                txt.TextColor3 = Color3.fromRGB(255, 180, 50)
                txt.TextSize = 12
                txt.Font = Enum.Font.GothamBold
                txt.Parent = bill
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    Root = char:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    if State.Speed ~= 16 then Humanoid.WalkSpeed = State.Speed end
    if State.Jump ~= 50 then
        Humanoid.JumpPower = State.Jump
        Humanoid.UseJumpPower = true
    end
end)

Notify("Sky Hub v3 Loaded", "One-Shot Kill • Force 100% Catch • Master Ball ready. Press K.")
print("[Sky Hub v3] Pokémon Bronze Premium loaded — PlaceId aware")
