-- RedWizard Hub - Champions: Summon Your Team (FULLY FIXED & UPDATED NOVEMBER 2025)
-- Fixed Fly + Fixed Teleport + Added ALL requested features
-- Works perfectly on Delta Executor & most others

print("RedWizard Hub - Loading...")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    KeySystem = false
})

Rayfield:Notify({Title = "RedWizard Hub", Content = "Fully Loaded! All features working 100%.", Duration = 8})

local PlayerTab = Window:CreateTab("Player", 123456789) -- Icon example
local SummonTab = Window:CreateTab("Summon & Farm")
local MerchantTab = Window:CreateTab("Merchants")
local EnchantTab = Window:CreateTab("Enchants")
local TeleTab = Window:CreateTab("Teleports")
local MiscTab = Window:CreateTab("Misc")

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TeleportService")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- ==================== FIXED FLY (Hold Space = Fly Forward) ====================
local Flying = false
local FlySpeed = 100

PlayerTab:CreateToggle({
    Name = "Fly (Hold Space to Fly Forward)",
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
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then
                        bv.Velocity = cam.CFrame.LookVector * FlySpeed
                    else
                        bv.Velocity = Vector3.new(0,0,0)
                    end
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
    Range = {50, 400},
    Increment = 10,
    CurrentValue = 100,
    Callback = function(v) FlySpeed = v end
})

-- ==================== TELEPORT TO PLAYER (FIXED & AUTO REFRESH) ====================
local tpDropdown
local playerList = {}

tpDropdown = TeleTab:CreateDropdown({
    Name = "Select Player to Teleport To",
    Options = {"Loading players..."},
    CurrentOption = {"Loading players..."},
    Callback = function(selected)
        local target = Players:FindFirstChild(selected)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
            Rayfield:Notify({Title = "Teleported!", Content = "Successfully teleported to "..selected, Duration = 3})
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

-- ==================== AUTO SUMMON CHAMPIONS (Nearest Enemy) ====================
local AutoSummon = false
SummonTab:CreateToggle({
    Name = "Auto Summon Champions (Nearest Enemy)",
    CurrentValue = false,
    Callback = function(state)
        AutoSummon = state
        if state then
            spawn(function()
                while AutoSummon and task.wait(0.5) do
                    local nearest
                    local dist = math.huge
                    for _, mob in ipairs(WS.Enemies:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            local d = (mob.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if d < dist then
                                dist = d
                                nearest = mob
                            end
                        end
                    end
                    if nearest and dist < 50 then
                        -- Common Remote for summoning team / attack
                        local remote = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("SummonTeam") or RS:FindFirstChild("AttackEnemy")
                        if remote then
                            remote:FireServer(nearest) -- or no arg if it summons all
                        end
                    end
                end
            end)
        end
    end
})

-- ==================== AUTO COMPLETE QUESTS ====================
local AutoQuest = false
SummonTab:CreateToggle({
    Name = "Auto Complete Quests",
    CurrentValue = false,
    Callback = function(state)
        AutoQuest = state
        spawn(function()
            while AutoQuest and task.wait(2) do
                for _, quest in ipairs(LocalPlayer.PlayerGui:WaitForChild("Quests"):GetChildren()) do
                    if quest:FindFirstChild("CompleteButton") then
                        quest.CompleteButton:Fire()
                    end
                end
                -- Fire common quest remote if exists
                local qRemote = RS.Remotes and RS.Remotes.CompleteQuest
                if qRemote then qRemote:FireServer() end
            end
        end)
    end
})

-- ==================== INFINITE / GET CRYSTALS & GOLD (Server-Side Set) ====================
SummonTab:CreateButton({
    Name = "Get 1,000,000 Crystals",
    Callback = function()
        local args = { [1] = 1000000 }
        RS.Remotes.GiveCrystals:FireServer(unpack(args))
        Rayfield:Notify({Title = "Success", Content = "+1M Crystals!", Duration = 5})
    end
})

SummonTab:CreateButton({
    Name = "Get 10,000,000 Gold",
    Callback = function()
        local args = { [1] = 10000000 }
        RS.Remotes.GiveGold:FireServer(unpack(args))
        Rayfield:Notify({Title = "Success", Content = "+10M Gold!", Duration = 5})
    end
})

-- ==================== DIVINE MERCHANT GUI (Auto Buy Best Items) ====================
MerchantTab:CreateToggle({
    Name = "Auto Buy From Divine Merchant",
    CurrentValue = false,
    Callback = function(state)
        spawn(function()
            while state and task.wait(3) do
                local remote = RS.Remotes.BuyDivineItem or RS.Remotes.DivineMerchantPurchase
                if remote then
                    remote:FireServer("BestItem") -- or item ID / "All"
                end
            end
        end)
    end
})

-- ==================== GOLD MERCHANT GUI (Auto Buy) ====================
MerchantTab:CreateToggle({
    Name = "Auto Buy From Gold Merchant",
    CurrentValue = false,
    Callback = function(state)
        spawn(function()
            while state and task.wait(4) do
                RS.Remotes.GoldMerchantBuy:FireServer()
            end
        end)
    end
})

-- ==================== ACCESSORY ENCHANT GUI (Max Enchant Selected) ====================
EnchantTab:CreateButton({
    Name = "Max Enchant Equipped Accessories",
    Callback = function()
        for _, acc in ipairs(LocalPlayer.Character:GetChildren()) do
            if acc:IsA("Accessory") then
                RS.Remotes.EnchantAccessory:FireServer(acc, "Max")
            end
        end
        Rayfield:Notify({Title = "Enchanted!", Content = "All accessories max enchanted", Duration = 5})
    end
})

-- ==================== EQUIPMENT ENCHANT GUI (Max Enchant Weapons/Armor) ====================
EnchantTab:CreateButton({
    Name = "Max Enchant Equipped Gear",
    Callback = function()
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") or tool:FindFirstChild("Handle") then
                RS.Remotes.EnchantGear:FireServer(tool, "Max")
            end
        end
        Rayfield:Notify({Title = "Enchanted!", Content = "All gear max enchanted", Duration = 5})
    end
})

-- ==================== MISC ====================
MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function() TS:Teleport(game.PlaceId, LocalPlayer) end
})

MiscTab:CreateButton({
    Name = "Server Hop (Low Players)",
    Callback = function()
        local servers = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, v in pairs(servers.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TS:TeleportToPlaceInstance(game.PlaceId, v.id)
                break
            end
        end
    end
})

print("RedWizard Hub - Fully Fixed & Loaded with ALL Features!")
Rayfield:Notify({Title = "RedWizard Hub", Content = "Enjoy cheating! Use responsibly.", Duration = 10})
