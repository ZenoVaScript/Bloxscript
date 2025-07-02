-- Steal a Brainrot Speed Boost (GUI + WalkSpeed Only)
-- By [YourName] - Simple & Effective

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

-- Speed Variables
local DefaultSpeed = 16
local BoostSpeed = 50  -- Adjust this value (50 = 3x faster)
local IsBoosting = false

-- Boost Function (WalkSpeed Only)
local function ToggleBoost(active)
    if active then
        IsBoosting = true
        Humanoid.WalkSpeed = BoostSpeed
        StatusLabel.Text = "Status: BOOSTING"
    else
        IsBoosting = false
        Humanoid.WalkSpeed = DefaultSpeed
        StatusLabel.Text = "Status: Disabled"
    end
end

-- Button Logic
BoostButton.MouseButton1Down:Connect(function()
    ToggleBoost(true)
end)

BoostButton.MouseButton1Up:Connect(function()
    ToggleBoost(false)
end)

-- Auto-Reset if character respawns
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    Humanoid.WalkSpeed = DefaultSpeed
    StatusLabel.Text = "Status: Ready"
end)

StatusLabel.Text = "Status: Loaded!"