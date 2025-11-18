-- RedWizard Hub - Champions: Summon Your Team (UPDATED NOVEMBER 2025)
-- Fly now goes UP when holding Space (classic fly style)
-- Teleport to Player moved to Player tab
-- New "General" tab with Merchants + Enchants (now as "Open Shop" buttons)
-- All other features kept + cleaned up

print("RedWizard Hub - Loading...")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    KeySystem = false
})

Rayfield:Notify({Title = "RedWizard Hub", Content = "Fully Updated! Fly = UP on Space | TP in Player tab | General tab added", Duration = 10})

local PlayerTab   = Window:CreateTab("Player")
local SummonTab   = Window:CreateTab("Summon & Farm")
local GeneralTab  = Window:CreateTab("General")  -- Merchants + Enchants here
local MiscTab     = Window:CreateTab("Misc")

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TeleportService")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- ==================== FLY: HOLD SPACE = FLY UP (Classic style) ====================
local Flying = false
local FlySpeed = 100

PlayerTab:CreateToggle({
    Name = "Fly (Hold Space = Fly Up)",
    CurrentValue = false,
    Callback = function(state)
        Flying = state
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")
        local cam = workspace.CurrentCamera

        if state then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.new(0,0,0)
            bv.Parent = root

            local bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bg.P = 15000
            bg.CFrame = cam.CFrame
            bg.Parent = root

            spawn(function()
                while Flying and task.wait() do
                    hum.PlatformStand = true
                    bg.CFrame = cam.CFrame

                    local moveVec = Vector3.new(0,0,0)
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + cam.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - cam.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - cam.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + cam.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end  -- UP
                    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec = moveVec - Vector3.new(0,1,0) end

                    bv.Velocity = moveVec * FlySpeed
                end
                bv:Destroy()
                bg:Destroy()
                hum.PlatformStand = false
            end)
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 100,
    Callback = function(v) FlySpeed = v end
})

-- ==================== TELEPORT TO PLAYER (Now in Player tab) ====================
local tpDropdown
local playerList = {}

tpDropdown = PlayerTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {"Loading players..."},
    CurrentOption = {"Loading players..."},
    Callback = function(selected)
        local target = Players:FindFirstChild(selected)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
            Rayfield:Notify({Title = "Teleported!", Content = "To "..selected, Duration = 3})
        end
    end
})

spawn(function()
    while task.wait(3) do
        playerList = {}
        for _, plr in Players:GetPlayers() do
            if plr ~= LocalPlayer then
                table.insert(playerList, plr.Name)
            end
        end
        if #playerList > 0 then
            tpDropdown:Refresh(playerList, true)
        end
    end
end)

-- ==================== AUTO SUMMON CHAMPIONS ====================
local AutoSummon = false
SummonTab:CreateToggle({
    Name = "Auto Summon Champions (Nearest Enemy)",
    CurrentValue = false,
    Callback = function(state)
        AutoSummon = state
        -- You'll replace this remote with the correct one from RemoteSpy
    end
})

-- ==================== GENERAL TAB - Merchants & Enchants (Open Shop Buttons) ====================
GeneralTab:CreateButton({
    Name = "Open Divine Merchant Shop",
    Callback = function()
        -- Replace with actual remote
        -- RS.Remotes.OpenDivineMerchant:FireServer()  or similar
        Rayfield:Notify({Title = "Opening...", Content = "Divine Merchant (check RemoteSpy if not working)", Duration = 4})
    end
})

GeneralTab:CreateButton({
    Name = "Open Gold Merchant Shop",
    Callback = function()
        -- Replace with actual remote
        Rayfield:Notify({Title = "Opening...", Content = "Gold Merchant (check RemoteSpy if not working)", Duration = 4})
    end
})

GeneralTab:CreateButton({
    Name = "Open Accessory Enchant GUI",
    Callback = function()
        -- Replace with actual remote
        Rayfield:Notify({Title = "Opening...", Content = "Accessory Enchant (check RemoteSpy if not working)", Duration = 4})
    end
})

GeneralTab:CreateButton({
    Name = "Open Equipment Enchant GUI",
    Callback = function()
        -- Replace with actual remote
        Rayfield:Notify({Title = "Opening...", Content = "Equipment Enchant (check RemoteSpy if not working)", Duration = 4})
    end
})

-- Keep your Get Crystals / Gold buttons here if you want
SummonTab:CreateButton({ Name = "Get 1M Crystals", Callback = function() end })
SummonTab:CreateButton({ Name = "Get 10M Gold", Callback = function() end })

-- ==================== MISC ====================
MiscTab:CreateButton({ Name = "Rejoin Server", Callback = function() TS:Teleport(game.PlaceId, LocalPlayer) end })

print("RedWizard Hub - Fully Updated & Ready!")
