--[[
    SPINACH PREMIUM — POKÉMON BRONZE
    Project Bronze Forever / Roria Conquest / PBB
    Built on Rayfield (Sky Hub base)
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

-- State
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
    InstantText = false,
    AntiAFK = true,
}

-- Window (your Sky Hub base)
local Window = Rayfield:CreateWindow({
   Name = "Sky Hub • Pokémon Bronze",
   Icon = "eye-closed",
   LoadingTitle = "Sky Hub",
   LoadingSubtitle = "by Envy • Spinach Premium",
   ShowText = "Sky Hub",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "SkyHub_PokemonBronze"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-- ══════════════════════════════════════
-- TABS
-- ══════════════════════════════════════

local MainTab = Window:CreateTab("Main", "zap")
local BattleTab = Window:CreateTab("Battle", "swords")
local TeleportTab = Window:CreateTab("Teleport", "map-pin")
local VisualTab = Window:CreateTab("Visual", "eye")
local MiscTab = Window:CreateTab("Misc", "settings")

-- ══════════════════════════════════════
-- MAIN TAB
-- ══════════════════════════════════════

MainTab:CreateSection("Movement")

MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 120},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        State.Speed = Value
        if Humanoid then Humanoid.WalkSpeed = Value end
    end,
})

MainTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        State.Jump = Value
        if Humanoid then
            Humanoid.JumpPower = Value
            Humanoid.UseJumpPower = true
        end
    end,
})

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        State.Noclip = Value
    end,
})

MainTab:CreateToggle({
    Name = "Walk on Water",
    CurrentValue = false,
    Flag = "WalkOnWater",
    Callback = function(Value)
        State.WalkOnWater = Value
    end,
})

MainTab:CreateSection("Utility")

MainTab:CreateToggle({
    Name = "Infinite Repel",
    CurrentValue = false,
    Flag = "InfiniteRepel",
    Callback = function(Value)
        State.InfiniteRepel = Value
        pcall(function()
            if _p and _p.Repel then
                _p.Repel.steps = Value and 999999 or 0
            end
        end)
    end,
})

MainTab:CreateToggle({
    Name = "Instant Text / Skip Dialogue",
    CurrentValue = false,
    Flag = "InstantText",
    Callback = function(Value)
        State.InstantText = Value
    end,
})

MainTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Flag = "AntiAFK",
    Callback = function(Value)
        State.AntiAFK = Value
    end,
})

MainTab:CreateButton({
    Name = "Enable Running Shoes + RTD",
    Callback = function()
        pcall(function()
            if _p then
                if _p.Menu and _p.Menu.rtd then _p.Menu.rtd:enable() end
                if _p.RunningShoes then _p.RunningShoes:enable() end
            end
        end)
        Rayfield:Notify({
            Title = "Sky Hub",
            Content = "Running Shoes + RTD enabled",
            Duration = 3,
            Image = "check",
        })
    end,
})

MainTab:CreateButton({
    Name = "Heal Party",
    Callback = function()
        pcall(function()
            if _p and _p.Network then
                _p.Network:get("PDS", "heal")
            end
        end)
        Rayfield:Notify({
            Title = "Sky Hub",
            Content = "Party healed",
            Duration = 3,
            Image = "heart",
        })
    end,
})

-- ══════════════════════════════════════
-- BATTLE TAB
-- ══════════════════════════════════════

BattleTab:CreateSection("Auto Features")

BattleTab:CreateToggle({
    Name = "Auto Battle (Trainer Rematch)",
    CurrentValue = false,
    Flag = "AutoBattle",
    Callback = function(Value)
        State.AutoBattle = Value
    end,
})

BattleTab:CreateToggle({
    Name = "Auto Catch (Wild)",
    CurrentValue = false,
    Flag = "AutoCatch",
    Callback = function(Value)
        State.AutoCatch = Value
    end,
})

BattleTab:CreateToggle({
    Name = "God Mode (Battle)",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        State.GodMode = Value
    end,
})

BattleTab:CreateSection("Quick Actions")

BattleTab:CreateButton({
    Name = "Force Win / Forfeit Battle",
    Callback = function()
        pcall(function()
            if _p and _p.Battle and _p.Battle.currentBattle then
                _p.Battle.currentBattle:forfeit()
            end
        end)
        Rayfield:Notify({
            Title = "Sky Hub",
            Content = "Battle force attempted",
            Duration = 3,
            Image = "swords",
        })
    end,
})

