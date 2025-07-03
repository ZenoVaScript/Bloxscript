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
local antiStunConnection = nil

local function updateCharacter()
    char = player.Character or player.CharacterAdded:Wait()
    root = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
end

updateCharacter()
player.CharacterAdded:Connect(function()
    task.wait(1)
    updateCharacter()
end)

-- SCRIPT-WIDE STATES & VARIABLES
local gui
local godConnection, aimConnection
local espEnabled = false
local espConnections = {}
local boostJumpEnabled = false
local teleportGui
local isTeleporting = false

-- Color scheme
local colors = {
    background = Color3.fromRGB(30, 30, 40),
    header = Color3.fromRGB(20, 20, 30),
    accent = Color3.fromRGB(0, 120, 215),
    text = Color3.fromRGB(240, 240, 240),
    toggleOff = Color3.fromRGB(70, 70, 70),
    toggleOn = Color3.fromRGB(0, 200, 83),
    button = Color3.fromRGB(50, 50, 60),
    category = Color3.fromRGB(40, 40, 50)
}

---------------------------------------------------
--[[           FUNCTION DEFINITIONS            ]]--
---------------------------------------------------

[Previous functions remain exactly the same until the GUI creation section]

---------------------------------------------------
--[[               GUI CREATION               ]]--
---------------------------------------------------

local function createTeleportGUI()
    teleportGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    teleportGui.Name = "TeleportControl"
    teleportGui.ResetOnSpawn = false
    teleportGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    teleportGui.Enabled = false

    local mainFrame = Instance.new("Frame", teleportGui)
    mainFrame.Size = UDim2.new(0, 150, 0, 100)
    mainFrame.Position = UDim2.new(0.5, -75, 0.5, -50)
    mainFrame.BackgroundColor3 = colors.background
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 6)

    local titleBar = Instance.new("TextLabel", mainFrame)
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = colors.header
    titleBar.Text = "TELEPORT CONTROL"
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextSize = 14
    titleBar.TextColor3 = colors.text
    titleBar.TextXAlignment = Enum.TextXAlignment.Center
    
    local titleCorner = Instance.new("UICorner", titleBar)
    titleCorner.CornerRadius = UDim.new(0, 6)

    local closeButton = Instance.new("TextButton", titleBar)
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -25, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 14
    closeButton.TextColor3 = colors.text
    closeButton.MouseButton1Click:Connect(function()
        teleportGui.Enabled = false
    end)
    
    local closeCorner = Instance.new("UICorner", closeButton)
    closeCorner.CornerRadius = UDim.new(0, 6)

    local teleportButton = Instance.new("TextButton", mainFrame)
    teleportButton.Size = UDim2.new(0.8, 0, 0, 40)
    teleportButton.Position = UDim2.new(0.1, 0, 0.5, -20)
    teleportButton.BackgroundColor3 = colors.button
    teleportButton.TextColor3 = colors.text
    teleportButton.Font = Enum.Font.GothamSemibold
    teleportButton.TextSize = 14
    teleportButton.Text = "TELEPORT TO SKY"
    
    local btnCorner = Instance.new("UICorner", teleportButton)
    btnCorner.CornerRadius = UDim.new(0, 6)

    teleportButton.MouseButton1Click:Connect(function()
        isTeleporting = not isTeleporting
        if isTeleporting then
            teleportToSky()
            teleportButton.Text = "TELEPORT TO GROUND"
        else
            teleportToGround()
            teleportButton.Text = "TELEPORT TO SKY"
        end
    end)
end

