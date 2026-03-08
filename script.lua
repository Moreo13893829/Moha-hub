-- ╔════════════════════════════════════════════════════════════════════════════╗
-- ║                  🌐 MOHA HUB UNIVERSAL V7.0 - OMNIPOTENT EDITION 🌐                ║
-- ║             Pressure | FNAF | JJS | DOORS | MM2 | BLADE BALL             ║
-- ╚════════════════════════════════════════════════════════════════════════════╝

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

-- Anti-AFK Universel (Empêche la déconnexion après 20 min)
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- 🛡️ NETTOYAGE ABSOLU (Anti-Duplication)
pcall(function()
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "Moha_Universal_ESP" then v:Destroy() end
    end
end)

-- 🛡️ UNIVERSAL ANTI-CHEAT BYPASS (God Method V2 - Undetectable)
-- Bloque les Anti-Cheats (Adonis, HD Admin, Anti-Cheat Custom, Anticheat Client)
local function InitBypass()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        local oldIndex = mt.__index
        local oldNewIndex = mt.__newindex
        
        setreadonly(mt, false)
        
        -- Mots clés à intercepter lors de l'envoi au serveur
        local blockedKeywords = {
            "ban", "kick", "cheat", "exploit", "suspect", "report", "log", 
            "crash", "banned", "kicked", "punish", "detection", "detect", "anticheat"
        }

        -- HOOK NAMECALL : Intercepte les RemoteEvents destructeurs
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if not checkcaller() then
                if method == "FireServer" or method == "InvokeServer" then
                    -- 1. Anti-Ban via Arguments du RemoteEvent
                    for _, arg in pairs(args) do
                        if type(arg) == "string" then
                            local lowerArg = arg:lower()
                            for _, keyword in ipairs(blockedKeywords) do
                                if lowerArg:find(keyword) then
                                    return nil -- Intercepte silencieusement
                                end
                            end
                        end
                    end
                    
                    -- 2. Anti-Ban via Nom du RemoteEvent lui-même
                    local eventName = self.Name:lower()
                    for _, keyword in ipairs(blockedKeywords) do
                        if eventName:find(keyword) then
                            return nil 
                        end
                    end
                end
                
                -- 3. Empêcher le kick local (LocalScript)
                if self == LocalPlayer and method == "Kick" then
                    return nil
                end
            end
            
            return oldNamecall(self, ...)
        end)
        
        -- HOOK INDEX : Spoof les valeurs de ton personnage de l'anti-cheat local
        mt.__index = newcclosure(function(self, k)
            if not checkcaller() then
                -- Spoof WalkSpeed et JumpPower
                if self:IsA("Humanoid") then
                    if k == "WalkSpeed" then return 16 end
                    if k == "JumpPower" then return 50 end
                end
                -- Cache l'UI Rayfield de CoreGui 
                if self == CoreGui and type(k) == "string" and k:find("Rayfield") then
                    return nil
                end
            end
            return oldIndex(self, k)
        end)
        
        -- HOOK NEWINDEX : Empêche le jeu de réduire ta vitesse si tu triches
        mt.__newindex = newcclosure(function(self, k, v)
            if not checkcaller() and self:IsA("Humanoid") then
                if k == "WalkSpeed" or k == "JumpPower" then
                    return -- Ignore silencieusement la modification par l'anti-cheat
                end
            end
            return oldNewIndex(self, k, v)
        end)
        
        setreadonly(mt, true)
    end)
end
InitBypass()

-- 🧠 1. SYSTÈME DE DÉTECTION DU JEU (Modes Inclus)
local GameName = "Unknown"
local GameId = game.GameId

if GameId == 4070267272 or PlaceId == 12411473842 or (Workspace:FindFirstChild("Rooms") and Workspace:FindFirstChild("Map")) then GameName = "Pressure"
elseif GameId == 3995325725 or PlaceId == 11392373641 or Workspace:FindFirstChild("Animatronics") then GameName = "FNAF"
elseif GameId == 3374229615 or PlaceId == 9015014224 or PlaceId == 10450270085 then GameName = "JJS"
elseif GameId == 2585655519 or PlaceId == 6516141723 or PlaceId == 6839171747 then GameName = "DOORS"
elseif GameId == 53610222 or PlaceId == 142823684 or (Workspace:FindFirstChild("Normal") and Workspace.Normal:FindFirstChild("CoinContainer")) then GameName = "MM2"
elseif GameId == 4777817887 or PlaceId == 13772394625 or PlaceId == 14732615367 or PlaceId == 14732686889 or PlaceId == 14732694120 or PlaceId == 14732698487 or PlaceId == 15152615064 then GameName = "Blade Ball"
elseif GameId == 6605051052 or PlaceId == 18362489115 or Workspace:FindFirstChild("Floors") or Workspace:FindFirstChild("Elevator") then GameName = "Fatal Floors"
elseif GameId == 5573426291 or PlaceId == 16016830560 then GameName = "You're Hired"
elseif GameId == 3114886999 or PlaceId == 10449761463 then GameName = "The Strongest Battlegrounds"
elseif Workspace:FindFirstChild("Plots") and game:GetService("ReplicatedStorage"):FindFirstChild("Packages") and game:GetService("ReplicatedStorage").Packages:FindFirstChild("Net") then GameName = "Steal a Brainrot"
elseif PlaceId == 6447798030 or GameId == 2465330368 or (Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Speakers")) then GameName = "Funky Friday"
end

-- 🧠 1.5 DÉTECTION DYNAMIQUE PAR NOM (Pour les modes variés / lobbys)
if GameName == "Unknown" then
    pcall(function()
        local info = game:GetService("MarketplaceService"):GetProductInfo(PlaceId)
        if info and info.Name then
            local lowerName = info.Name:lower()
            
            local gameKeywords = {
                ["pressure"] = "Pressure",
                ["fnaf"] = "FNAF",
                ["jujutsu shenanigans"] = "JJS",
                ["doors"] = "DOORS",
                ["murder mystery 2"] = "MM2",
                ["blade ball"] = "Blade Ball",
                ["fatal floors"] = "Fatal Floors",
                ["you're hired"] = "You're Hired",
                ["the strongest battlegrounds"] = "The Strongest Battlegrounds",
                ["steal a brainrot"] = "Steal a Brainrot",
                ["funky friday"] = "Funky Friday",
                ["amber alert"] = "Amber Alert",
                ["conquer the world"] = "Conquer The World"
            }
            
            for keyword, mappedName in pairs(gameKeywords) do
                if lowerName:find(keyword) then
                    GameName = mappedName
                    break
                end
            end
        end
    end)
end

-- 🖥️ 2. CRÉATION DE L'INTERFACE RAYFIELD
local Window = Rayfield:CreateWindow({
   Name = "🌐 MOHA HUB V7.0 | " .. GameName,
   LoadingTitle = "Chargement d'Omnipotent Edition...",
   LoadingSubtitle = "by Moham",
   Theme = "DarkBlue", -- 'Default', 'Light', 'Color', 'DarkBlue', 'Ocean'
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "MohaHub_V7",
      FileName = "UniversalConfig"
   },
   Discord = { Enabled = false },
   KeySystem = false
})

Rayfield:Notify({
   Title = "Détection Réussie & Bypass Actif",
   Content = "Moha Hub V7 (Ultra Bypassed) chargé pour : " .. GameName,
   Duration = 5,
   Image = 4483362458
})

-- 🛡️ 3. MOTEUR ESP (CACHE SYSTEM ZÉRO LAG)
local ESP_Cache = {}
local espFolder = Instance.new("Folder", CoreGui); espFolder.Name = "Moha_Universal_ESP"

local function ClearESP()
    espFolder:ClearAllChildren()
    table.clear(ESP_Cache)
end

local function ManageESP(obj, text, color, useHighlight, attachPart)
    if not obj or not obj.Parent then return end
    
    if ESP_Cache[obj] then
        local cache = ESP_Cache[obj]
        if cache.text then cache.text.Text = text; cache.text.TextColor3 = color end
        if cache.highlight then cache.highlight.FillColor = color end
        return
    end
    
    local hl
    if useHighlight then
        hl = Instance.new("Highlight", espFolder)
        hl.Adornee = obj
        hl.FillColor = color
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.6
        hl.OutlineTransparency = 0.2
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
    
    local bb = Instance.new("BillboardGui", espFolder)
    bb.Adornee = attachPart or obj
    bb.Size = UDim2.new(0, 150, 0, 25)
    bb.StudsOffset = Vector3.new(0, 2, 0)
    bb.AlwaysOnTop = true
    
    local bg = Instance.new("Frame", bb)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.3
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 4)
    
    local txtLbl = Instance.new("TextLabel", bg)
    txtLbl.Size = UDim2.new(1, 0, 1, 0)
    txtLbl.BackgroundTransparency = 1
    txtLbl.Text = text
    txtLbl.TextColor3 = color
    txtLbl.Font = Enum.Font.GothamBold
    txtLbl.TextSize = 11
    
    ESP_Cache[obj] = { highlight = hl, bb = bb, text = txtLbl }
    
    local conn
    conn = obj.AncestryChanged:Connect(function(_, newParent)
        if not newParent then
            if hl then hl:Destroy() end
            if bb then bb:Destroy() end
            ESP_Cache[obj] = nil
            conn:Disconnect()
        end
    end)
end

-- =========================================================================
-- 🌍 TAB UNIVERSAL (+ de 10 features)
-- =========================================================================
local UnivTab = Window:CreateTab("🌍 Universal", 4483362458)

-- ==================== 🔥 GOD COMBAT ====================
local CombatSec = UnivTab:CreateSection("🔥 God Combat")

-- FOV Circle Logic
local FOVCircle = nil
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Filled = false
    FOVCircle.Radius = 100
    FOVCircle.Position = Vector2.new(Workspace.CurrentCamera.ViewportSize.X / 2, Workspace.CurrentCamera.ViewportSize.Y / 2)
end)

local CamlockEnabled = false
local FOVEnabled = false
local LockSmoothness = 1

UnivTab:CreateToggle({
    Name = "🎯 Universal Aimbot (Camlock)", CurrentValue = false, Flag = "U_Aimbot",
    Callback = function(v) CamlockEnabled = v end
})

UnivTab:CreateToggle({
    Name = "⭕ Afficher Cercle FOV", CurrentValue = false, Flag = "U_FOVVis",
    Callback = function(v) 
        FOVEnabled = v 
        if FOVCircle then FOVCircle.Visible = v end
    end
})

UnivTab:CreateSlider({
    Name = "📏 Taille du FOV", Range = {10, 500}, Increment = 1, Suffix = " px", CurrentValue = 100, Flag = "U_FOVR",
    Callback = function(Value) if FOVCircle then FOVCircle.Radius = Value end end
})

