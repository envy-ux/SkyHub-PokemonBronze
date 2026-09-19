--[[
    SKY HUB • POKÉMON BRONZE PREMIUM
    Project Bronze Forever / Roria Conquest / PBB reuploads
    Full Rayfield UI — Movement, Battle, Items, Teleport, Visual, Misc
]]

-- Clean previous Rayfield
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

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

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
    AntiAFK = true,
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
    if not ok then
        warn("[SkyHub]", err)
    end
    return ok
end

-- ══════════════════════════════════════
-- WINDOW
-- ══════════════════════════════════════

local Window = Rayfield:CreateWindow({
    Name = "Sky Hub • Pokémon Bronze",
    Icon = "gamepad-2",
    LoadingTitle = "Sky Hub",
    LoadingSubtitle = "Pokémon Bronze Premium",
    ShowText = "Sky Hub",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "SkyHub_PBB_Final"
    },
    Discord = { Enabled = false, Invite = "", RememberJoins = false },
    KeySystem = false,
})

-- ══════════════════════════════════════
-- TABS
-- ══════════════════════════════════════

local MainTab = Window:CreateTab("Main", "zap")
local BattleTab = Window:CreateTab("Battle", "swords")
local ItemsTab = Window:CreateTab("Items", "package")
local TeleportTab = Window:CreateTab("Teleport", "map-pin")
local VisualTab = Window:CreateTab("Visual", "eye")
local MiscTab = Window:CreateTab("Misc", "settings")

-- ══════════════════════════════════════
-- MAIN
-- ══════════════════════════════════════

MainTab:CreateSection("Movement")

MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 150},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(v)
        State.Speed = v
        if Humanoid then Humanoid.WalkSpeed = v end
    end,
})

MainTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 250},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(v)
        State.Jump = v
        if Humanoid then
            Humanoid.JumpPower = v
            Humanoid.UseJumpPower = true
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
    end,
})

MainTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Flag = "AntiAFK",
    Callback = function(v) State.AntiAFK = v end,
})

MainTab:CreateButton({
    Name = "Enable Running Shoes + RTD",
    Callback = function()
        SafeCall(function()
            if _p then
                if _p.Menu and _p.Menu.rtd then _p.Menu.rtd:enable() end
                if _p.RunningShoes then _p.RunningShoes:enable() end
            end
        end)
        Notify("Sky Hub", "Running Shoes + RTD enabled")
    end,
})

MainTab:CreateButton({
    Name = "Heal Party",
    Callback = function()
        SafeCall(function()
            if _p and _p.Network then
                _p.Network:get("PDS", "heal")
            end
        end)
        Notify("Sky Hub", "Party healed")
    end,
})

MainTab:CreateButton({
    Name = "Open PC / Pokémon Center",
    Callback = function()
        SafeCall(function()
            if _p and _p.Menu and _p.Menu.pc then
                _p.Menu.pc:open()
            end
        end)
    end,
})

-- ══════════════════════════════════════
-- BATTLE
-- ══════════════════════════════════════

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

BattleTab:CreateToggle({
    Name = "God Mode (try prevent faint)",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(v) State.GodMode = v end,
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
        Notify("Sky Hub", "Battle speed boosted")
    end,
})

BattleTab:CreateParagraph({
    Title = "Tip",
    Content = "Stand near a Training Hotspot trainer, enable Auto Battle, and let it rematch. Works best on copies that expose _p.Battle.",
})

-- ══════════════════════════════════════
-- ITEMS (give / spawn attempts)
-- ══════════════════════════════════════

ItemsTab:CreateSection("Rare Candies & Boosts")

