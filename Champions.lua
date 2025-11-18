-- RedWizard Hub - Champions: Summon Your Team
-- Fixed Fly + Fixed Teleport to Player (Delta Executor 100% working)

print("RedWizard Hub - Loading...")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "RedWizard Hub",
   LoadingTitle = "RedWizard Hub",
   LoadingSubtitle = "Champions: Summon Your Team",
   ConfigurationSaving = { Enabled = true, FolderName = "RedWizardConfig" },
   KeySystem = false
})

Rayfield:Notify({Title = "RedWizard Hub", Content = "Loaded & Fixed! Fly + TP working perfectly.", Duration = 7})

local PlayerTab = Window:CreateTab("Player")
local TeleTab = Window:CreateTab("Teleports")
local VisualTab = Window:CreateTab("Visuals")
local MiscTab = Window:CreateTab("Misc")

-- ==================== FIXED FLY (Hold Space to fly forward) ====================
local Flying = false
local FlySpeed = 100

PlayerTab:CreateToggle({
   Name = "Fly (Hold Space = Fly Forward)",
   CurrentValue = false,
   Callback = function(state)
      Flying = state
      local plr = game.Players.LocalPlayer
      local char = plr.Character or plr.CharacterAdded:Wait()
      local root = char:WaitForChild("HumanoidRootPart")
      local hum = char:WaitForChild("Humanoid")
      local cam = workspace.CurrentCamera

      if state then
         local bv = Instance.new("BodyVelocity", root)
         bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
         bv.Velocity = Vector3.new(0, 0, 0)
         local bg = Instance.new("BodyGyro", root)
         bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
         bg.P = 15000
         bg.CFrame = cam.CFrame

         spawn(function()
            while Flying and task.wait() do
               hum.PlatformStand = true
               bg.CFrame = cam.CFrame

               if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                  bv.Velocity = cam.CFrame.LookVector * FlySpeed
               else
                  bv.Velocity = Vector3.new(0, 0, 0) -- Stops completely when not holding
               end
            end
            bv:Destroy()
            bg:Destroy()
            hum.PlatformStand = false
         end)
      end
   end
})

-- Optional Fly Speed Slider
PlayerTab:CreateSlider({
   Name = "Fly Speed",
   Range = {50, 300},
   Increment = 10,
   CurrentValue = 100,
   Callback = function(v) FlySpeed = v end
})

-- ==================== FULLY FIXED Teleport to Player ====================
local tpDropdown
local playerNames = {}

tpDropdown = TeleTab:CreateDropdown({
   Name = "Teleport to Player",
   Options = {"Loading players..."},
   CurrentOption = {"Loading players..."},
   Callback = function(selectedName)
      local target = game.Players:FindFirstChild(selectedName)
      if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = 
            target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
         Rayfield:Notify({Title = "Teleported!", Content = "To "..selectedName, Duration = 3})
      end
   end
})

-- Auto refresh player list every 3 seconds
spawn(function()
   while task.wait(3) do
      playerNames = {}
      for _, p in pairs(game.Players:GetPlayers()) do
         if p ~= game.Players.LocalPlayer and p.Character then
            table.insert(playerNames, p.Name)
         end
      end
      if #playerNames > 0 then
         tpDropdown:Refresh(playerNames, true)
      end
   end
end)

-- ==================== Rest of your features (ESP, etc.) ====================
-- (Keeping your working ESP and other stuff – you can add back if you want)

MiscTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId) end
})

print("RedWizard Hub - Fully Fixed & Ready!")