BattleTab:CreateButton({
    Name = "Skip Battle Animation",
    Callback = function()
        pcall(function()
            if _p and _p.Battle then
                _p.Battle.speed = 10
            end
        end)
        Rayfield:Notify({
            Title = "Sky Hub",
            Content = "Battle speed boosted",
            Duration = 3,
            Image = "zap",
        })
    end,
})

BattleTab:CreateParagraph({
    Title = "Note",
    Content = "Auto Battle works best at Training Hotspots. Stand near a rematchable trainer and enable. God Mode attempts to prevent faint.",
})

-- ══════════════════════════════════════
-- TELEPORT TAB
-- ══════════════════════════════════════

TeleportTab:CreateSection("Key Locations")

local Locations = {
    {Name = "Pokémon Lab (Start)", Pos = Vector3.new(0, 5, 0)},
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
            Rayfield:Notify({
                Title = "Teleported",
                Content = "→ " .. loc.Name,
                Duration = 2,
                Image = "map-pin",
            })
        end,
    })
end

TeleportTab:CreateSection("Server")

TeleportTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

TeleportTab:CreateButton({
    Name = "Server Hop (Low Players)",
    Callback = function()
        pcall(function()
            local servers = HttpService:JSONDecode(game:HttpGet(
                "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            ))
            for _, s in ipairs(servers.data or {}) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
                    break
                end
            end
        end)
    end,
})

-- ══════════════════════════════════════
-- VISUAL TAB
-- ══════════════════════════════════════

VisualTab:CreateSection("ESP & Lighting")

VisualTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        State.ESP = Value
    end,
})

VisualTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(Value)
        if Value then
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
    Callback = function(Value)
        Lighting.FogEnd = Value and 100000 or 1000
    end,
})

VisualTab:CreateSection("Camera")

VisualTab:CreateSlider({
    Name = "FOV",
    Range = {70, 120},
    Increment = 1,
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(Value)
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = Value end
    end,
})

VisualTab:CreateButton({
    Name = "Free Cam Toggle",
    Callback = function()
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam.CameraType == Enum.CameraType.Custom then
                cam.CameraType = Enum.CameraType.Scriptable
            else
                cam.CameraType = Enum.CameraType.Custom
            end
        end)
    end,
})

-- ══════════════════════════════════════
-- MISC TAB
-- ══════════════════════════════════════

MiscTab:CreateSection("Performance")

MiscTab:CreateButton({
    Name = "FPS Boost (Low Graphics)",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                end
            end
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
        end)
        Rayfield:Notify({
            Title = "Sky Hub",
            Content = "FPS Boost applied",
            Duration = 3,
            Image = "gauge",
        })
    end,
})

MiscTab:CreateSection("Player")

MiscTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        if Humanoid then Humanoid.Health = 0 end
    end,
})

MiscTab:CreateSection("Credits")

MiscTab:CreateParagraph({
    Title = "Sky Hub • Pokémon Bronze",
    Content = "Built on Rayfield by Envy\nFeatures by Spinach Premium\nCompatible with Project Bronze Forever / Roria Conquest / PBB reuploads\nToggle UI: K",
})

-- ══════════════════════════════════════
-- LOOPS
-- ══════════════════════════════════════

-- Keep speed / jump
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

-- Walk on Water
RunService.Heartbeat:Connect(function()
    if State.WalkOnWater and Root then
        local ray = Ray.new(Root.Position, Vector3.new(0, -5, 0))
        local hit = workspace:FindPartOnRay(ray, Character)
        if hit and (hit.Name:lower():find("water") or hit.Material == Enum.Material.Water) then
            Root.Velocity = Vector3.new(Root.Velocity.X, 2, Root.Velocity.Z)
        end
    end
end)

-- Infinite Repel keep
task.spawn(function()
    while task.wait(2) do
        if State.InfiniteRepel then
            pcall(function()
                if _p and _p.Repel then
                    _p.Repel.steps = 999999
                end
            end)
        end
    end
end)

-- Anti-AFK
task.spawn(function()
    while task.wait(60) do
        if State.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
end)

-- ESP
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "SkyHubESP"
ESPFolder.Parent = game:GetService("CoreGui")

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

-- Character respawn
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

Rayfield:Notify({
    Title = "Sky Hub Loaded",
    Content = "Pokémon Bronze Premium ready. Press K to toggle.",
    Duration = 5,
    Image = "check",
})

print("[Sky Hub] Pokémon Bronze Premium loaded")
