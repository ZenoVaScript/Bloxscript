-- Steal a Brainrot Speed Boost (Fixed Version)
-- By [YourName] - Guaranteed Working WalkSpeed Mod

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0.7, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Parent = ScreenGui

local BoostButton = Instance.new("TextButton")
BoostButton.Size = UDim2.new(0.8, 0, 0.5, 0)
BoostButton.Position = UDim2.new(0.1, 0, 0.2, 0)
BoostButton.Text = "BOOST (Hold)"
BoostButton.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
BoostButton.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.8, 0, 0.3, 0)
StatusLabel.Position = UDim2.new(0.1, 0, 0.7, 0)
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Parent = Frame

-- Speed Settings
local DefaultSpeed = 16
local BoostSpeed = 50  -- Adjust this value as needed
local IsBoosting = false

-- Function to ensure WalkSpeed stays modified
local function MaintainSpeed()
    while IsBoosting do
        if Humanoid and Humanoid.WalkSpeed ~= BoostSpeed then
            Humanoid.WalkSpeed = BoostSpeed
        end
        wait(0.1)
    end
end

-- Boost Toggle
local function ToggleBoost(active)
    IsBoosting = active
    if active then
        Humanoid.WalkSpeed = BoostSpeed
        StatusLabel.Text = "Status: BOOSTING"
        spawn(MaintainSpeed)  -- Start maintenance loop
    else
        Humanoid.WalkSpeed = DefaultSpeed
        StatusLabel.Text = "Status: Ready"
    end
end

-- Button Connections
BoostButton.MouseButton1Down:Connect(function()
    ToggleBoost(true)
end)

BoostButton.MouseButton1Up:Connect(function()
    ToggleBoost(false)
end)

-- Handle character changes/respawns
local function SetupCharacter(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    Humanoid.WalkSpeed = DefaultSpeed
    StatusLabel.Text = "Status: Ready"
    
    -- Reapply boost if active during respawn
    if IsBoosting then
        wait(0.5)  -- Small delay to ensure humanoid is ready
        Humanoid.WalkSpeed = BoostSpeed
        spawn(MaintainSpeed)
    end
end

LocalPlayer.CharacterAdded:Connect(SetupCharacter)

-- Initial setup
if Character then
    SetupCharacter(Character)
end

StatusLabel.Text = "Status: Loaded!"