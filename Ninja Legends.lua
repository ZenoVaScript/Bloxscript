-- Bikini GUI - Ultimate Luxury Edition with Custom GUI
if game.PlaceId == 3956818381 then
    -- Clear existing GUI
    for _,v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v.Name == "BikiniHub" then
            v:Destroy()
        end
    end

    -- Create main GUI container
    local BikiniHub = Instance.new("ScreenGui")
    BikiniHub.Name = "BikiniHub"
    BikiniHub.Parent = game:GetService("CoreGui")
    BikiniHub.ResetOnSpawn = false

    -- Main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = BikiniHub

    -- Corner rounding
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Bikini Hub | Ultimate Edition"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Parent = TitleBar

    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.Parent = TitleBar

    CloseButton.MouseButton1Click:Connect(function()
        BikiniHub:Destroy()
    end)

    -- Resize button
    local ResizeButton = Instance.new("TextButton")
    ResizeButton.Name = "ResizeButton"
    ResizeButton.Size = UDim2.new(0, 30, 0, 30)
    ResizeButton.Position = UDim2.new(1, -60, 0, 0)
    ResizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    ResizeButton.BorderSizePixel = 0
    ResizeButton.Text = "◻"
    ResizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ResizeButton.Font = Enum.Font.GothamBold
    ResizeButton.TextSize = 14
    ResizeButton.Parent = TitleBar

    -- Tab buttons
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(0, 120, 1, -30)
    TabButtons.Position = UDim2.new(0, 0, 0, 30)
    TabButtons.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabButtons.BorderSizePixel = 0
    TabButtons.Parent = MainFrame

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabButtons

    -- Content frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, -120, 1, -30)
    ContentFrame.Position = UDim2.new(0, 120, 0, 30)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ClipsDescendants = true
    ContentFrame.Parent = MainFrame

    -- Tabs
    local Tabs = {
        "Autofarm",
        "Player",
        "Teleport",
        "Pets",
        "Misc"
    }

    local CurrentTab = nil
    local TabFrames = {}

    -- Create tabs
    for i, tabName in ipairs(Tabs) do
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName.."Tab"
        TabButton.Size = UDim2.new(1, -10, 0, 30)
        TabButton.Position = UDim2.new(0, 5, 0, (i-1)*35 + 5)
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        TabButton.BorderSizePixel = 0
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.Parent = TabButtons

        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = tabName.."Frame"
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Position = UDim2.new(0, 0, 0, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.ScrollBarThickness = 5
        TabFrame.Visible = false
        TabFrame.Parent = ContentFrame

        local TabLayout = Instance.new("UIListLayout")
        TabLayout.Padding = UDim.new(0, 5)
        TabLayout.Parent = TabFrame

        TabFrames[tabName] = TabFrame

        TabButton.MouseButton1Click:Connect(function()
            if CurrentTab then
                TabFrames[CurrentTab].Visible = false
            end
            CurrentTab = tabName
            TabFrames[tabName].Visible = true
        end)

        if i == 1 then
            CurrentTab = tabName
            TabFrames[tabName].Visible = true
        end
    end

    -- Resize functionality
    local isMinimized = false
    local originalSize = MainFrame.Size
    local originalPosition = MainFrame.Position

    ResizeButton.MouseButton1Click:Connect(function()
        if isMinimized then
            -- Restore
            MainFrame.Size = originalSize
            ResizeButton.Text = "◻"
            isMinimized = false
        else
            -- Minimize
            originalSize = MainFrame.Size
            originalPosition = MainFrame.Position
            MainFrame.Size = UDim2.new(0, 500, 0, 30)
            ResizeButton.Text = "⛶"
            isMinimized = true
        end
    end)

    -- Luxury color animation
    spawn(function()
        while wait(1) do
            for i = 0, 1, 0.01 do
                TitleBar.BackgroundColor3 = Color3.fromHSV(i, 0.7, 0.2)
                TabButtons.BackgroundColor3 = Color3.fromHSV(i, 0.7, 0.15)
                wait(0.05)
            end
        end
    end)

    -- Helper function to create sections
    local function CreateSection(parent, title)
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = title.."Section"
        SectionFrame.Size = UDim2.new(1, -20, 0, 0)
        SectionFrame.Position = UDim2.new(0, 10, 0, 0)
        SectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        SectionFrame.BorderSizePixel = 0
        SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
        SectionFrame.Parent = parent

        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 6)
        SectionCorner.Parent = SectionFrame

        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Name = "Title"
        SectionTitle.Size = UDim2.new(1, -10, 0, 25)
        SectionTitle.Position = UDim2.new(0, 10, 0, 5)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Text = title
        SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.TextSize = 14
        SectionTitle.Parent = SectionFrame

        local SectionLayout = Instance.new("UIListLayout")
        SectionLayout.Padding = UDim.new(0, 5)
        SectionLayout.Parent = SectionFrame

        local SectionPadding = Instance.new("UIPadding")
        SectionPadding.PaddingTop = UDim.new(0, 35)
        SectionPadding.PaddingLeft = UDim.new(0, 10)
        SectionPadding.PaddingRight = UDim.new(0, 10)
        SectionPadding.PaddingBottom = UDim.new(0, 10)
        SectionPadding.Parent = SectionFrame

        return SectionFrame
    end

    -- Helper function to create buttons
    local function CreateButton(parent, text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = text.."Button"
        Button.Size = UDim2.new(1, 0, 0, 30)
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        Button.BorderSizePixel = 0
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Font = Enum.Font.Gotham
        Button.TextSize = 14
        Button.Parent = parent

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = Button

        Button.MouseButton1Click:Connect(callback)

        return Button
    end

    -- Helper function to create toggles
    local function CreateToggle(parent, text, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = text.."Toggle"
        ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
        ToggleFrame.BackgroundTransparency = 1
        ToggleFrame.Parent = parent

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "Button"
        ToggleButton.Size = UDim2.new(1, 0, 1, 0)
        ToggleButton.BackgroundTransparency = 1
        ToggleButton.Text = ""
        ToggleButton.Parent = ToggleFrame

        local ToggleBox = Instance.new("Frame")
        ToggleBox.Name = "Box"
        ToggleBox.Size = UDim2.new(0, 20, 0, 20)
        ToggleBox.Position = UDim2.new(0, 0, 0.5, -10)
        ToggleBox.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 80)
        ToggleBox.BorderSizePixel = 0
        ToggleBox.Parent = ToggleFrame

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 4)
        ToggleCorner.Parent = ToggleBox

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Name = "Label"
        ToggleLabel.Size = UDim2.new(1, -25, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 25, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextSize = 14
        ToggleLabel.Parent = ToggleFrame

        local state = default

        ToggleButton.MouseButton1Click:Connect(function()
            state = not state
            ToggleBox.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 80)
            callback(state)
        end)

        return {
            Set = function(newState)
                state = newState
                ToggleBox.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 80)
                callback(state)
            end,
            Get = function()
                return state
            end
        }
    end

    -- Helper function to create sliders
    local function CreateSlider(parent, text, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = text.."Slider"
        SliderFrame.Size = UDim2.new(1, 0, 0, 50)
        SliderFrame.BackgroundTransparency = 1
        SliderFrame.Parent = parent

        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Name = "Label"
        SliderLabel.Size = UDim2.new(1, 0, 0, 20)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Text = text..": "..default
        SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.TextSize = 14
        SliderLabel.Parent = SliderFrame

        local SliderTrack = Instance.new("Frame")
        SliderTrack.Name = "Track"
        SliderTrack.Size = UDim2.new(1, 0, 0, 5)
        SliderTrack.Position = UDim2.new(0, 0, 0, 25)
        SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        SliderTrack.BorderSizePixel = 0
        SliderTrack.Parent = SliderFrame

        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(1, 0)
        SliderCorner.Parent = SliderTrack

        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "Fill"
        SliderFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderTrack

        local SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner.CornerRadius = UDim.new(1, 0)
        SliderFillCorner.Parent = SliderFill

        local SliderButton = Instance.new("TextButton")
        SliderButton.Name = "Button"
        SliderButton.Size = UDim2.new(0, 15, 0, 15)
        SliderButton.Position = UDim2.new((default - min)/(max - min), -7.5, 0.5, -7.5)
        SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderButton.BorderSizePixel = 0
        SliderButton.Text = ""
        SliderButton.Parent = SliderTrack

        local SliderButtonCorner = Instance.new("UICorner")
        SliderButtonCorner.CornerRadius = UDim.new(1, 0)
        SliderButtonCorner.Parent = SliderButton

        local dragging = false

        local function updateValue(input)
            local x = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
            x = math.clamp(x, 0, 1)
            local value = math.floor(min + (max - min) * x)
            SliderFill.Size = UDim2.new(x, 0, 1, 0)
            SliderButton.Position = UDim2.new(x, -7.5, 0.5, -7.5)
            SliderLabel.Text = text..": "..value
            callback(value)
        end

        SliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        SliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateValue(input)
            end
        end)

        SliderTrack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateValue(input)
            end
        end)

        return {
            Set = function(value)
                value = math.clamp(value, min, max)
                local x = (value - min)/(max - min)
                SliderFill.Size = UDim2.new(x, 0, 1, 0)
                SliderButton.Position = UDim2.new(x, -7.5, 0.5, -7.5)
                SliderLabel.Text = text..": "..value
                callback(value)
            end
        }
    end

    -- Helper function to create dropdowns
    local function CreateDropdown(parent, text, options, callback)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = text.."Dropdown"
        DropdownFrame.Size = UDim2.new(1, 0, 0, 30)
        DropdownFrame.BackgroundTransparency = 1
        DropdownFrame.Parent = parent

        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Name = "Button"
        DropdownButton.Size = UDim2.new(1, 0, 0, 30)
        DropdownButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        DropdownButton.BorderSizePixel = 0
        DropdownButton.Text = text
        DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownButton.Font = Enum.Font.Gotham
        DropdownButton.TextSize = 14
        DropdownButton.Parent = DropdownFrame

        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 4)
        DropdownCorner.Parent = DropdownButton

        local DropdownList = Instance.new("Frame")
        DropdownList.Name = "List"
        DropdownList.Size = UDim2.new(1, 0, 0, 0)
        DropdownList.Position = UDim2.new(0, 0, 0, 35)
        DropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        DropdownList.BorderSizePixel = 0
        DropdownList.Visible = false
        DropdownList.Parent = DropdownFrame

        local DropdownListCorner = Instance.new("UICorner")
        DropdownListCorner.CornerRadius = UDim.new(0, 4)
        DropdownListCorner.Parent = DropdownList

        local DropdownListLayout = Instance.new("UIListLayout")
        DropdownListLayout.Padding = UDim.new(0, 2)
        DropdownListLayout.Parent = DropdownList

        local isOpen = false

        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = option
            OptionButton.Size = UDim2.new(1, -10, 0, 25)
            OptionButton.Position = UDim2.new(0, 5, 0, (i-1)*27 + 5)
            OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            OptionButton.BorderSizePixel = 0
            OptionButton.Text = option
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            OptionButton.Font = Enum.Font.Gotham
            OptionButton.TextSize = 14
            OptionButton.Parent = DropdownList

            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = text..": "..option
                callback(option)
                DropdownList.Visible = false
                isOpen = false
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
            end)
        end

        DropdownButton.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            DropdownList.Visible = isOpen
            if isOpen then
                local count = #DropdownList:GetChildren() - 2 -- subtract layout and corner
                DropdownList.Size = UDim2.new(1, 0, 0, count * 27 + 10)
            else
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
            end
        end)

        return {
            Set = function(option)
                DropdownButton.Text = text..": "..option
                callback(option)
            end
        }
    end

    -- Notification function
    local function Notify(message)
        local Notification = Instance.new("Frame")
        Notification.Name = "Notification"
        Notification.Size = UDim2.new(0, 300, 0, 50)
        Notification.Position = UDim2.new(1, -310, 1, -60)
        Notification.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        Notification.BorderSizePixel = 0
        Notification.Parent = BikiniHub

        local NotificationCorner = Instance.new("UICorner")
        NotificationCorner.CornerRadius = UDim.new(0, 8)
        NotificationCorner.Parent = Notification

        local NotificationLabel = Instance.new("TextLabel")
        NotificationLabel.Name = "Label"
        NotificationLabel.Size = UDim2.new(1, -20, 1, -20)
        NotificationLabel.Position = UDim2.new(0, 10, 0, 10)
        NotificationLabel.BackgroundTransparency = 1
        NotificationLabel.Text = message
        NotificationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotificationLabel.Font = Enum.Font.Gotham
        NotificationLabel.TextSize = 14
        NotificationLabel.Parent = Notification

        spawn(function()
            wait(3)
            Notification:Destroy()
        end)
    end

    -- Variables
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local enabled = true

    -- Create tabs content
    -- Autofarm Tab
    local AutofarmTab = TabFrames["Autofarm"]
    local AutoFarmSection = CreateSection(AutofarmTab, "Main Autofarm")
    local AutoCoinSection = CreateSection(AutofarmTab, "Coin Farm")

    -- Player Tab
    local PlayerTab = TabFrames["Player"]
    local PlayerSection = CreateSection(PlayerTab, "Character Settings")
    local MovementSection = CreateSection(PlayerTab, "Movement")

    -- Teleport Tab
    local TeleportTab = TabFrames["Teleport"]
    local IslandSection = CreateSection(TeleportTab, "Islands")
    local TrainingSection = CreateSection(TeleportTab, "Training Areas")

    -- Pets Tab
    local PetsTab = TabFrames["Pets"]
    local CrystalsSection = CreateSection(PetsTab, "Crystals")
    local PetSellSection = CreateSection(PetsTab, "Auto Sell Pets")

    -- Misc Tab
    local MiscTab = TabFrames["Misc"]
    local UtilitySection = CreateSection(MiscTab, "Utilities")
    local UnlockSection = CreateSection(MiscTab, "Unlockers")

    -- Auto Farm Features
    local autoSwing = false
    CreateToggle(AutoFarmSection, "Auto Swing", false, function(state)
        autoSwing = state
        while autoSwing do
            for _,v in pairs(LocalPlayer.Backpack:GetChildren()) do
                if v:FindFirstChild("ninjitsuGain") then
                    Humanoid:EquipTool(v)
                    break
                end
            end
            LocalPlayer.ninjaEvent:FireServer("swingKatana")
            wait(0.1)
        end
    end)

    local autoSell = false
    CreateToggle(AutoFarmSection, "Auto Sell", false, function(state)
        autoSell = state
        while autoSell do
            local sellCircle = game:GetService("Workspace").sellAreaCircles["sellAreaCircle16"].circleInner
            sellCircle.CFrame = Character.HumanoidRootPart.CFrame
            wait(0.1)
            sellCircle.CFrame = CFrame.new(0,0,0)
            wait(0.1)
        end
    end)

    -- Auto Buy Features
    local ranks = {}
    for _,v in pairs(game:GetService("ReplicatedStorage").Ranks.Ground:GetChildren()) do
        table.insert(ranks, v.Name)
    end

    CreateToggle(AutoFarmSection, "Auto Buy Ranks", false, function(state)
        getgenv().autobuyranks = state
        while getgenv().autobuyranks do
            for _, rank in pairs(ranks) do
                LocalPlayer.ninjaEvent:FireServer("buyRank", rank)
            end
            wait(0.1)
        end
    end)

    CreateToggle(AutoFarmSection, "Auto Buy Belts", false, function(state)
        getgenv().autobuybelts = state
        while getgenv().autobuybelts do
            LocalPlayer.ninjaEvent:FireServer("buyAllBelts", "Inner Peace Island")
            wait(0.5)
        end
    end)

    CreateToggle(AutoFarmSection, "Auto Buy Skills", false, function(state)
        getgenv().autobuyskills = state
        while getgenv().autobuyskills do
            LocalPlayer.ninjaEvent:FireServer("buyAllSkills", "Inner Peace Island")
            wait(0.5)
        end
    end)

    -- Coin Farm System
    CreateToggle(AutoCoinSection, "Auto Coin Farm", false, function(state)
        enabled = state
        Notify("Auto Coin Farm "..(state and "ON" or "OFF"))
    end)

    -- Player Settings
    CreateSlider(PlayerSection, "WalkSpeed", 16, 500, 16, function(value)
        Humanoid.WalkSpeed = value
    end)

    CreateSlider(PlayerSection, "JumpPower", 50, 400, 50, function(value)
        Humanoid.JumpPower = value
    end)

    -- Movement Enhancements
    CreateToggle(MovementSection, "Infinite Jump", false, function(state)
        if state then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if enabled then
                    Humanoid:ChangeState("Jumping")
                end
            end)
        end
    end)

    CreateToggle(MovementSection, "NoClip", false, function(state)
        if state then
            game:GetService('RunService').Stepped:Connect(function()
                if enabled then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end)

    -- Teleport System
    local islands = {
        "Enchanted Island", "Astral Island", "Mystical Island", "Space Island", 
        "Tundra Island", "Eternal Island", "Sandstorm", "Thunderstorm",
        "Ancient Inferno Island", "Midnight Shadow Island", "Mythical Souls Island",
        "Winter Wonder Island", "Golden Master Island", "Dragon Legend Island"
    }

    CreateDropdown(IslandSection, "Teleport to Island", islands, function(selected)
        local island = game:GetService("Workspace").islandUnlockParts[selected]
        if island then
            Character.HumanoidRootPart.CFrame = island.CFrame
            Notify("Teleported to "..selected)
        end
    end)

    local trainingAreas = {
        "Mystical Waters", "Lava Pit", "Tornado", "Sword of Legends", 
        "Sword of Ancients", "Elemental Tornado", "Fallen Infinity Blade"
    }

    CreateDropdown(TrainingSection, "Teleport to Training", trainingAreas, function(selected)
        local root = Character.HumanoidRootPart
        if selected == "Mystical Waters" then
            root.CFrame = CFrame.new(343.93, 8824.41, 116.45)
        elseif selected == "Lava Pit" then
            root.CFrame = CFrame.new(-126.42, 12952.41, 273.15)
        elseif selected == "Tornado" then
            root.CFrame = CFrame.new(313.67, 16871.97, -14.72)
        elseif selected == "Sword of Legends" then
            root.CFrame = CFrame.new(1847.01, 38.58, -139.80)
        elseif selected == "Sword of Ancients" then
            root.CFrame = CFrame.new(608.70, 38.58, 2425.60)
        elseif selected == "Elemental Tornado" then
            root.CFrame = CFrame.new(323.20, 30382.97, 0.84)
        elseif selected == "Fallen Infinity Blade" then
            root.CFrame = CFrame.new(1883.16, 66.97, -6811.91)
        end
        Notify("Teleported to "..selected)
    end)

    -- Pet System
    local crystals = {}
    for _,v in pairs(game:GetService("Workspace").mapCrystalsFolder:GetChildren()) do
        if v:IsA("Model") then
            table.insert(crystals, v.Name)
        end
    end

    table.sort(crystals, function(a,b)
        return game:GetService("ReplicatedStorage").crystalPrices[a].price.Value < 
               game:GetService("ReplicatedStorage").crystalPrices[b].price.Value
    end)

    local selectedCrystal = nil
    local crystalDropdown = CreateDropdown(CrystalsSection, "Select Crystal", crystals, function(selected)
        selectedCrystal = selected
    end)

    CreateToggle(CrystalsSection, "Auto Open", false, function(state)
        getgenv().autoopencrystals = state
        while getgenv().autoopencrystals and selectedCrystal do
            game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer("openCrystal", selectedCrystal)
            wait(0.5)
        end
    end)

    -- Auto Sell Pets
    for _,v in pairs(LocalPlayer.petsFolder:GetChildren()) do
        CreateToggle(PetSellSection, "Sell "..v.Name, false, function(state)
            getgenv()["autosell"..v.Name] = state
            while getgenv()["autosell"..v.Name] do
                for _,pet in pairs(v:GetChildren()) do
                    game:GetService("ReplicatedStorage").rEvents.sellPetEvent:FireServer("sellPet", pet)
                end
                wait(0.1)
            end
        end)
    end

    -- Utilities
    CreateButton(UtilitySection, "Open Shop", function()
        local shop = game:GetService("Workspace").shopAreaCircles.shopAreaCircle19.circleInner
        shop.CFrame = Character.HumanoidRootPart.CFrame
        wait(0.4)
        shop.CFrame = CFrame.new(0,0,0)
    end)

    CreateButton(UtilitySection, "Infinite Jumps", function()
        LocalPlayer.multiJumpCount.Value = 999999999
        Notify("Enabled infinite jumps")
    end)

    CreateToggle(UtilitySection, "Toggle Popups", true, function(state)
        local gui = LocalPlayer.PlayerGui
        gui.statEffectsGui.Enabled = state
        gui.hoopGui.Enabled = state
    end)

    -- Unlockers
    CreateButton(UnlockSection, "Unlock Islands", function()
        for _,v in pairs(game:GetService("Workspace").islandUnlockParts:GetChildren()) do
            firetouchinterest(Character.HumanoidRootPart, v, 0)
            firetouchinterest(Character.HumanoidRootPart, v, 1)
            wait()
        end
    end)

    local elements = {}
    for _,v in pairs(game:GetService("ReplicatedStorage").Elements:GetChildren()) do
        table.insert(elements, v.Name)
    end

    CreateButton(UnlockSection, "Unlock Elements", function()
        for _,element in pairs(elements) do
            game.ReplicatedStorage.rEvents.elementMasteryEvent:FireServer(element)
            wait()
        end
    end)

    -- Keybinds and Toggles
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.L then
            enabled = not enabled
            Humanoid.WalkSpeed = enabled and 150 or 16
            Notify("Script "..(enabled and "ENABLED" or "DISABLED"))
        end
    end)

    -- Main loop
    spawn(function()
        while wait() do
            if enabled then
                -- Auto swing for coins
                for _,v in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if v:FindFirstChild("ninjitsuGain") then
                        Humanoid:EquipTool(v)
                        break
                    end
                end
                LocalPlayer.ninjaEvent:FireServer("swingKatana")
            end
        end
    end)

    Notify("Bikini Hub Loaded! Press L to toggle features")
end