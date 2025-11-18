-- RedWizard Hub - Champions: Summon Your Team
-- Using sirius.menu/rayfield (perfect for Delta Executor)

print("RedWizard Hub - Loading Rayfield from sirius.menu...")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "RedWizard Hub",
   LoadingTitle = "RedWizard Hub",
   LoadingSubtitle = "Champions: Summon Your Team",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RedWizardConfig"
   },
   Discord = {Enabled = false},
   KeySystem = false
})

Rayfield:Notify({
   Title = "RedWizard Hub",
   Content = "Loaded successfully! Enjoy the safe features.",
   Duration = 6.5,
   Image = 4483362458,
})

print("RedWizard Hub - GUI Loaded!")

-- Tabs
local PlayerTab = Window:CreateTab("Player", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)
local TeleTab = Window:CreateTab("Teleports", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- WalkSpeed Slider + Input
PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 300},
   Increment = 5,
   CurrentValue = 16,
   Callback = function(v)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
   end
})

PlayerTab:CreateInput({
   Name = "Set WalkSpeed (Text)",
   PlaceholderText = "Enter speed...",
   Callback = function(t)
      local n = tonumber(t)
      if n then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = n end
   end
})

-- Fly (Hold Space / Jump)
local Flying = false
PlayerTab:CreateToggle({
   Name = "Fly (Hold Space)",
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
               bv.Velocity = UserInputService:IsKeyDown(Enum.KeyCode.Space) and workspace.CurrentCamera.CFrame.LookVector * 130 or Vector3.new(0,0,0)
            end
            bv:Destroy()
            bg:Destroy()
            hum.PlatformStand = false
         end)
      end
   end
})

-- Player ESP (Name + Distance)
local ESP = false
VisualTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(state)
      ESP = state
      if not state then
         for _, p in pairs(game.Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("RedWizardESP") then
               p.Character.Head.RedWizardESP:Destroy()
            end
         end
         return
      end

      for _, p in pairs(game.Players:GetPlayers()) do
         if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local bill = Instance.new("BillboardGui", p.Character.Head)
            bill.Name = "RedWizardESP"
            bill.AlwaysOnTop = true
            bill.Size = UDim2.new(0,200,0,50)
            bill.StudsOffset = Vector3.new(0,3,0)
            local txt = Instance.new("TextLabel", bill)
            txt.BackgroundTransparency = 1
            txt.Size = UDim2.new(1,0,1,0)
            txt.Font = Enum.Font.GothamBold
            txt.TextColor3 = Color3.fromRGB(255,0,0)
            txt.TextStrokeTransparency = 0

            spawn(function()
               while ESP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and task.wait(0.1) do
                  local dist = (p.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                  txt.Text = p.Name.."\n["..math.floor(dist).."m]"
               end
            end)
         end
      end
   end
})

-- Teleport to Player Dropdown (auto refresh)
local tpDropdown
tpDropdown = TeleTab:CreateDropdown({
   Name = "Teleport to Player",
   Options = {"Loading players..."},
   CurrentOption = {"Loading players..."},
   Callback = function(playerName)
      local target = game.Players:FindFirstChild(playerName)
      if target and target.Character then
         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
      end
   end
})

spawn(function()
   while task.wait(4) do
      local list = {}
      for _, p in pairs(game.Players:GetPlayers()) do
         if p ~= game.Players.LocalPlayer then table.insert(list, p.Name) end
      end
      if #list > 0 then tpDropdown:Refresh(list) end
   end
end)

-- Misc
MiscTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId)
   end
})

print("RedWizard Hub - Fully loaded and ready!")
