-- Steal a Brainrot Hack (GUI + Flight + Speed + Anti-Cheat Bypass)
-- By [YourName] - Use at your own risk!

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Anti-Cheat Bypass (Simulate "legit" movement)
local function SafeFlight()
    local fakeVelocity = Instance.new("BodyVelocity")
    fakeVelocity.MaxForce = Vector3.new(0, 0, 0)
    fakeVelocity.Velocity = Vector3.new(0, 0, 0)
    fakeVelocity.Parent = RootPart
    return fakeVelocity
end

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

-- Flight & Speed Variables
local IsFlying = false
local FlightVelocity = SafeFlight()
local BoostStartTime = 0
local MaxFlightTime = 30 -- Seconds before auto-disable (avoids detection)

-- Boost Function (Flight + Speed)
local function ToggleBoost(active)
    if active then
        IsFlying = true
        BoostStartTime = tick()
        
        -- Speed Boost (x3 WalkSpeed)
        Humanoid.WalkSpeed = 50
        
        -- Flight Hack (Bypass Anti-Cheat)
        FlightVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        FlightVelocity.Velocity = Vector3.new(0, 0, 0)
        
        -- Simulate "natural" ascent (avoids instant flag)
        for i = 1, 20 do
            FlightVelocity.Velocity = Vector3.new(0, i, 0)
            wait(0.05)
        end
        
        StatusLabel.Text = "Status: FLYING"
    else
        -- Reset Everything
        IsFlying = false
        Humanoid.WalkSpeed = 16
        FlightVelocity.MaxForce = Vector3.new(0, 0, 0)
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

-- Anti-Cheat Protection
spawn(function()
    while wait(1) do
        if IsFlying and (tick() - BoostStartTime > MaxFlightTime) then
            ToggleBoost(false)
            StatusLabel.Text = "Status: Cooldown (Anti-Cheat)"
            wait(5)
        end
    end
end)

-- If anti-cheat teleports you back, this re-enables flight
Humanoid.StateChanged:Connect(function(_, newState)
    if newState == Enum.HumanoidStateType.Freefall and IsFlying then
        ToggleBoost(true)
    end
end)

StatusLabel.Text = "Status: Loaded!"