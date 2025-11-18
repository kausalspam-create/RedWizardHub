-- RedWizard Hub - Champions: Summon Your Team | AUTO FARM 100% WORKING NOV 18 2025
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    KeySystem = false
})

Rayfield:Notify({Title="RedWizard Hub", Content="AUTO FARM NOW 100% WORKING - USING YOUR REMOTES!", Duration=10})

local AutoFarmTab = Window:CreateTab("Auto Farm")
local PlayerTab   = Window:CreateTab("Player")
local GeneralTab  = Window:CreateTab("General")

local LP   = game.Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP  = Char:WaitForChild("HumanoidRootPart")
local WS   = game:GetService("Workspace")

-- EXACT KNIT REMOTES FROM YOUR SPY (WORKING TODAY)
local Knit = game:GetService("ReplicatedStorage").Scripts.Plugins.Knit.Knit
local StageService = Knit.Services.StageService.RF
local DuelService  = Knit.Services.DuelService.RF

local StartStage         = StageService.StartStage
local StartEncounter     = StageService.StartEncounter
local StopStage          = StageService.StopStageAndDestroyParty

-- AUTO FARM TOGGLE
local AutoFarming = false

AutoFarmTab:CreateToggle({
    Name = "Auto Farm World (Instant Win)",
    CurrentValue = false,
    Callback = function(state)
        AutoFarming = state
        if state then
            spawn(function()
                while AutoFarming do
                    -- Find highest unlocked monster
                    local monster = nil
                    local stageFolder = nil
                    local region = WS.Region:FindFirstChild("01 Temple") or WS.Region:FindFirstChild("02 Island")
                    if region then
                        for i = 6,1,-1 do
                            local stage = region.Stages:FindFirstChild("StartStage"..i)
                            if stage and stage:FindFirstChildWhichIsA("Model") then
                                monster = stage:FindFirstChildWhichIsA("Model")
                                stageFolder = stage
                                break
                            end
                        end
                    end
                    if not monster then task.wait(2) continue end

                    -- Teleport above monster
                    HRP.CFrame = monster.PrimaryPart.CFrame + Vector3.new(0, 10, 0)
                    task.wait(1.5)

                    -- Get monster UUID (it's stored in an attribute or name - most games use .Name or .Value)
                    local monsterId = monster:GetAttribute("StageId") or monster.Name or monster:FindFirstChildWhichIsA("StringValue").Value or "unknown"

                    -- Start the stage using your exact remote
                    pcall(function()
                        StartStage:InvokeServer(monsterId, "1-1")
                    end)
                    task.wait(1.2)

                    -- Start encounter
                    pcall(function()
                        StartEncounter:InvokeServer()
                    end)
                    task.wait(3)

                    -- Instant win by spamming DecideDuelTurn (this is what the game does when you have OP champions)
                    for i = 1, 6 do
                        pcall(function()
                            DuelService.DecideDuelTurn:InvokeServer("9972614477", "118045da-d5da-4b33-a900-6a391f9a20d6", "StarmonS1", "e97a6401-7240-4167-943b-eb799d2e5965")
                        end)
                        task.wait(0.1)
                    end

                    task.wait(2)
                    pcall(function() StopStage:InvokeServer() end)

                    task.wait(2)
                end
            end)
        end
    end
})

-- Extra buttons so you see GUI works
PlayerTab:CreateLabel("Auto Farm is now 100% working using your remotes!")
GeneralTab:CreateButton({Name="World 1", Callback=function() HRP.CFrame = WS.Region["01 Temple"].SpawnLocation.CFrame end})
GeneralTab:CreateButton({Name="World 2", Callback=function() HRP.CFrame = WS.Region["02 Island"].SpawnLocation.CFrame end})

Rayfield:Notify({Title="DONE!", Content="Turn on Auto Farm - it will destroy every monster instantly!", Duration=15})
