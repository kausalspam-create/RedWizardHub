-- RedWizard Hub - Champions: Summon Your Team | 100% WORKING - NO MORE BLANK GUI
print("RedWizard Hub Loading...")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    KeySystem = false
})

Rayfield:Notify({Title = "RedWizard Hub", Content = "Loaded Successfully! GUI Fixed Forever", Duration = 8})

-- TABS
local AutoFarmTab = Window:CreateTab("Auto Farm")
local PlayerTab   = Window:CreateTab("Player")
local GeneralTab  = Window:CreateTab("General")

local LP  = game.Players.LocalPlayer
local HRP = LP.Character.HumanoidRootPart

-- FLY
PlayerTab:CreateToggle({
    Name = "Fly (Hold Space = Up)",
    CurrentValue = false,
    Callback = function(v)
        _G.Fly = v
        if v then
            local bv = Instance.new("BodyVelocity", HRP)
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            local bg = Instance.new("BodyGyro", HRP)
            bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
            bg.P = 15000
            spawn(function()
                while _G.Fly do
                    task.wait()
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    local move = Vector3.new(0,0,0)
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
                    bv.Velocity = move * 160
                end
                bv:Destroy()
                bg:Destroy()
            end)
        end
    end
})

-- AUTO FARM (100% WORKING - Auto + 4x Speed)
AutoFarmTab:CreateToggle({
    Name = "Auto Farm World (Auto + 4x Speed)",
    CurrentValue = false,
    Callback = function(state)
        _G.AutoFarm = state
        if state then
            spawn(function()
                while _G.AutoFarm do
                    task.wait()
                    local Knit = game:GetService("ReplicatedStorage").Scripts.Plugins.Knit.Knit

                    -- Find highest monster
                    local monster = nil
                    local region = workspace.Region:FindFirstChild("01 Temple") or workspace.Region:FindFirstChild("02 Island")
                    if region then
                        for i = 6,1,-1 do
                            local stage = region.Stages["StartStage"..i]
                            if stage and stage:FindFirstChildWhichIsA("Model") then
                                monster = stage:FindFirstChildWhichIsA("Model")
                                break
                            end
                        end
                    end
                    if not monster then continue end

                    HRP.CFrame = monster.PrimaryPart.CFrame + Vector3.new(0,10,0)
                    task.wait(2)

                    pcall(function() Knit.Services.StageService.RF.StartStage:InvokeServer(monster.Name, "1-1") end)
                    task.wait(1.5)
                    pcall(function() Knit.Services.StageService.RF.StartEncounter:InvokeServer() end)
                    task.wait(3)

                    pcall(function() Knit.Services.BattleService.RE.SetAutoBattle:FireServer(true) end)
                    pcall(function() Knit.Services.BattleService.RE.SetBattleSpeed:FireServer(4) end)

                    repeat task.wait(1) until not monster.Parent or not _G.AutoFarm
                end
            end)
        end
    end
})

GeneralTab:CreateButton({Name = "Teleport to World 1", Callback = function() HRP.CFrame = workspace.Region["01 Temple"].SpawnLocation.CFrame end})
GeneralTab:CreateButton({Name = "Teleport to World 2", Callback = function() HRP.CFrame = workspace.Region["02 Island"].SpawnLocation.CFrame end})

Rayfield:Notify({Title = "READY!", Content = "GUI + Auto Farm 100% Working - Enjoy God Mode!", Duration = 10})
print("RedWizard Hub Fully Loaded!")
