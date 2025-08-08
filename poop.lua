local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local backpack = player:WaitForChild("Backpack")

local poopEvent = ReplicatedStorage:WaitForChild("PoopEvent")
local poopChargeStartEvent = ReplicatedStorage:WaitForChild("PoopChargeStart")
local poopResponseChosenEvent = ReplicatedStorage:WaitForChild("PoopResponseChosen")

local isPoopLooping = false
local isSellLooping = false
local Whitelist = {}
local antiFriendsEnabled = false

-- Modern color scheme
local colors = {
    background = Color3.fromRGB(30, 30, 40),
    panel = Color3.fromRGB(40, 40, 50),
    button = Color3.fromRGB(60, 60, 80),
    buttonHover = Color3.fromRGB(80, 80, 100),
    buttonActive = Color3.fromRGB(100, 180, 100),
    buttonDanger = Color3.fromRGB(180, 80, 80),
    buttonDangerHover = Color3.fromRGB(200, 100, 100),
    text = Color3.fromRGB(240, 240, 240),
    accent = Color3.fromRGB(100, 150, 255),
    input = Color3.fromRGB(50, 50, 60)
}

-- Create main UI container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PoopSimulatorGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create main frame with smooth animations
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 320)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
mainFrame.BackgroundColor3 = colors.panel
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
mainFrame.Visible = true

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Parent = mainFrame
shadow.ZIndex = -1

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = colors.background
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Poop Simulator GUI"
titleText.TextColor3 = colors.text
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0.5, -10)
closeButton.AnchorPoint = Vector2.new(0, 0.5)
closeButton.BackgroundTransparency = 1
closeButton.Image = "rbxassetid://3926305904"
closeButton.ImageColor3 = colors.text
closeButton.ImageRectOffset = Vector2.new(924, 724)
closeButton.ImageRectSize = Vector2.new(36, 36)
closeButton.Parent = titleBar

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -40)
contentFrame.Position = UDim2.new(0.5, -90, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Create stylish buttons with hover effects
local function createButton(name, text, position, color, hoverColor)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 0, 36)
    button.Position = position
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = colors.text
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.AutoButtonColor = false
    button.Parent = contentFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = button
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(
            math.floor(hoverColor.R * 255 * 0.8),
            math.floor(hoverColor.G * 255 * 0.8),
            math.floor(hoverColor.B * 255 * 0.8)
        )}):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    return button
end

-- Create all buttons
local heaviestButton = createButton("HeaviestButton", "Equip Heaviest", UDim2.new(0, 0, 0, 0), colors.button, colors.buttonHover)
local unequipButton = createButton("UnequipButton", "Unequip All", UDim2.new(0, 0, 0, 46), colors.button, colors.buttonHover)
local poopButton = createButton("PoopButton", "Auto-Poop [OFF]", UDim2.new(0, 0, 0, 92), colors.buttonDanger, colors.buttonDangerHover)
local oneClickSellButton = createButton("OneClickSellButton", "Sell Inventory Once", UDim2.new(0, 0, 0, 138), colors.accent, Color3.fromRGB(120, 170, 255))
local autoSellButton = createButton("AutoSellButton", "Auto-Sell [OFF]", UDim2.new(0, 0, 0, 184), colors.buttonDanger, colors.buttonDangerHover)

-- Create input fields with modern design
local function createInputField(name, placeholder, position, defaultValue)
    local frame = Instance.new("Frame")
    frame.Name = name .. "Frame"
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = contentFrame
    
    local box = Instance.new("TextBox")
    box.Name = name
    box.Size = UDim2.new(1, 0, 1, 0)
    box.Position = UDim2.new(0, 0, 0, 0)
    box.BackgroundColor3 = colors.input
    box.Text = defaultValue
    box.PlaceholderText = placeholder
    box.TextColor3 = colors.text
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = box
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = box
    
    -- Focus effects
    box.Focused:Connect(function()
        TweenService:Create(box, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(
            math.floor(colors.input.R * 255 * 1.2),
            math.floor(colors.input.G * 255 * 1.2),
            math.floor(colors.input.B * 255 * 1.2)
        )}):Play()
    end)
    
    box.FocusLost:Connect(function()
        TweenService:Create(box, TweenInfo.new(0.2), {BackgroundColor3 = colors.input}):Play()
    end)
    
    return box
