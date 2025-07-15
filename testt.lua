local G2L = {}

if not isfolder("Koronis") then
    makefolder("Koronis")
end

-- Key Module (replaced loadstring with direct implementation)
local KeyModule = {
    IDs = {
        ["Universal"] = "baf0792f6cce01ba2040d6bf52996eb8",
        [8884433153] = "2f3e1443b79ad9ca4c483dcf537d4288",
        [142823291] = "715b720f239e20ee194665e05b77ad6e",
        [73801682582529] = "fe3a3d936137408a4f153979276d1416",
        [84759971088447] = "fe3a3d936137408a4f153979276d1416",
        [126884695634066] = "c20cd2b9eb243faf8a3884d9ea459bf1",
        [606849621] = "764d9f1b4b09fec218950bcdf95b8cc2",
        [121154762177314] = "90623d08618a93383a67f543e84da5dc",
        [81440632616906] = "24436993afc067cac69ff4e3c0bce3a8",
        [101949297449238] = "d0fe3a812ac0aaf27e6b7cb94350d9a2"
    },
    Notify = nil
}

KeyModule.ScriptID = KeyModule.IDs[game.PlaceId] or KeyModule.IDs.Universal

-- API implementation (simplified version of what would be in the library)
local API = {
    script_id = KeyModule.ScriptID,
    check_key = function(key)
        -- This is a simplified version - real implementation would make HTTP requests
        if string.match(key, "^%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x$") then
            return {
                code = "KEY_VALID",
                message = "Key is valid",
                script = "Koronis Hub"
            }
        else
            return {
                code = "KEY_INVALID",
                message = "Invalid key format"
            }
        end
    end,
    load_script = function()
        -- This would normally load the actual script
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Koronis",
            Text = "Script loaded successfully!",
            Duration = 5
        })
    end
}

KeyModule.api = API
KeyModule.Functions = {
    CheckKey = function(Key)
        local status = KeyModule.api.check_key(Key)
        if status.code == "KEY_VALID" then
            script_key = Key
            return {STATUS=status, API=KeyModule.api, KEYSCRIPT=script}
        else
            if KeyModule.Notify ~= nil then
                KeyModule.Notify("Error", status.message, 5)
            end
            return {STATUS=status, API=KeyModule.api, KEYSCRIPT=script}
        end
    end
}

-- Key System GUI
local keyFile
if not isfile("Koronis/key.txt") then
    writefile("Koronis/key.txt", "")
    keyFile = readfile("Koronis/key.txt")
else
    keyFile = readfile("Koronis/key.txt")
    local response = KeyModule.Functions.CheckKey(keyFile)
    if response.STATUS.code == "KEY_VALID" then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Found User",
            Text = "Key Found, Loading Koronis...",
            Duration = 5
        })
        script_key = keyFile
        response.API.load_script()
        return
    end
end

local kSpoof = game:GetService("HttpService"):GenerateGUID(false)
local KORONIS_SAVEKEY = false

-- Create the GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = kSpoof
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game:GetService("CoreGui")

-- Notification Holder
local notificationHolder = Instance.new("Frame")
notificationHolder.BorderSizePixel = 0
notificationHolder.BackgroundTransparency = 1
notificationHolder.AnchorPoint = Vector2.new(0.5, 1)
notificationHolder.Size = UDim2.new(0.54102, 0, 0.17284, 0)
notificationHolder.Position = UDim2.new(0.5, 0, 0.85, 0)
notificationHolder.Name = "NotificationHolder"
notificationHolder.ZIndex = 999
notificationHolder.Parent = screenGui

local uiListLayout = Instance.new("UIListLayout", notificationHolder)
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local uiPadding = Instance.new("UIPadding", notificationHolder)
uiPadding.PaddingTop = UDim.new(0, 3)
uiPadding.PaddingRight = UDim.new(0, 3)
uiPadding.PaddingLeft = UDim.new(0, 3)
uiPadding.PaddingBottom = UDim.new(0, 3)

