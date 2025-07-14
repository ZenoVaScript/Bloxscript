-- Bikini GUI - Luxury Edition with Animations
if game.PlaceId == 3956818381 then
    -- Clear existing GUI
    for i,v in pairs(game:GetService("CoreGui"):GetChildren()) do
        if v:FindFirstChild("MainFrameHolder") or v:FindFirstChild("NotificationHolder") then
            v:Destroy()
            getgenv().autoopencrystals = false
            getgenv().autobuyranks = false
            getgenv().autobuybelts = false
            getgenv().autobuy = false
            getgenv().autobuyskills = false
            getgenv().autosell = false
            getgenv().autoswing = false
            getgenv().autosellpets = false
        end
    end

    -- Load luxury library with animations
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua"))()
    local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/ThemeManager.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/SaveManager.lua"))()

    local Window = Library:CreateWindow({
        Title = "Bikini Hub | Luxury Edition",
        Center = true,
        AutoShow = true,
        TabPadding = 8,
        MenuFadeTime = 0.2
    })

    -- Set luxury theme
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)

    -- Luxury color scheme
    local colors = {
        SchemeColor = Color3.fromRGB(230, 35, 69),
        Background = Color3.fromRGB(28, 28, 28),
        Header = Color3.fromRGB(20, 20, 20),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementBorder = Color3.fromRGB(50, 50, 50),
        ElementBg = Color3.fromRGB(35, 35, 35),
        ScrollBar = Color3.fromRGB(230, 35, 69)
    }

    -- Apply theme
    Library:SetWatermarkVisibility(true)
    Library:SetWatermark('Bikini Hub | Luxury Edition')
    Library:OnUnload(function()
        Library.Unloaded = true
    end)

    -- Initialize variables
    local Character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local PriceLabel
    local Price = nil
    local PriceType = nil
    local CrystalsList = {}
    local Selected = nil
    local enabled = true

    -- Create tabs with elegant animations
    local Main = Window:AddTab('Autofarm')
    local Egg = Window:AddTab('Pets')
    local Teleporting = Window:AddTab('Teleporting')
    local Player = Window:AddTab('LocalPlayer')
    local Misc = Window:AddTab('Misc')

    -- AutoCoin Farm Section (from your second script)
    local AutoCoin = Main:AddLeftGroupbox('Auto Coin Farm')
    
    AutoCoin:AddToggle('AutoCoinToggle', {
        Text = 'Enable Auto Coin Farm',
        Default = false,
        Tooltip = 'Automatically farms coins',
        Callback = function(value)
            enabled = value
            Library:Notify("Auto Coin Farm " .. (value and "enabled" or "disabled"), 3)
        end
    })
    
    AutoCoin:AddLabel('Press L to toggle'):AddColorPicker('ColorPicker', {
        Default = Color3.new(1, 1, 1),
        Title = 'Label Color',
        Callback = function(value)
            -- Color change callback
        end
    })

    -- Main autofarm functions
    local MainBox = Main:AddRightGroupbox('Main Autofarm')
    
    local ranks = {}
    for i,v in pairs(game:GetService("ReplicatedStorage").Ranks.Ground:GetChildren()) do
        table.insert(ranks, v.Name)
    end

    MainBox:AddToggle('AutoBuyRanks', {
        Text = 'Auto Buy All Ranks',
        Default = false,
        Tooltip = 'Automatically purchases all ranks',
        Callback = function(value)
            getgenv().autobuyranks = value
            while getgenv().autobuyranks and task.wait(0.1) do
                local deku1 = "buyRank"
                for i = 1, #ranks do
                    game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(deku1, ranks[i])
                end
            end
        end
    })

    MainBox:AddToggle('AutoBuyBelts', {
        Text = 'Auto Buy All Belts',
        Default = false,
        Tooltip = 'Automatically purchases all belts',
        Callback = function(value)
            getgenv().autobuybelts = value
            while getgenv().autobuybelts and task.wait(0.5) do
                local A_1 = "buyAllBelts"
                local A_2 = "Inner Peace Island"
                local Event = game:GetService("Players").LocalPlayer.ninjaEvent
                Event:FireServer(A_1, A_2)
            end
        end
    })

    MainBox:AddToggle('AutoBuySkills', {
        Text = 'Auto Buy All Skills',
        Default = false,
        Tooltip = 'Automatically purchases all skills',
        Callback = function(value)
            getgenv().autobuyskills = value
            while getgenv().autobuyskills and task.wait(0.5) do
                local A_1 = "buyAllSkills"
                local A_2 = "Inner Peace Island"
                local Event = game:GetService("Players").LocalPlayer.ninjaEvent
                Event:FireServer(A_1, A_2)
            end
        end
    })

    MainBox:AddToggle('AutoBuySwords', {
        Text = 'Auto Buy All Swords',
        Default = false,
        Tooltip = 'Automatically purchases all swords',
        Callback = function(value)
            getgenv().autobuy = value
            while getgenv().autobuy and task.wait(0.5) do
                local A_1 = "buyAllSwords"
                local A_2 = "Inner Peace Island"
                local Event = game:GetService("Players").LocalPlayer.ninjaEvent
                Event:FireServer(A_1, A_2)
            end
        end
    })

    MainBox:AddToggle('AutoSell', {
        Text = 'Auto Sell',
        Default = false,
        Tooltip = 'Automatically sells items',
        Callback = function(value)
            getgenv().autosell = value
            while getgenv().autosell and task.wait(0.1) do
                local sellCircle = game:GetService("Workspace").sellAreaCircles["sellAreaCircle16"].circleInner
                sellCircle.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                task.wait(0.1)
                sellCircle.CFrame = CFrame.new(0,0,0)
            end
        end
    })

    MainBox:AddToggle('AutoSwing', {
        Text = 'Auto Swing',
        Default = false,
        Tooltip = 'Automatically swings your sword',
        Callback = function(value)
            getgenv().autoswing = value
            while getgenv().autoswing and task.wait() do
                for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v:FindFirstChild("ninjitsuGain") then
                        game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):EquipTool(v)
                        break
                    end
                end
                game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("swingKatana")
            end
        end
    })

    -- Pets Section
    local EggBox = Egg:AddLeftGroupbox('Crystals')
    
    -- Populate crystals list
    for i,v in pairs(game:GetService("Workspace").mapCrystalsFolder:GetChildren()) do
        if v:IsA("Model") then
            table.insert(CrystalsList, v.Name)
        end
    end
    
    table.sort(CrystalsList, function(a,b)
        return game:GetService("ReplicatedStorage").crystalPrices[a].price.Value < game:GetService("ReplicatedStorage").crystalPrices[b].price.Value
    end)

    -- Crystal dropdown with elegant animation
    EggBox:AddDropdown('CrystalSelect', {
        Values = CrystalsList,
        Default = 1,
        Multi = false,
        Text = 'Select Crystal',
        Tooltip = 'Choose which crystal to open',
        Callback = function(value)
            pcall(function()
                local number = require(game:GetService("ReplicatedStorage").globalFunctions)
                Price = game:GetService("ReplicatedStorage").crystalPrices[value].price.Value
                PriceType = game:GetService("ReplicatedStorage").crystalPrices[value].priceType.Value
                EggBox:GetInstance('PriceLabel'):SetText("Crystal Price: "..tostring(number.shortenNumber(Price)).." "..tostring(PriceType))
                Selected = value
            end)
        end
    })

    EggBox:AddLabel('Crystal Price: NaN', true):SetTextSize(14)

    EggBox:AddButton('Open Once', function()
        if Selected == nil then return end
        local A_1 = "openCrystal"
        local Event = game:GetService("ReplicatedStorage").rEvents.openCrystalRemote
        Event:InvokeServer(A_1, Selected)
        Library:Notify("Opened "..Selected.." crystal", 2)
    end)

    EggBox:AddToggle('AutoOpenCrystals', {
        Text = 'Auto Open Crystals',
        Default = false,
        Tooltip = 'Automatically opens selected crystals',
        Callback = function(value)
            getgenv().autoopencrystals = value
            while getgenv().autoopencrystals and task.wait(0.5) do
                if Selected == nil then continue end
                local A_1 = "openCrystal"
                local Event = game:GetService("ReplicatedStorage").rEvents.openCrystalRemote
                Event:InvokeServer(A_1, Selected)
            end
        end
    })

    -- Auto sell pets section
    local PetSellBox = Egg:AddRightGroupbox('Auto Sell Pets')
    
    for i,v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetChildren()) do
        PetSellBox:AddToggle('AutoSell'..v.Name, {
            Text = 'Auto Sell: '..v.Name,
            Default = false,
            Tooltip = 'Automatically sells '..v.Name..' pets',
            Callback = function(value)
                getgenv().autosellpets = value
                while getgenv().autosellpets and task.wait(0.1) do
                    for z,val in pairs(v:GetChildren()) do
                        local A_1 = "sellPet"
                        local Event = game:GetService("ReplicatedStorage").rEvents.sellPetEvent
                        Event:FireServer(A_1, val)
                    end
                end
            end
        })
    end

    -- Player Section
    local PlayerBox = Player:AddLeftGroupbox('Character')
    
    PlayerBox:AddSlider('WalkSpeed', {
        Text = 'Walk Speed',
        Default = 16,
        Min = 16,
        Max = 500,
        Rounding = 1,
        Compact = false,
        Callback = function(value)
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = value
        end
    })

    PlayerBox:AddSlider('JumpPower', {
        Text = 'Jump Power',
        Default = 50,
        Min = 50,
        Max = 400,
        Rounding = 1,
        Compact = false,
        Callback = function(value)
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid").JumpPower = value
        end
    })

    -- Infinite Jump
    PlayerBox:AddToggle('InfiniteJump', {
        Text = 'Infinite Jump',
        Default = false,
        Tooltip = 'Allows infinite jumping',
        Callback = function(value)
            if value then
                game:GetService("UserInputService").JumpRequest:Connect(function()
                    if enabled then
                        Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                    end
                end)
            end
        end
    })

    -- NoClip
    PlayerBox:AddToggle('NoClip', {
        Text = 'NoClip',
        Default = false,
        Tooltip = 'Allows you to walk through objects',
        Callback = function(value)
            if value then
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
        end
    })

    -- Teleporting Section
    local TeleportBox = Teleporting:AddLeftGroupbox('Islands')
    
    local Islandslist = {
        "Enchanted Island", "Astral Island", "Mystical Island", "Space Island", "Tundra Island", 
        "Eternal Island", "Sandstorm", "Thunderstorm", "Ancient Inferno Island", "Midnight Shadow Island", 
        "Mythical Souls Island", "Winter Wonder Island", "Golden Master Island", "Dragon Legend Island", 
        "Cybernetic Legends Island", "Skystorm Ultraus Island", "Chaos Legends Island", "Soul Fusion Island", 
        "Dark Elements Island", "Inner Peace Island", "Blazing Vortex Island"
    }

    TeleportBox:AddDropdown('IslandSelect', {
        Values = Islandslist,
        Default = 1,
        Multi = false,
        Text = 'Teleport To Island',
        Tooltip = 'Teleport to selected island',
        Callback = function(value)
            pcall(function()
                if game:GetService("Workspace").islandUnlockParts:FindFirstChild(value) then
                    game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = 
                        game:GetService("Workspace").islandUnlockParts[value].CFrame
                    Library:Notify("Teleported to "..value, 2)
                end
            end)
        end
    })

    local TrainingBox = Teleporting:AddRightGroupbox('Training Areas')
    
    local TrainingList = {
        "Mystical Waters", "Lava Pit", "Tornado", "Sword of Legends", "Sword of Ancients", 
        "Elemental Tornado", "Fallen Infinity Blade", "Zen Master's Blade"
    }

    TrainingBox:AddDropdown('TrainingSelect', {
        Values = TrainingList,
        Default = 1,
        Multi = false,
        Text = 'Teleport To Training',
        Tooltip = 'Teleport to selected training area',
        Callback = function(value)
            pcall(function()
                local root = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                if value == "Mystical Waters" then
                    root.CFrame = CFrame.new(343.933624, 8824.41309, 116.454231)
                elseif value == "Lava Pit" then
                    root.CFrame = CFrame.new(-126.416206, 12952.4131, 273.149292)
                elseif value == "Tornado" then
                    root.CFrame = CFrame.new(313.673065, 16871.9688, -14.7217541)
                elseif value == "Sword of Legends" then
                    root.CFrame = CFrame.new(1847.01306, 38.5793152, -139.799545)
                elseif value == "Sword of Ancients" then
                    root.CFrame = CFrame.new(608.698364, 38.5796623, 2425.60474)
                elseif value == "Elemental Tornado" then
                    root.CFrame = CFrame.new(323.196381, 30382.9707, 0.835642278)
                elseif value == "Fallen Infinity Blade" then
                    root.CFrame = CFrame.new(1883.16479, 66.9705124, -6811.90771)
                elseif value == "Zen Master's Blade" then
                    root.CFrame = CFrame.new()
                end
                Library:Notify("Teleported to "..value, 2)
            end)
        end
    })

    -- Misc Section
    local MiscBox = Misc:AddLeftGroupbox('Utilities')
    
    MiscBox:AddButton('Open Shop', function()
        local shop = game:GetService("Workspace").shopAreaCircles.shopAreaCircle19.circleInner
        local root = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        shop.CFrame = root.CFrame
        task.wait(0.4)
        shop.CFrame = CFrame.new(0,0,0)
        Library:Notify("Opened shop", 2)
    end)

    MiscBox:AddButton('Infinite Double Jumps', function()
        game.Players.LocalPlayer.multiJumpCount.Value = 999999999
        Library:Notify("Enabled infinite double jumps", 2)
    end)

    MiscBox:AddButton('Unlock all Islands', function()
        local root = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        for _,v in pairs(game:GetService("Workspace").islandUnlockParts:GetChildren()) do
            firetouchinterest(root, v, 0)
            firetouchinterest(root, v, 1)
            task.wait()
        end
        Library:Notify("Unlocked all islands", 2)
    end)

    local Elements = {}
    for i,v in pairs(game:GetService("ReplicatedStorage").Elements:GetChildren()) do
        table.insert(Elements, v.Name)
    end

    MiscBox:AddButton('Unlock all Elements', function()
        for i,v in pairs(Elements) do
            game.ReplicatedStorage.rEvents.elementMasteryEvent:FireServer(v)
            task.wait()
        end
        Library:Notify("Unlocked all elements", 2)
    end)

    MiscBox:AddButton('Open All Chests', function()
        for i, v in pairs(Workspace:GetChildren()) do
            if v:FindFirstChild("Chest") and v:FindFirstChild("circleInner") and v.circleInner:FindFirstChildWhichIsA("TouchTransmitter") then
                local Transmitter = v.circleInner:FindFirstChildWhichIsA("TouchTransmitter")
                firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), Transmitter.Parent, 0)
                task.wait()
                firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"), Transmitter.Parent, 1)
                task.wait(5)
            end
        end
        Library:Notify("Opened all chests", 2)
    end)

    MiscBox:AddButton('Collect all Hoops', function()
        for i,v in pairs(game:GetService("Workspace").Hoops:GetChildren()) do
            if v:IsA("MeshPart") and v:FindFirstChild("touchPart") then
                v.touchPart.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
                task.wait(0.25)
                v.touchPart.CFrame = CFrame.new(0,0,0)
            end
        end
        Library:Notify("Collected all hoops", 2)
    end)

    MiscBox:AddToggle('Toggle Popups', {
        Text = 'Toggle Popups',
        Default = true,
        Tooltip = 'Toggle stat and hoop popups',
        Callback = function(value)
            local gui = game:GetService("Players").LocalPlayer.PlayerGui
            gui.statEffectsGui.Enabled = value
            gui.hoopGui.Enabled = value
        end
    })

    -- Keybind to toggle script
    Library:SetWatermarkVisibility(true)
    Library.KeybindFrame.Visible = true;
    Library:OnUnload(function()
        print('Unloaded!')
        Library.Unloaded = true
    end)

    local MenuGroup = Window:AddTab('UI Settings')
    local MenuBox = MenuGroup:AddLeftGroupbox('Menu')
    
    MenuBox:AddButton('Unload', function() Library:Unload() end)
    MenuBox:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { 
        Default = 'RightShift', 
        NoUI = true, 
        Text = 'Menu keybind' 
    })

    Library.ToggleKeybind = Options.MenuKeybind
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
    ThemeManager:SetFolder('BikiniHub')
    SaveManager:SetFolder('BikiniHub/specific-game')
    SaveManager:BuildConfigSection(MenuGroup)
    ThemeManager:ApplyToTab(MenuGroup)

    -- Main loop for Auto Coin Farm
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.L then
            enabled = not enabled
            Library:Notify("Script toggled " .. (enabled and "on" or "off"), 2)
        end
    end)

    spawn(function()
        while task.wait() do
            if enabled then
                -- Auto swing for coins
                for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if v:FindFirstChild("ninjitsuGain") then
                        game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):EquipTool(v)
                        break
                    end
                end
                game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("swingKatana")
                
                -- WalkSpeed adjustment                Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 150
            else
                Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
        end
    end)
end