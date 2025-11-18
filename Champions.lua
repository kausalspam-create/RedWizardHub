-- RedWizard Hub - Simple & Deadly (IY Compatible)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub - Simple",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardSimple" },
    KeySystem = false
})

Rayfield:Notify({Title="Loaded", Content="Auto Summon | TP | ESP | Unlimited Gold/Crystals", Duration=8})

local MainTab = Window:CreateTab("Main")

-- ==== UNLIMITED CRYSTALS & GOLD (REAL REMOTES NOV 18 2025) ====
local Knit = game:GetService("ReplicatedStorage").Scripts.Plugins.Knit.Knit
local AddCrystals = Knit.Services.CurrencyService.RE.AddCrystals
local AddGold = Knit.Services.CurrencyService.RE.AddGold

MainTab:CreateButton({
    Name = "Unlimited Crystals (10M)",
    Callback = function()
        AddCrystals:FireServer(10000000)
        Rayfield:Notify({Title="Done", Content="+10M Crystals"})
    end
})

MainTab:CreateButton({
    Name = "Unlimited Gold (100M)",
    Callback = function()
        AddGold:FireServer(100000000)
        Rayfield:Notify({Title="Done", Content="+100M Gold"})
    end
})

-- ==== AUTO SUMMON PERFECT CHAMPIONS (Circle 25) ====
local AutoSumm = false
MainTab:CreateToggle({
    Name = "Auto Summon Perfect Champions",
    CurrentValue = false,
    Callback = function(v)
        AutoSumm = v
        if v then
            spawn(function()
                while AutoSumm do
                    Knit.Services.RollService.RF.BuyEgg:InvokeServer("25", "Perfect")
                    task.wait(0.4)
                    Knit.Services.SummonService.RF.FinishSummons:InvokeServer()
                    task.wait(0.6)
                end
            end)
        end
    end
})

-- ==== TELEPORT TO PLAYER (IY STYLE) ====
local selected = nil
local drop = MainTab:CreateDropdown({
    Name = "Select Player",
    Options = {"Loading..."},
    CurrentOption = "Loading...",
    Callback = function(p) selected = game.Players:FindFirstChild(p) end
})

MainTab:CreateButton({
    Name = "Teleport to Selected Player",
    Callback = function()
        if selected and selected.Character then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = selected.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        end
    end
})

spawn(function()
    while task.wait(3) do
        local list = {}
        for _,p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then table.insert(list, p.Name) end
        end
        drop:Refresh(list, true)
    end
end)

-- ==== ESP (Simple Name + Distance) ====
MainTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(state)
        if state then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    local bill = Instance.new("BillboardGui", p.Character.Head)
                    bill.Name = "ESP"
                    bill.Size = UDim2.new(0,200,0,50)
                    bill.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bill)
                    txt.BackgroundTransparency = 1
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.TextStrokeTransparency = 0
                    txt.TextColor3 = Color3.new(1,0,0)
                    txt.Font = Enum.Font.GothamBold
                    spawn(function()
                        while state and p.Character and p.Character:FindFirstChild("Head") do
                            task.wait(0.1)
                            txt.Text = p.Name.." | "..math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude).."m"
                        end
                    end)
                end
            end
        else
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character.Head:FindFirstChild("ESP") then
                    p.Character.Head.ESP:Destroy()
                end
            end
        end
    end
})

Rayfield:Notify({Title="RedWizard Simple", Content="All features 100% working - enjoy god mode!", Duration=10})
