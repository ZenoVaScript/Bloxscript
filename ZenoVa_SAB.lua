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

---------------------------------------------------
--[[           FUNCTION DEFINITIONS            ]]--
---------------------------------------------------

-- TELEPORT / MOVEMENT FUNCTIONS
local doorPositions = {
    Vector3.new(-466, -1, 220), Vector3.new(-466, -2, 116), Vector3.new(-466, -2, 8),
    Vector3.new(-464, -2, -102), Vector3.new(-351, -2, -100), Vector3.new(-354, -2, 5),
    Vector3.new(-354, -2, 115), Vector3.new(-358, -2, 223)
}

local function getNearestDoor()
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, door in ipairs(doorPositions) do
        local dist = (root.Position - door).Magnitude
        if dist < minDist then
            minDist = dist
            closest = door
        end
    end
    return closest
end

local function teleportToSky()
    if not root then updateCharacter() end
    local door = getNearestDoor()
    if door and root then
        TweenService:Create(root, TweenInfo.new(1.2), { CFrame = CFrame.new(door) }):Play()
        task.wait(1.3)
        root.CFrame = root.CFrame + Vector3.new(0, 200, 0)
    end
end

local function teleportToGround()
    if not root then updateCharacter() end
    if root then
        root.CFrame = root.CFrame - Vector3.new(0, 50, 0)
    end
end

-- COMBAT / PLAYER STATE FUNCTIONS
function setGodMode(on)
    if not humanoid then updateCharacter() end
    if not humanoid then return end

    if on then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        if godConnection then godConnection:Disconnect() end
        godConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health < math.huge then
                humanoid.Health = math.huge
            end
        end)
    else
        if godConnection then godConnection:Disconnect() end
        godConnection = nil
        pcall(function()
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end)
    end
end

local aimbotRange = 100

local function getClosestAimbotTarget()
    if not root then return nil end

    local closestPlayer, shortestDist = nil, aimbotRange
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") and p.Character.Humanoid.Health > 0 then
            local targetHRP = p.Character.HumanoidRootPart
            local dist = (root.Position - targetHRP.Position).Magnitude
            
            if dist < shortestDist then
                closestPlayer = p
                shortestDist = dist
            end
        end
    end
    return closestPlayer
end

local function toggleAimbot(state)
    if state then
        aimConnection = RunService.Heartbeat:Connect(function()
            local target = getClosestAimbotTarget()
            if target and target.Character and char and root and humanoid then
                local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    root.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetHrp.Position.X, root.Position.Y, targetHrp.Position.Z))
                end
            end
        end)
    else
        if aimConnection then
            aimConnection:Disconnect()
            aimConnection = nil
        end
    end
end

UserInputService.JumpRequest:Connect(function()
    if boostJumpEnabled and humanoid and root then
        root.AssemblyLinearVelocity = Vector3.new(0, 100, 0)
        local gravityConn
        gravityConn = RunService.Stepped:Connect(function()
            if not char or not root or not humanoid or not boostJumpEnabled then
                gravityConn:Disconnect()
                return
            end

            if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                root.Velocity = Vector3.new(root.Velocity.X, math.clamp(root.Velocity.Y, -20, 150), root.Velocity.Z)
            elseif humanoid.FloorMaterial ~= Enum.Material.Air then
                gravityConn:Disconnect()
            end
        end)
    end
end)

-- VISUALS FUNCTIONS
function setInvisible(on)
    if not char then updateCharacter() end
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = on and 1 or part.Parent:IsA("Accessory") and part.Parent.Handle.Transparency or 0
        elseif part:IsA("Decal") then
            part.Transparency = on and 1 or 0
        end
    end
end