end

local poopDelayTextBox = createInputField("PoopDelayTextBox", "Poop Delay (seconds)", UDim2.new(0, 0, 0, 230), "0.2")
local sellDelayTextBox = createInputField("SellDelayTextBox", "Sell Delay (seconds)", UDim2.new(0, 0, 0, 276), "10")

-- Create fling panel with modern design
local flingFrame = Instance.new("Frame")
flingFrame.Name = "FlingFrame"
flingFrame.Size = UDim2.new(0, 200, 0, 100)
flingFrame.Position = UDim2.new(0, 20, 0.5, -50)
flingFrame.BackgroundColor3 = colors.panel
flingFrame.BorderSizePixel = 0
flingFrame.AnchorPoint = Vector2.new(0, 0.5)
flingFrame.Active = true
flingFrame.Draggable = true
flingFrame.Parent = screenGui
flingFrame.Visible = true

local flingCorner = Instance.new("UICorner")
flingCorner.CornerRadius = UDim.new(0, 12)
flingCorner.Parent = flingFrame

local flingShadow = Instance.new("ImageLabel")
flingShadow.Name = "Shadow"
flingShadow.Image = "rbxassetid://1316045217"
flingShadow.ImageColor3 = Color3.new(0, 0, 0)
flingShadow.ImageTransparency = 0.8
flingShadow.ScaleType = Enum.ScaleType.Slice
flingShadow.SliceCenter = Rect.new(10, 10, 118, 118)
flingShadow.Size = UDim2.new(1, 20, 1, 20)
flingShadow.Position = UDim2.new(0, -10, 0, -10)
flingShadow.BackgroundTransparency = 1
flingShadow.Parent = flingFrame
flingShadow.ZIndex = -1

local flingTitle = Instance.new("TextLabel")
flingTitle.Name = "Title"
flingTitle.Size = UDim2.new(1, 0, 0, 30)
flingTitle.Position = UDim2.new(0, 0, 0, 0)
flingTitle.BackgroundColor3 = colors.background
flingTitle.BorderSizePixel = 0
flingTitle.Text = "Fling Tool"
flingTitle.TextColor3 = colors.text
flingTitle.Font = Enum.Font.GothamBold
flingTitle.TextSize = 14
flingTitle.Parent = flingFrame

local flingTitleCorner = Instance.new("UICorner")
flingTitleCorner.CornerRadius = UDim.new(0, 12)
flingTitleCorner.Parent = flingTitle

local flingContent = Instance.new("Frame")
flingContent.Name = "Content"
flingContent.Size = UDim2.new(1, -20, 1, -40)
flingContent.Position = UDim2.new(0.5, -90, 0, 40)
flingContent.BackgroundTransparency = 1
flingContent.Parent = flingFrame

local flingTargetBox = createInputField("FlingTargetBox", "Target Username", UDim2.new(0, 0, 0, 0), "")
flingTargetBox.Parent = flingContent
flingTargetBox.Size = UDim2.new(1, 0, 0, 30)

local flingTargetButton = createButton("FlingTargetButton", "Fling Target", UDim2.new(0, 0, 0, 40), colors.buttonDanger, colors.buttonDangerHover)
flingTargetButton.Parent = flingContent

-- Create toggle button with animation
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 120, 0, 30)
toggleButton.Position = UDim2.new(0.5, -60, 0, 10)
toggleButton.AnchorPoint = Vector2.new(0.5, 0)
toggleButton.BackgroundColor3 = colors.button
toggleButton.Text = "Toggle GUI"
toggleButton.TextColor3 = colors.text
toggleButton.Font = Enum.Font.GothamSemibold
toggleButton.TextSize = 14
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Add hover effects to toggle button
toggleButton.MouseEnter:Connect(function()
    TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.buttonHover}):Play()
end)

toggleButton.MouseLeave:Connect(function()
    TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.button}):Play()
end)