-- Assets Folder
local assetsFolder = Instance.new("Folder", screenGui)
assetsFolder.Name = "Assets"

-- Notification Template
local notificationTemplate = Instance.new("TextLabel", assetsFolder)
notificationTemplate.TextWrapped = true
notificationTemplate.BorderSizePixel = 0
notificationTemplate.TextSize = 14
notificationTemplate.TextScaled = true
notificationTemplate.BackgroundTransparency = 1
notificationTemplate.Font = Enum.Font.GothamSSm
notificationTemplate.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
notificationTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
notificationTemplate.RichText = true
notificationTemplate.Size = UDim2.new(0.02181, 0, 0.27911, 0)
notificationTemplate.Visible = false
notificationTemplate.Text = "Notification Text!"
notificationTemplate.AutomaticSize = Enum.AutomaticSize.X
notificationTemplate.Name = "NotificationTemplate"
notificationTemplate.Position = UDim2.new(0.45718, 0, 0.36044, 0)

local uiStroke = Instance.new("UIStroke", notificationTemplate)
uiStroke.Thickness = 2

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Size = UDim2.new(0, 350, 0, 225)
mainFrame.Position = UDim2.new(0.5, 0, 0.4992, 0)

local uiCorner = Instance.new("UICorner", mainFrame)
local mainUIStroke = Instance.new("UIStroke", mainFrame)
mainUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainUIStroke.Thickness = 3
mainUIStroke.Color = Color3.fromRGB(50, 50, 50)

-- Discord Button
local discordButton = Instance.new("TextButton", mainFrame)
discordButton.BorderSizePixel = 0
discordButton.Text = ""
discordButton.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
discordButton.AnchorPoint = Vector2.new(0.5, 0.5)
discordButton.Size = UDim2.new(0, 45, 0, 45)
discordButton.Name = "DISCORD"
discordButton.Position = UDim2.new(0.11143, 0, 0.82889, 0)

local discordCorner = Instance.new("UICorner", discordButton)
local discordStroke = Instance.new("UIStroke", discordButton)
discordStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
discordStroke.Thickness = 3
discordStroke.Color = Color3.fromRGB(51, 51, 51)

local discordImage = Instance.new("ImageLabel", discordButton)
discordImage.BorderSizePixel = 0
discordImage.BackgroundTransparency = 1
discordImage.ScaleType = Enum.ScaleType.Fit
discordImage.ImageTransparency = 0.06
discordImage.Image = "rbxassetid://745203704"
discordImage.Size = UDim2.new(0.75, 0, 0.75, 0)
discordImage.Position = UDim2.new(0.11111, 0, 0.11111, 0)

-- Key TextBox
local keyTextBox = Instance.new("TextBox", mainFrame)
keyTextBox.CursorPosition = -1
keyTextBox.BorderSizePixel = 0
keyTextBox.TextWrapped = true
keyTextBox.TextSize = 14
keyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTextBox.TextScaled = true
keyTextBox.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
keyTextBox.Font = Enum.Font.SourceSans
keyTextBox.AnchorPoint = Vector2.new(0.5, 0.5)
keyTextBox.PlaceholderText = "Enter Key..."
keyTextBox.Size = UDim2.new(0, 200, 0, 35)
keyTextBox.Position = UDim2.new(0.5, 0, 0.4, 0)
keyTextBox.Text = ""

local textBoxStroke = Instance.new("UIStroke", keyTextBox)
textBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
textBoxStroke.Thickness = 3
textBoxStroke.Color = Color3.fromRGB(50, 50, 50)

local textBoxCorner = Instance.new("UICorner", keyTextBox)
local textSizeConstraint = Instance.new("UITextSizeConstraint", keyTextBox)
textSizeConstraint.MaxTextSize = 20

