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

-- Rayfield setup
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

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
local espEnabled = false
local espConnections = {}
local boostJumpEnabled = false
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
        if antiStunConnection then antiStunConnection:Disconnect() end
        antiStunConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health < math.huge then
                humanoid.Health = math.huge
            end
        end)
    else
        if antiStunConnection then antiStunConnection:Disconnect() end
        antiStunConnection = nil
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
        RunService.Heartbeat:Connect(function()
            local target = getClosestAimbotTarget()
            if target and target.Character and char and root and humanoid then
                local targetHrp = target.Character:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    root.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetHrp.Position.X, root.Position.Y, targetHrp.Position.Z))
                end
            end
        end)
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
        Rayfield:Notify({
            Title = "Server Hop",
            Content = "No other servers found.",
            Duration = 3,
            Actions = {
                Ignore = {
                    Name = "Okay",
                    Callback = function() end
                },
            },
        })
    end
end

---------------------------------------------------
--[[               RAYFIELD UI                ]]--
---------------------------------------------------

local Window = Rayfield:CreateWindow({
    Name = "ZenoVa SAB",
    LoadingTitle = "Loading ZenoVa Script",
    LoadingSubtitle = "by ZenoVa",
    ConfigurationSaving = {
       Enabled = false,
       FolderName = nil,
       FileName = "ZenoVaSAB"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink",
       RememberJoins = true
    },
    KeySystem = false,
})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateToggle({
    Name = "Godmode",
    CurrentValue = false,
    Flag = "GodmodeToggle",
    Callback = function(Value)
        setGodMode(Value)
    end,
})

PlayerTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        toggleAimbot(Value)
    end,
})

PlayerTab:CreateToggle({
    Name = "Jump Boost",
    CurrentValue = false,
    Flag = "JumpBoostToggle",
    Callback = function(Value)
        boostJumpEnabled = Value
    end,
})

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

VisualsTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        toggleESP(Value)
    end,
})

VisualsTab:CreateToggle({
    Name = "Invisible",
    CurrentValue = false,
    Flag = "InvisibleToggle",
    Callback = function(Value)
        setInvisible(Value)
    end,
})

-- Steal Tab
local StealTab = Window:CreateTab("Steal", 4483362458)

local teleportWindow = nil
StealTab:CreateButton({
    Name = "Start Steal",
    Callback = function()
        if not teleportWindow then
            teleportWindow = Window:CreateWindow({
                Name = "Teleport Control",
                LoadingTitle = "Teleport Controls",
                LoadingSubtitle = "Sky/Ground Teleport",
                ConfigurationSaving = {
                   Enabled = false,
                },
            })
            
            teleportWindow:CreateButton({
                Name = isTeleporting and "GROUND" or "SKY",
                Callback = function()
                    isTeleporting = not isTeleporting
                    if isTeleporting then
                        teleportToSky()
                    else
                        teleportToGround()
                    end
                    -- Update button text
                    for _, element in pairs(teleportWindow:GetChildren()) do
                        if element.Name == "Button" then
                            element:Set("Name", isTeleporting and "GROUND" or "SKY")
                        end
                    end
                end,
            })
        else
            teleportWindow:Destroy()
            teleportWindow = nil
        end
    end,
})

-- World Tab
local WorldTab = Window:CreateTab("World", 4483362458)

WorldTab:CreateButton({
    Name = "Change Server",
    Callback = function()
        serverHop()
    end,
})

Rayfield:LoadConfiguration()