-- Animation function
local function animateFrame(frame, visible)
    if visible then
        frame.Visible = true
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -110, 0.5, -160)
        }):Play()
    else
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -110, 0, -400)
        }):Play()
        task.wait(0.3)
        frame.Visible = false
    end
end

local uiVisible = true
toggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    animateFrame(mainFrame, uiVisible)
    animateFrame(flingFrame, uiVisible)
    toggleButton.Text = uiVisible and "Hide GUI" or "Show GUI"
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Original functionality remains the same
local function Message(_Title, _Text, Time)
    StarterGui:SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
end

local function equipHeaviestTool()
    -- Animation when pressed
    TweenService:Create(heaviestButton, TweenInfo.new(0.1), {Size = UDim2.new(0.95, 0, 0, 34)}):Play()
    task.wait(0.1)
    TweenService:Create(heaviestButton, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 36)}):Play()
    
    local heaviestTool = nil
    local maxLbs = -1
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local lbsString = tool.Name:match("%((%d+%.?%d*) lbs%)")
            if lbsString then
                local lbs = tonumber(lbsString)
                if lbs and lbs > maxLbs then
                    maxLbs = lbs
                    heaviestTool = tool
                end
            end
        end
    end
    if heaviestTool then
        humanoid:EquipTool(heaviestTool)
        Message("Success", "Equipped heaviest tool ("..maxLbs.." lbs)", 2)
    else
        Message("Error", "No tools found in backpack", 2)
    end
end

local function unequipAllTools()
    -- Animation when pressed
    TweenService:Create(unequipButton, TweenInfo.new(0.1), {Size = UDim2.new(0.95, 0, 0, 34)}):Play()
    task.wait(0.1)
    TweenService:Create(unequipButton, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 36)}):Play()
    
    humanoid:UnequipTools()
    Message("Success", "Unequipped all tools", 2)
end

local function togglePoopLoop()
    -- Animation when pressed
    TweenService:Create(poopButton, TweenInfo.new(0.1), {Size = UDim2.new(0.95, 0, 0, 34)}):Play()
    task.wait(0.1)
    TweenService:Create(poopButton, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 36)}):Play()
    
    isPoopLooping = not isPoopLooping
    if isPoopLooping then
        poopButton.Text = "Auto-Poop [ON]"
        TweenService:Create(poopButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.buttonActive}):Play()
        task.spawn(function()
            while isPoopLooping do
                local delay = tonumber(poopDelayTextBox.Text) or 0.1
                poopChargeStartEvent:FireServer()
                local args = {[1] = 1}
                poopEvent:FireServer(unpack(args))
                task.wait(delay)
            end
        end)
    else
        poopButton.Text = "Auto-Poop [OFF]"
        TweenService:Create(poopButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.buttonDanger}):Play()
    end
end

local function sellInventoryOnce()
    -- Animation when pressed
    TweenService:Create(oneClickSellButton, TweenInfo.new(0.1), {Size = UDim2.new(0.95, 0, 0, 34)}):Play()
    task.wait(0.1)
    TweenService:Create(oneClickSellButton, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 36)}):Play()
    
    local args = {
        [1] = "2. [I want to sell my inventory.]"
    }
    poopResponseChosenEvent:FireServer(unpack(args))
    Message("Success", "Sold inventory once", 2)
end

local function toggleSellLoop()
    -- Animation when pressed
    TweenService:Create(autoSellButton, TweenInfo.new(0.1), {Size = UDim2.new(0.95, 0, 0, 34)}):Play()
    task.wait(0.1)
    TweenService:Create(autoSellButton, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 36)}):Play()
    
    isSellLooping = not isSellLooping
    if isSellLooping then
        autoSellButton.Text = "Auto-Sell [ON]"
        TweenService:Create(autoSellButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.buttonActive}):Play()
        task.spawn(function()
            while isSellLooping do
                local delay = tonumber(sellDelayTextBox.Text) or 1
                local args = {
                    [1] = "2. [I want to sell my inventory.]"
                }
                poopResponseChosenEvent:FireServer(unpack(args))
                task.wait(delay)
            end
        end)
    else
        autoSellButton.Text = "Auto-Sell [OFF]"
        TweenService:Create(autoSellButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.buttonDanger}):Play()
    end