-- Title Label
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.TextWrapped = true
titleLabel.BorderSizePixel = 0
titleLabel.TextSize = 14
titleLabel.TextScaled = true
titleLabel.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
titleLabel.Font = Enum.Font.GothamSSm
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)
titleLabel.Size = UDim2.new(0, 200, 0, 34)
titleLabel.Text = "Koronis Hub"
titleLabel.Position = UDim2.new(0.5, 0, 0.12, 0)

local titlePadding = Instance.new("UIPadding", titleLabel)
titlePadding.PaddingTop = UDim.new(0, 5)
titlePadding.PaddingRight = UDim.new(0, 5)
titlePadding.PaddingLeft = UDim.new(0, 5)
titlePadding.PaddingBottom = UDim.new(0, 5)

local titleCorner = Instance.new("UICorner", titleLabel)
local titleStroke = Instance.new("UIStroke", titleLabel)
titleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
titleStroke.Thickness = 3
titleStroke.Color = Color3.fromRGB(50, 50, 50)

local titleTextConstraint = Instance.new("UITextSizeConstraint", titleLabel)
titleTextConstraint.MaxTextSize = 20

-- Remember Key Label
local rememberLabel = Instance.new("TextLabel", mainFrame)
rememberLabel.TextWrapped = true
rememberLabel.BorderSizePixel = 0
rememberLabel.TextSize = 14
rememberLabel.TextXAlignment = Enum.TextXAlignment.Right
rememberLabel.TextScaled = true
rememberLabel.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
rememberLabel.Font = Enum.Font.GothamSSm
rememberLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
rememberLabel.BackgroundTransparency = 1
rememberLabel.AnchorPoint = Vector2.new(0.5, 0.5)
rememberLabel.Size = UDim2.new(0, 153, 0, 25)
rememberLabel.Text = "Remember Key?"
rememberLabel.Name = "remember"
rememberLabel.Position = UDim2.new(0.43286, 0, 0.59778, 0)

local rememberPadding = Instance.new("UIPadding", rememberLabel)
rememberPadding.PaddingTop = UDim.new(0, 5)
rememberPadding.PaddingRight = UDim.new(0, 5)
rememberPadding.PaddingLeft = UDim.new(0, 5)
rememberPadding.PaddingBottom = UDim.new(0, 5)

local rememberCorner = Instance.new("UICorner", rememberLabel)
local rememberTextConstraint = Instance.new("UITextSizeConstraint", rememberLabel)
rememberTextConstraint.MaxTextSize = 20

-- Submit Button
local submitButton = Instance.new("TextButton", mainFrame)
submitButton.TextWrapped = true
submitButton.BorderSizePixel = 0
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.TextSize = 14
submitButton.TextScaled = true
submitButton.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
submitButton.Font = Enum.Font.GothamSSm
submitButton.AnchorPoint = Vector2.new(0.5, 0.5)
submitButton.Size = UDim2.new(0, 158, 0, 45)
submitButton.Name = "SUBMIT"
submitButton.Text = "Submit"
submitButton.Position = UDim2.new(0.5, 0, 0.83111, 0)

local submitCorner = Instance.new("UICorner", submitButton)
local submitStroke = Instance.new("UIStroke", submitButton)
submitStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
submitStroke.Thickness = 3
submitStroke.Color = Color3.fromRGB(51, 51, 51)

local submitStroke2 = Instance.new("UIStroke", submitButton)
submitStroke2.Thickness = 3

local submitTextConstraint = Instance.new("UITextSizeConstraint", submitButton)
submitTextConstraint.MaxTextSize = 30

-- Save Login Button
local saveLoginButton = Instance.new("TextButton", mainFrame)
saveLoginButton.TextWrapped = true
saveLoginButton.BorderSizePixel = 0
saveLoginButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveLoginButton.TextSize = 14
saveLoginButton.TextScaled = true
saveLoginButton.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
saveLoginButton.Font = Enum.Font.GothamSSm
saveLoginButton.AnchorPoint = Vector2.new(0.5, 0.5)
saveLoginButton.Size = UDim2.new(0, 40, 0, 40)
saveLoginButton.Name = "SAVE_LOGIN"
saveLoginButton.Text = ""
saveLoginButton.Position = UDim2.new(0.72714, 0, 0.59556, 0)

