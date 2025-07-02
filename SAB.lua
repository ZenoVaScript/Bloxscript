--[[
  ULTIMATE STEAL A BRAINROT HACK
  Features:
  - Custom Speed Boost (16-100+)
  - Anti-Cheat Bypass
  - Auto-Respawn Support
  - Clean GUI
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Settings
local DEFAULT_SPEED = 16
local MAX_SPEED = 150
local TARGET_SPEED = 50 -- Default speed when applied

-- Core Variables
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrainrotHack_"..tostring(math.random(1000,9999))
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 180)
MainFrame.Position = UDim2.new(0.8, -125, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "SPEED HACK"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Speed Input
local SpeedBox = Instance.new("TextBox")
SpeedBox.PlaceholderText = "Enter speed ("..DEFAULT_SPEED.."-"..MAX_SPEED..")"
SpeedBox.Text = tostring(TARGET_SPEED)
SpeedBox.Size = UDim2.new(0.8, 0, 0, 35)
SpeedBox.Position = UDim2.new(0.1, 0, 0.25, 0)
SpeedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SpeedBox.TextColor3 = Color3.new(1, 1, 1)
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = MainFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 6)
BoxCorner.Parent = SpeedBox

-- Apply Button
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Text = "APPLY SPEED"
ApplyBtn.Size = UDim2.new(0.8, 0, 0, 35)
ApplyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ApplyBtn.TextColor3 = Color3.new(1, 1, 1)
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ApplyBtn

-- Status Label
local Status = Instance.new("TextLabel")
Status.Text = "Current: "..DEFAULT_SPEED
Status.TextColor3 = Color3.fromRGB(200, 200, 200)
Status.Size = UDim2.new(0.8, 0, 0, 20)
Status.Position = UDim2.new(0.1, 0, 0.8, 0)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.Parent = MainFrame

-- Movement Hack (3-Layer Bypass)
local function ApplySpeedHack(speed)
    if not Character or not RootPart then return end
    
    -- Layer 1: BodyVelocity Approach
    local BV = Instance.new("BodyVelocity")
    BV.Name = "SpeedHack_BV"
    BV.MaxForce = Vector3.new(4000, 0, 4000)
    BV.Velocity = RootPart.CFrame.LookVector * speed
    BV.Parent = RootPart

    -- Layer 2: CFrame Manipulation (Backup)
    spawn(function()
        while BV and BV.Parent == RootPart do
            RootPart.CFrame = RootPart.CFrame + RootPart.CFrame.LookVector * (speed/30)
            RunService.Heartbeat:Wait()
        end
    end)

    -- Layer 3: Humanoid Override (Fallback)
    pcall(function()
        Humanoid.WalkSpeed = speed
    end)

    Status.Text = "Current: "..tostring(speed)
end

-- Input Validation
local function ValidateSpeed(input)
    local num = tonumber(input)
    if num and num >= DEFAULT_SPEED and num <= MAX_SPEED then
        return math.floor(num)
    end
    return DEFAULT_SPEED
end

-- Apply Button Logic
ApplyBtn.MouseButton1Click:Connect(function()
    local newSpeed = ValidateSpeed(SpeedBox.Text)
    TARGET_SPEED = newSpeed
    ApplySpeedHack(TARGET_SPEED)
    
    -- Visual feedback
    ApplyBtn.Text = "APPLIED!"
    task.delay(1, function()
        ApplyBtn.Text = "APPLY SPEED"
    end)
end)

-- Auto-Reapply on Respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    repeat task.wait() until newChar:FindFirstChild("HumanoidRootPart")
    RootPart = newChar:FindFirstChild("HumanoidRootPart")
    Humanoid = newChar:FindFirstChildOfClass("Humanoid")

    task.wait(0.5) -- Wait for stabilization
    ApplySpeedHack(TARGET_SPEED)
end)

-- Initialize
ApplySpeedHack(TARGET_SPEED)

-- Close GUI with Escape
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Escape then
        ScreenGui:Destroy()
    end
end)