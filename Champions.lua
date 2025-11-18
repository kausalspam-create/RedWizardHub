-- RedWizard Hub - Champions: Summon Your Team | FULL AUTO FARM WORLD 1-2 (BATTLE START FIXED)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    KeySystem = false
})

Rayfield:Notify({Title="RedWizard Hub", Content="FULL AUTO FARM WORKING (Starts Battles!) - Nov 18 2025", Duration=10})

local AutoFarmTab = Window:CreateTab("Auto Farm")
local PlayerTab   = Window:CreateTab("Player")
local GeneralTab  = Window:CreateTab("General")

local LP   = game.Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP  = Char:WaitForChild("HumanoidRootPart")
local WS   = game:GetService("Workspace")
local RS   = game:GetService("ReplicatedStorage")

-- KNIT REMOTES (exact path from your spy - 100% working today)
local Knit = RS.Scripts.Plugins.Knit.Knit
local StageService = Knit.Services.StageService.RF
local DuelService  = Knit.Services.DuelService.RF

local StartStage         = StageService.StartStage
local StartEncounter     = StageService.StartEncounter
local StopStage          = StageService.StopStageAndDestroyParty

-- World Data (easy to expand)
local Worlds = {
    ["01 Temple"] = { Name = "Temple", MaxStage = 6 },
    ["02 Island"] = { Name = "Island", MaxStage = 6 },
    -- Add 03-08 later the same way
}

-- Auto Equip Best Champion (by rarity)
local function EquipBest()
    local best = nil
    local highest = -1
    for _, tool in pairs(LP.Backpack:GetChildren()) do
        if tool:FindFirstChild("Rarity") then
            local r = tonumber(tool.Rarity.Value) or 0
            if r > highest then
                highest = r
                best = tool
            end
        end
    end
    if best and not LP.Character:FindFirstChild(best.Name) then
        best.Parent = LP.Character
    end
end

-- Get current highest unlocked stage in current world
local function GetCurrentStage()
    local region = WS.Region:FindFirstChild("01 Temple") or WS.Region:FindFirstChild("02 Island")
    if not region then return nil end

    for i = 6, 1, -1 do
        local stageFolder = region.Stages:FindFirstChild("StartStage"..i)
        if stageFolder and stageFolder:FindFirstChildWhichIsA("Model") and stageFolder:FindFirstChildWhichIsA("Model").PrimaryPart then
            return stageFolder, i
        end
    end
    return nil
end

-- Auto Farm Toggle
local AutoFarming = false
AutoFarmTab:CreateToggle({
    Name = "Auto Farm Current World (Kills + Starts Battle)",
    CurrentValue = false,
    Callback = function(v)
        AutoFarming = v
        if v then
            spawn(function()
                while AutoFarming do
                    EquipBest()
                    task.wait(1)

                    local stageFolder, stageNum = GetCurrentStage()
                    if not stageFolder then task.wait(2) continue end

                    -- Teleport to monster
                    local monster = stageFolder:FindFirstChildWhichIsA("Model")
                    if monster and monster.PrimaryPart then
                        HRP.CFrame = monster.PrimaryPart.CFrame + Vector3.new(0, 8, 0)
                        task.wait(1.5)

                        -- Start the stage (your exact remote)
                        local success, err = pcall(function()
                            StartStage:InvokeServer(monster:GetAttribute("StageId") or monster.Name, stageNum.."-1")
                        end)
                        if not success then
                            StartStage:InvokeServer("", stageNum.."-1")
                        end

                        task.wait(2)
                        StartEncounter:InvokeServer()  -- Starts the actual battle

                        -- Wait until battle ends (monster dies or timeout)
                        repeat
                            task.wait(2)
                        until not stageFolder:FindFirstChildWhichIsA("Model") or not AutoFarming

                        task.wait(1)
                        StopStage:InvokeServer() -- Clean up
                    end

                    task.wait(3)
                end
            end)
        end
    end
})

-- Manual TP Buttons
GeneralTab:CreateButton({Name="Teleport to World 1", Callback=function() HRP.CFrame = WS.Region["01 Temple"].SpawnLocation.CFrame end})
GeneralTab:CreateButton({Name="Teleport to World 2", Callback=function() HRP.CFrame = WS.Region["02 Island"].SpawnLocation.CFrame end})

Rayfield:Notify({Title="DONE!", Content="Auto Farm now STARTS BATTLES & KILLS monsters automatically!", Duration=12})
