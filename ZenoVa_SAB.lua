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

-- COLOR SCHEME
local colors = {
    background = Color3.fromRGB(30, 30, 40),
    header = Color3.fromRGB(25, 25, 35),
    accent = Color3.fromRGB(0, 150, 255),
    text = Color3.fromRGB(240, 240, 240),
    toggleOff = Color3.fromRGB(70, 70, 80),
    toggleOn = Color3.fromRGB(0, 200, 100),
    button = Color3.fromRGB(50, 50, 60),
    buttonHover = Color3.fromRGB(60, 60, 70),
    category = Color3.fromRGB(40, 40, 50)
}

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
            h.FillColor = colors.accent
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
--[[           GUI CREATION FUNCTIONS          ]]--
---------------------------------------------------

local function createButtonHoverEffect(button)
    local originalColor = button.BackgroundColor3
    local hoverColor = colors.buttonHover
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = originalColor}):Play()
    end)
end

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
    
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = colors.accent
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.5

    local titleBar = Instance.new("TextLabel", mainFrame)
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = colors.header
    titleBar.BackgroundTransparency = 0
    titleBar.Text = "TELEPORTATION"
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextSize = 14
    titleBar.TextColor3 = colors.text
    titleBar.TextXAlignment = Enum.TextXAlignment.Center
    
    local titleCorner = Instance.new("UICorner", titleBar)
    titleCorner.CornerRadius = UDim.new(0, 6)

    local teleportButton = Instance.new("TextButton", mainFrame)
    teleportButton.Size = UDim2.new(0.8, 0, 0, 35)
    teleportButton.Position = UDim2.new(0.1, 0, 0.5, -17.5)
    teleportButton.BackgroundColor3 = colors.button
    teleportButton.TextColor3 = colors.text
    teleportButton.Font = Enum.Font.GothamSemibold
    teleportButton.TextSize = 14
    teleportButton.Text = "SKY"
    
    local btnCorner = Instance.new("UICorner", teleportButton)
    btnCorner.CornerRadius = UDim.new(0, 4)
    
    local btnStroke = Instance.new("UIStroke", teleportButton)
    btnStroke.Color = colors.accent
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.7
    
    createButtonHoverEffect(teleportButton)

    teleportButton.MouseButton1Click:Connect(function()
        isTeleporting = not isTeleporting
        if isTeleporting then
            teleportToSky()
            teleportButton.Text = "GROUND"
            TweenService:Create(teleportButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.toggleOn}):Play()
        else
            teleportToGround()
            teleportButton.Text = "SKY"
            TweenService:Create(teleportButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.button}):Play()
        end
    end)
end