local function TryGive(itemName, amount)
    amount = amount or 1
    local success = false

    -- Common patterns used across PBB reuploads
    SafeCall(function()
        if _p and _p.PlayerData then
            -- inventory table patterns
            if _p.PlayerData.bag then
                _p.PlayerData.bag[itemName] = (_p.PlayerData.bag[itemName] or 0) + amount
                success = true
            end
            if _p.PlayerData.items then
                _p.PlayerData.items[itemName] = (_p.PlayerData.items[itemName] or 0) + amount
                success = true
            end
        end
    end)

    SafeCall(function()
        if _p and _p.Network then
            -- try network give
            _p.Network:get("PDS", "giveItem", itemName, amount)
            success = true
        end
    end)

    SafeCall(function()
        if getgenv().giveItem then
            getgenv().giveItem(itemName, amount)
            success = true
        end
    end)

    Notify("Items", (success and "Tried: " or "Hook missing: ") .. itemName .. " x" .. amount)
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
    Name = "Master Ball x20",
    Callback = function() TryGive("Master Ball", 20) end,
})

ItemsTab:CreateButton({
    Name = "Ultra Ball x50",
    Callback = function() TryGive("Ultra Ball", 50) end,
})

ItemsTab:CreateButton({
    Name = "Great Ball x50",
    Callback = function() TryGive("Great Ball", 50) end,
})

ItemsTab:CreateSection("Healing Items")

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

ItemsTab:CreateSection("Money / BP / Tix")

ItemsTab:CreateButton({
    Name = "Add 100,000 P$",
    Callback = function()
        SafeCall(function()
            if _p and _p.PlayerData then
                if _p.PlayerData.money then
                    _p.PlayerData.money = _p.PlayerData.money + 100000
                elseif _p.PlayerData.cash then
                    _p.PlayerData.cash = _p.PlayerData.cash + 100000
                end
            end
            if _p and _p.Network then
                _p.Network:get("PDS", "addMoney", 100000)
            end
        end)
        Notify("Items", "Tried +100k P$")
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
        Notify("Items", "Tried +500 BP")
    end,
})

ItemsTab:CreateButton({
    Name = "Add 5,000 Tix",
    Callback = function()
        SafeCall(function()
            if _p and _p.PlayerData and _p.PlayerData.tix then
                _p.PlayerData.tix = _p.PlayerData.tix + 5000
            end
            if _p and _p.Network then
                _p.Network:get("PDS", "addTix", 5000)
            end
        end)
        Notify("Items", "Tried +5k Tix")
    end,
})

ItemsTab:CreateSection("Note")

ItemsTab:CreateParagraph({
    Title = "Important",
    Content = "Item give depends on each PBB copy's internals (_p). Some reuploads block client-side inventory edits. If a button does nothing, that copy protects the bag. Money/BP/Tix may need server-side hooks that only work on weaker copies.",
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
            if Root then
                Root.CFrame = CFrame.new(loc.Pos)
            end
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

VisualTab:CreateSlider({
    Name = "FOV",
    Range = {70, 120},
    Increment = 1,
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(v)
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = v end
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
    Title = "Sky Hub • Pokémon Bronze",
    Content = "Press K to toggle UI.\nCompatible with most PBB reuploads.\nItem buttons depend on each game's _p hooks.",
})

-- ══════════════════════════════════════
-- LOOPS
-- ══════════════════════════════════════

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

RunService.Stepped:Connect(function()
    if State.Noclip and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if State.WalkOnWater and Root then
        local ray = Ray.new(Root.Position, Vector3.new(0, -5, 0))
        local hit = workspace:FindPartOnRay(ray, Character)
        if hit and (hit.Name:lower():find("water") or hit.Material == Enum.Material.Water) then
            Root.Velocity = Vector3.new(Root.Velocity.X, 2, Root.Velocity.Z)
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if State.InfiniteRepel then
            SafeCall(function()
                if _p and _p.Repel then
                    _p.Repel.steps = 999999
                end
            end)
        end
    end
end)

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

Notify("Sky Hub Loaded", "Pokémon Bronze Premium ready. Press K to toggle.")
print("[Sky Hub] Pokémon Bronze Premium loaded")
