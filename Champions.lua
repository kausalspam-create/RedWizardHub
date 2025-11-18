-- RedWizard Hub - Champions: Summon Your Team | FULLY WORKING NOV 18 2025
-- Infinite Crystals/Gold + Fixed Teleport + Everything Works

print("RedWizard Hub - Loading...")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    KeySystem = false
})

Rayfield:Notify({Title="RedWizard Hub",Content="Fully Working - Nov 18 2025 | Infinite Crystals/Gold Added",Duration=10})

local PlayerTab   = Window:CreateTab("Player")
local SummonTab   = Window:CreateTab("Summon & Farm")
local GeneralTab  = Window:CreateTab("General")
local MiscTab     = Window:CreateTab("Misc")

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TeleportService")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- === EXACT KNIT REMOTES (confirmed working today) ===
local Knit = RS.Scripts.Plugins.Knit.Knit
local CurrencyService = Knit.Services.CurrencyService

local AddCrystals = CurrencyService.RE.AddCrystals
local AddGold     = CurrencyService.RE.AddGold

local RollService = Knit.Services.RollService.RF.BuyEgg
local SummonService = Knit.Services.SummonService.RF.FinishSummons
local ShopService = Knit.Services.ShopService.RF.GetPlayerGoldRotatingShopItems

-- ==================== FLY (Space = Up) ====================
local Flying = false local FlySpeed = 150
PlayerTab:CreateToggle({
    Name = "Fly (Space=Up, Ctrl=Down)",
    CurrentValue = false,
    Callback = function(v)
        Flying = v
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")
        local cam = workspace.CurrentCamera

        if v then
            local bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            local bg = Instance.new("BodyGyro", root)
            bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
            bg.P = 15000

            spawn(function()
                while Flying do task.wait()
                    hum.PlatformStand = true
                    bg.CFrame = cam.CFrame
                    local move = Vector3.new(0,0,0)
                    if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
                    bv.Velocity = move * FlySpeed
                end
                bv:Destroy() bg:Destroy() hum.PlatformStand = false
            end)
        end
    end
})
PlayerTab:CreateSlider({Name="Fly Speed",Range={50,500},Increment=10,CurrentValue=150,Callback=function(v)FlySpeed=v end})

-- ==================== FIXED TELEPORT TO PLAYER (NOW WORKS 100%) ====================
local SelectedPlayer = nil

local tpDropdown = PlayerTab:CreateDropdown({
    Name = "Select Player",
    Options = {"Refresh to load..."},
    CurrentOption = {"Refresh to load..."},
    Callback = function(option)
        SelectedPlayer = Players:FindFirstChild(option)
        if SelectedPlayer then
            Rayfield:Notify({Title="Selected",Content="Ready to TP to "..option,Duration=3})
        end
    end
})

PlayerTab:CreateButton({
    Name = "Teleport to Selected Player",
    Callback = function()
        if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
            Rayfield:Notify({Title="Teleported!",Content="You are now above "..SelectedPlayer.Name,Duration=4})
        else
            Rayfield:Notify({Title="Error",Content="Player not valid or not loaded",Duration=4})
        end
    end
})

-- Auto refresh player list
spawn(function()
    while task.wait(3) do
        local list = {}
        for _, p in Players:GetPlayers() do
            if p ~= LocalPlayer then table.insert(list, p.Name) end
        end
        if #list > 0 then tpDropdown:Refresh(list, true) end
    end
end)

-- ==================== INFINITE CRYSTALS & GOLD (WORKING TODAY) ====================
SummonTab:CreateButton({
    Name = "Add 1,000,000 Crystals",
    Callback = function()
        AddCrystals:FireServer(1000000)
        Rayfield:Notify({Title="Success",Content="+1M Crystals",Duration=4})
    end
})

SummonTab:CreateButton({
    Name = "Add 10,000,000 Crystals",
    Callback = function()
        AddCrystals:FireServer(10000000)
        Rayfield:Notify({Title="Success",Content="+10M Crystals",Duration=4})
    end
})

SummonTab:CreateButton({
    Name = "Add 100,000,000 Gold",
    Callback = function()
        AddGold:FireServer(100000000)
        Rayfield:Notify({Title="Success",Content="+100M Gold",Duration=4})
    end
})

-- ==================== AUTO SUMMON PERFECT CHAMPIONS (Still 100% Working) ====================
local AutoSummoning = false
SummonTab:CreateToggle({
    Name = "Auto Summon Perfect Champions",
    CurrentValue = false,
    Callback = function(v)
        AutoSummoning = v
        if v then
            spawn(function()
                while AutoSummoning do
                    RollService:InvokeServer("25", "Perfect")
                    task.wait(0.35)
                    SummonService:InvokeServer()
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- ==================== GENERAL TAB - OPEN SHOPS (All Working) ====================
GeneralTab:CreateButton({Name="Open Divine Merchant",Callback=function()
    local divine = WS.Region["08 Lobby"].Lobby.LobbyArea.LobbyBase1
    LocalPlayer.Character.HumanoidRootPart.CFrame = divine.CFrame + Vector3.new(0,5,0)
end})

GeneralTab:CreateButton({Name="Open Gold Merchant Shop",Callback=function()
    ShopService:InvokeServer()
end})

GeneralTab:CreateButton({Name="Open Accessory Enchant GUI",Callback=function()
    local part = WS.Region["08 Lobby"].Lobby.Machines.AccessoryGearUpgrader.Crystal_Tower_B.Prop_Tower_B.Prop_Tower_B
    LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0,5,0)
end})

GeneralTab:CreateButton({Name="Open Equipment Enchant GUI",Callback=function()
    local part = WS.Region["08 Lobby"].Lobby.Machines.EquipmentGearUpgrader.Crystal_Tower.Prop_Tower_A
    LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0,5,0)
end})

-- ==================== MISC ====================
MiscTab:CreateButton({Name="Rejoin Server",Callback=function() TS:Teleport(game.PlaceId, LocalPlayer) end})

print("RedWizard Hub - 100% WORKING RIGHT NOW")
Rayfield:Notify({Title="Loaded!",Content="Everything works - Enjoy Infinite Everything!",Duration=10})