local function createV1Menu()
    if gui then gui:Destroy() end

    gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "ServerV1Menu"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local mainFrame = Instance.new("Frame", gui)
    local originalSize = UDim2.new(0, 200, 0, 320)
    mainFrame.Size = originalSize
    mainFrame.Position = UDim2.new(0.05, 0, 0.5, -160)
    mainFrame.BackgroundColor3 = colors.background
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    
    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 8)
    
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = colors.accent
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.5

    local titleBar = Instance.new("TextLabel", mainFrame)
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = colors.header
    titleBar.BackgroundTransparency = 0
    titleBar.Text = "ZenoVa HUB | Steal A Brainrot"
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextSize = 16
    titleBar.TextColor3 = colors.text
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
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- MINIMIZE BUTTON
    local minimized = false
    local minimizeButton = Instance.new("TextButton", titleBar)
    minimizeButton.Size = UDim2.new(0, 25, 0, 25)
    minimizeButton.Position = UDim2.new(1, -30, 0.5, -12.5)
    minimizeButton.BackgroundColor3 = colors.button
    minimizeButton.Text = "–"
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.TextSize = 16
    minimizeButton.TextColor3 = colors.text
    local minimizeCorner = Instance.new("UICorner", minimizeButton)
    minimizeCorner.CornerRadius = UDim.new(0, 4)
    
    createButtonHoverEffect(minimizeButton)
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        contentFrame.Visible = not minimized
        minimizeButton.Text = minimized and "+" or "–"
        
        local targetSize = minimized and UDim2.new(0, 200, 0, 35) or originalSize
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
    end)

    local currentLayoutOrder = 1
    local function createCategory(title)
        local categoryFrame = Instance.new("Frame", contentFrame)
        categoryFrame.Size = UDim2.new(1, 0, 0, 25)
        categoryFrame.BackgroundColor3 = colors.category
        categoryFrame.BackgroundTransparency = 0.5
        categoryFrame.LayoutOrder = currentLayoutOrder
        currentLayoutOrder = currentLayoutOrder + 1
        
        local categoryCorner = Instance.new("UICorner", categoryFrame)
        categoryCorner.CornerRadius = UDim.new(0, 4)
        
        local categoryLabel = Instance.new("TextLabel", categoryFrame)
        categoryLabel.Size = UDim2.new(1, 0, 1, 0)
        categoryLabel.Text = title
        categoryLabel.Font = Enum.Font.GothamBold
        categoryLabel.TextSize = 14
        categoryLabel.TextColor3 = colors.text
        categoryLabel.BackgroundTransparency = 1
        categoryLabel.TextXAlignment = Enum.TextXAlignment.Center
        
        return categoryFrame
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

        local switch = Instance.new("TextButton", container)
        switch.Size = UDim2.new(0, 45, 0, 22)
        switch.Position = UDim2.new(1, -50, 0.5, -11)
        switch.BackgroundColor3 = colors.toggleOff
        switch.Text = ""
        local switchCorner = Instance.new("UICorner", switch)
        switchCorner.CornerRadius = UDim.new(0.5, 0)
        
        local switchStroke = Instance.new("UIStroke", switch)
        switchStroke.Color = colors.accent
        switchStroke.Thickness = 1
        switchStroke.Transparency = 0.7

        local nub = Instance.new("Frame", switch)
        nub.Size = UDim2.new(0, 18, 0, 18)
        nub.Position = UDim2.new(0, 2, 0.5, -9)
        nub.BackgroundColor3 = colors.text
        local nubCorner = Instance.new("UICorner", nub)
        nubCorner.CornerRadius = UDim.new(0.5, 0)

        local state = false
        switch.MouseButton1Click:Connect(function()
            state = not state
            callback(state)
            local nubPos = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            local switchColor = state and colors.toggleOn or colors.toggleOff
            TweenService:Create(nub, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Position = nubPos }):Play()
            TweenService:Create(switch, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { BackgroundColor3 = switchColor }):Play()
        end)
        
        createButtonHoverEffect(switch)
    end
    
    local function createOneShotButton(name, parent, callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = colors.button
        btn.TextColor3 = colors.text
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.Text = name
        btn.LayoutOrder = currentLayoutOrder
        currentLayoutOrder = currentLayoutOrder + 1
        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 4)
        
        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = colors.accent
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.7
        
        createButtonHoverEffect(btn)

        btn.MouseButton1Click:Connect(callback)
    end
    
    -- CREATE UI ELEMENTS
    -- Player Settings
    createCategory("PLAYER SETTINGS")
    createToggleButton("Godmode", contentFrame, setGodMode)
    createToggleButton("Aimbot", contentFrame, toggleAimbot)
    createToggleButton("Jump Boost", contentFrame, function(state) boostJumpEnabled = state end)

    -- Visual Settings
    createCategory("VISUALS")
    createToggleButton("ESP", contentFrame, toggleESP)
    createToggleButton("Invisible", contentFrame, setInvisible)

    -- Teleport Settings
    createCategory("TELEPORT")
    createOneShotButton("Toggle Teleport", contentFrame, function()
        if teleportGui then
            teleportGui.Enabled = not teleportGui.Enabled
            StarterGui:SetCore("SendNotification", {
                Title = "Teleport",
                Text = teleportGui.Enabled and "Teleport GUI enabled" or "Teleport GUI disabled",
                Duration = 2
            })
        end
    end)
    
    -- Server Settings
    createCategory("SERVER")
    createOneShotButton("Server Hop", contentFrame, serverHop)
    
    -- Initial animation
    mainFrame.Position = UDim2.new(0.05, 0, 0, -400)
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.05, 0, 0.5, -160)}):Play()
end

-- Initialize Menus
createTeleportGUI()
createV1Menu()