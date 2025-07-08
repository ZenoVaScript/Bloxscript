local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "CheatSheet"

-- Create main frame with smooth animation
local Frame = Instance.new("Frame", ScreenGui)
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 300, 0, 350)
Frame.BackgroundTransparency = 0.2
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.ClipsDescendants = true

-- Add rounded corners
local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Add drop shadow
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(60, 60, 70)
UIStroke.Transparency = 0.5

-- Create drag functionality
local UIDragDetector = Instance.new("TextButton", Frame)
UIDragDetector.Name = "DragButton"
UIDragDetector.Text = ""
UIDragDetector.BackgroundTransparency = 1
UIDragDetector.Size = UDim2.new(1, 0, 0, 40)
UIDragDetector.AutoButtonColor = false

local dragStartPos
local frameStartPos

UIDragDetector.MouseButton1Down:Connect(function()
    dragStartPos = Vector2.new(game:GetService("UserInputService"):GetMouseLocation().X, game:GetService("UserInputService"):GetMouseLocation().Y)
    frameStartPos = Frame.Position
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragStartPos then
        local mousePos = Vector2.new(game:GetService("UserInputService"):GetMouseLocation().X, game:GetService("UserInputService"):GetMouseLocation().Y)
        local delta = mousePos - dragStartPos
        Frame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStartPos = nil
    end
end)

-- Create toggle button
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Name = "ToggleButton"
ToggleButton.Image = "rbxassetid://7072717362" -- Default Roblox icon
ToggleButton.ImageColor3 = Color3.fromRGB(200, 200, 200)
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0.25, 0, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToggleButton.AutoButtonColor = false

local ToggleCorner = Instance.new("UICorner", ToggleButton)
ToggleCorner.CornerRadius = UDim.new(0, 12)

local ToggleStroke = Instance.new("UIStroke", ToggleButton)
ToggleStroke.Thickness = 1
ToggleStroke.Color = Color3.fromRGB(80, 80, 90)

-- Button animation on hover
ToggleButton.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 60),
        ImageColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

ToggleButton.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        ImageColor3 = Color3.fromRGB(200, 200, 200)
    }):Play()
end)

-- Toggle functionality with animation
local Debounce = false
local isOpen = true

ToggleButton.MouseButton1Click:Connect(function()
    if not Debounce then
        Debounce = true
        
        if isOpen then
            -- Close animation
            game:GetService("TweenService"):Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 0, 0, 350),
                Position = UDim2.new(Frame.Position.X.Scale, Frame.Position.X.Offset + 150, Frame.Position.Y.Scale, Frame.Position.Y.Offset)
            }):Play()
            
            game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
                ImageColor3 = Color3.fromRGB(150, 150, 150)
            }):Play()
        else
            -- Open animation
            Frame.Visible = true
            game:GetService("TweenService"):Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 300, 0, 350),
                Position = UDim2.new(Frame.Position.X.Scale, Frame.Position.X.Offset - 150, Frame.Position.Y.Scale, Frame.Position.Y.Offset)
            }):Play()
            
            game:GetService("TweenService"):Create(ToggleButton, TweenInfo.new(0.2), {
                ImageColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end
        
        isOpen = not isOpen
        wait(0.3)
        Debounce = false
    end
end)

-- Header
local Header = Instance.new("Frame", Frame)
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1
Header.ZIndex = 2

local Title = Instance.new("TextLabel", Header)
Title.Name = "Title"
Title.Text = "THE HATCH"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Center

-- Content area
local Content = Instance.new("ScrollingFrame", Frame)
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.Size = UDim2.new(1, -10, 1, -50)
Content.Position = UDim2.new(0, 5, 0, 45)
Content.ScrollBarThickness = 6
Content.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Content.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

local ContentLayout = Instance.new("UIListLayout", Content)
ContentLayout.Padding = UDim.new(0, 5)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Egg teleport button
local EggButton = Instance.new("Frame", Content)
EggButton.Name = "EggButton"
EggButton.Size = UDim2.new(1, 0, 0, 40)
EggButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
EggButton.BackgroundTransparency = 0.3

local EggCorner = Instance.new("UICorner", EggButton)
EggCorner.CornerRadius = UDim.new(0, 6)

local EggStroke = Instance.new("UIStroke", EggButton)
EggStroke.Thickness = 1
EggStroke.Color = Color3.fromRGB(60, 60, 70)

local EggLabel = Instance.new("TextLabel", EggButton)
EggLabel.Name = "Label"
EggLabel.Text = "TELEPORT TO EGG"
EggLabel.Font = Enum.Font.Gotham
EggLabel.TextSize = 14
EggLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
EggLabel.Size = UDim2.new(0.7, 0, 1, 0)
EggLabel.Position = UDim2.new(0.05, 0, 0, 0)
EggLabel.BackgroundTransparency = 1
EggLabel.TextXAlignment = Enum.TextXAlignment.Left

local EggIcon = Instance.new("ImageLabel", EggButton)
EggIcon.Name = "Icon"
EggIcon.Image = "rbxassetid://7072717362" -- Default Roblox icon
EggIcon.Size = UDim2.new(0, 25, 0, 25)
EggIcon.Position = UDim2.new(0.8, 0, 0.5, 0)
EggIcon.AnchorPoint = Vector2.new(0, 0.5)
EggIcon.BackgroundTransparency = 1
EggIcon.ImageColor3 = Color3.fromRGB(150, 200, 255)

local EggButtonClick = Instance.new("TextButton", EggButton)
EggButtonClick.Name = "ClickDetector"
EggButtonClick.Text = ""
EggButtonClick.BackgroundTransparency = 1
EggButtonClick.Size = UDim2.new(1, 0, 1, 0)
EggButtonClick.ZIndex = 5

-- Button hover effect
EggButtonClick.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(EggButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.2,
        BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    }):Play()
    
    game:GetService("TweenService"):Create(EggIcon, TweenInfo.new(0.2), {
        ImageColor3 = Color3.fromRGB(200, 230, 255)
    }):Play()
end)

EggButtonClick.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(EggButton, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.3,
        BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    }):Play()
    
    game:GetService("TweenService"):Create(EggIcon, TweenInfo.new(0.2), {
        ImageColor3 = Color3.fromRGB(150, 200, 255)
    }):Play()
end)

-- Button click effect and functionality
local Debounce2 = false

EggButtonClick.MouseButton1Click:Connect(function()
    if not Debounce2 then
        Debounce2 = true
        
        -- Click animation
        game:GetService("TweenService"):Create(EggButton, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        }):Play()
        
        game:GetService("TweenService"):Create(EggIcon, TweenInfo.new(0.1), {
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0, 22, 0, 22)
        }):Play()
        
        wait(0.1)
        
        game:GetService("TweenService"):Create(EggButton, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        }):Play()
        
        game:GetService("TweenService"):Create(EggIcon, TweenInfo.new(0.1), {
            ImageColor3 = Color3.fromRGB(200, 230, 255),
            Size = UDim2.new(0, 25, 0, 25)
        }):Play()
        
        -- Teleport to eggs
        for _, egg in ipairs(workspace:GetDescendants()) do
            if egg:IsA("MeshPart") and (string.match(egg.Name, "Egg") or egg.Name == "EggSpawn") then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character:PivotTo(egg.CFrame)
                    break
                end
            end
        end
        
        wait(0.5)
        Debounce2 = false
    end
end)

-- Add more cheat buttons here following the same pattern as EggButton
-- Example:
-- local AnotherButton = Instance.new("Frame", Content)
-- ... similar setup as EggButton ...