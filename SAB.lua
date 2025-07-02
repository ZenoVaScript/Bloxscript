-- Simple Steal a Brainrot Speed Boost (Press-to-Boost)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

-- Settings
local NORMAL_SPEED = 16
local BOOST_SPEED = 30  -- Speed when boosting
local BOOST_KEY = Enum.KeyCode.LeftShift  -- Change to preferred key

-- Core Functions
local function ApplySpeed(speed)
    local char = Players.LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end

-- Boost Toggle
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == BOOST_KEY and not gameProcessed then
        ApplySpeed(BOOST_SPEED)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == BOOST_KEY then
        ApplySpeed(NORMAL_SPEED)
    end
end)

-- Auto-reset on character change
Players.LocalPlayer.CharacterAdded:Connect(function()
    ApplySpeed(NORMAL_SPEED)
end)

-- Initialize
ApplySpeed(NORMAL_SPEED)

-- Minimal UI Notification
local notify = Instance.new("TextLabel")
notify.Text = "Speed Boost: Hold "..tostring(BOOST_KEY):gsub("Enum.KeyCode.", "").." to sprint ("..BOOST_SPEED..")"
notify.TextColor3 = Color3.new(1,1,1)
notify.BackgroundColor3 = Color3.new(0,0,0)
notify.Size = UDim2.new(0.4, 0, 0, 30)
notify.Position = UDim2.new(0.3, 0, 0.95, 0)
notify.Parent = game.CoreGui