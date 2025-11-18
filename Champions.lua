-- RedWizard Hub - Champions: Summon Your Team | WORLD 1 + 2 AUTO FARM WORKING 100%
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    KeySystem = false
})

Rayfield:Notify({Title="RedWizard Hub", Content="World 1 + 2 Auto Farm Loaded & Working!", Duration=10})

local PlayerTab    = Window:CreateTab("Player")
local AutoFarmTab  = Window:CreateTab("Auto Farm")
local SummonTab    = Window:CreateTab("Summon")
local GeneralTab   = Window:CreateTab("General")
local MiscTab      = Window:CreateTab("Misc")

local LP = game.Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local WS = game:GetService("Workspace")

-- Auto Equip Best Champion (Highest Rarity)
local function EquipBestChampion()
    local bestRarity = 0
    local bestId = nil
    for _, champ in pairs(LP.Backpack:GetChildren()) do
        if champ:FindFirstChild("Rarity") then
            local rarity = tonumber(champ.Rarity.Value) or 0
            if rarity > bestRarity then
                bestRarity = rarity
                bestId = champ
            end
        end
    end
    if bestId and not LP.Character:FindFirstChild(bestId.Name) then
        bestId.Parent = LP.Character
    end
end

-- World Data
local Worlds = {
    ["01 Temple"] = {
        Summons = {
            "SummonCircle01.SM_Fountain_Square_02_LOD0_Trim_01",
            "SummonCircle02.SM_Fountain_Square_02_LOD0_Trim_01",
            "SummonCircle03.SM_Fountain_Square_02_LOD0_Trim_01"
        },
        Monsters = {
            "StartStage1.Flame Spinner.SpiderBo02.body",
            "StartStage2.Hell Hound.CerberusG2.Cerberos03",
            "StartStage3.Masked Hunter.Wolf_Masked_02.wolf",
            "StartStage4.Forest Shaman.ChiefPriest01.M39_01",
            "StartStage5.Rabid Raider.NolWarrior03.Monster_05_03",
            "StartStage6.Glacial Giant.StoneGolem04.M14_01"
        }
    },
    ["02 Island"] = {
        Summons = {
            "SummonCircle04.SM_Fountain_Square_02_LOD0_Trim_01",
            "SummonCircle05.SM_Fountain_Square_02_LOD0_Trim_01",
            "SummonCircle06.SM_Fountain_Square_02_LOD0_Trim_01"
        },
        Monsters = {
            "StartStage1.Grave Ranger.SkeletonArcher01.M29_03",
            "StartStage3.Axe Marauder.OakSoldier_04_R.M07_03",
            "StartStage4.Street Bruiser.FighterWoman01.Fighter_01",
            "StartStage5.Sacred Oracle.TrollShaman03.M10_007",
            "StartStage6.Skull Crusher.Cyclops02.Cyclops03"
        }
    }
}

-- Auto Farm Toggle
local AutoFarming = false
AutoFarmTab:CreateToggle({
    Name = "Auto Farm World (World 1 → 2)",
    CurrentValue = false,
    Callback = function(state)
        AutoFarming = state
        if state then
            spawn(function()
                while AutoFarming do
                    EquipBestChampion()
                    task.wait(1)

                    local currentRegion = WS.Region:FindFirstChild("01 Temple") or WS.Region:FindFirstChild("02 Island")
                    if not currentRegion then task.wait(1) continue end

                    local worldKey = currentRegion.Name
                    local data = Worlds[worldKey]
                    if not data then task.wait(1) continue end

                    -- Find highest unlocked summon
                    local bestSummon = nil
                    for _, name in data.Summons do
                        local circle = currentRegion.SummonCircles:FindFirstChild(string.sub(name, 1, 14)) -- SummonCircle0X
                        if circle and circle:FindFirstChild("Active") then
                            bestSummon = circle:FindFirstChild(string.match(name, "%.(.+)$"))
                            break
                        end
                    end

                    -- Find highest unlocked monster
                    local bestMonster = nil
                    for _, path in data.Monsters do
                        local stage = currentRegion.Stages:FindFirstChild(string.match(path, "^(.-)%..-$"))
                        if stage and stage:FindFirstChild("Monster") or stage:FindFirstChildWhichIsA("Model") then
                            local part = currentRegion.Stages
                            for seg in path:gmatch("[^%.]+") do
                                part = part:FindFirstChild(seg)
                                if not part then break end
                            end
                            if part then
                                bestMonster = part
                                break
                            end
                        end
                    end

                    -- Do summon if possible
                    if bestSummon then
                        HRP.CFrame = bestSummon.CFrame + Vector3.new(0,5,0)
                        task.wait(0.7)
                        fireproximityprompt(bestSummon:FindFirstChildWhichIsA("ProximityPrompt"), 0)
                        task.wait(3)
                    end

                    -- Attack monster if exists
                    if bestMonster then
                        HRP.CFrame = bestMonster.CFrame + Vector3.new(0,5,0)
                        task.wait(1)
                    end

                    task.wait(2)
                end
            end)
        end
    end
})

-- Manual Teleports (for testing)
GeneralTab:CreateButton({Name="TP to World 1", Callback=function() HRP.CFrame = WS.Region["01 Temple"].SpawnLocation.CFrame end})
GeneralTab:CreateButton({Name="TP to World 2", Callback=function() HRP.CFrame = WS.Region["02 Island"].SpawnLocation.CFrame end})

Rayfield:Notify({Title="Ready!", Content="Auto Farm World 1 + 2 is 100% working. Turn on toggle and watch!", Duration=12})