end

local function GetPlayer(Name)
    for _, x in next, Players:GetPlayers() do
        if x ~= player and (x.Name:lower():match("^" .. Name:lower()) or x.DisplayName:lower():match("^" .. Name:lower())) then
            return x
        end
    end
    return nil
end

local function SkidFling(TargetPlayer)
    -- Animation when pressed
    TweenService:Create(flingTargetButton, TweenInfo.new(0.1), {Size = UDim2.new(0.95, 0, 0, 28)}):Play()
    task.wait(0.1)
    TweenService:Create(flingTargetButton, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 30)}):Play()
    
    if not TargetPlayer then return end
    if Whitelist[TargetPlayer.Name:lower()] then return Message("Info", TargetPlayer.Name .. " is whitelisted.", 3) end
    if antiFriendsEnabled and player:IsFriendsWith(TargetPlayer.UserId) then return Message("Skipped", TargetPlayer.Name .. " is a friend.", 3) end

    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    local TCharacter = TargetPlayer.Character
    if not TCharacter then return end
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if not (Character and Humanoid and RootPart) then return Message("Error", "Your character is missing parts.", 4) end

    if RootPart.Velocity.Magnitude < 50 then getgenv().OldPos = RootPart.CFrame end
    if THumanoid and THumanoid.Sit then return Message("Error", "Target is sitting.", 4) end
    if THead then workspace.CurrentCamera.CameraSubject = THead
    elseif Handle then workspace.CurrentCamera.CameraSubject = Handle
    elseif THumanoid then workspace.CurrentCamera.CameraSubject = THumanoid end
    if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end

    local FPos = function(BasePart, Pos, Ang)
        RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
        Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
        local velocity = 9e7
        RootPart.Velocity = Vector3.new(velocity, velocity * 10, velocity)
        RootPart.RotVelocity = Vector3.new(velocity, velocity, velocity)
    end

    local SFBasePart = function(BasePart)
        local flingTimeout = 2
        local Time = tick()
        local Angle = 0
        repeat
            if not (RootPart and THumanoid and BasePart and BasePart.Parent) then break end
            if BasePart.Velocity.Magnitude < 50 then
                Angle = Angle + 100
                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                task.wait()
            else
                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                task.wait()
            end
        until BasePart.Velocity.Magnitude > 500 or not BasePart.Parent or BasePart.Parent ~= TargetPlayer.Character or not TargetPlayer.Parent or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + flingTimeout
    end

    workspace.FallenPartsDestroyHeight = 0 / 0
    local BV = Instance.new("BodyVelocity", RootPart)
    BV.Name = "EpixVel"
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(1 / 0, 1 / 0, 1 / 0)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    local partToFling = TRootPart or THead or Handle
    if partToFling then
        if TRootPart and THead and (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then SFBasePart(THead)
        else SFBasePart(partToFling) end
    else
        return Message("Error", "Target is missing required parts.", 4)
    end
    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.CurrentCamera.CameraSubject = Humanoid
    if getgenv().OldPos then
        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
            Humanoid:ChangeState("GettingUp")
            for _, x in pairs(Character:GetChildren()) do
                if x:IsA("BasePart") then x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new() end
            end
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
    end
    workspace.FallenPartsDestroyHeight = -500
end

-- Connect button events
heaviestButton.MouseButton1Click:Connect(equipHeaviestTool)
unequipButton.MouseButton1Click:Connect(unequipAllTools)
poopButton.MouseButton1Click:Connect(togglePoopLoop)
oneClickSellButton.MouseButton1Click:Connect(sellInventoryOnce)
autoSellButton.MouseButton1Click:Connect(toggleSellLoop)

flingTargetButton.MouseButton1Click:Connect(function()
    local targetName = flingTargetBox.Text
    if targetName and targetName ~= "" then
        local targetPlayer = GetPlayer(targetName)
        if targetPlayer then
            Message("Flinging", "Attempting to fling " .. targetPlayer.Name, 3)
            SkidFling(targetPlayer)
        else
            Message("Error", "Player '" .. targetName .. "' not found.", 4)
        end
    else
        Message("Error", "Target name cannot be empty.", 4)
    end
end)