-- pelimen hub v1.2 (Zaključana verzija sa efektima i P dugmetom)

local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local sg = game:GetService("StarterGui")

local SETTINGS = {
    KingMode = false,
    InfiniteJump = false,
    Noclip = false,
    ESP = false,
    AntiStun = false
}

local UNLOCKED = false
local CORRECT_KEY = "062965"
local KEY_LINK = "https://rekonise.com/steal-a-brainrot-script-key-1dmhf"

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PelimenGui"

-- Dugme P
local iconBtn = Instance.new("TextButton", gui)
iconBtn.Size = UDim2.new(0, 50, 0, 50)
iconBtn.Position = UDim2.new(0, 10, 0, 10)
iconBtn.Text = "P"
iconBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
iconBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
iconBtn.Font = Enum.Font.Fantasy
iconBtn.TextSize = 30
iconBtn.AutoButtonColor = false
iconBtn.BorderSizePixel = 0
iconBtn.BackgroundTransparency = 0.1
Instance.new("UICorner", iconBtn).CornerRadius = UDim.new(0, 12)

-- Frame za unos ključa
local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.new(0, 260, 0, 150)
keyFrame.Position = UDim2.new(0, 70, 0, 10)
keyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
keyFrame.Visible = true
keyFrame.Active = true
keyFrame.Draggable = true
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 10)

local keyLabel = Instance.new("TextLabel", keyFrame)
keyLabel.Size = UDim2.new(1, 0, 0, 30)
keyLabel.Text = "Enter Key to Unlock"
keyLabel.TextColor3 = Color3.new(1, 1, 1)
keyLabel.Font = Enum.Font.SourceSansBold
keyLabel.TextSize = 20

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0, 200, 0, 30)
keyBox.Position = UDim2.new(0, 30, 0, 50)
keyBox.PlaceholderText = "Paste Key Here"
keyBox.Font = Enum.Font.SourceSans
keyBox.TextSize = 18
keyBox.Text = ""
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local submitBtn = Instance.new("TextButton", keyFrame)
submitBtn.Size = UDim2.new(0, 100, 0, 30)
submitBtn.Position = UDim2.new(0, 80, 0, 90)
submitBtn.Text = "Unlock"
submitBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
submitBtn.TextColor3 = Color3.new(1, 1, 1)
submitBtn.Font = Enum.Font.SourceSansBold
submitBtn.TextSize = 18

local getKeyBtn = Instance.new("TextButton", keyFrame)
getKeyBtn.Size = UDim2.new(0, 100, 0, 20)
getKeyBtn.Position = UDim2.new(0.5, -50, 1, -25)
getKeyBtn.Text = "Get Key"
getKeyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
getKeyBtn.TextColor3 = Color3.new(1, 1, 1)
getKeyBtn.Font = Enum.Font.SourceSans
getKeyBtn.TextSize = 14

getKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(KEY_LINK)
end)

submitBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == CORRECT_KEY then
        UNLOCKED = true
        keyFrame.Visible = false
        frame.Visible = true
    else
        keyBox.Text = "Wrong Key!"
    end
end)

-- Glavni meni
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 280)
frame.Position = UDim2.new(0, 70, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Pelimen Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 180, 0, 30)
closeBtn.Position = UDim2.new(0, 10, 1, -40)
closeBtn.Text = "Close GUI"
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local website = Instance.new("TextLabel", frame)
website.Size = UDim2.new(1, 0, 0, 20)
website.Position = UDim2.new(0, 0, 1, -20)
website.Text = "pelimen.com"
website.TextColor3 = Color3.new(1, 1, 1)
website.BackgroundTransparency = 1
website.Font = Enum.Font.SourceSansItalic
website.TextSize = 14

-- Toggle dugmad
local function createToggle(text, key, posX, posY)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Text = text .. ": OFF"

    btn.MouseButton1Click:Connect(function()
        SETTINGS[key] = not SETTINGS[key]
        btn.Text = text .. ": " .. (SETTINGS[key] and "ON" or "OFF")
    end)
end

-- Funkcionalna dugmad
createToggle("King Mode", "KingMode", 10, 40)
createToggle("Infinite Jump", "InfiniteJump", 10, 80)
createToggle("Noclip", "Noclip", 10, 120)
createToggle("ESP", "ESP", 10, 160)
createToggle("Anti Stun", "AntiStun", 10, 200)

-- Link dugmad
local ytBtn = Instance.new("TextButton", frame)
ytBtn.Size = UDim2.new(0, 180, 0, 30)
ytBtn.Position = UDim2.new(0, 210, 0, 40)
ytBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ytBtn.Text = "YouTube"
ytBtn.TextColor3 = Color3.new(1, 1, 1)
ytBtn.Font = Enum.Font.SourceSansBold
ytBtn.TextSize = 18
ytBtn.MouseButton1Click:Connect(function()
    setclipboard("https://youtube.com/@pelimenmod?si=Ot5eX7-2OP65md1f")
    sg:SetCore("SendNotification", {
        Title = "Copied!",
        Text = "YouTube link copied to clipboard!",
        Duration = 3
    })
end)

local siteBtn = Instance.new("TextButton", frame)
siteBtn.Size = UDim2.new(0, 180, 0, 30)
siteBtn.Position = UDim2.new(0, 210, 0, 80)
siteBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
siteBtn.Text = "All Scripts"
siteBtn.TextColor3 = Color3.new(1, 1, 1)
siteBtn.Font = Enum.Font.SourceSansBold
siteBtn.TextSize = 18
siteBtn.MouseButton1Click:Connect(function()
    setclipboard("https://pelimen.com")
    sg:SetCore("SendNotification", {
        Title = "Copied!",
        Text = "Website link copied to clipboard!",
        Duration = 3
    })
end)

-- GUI toggle
local menuVisible = false
iconBtn.MouseButton1Click:Connect(function()
    if not UNLOCKED then
        keyFrame.Visible = not keyFrame.Visible
    else
        menuVisible = not menuVisible
        frame.Visible = menuVisible
    end
end)

-- Funckije
run.RenderStepped:Connect(function()
    if UNLOCKED and SETTINGS.KingMode and plr.Character then
        local hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
        if hum and hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
            hum.PlatformStand = false
            hum.Sit = false
        end
    end
end)

uis.JumpRequest:Connect(function()
    if UNLOCKED and SETTINGS.InfiniteJump then
        local hum = plr.Character and plr.Character:FindFirstChildWhichIsA("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

run.Stepped:Connect(function()
    if UNLOCKED and SETTINGS.Noclip and plr.Character then
        for _, v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

run.RenderStepped:Connect(function()
    if UNLOCKED then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= plr and p.Character then
                local hasESP = p.Character:FindFirstChild("PelimenESP")
                if SETTINGS.ESP and not hasESP then
                    local esp = Instance.new("Highlight", p.Character)
                    esp.Name = "PelimenESP"
                    esp.FillColor = Color3.fromRGB(255, 0, 0)
                    esp.OutlineColor = Color3.fromRGB(255, 255, 255)
                elseif not SETTINGS.ESP and hasESP then
                    hasESP:Destroy()
                end
            end
        end
    end
end)

-- AntiStun
run.RenderStepped:Connect(function()
    if UNLOCKED and SETTINGS.AntiStun and plr.Character then
        local char = plr.Character
        if char:FindFirstChild("Ragdoll") then char:FindFirstChild("Ragdoll"):Destroy() end
        if char:FindFirstChild("Stunned") then char:FindFirstChild("Stunned"):Destroy() end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end)