local function createMainMenu()
    if gui then gui:Destroy() end

    gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "ZenoVaSABMenu"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local mainFrame = Instance.new("Frame", gui)
    local originalSize = UDim2.new(0, 200, 0, 350)
    mainFrame.Size = originalSize
    mainFrame.Position = UDim2.new(0.05, 0, 0.5, -175)
    mainFrame.BackgroundColor3 = colors.background
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 8)

    local titleBar = Instance.new("TextLabel", mainFrame)
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = colors.header
    titleBar.Text = "ZENOVA SAB"
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextSize = 16
    titleBar.TextColor3 = colors.accent
    titleBar.TextXAlignment = Enum.TextXAlignment.Center
    
    local titleCorner = Instance.new("UICorner", titleBar)
    titleCorner.CornerRadius = UDim.new(0, 8)

    local contentFrame = Instance.new("ScrollingFrame", mainFrame)
    contentFrame.Size = UDim2.new(1, -10, 1, -40)
    contentFrame.Position = UDim2.new(0, 5, 0, 35)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = colors.accent
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local listLayout = Instance.new("UIListLayout", contentFrame)
    listLayout.Padding = UDim.new(0, 8)

    -- MINIMIZE BUTTON
    local minimized = false
    local minimizeButton = Instance.new("TextButton", titleBar)
    minimizeButton.Size = UDim2.new(0, 25, 0, 25)
    minimizeButton.Position = UDim2.new(1, -30, 0.5, -12)
    minimizeButton.BackgroundColor3 = colors.button
    minimizeButton.Text = "─"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 16
    minimizeButton.TextColor3 = colors.text
    local minimizeCorner = Instance.new("UICorner", minimizeButton)
    minimizeCorner.CornerRadius = UDim.new(0, 6)
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        contentFrame.Visible = not minimized
        minimizeButton.Text = minimized and "+" or "─"
        
        local targetSize = minimized and UDim2.new(0, 200, 0, 35) or originalSize
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
    end)

    local currentLayoutOrder = 1
    local function createCategory(title)
        local categoryLabel = Instance.new("TextLabel", contentFrame)
        categoryLabel.Size = UDim2.new(1, 0, 0, 25)
        categoryLabel.Text = string.upper(title)
        categoryLabel.Font = Enum.Font.GothamBold
        categoryLabel.TextSize = 12
        categoryLabel.TextColor3 = colors.accent
        categoryLabel.BackgroundColor3 = colors.category
        categoryLabel.BackgroundTransparency = 0.5
        categoryLabel.TextXAlignment = Enum.TextXAlignment.Center
        categoryLabel.LayoutOrder = currentLayoutOrder
        currentLayoutOrder = currentLayoutOrder + 1
        
        local categoryCorner = Instance.new("UICorner", categoryLabel)
        categoryCorner.CornerRadius = UDim.new(0, 4)
        return categoryLabel
    end

    local function createToggleButton(name, parent, callback)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(1, 0, 0, 30)
        container.BackgroundTransparency = 1
        container.LayoutOrder = currentLayoutOrder
        currentLayoutOrder = currentLayoutOrder + 1

        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Text = name
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 14
        label.TextColor3 = colors.text
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left

        local switch = Instance.new("Frame", container)
        switch.Size = UDim2.new(0, 50, 0, 25)
        switch.Position = UDim2.new(1, -55, 0.5, -12)
        switch.BackgroundColor3 = colors.toggleOff
        local switchCorner = Instance.new("UICorner", switch)
        switchCorner.CornerRadius = UDim.new(0.5, 0)

        local nub = Instance.new("Frame", switch)
        nub.Size = UDim2.new(0, 21, 0, 21)
        nub.Position = UDim2.new(0, 2, 0.5, -10)
        nub.BackgroundColor3 = colors.text
        local nubCorner = Instance.new("UICorner", nub)
        nubCorner.CornerRadius = UDim.new(0.5, 0)

        local state = false
        switch.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                state = not state
                callback(state)
                local nubPos = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                local switchColor = state and colors.toggleOn or colors.toggleOff
                TweenService:Create(nub, TweenInfo.new(0.2), {Position = nubPos}):Play()
                TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = switchColor}):Play()
            end
        end)
    end
    
    local function createButton(name, parent, callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.BackgroundColor3 = colors.button
        btn.TextColor3 = colors.text
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.Text = name
        btn.LayoutOrder = currentLayoutOrder
        currentLayoutOrder = currentLayoutOrder + 1
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 6)

        btn.MouseButton1Click:Connect(callback)
        
        -- Hover effect
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = colors.button}):Play()
        end)
    end
    
    -- CREATE UI SECTIONS
    createCategory("PLAYER")
    createToggleButton("Godmode", contentFrame, setGodMode)
    createToggleButton("Aimbot", contentFrame, toggleAimbot)
    createToggleButton("Jump Boost", contentFrame, function(state) boostJumpEnabled = state end)

    createCategory("VISUALS")
    createToggleButton("ESP", contentFrame, toggleESP)
    createToggleButton("Invisible", contentFrame, setInvisible)

    createCategory("STEAL")
    createButton("Teleport Controls", contentFrame, function()
        teleportGui.Enabled = not teleportGui.Enabled
    end)
    
    createCategory("SERVER")
    createButton("Server Hop", contentFrame, serverHop)
end

-- Initialize GUIs
createTeleportGUI()
createMainMenu()