local uncheckImage = Instance.new("ImageLabel", saveLoginButton)
uncheckImage.BorderSizePixel = 0
uncheckImage.BackgroundTransparency = 1
uncheckImage.Image = "rbxassetid://4458801905"
uncheckImage.Size = UDim2.new(1, 0, 1, 0)
uncheckImage.Name = "uncheck"

local checkImage = Instance.new("ImageLabel", saveLoginButton)
checkImage.BorderSizePixel = 0
checkImage.BackgroundTransparency = 1
checkImage.ImageTransparency = 1
checkImage.Image = "rbxassetid://4458804262"
checkImage.Size = UDim2.new(1, 0, 1, 0)
checkImage.Name = "check"

-- Copy Key Button
local copyKeyButton = Instance.new("TextButton", mainFrame)
copyKeyButton.TextWrapped = true
copyKeyButton.BorderSizePixel = 0
copyKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyKeyButton.TextSize = 14
copyKeyButton.TextScaled = true
copyKeyButton.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
copyKeyButton.Font = Enum.Font.GothamSSm
copyKeyButton.AnchorPoint = Vector2.new(0.5, 0.5)
copyKeyButton.Size = UDim2.new(0, 59, 0, 35)
copyKeyButton.Name = "COPY_KEY"
copyKeyButton.Text = "Get Key"
copyKeyButton.Position = UDim2.new(0.89857, 0, 0.4, 0)

local copyKeyCorner = Instance.new("UICorner", copyKeyButton)
local copyKeyStroke = Instance.new("UIStroke", copyKeyButton)
copyKeyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
copyKeyStroke.Thickness = 3
copyKeyStroke.Color = Color3.fromRGB(51, 51, 51)

local copyKeyStroke2 = Instance.new("UIStroke", copyKeyButton)
copyKeyStroke2.Thickness = 3

local copyKeyTextConstraint = Instance.new("UITextSizeConstraint", copyKeyButton)
copyKeyTextConstraint.MaxTextSize = 20

local copyKeyPadding = Instance.new("UIPadding", copyKeyButton)
copyKeyPadding.PaddingTop = UDim.new(0, 5)
copyKeyPadding.PaddingRight = UDim.new(0, 5)
copyKeyPadding.PaddingLeft = UDim.new(0, 5)
copyKeyPadding.PaddingBottom = UDim.new(0, 5)

-- Close Button
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.TextWrapped = true
closeButton.BorderSizePixel = 0
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.TextScaled = true
closeButton.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
closeButton.Font = Enum.Font.GothamSSm
closeButton.AnchorPoint = Vector2.new(0.5, 0.5)
closeButton.Size = UDim2.new(0, 34, 0, 35)
closeButton.Name = "CLOSE"
closeButton.Text = "X"
closeButton.Position = UDim2.new(0.93429, 0, 0.12, 0)

local closeCorner = Instance.new("UICorner", closeButton)
local closeStroke = Instance.new("UIStroke", closeButton)
closeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
closeStroke.Thickness = 3
closeStroke.Color = Color3.fromRGB(51, 51, 51)

local closeStroke2 = Instance.new("UIStroke", closeButton)
closeStroke2.Thickness = 3

local closeTextConstraint = Instance.new("UITextSizeConstraint", closeButton)
closeTextConstraint.MaxTextSize = 20

local closePadding = Instance.new("UIPadding", closeButton)
closePadding.PaddingTop = UDim.new(0, 5)
closePadding.PaddingRight = UDim.new(0, 5)
closePadding.PaddingLeft = UDim.new(0, 5)
closePadding.PaddingBottom = UDim.new(0, 5)

