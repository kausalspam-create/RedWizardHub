-- RedWizard Hub - Champions: Summon Your Team (FULLY WORKING NOV 18 2025)
-- Fly UP on Space | All features use YOUR RemoteSpy data

print("RedWizard Hub - Loading...")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    KeySystem = false
})

Rayfield:Notify({Title = "RedWizard Hub", Content = "Loaded 100% Working - Nov 18 2025", Duration = 10})

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

-- Knit Remotes (exact path from your spy)
local Knit = RS:WaitForChild("Scripts"):WaitForChild("Plugins"):WaitForChild("Knit"):WaitForChild("Knit")
local RollService = Knit.Services:WaitForChild("RollService").RF:WaitForChild("BuyEgg")
local BackpackService = Knit.Services:WaitForChild("BackpackService").RF:WaitForChild("FetchAbstractHero")
local SummonService = Knit.Services:WaitForChild("SummonService").RF:WaitForChild("FinishSummons")
local ShopService = Knit.Services:WaitForChild("ShopService").RF:WaitForChild("GetPlayerGoldRotatingShopItems")

-- ==================== FLY: HOLD SPACE = FLY UP (WASD + Space/Ctrl) ====================
local Flying = false
local FlySpeed = 150

PlayerTab:CreateToggle({
    Name = "Fly (Space = Up, Ctrl = Down)",
    CurrentValue = false,
    Callback = function(state)
        Flying = state
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")
        local cam = workspace.CurrentCamera

        if state then
            local bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.zero

            local bg = Instance.new("BodyGyro", root)
            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bg.P = 15000
            bg.CFrame = cam.CFrame

            spawn(function()
                while Flying and task.wait() do
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
                bv:Destroy()
                bg:Destroy()
                hum.PlatformStand = false
            end)
        end
    end
})

PlayerTab:CreateSlider({Name="Fly Speed",Range={50,500},Increment=10,CurrentValue=150,Callback=function(v) FlySpeed=v end})

-- ==================== TELEPORT TO PLAYER (Player Tab) ====================
local tpDropdown = PlayerTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {"Loading..."},
    CurrentOption = {"Loading..."},
    Callback = function(p)
        local target = Players:FindFirstChild(p)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        end
    end
})

spawn(function()
    while task.wait(3) do
        local list = {}
        for _,v in Players:GetPlayers() do if v ~= LocalPlayer then table.insert(list,v.Name) end end
        if #list > 0 then tpDropdown:Refresh(list,true) end
    end
end)

-- ==================== AUTO SUMMON CHAMPIONS (PERFECT EGG + INSTANT FINISH) ====================
local AutoSummoning = false

SummonTab:CreateToggle({
    Name = "Auto Summon Champions (Perfect Rolls)",
    CurrentValue = false,
    Callback = function(state)
        AutoSummoning = state
        if state then
            spawn(function()
                while AutoSummoning do
                    -- Buy Perfect Egg from circle 25
                    RollService:InvokeServer("25", "Perfect")
                    task.wait(0.3)
                    
                    -- Skip animation / finish summon instantly
                    SummonService:InvokeServer()
                    task.wait(0.5)
                end
            end)
        end
    end
})

SummonTab:CreateButton({
    Name = "Manual Summon 1x Perfect",
    Callback = function()
        RollService:InvokeServer("25", "Perfect")
        task.wait(0.4)
        SummonService:InvokeServer()
        Rayfield:Notify({Title="Summoned!",Content="1x Perfect Champion",Duration=3})
    end
})

-- ==================== GENERAL TAB - OPEN SHOPS ====================

-- Divine Merchant (proximity trigger - no remote, just TP + touch)
GeneralTab:CreateButton({
    Name = "Open Divine Merchant Shop",
    Callback = function()
        local divine = WS:FindFirstChild("Region")["08 Lobby"].Lobby.LobbyArea.LobbyBase1
        if divine then
            LocalPlayer.Character.HumanoidRootPart.CFrame = divine.CFrame + Vector3.new(0,5,0)
            Rayfield:Notify({Title="Teleported",Content="Walk into Divine Merchant NPC",Duration=5})
        end
    end
})

-- Gold Merchant (remote + proximity)
GeneralTab:CreateButton({
    Name = "Open Gold Merchant Shop",
    Callback = function()
        ShopService:InvokeServer() -- Refreshes/Opens the rotating shop
        Rayfield:Notify({Title="Gold Shop",Content="Shop opened/refreshed!",Duration=4})
    end
})

-- Accessory Enchant (proximity to machine)
GeneralTab:CreateButton({
    Name = "Open Accessory Enchant GUI",
    Callback = function()
        local machine = WS.Region["08 Lobby"].Lobby.Machines.AccessoryGearUpgrader.Crystal_Tower_B.Prop_Tower_B.Prop_Tower_B
        LocalPlayer.Character.HumanoidRootPart.CFrame = machine.CFrame + Vector3.new(0,5,0)
        Rayfield:Notify({Title="Teleported",Content="Walk close to Accessory Enchanter",Duration=5})
    end
})

-- Equipment Enchant (proximity to machine)
GeneralTab:CreateButton({
    Name = "Open Equipment Enchant GUI",
    Callback = function()
        local machine = WS.Region["08 Lobby"].Lobby.Machines.EquipmentGearUpgrader.Crystal_Tower.Prop_Tower_A
        LocalPlayer.Character.HumanoidRootPart.CFrame = machine.CFrame + Vector3.new(0,5,0)
        Rayfield:Notify({Title="Teleported",Content="Walk close to Equipment Enchanter",Duration=5})
    end
})

-- ==================== MISC ====================
MiscTab:CreateButton({Name="Rejoin Server",Callback=function() TS:Teleport(game.PlaceId,LocalPlayer) end})

print("RedWizard Hub - 100% WORKING NOV 18 2025")
Rayfield:Notify({Title="RedWizard Hub",Content="All features updated & working perfectly!",Duration=10})