local function toggleESP(state)
    espEnabled = state
    if state then
        local function applyHighlight(character)
            if not character or character:FindFirstChild("ServerV1ESP") then return end
            local h = Instance.new("Highlight")
            h.Name = "ServerV1ESP"
            h.FillColor = Color3.fromRGB(255, 50, 50)
            h.OutlineColor = Color3.new(1, 1, 1)
            h.FillTransparency = 0.5
            h.OutlineTransparency = 0
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = character
        end

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                applyHighlight(p.Character)
            end
        end
        
        table.insert(espConnections, Players.PlayerAdded:Connect(function(newP)
            newP.CharacterAdded:Connect(function(char)
                if espEnabled then applyHighlight(char) end
            end)
        end))
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                table.insert(espConnections, p.CharacterAdded:Connect(function(char)
                    if espEnabled then applyHighlight(char) end
                end))
            end
        end
    else
        for _, c in ipairs(espConnections) do c:Disconnect() end
        espConnections = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local h = p.Character:FindFirstChild("ServerV1ESP")
                if h then h:Destroy() end
            end
        end
    end
end

-- WORLD / SERVER FUNCTIONS
local function serverHop()
    local placeId = game.PlaceId
    local servers = {}
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and response and response.data then
        for _, server in ipairs(response.data) do
            if server.playing and server.maxPlayers and server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
    end
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(placeId, servers[math.random(1, #servers)])
    else
        StarterGui:SetCore("SendNotification", { Title = "Server Hop", Text = "No other servers found.", Duration = 3 })
    end
end

---------------------------------------------------
--[[               LUXURY GUI                 ]]--
---------------------------------------------------

local function applyGradient(frame)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 40, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    gradient.Parent = frame
end

local function createLuxuryButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Name = "LuxuryButton"
    button.Text = text
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    button.AutoButtonColor = false
    button.Size = UDim2.new(1, -10, 0, 36)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(80, 80, 100)
    stroke.Thickness = 1
    stroke.Parent = button
    
    local hoverGradient = Instance.new("UIGradient")
    hoverGradient.Rotation = 90
    hoverGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 80))
    })
    hoverGradient.Enabled = false
    hoverGradient.Parent = button
    
    button.MouseEnter:Connect(function()
        hoverGradient.Enabled = true
        TweenService:Create(button, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(100, 150, 255)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        hoverGradient.Enabled = false
        TweenService:Create(button, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(80, 80, 100)}):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(0.95, -10, 0, 34)}):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 36)}):Play()
        callback()
    end)
    
    return button
end

local function createLuxuryToggle(parent, text, defaultState, callback)
    local container = Instance.new("Frame")
    container.Name = "ToggleContainer"
    container.BackgroundTransparency = 1
    container.Size = UDim2.new(1, -10, 0, 36)
    container.Position = UDim2.new(0, 5, 0, 0)
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Name = "ToggleLabel"
    label.Text = text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Parent = container
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Size = UDim2.new(0, 50, 0, 24)
    toggleFrame.Position = UDim2.new(1, -60, 0.5, -12)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    toggleFrame.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = toggleFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(80, 80, 100)
    stroke.Thickness = 1
    stroke.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Text = ""
    toggleButton.Size = UDim2.new(0, 20, 0, 20)
    toggleButton.Position = UDim2.new(0, 2, 0.5, -10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    toggleButton.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = toggleButton
    
    local state = defaultState or false
    
    local function updateToggle()
        if state then
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -22, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(100, 255, 150)
            }):Play()
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 80, 50)
            }):Play()
        else
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            }):Play()
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            }):Play()
        end
        callback(state)
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
    end)
    
    -- Initialize state
    updateToggle()
    
    return {
        SetState = function(newState)
            state = newState
            updateToggle()
        end,
        GetState = function()
            return state
        end
    }
end

local function createLuxuryCategory(parent, title)
    local category = Instance.new("Frame")
    category.Name = "Category"
    category.BackgroundTransparency = 1
    category.Size = UDim2.new(1, -10, 0, 42)
    category.Position = UDim2.new(0, 5, 0, 0)
    category.Parent = parent
    
    local labelContainer = Instance.new("Frame")
    labelContainer.Name = "LabelContainer"
    labelContainer.Size = UDim2.new(1, 0, 0, 24)
    labelContainer.Position = UDim2.new(0, 0, 0, 10)
    labelContainer.BackgroundTransparency = 1
    labelContainer.Parent = category
    
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 50, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))
    })
    gradient.Parent = labelContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = labelContainer
    
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(80, 80, 120)
    stroke.Thickness = 1
    stroke.Parent = labelContainer
    
    local label = Instance.new("TextLabel")
    label.Name = "CategoryLabel"
    label.Text = string.upper(title)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(180, 180, 255)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Parent = labelContainer
    
    return category
