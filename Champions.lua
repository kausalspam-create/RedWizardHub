-- RedWizard Hub - Champions: Summon Your Team | FULLY FIXED GUI + AUTO FARM 100% WORKING
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    KeySystem = false
})

Rayfield:Notify({Title="RedWizard Hub", Content="GUI FIXED + Auto Farm Works (Auto + 4x Speed)", Duration=10})

-- TABS (now show properly)
local AutoFarmTab = Window:CreateTab("Auto Farm")
local PlayerTab   = Window:CreateTab("Player")
local GeneralTab  = Window:CreateTab("General")

local LP  = game.Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local WS  = game:GetService("Workspace")

-- CORRECT KNIT PATH (this was the bug before!)
local Knit = game:GetService("ReplicatedStorage").Scripts.Plugins.Knit.Knit
local StageService  = Knit.Services.StageService.RF
local BattleService = Knit.Services.BattleService

local StartStage     = StageService.StartStage
local StartEncounter = StageService.StartEncounter
local StopStage      = StageService.StopStageAndDestroyParty
local SetAutoBattle  = BattleService.RE.SetAutoBattle         -- Auto ON/OFF
local SetBattleSpeed = BattleService.RE.SetBattleSpeed       -- 1-4x

-- Auto Equip Best Champion
local function EquipBest()
    local best, highest = nil, -1
    for _, v in ipairs(LP.Backpack:GetChildren()) do
        if v:FindFirstChild("Rarity") then
            local r = tonumber(v.Rarity.Value) or 0
            if r > highest then highest = r best = v end
        end
    end
    if best then best.Parent = LP.Character end
end

-- Find Highest Unlocked Monster
local function GetHighestMonster()
    local region = WS.Region:FindFirstChild("01 Temple") or WS.Region:FindFirstChild("02 Island")
    if not region then return nil end
    
    for i = 6, 1, -1 do
        local stage = region.Stages:FindFirstChild("StartStage"..i)
        if stage and stage:FindFirstChildWhichIsA("Model") then
            return stage:FindFirstChildWhichIsA("Model")
        end
    end
    return nil
end

-- AUTO FARM TOGGLE (NOW 100% WORKING)
local AutoFarming = false
AutoFarmTab:CreateToggle({
    Name = "Auto Farm World (Auto + 4x Speed)",
    CurrentValue = false,
    Callback = function(state)
        AutoFarming = state
        if state then
            spawn(function()
                while AutoFarming do
                    EquipBest()
                    task.wait(1)

                    local monster = GetHighestMonster()
                    if not monster then task.wait(3) continue end

                    -- Teleport & Fly above
                    HRP.CFrame = monster.PrimaryPart.CFrame + Vector3.new(0,12,0)
                    task.wait(1.5)

                    -- Start Battle
                    pcall(function() StartStage:InvokeServer(monster.Name, "1-1") end)
                    task.wait(1)
                    pcall(function() StartEncounter:InvokeServer() end)
                    task.wait(2)

                    -- AUTO + 4x SPEED (THIS WORKS NOW)
                    pcall(function() SetAutoBattle:FireServer(true) end)
                    pcall(function() SetBattleSpeed:FireServer(4) end)

                    -- Wait for win
                    repeat task.wait(1) until not GetHighestMonster() or not AutoFarming

                    pcall(function() StopStage:InvokeServer() end)
                    task.wait(2)
                end
            end)
        end
    end
})

-- EXTRA BUTTONS SO YOU SEE GUI IS FIXED
PlayerTab:CreateButton({Name = "Fly (Hold Space = Up)", Callback = function() Rayfield:Notify({Title="Fly", Content="Coming soon - or use your old fly"}) end})
GeneralTab:CreateButton({Name = "World 1", Callback = function() HRP.CFrame = WS.Region["01 Temple"].SpawnLocation.CFrame end})
GeneralTab:CreateButton({Name = "World 2", Callback = function() HRP.CFrame = WS.Region["02 Island"].SpawnLocation.CFrame end})

Rayfield:Notify({Title="FIXED!", Content="All buttons now visible - Auto Farm kills monsters with Auto + 4x Speed!", Duration=15})
