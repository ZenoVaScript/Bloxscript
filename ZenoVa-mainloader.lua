-- Universal Fake Ban Script (Error Code: 267)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- Create the fake ban GUI
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalFakeBan"
gui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.35, 0, 0.3, 0)
mainFrame.Position = UDim2.new(0.325, 0, 0.35, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local header = Instance.new("TextLabel")
header.Text = "Universal Script"
header.TextColor3 = Color3.fromRGB(255, 85, 0)  -- Orange color
header.TextSize = 18
header.Size = UDim2.new(1, 0, 0.15, 0)
header.Font = Enum.Font.SourceSansBold
header.BackgroundTransparency = 1
header.Parent = mainFrame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, 0, 0.005, 0)
divider.Position = UDim2.new(0, 0, 0.15, 0)
divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
divider.BorderSizePixel = 0
divider.Parent = mainFrame

local banMessage = Instance.new("TextLabel")
banMessage.Text = "were kicked from this game: Exploiting\nunable offense. This action log has be\nsubmitted to ROBLOX.\n(Error Code: 267)"
banMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
banMessage.TextSize = 16
banMessage.Size = UDim2.new(0.9, 0, 0.6, 0)
banMessage.Position = UDim2.new(0.05, 0, 0.2, 0)
banMessage.TextWrapped = true
banMessage.Font = Enum.Font.SourceSans
banMessage.TextXAlignment = Enum.TextXAlignment.Left
banMessage.BackgroundTransparency = 1
banMessage.Parent = mainFrame

local leaveButton = Instance.new("TextButton")
leaveButton.Text = "Leave"
leaveButton.Size = UDim2.new(0.3, 0, 0.15, 0)
leaveButton.Position = UDim2.new(0.35, 0, 0.8, 0)
leaveButton.BackgroundColor3 = Color3.fromRGB(255, 85, 0)  -- Orange color
leaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
leaveButton.Font = Enum.Font.SourceSansBold
leaveButton.TextSize = 16
leaveButton.Parent = mainFrame

-- Add footer text
local footer = Instance.new("TextLabel")
footer.Text = "[Free]"
footer.TextColor3 = Color3.fromRGB(150, 150, 150)
footer.TextSize = 12
footer.Size = UDim2.new(1, 0, 0.1, 0)
footer.Position = UDim2.new(0, 0, 0.9, 0)
footer.Font = Enum.Font.SourceSans
footer.BackgroundTransparency = 1
footer.Parent = mainFrame

-- Button functionality
leaveButton.MouseButton1Click:Connect(function()
    player:Kick("You were kicked from this game: Exploiting (Error Code: 267)")
end)

-- Optional: Add a small delay before showing the GUI for more realism
task.wait(1)