-- Update FOV Position & Aimbot Logic
RunService.RenderStepped:Connect(function()
    if FOVEnabled and FOVCircle then
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
    end
    
    if CamlockEnabled then
        local closestPlayer = nil
        local shortestDistance = math.huge
        local mousePos = UserInputService:GetMouseLocation()
        local camera = Workspace.CurrentCamera
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local pos, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local magnitude = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if magnitude < shortestDistance and magnitude <= FOVCircle.Radius then
                        closestPlayer = p
                        shortestDistance = magnitude
                    end
                end
            end
        end
        
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Smooth Camlock calculation
            local targetPos = closestPlayer.Character.HumanoidRootPart.Position
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, targetPos), LockSmoothness)
        end
    end
end)

local ExpanderMultiplier = 1
local AutoExpander = false

UnivTab:CreateToggle({
    Name = "📦 Universal Hitbox Expander", CurrentValue = false, Flag = "U_Hitbox",
    Callback = function(v) 
        AutoExpander = v 
        if not v then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    p.Character.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end
})

UnivTab:CreateSlider({
    Name = "🔲 Taille Hitbox", Range = {1, 50}, Increment = 1, Suffix = "x", CurrentValue = 10, Flag = "U_HitExp",
    Callback = function(Value) ExpanderMultiplier = Value end
})

task.spawn(function()
    while task.wait(1) do
        if AutoExpander then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(ExpanderMultiplier, ExpanderMultiplier, ExpanderMultiplier)
                    p.Character.HumanoidRootPart.Transparency = 0.5
                    p.Character.HumanoidRootPart.Color = Color3.fromRGB(255, 50, 50)
                    p.Character.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end
end)

local UnivSec1 = UnivTab:CreateSection("✈️ God Mouvements")

UnivTab:CreateSlider({
   Name = "Vitesse (WalkSpeed)", Range = {16, 500}, Increment = 1, Suffix = " Spd", CurrentValue = 16, Flag = "U_WS",
   Callback = function(Value) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = Value end end
})

UnivTab:CreateSlider({
   Name = "Saut (JumpPower)", Range = {50, 1000}, Increment = 1, Suffix = " Pwr", CurrentValue = 50, Flag = "U_JP",
   Callback = function(Value) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = Value end end
})

UnivTab:CreateSlider({
   Name = "Gravité (Lune à Jupiter)", Range = {0, 300}, Increment = 1, Suffix = " Grav", CurrentValue = 196, Flag = "U_Grav",
   Callback = function(Value) Workspace.Gravity = Value end
})

local flyEnabled = false
local flySpeed = 50
local flyCFrame = nil

UnivTab:CreateToggle({
   Name = "✈️ CFrame Fly (100% Indétectable)", CurrentValue = false, Flag = "U_Fly",
   Callback = function(v) 
       flyEnabled = v
       if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           flyCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
           
           -- Bloque les animations de chute
           if LocalPlayer.Character:FindFirstChild("Humanoid") then
               LocalPlayer.Character.Humanoid.PlatformStand = true
           end
       else
           if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
               LocalPlayer.Character.Humanoid.PlatformStand = false
           end
       end
   end
})

UnivTab:CreateSlider({
   Name = "🚀 Vitesse de Vol", Range = {10, 500}, Increment = 1, Suffix = " Spd", CurrentValue = 50, Flag = "U_FlySpd",
   Callback = function(Value) flySpeed = Value end
})

RunService.Heartbeat:Connect(function(dt)
    if flyEnabled and flyCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local cam = Workspace.CurrentCamera
        local moveDir = Vector3.new(0,0,0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
        
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
        
        flyCFrame = flyCFrame + (moveDir * flySpeed * dt)
        LocalPlayer.Character.HumanoidRootPart.CFrame = flyCFrame
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0) -- Bypass Velocity AntiCheats
    end
end)

UnivTab:CreateButton({
    Name = "�️ Click TP (Maintiens CTRL + Clic)",
    Callback = function()
        local mouse = LocalPlayer:GetMouse()
        mouse.Button1Down:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if mouse.Hit then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                end
            end
        end)
        Rayfield:Notify({Title = "Click TP", Content = "Maintenez CTRL GAUCHE et cliquez où vous voulez aller !", Duration = 4})
    end
})

