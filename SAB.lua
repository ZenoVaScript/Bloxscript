-- Steal a Brainrot Speed Boost GUI (Optimized)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedBoostGUI"
screenGui.Parent = PlayerGui

-- Create Open/Close Button
local toggleGuiButton = Instance.new("TextButton")
toggleGuiButton.Size = UDim2.new(0, 100, 0, 40)
toggleGuiButton.Position = UDim2.new(0, 10, 0, 10)
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
toggleGuiButton.TextColor3 = Color3.new(1, 1, 1)
toggleGuiButton.Text = "Speed Boost"
toggleGuiButton.Font = Enum.Font.GothamBold
toggleGuiButton.Parent = screenGui

-- Create Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0.5, -125, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.Visible = false
frame.Parent = screenGui

-- Add UI Corners
local function addCorner(instance)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = instance
end

addCorner(toggleGuiButton)
addCorner(frame)

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "SPEED BOOST"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- Speed Input
local speedTextBox = Instance.new("TextBox")
speedTextBox.Size = UDim2.new(0.8, 0, 0, 35)
speedTextBox.Position = UDim2.new(0.1, 0, 0.3, 0)
speedTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
speedTextBox.TextColor3 = Color3.new(1, 1, 1)
speedTextBox.PlaceholderText = "Enter speed (16-100)"
speedTextBox.Text = "50"
speedTextBox.ClearTextOnFocus = false
speedTextBox.Parent = frame
addCorner(speedTextBox)

-- Apply Button
local applyButton = Instance.new("TextButton")
applyButton.Size = UDim2.new(0.8, 0, 0, 35)
applyButton.Position = UDim2.new(0.1, 0, 0.6, 0)
applyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
applyButton.TextColor3 = Color3.new(1, 1, 1)
applyButton.Text = "APPLY SPEED"
applyButton.Font = Enum.Font.GothamBold
applyButton.Parent = frame
addCorner(applyButton)

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0, 20)
statusLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Current: 16"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.Parent = frame

-- Toggle GUI function
local function toggleGui()
    frame.Visible = not frame.Visible
    toggleGuiButton.Text = frame.Visible and "CLOSE" or "SPEED BOOST"
end

-- Apply speed function
local function applySpeed()
    local speed = tonumber(speedTextBox.Text)
    if speed and speed >= 16 and speed <= 100 then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speed
                statusLabel.Text = "Current: "..tostring(speed)
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                
                -- Reset status color after 2 seconds
                task.delay(2, function()
                    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                end)
                return
            end
        end
    end
    
    -- Invalid input
    speedTextBox.Text = "Invalid!"
    speedTextBox.TextColor3 = Color3.fromRGB(255, 50, 50)
    task.delay(1, function()
        speedTextBox.Text = "50"
        speedTextBox.TextColor3 = Color3.new(1, 1, 1)
    end)
end

-- Character handling
local function updateSpeedOnCharacter()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChildOfClass("Humanoid")
    
    -- Maintain speed when character respawns
    if speedTextBox.Text ~= "16" then
        humanoid.WalkSpeed = tonumber(speedTextBox.Text) or 16
    end
end

-- Connections
toggleGuiButton.MouseButton1Click:Connect(toggleGui)
applyButton.MouseButton1Click:Connect(applySpeed)
LocalPlayer.CharacterAdded:Connect(updateSpeedOnCharacter)

-- Close GUI when pressing escape
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Escape and frame.Visible then
        toggleGui()
    end
end)

-- Initialize
if LocalPlayer.Character then
    updateSpeedOnCharacter()
end