-- Load Rayfield GUI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

-- Create GUI Window
local Window = Rayfield:CreateWindow({
   Name = "Aura Kill",
   LoadingTitle = "Aura Kill Script",
   LoadingSubtitle = "By specc",
   ConfigurationSaving = {
      Enabled = false,
   }
})

-- Create Main Tab
local MainTab = Window:CreateTab("Main", 4483362458) -- Example icon ID

-- Aura Kill Variables
local AuraKillEnabled = false
local KillRadius = 10 -- Default radius

-- Function to check if an entity is an NPC
local function isNPC(entity)
   return entity:FindFirstChild("Humanoid") and not entity:FindFirstChildOfClass("Player")
end

-- Aura Kill Loop
local function AuraKill()
   while AuraKillEnabled do
      task.wait(0.2) -- Small delay to prevent lag
      local player = game.Players.LocalPlayer
      local character = player.Character
      if character and character:FindFirstChild("HumanoidRootPart") then
         local root = character.HumanoidRootPart
         for _, v in pairs(workspace:GetChildren()) do
            if isNPC(v) and v:FindFirstChild("HumanoidRootPart") then
               local distance = (root.Position - v.HumanoidRootPart.Position).Magnitude
               if distance <= KillRadius then
                  v.Humanoid.Health = 0 -- Instantly kill NPC
               end
            end
         end
      end
   end
end

-- Aura Kill Toggle Button
MainTab:CreateToggle({
   Name = "Enable Aura Kill",
   CurrentValue = false,
   Callback = function(value)
      AuraKillEnabled = value
      if AuraKillEnabled then
         AuraKill()
      end
   end
})

-- Radius Slider
MainTab:CreateSlider({
   Name = "Kill Radius",
   Min = 5,
   Max = 50,
   Increment = 1,
   CurrentValue = KillRadius,
   Callback = function(value)
      KillRadius = value
   end
})