-- Notification Function
local function sendNotification(message, duration)
    task.spawn(function()
        local notification = notificationTemplate:Clone()
        notification.Text = message
        notification.Parent = notificationHolder
        notification.Visible = true
        
        notification:TweenSize(
            UDim2.new(
                notification.Size.X.Scale,
                notification.Size.X.Offset,
                notification.Size.Y.Scale,
                notification.Size.Y.Offset + 6
            ),
            Enum.EasingDirection.InOut,
            Enum.EasingStyle.Sine,
            0.25,
            true,
            function()
                notification:TweenSize(
                    UDim2.new(
                        notification.Size.X.Scale,
                        notification.Size.X.Offset,
                        notification.Size.Y.Scale,
                        notification.Size.Y.Offset - 6
                    ),
                    Enum.EasingDirection.InOut,
                    Enum.EasingStyle.Sine,
                    0.25,
                    true
                )
            end
        )
        
        task.wait(duration or 5)
        notification:Destroy()
    end)
end

-- Button Animations
local function setupButtonAnimations(button)
    local oldSize = button.Size
    
    local function scaled(scaleFactor)
        return UDim2.new(
            oldSize.X.Scale/scaleFactor,
            oldSize.X.Offset/scaleFactor,
            oldSize.Y.Scale/scaleFactor,
            oldSize.Y.Offset/scaleFactor
        )
    end
    
    button.MouseEnter:Connect(function()
        button:TweenSize(scaled(1.25), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.15, true)
    end)
    
    button.MouseLeave:Connect(function()
        button:TweenSize(oldSize, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.15, true)
    end)
    
    button.MouseButton1Down:Connect(function()
        button:TweenSize(scaled(1.35), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.15, true)
    end)
    
    button.MouseButton1Up:Connect(function()
        button:TweenSize(scaled(1.25), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.15, true)
    end)
end

-- Button Functionality
setupButtonAnimations(discordButton)
discordButton.Activated:Connect(function()
    if setclipboard then 
        setclipboard("https://discord.gg/koronis")
    end
    sendNotification("Koronis has been copied to your clipboard!")
end)

setupButtonAnimations(submitButton)
submitButton.Activated:Connect(function()
    local response = KeyModule.Functions.CheckKey(keyTextBox.Text)
    if response.STATUS.code == "KEY_VALID" then
        if KORONIS_SAVEKEY then
            writefile("Koronis/key.txt", keyTextBox.Text)
        end
        script_key = keyTextBox.Text
        response.API.load_script()
        sendNotification("Loading Koronis!")
        screenGui:Destroy()
    elseif response.STATUS.code == "KEY_HWID_LOCKED" then
        sendNotification("Your HWID must be reset, please join the discord or get a new key!")
    elseif response.STATUS.code == "KEY_INVALID" then
        sendNotification("Uh oh, it looks like this key might be expired or invalid!")	
    end
end)

setupButtonAnimations(copyKeyButton)
copyKeyButton.Activated:Connect(function()
    if setclipboard then 
        setclipboard("https://koronis.xyz/get-key/")
    end
    sendNotification("Key link has been copied to your clipboard!")
end)

setupButtonAnimations(closeButton)
closeButton.Activated:Connect(function()
    screenGui:Destroy()
end)

setupButtonAnimations(saveLoginButton)
saveLoginButton.Activated:Connect(function()
    KORONIS_SAVEKEY = not KORONIS_SAVEKEY
    
    if KORONIS_SAVEKEY then
        sendNotification("Key will be remembered on next login!")
        game:GetService("TweenService"):Create(checkImage, TweenInfo.new(1), {ImageTransparency = 0}):Play()
    else
        sendNotification("Key will no longer be remembered on next login!")
        game:GetService("TweenService"):Create(checkImage, TweenInfo.new(1), {ImageTransparency = 1}):Play()
    end
end)