-- Load Rayfield GUI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()
local Window = Rayfield:CreateWindow({
    Name = "Dead Rails Script || by specc",
    LoadingTitle = "Dead Rails Script",
    LoadingSubtitle = "by specc",
    ConfigurationSaving = { Enabled = false }
})

-- Tabs
local MainTab = Window:CreateTab("Main")
local ESPTab = Window:CreateTab("ESP")
local ServerTab = Window:CreateTab("Server")
local MiscTab = Window:CreateTab("Misc")

-- Aura Kill (Instant Kill, Only NPCs, Adjustable Radius)
local auraEnabled = false
local auraRadius = 10

MainTab:CreateSlider({
    Name = "Aura Kill Radius",
    Min = 5,
    Max = 50,
    Default = 10,
    Callback = function(Value) auraRadius = Value end
})

MainTab:CreateToggle({
    Name = "Aura Kill",
    Callback = function(state)
        auraEnabled = state
        while auraEnabled do
            task.wait(0.5)
            for _, enemy in ipairs(workspace:GetDescendants()) do
                if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                    local isPlayer = game.Players:GetPlayerFromCharacter(enemy)
                    if not isPlayer then
                        local distance = (enemy.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance <= auraRadius then
                            enemy.Humanoid.Health = 0
                        end
                    end
                end
            end
        end
    end
})

-- Aimbot (Targets NPCs in FOV Circle)
local aimbotEnabled = false
local aimTarget = "Head"
local fovSize = 100

-- Create FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = true
fovCircle.Radius = fovSize
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.Color = Color3.fromRGB(255, 0, 0)

game:GetService("RunService").RenderStepped:Connect(function()
    fovCircle.Position = game.Players.LocalPlayer:GetMouse().ViewportPoint
    fovCircle.Radius = fovSize
end)

MainTab:CreateSlider({
    Name = "Aimbot FOV Size",
    Min = 50,
    Max = 300,
    Default = 100,
    Callback = function(Value) fovSize = Value end
})

MainTab:CreateDropdown({
    Name = "Aimbot Target",
    Options = {"Head", "Torso"},
    Callback = function(value) aimTarget = value end
})

MainTab:CreateToggle({
    Name = "Aimbot",
    Callback = function(state)
        aimbotEnabled = state
        while aimbotEnabled do
            task.wait()
            local closestEnemy, closestDist = nil, math.huge
            for _, enemy in ipairs(workspace:GetDescendants()) do
                if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                    if enemy.Humanoid.Health > 0 and not game.Players:GetPlayerFromCharacter(enemy) then
                        local enemyPos = enemy[aimTarget].Position
                        local screenPos, onScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(enemyPos)
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)).Magnitude
                        if onScreen and distance < fovSize and distance < closestDist then
                            closestEnemy = enemy
                            closestDist = distance
                        end
                    end
                end
            end
            if closestEnemy then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, closestEnemy[aimTarget].Position)
            end
        end
    end
})

-- Noclip (Walk Through Walls)
local noclipEnabled = false

MainTab:CreateToggle({
    Name = "Noclip",
    Callback = function(state)
        noclipEnabled = state
        while noclipEnabled do
            task.wait()
            for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
})

-- ESP (Enable, Player ESP, Mob ESP, Item ESP)
local ESPEnabled = false
local PlayerESP = false
local MobESP = false
local ItemESP = false

ESPTab:CreateToggle({
    Name = "ESP Enable",
    Callback = function(state) ESPEnabled = state end
})

ESPTab:CreateToggle({
    Name = "Player ESP",
    Callback = function(state) PlayerESP = state end
})

ESPTab:CreateToggle({
    Name = "Mob ESP",
    Callback = function(state) MobESP = state end
})

ESPTab:CreateToggle({
    Name = "Item ESP",
    Callback = function(state) ItemESP = state end
})

-- Server Hop & Rejoin
ServerTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})

ServerTab:CreateButton({
    Name = "Rejoin Last Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
})

-- Misc: Reduce Lag, Boost FPS, Bring Items
MiscTab:CreateButton({
    Name = "Reduce Lag",
    Callback = function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            end
        end
    end
})

MiscTab:CreateButton({
    Name = "Boost FPS",
    Callback = function()
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").Brightness = 3
        setfpscap(30)
    end
})

MiscTab:CreateButton({
    Name = "Bring Items",
    Callback = function()
        for _, item in ipairs(workspace:GetDescendants()) do
            if item:IsA("Model") and item:FindFirstChild("Handle") then
                local distance = (item.Handle.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance <= 50 then
                    item.Handle.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                end
            end
        end
    end
})