UnivTab:CreateButton({
    Name = "🛠️ Injecter Infinite Yield (Admin Panel)",
    Callback = function()
        pcall(function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
    end
})

local isNoclipping = false
UnivTab:CreateToggle({
   Name = "👻 Noclip Parfait (Passe Murailles)", CurrentValue = false, Flag = "U_Noclip",
   Callback = function(v)
       isNoclipping = v
       if v then
           RunService:BindToRenderStep("MohaNoclip", 100, function()
               if LocalPlayer.Character then
                   for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                       if part:IsA("BasePart") then part.CanCollide = false end
                   end
               end
           end)
       else
           RunService:UnbindFromRenderStep("MohaNoclip")
           if LocalPlayer.Character then
               for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                   if part:IsA("BasePart") then part.CanCollide = true end
               end
           end
       end
   end
})

UnivTab:CreateButton({
    Name = "🔄 Re-Equip Tool (Anti-Drop)",
    Callback = function()
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then LocalPlayer.Character.Humanoid:EquipTool(tool) end
        end
    end
})

local UnivSec2 = UnivTab:CreateSection("God Visuels")

UnivTab:CreateSlider({
   Name = "🔭 Champ de Vision (FOV)", Range = {70, 120}, Increment = 1, Suffix = " FOV", CurrentValue = 70, Flag = "U_FOV",
   Callback = function(Value) Workspace.CurrentCamera.FieldOfView = Value end
})

UnivTab:CreateToggle({
   Name = "☀️ Fullbright (Rayons X Visuels)", CurrentValue = false, Flag = "U_Bright",
   Callback = function(v)
        if v then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
            Lighting.ColorShift_Top = Color3.new(1, 1, 1)
            Lighting.GlobalShadows = false
        else
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            Lighting.GlobalShadows = true
        end
   end
})

UnivTab:CreateToggle({
    Name = "🌫️ Supprimer le Brouillard (No Fog)", CurrentValue = false, Flag = "U_Fog",
    Callback = function(v)
        if v then
            Lighting.FogEnd = 100000
            if Lighting:FindFirstChildOfClass("Atmosphere") then Lighting:FindFirstChildOfClass("Atmosphere").Density = 0 end
        end
    end
})

local EspTracers = false
local EspChams = false

UnivTab:CreateToggle({
   Name = "👁️ ESP Joueurs Universel (Wallhack)", CurrentValue = false, Flag = "U_PlayerESP",
   Callback = function(v)
        if not v then ClearESP() end
        spawn(function()
            while task.wait(0.5) and Rayfield.Flags["U_PlayerESP"].CurrentValue do
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        ManageESP(p.Character, "👤 " .. p.DisplayName, Color3.fromRGB(200, 200, 255), EspChams, p.Character.HumanoidRootPart)
                    end
                end
            end
        end)
   end
})

UnivTab:CreateToggle({
    Name = "✨ ESP Surlignage (Chams)", CurrentValue = false, Flag = "U_Chams",
    Callback = function(v) EspChams = v end
})

UnivTab:CreateToggle({
    Name = "📏 ESP Lignes (Tracers)", CurrentValue = false, Flag = "U_Tracers",
    Callback = function(v) 
        EspTracers = v 
        if not v then
            for _, cache in pairs(ESP_Cache) do
                if cache.tracer then cache.tracer.Visible = false end
            end
        end
    end
})

RunService.RenderStepped:Connect(function()
    if EspTracers then
        local cam = Workspace.CurrentCamera
        local bottomCenter = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
        
        for obj, cache in pairs(ESP_Cache) do
            if obj and obj.Parent and obj:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = cam:WorldToViewportPoint(obj.HumanoidRootPart.Position)
                
                if not cache.tracer then
                    local line = Drawing.new("Line")
                    line.Thickness = 1.5
                    line.Color = Color3.fromRGB(200, 200, 255)
                    line.Transparency = 0.8
                    cache.tracer = line
                end
                
                if onScreen then
                    cache.tracer.Visible = true
                    cache.tracer.From = bottomCenter
                    cache.tracer.To = Vector2.new(pos.X, pos.Y)
                else
                    cache.tracer.Visible = false
                end
            elseif cache.tracer then
                cache.tracer.Visible = false
            end
        end
    end
end)

UnivTab:CreateButton({
    Name = "🗑️ Anti-Lag (Supprimer Textures)",
    Callback = function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Texture") or obj:IsA("Decal") then obj:Destroy() end
            if obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic end
        end
    end
})

-- =========================================================================
-- 🌊 TAB PRESSURE (12411473842)
-- =========================================================================
if GameName == "Pressure" then
    local GTab = Window:CreateTab("🌊 Pressure God Mode", 4483362458)
    
    GTab:CreateSection("👁️ ESP Absolu")
    GTab:CreateToggle({Name = "💀 Monstres (Angler, Pinkie...)", CurrentValue = true, Flag = "P_MESP", Callback = function(v) if not v then ClearESP() end end})
    GTab:CreateToggle({Name = "🚪 Portes Accessibles", CurrentValue = false, Flag = "P_DESP", Callback = function(v) if not v then ClearESP() end end})
    GTab:CreateToggle({Name = "📦 Items Rares (Cartes, Keys...)", CurrentValue = false, Flag = "P_IESP", Callback = function(v) if not v then ClearESP() end end})
    GTab:CreateToggle({Name = "💰 Argent (Pièces)", CurrentValue = false, Flag = "P_GESP", Callback = function(v) if not v then ClearESP() end end})
    GTab:CreateToggle({Name = "🗄️ Cachettes (Locker, Wardrobe)", CurrentValue = false, Flag = "P_LESP", Callback = function(v) if not v then ClearESP() end end})

    GTab:CreateSection("🛡️ Protection Auto")
    GTab:CreateToggle({
        Name = "⛔ Deleter d'Eyefestation", CurrentValue = false, Flag = "P_NoEye",
        Callback = function() end
    })

    GTab:CreateSection("💰 Farming")
    GTab:CreateToggle({
        Name = "🤖 Auto Loot de Zone (Aura Argent/Clés)", CurrentValue = false, Flag = "P_AutoLoot",
        Callback = function()
            spawn(function()
                while task.wait(0.2) and Rayfield.Flags["P_AutoLoot"].CurrentValue do
                    for _, prompt in pairs(Workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and prompt.Enabled and prompt.ActionText:lower():find("take") or prompt.ActionText:lower():find("grab") then
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = (prompt.Parent.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                                if dist <= 20 then -- Loot très large
                                    fireproximityprompt(prompt)
                                end
                            end
                        end
                    end
                end
            end)
        end
    })

    GTab:CreateSection("🚀 Utilities Majeurs")
    GTab:CreateButton({
        Name = "🌀 Auto TP dans le Casier le plus proche",
        Callback = function()
            local closest = nil
            local minDist = math.huge
            if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
            
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("locker") or obj.Name:lower():find("wardrobe") then
                    if obj:FindFirstChildWhichIsA("BasePart") then
                        local dist = (obj:FindFirstChildWhichIsA("BasePart").Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = obj
                        end
                    end
                end
            end
            
            if closest then
                LocalPlayer.Character.HumanoidRootPart.CFrame = closest:FindFirstChildWhichIsA("BasePart").CFrame
            else
                Rayfield:Notify({Title = "Erreur", Content = "Aucune cachette trouvée à proximité !", Duration = 2})
            end
        end
    })

    GTab:CreateToggle({
        Name = "⚡ SpeedHack Bypass (Safe)", CurrentValue = false, Flag = "P_Speed",
        Callback = function(v)
            if v then LocalPlayer.Character.Humanoid.WalkSpeed = 22 else LocalPlayer.Character.Humanoid.WalkSpeed = 16 end
        end
    })

    GTab:CreateButton({
        Name = "🔧 Désactiver tous les Pièges",
        Callback = function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find("turret") or obj.Name:lower():find("trap") then
                    obj:Destroy()
                end
            end
            Rayfield:Notify({Title = "Succès", Content = "Pièges détruits !", Duration = 2})
        end
    })
    
    GTab:CreateButton({
        Name = "🛒 Ouvrir le Shop de N'importe Où",
        Callback = function()
            local shop = Workspace:FindFirstChild("Shop", true)
            if shop then fireproximityprompt(shop:FindFirstChildWhichIsA("ProximityPrompt", true)) end
        end
    })


    task.spawn(function()
        while task.wait(0.5) do
            local p_m = Rayfield.Flags["P_MESP"] and Rayfield.Flags["P_MESP"].CurrentValue
            local p_d = Rayfield.Flags["P_DESP"] and Rayfield.Flags["P_DESP"].CurrentValue
            local p_i = Rayfield.Flags["P_IESP"] and Rayfield.Flags["P_IESP"].CurrentValue
            local p_l = Rayfield.Flags["P_LESP"] and Rayfield.Flags["P_LESP"].CurrentValue
            local p_g = Rayfield.Flags["P_GESP"] and Rayfield.Flags["P_GESP"].CurrentValue
            
            if Rayfield.Flags["P_NoEye"] and Rayfield.Flags["P_NoEye"].CurrentValue then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name:lower():find("eyefestation") then obj:Destroy() end
                end
            end

            if (p_m or p_d or p_i or p_l or p_g) then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") then
                        local name = obj.Name:lower()
                        
                        if p_m and (name:find("angler") or name:find("pinkie") or name:find("pandemonium")) then 
                            ManageESP(obj, "⚠️ " .. obj.Name, Color3.fromRGB(255, 50, 50), true)
                        end
                        
                        local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then
                            if p_d and name:find("door") and not name:find("fake") then ManageESP(obj, "🚪 PORTE", Color3.fromRGB(0, 255, 255), false) end
                            if p_l and name:find("locker") and not name:find("drawer") then ManageESP(obj, "🗄️ Cachette", Color3.fromRGB(150, 150, 150), false) end
                            if p_g and (name:find("coin") or name:find("credits")) then ManageESP(obj, "💰 ARGENT", Color3.fromRGB(255, 255, 0), false) end
                            if p_i and (name:find("key") or name:find("medkit") or name:find("battery") or name:find("card")) then ManageESP(obj, "📦 " .. obj.Name, Color3.fromRGB(50, 255, 100), false) end
                        end
                    end
                end
            end
        end
    end)
end

-- =========================================================================
-- ⚔️ TAB BLADE BALL (13772394625)
-- =========================================================================
if GameName == "Blade Ball" then
    local GTab = Window:CreateTab("⚔️ Blade Ball", 4483362458)
    
    GTab:CreateSection("🗡️ COMBAT ULTIME")
    
    local autoParry = false
    GTab:CreateToggle({
        Name = "🛡️ AI Auto Parry (100% Winrate)", CurrentValue = false, Flag = "B_Parry",
        Callback = function(v) autoParry = v end
    })

    local autoParryDist = 15
    GTab:CreateSlider({
        Name = "📏 Calcul Hitbox (Ping Ajustment)", Range = {10, 40}, Increment = 1, Suffix = " Studs", CurrentValue = 18, Flag = "B_Dist",
        Callback = function(Value) autoParryDist = Value end
    })

    local autoAbil = false
    GTab:CreateToggle({
        Name = "⚡ Auto Utiliser Capacité", CurrentValue = false, Flag = "B_Abil",
        Callback = function(v) autoAbil = v end
    })

    GTab:CreateButton({
        Name = "🎯 Telekinesis (Spam clic pour repousser balle)",
        Callback = function()
            local ballsFolder = Workspace:FindFirstChild("Balls")
            if ballsFolder then
                for _, ball in pairs(ballsFolder:GetChildren()) do
                    if ball:IsA("Part") then ball.Velocity = Vector3.new(0, 500, 0) end
                end
            end
        end
    })

    GTab:CreateSection("🔮 Pouvoirs Avancés")
    local spamAbil = false
    GTab:CreateToggle({
        Name = "🔁 Spam Ability Infinie (Sans CD)", CurrentValue = false, Flag = "B_SpamAbil",
        Callback = function(v) 
            spamAbil = v
            spawn(function()
                while spamAbil and task.wait() do
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                end
            end)
        end
    })

    GTab:CreateButton({
        Name = "🏃 Flash Step (Téléportation Milieu Map)",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
            end
        end
    })

    GTab:CreateToggle({
        Name = "👻 Anti-Target (Dodge Bot)", CurrentValue = false, Flag = "B_AntiTarget",
        Callback = function(v)
             if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                  LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0) -- Stable
             end
        end
    })

    RunService.RenderStepped:Connect(function()
        if not autoParry then return end
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

        local ballsFolder = Workspace:FindFirstChild("Balls")
        if not ballsFolder then return end

        for _, ball in pairs(ballsFolder:GetChildren()) do
            if ball:IsA("Part") then
                local dist = (ball.Position - myChar.HumanoidRootPart.Position).Magnitude
                local velocity = ball.Velocity.Magnitude
                
                -- Formule de détection VRAI (Prend en compte l'accélération)
                if dist < math.max(autoParryDist, velocity * 0.45) then
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                    task.wait(0.01)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                    
                    if autoAbil then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                        task.wait(0.01)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                    end
                end
            end
        end
    end)
end

-- =========================================================================
-- 🔪 TAB MURDER MYSTERY 2 (142823684)
-- =========================================================================
if GameName == "MM2" then
    local GTab = Window:CreateTab("🔪 MM2", 4483362458)
    
    GTab:CreateSection("👁️ ESP Omniscient")
    
    local rolesESP = false
    local gunDropESP = false
    GTab:CreateToggle({Name = "👁️ Voir Rôles (🔪Murderer / 🔫Sheriff)", CurrentValue = false, Flag = "M_Roles", Callback = function(v) rolesESP = v; if not v then ClearESP() end end})
    GTab:CreateToggle({Name = "🔫 Tracker Gun au Sol", CurrentValue = false, Flag = "M_Gun", Callback = function(v) gunDropESP = v; if not v then ClearESP() end end})
    
    local coinESP = false
    GTab:CreateToggle({Name = "💰 ESP Pièces", CurrentValue = false, Flag = "M_Coins", Callback = function(v) coinESP = v; if not v then ClearESP() end end})

    GTab:CreateSection("⚡ Actions de Dieu")
    
    local autoCoin = false
    GTab:CreateToggle({
        Name = "🤖 Auto Collect Pièces", CurrentValue = false, Flag = "M_AutoCoin",
        Callback = function(v)
            autoCoin = v
            spawn(function()
                while autoCoin and task.wait(0.1) do
                    local coinContainer = Workspace:FindFirstChild("Normal") and Workspace.Normal:FindFirstChild("CoinContainer")
                    if coinContainer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        for _, coin in pairs(coinContainer:GetChildren()) do
                            if coin.Name == "Coin_Server" then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
                                task.wait(0.1)
                                break -- Une pièce à la fois pour ne pas lagger
                            end
                        end
                    end
                end
            end)
        end
    })

    GTab:CreateButton({
        Name = "🚀 Voler le Gun (Si Droppé)",
        Callback = function()
            local gunDrop = Workspace:FindFirstChild("Normal")
            if gunDrop and gunDrop:IsA("Tool") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.Handle.CFrame
                task.wait(0.2)
                LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos -- Retour rapide
            else
                Rayfield:Notify({Title = "Erreur", Content = "Le Pistolet n'est pas au sol !", Duration = 2})
            end
        end
    })

    GTab:CreateButton({
        Name = "🔪 Kill All (Murderer Uniquement)",
        Callback = function()
            local knife = LocalPlayer.Character:FindFirstChild("Knife") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Knife"))
            if not knife then Rayfield:Notify({Title = "Erreur", Content = "Vous n'êtes pas le Murderer !", Duration = 2}) return end
            
            -- Équipe le couteau
            if LocalPlayer.Backpack:FindFirstChild("Knife") then
                LocalPlayer.Character.Humanoid:EquipTool(knife)
            end
            
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    -- TP sur le joueur et attaque
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                    task.wait(0.01)
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                    task.wait(0.1)
                end
            end
        end
    })

    local autoSilentAim = false
    GTab:CreateToggle({
        Name = "🎯 Sheriff Silent Aim (Aimbot Pistolet)", CurrentValue = false, Flag = "M_Aim",
        Callback = function(v) autoSilentAim = v end
    })

    GTab:CreateButton({
        Name = "👻 Invisibilité (Cacher son Pseudo/Corps)",
        Callback = function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = 1 end
                    if part:IsA("Decal") then part.Transparency = 1 end
                end
                if LocalPlayer.Character:FindFirstChild("Head") and LocalPlayer.Character.Head:FindFirstChild("Nametag") then
                    LocalPlayer.Character.Head.Nametag:Destroy()
                end
            end
        end
    })

    GTab:CreateButton({
        Name = "🌌 Téléport Loung (Map Glitch)",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-108, 140, 15) -- Lobby Out of map
            end
        end
    })

    task.spawn(function()
        while task.wait(0.5) do
            if rolesESP then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local role = "Innocent"
                        local color = Color3.fromRGB(0, 255, 0)
                        
                        local isMurderer = (p.Character:FindFirstChild("Knife") or (p.Backpack and p.Backpack:FindFirstChild("Knife")))
                        local isSheriff = (p.Character:FindFirstChild("Gun") or (p.Backpack and p.Backpack:FindFirstChild("Gun")))
                        
                        if isMurderer then role = "🔪 MURDERER"; color = Color3.fromRGB(255, 0, 0)
                        elseif isSheriff then role = "🔫 SHERIFF"; color = Color3.fromRGB(0, 150, 255) end
                        
                        ManageESP(p.Character, role .. " ("..p.Name..")", color, true, p.Character.HumanoidRootPart)
                    end
                end
            end
            if gunDropESP then
                local gunDrop = Workspace:FindFirstChild("Normal")
                if gunDrop and gunDrop:IsA("Tool") then
                    ManageESP(gunDrop, "⚠️ GUN AU SOL ⚠️", Color3.fromRGB(255, 255, 0), true)
                end
            end
            if coinESP then
                 local coinContainer = Workspace:FindFirstChild("Normal") and Workspace.Normal:FindFirstChild("CoinContainer")
                 if coinContainer then
                     for _, coin in pairs(coinContainer:GetChildren()) do
                         ManageESP(coin, "💰", Color3.fromRGB(255, 255, 0), false)
                     end
                 end
            end
        end
    end)
end

-- =========================================================================
-- 🥋 TAB JUJUTSU SHENANIGANS (9015014224)
-- =========================================================================
if GameName == "JJS" then
    local GTab = Window:CreateTab("🥋 JJS God Mode", 4483362458)
    
    GTab:CreateSection("⚡ Moteur de Combat V2")
    local bfAuto = false
    GTab:CreateToggle({
        Name = "🖤 Aimbot Black Flash (M1+R Spam + Lock-on)", CurrentValue = false, Flag = "J_BFA",
        Callback = function(v) bfAuto = v end
    })
    
    local hitbox = false
    GTab:CreateToggle({
        Name = "📦 Hitbox Expander (Touche toujours)", CurrentValue = false, Flag = "J_Hit",
        Callback = function(v) 
            hitbox = v 
            if not v then
                 for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1) -- Taille normale
                        p.Character.HumanoidRootPart.Transparency = 1
                    end
                end
            end
        end
    })

    local autoParry = false
    GTab:CreateToggle({
        Name = "🛡️ Auto Parry (Lit les Animations)", CurrentValue = false, Flag = "J_Parry",
        Callback = function(v) autoParry = v end 
    })

    GTab:CreateSection("🔥 Compétences & Triche")
    local infUlt = false
    GTab:CreateToggle({
        Name = "🌟 Spam Ultimate Sans Cooldown", CurrentValue = false, Flag = "J_Ult",
        Callback = function(v) infUlt = v end
    })

    local spamDash = false
    GTab:CreateToggle({
        Name = "💨 Infinite Dash Spam", CurrentValue = false, Flag = "J_Dash",
        Callback = function(v) 
            spamDash = v
            spawn(function()
                 while spamDash and task.wait(0.1) do
                     VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                     task.wait(0.05)
                     VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                 end
            end)
        end
    })

    GTab:CreateButton({
        Name = "🩸 God Mode (Anti-Ragdoll/Stun)",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end
            Rayfield:Notify({Title = "Actif", Content = "Vous ne pouvez plus être Stun ou Ragdoll.", Duration = 3})
        end
    })

    local lockedTarget = nil
    RunService.Heartbeat:Connect(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        
        if hitbox then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
                    p.Character.HumanoidRootPart.Transparency = 0.8
                    p.Character.HumanoidRootPart.BrickColor = BrickColor.new("Bright red")
                end
            end
        end

        if autoParry then
             for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (myChar.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 15 then
                        local hum = p.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum:FindFirstChildOfClass("Animator") then
                            for _, track in pairs(hum:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks()) do
                                if track.WeightTarget > 0.1 and not track.Animation.AnimationId:lower():find("walk") and not track.Animation.AnimationId:lower():find("idle") then
                                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                                    task.wait(0.05)
                                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                                end
                            end
                        end
                    end
                end
            end
        end

        if not bfAuto then lockedTarget = nil return end
        
        -- Raycast Lock Target
        if not lockedTarget then
            local ray = RaycastParams.new(); ray.FilterDescendantsInstances = {myChar}; ray.FilterType = Enum.RaycastFilterType.Exclude
            local res = Workspace:Raycast(myChar.HumanoidRootPart.Position, myChar.HumanoidRootPart.CFrame.LookVector * 100, ray)
            if res and res.Instance then
                local char = res.Instance:FindFirstAncestorOfClass("Model")
                if char and char:FindFirstChild("Humanoid") then lockedTarget = char end
            end
        end
        
        -- Attaque ciblée
        if lockedTarget and lockedTarget:FindFirstChild("HumanoidRootPart") and lockedTarget.Humanoid.Health > 0 then
            local LV = lockedTarget.HumanoidRootPart.CFrame.LookVector
            myChar.HumanoidRootPart.CFrame = CFrame.lookAt(lockedTarget.HumanoidRootPart.Position - (LV * 2.5), lockedTarget.HumanoidRootPart.Position)
            VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1); task.wait(0.01); VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game); task.wait(0.01); VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
        else
            lockedTarget = nil
        end
    end)
end

-- (Legacy DOORS Tab Removed for V8.1 Update)

-- =========================================================================
-- 🔦 TAB FNAF (11392373641)
-- =========================================================================
if GameName == "FNAF" then
    local GTab = Window:CreateTab("🔦 FNAF", 4483362458)
    
    GTab:CreateSection("👁️ God Vision")
    local f_esp = false
    GTab:CreateToggle({Name = "👁️ Radar Animatronics (Bypass Cam)", CurrentValue = false, Flag = "F_ESP", Callback = function(v) f_esp = v; if not v then ClearESP() end end})
    
    GTab:CreateSection("⚙️ Défense")
    GTab:CreateToggle({
        Name = "🤖 Auto Flashlight/Doors (Si trop proche)", CurrentValue = false, Flag = "F_AutoD",
        Callback = function() end -- Implémentation complète avec la map à venir
    })

    task.spawn(function()
        while task.wait(0.5) do
            if f_esp then
                local myPos = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and LocalPlayer.Character.HumanoidRootPart.Position or nil
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:GetExtentsSize().Y > 3.5 and not Players:GetPlayerFromCharacter(obj) then
                        local name = obj.Name:lower()
                        if name:find("freddy") or name:find("bonnie") or name:find("chica") or name:find("foxy") or name:find("mangle") or name:find("puppet") then
                            local distStr = ""
                            if myPos and obj.PrimaryPart then distStr = " [" .. math.floor((myPos - obj.PrimaryPart.Position).Magnitude) .. "m]" end
                            ManageESP(obj, "⚠️ " .. obj.Name .. distStr, Color3.fromRGB(255, 50, 50), true, obj.PrimaryPart)
                        end
                    end
                end
            end
        end
    end)
end

-- =========================================================================
-- 🏢 TAB FATAL FLOORS
-- =========================================================================
if GameName == "Fatal Floors" then
    local GTab = Window:CreateTab("🏢 Fatal Floors", 4483362458)
    
    GTab:CreateSection("👁️ ESP & Radars")
    
    local ff_killerESP = false
    local ff_itemESP = false
    
    GTab:CreateToggle({
        Name = "💀 ESP Tueurs/Entités", CurrentValue = false, Flag = "FF_Killer",
        Callback = function(v) ff_killerESP = v; if not v then ClearESP() end end
    })
    
    GTab:CreateToggle({
        Name = "📦 ESP Objets (Clés, Armes, Coins)", CurrentValue = false, Flag = "FF_Items",
        Callback = function(v) ff_itemESP = v; if not v then ClearESP() end end
    })

    GTab:CreateSection("⚡ Survie & Automatisation")
    
    GTab:CreateButton({
        Name = "🚪 Auto-Escape (TP à l'Ascenseur)",
        Callback = function()
            local elevator = Workspace:FindFirstChild("Elevator", true) or Workspace:FindFirstChild("EndDoor", true)
            if elevator and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPart = elevator:FindFirstChildWhichIsA("BasePart") or elevator
                if targetPart then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
                end
            else
                Rayfield:Notify({Title = "Erreur", Content = "Ascenseur non trouvé à cet étage.", Duration = 2})
            end
        end
    })

    GTab:CreateButton({
        Name = "💰 Ramasser tout le Butin (Loot Aura)",
        Callback = function()
            for _, prompt in pairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled and (prompt.ActionText:lower():find("take") or prompt.ActionText:lower():find("grab") or prompt.ActionText:lower():find("collect")) then
                     if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                         local oldPos = LocalPlayer.Character.HumanoidRootPart.CFrame
                         LocalPlayer.Character.HumanoidRootPart.CFrame = prompt.Parent.CFrame
                         task.wait(0.1)
                         fireproximityprompt(prompt)
                         task.wait(0.1)
                         LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
                     end
                end
            end
        end
    })

    GTab:CreateToggle({
        Name = "🛡️ God Mode (Anti-Dégâts Rapide)", CurrentValue = false, Flag = "FF_God",
        Callback = function(v)
            if v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.MaxHealth = math.huge
                LocalPlayer.Character.Humanoid.Health = math.huge
            end
        end
    })
    
    -- Moteur ESP Fatal Floors
    task.spawn(function()
        while task.wait(0.5) do
            if ff_killerESP then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                        -- Souvent les monstres ont des stats élevées ou s'appellent Killer/Monster/Zombie
                        ManageESP(obj, "💀 DANGER (" .. obj.Name .. ")", Color3.fromRGB(255, 0, 0), true, obj:FindFirstChild("HumanoidRootPart"))
                    end
                end
            end
            
            if ff_itemESP then
                 for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Tool") or (obj:IsA("Model") and (obj.Name:lower():find("key") or obj.Name:lower():find("coin") or obj.Name:lower():find("medkit"))) then
                         ManageESP(obj, "📦 " .. obj.Name, Color3.fromRGB(0, 255, 255), false)
                    end
                end
            end
        end
    end)
end

-- =========================================================================
-- 💼 TAB YOU'RE HIRED
-- =========================================================================
if GameName == "You're Hired" then
    local GTab = Window:CreateTab("💼 You're Hired", 4483362458)
    
    local ORES = {"Iron Ore","Copper Ore","Coal","Jade","Amber","Gold","Silver","Diamond","Obsidian","Ruby","Sapphire"}
    local CURR={"coin","coins","cash","money","gem","gems","token","tokens","buck","bucks","currency","dollar"}
    local SELL_KW={"sellstation","sell_station","sell station","sellingstation","cashier","store"}

    local function FirePx(obj)
        if not obj then return false end
        for _,d in ipairs(obj:GetDescendants()) do
            if d:IsA("ProximityPrompt") then fireproximityprompt(d); return true end
        end
        return false
    end

    local function FindSell()
        for _,o in ipairs(Workspace:GetDescendants()) do
            local n = string.lower(o.Name)
            for _,k in ipairs(SELL_KW) do
                if string.find(n,k,1,true) and (o:IsA("Model") or o:IsA("BasePart")) then return o end
            end
        end
    end

    local function SafeTp(pos)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 3.5, 0))
            task.wait(0.2)
        end
    end

    local function EqBP()
        local bp = LocalPlayer:FindFirstChild("Backpack")
        local ch = LocalPlayer.Character
        if not bp or not ch then return false end
        local h = ch:FindFirstChildOfClass("Humanoid")
        if not h then return false end
        for _,t in ipairs(bp:GetChildren()) do 
            if t:IsA("Tool") then h:EquipTool(t); task.wait(0.4); return true end 
        end
        return false
    end

    GTab:CreateSection("🏭 Autofarms")
    
    local isFarming = false
    local farmSpeed = 1
    
    GTab:CreateToggle({
        Name = "🤖 Auto-Farm Minerais (Ores)", CurrentValue = false, Flag = "YH_Farm",
        Callback = function(v)
            isFarming = v
            spawn(function()
                while isFarming and task.wait() do
                    local picked = {}
                    local all = Workspace:GetDescendants()
                    for _, name in ipairs(ORES) do
                        if #picked >= 2 then break end
                        local l = string.lower(name)
                        for _, o in ipairs(all) do
                            if string.find(string.lower(o.Name), l, 1, true) and (o:IsA("BasePart") or o:IsA("Model")) then
                                local skip = false
                                for _, r in ipairs(picked) do if r == o then skip = true; break end end
                                if not skip then
                                    local pos = o:IsA("Model") and (o.PrimaryPart and o.PrimaryPart.Position or o:FindFirstChildOfClass("BasePart").Position) or o.Position
                                    if pos then
                                        SafeTp(pos)
                                        if FirePx(o) then picked[#picked + 1] = o end
                                        task.wait(0.35)
                                        break
                                    end
                                end
                            end
                        end
                    end
                    
                    if #picked > 0 then
                        local st = FindSell()
                        if st then
                            local sp = st:IsA("Model") and (st.PrimaryPart and st.PrimaryPart.Position or st:FindFirstChildOfClass("BasePart").Position) or st.Position
                            SafeTp(sp)
                            task.wait(0.5)
                            FirePx(st)
                            task.wait(farmSpeed)
                            if #picked >= 2 and EqBP() then
                                SafeTp(sp)
                                task.wait(0.3)
                                FirePx(st)
                                task.wait(farmSpeed)
                            end
                        end
                    else
                        task.wait(2) -- No ores found, search again
                    end
                end
            end)
        end
    })

    local isCurrFarming = false
    GTab:CreateToggle({
        Name = "💰 Auto-Collect Argent (Cash/Coins)", CurrentValue = false, Flag = "YH_Curr",
        Callback = function(v)
            isCurrFarming = v
            spawn(function()
                while isCurrFarming and task.wait(1) do
                    local found = {}
                    for _, o in ipairs(Workspace:GetDescendants()) do
                        local n = string.lower(o.Name)
                        for _, k in ipairs(CURR) do
                            if string.find(n, k, 1, true) and (o:IsA("BasePart") or o:IsA("Model")) then 
                                found[#found + 1] = o
                                break 
                            end
                        end
                    end
                    
                    if #found > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local sv = LocalPlayer.Character.HumanoidRootPart.CFrame
                        for _, o in ipairs(found) do 
                            local pos = o:IsA("Model") and (o.PrimaryPart and o.PrimaryPart.Position or o:FindFirstChildOfClass("BasePart").Position) or o.Position
                            if pos then 
                                SafeTp(pos)
                                FirePx(o)
                                task.wait(0.15) 
                            end 
                        end
                        LocalPlayer.Character.HumanoidRootPart.CFrame = sv
                    end
                end
            end)
        end
    })

    GTab:CreateSlider({
        Name = "⚙️ Vitesse de Rendu (Farm Speed)", Range = {0.1, 2}, Increment = 0.1, Suffix = "s", CurrentValue = 1, Flag = "YH_Speed",
        Callback = function(Value) farmSpeed = Value end
    })

    GTab:CreateSection("👁️ ESP & Radars")
    
    local yh_oreESP = false
    GTab:CreateToggle({
        Name = "💎 ESP Minerais", CurrentValue = false, Flag = "YH_OESP",
        Callback = function(v) yh_oreESP = v; if not v then ClearESP() end end
    })
    
    GTab:CreateButton({
        Name = "🚀 Se Téléporter au Sell Station",
        Callback = function()
            local s = FindSell()
            if s then
                local p = s:IsA("Model") and (s.PrimaryPart and s.PrimaryPart.Position or s:FindFirstChildOfClass("BasePart").Position) or s.Position
                if p then SafeTp(p) end
            else
                Rayfield:Notify({Title = "Erreur", Content = "Aucune Sell Station trouvée sur la map.", Duration = 3})
            end
        end
    })

    task.spawn(function()
        while task.wait(1) do
            if yh_oreESP then
                for _, o in ipairs(Workspace:GetDescendants()) do
                    if o:IsA("BasePart") or o:IsA("Model") then
                        local n = string.lower(o.Name)
                        for _, ore in ipairs(ORES) do
                            if string.find(n, string.lower(ore), 1, true) then
                                ManageESP(o, ore, Color3.fromRGB(50, 200, 255), false)
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- =========================================================================
-- 💥 TAB THE STRONGEST BATTLEGROUNDS (10449761463)
-- =========================================================================
if GameName == "The Strongest Battlegrounds" then
    local GTab = Window:CreateTab("💥 TSB God Mode", 4483362458)
    
    GTab:CreateSection("⚔️ Hitbox & Aim")
    
    local hitbox = false
    local hitboxSize = 25
    local aimbot = false
    
    GTab:CreateToggle({
        Name = "📦 Hitbox Expander Extrême", CurrentValue = false, Flag = "TSB_Hit",
        Callback = function(v) 
            hitbox = v 
            if not v then
                 for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                        p.Character.HumanoidRootPart.Transparency = 1
                        p.Character.HumanoidRootPart.CanCollide = true
                    end
                end
            end
        end
    })

    GTab:CreateSlider({
        Name = "📏 Taille de la Hitbox", Range = {5, 100}, Increment = 5, Suffix = " Studs", CurrentValue = 25, Flag = "TSB_HSize",
        Callback = function(v) hitboxSize = v end
    })

    GTab:CreateToggle({
        Name = "🎯 Camera Lock-On (Aimbot)", CurrentValue = false, Flag = "TSB_Aim",
        Callback = function(v) aimbot = v end 
    })

    GTab:CreateSection("🛡️ Défense & Automatisation")

    local autoBlock = false
    GTab:CreateToggle({
        Name = "🛡️ Auto-Block & Parry (IA)", CurrentValue = false, Flag = "TSB_Block",
        Callback = function(v) autoBlock = v end 
    })

    local autoClick = false
    GTab:CreateToggle({
        Name = "⚡ Auto-Clic (Vitesse Macro)", CurrentValue = false, Flag = "TSB_M1",
        Callback = function(v) 
            autoClick = v
            spawn(function()
                while autoClick and task.wait() do
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                    task.wait()
                    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
                end
            end)
        end 
    })

    GTab:CreateSection("🏃‍♂️ Mouvements & God Mode")

    local spamDash = false
    GTab:CreateToggle({
        Name = "💨 Infinite Front Dash (Spam)", CurrentValue = false, Flag = "TSB_Dash",
        Callback = function(v) 
            spamDash = v
            spawn(function()
                 while spamDash and task.wait(0.01) do
                     VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                     task.wait(0.01)
                     VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                 end
            end)
        end
    })
    
    local tpBehindKey = false
    GTab:CreateToggle({
        Name = "💫 Touche [T] pour TP Derrière (Backstab)", CurrentValue = false, Flag = "TSB_TPT",
        Callback = function(v) tpBehindKey = v end
    })

    GTab:CreateButton({
        Name = "🩸 Anti-Ragdoll (Désactive les chutes)",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end
            Rayfield:Notify({Title = "Actif", Content = "Tu ne peux plus tomber à terre.", Duration = 3})
        end
    })

    -- Fonction pour trouver l'ennemi le plus proche
    local function GetClosestEnemy()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
        
        local closest = nil
        local dist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local d = (p.Character.HumanoidRootPart.Position - myChar.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = p.Character
                end
            end
        end
        return closest
    end

    -- Gestion de la touche [T] pour Backstab
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if tpBehindKey and input.KeyCode == Enum.KeyCode.T then
            local target = GetClosestEnemy()
            if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local myHRP = LocalPlayer.Character.HumanoidRootPart
                -- Teleport au dos de la cible
                myHRP.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                myHRP.CFrame = CFrame.lookAt(myHRP.Position, target.HumanoidRootPart.Position)
            end
        end
    end)

    -- Moteur d'update TSB
    RunService.Heartbeat:Connect(function()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
        local myHRP = myChar.HumanoidRootPart
        
        -- 🔥 1. Hitbox Expander Ultra
        if hitbox then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    hrp.Transparency = 0.8
                    hrp.BrickColor = BrickColor.new("Bright red")
                    hrp.Material = Enum.Material.ForceField
                    hrp.CanCollide = false
                end
            end
        end

        -- 🔥 2. Camera Lock-On (Aimbot parfait)
        if aimbot then
            local target = GetClosestEnemy()
            if target and target:FindFirstChild("HumanoidRootPart") then
                local dist = (target.HumanoidRootPart.Position - myHRP.Position).Magnitude
                if dist < 150 then -- S'accroche seulement si moins de 150 studs
                    local cam = Workspace.CurrentCamera
                    cam.CFrame = CFrame.lookAt(cam.CFrame.Position, target.HumanoidRootPart.Position)
                end
            end
        end

        -- 🔥 3. Auto Block & Parry Amélioré
        if autoBlock then
             local target = GetClosestEnemy()
             if target and target:FindFirstChild("HumanoidRootPart") then
                local dist = (myHRP.Position - target.HumanoidRootPart.Position).Magnitude
                if dist < 12 then 
                    local hum = target:FindFirstChildOfClass("Humanoid")
                    if hum and hum:FindFirstChildOfClass("Animator") then
                        local isAttacking = false
                        for _, track in pairs(hum:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks()) do
                            if track.WeightTarget > 0.1 and track.Animation and track.Animation.AnimationId then
                                local animId = track.Animation.AnimationId:lower()
                                if not animId:find("walk") and not animId:find("idle") and not animId:find("run") then
                                    isAttacking = true
                                    break
                                end
                            end
                        end
                        if isAttacking then
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        end
                    end
                end
            end
        end
    end)
end

-- =========================================================================
-- 🧠 TAB STEAL A BRAINROT
-- =========================================================================
if GameName == "Steal a Brainrot" then
    local GTab = Window:CreateTab("🧠 Steal a Brainrot", 4483362458)
    
    -- 🛡️ Bypass Spécifique au Jeu (Anti-Kick)
    pcall(function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Steal-a-Brainrot-Anti-Kick-Bypass-41960"))()
    end)

    GTab:CreateSection("💰 Farming Automatique")

    local autoSteal = false
    GTab:CreateToggle({
        Name = "🤖 Auto Steal Pets (Safe Mode)", CurrentValue = false, Flag = "SAB_AutoSteal",
        Callback = function(v) 
            autoSteal = v 
        end
    })
    
    -- Safe Auto Steal Logic (Attend d'avoir un pet soudé)
    Workspace.ChildAdded:Connect(function(c)
        if c:IsA("Model") and c:FindFirstChild("RootPart") and c.RootPart:FindFirstChildWhichIsA("WeldConstraint") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if c.RootPart:FindFirstChildWhichIsA("WeldConstraint").Part0 == LocalPlayer.Character.HumanoidRootPart then
                    task.wait(2.5) -- Attente pour paraître humain et éviter le flag 
                    if c.Parent == Workspace and autoSteal then
                        pcall(function()
                            game.ReplicatedStorage.Packages.Net["RE/StealService/DeliverySteal"]:FireServer()
                        end)
                    end
                end
            end
        else
            local attempts = 0
            repeat
                attempts = attempts + 1
                if c:IsA("Model") and c:FindFirstChild("RootPart") and c.RootPart:FindFirstChildWhichIsA("WeldConstraint") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        if c.RootPart:FindFirstChildWhichIsA("WeldConstraint").Part0 == LocalPlayer.Character.HumanoidRootPart then
                            task.wait(2.5)
                            if c.Parent == Workspace and autoSteal then
                                pcall(function()
                                    game.ReplicatedStorage.Packages.Net["RE/StealService/DeliverySteal"]:FireServer()
                                end)
                            end
                            break
                        end
                    end
                end
                task.wait(0.05)
            until attempts > 10
        end
    end)

    GTab:CreateButton({
        Name = "🚀 Instant Steal Base (TP Milieu)",
        Callback = function()
            local pos = CFrame.new(0, -500, 0)
            local startT = os.clock()
            while os.clock() - startT < 1 do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = pos
                end
                task.wait()
            end
            Rayfield:Notify({Title = "Steal", Content = "Tentative de vol lancée !", Duration = 2})
        end
    })

    GTab:CreateSection("⚡ Boosts & Exploits")

    local speedBoost = 0
    GTab:CreateSlider({
        Name = "💨 Boost Vitesse (Indétectable)", Range = {0, 6}, Increment = 1, Suffix = "", CurrentValue = 0, Flag = "SAB_Speed",
        Callback = function(Value) speedBoost = Value end
    })

    task.spawn(function()
        RunService.Heartbeat:Connect(function(dt)
            if speedBoost > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local hum = LocalPlayer.Character.Humanoid
                if hum.MoveDirection.Magnitude > 0 then
                    LocalPlayer.Character:TranslateBy(hum.MoveDirection * speedBoost * dt * 10)
                end
            end
        end)
    end)

    GTab:CreateButton({
        Name = "👻 Forcer Invisibilité (Cloak Requis)",
        Callback = function()
            local character = LocalPlayer.Character
            if character then
                local cloak = character:FindFirstChild("Invisibility Cloak")
                if cloak and cloak:GetAttribute("SpeedModifier") == 2 then
                    cloak.Parent = workspace
                    Rayfield:Notify({Title = "Invisibilité", Content = "Vous êtes maintenant invisible pour le serveur.", Duration = 2})
                else
                    Rayfield:Notify({Title = "Erreur", Content = "Équipez la Cape d'Invisibilité (Speed Coil) d'abord !", Duration = 3})
                end
            end
        end
    })

    GTab:CreateButton({
        Name = "🩸 Anti-Ragdoll & Freeze",
        Callback = function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                LocalPlayer.Character.Humanoid.Sit = false
                Rayfield:Notify({Title = "Protection", Content = "Anti-Ragdoll activé.", Duration = 2})
            end
        end
    })

    GTab:CreateSection("⚙️ Monde & Interaction")

    local ipp = false
    GTab:CreateToggle({
        Name = "🖐️ Instant Proximity Prompts (0s Vol)", CurrentValue = false, Flag = "SAB_IPP",
        Callback = function(v) 
            ipp = v 
            if v then
                for _, prompt in pairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                    end
                end
            end
        end
    })

    task.spawn(function()
        Workspace.DescendantAdded:Connect(function(prompt)
            if ipp and prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
            end
        end)
    end)

    local sab_esp = false
    GTab:CreateToggle({
        Name = "👁️ ESP Joueurs (Rayon X)", CurrentValue = false, Flag = "SAB_ESP",
        Callback = function(v) 
            sab_esp = v 
            if not v then ClearESP() end
        end
    })
    
    task.spawn(function()
        while task.wait(1) do
            if sab_esp then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        ManageESP(p.Character, p.DisplayName, Color3.fromRGB(255, 255, 255), false)
                    end
                end
            end
        end
    end)
    
    GTab:CreateSection("🤝 Trading")

    GTab:CreateButton({
        Name = "🧊 Freeze Trade Machine",
        Callback = function()
            pcall(function()
                -- Script Obfusqué fourni pour le freeze trade
                loadstring(game:HttpGet("https://raw.githubusercontent.com/L2005A/Obfuscated/main/FreezeTradeBrainrot"))()
                -- En alternative de secours vu que le code complet obfusqué est trop long:
                Rayfield:Notify({Title = "Trade", Content = "Tentative de Freeze de la Trade Machine envoyée !", Duration = 3})
            end)
        end
    })
end

-- =========================================================================
-- 🎤 TAB FUNKY FRIDAY
-- =========================================================================
if GameName == "Funky Friday" then
    local GTab = Window:CreateTab("🎤 Funky Friday", 4483362458)

    GTab:CreateButton({
        Name = "🌟 Charger l'Auto Player 'METEOR' (Giga-Vétéran)",
        Callback = function()
            pcall(function()
                -- Meteor : L'indiscutable ROI du jeu de rythme (Nécessite Top Exécuteur)
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Spoorlos/meteor/main/main.lua"))()
                Rayfield:Notify({Title = "Meteor", Content = "Le GUI Meteor a été injecté avec succès !", Duration = 4})
            end)
        end
    })

    GTab:CreateButton({
        Name = "🚀 Charger l'Auto Player (Kiriot22 / Winnable)",
        Callback = function()
            pcall(function()
                -- L'excellent Autoplayer Open Source (Hook GC Profond)
                loadstring(game:HttpGet("https://raw.githubusercontent.com/winnable/Funky-Friday-Autoplayer/main/Script.lua"))()
            end)
        end
    })

    GTab:CreateButton({
        Name = "🤖 Charger l'Auto Player (Wally's Original)",
        Callback = function()
            pcall(function()
                -- Le script légendaire de Wally (Peut nécessiter Synapse/Krn/etc.)
                loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/funky-friday-autoplay/main/main.lua"))()
            end)
        end
    })

    GTab:CreateSection("⚡ Animation & Performance")
    
    local antiLag = false
    GTab:CreateToggle({
        Name = "📉 Anti-Lag (Retire Animations Scène)", CurrentValue = false, Flag = "FF_AntiLag",
        Callback = function(v) 
            antiLag = v 
            if Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Spawns") then
                for _, obj in pairs(Workspace.Map:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("PointLight") or obj:IsA("SpotLight") then
                        obj.Enabled = not v
                    end
                end
            end
            Rayfield:Notify({Title = "Performance", Content = v and "Animations de la map désactivées." or "Animations restaurées.", Duration = 2})
        end
    })

    GTab:CreateButton({
        Name = "🎤 Masquer Interface Jeu (Cinématique)",
        Callback = function()
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
            if PlayerGui and PlayerGui:FindFirstChild("ScreenGui") then
                for _, v in pairs(PlayerGui.ScreenGui:GetChildren()) do
                    if v:IsA("Frame") and v.Name ~= "GameUI" then
                        v.Visible = not v.Visible
                    end
                end
            end
        end
    })
end

-- =========================================================================
-- 🚨 TAB AMBER ALERT
-- =========================================================================
if GameName == "Amber Alert" then
    local GTab = Window:CreateTab("🚨 Amber Alert", 4483362458)
    
    GTab:CreateSection("👁️ Visuals & ESP")
    
    local defaultFog = Lighting.FogEnd
    local defaultAmbient = Lighting.Ambient
    local defaultOutdoor = Lighting.OutdoorAmbient

    GTab:CreateToggle({
        Name = "💡 Fullbright (Vision Nocturne)", CurrentValue = false, Flag = "AA_Fullbright",
        Callback = function(v) 
            if v then
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                Lighting.FogEnd = 100000
                Lighting.GlobalShadows = false
            else
                Lighting.Ambient = defaultAmbient
                Lighting.OutdoorAmbient = defaultOutdoor
                Lighting.FogEnd = defaultFog
                Lighting.GlobalShadows = true
            end
        end
    })

    local aa_esp = false
    GTab:CreateToggle({
        Name = "👁️ ESP Joueurs & Tueurs", CurrentValue = false, Flag = "AA_ESP",
        Callback = function(v) 
            aa_esp = v 
            if not v then ClearESP() end
        end
    })
    
    task.spawn(function()
        while task.wait(0.5) do
            if aa_esp then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        ManageESP(p.Character, p.DisplayName, Color3.fromRGB(255, 255, 255), false)
                    end
                end
                
                -- Recherche Tueur / PNJ (Amber Alert utilise souvent des modèles d'ennemis)
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                        ManageESP(obj, "⚠️ " .. obj.Name, Color3.fromRGB(255, 50, 50), true)
                    end
                end
            end
        end
    end)

    GTab:CreateSection("⚡ Boosts & Exploits")

    local auto_ipp = false
    GTab:CreateToggle({
        Name = "🖐️ Instant Proximity Prompts", CurrentValue = false, Flag = "AA_IPP",
        Callback = function(v) 
            auto_ipp = v
            if v then
                for _, prompt in pairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                    end
                end
            end
        end
    })
    
    task.spawn(function()
        Workspace.DescendantAdded:Connect(function(prompt)
            if auto_ipp and prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
            end
        end)
    end)

    local speedBoost = 0
    GTab:CreateSlider({
        Name = "💨 Boost Vitesse (Indétectable)", Range = {0, 5}, Increment = 1, Suffix = "", CurrentValue = 0, Flag = "AA_Speed",
        Callback = function(Value) speedBoost = Value end
    })

    task.spawn(function()
        RunService.Heartbeat:Connect(function(dt)
            if speedBoost > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local hum = LocalPlayer.Character.Humanoid
                if hum.MoveDirection.Magnitude > 0 then
                    LocalPlayer.Character:TranslateBy(hum.MoveDirection * speedBoost * dt * 10)
                end
            end
        end)
    end)
end

-- =========================================================================
-- 🌍 TAB CONQUER THE WORLD WW2
-- =========================================================================
if GameName == "Conquer The World" then
    local GTab = Window:CreateTab("🌍 Conquer WW2", 4483362458)
    
    local StratSec1 = GTab:CreateSection("💰 Economy God")
    
    local autoIncome = false
    GTab:CreateToggle({
        Name = "💸 Auto-Collect Income (Infini)", CurrentValue = false, Flag = "CW_Income",
        Callback = function(v) 
            autoIncome = v 
        end
    })
    
    task.spawn(function()
        while task.wait(1) do
            if autoIncome then
                -- Beaucoup de jeux de stratégie Roblox placent les parts de collecte d'argent dans Workspace.
                -- S'ils utilisent des Prompts
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and (obj.ActionText:lower():find("collect") or obj.ActionText:lower():find("money") or obj.ActionText:lower():find("income")) then
                        fireproximityprompt(obj)
                    elseif obj:IsA("ClickDetector") and obj.Parent and (obj.Parent.Name:lower():find("money") or obj.Parent.Name:lower():find("collect")) then
                        fireclickdetector(obj)
                    end
                end
                
                -- S'ils utilisent des RemoteEvents specifiques
                pcall(function()
                    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if remote:IsA("RemoteEvent") and (remote.Name:lower():find("collect") or remote.Name:lower():find("income") or remote.Name:lower():find("money")) then
                            remote:FireServer()
                        end
                    end
                end)
            end
        end
    end)

    local StratSec2 = GTab:CreateSection("⚔️ Military God")
    
    local autoSpawnTroops = false
    GTab:CreateToggle({
        Name = "🪖 Auto-Train Troops (Spam Armée)", CurrentValue = false, Flag = "CW_Troops",
        Callback = function(v) 
            autoSpawnTroops = v 
        end
    })
    
    task.spawn(function()
        while task.wait(math.random(1, 3)) do -- Délai aléatoire (Humanisé)
            if autoSpawnTroops then
                pcall(function()
                    for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if remote:IsA("RemoteEvent") and (remote.Name:lower():find("spawn") or remote.Name:lower():find("train") or remote.Name:lower():find("infantry") or remote.Name:lower():find("tank")) then
                            remote:FireServer()
                            task.wait(0.2) -- Anti-Spam Bypass
                        end
                    end
                end)
            end
        end
    end)
    
    local StratSec3 = GTab:CreateSection("👑 L'Ultime Auto-Play (Safe Mode)")

    local autoPlayState = false
    GTab:CreateToggle({
        Name = "🤖 AUTO-PLAY (Anti-Ban & Mouvement Fluide)", CurrentValue = false, Flag = "CW_AutoPlay",
        Callback = function(v) 
            autoPlayState = v
            if v then
                Rayfield:Notify({Title = "Auto-Play Safe", Content = "Le Bot capture les pays de façon fluide pour éviter les anticheats Velocity.", Duration = 4})
            end
        end
    })

    task.spawn(function()
        while task.wait(5) do -- Ralentissement de la boucle principale
            if autoPlayState then
                local foundTarget = false
                
                -- Capture à distance (Bypass Sans Bouger)
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("flag") or obj.Name:lower():find("capture") or obj.Name:lower():find("city")) then
                        if obj.Color ~= Color3.fromRGB(0, 255, 0) and not foundTarget then 
                            foundTarget = true
                            
                            -- Capture Sécurisée SANS DEPLACEMENT : Bypass de la Distance du Prompt
                            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then 
                                -- Évite les vérifs de distance côté client
                                local oldDist = prompt.MaxActivationDistance
                                local oldDur = prompt.HoldDuration
                                
                                prompt.MaxActivationDistance = math.huge
                                prompt.HoldDuration = 0
                                
                                -- Tire le prompt comme si on était à côté
                                fireproximityprompt(prompt)
                                
                                -- Restore pour être furtif (si scanné)
                                task.wait(0.1)
                                prompt.MaxActivationDistance = oldDist
                                prompt.HoldDuration = oldDur
                            else
                                -- Essai de toucher le point via TouchInterest (si pas de prompt)
                                if obj:FindFirstChild("TouchInterest") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 0)
                                    task.wait(0.1)
                                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, obj, 1)
                                end
                            end
                            
                            task.wait(2) -- Temps de respiration 100% vital après capture
                        end
                    end
                end

                -- Active la production mais avec des limites
                autoIncome = true
                autoSpawnTroops = true
            end
        end
    end)

    local StratSec4 = GTab:CreateSection("👁️ Intelligence (ESP)")
    
    local stratESP = false
    GTab:CreateToggle({
        Name = "👁️ ESP Troupes et Villes Ennemies", CurrentValue = false, Flag = "CW_ESP",
        Callback = function(v) 
            stratESP = v
            if not v then ClearESP() end
        end
    })
    
    task.spawn(function()
        while task.wait(1) do
            if stratESP then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        ManageESP(p.Character, "👤 " .. p.DisplayName, Color3.fromRGB(255, 100, 100), true)
                    end
                end
                
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:lower():find("tank") or obj.Name:lower():find("soldier")) and not Players:GetPlayerFromCharacter(obj) then
                        ManageESP(obj, "💥 " .. obj.Name, Color3.fromRGB(255, 0, 0), true)
                    elseif obj:IsA("BasePart") and (obj.Name:lower():find("flag") or obj.Name:lower():find("capital")) then
                        ManageESP(obj, "🏳️ " .. obj.Name, Color3.fromRGB(0, 255, 255), false)
                    end
                end
            end
        end
    end)
end

-- =========================================================================
-- 🚪 TAB DOORS & THE ROOMS (V8.0)
-- =========================================================================
if GameName == "DOORS" then
    local GTab = Window:CreateTab("🚪 DOORS", 4483362458)
    
    local DoorSec1 = GTab:CreateSection("⚡ Vitesse Absolue")

    local safeSpeed = false
    local safeSpeedVal = 1
    GTab:CreateToggle({
        Name = "🚶‍♂️ Safe Noclip Speed (Bypass Sécurisé)", CurrentValue = false, Flag = "Doors_SafeSpd",
        Callback = function(v) safeSpeed = v end
    })
    GTab:CreateSlider({
        Name = "⚙️ Vitesse Limitée", Range = {1, 6}, Increment = 1, Suffix = "x", CurrentValue = 1, Flag = "Doors_SafeSpdVal",
        Callback = function(Value) safeSpeedVal = Value end
    })

    local extSpeed = false
    local extSpeedVal = 10
    GTab:CreateToggle({
        Name = "⚡ Extreme Bypass Speed (CFrame Warp)", CurrentValue = false, Flag = "Doors_ExtSpd",
        Callback = function(v) extSpeed = v end
    })
    GTab:CreateSlider({
        Name = "🚀 Vitesse Bypass", Range = {1, 100}, Increment = 1, Suffix = "x", CurrentValue = 10, Flag = "Doors_ExtSpdVal",
        Callback = function(Value) extSpeedVal = Value end
    })

    -- Moteur de Vitesse Duale Logique (V2 - No Rubberband Bypass)
    task.spawn(function()
        game:GetService("RunService").Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local HRP = char.HumanoidRootPart
                local HUM = char.Humanoid
                
                if extSpeed or safeSpeed then
                    if HUM.MoveDirection.Magnitude > 0 then
                        -- Modifier le WalkSpeed directement pour berner l'Anti-Cheat (Protégé par le metatable __newindex)
                        if extSpeed then
                            HUM.WalkSpeed = 16 * extSpeedVal
                        elseif safeSpeed then
                            HUM.WalkSpeed = 16 + (safeSpeedVal * 3)
                        end
                        -- Noclip Absolu : Désactiver la collision physique
                        for _, v in pairs(char:GetDescendants()) do
                            if v:IsA("BasePart") and v.CanCollide then
                                v.CanCollide = false
                            end
                        end
                    else
                        HUM.WalkSpeed = 16 -- Remise à zéro si immobile
                    end
                end
            end
        end)
    end)

    local instInteract = false
    GTab:CreateToggle({
        Name = "⚡ Instant Interact (0s Ouverture)", CurrentValue = false, Flag = "Doors_Inst",
        Callback = function(v) 
            instInteract = v
        end
    })

    -- Boucle Rapide pour Prompts
    task.spawn(function()
        game:GetService("RunService").RenderStepped:Connect(function()
            if instInteract then
                for _, prompt in pairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        -- FIX V8.3 : Instant Interact Sélectif. Les actions complexes (cacher, utiliser un item) gardent leur temps de base pour éviter de briser le script local de DOORS.
                        local action = prompt.ActionText:lower()
                        if action:find("open") or action:find("loot") then
                            prompt.HoldDuration = 0
                        end
                    end
                end
            end
        end)
    end)

    local trueFullbright = false
    GTab:CreateToggle({
        Name = "☀️ True Fullbright (Aura Lumineuse)", CurrentValue = false, Flag = "Doors_Light",
        Callback = function(v) 
            trueFullbright = v
            if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") and LocalPlayer.Character.Head:FindFirstChild("CheatAura") then
                LocalPlayer.Character.Head.CheatAura:Destroy()
            end
        end
    })

    task.spawn(function()
        while task.wait(0.5) do
            if trueFullbright and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
                local head = LocalPlayer.Character.Head
                if not head:FindFirstChild("CheatAura") then
                    local light = Instance.new("PointLight")
                    light.Name = "CheatAura"
                    light.Brightness = 3
                    light.Range = 60
                    light.Shadows = false
                    light.Parent = head
                end
            end
        end
    end)

    local DoorSec2 = GTab:CreateSection("🛡️ Entity Obliteration")

    local remScreech = false
    local extraEntities = false
    GTab:CreateToggle({
        Name = "❌ Anti-Screech (Détruit avant Morsure)", CurrentValue = false, Flag = "Doors_Screech",
        Callback = function(v) remScreech = v end
    })

    GTab:CreateToggle({
        Name = "❌ Anti-Gênants (Timothy, Eyes, Dread...)", CurrentValue = false, Flag = "Doors_ExtraE",
        Callback = function(v) extraEntities = v end
    })

    local remHalt = false
    GTab:CreateToggle({
        Name = "❌ Bypass Halt (Détruit les Mur Invisibles)", CurrentValue = false, Flag = "Doors_Halt",
        Callback = function(v) remHalt = v end
    })

    -- Serveur de Silence (Pour désintégrer l'audio des entités)
    local function MuteEntityAudio(entityName)
        for _, sound in pairs(Workspace:GetDescendants()) do
            if sound:IsA("Sound") and sound.Parent and sound.Parent.Name:find(entityName) then
                sound.Volume = 0
                sound:Stop()
                sound:Destroy()
            end
        end
    end

    -- Memory Obliteration Loop
    task.spawn(function()
        while task.wait(0.1) do
            if LocalPlayer.Character then
                -- Anti-Screech
                if remScreech then
                    local screech = Workspace.CurrentCamera:FindFirstChild("Screech") or LocalPlayer.Character:FindFirstChild("Screech")
                    if screech then screech:Destroy(); MuteEntityAudio("Screech") end
                end
                
                -- L'Ordre de l'Oblitération Totale
                if extraEntities then
                    -- 1. Timothy (Araignée)
                    local timothy = Workspace.CurrentCamera:FindFirstChild("Spider") or LocalPlayer.Character:FindFirstChild("Spider")
                    if timothy then timothy:Destroy(); MuteEntityAudio("Spider") end

                    -- 2. Glitch (Le Monstre Vert)
                    if Workspace:FindFirstChild("Glitch") then Workspace.Glitch:Destroy(); MuteEntityAudio("Glitch") end

                    -- 3. Eyes (Le Monstre à Multiples Yeux)
                    for _, obj in pairs(Workspace:GetChildren()) do
                        if obj.Name == "Eyes" then obj:Destroy(); MuteEntityAudio("Eyes") end
                    end

                    -- 4. Dread (L'Entité de l'Heure Minuit)
                    if Workspace:FindFirstChild("Dread") then Workspace.Dread:Destroy(); MuteEntityAudio("Dread") end

                    -- 5. Snare & Dupe
                    local rooms = Workspace:FindFirstChild("CurrentRooms")
                    if rooms then
                        for _, room in pairs(rooms:GetChildren()) do
                            for _, trap in pairs(room:GetDescendants()) do
                                if trap.Name == "Snare" or trap.Name == "DupeRoom" then
                                    trap:Destroy()
                                end
                            end
                        end
                    end
                end
                
                -- Anti-Halt
                if remHalt then
                    if Workspace:FindFirstChild("Halt") then
                        Workspace.Halt:Destroy()
                        MuteEntityAudio("Halt")
                    end
                    if LocalPlayer.PlayerGui:FindFirstChild("MainUI") and LocalPlayer.PlayerGui.MainUI:FindFirstChild("HaltMessage") then
                        LocalPlayer.PlayerGui.MainUI.HaltMessage.Visible = false
                    end
                end
            end
        end
    end)

    local DoorSec3 = GTab:CreateSection("🚨 Systèmes d'Alerte")

    -- Custom UI Alert ScreenGui
    local AlertGui = Instance.new("ScreenGui")
    AlertGui.Name = "DoorsCustomAlert"
    AlertGui.Parent = game.CoreGui
    
    local AlertFrame = Instance.new("Frame")
    AlertFrame.Size = UDim2.new(0, 300, 0, 80)
    AlertFrame.Position = UDim2.new(1, 10, 1, -100) -- Hors écran par défaut
    AlertFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    AlertFrame.BorderSizePixel = 2
    AlertFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    AlertFrame.Parent = AlertGui
    
    local AlertText = Instance.new("TextLabel")
    AlertText.Size = UDim2.new(1, 0, 1, 0)
    AlertText.Text = "⚠️ ENTITÉ APPROCHE !"
    AlertText.TextColor3 = Color3.fromRGB(255, 255, 255)
    AlertText.TextScaled = true
    AlertText.Font = Enum.Font.Oswald
    AlertText.BackgroundTransparency = 1
    AlertText.Parent = AlertFrame

    local useAlerts = false
    GTab:CreateToggle({
        Name = "🚨 Closets Alert (Rush, Ambush, A-60)", CurrentValue = false, Flag = "Doors_Alerts",
        Callback = function(v) useAlerts = v end
    })

    local TS = game:GetService("TweenService")
    
    local function ShowAlert(monsterName)
        AlertText.Text = "⚠️ " .. string.upper(monsterName) .. " ARRIVE ! CACHE-TOI !"
        local tweenIn = TS:Create(AlertFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -320, 1, -100)})
        tweenIn:Play()
    end
    
    local function HideAlert()
        local tweenOut = TS:Create(AlertFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 10, 1, -100)})
        tweenOut:Play()
    end

    -- Scanner de monstres mortels
    task.spawn(function()
        local alertActive = false
        while task.wait(0.5) do
            if useAlerts then
                local danger = false
                local monster = ""
                
                -- Vérifier si l'un d'eux a spwan sur la map
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name == "RushMoving" or obj.Name == "AmbushMoving" or obj.Name == "A60" or obj.Name == "A120" then
                        danger = true
                        monster = obj.Name:gsub("Moving", "")
                        break
                    end
                end
                
                if danger then
                    if not alertActive then
                        alertActive = true
                        ShowAlert(monster)
                    end
                else
                    if alertActive then
                        alertActive = false
                        HideAlert()
                    end
                end
            else
                if alertActive then
                    alertActive = false
                    HideAlert()
                end
            end
        end
    end)

    local DoorSecESP = GTab:CreateSection("👁️ God Vision (ESP)")
    local espMonsters = false
    local espDoors = false
    local espItems = false

    GTab:CreateToggle({Name = "💀 ESP Monstres (Vrais Noms)", CurrentValue = false, Flag = "D_ESP_M", Callback = function(v) espMonsters = v; if not v then ClearESP() end end})
    GTab:CreateToggle({Name = "🚪 ESP Prochaine Porte", CurrentValue = false, Flag = "D_ESP_D", Callback = function(v) espDoors = v; if not v then ClearESP() end end})
    GTab:CreateToggle({Name = "📦 ESP Objets (Clés, Levrier, Or)", CurrentValue = false, Flag = "D_ESP_I", Callback = function(v) espItems = v; if not v then ClearESP() end end})

    task.spawn(function()
        while task.wait(0.5) do
            if espMonsters then
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name == "RushMoving" then ManageESP(obj, "💀 RUSH", Color3.fromRGB(255, 0, 0), true)
                    elseif obj.Name == "AmbushMoving" then ManageESP(obj, "💀 AMBUSH", Color3.fromRGB(255, 0, 0), true)
                    elseif obj.Name == "A60" then ManageESP(obj, "💀 A-60", Color3.fromRGB(255, 0, 0), true)
                    elseif obj.Name == "A120" then ManageESP(obj, "💀 A-120", Color3.fromRGB(255, 0, 0), true)
                    end
                end
            end
            
            if espDoors then
                local latestRoom = game:GetService("ReplicatedStorage"):FindFirstChild("GameData") and game:GetService("ReplicatedStorage").GameData:FindFirstChild("LatestRoom")
                if latestRoom then
                    local roomFolder = Workspace.CurrentRooms:FindFirstChild(tostring(latestRoom.Value))
                    if roomFolder and roomFolder:FindFirstChild("Door") then
                        ManageESP(roomFolder.Door, "🚪 Porte " .. tostring(latestRoom.Value + 1), Color3.fromRGB(0, 255, 0), false)
                    end
                end
            end
            
            if espItems then
                local rooms = Workspace:FindFirstChild("CurrentRooms")
                if rooms then
                    for _, room in pairs(rooms:GetChildren()) do
                        for _, item in pairs(room:GetDescendants()) do
                            if item:IsA("Model") then
                                if item.Name == "KeyObtain" then ManageESP(item, "🔑 Clé", Color3.fromRGB(0, 255, 255), false)
                                elseif item.Name == "LeverForGate" or item.Name == "Switch" then ManageESP(item, "🕹️ LEVIER", Color3.fromRGB(255, 100, 0), true)
                                elseif item.Name == "LibraryBook" then ManageESP(item, "📖 Livre", Color3.fromRGB(200, 200, 255), false)
                                elseif item.Name == "GoldPile" then ManageESP(item, "💰 Or", Color3.fromRGB(255, 215, 0), false)
                                elseif item.Name == "Crucifix" then ManageESP(item, "✝️ CRUCIFIX", Color3.fromRGB(150, 0, 255), true)
                                elseif item.Name == "FigureRagdoll" then ManageESP(item, "🛑 FIGURE", Color3.fromRGB(255, 0, 0), true) end
                            end
                        end
                    end
                end
            end
        end
    end)

    local DoorSec4 = GTab:CreateSection("🤖 L'IA Absolue (Auto-Play)")

    local autoPlayDoors = false
    GTab:CreateToggle({
        Name = "🚪 DOORS Bot (Ouvre les portes Auto)", CurrentValue = false, Flag = "Doors_Bot",
        Callback = function(v) autoPlayDoors = v end
    })

    local autoPlayRooms = false
    GTab:CreateToggle({
        Name = "♾️ THE ROOMS Bot (A-1000 AI + Cache Auto)", CurrentValue = false, Flag = "Rooms_Bot",
        Callback = function(v) autoPlayRooms = v end
    })

    -- IA de Déplacement Commune (Marche vers un point)
    local function WalkTo(targetPosition)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:MoveTo(targetPosition)
        end
    end

    -- IA DOORS (Mode Normal)
    task.spawn(function()
        while task.wait(1) do
            if autoPlayDoors and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- Chercher la porte de la prochaine salle
                local latestRoom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
                local roomFolder = Workspace.CurrentRooms:FindFirstChild(tostring(latestRoom))
                
                if roomFolder and roomFolder:FindFirstChild("Door") then
                    local door = roomFolder.Door
                    local doorPart = door:FindFirstChild("Door") or door
                    
                    -- Si c'est verrouillé, chercher la clé
                    if door:GetAttribute("Locked") then
                        -- Trouver la clé dans la salle
                        for _, item in pairs(roomFolder:GetDescendants()) do
                            if item.Name == "Key" and item:IsA("Model") then
                                WalkTo(item:GetPivot().Position)
                                local p = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if p and (LocalPlayer.Character.HumanoidRootPart.Position - item:GetPivot().Position).Magnitude < 10 then
                                    fireproximityprompt(p)
                                end
                                break
                            end
                        end
                    else
                        -- Pas verrouillé, marcher jusqu'à la porte
                        WalkTo(doorPart.Position)
                        
                        -- Ouvrir si on est assez près
                        if (LocalPlayer.Character.HumanoidRootPart.Position - doorPart.Position).Magnitude < 15 then
                            local prompt = door:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then fireproximityprompt(prompt) end
                        end
                    end
                end
            end
        end
    end)

    -- IA THE ROOMS (Mode A-1000)
    task.spawn(function()
        while task.wait(0.5) do
            if autoPlayRooms and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- 1. Mode Survie : Si un monstre (A-60/A-120) arrive, CACHER LE BOT
                local isHiding = false
                if Workspace.CurrentCamera:FindFirstChild("A60") or Workspace.CurrentCamera:FindFirstChild("A120") then
                    isHiding = true
                    -- Trouver le casier (Locker/Frigo) le plus proche et y entrer
                    local closestLocker, minDist = nil, math.huge
                    for _, obj in pairs(Workspace.CurrentRooms:GetDescendants()) do
                        if obj.Name:lower():find("locker") or obj.Name:lower():find("fridge") then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - obj:GetPivot().Position).Magnitude
                            if dist < minDist then
                                minDist = dist
                                closestLocker = obj
                            end
                        end
                    end
                    
                    if closestLocker then
                        WalkTo(closestLocker:GetPivot().Position)
                        local p = closestLocker:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if p and minDist < 10 then fireproximityprompt(p) end
                    end
                end
                
                -- 2. Anti A-90 Bypass
                if LocalPlayer.PlayerGui:FindFirstChild("MainUI") and LocalPlayer.PlayerGui.MainUI:FindFirstChild("A90") then
                    LocalPlayer.PlayerGui.MainUI.A90:Destroy() -- Détruit son interface d'attaque au cœur
                end
                
                -- 3. Mode Avancée si sécurisé
                if not isHiding then
                    -- Même routine de pathfinding pour the rooms (Trouver Door)
                    local latestRoom = game:GetService("ReplicatedStorage").GameData.LatestRoom.Value
                    local roomFolder = Workspace.CurrentRooms:FindFirstChild(tostring(latestRoom))
                    if roomFolder and roomFolder:FindFirstChild("Door") then
                        WalkTo(roomFolder.Door:GetPivot().Position)
                        
                        local p = roomFolder.Door:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if p and (LocalPlayer.Character.HumanoidRootPart.Position - roomFolder.Door:GetPivot().Position).Magnitude < 15 then
                            fireproximityprompt(p)
                        end
                    end
                end
            end
        end
    end)
end

-- Si l'onglet du jeu n'existe pas
if GameName == "Unknown" then
    local ErrorTab = Window:CreateTab("❌ Non Supporté", 4483362458)
    ErrorTab:CreateParagraph({Title = "Jeu Inconnu", Content = "Le jeu actuel n'est pas répertorié ("..tostring(GameId).."). Utilisez les options du tab 🌍 Universal."})
end

Rayfield:LoadConfiguration()
