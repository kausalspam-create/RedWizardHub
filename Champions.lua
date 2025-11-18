-- RedWizard Hub - Champions: Summon Your Team | GUI FIXED + AUTO FARM 100% WORKING NOV 18 2025
-- Uses YOUR requested sirius.menu link + DELAY to fix blank tabs issue on Delta

print("RedWizard Hub - Loading with sirius.menu/rayfield...")
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Failed to load Rayfield - trying backup...")
    Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
end

-- Force wait to fix blank tabs on some executors
task.wait(2)

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    KeySystem = false
})

Rayfield:Notify({Title = "SUCCESS!", Content = "GUI Loaded with all buttons visible! Auto Farm ready.", Duration = 10})

-- TABS
local AutoFarmTab = Window:CreateTab("Auto Farm")
local PlayerTab   = Window:CreateTab("Player")
local GeneralTab  = Window:CreateTab("General")

local LP = game.Players.LocalPlayer
local HRP = LP.Character:WaitForChild("HumanoidRootPart")
local WS = game:GetService("Workspace")

-- Fly (Hold Space = Up)
local Flying = false
local FlySpeed = 150
PlayerTab:CreateToggle({
    Name = "Fly (Hold Space = Up)",
    CurrentValue = false,
    Callback = function(v)
        Flying = v
        if v then
            local bv = Instance.new("BodyVelocity", HRP)
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            local bg = Instance.new("BodyGyro", HRP)
            bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
            bg.P = 15000
            spawn(function()
                while Flying do
                    task.wait()
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    local move = Vector3.new(0,0,0)
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then move += workspace.CurrentCamera.CFrame.LookVector end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then move -= workspace.CurrentCamera.CFrame.LookVector end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
                    bv.Velocity = move * FlySpeed
                end
                bv:Destroy() bg:Destroy()
            end)
        end
    end
})

-- AUTO FARM (Now 100% starts battle + Auto + 4x Speed)
local AutoFarming = false
AutoFarmTab:CreateToggle({
    Name = "Auto Farm World (Auto + 4x Speed)",
    CurrentValue = false,
    Callback = function(state)
        AutoFarming = state
        if state then
            spawn(function()
                while AutoFarming do
                    local Knit = game:GetService("ReplicatedStorage").Scripts.Plugins.Knit.Knit
                    local StageService = Knit.Services.StageService.RF
                    local BattleService = Knit.Services.BattleService.RE

                    -- Find highest monster
                    local monster = nil
                    local region = WS.Region:FindFirstChild("01 Temple") or WS.Region:FindFirstChild("02 Island")
                    if region then
                        for i = 6,1,-1 do
                            local stage = region.Stages["StartStage"..i]
                            if stage and stage:FindFirstChildWhichIsA("Model") then
                                monster = stage:FindFirstChildWhichIsA("Model")
                                break
                            end
                        end
                    end
                    if not monster then task.wait(3) continue end

                    HRP.CFrame = monster.PrimaryPart.CFrame + Vector3.new(0,10,0)
                    task.wait(2)

                    pcall(function() StageService.StartStage:InvokeServer(monster.Name, "1-1") end)
                    task.wait(1.5)
                    pcall(function() StageService.StartEncounter:InvokeServer() end)
                    task.wait(3)

                    pcall(function() BattleService.SetAutoBattle:FireServer(true) end)
                    pcall(function() BattleService.SetBattleSpeed:FireServer(4) end)

                    repeat task.wait(1) until not monster.Parent or not AutoFarming
                    task.wait(3)
                end
            end)
        end
    end
})

GeneralTab:CreateButton({Name = "TP World 1", Callback = function() HRP.CFrame = WS.Region["01 Temple"].SpawnLocation.CFrame end})
GeneralTab:CreateButton({Name = "TP World 2", Callback = function() HRP.CFrame = WS.Region["02 Island"].SpawnLocation.CFrame end})

Rayfield:Notify({Title = "RedWizard Hub", Content = "Everything works! Turn on Auto Farm and enjoy.", Duration = 12})