end

local function createLuxuryTeleportGUI()
    teleportGui = Instance.new("ScreenGui")
    teleportGui.Name = "LuxuryTeleportControl"
    teleportGui.ResetOnSpawn = false
    teleportGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    teleportGui.Enabled = false
    teleportGui.Parent = player:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 180, 0, 120)
    mainFrame.Position = UDim2.new(0.5, -90, 0.5, -60)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.Parent = teleportGui
    
    applyGradient(mainFrame)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(80, 80, 120)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = "TELEPORT CONTROL"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Position = UDim2.new(1, -28, 0.5, -12)
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        teleportGui.Enabled = false
    end)
    
    local teleportButton = createLuxuryButton(mainFrame, "TELEPORT TO SKY", function()
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
end

local function createLuxuryMainGUI()
    if gui then gui:Destroy() end

    gui = Instance.new("ScreenGui")
    gui.Name = "LuxuryServerV1Menu"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 240, 0, 400)
    mainFrame.Position = UDim2.new(0.05, 0, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.Parent = gui
    
    applyGradient(mainFrame)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(80, 80, 120)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = mainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = "ZENOVA SAB | V1"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Text = "─"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 20
    minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    minimizeButton.Size = UDim2.new(0, 24, 0, 24)
    minimizeButton.Position = UDim2.new(1, -60, 0.5, -12)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    minimizeButton.Parent = titleBar
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 4)
    minimizeCorner.Parent = minimizeButton
    
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "×"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Position = UDim2.new(1, -28, 0.5, -12)
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
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
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = contentFrame
    
    -- Minimize functionality
    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        contentFrame.Visible = not minimized
        minimizeButton.Text = minimized and "+" or "─"
        
        local targetSize = minimized and UDim2.new(0, 240, 0, 40) or UDim2.new(0, 240, 0, 400)
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    
    -- Create categories and controls
    -- Player Settings
    local playerCategory = createLuxuryCategory(contentFrame, "Player Settings")
    createLuxuryToggle(playerCategory, "God Mode", false, setGodMode)
    createLuxuryToggle(playerCategory, "Aimbot", false, toggleAimbot)
    createLuxuryToggle(playerCategory, "Jump Boost", false, function(state) boostJumpEnabled = state end)
    
    -- Visual Settings
    local visualCategory = createLuxuryCategory(contentFrame, "Visual Settings")
    createLuxuryToggle(visualCategory, "ESP", false, toggleESP)
    createLuxuryToggle(visualCategory, "Invisible", false, setInvisible)
    
    -- Steal Settings
    local stealCategory = createLuxuryCategory(contentFrame, "Steal Settings")
    createLuxuryButton(stealCategory, "Open Teleport Control", function()
        if teleportGui then
            teleportGui.Enabled = not teleportGui.Enabled
        end
    end)
    
    -- World Settings
    local worldCategory = createLuxuryCategory(contentFrame, "World Settings")
    createLuxuryButton(worldCategory, "Server Hop", serverHop)
    
    -- Add some decorative elements
    local footer = Instance.new("Frame")
    footer.Size = UDim2.new(1, 0, 0, 20)
    footer.BackgroundTransparency = 1
    footer.Parent = contentFrame
    
    local footerText = Instance.new("TextLabel")
    footerText.Text = "ZENOVA SAB | V1"
    footerText.Font = Enum.Font.GothamSemibold
    footerText.TextSize = 12
    footerText.TextColor3 = Color3.fromRGB(120, 120, 150)
    footerText.Size = UDim2.new(1, 0, 1, 0)
    footerText.BackgroundTransparency = 1
    footerText.TextXAlignment = Enum.TextXAlignment.Center
    footerText.Parent = footer
    
    -- Make the window draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
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
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateInput(input)
        end
    end)
end

-- Initialize the luxury GUIs
createLuxuryTeleportGUI()
createLuxuryMainGUI()