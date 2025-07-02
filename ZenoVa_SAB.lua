-- CREDITS SERVER V1 YOUTUBE - SERVER

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

-- LOCAL PLAYER & CHARACTER
local player = Players.LocalPlayer
local char, root, humanoid

-- GUI CREATION
local gui = Instance.new("ScreenGui")
gui.Name = "LuxuryBoxGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- MAIN CONTAINER
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 450)
mainFrame.Position = UDim2.new(0.05, 0, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

-- BOX STYLE ELEMENTS
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "ZENOVA SAB | V1"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- CONTROL BUTTONS
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
closeButton.Parent = topBar

local minimizeButton = Instance.new("TextButton")
minimizeButton.Text = "_"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 16
minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -70, 0.5, -15)
minimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minimizeButton.Parent = topBar

-- CONTENT AREA
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -10, 1, -50)
contentFrame.Position = UDim2.new(0, 5, 0, 45)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 4
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = contentFrame

-- BOX-STYLE CATEGORY FUNCTION
local function createBoxCategory(title)
    local category = Instance.new("Frame")
    category.Size = UDim2.new(1, 0, 0, 42)
    category.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    category.BorderSizePixel = 0
    category.Parent = contentFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 24)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = category
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = string.upper(title)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, 0, 0, 0)
    contentArea.Position = UDim2.new(0, 0, 0, 24)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = category
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentArea
    
    return contentArea
end

-- BOX-STYLE TOGGLE FUNCTION
local function createBoxToggle(parent, text, defaultState, callback)
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.BackgroundTransparency = 1
    toggle.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Text = text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 50, 0, 24)
    toggleFrame.Position = UDim2.new(1, -60, 0.5, -12)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = toggle
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Size = UDim2.new(0, 20, 0, 20)
    toggleButton.Position = UDim2.new(0, 3, 0.5, -10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    local state = defaultState or false
    
    local function updateToggle()
        if state then
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -23, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(100, 255, 150)
            }):Play()
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 80, 50)
            }):Play()
        else
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            }):Play()
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            }):Play()
        end
        callback(state)
    end
    
    toggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            updateToggle()
        end
    end)
    
    updateToggle()
    
    return {
        SetState = function(newState)
            state = newState
            updateToggle()
        end
    }
end

-- BOX-STYLE BUTTON FUNCTION
local function createBoxButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.Size = UDim2.new(1, -10, 0, 36)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Parent = parent
    
    local hoverFrame = Instance.new("Frame")
    hoverFrame.Size = UDim2.new(1, 0, 1, 0)
    hoverFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hoverFrame.BackgroundTransparency = 0.9
    hoverFrame.BorderSizePixel = 0
    hoverFrame.Visible = false
    hoverFrame.Parent = button
    
    button.MouseEnter:Connect(function()
        hoverFrame.Visible = true
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        hoverFrame.Visible = false
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        }):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        }):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        }):Play()
        callback()
    end)
    
    return button
end

-- CREATE UI ELEMENTS
-- Player Settings
local playerCategory = createBoxCategory("Player Settings")
createBoxToggle(playerCategory, "God Mode", false, setGodMode)
createBoxToggle(playerCategory, "Aimbot", false, toggleAimbot)
createBoxToggle(playerCategory, "Jump Boost", false, function(state) 
    boostJumpEnabled = state 
end)

-- Visual Settings
local visualCategory = createBoxCategory("Visual Settings")
createBoxToggle(visualCategory, "ESP", false, toggleESP)
createBoxToggle(visualCategory, "Invisible", false, setInvisible)

-- Steal Settings
local stealCategory = createBoxCategory("Steal Settings")
createBoxButton(stealCategory, "Open Teleport Control", function()
    if teleportGui then
        teleportGui.Enabled = not teleportGui.Enabled
    end
end)

-- World Settings
local worldCategory = createBoxCategory("World Settings")
createBoxButton(worldCategory, "Server Hop", serverHop)

-- WINDOW CONTROLS
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    contentFrame.Visible = not minimized
    minimizeButton.Text = minimized and "+" or "_"
    
    local targetSize = minimized and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 450)
    TweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = targetSize}):Play()
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- DRAGGABLE WINDOW
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- CREATE TELEPORT GUI (BOX STYLE)
teleportGui = Instance.new("ScreenGui")
teleportGui.Name = "LuxuryBoxTeleportGUI"
teleportGui.ResetOnSpawn = false
teleportGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
teleportGui.Enabled = false
teleportGui.Parent = player:WaitForChild("PlayerGui")

local teleportFrame = Instance.new("Frame")
teleportFrame.Size = UDim2.new(0, 220, 0, 120)
teleportFrame.Position = UDim2.new(0.5, -110, 0.5, -60)
teleportFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
teleportFrame.BorderSizePixel = 0
teleportFrame.Parent = teleportGui

local teleportTopBar = Instance.new("Frame")
teleportTopBar.Size = UDim2.new(1, 0, 0, 30)
teleportTopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
teleportTopBar.BorderSizePixel = 0
teleportTopBar.Parent = teleportFrame

local teleportTitle = Instance.new("TextLabel")
teleportTitle.Text = "TELEPORT CONTROL"
teleportTitle.Font = Enum.Font.GothamBold
teleportTitle.TextSize = 16
teleportTitle.TextColor3 = Color3.fromRGB(220, 220, 255)
teleportTitle.Size = UDim2.new(1, -10, 1, 0)
teleportTitle.Position = UDim2.new(0, 10, 0, 0)
teleportTitle.BackgroundTransparency = 1
teleportTitle.TextXAlignment = Enum.TextXAlignment.Left
teleportTitle.Parent = teleportTopBar

local teleportClose = Instance.new("TextButton")
teleportClose.Text = "X"
teleportClose.Font = Enum.Font.GothamBold
teleportClose.TextSize = 16
teleportClose.TextColor3 = Color3.fromRGB(200, 200, 200)
teleportClose.Size = UDim2.new(0, 30, 0, 30)
teleportClose.Position = UDim2.new(1, -35, 0.5, -15)
teleportClose.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
teleportClose.BorderSizePixel = 0
teleportClose.Parent = teleportTopBar

teleportClose.MouseButton1Click:Connect(function()
    teleportGui.Enabled = false
end)

local teleportButton = createBoxButton(teleportFrame, "TELEPORT TO SKY", function()
    isTeleporting = not isTeleporting
    if isTeleporting then
        teleportToSky()
        teleportButton.Text = "TELEPORT TO GROUND"
    else
        teleportToGround()
        teleportButton.Text = "TELEPORT TO SKY"
    end
end)
teleportButton.Position = UDim2.new(0, 10, 0, 40)