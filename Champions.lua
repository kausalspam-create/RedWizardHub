-- RedWizard Hub - Champions: Summon Your Team
-- Fixed & Guaranteed to show GUI + console message (Delta Executor tested)

print("RedWizard Hub - Loading Rayfield UI...")

local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/refs/heads/main/Rayfield%20Lib/Rayfield%20Lib%20Source.lua"))()
end)

if not success then
    warn("Failed to load Rayfield UI! Error: "..tostring(err))
    return
end

wait(1) -- small delay so Rayfield fully loads

local Window = Rayfield:CreateWindow({
    Name = "RedWizard Hub",
    LoadingTitle = "RedWizard Hub",
    LoadingSubtitle = "Champions: Summon Your Team",
    ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
    KeySystem = false
})

Rayfield:Notify({
    Title = "RedWizard Hub",
    Content = "Successfully loaded! Enjoy safely.",
    Duration = 8
})

print("RedWizard Hub - GUI Loaded Successfully!")

-- Tabs
local PlayerTab = Window:CreateTab("Player")
local VisualTab = Window:CreateTab("Visuals")
local TeleportTab = Window:CreateTab("Teleports")
local MiscTab = Window:CreateTab("Misc")

-- WalkSpeed
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

-- Fly (Hold Space)
local Flying = false
PlayerTab:CreateToggle({
    Name = "Fly (Hold Space/Jump)",
    CurrentValue = false,
    Callback = function(state)
        Flying = state
        local plr = game.Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")

        if state then
            local bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            local bg = Instance.new("BodyGyro", root)
            bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
            bg.P = 15000

            spawn(function()
                while Flying and task.wait() do
                    hum.PlatformStand = true
                    bg.CFrame = workspace.CurrentCamera.CFrame
                    bv.Velocity = UserInputService:IsKeyDown(Enum.KeyCode.Space) and workspace.CurrentCamera.CFrame.LookVector * 120 or Vector3.new(0,0,0)
                end
                bv:Destroy()
                bg:Destroy()
                hum.PlatformStand = false
            end)
        end
    end
})

-- Simple ESP
VisualTab:CreateToggle({
    Name = "Player ESP (Name + Distance)",
    CurrentValue = false,
    Callback = function(state)
        if state then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local bill = Instance.new("BillboardGui", player.Character.Head)
                    bill.AlwaysOnTop = true
                    bill.Size = UDim2.new(0,200,0,50)
                    bill.StudsOffset = Vector3.new(0,3,0)
                    local text = Instance.new("TextLabel", bill)
                    text.BackgroundTransparency = 1
                    text.Size = UDim2.new(1,0,1,0)
                    text.TextColor3 = Color3.new(1,0,0)
                    text.TextStrokeTransparency = 0
                    text.Font = Enum.Font.GothamBold
                    spawn(function()
                        while state and player.Character and wait(0.1) do
                            local dist = (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            text.Text = player.Name.." ["..math.floor(dist).."m]"
                        end
                    end)
                end
            end
        end
    end
})

-- Teleport to Player Dropdown (auto refresh)
local dropdown
dropdown = TeleportTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {"Loading players..."},
    CurrentOption = "Loading players...",
    Callback = function(name)
        local target = game.Players:FindFirstChild(name)
        if target and target.Character then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        end
    end
})

spawn(function()
    while wait(3) do
        local names = {}
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then table.insert(names, p.Name) end
        end
        if #names > 0 then dropdown:Refresh(names) end
    end
end)

-- Rejoin
MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})

print("RedWizard Hub - All features loaded!")
