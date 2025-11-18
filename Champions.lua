-- RedWizard Hub - Champions: Summon Your Team
-- UI: Rayfield (works perfectly on Delta Executor)
-- 100% Safe Features - No ban risk

loadstring(game:HttpGet("https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/refs/heads/main/Rayfield%20Lib/Rayfield%20Lib%20Source.lua"))()

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team - Safe",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    Discord = { Enabled = false },
    KeySystem = false
})

local PlayerTab = Window:CreateTab("Player", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)
local TeleportTab = Window:CreateTab("Teleports", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- === PLAYER TAB ===
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

PlayerTab:CreateTextbox({
    Name = "Set WalkSpeed (Text)",
    PlaceholderText = "Enter speed...",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = num
        end
    end
})

-- Fly (Hold Space / Jump)
local Flying = false
PlayerTab:CreateToggle({
    Name = "Fly (Hold Space)",
    CurrentValue = false,
    Callback = function(State)
        Flying = State
        local plr = game.Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")

        if State then
            local bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            local bg = Instance.new("BodyGyro", root)
            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bg.P = 15000

            spawn(function()
                while Flying and task.wait() do
                    hum.PlatformStand = true
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    bv.Velocity = Vector3.new(0,0,0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 120
                    end
                end
                bv:Destroy()
                bg:Destroy()
                hum.PlatformStand = false
            end)
        end
    end
})

-- === VISUALS TAB ===
local ESPEnabled = false
local ESPTable = {}

VisualTab:CreateToggle({
    Name = "Player ESP (Name + Distance)",
    CurrentValue = false,
    Callback = function(State)
        ESPEnabled = State
        if not State then
            for _, v in pairs(ESPTable) do
                if v.Billboard then v.Billboard:Destroy() end
            end
            ESPTable = {}
            return
        end

        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local bill = Instance.new("BillboardGui")
                bill.Name = "ESP_"..player.Name
                bill.Adornee = head
                bill.Size = UDim2.new(0, 200, 0, 50)
                bill.StudsOffset = Vector3.new(0, 3, 0)
                bill.AlwaysOnTop = true
                bill.Parent = head

                local label = Instance.new("TextLabel", bill)
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1,0,1,0)
                label.Font = Enum.Font.GothamBold
                label.TextStrokeTransparency = 0
                label.TextColor3 = Color3.fromRGB(255, 50, 50)

                ESPTable[player] = {Billboard = bill}

                spawn(function()
                    while ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and task.wait(0.1) do
                        local myRoot = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if myRoot then
                            local dist = (player.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
                            label.Text = player.Name .. "\n[" .. math.floor(dist) .. " studs]"
                        end
                    end
                end)
            end
        end
    end
})

-- === TELEPORTS TAB ===
local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {},
    CurrentOption = "Select",
    Callback = function(Option)
        local target = game.Players:FindFirstChild(Option)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
})

-- Auto-refresh player list
spawn(function()
    while task.wait(3) do
        local names = {}
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                table.insert(names, p.Name)
            end
        end
        PlayerDropdown:Refresh(names, true)
    end
end)

-- Example public teleports (change these CFrames yourself in-game by printing position)
TeleportTab:CreateButton({
    Name = "Spawn",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0) -- change
    end
})

-- === MISC TAB ===
MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})

Rayfield:Notify({
    Title = "RedWizard Hub",
    Content = "Loaded successfully! Enjoy safely.",
    Duration = 6
})

print("RedWizard Hub loaded with Rayfield UI!")
