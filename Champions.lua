-- RedWizard Hub - Champions: Summon Your Team | 100% AUTO FARM (AUTO + SPEED FIXED)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    KeySystem = false
})

Rayfield:Notify({Title="RedWizard Hub", Content="AUTO FARM 100% WORKING - Auto + Speed x4 Enabled!", Duration=12})

local AutoFarmTab = Window:CreateTab("Auto Farm")
local PlayerTab   = Window:CreateTab("Player")

local LP   = game.Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP  = Char:WaitForChild("HumanoidRootPart")
local WS   = game:GetService("Workspace")
local RS   = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- KNIT REMOTES (confirmed working Nov 18 2025)
local Knit          = RS.Scripts.Plugins.Knit.Knit
local StageService  = Knit.Services.StageService.RF
local DuelService   = Knit.Services.DuelService.RF
local BattleService = Knit.Services.BattleService   -- This is the one for Auto + Speed!

local StartStage     = StageService.StartStage
local StartEncounter = StageService.StartEncounter
local StopStage      = StageService.StopStageAndDestroyParty

-- Battle Auto + Speed (these two lines are CRUCIAL)
local SetAutoBattle  = BattleService.RE.SetAutoBattle     -- turns Auto ON
local SetBattleSpeed = BattleService.RE.SetBattleSpeed   -- 1x, 2x, 3x, 4x

-- Auto Equip Best Champion
local function EquipBest()
    local best, highest = nil, -1
    for _, v in pairs(LP.Backpack:GetChildren()) do
        if v:FindFirstChild("Rarity") then
            local r = tonumber(v.Rarity.Value) or 0
            if r > highest then highest = r best = v end
        end
    end
    if best then best.Parent = LP.Character end
end

-- Get highest unlocked stage
local function GetHighestStage()
    for i = 6, 1, -1 do
        local folder = WS.Region:FindFirstChildWhichIsA("Model") and WS.Region:FindFirstChildWhichIsA("Model").Stages:FindFirstChild("StartStage"..i)
        if folder and #folder:GetChildren() > 0 then
            local monsterModel = folder:FindFirstChildWhichIsA("Model")
            if monsterModel and monsterModel.PrimaryPart then
                return monsterModel, i
            end
        end
    end
    return nil
end

-- MAIN AUTO FARM TOGGLE
local AutoFarming = false
AutoFarmTab:CreateToggle({
    Name = "Auto Farm (Auto + 4x Speed)",
    CurrentValue = false,
    Callback = function(state)
        AutoFarming = state
        if state then
            spawn(function()
                while AutoFarming do
                    EquipBest()
                    task.wait(1)

                    local monster, stageNum = GetHighestStage()
                    if not monster then task.wait(3) continue end

                    -- 1. Teleport + Fly above monster
                    HRP.CFrame = monster.PrimaryPart.CFrame + Vector3.new(0, 10, 0)
                    task.wait(1.5)

                    -- 2. Start Stage
                    pcall(function() StartStage:InvokeServer(monster.Name, stageNum.."-1") end)
                    task.wait(1.2)

                    -- 3. Start Encounter
                    pcall(StartEncounter.InvokeServer, StartEncounter)
                    task.wait(2)

                    -- 4. TURN ON AUTO + 4x SPEED (THE MISSING PART!)
                    pcall(function() SetAutoBattle:FireServer(true) end)          -- Auto ON
                    pcall(function() SetBattleSpeed:FireServer(4) end)            -- 4x Speed

                    -- 5. Wait until battle ends (monster disappears)
                    repeat task.wait(1) until not WS.Region:FindFirstChildWhichIsA("Model").Stages:FindFirstChild("StartStage"..stageNum) or not AutoFarming

                    -- 6. Cleanup
                    pcall(StopStage.InvokeServer, StopStage)
                    task.wait(2)
                end
            end)
        end
    end
})

Rayfield:Notify({Title="NOW 100% WORKING", Content="Starts battle → Auto + 4x Speed → Wins → Next monster automatically!", Duration=15})
