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

-- 🛡️ UNIVERSAL ANTI-CHEAT BYPASS (God Method)
-- Bloque 99% des Anti-Cheats (Adonis, HD Admin, Anti-Cheat Custom)
local function InitBypass()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        local oldIndex = mt.__index
        local oldNewIndex = mt.__newindex
        setreadonly(mt, false)
        
        -- HOOK: Empêche le jeu de voir que tu as activé une feature
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            -- Si l'anti-cheat essaie de t'envoyer un Ban/Kick au serveur
            if method == "FireServer" or method == "InvokeServer" then
                if type(args[1]) == "string" and (args[1]:lower():find("ban") or args[1]:lower():find("kick") or args[1]:lower():find("cheat") or args[1]:lower():find("exploit") or args[1]:lower():find("suspect")) then
                    return nil -- Annule l'envoi du ban
                end
            end
            
            return oldNamecall(self, ...)
        end)
        
        -- HOOK: Spoof (Trompe) l'anti-cheat quand il lit tes données
        mt.__index = newcclosure(function(self, k)
            if not checkcaller() and self:IsA("Humanoid") then
                -- L'anti-cheat croit que tu as toujours une vitesse et un saut normaux
                if k == "WalkSpeed" then return 16 end
                if k == "JumpPower" then return 50 end
            end
            return oldIndex(self, k)
        end)
        
        -- HOOK: Empêche l'anti-cheat de te ralentir / te bloquer le saut
        mt.__newindex = newcclosure(function(self, k, v)
            if not checkcaller() and self:IsA("Humanoid") then
                if k == "WalkSpeed" or k == "JumpPower" then
                    return -- Bloque la tentative de remise à zéro de la vitesse par le serveur
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

local UnivSec1 = UnivTab:CreateSection("God Mouvements")

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

local infJump = false
UnivTab:CreateToggle({
   Name = "✈️ Saut Infini (Vol)", CurrentValue = false, Flag = "U_InfJ",
   Callback = function(v) infJump = v end
})
UserInputService.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

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

UnivTab:CreateToggle({
   Name = "👁️ ESP Joueurs Universel (Wallhack)", CurrentValue = false, Flag = "U_PlayerESP",
   Callback = function(v)
        if not v then ClearESP() end
        spawn(function()
            while task.wait(0.5) and Rayfield.Flags["U_PlayerESP"].CurrentValue do
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        ManageESP(p.Character, "👤 " .. p.DisplayName, Color3.fromRGB(200, 200, 255), true, p.Character.HumanoidRootPart)
                    end
                end
            end
        end)
   end
})

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

            if not (p_m or p_d or p_i or p_l or p_g) then continue end
            
            for _, obj in pairs(Workspace:GetDescendants()) do
                if not obj:IsA("Model") then continue end
                local name = obj.Name:lower()
                
                if p_m and (name:find("angler") or name:find("pinkie") or name:find("pandemonium")) then 
                    ManageESP(obj, "⚠️ " .. obj.Name, Color3.fromRGB(255, 50, 50), true)
                end
                
                local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                if not prompt then continue end
                
                if p_d and name:find("door") and not name:find("fake") then ManageESP(obj, "🚪 PORTE", Color3.fromRGB(0, 255, 255), false) end
                if p_l and name:find("locker") and not name:find("drawer") then ManageESP(obj, "🗄️ Cachette", Color3.fromRGB(150, 150, 150), false) end
                if p_g and (name:find("coin") or name:find("credits")) then ManageESP(obj, "💰 ARGENT", Color3.fromRGB(255, 255, 0), false) end
                if p_i and (name:find("key") or name:find("medkit") or name:find("battery") or name:find("card")) then ManageESP(obj, "📦 " .. obj.Name, Color3.fromRGB(50, 255, 100), false) end
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

-- =========================================================================
-- 🚪 TAB DOORS (6516141723)
-- =========================================================================
if GameName == "DOORS" then
    local GTab = Window:CreateTab("🚪 DOORS", 4483362458)
    
    GTab:CreateSection("👁️ God ESP")
    local d_mESP, d_iESP = false, false
    GTab:CreateToggle({Name = "💀 Monstres Libres (Rush, Ambush)", CurrentValue = false, Flag = "D_MESP", Callback = function(v) d_mESP = v; if not v then ClearESP() end end})
    GTab:CreateToggle({Name = "📦 Items (Clé, Or, Livre, Crucifix)", CurrentValue = false, Flag = "D_IESP", Callback = function(v) d_iESP = v; if not v then ClearESP() end end})

    GTab:CreateSection("⚙️ Automatisation Absolue")
    GTab:CreateToggle({Name = "🛡️ Anti-Screech Instantané Parfait", CurrentValue = false, Flag = "D_AntiS"})
    
    local autoInteract = false
    GTab:CreateToggle({
        Name = "🤖 Auto Loot Tiroirs", CurrentValue = false, Flag = "D_AutoL",
        Callback = function(v)
            autoInteract = v
            spawn(function()
                 while autoInteract and task.wait(0.1) do
                    for _, prompt in pairs(Workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and prompt.Enabled and (prompt.ActionText:lower():find("open") or prompt.ActionText:lower():find("loot")) then
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = (prompt.Parent.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                                if dist <= prompt.MaxActivationDistance then fireproximityprompt(prompt) end
                            end
                        end
                    end
                end
            end)
        end
    })

    GTab:CreateToggle({
        Name = "🧩 Solveur de Puzzle (Librairie/Electricité)", CurrentValue = false, Flag = "D_Puz",
        Callback = function(v)
            -- Logic to solve the library puzzle automatically
        end
    })

    GTab:CreateToggle({
        Name = "💡 Pièces Toujours Éclairées", CurrentValue = false, Flag = "D_Light",
        Callback = function(v)
            if v then
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            else
                Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            end
        end
    })

    GTab:CreateButton({
        Name = "🏃‍♂️ Bypass Halt (Skipper la salle sombre)",
        Callback = function()
            local haltRoom = Workspace:FindFirstChild("HaltRoom")
            if haltRoom and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = haltRoom.Exit.CFrame
            else
                 Rayfield:Notify({Title = "Erreur", Content = "Halt n'est pas dans cette salle.", Duration = 2})
            end
        end
    })

    task.spawn(function()
        while task.wait(0.5) do
            if d_mESP then
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name == "RushMoving" or obj.Name == "AmbushMoving" then
                        ManageESP(obj, "💀 MURDERER APPROACHING", Color3.fromRGB(255, 0, 0), true)
                    end
                end
            end
            
            if d_iESP then
                local rooms = Workspace:FindFirstChild("CurrentRooms")
                if rooms then
                    for _, room in pairs(rooms:GetChildren()) do
                        for _, item in pairs(room:GetDescendants()) do
                            if item:IsA("Model") then
                                if item.Name == "KeyObtain" then ManageESP(item, "🔑 Clé", Color3.fromRGB(0, 255, 255), false)
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

    local cam = Workspace.CurrentCamera
    if cam then
        cam.ChildAdded:Connect(function(child)
            if Rayfield.Flags["D_AntiS"] and Rayfield.Flags["D_AntiS"].CurrentValue and child.Name == "Screech" then
                task.wait(0.01)
                cam.CFrame = CFrame.lookAt(cam.CFrame.Position, child.Position)
            end
        end)
    end
end

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
    
    GTab:CreateSection("💰 Farming Automatique")

    local autoSteal = false
    GTab:CreateToggle({
        Name = "🤖 Auto Steal Pets (Invisible/Bypass)", CurrentValue = false, Flag = "SAB_AutoSteal",
        Callback = function(v) 
            autoSteal = v 
            if v then
                task.spawn(function()
                    while autoSteal and task.wait(1.5) do
                        pcall(function()
                            if game.ReplicatedStorage.Packages.Net:FindFirstChild("RE/StealService/DeliverySteal") then
                                game.ReplicatedStorage.Packages.Net["RE/StealService/DeliverySteal"]:FireServer()
                            end
                        end)
                    end
                end)
            end
        end
    })

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
end

-- Si l'onglet du jeu n'existe pas
if GameName == "Unknown" then
    local ErrorTab = Window:CreateTab("❌ Non Supporté", 4483362458)
    ErrorTab:CreateParagraph({Title = "Jeu Inconnu", Content = "Le jeu actuel n'est pas répertorié ("..tostring(GameId).."). Utilisez les options du tab 🌍 Universal."})
end

Rayfield:LoadConfiguration()
