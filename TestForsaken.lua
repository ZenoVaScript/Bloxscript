local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local selectedTheme = "Default"
local Window = Rayfield:CreateWindow({
   Name = "Forsaken - Script By Iliankytb",
   Icon = 0,
   LoadingTitle = "Forsaken",
   LoadingSubtitle = "Script By Iliankytb",
   Theme = selectedTheme,
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SaverForsaken",
      FileName = "K"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

-- Tabs
local InfoTab = Window:CreateTab("Info")
local UpdateTab = Window:CreateTab("Update")
local PlayerTab = Window:CreateTab("Player")
local EspTab = Window:CreateTab("Esp")
local DiscordTab = Window:CreateTab("Discord")
local SettingsTab = Window:CreateTab("Settings")
local KillerTab = Window:CreateTab("Killer") -- New tab for Backstab features

-- Variables
local ActiveSpeedBoost,ActiveAutoUseCoinFlip,ActiveEspSurvivors,ActiveNoStun,ActiveEspKillers,ActiveEspGenerator,ActiveEspItems,ActiveInfiniteStamina,ActiveEspRagdolls,ActiveAutoGenerator,AutoKillSurvivors,RemoveLags = false,false,false,false,false,false,false,false,false,false,false

-- Backstab Variables
local enabled = false
local cooldown = false
local lastTarget = nil
local range = 4
local mode = "Behind"
local matchFacing = false
local attackType = "Normal"
local daggerCooldownText = nil

-- Initialize Backstab Remote
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local daggerRemote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
local killerNames = { "Jason", "c00lkidd", "JohnDoe", "1x1x1x1", "Noli" }
local killersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")

-- Animation IDs for Counter mode
local counterAnimIDs = {
    "126830014841198", "126355327951215", "121086746534252", "18885909645",
    "98456918873918", "105458270463374", "83829782357897", "125403313786645",
    "118298475669935", "82113744478546", "70371667919898", "99135633258223",
    "97167027849946", "109230267448394", "139835501033932", "126896426760253",
    "109667959938617", "126681776859538", "129976080405072", "121293883585738",
    "81639435858902", "137314737492715", "92173139187970"
}

-- Backstab Functions
local function killerPlayingCounterAnim(killer)
    local humanoid = killer:FindFirstChildOfClass("Humanoid")
    if not humanoid or not humanoid:FindFirstChildOfClass("Animator") then return false end
    for _, track in ipairs(humanoid.Animator:GetPlayingAnimationTracks()) do
        if track.Animation and track.Animation.AnimationId then
            local animIdNum = track.Animation.AnimationId:match("%d+")
            for _, id in ipairs(counterAnimIDs) do
                if tostring(animIdNum) == id then return true end
            end
        end
    end
    return false
end

local function isBehindTarget(hrp, targetHRP)
    local distance = (hrp.Position - targetHRP.Position).Magnitude
    if distance > range then return false end
    if mode == "Around" then 
        return true 
    else
        local direction = -targetHRP.CFrame.LookVector
        local toPlayer = (hrp.Position - targetHRP.Position)
        return toPlayer:Dot(direction) > 0.5
    end
end

local function refreshDaggerRef()
    local mainui = lp:FindFirstChild("PlayerGui"):FindFirstChild("MainUI")
    if mainui and mainui:FindFirstChild("AbilityContainer") then
        local dagger = mainui.AbilityContainer:FindFirstChild("Dagger")
        if dagger and dagger:FindFirstChild("CooldownTime") then
            daggerCooldownText = dagger.CooldownTime
            return
        end
    end
    daggerCooldownText = nil
end

-- Backstab UI Elements
local BackstabToggle = KillerTab:CreateToggle({
    Name = "Backstab",
    CurrentValue = false,
    Flag = "BackstabToggle",
    Callback = function(Value)
        enabled = Value
    end,
})

local BackstabRangeSlider = KillerTab:CreateSlider({
    Name = "Backstab Range",
    Range = {1, 10},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 4,
    Flag = "BackstabRange",
    Callback = function(Value)
        range = Value
    end,
})

local BackstabModeDropdown = KillerTab:CreateDropdown({
    Name = "Backstab Mode",
    Options = {"Behind", "Around"},
    CurrentOption = {"Behind"},
    MultipleOptions = false,
    Flag = "BackstabMode",
    Callback = function(Options)
        mode = Options[1]
    end,
})

local BackstabTypeDropdown = KillerTab:CreateDropdown({
    Name = "Backstab Type",
    Options = {"Normal", "Counter", "Legit"},
    CurrentOption = {"Normal"},
    MultipleOptions = false,
    Flag = "BackstabType",
    Callback = function(Options)
        attackType = Options[1]
    end,
})

local LegitAimbotToggle = KillerTab:CreateToggle({
    Name = "Legit Aimbot",
    CurrentValue = false,
    Flag = "LegitAimbot",
    Callback = function(Value)
        matchFacing = Value
    end,
})

-- Backstab Main Logic
lp.PlayerGui.DescendantAdded:Connect(refreshDaggerRef)
lp.PlayerGui.DescendantRemoving:Connect(function(obj)
    if obj == daggerCooldownText then
        daggerCooldownText = nil
    end
end)
refreshDaggerRef()

RunService.RenderStepped:Connect(function()
    if not daggerCooldownText or not daggerCooldownText.Parent then return end
    if tonumber(daggerCooldownText.Text) then return end -- still on cooldown
    if not enabled or cooldown then return end
    
    local char = lp.Character
    if not (char and char:FindFirstChild("HumanoidRootPart")) then return end
    local hrp = char.HumanoidRootPart
    local stats = game:GetService("Stats")
    
    for _, name in ipairs(killerNames) do
        local killer = killersFolder:FindFirstChild(name)
        if killer and killer:FindFirstChild("HumanoidRootPart") then
            local kHRP = killer.HumanoidRootPart
            
            if attackType == "Legit" then
                local dist = (kHRP.Position - hrp.Position).Magnitude
                if dist <= range then
                    -- Optional facing alignment
                    if matchFacing then
                        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + kHRP.CFrame.LookVector)
                    end
                    if mode == "Behind" then
                        local directionToTarget = (kHRP.Position - hrp.Position).Unit
                        local dot = hrp.CFrame.LookVector:Dot(directionToTarget)
                        if dot > 0.6 then -- target is in front
                            return
                        end
                    end
                    daggerRemote:FireServer("UseActorAbility", "Dagger")
                end
                return -- skip TP logic
            end
            
            if attackType == "Counter" and not killerPlayingCounterAnim(killer) then
                continue
            end
            
            if isBehindTarget(hrp, kHRP) and killer ~= lastTarget then
                cooldown = true
                lastTarget = killer
                local start = tick()
                local didDagger = false
                local connection
                
                connection = RunService.Heartbeat:Connect(function()
                    if not (char and char.Parent and kHRP and kHRP.Parent) then
                        if connection then connection:Disconnect() end
                        return
                    end
                    
                    local elapsed = tick() - start
                    if elapsed >= 0.5 then
                        if connection then connection:Disconnect() end
                        return
                    end
                    
                    -- LIVE Ping + velocity prediction
                    local ping = tonumber(stats.Network.ServerStatsItem["Data Ping"]:GetValueString():match("%d+")) or 50
                    local pingSeconds = ping / 1000
                    local killerVelocity = kHRP.Velocity
                    local moveDir = killerVelocity.Magnitude > 0.1 and killerVelocity.Unit or Vector3.new()
                    local pingOffset = moveDir * (pingSeconds * killerVelocity.Magnitude)
                    local predictedPos = kHRP.Position + pingOffset
                    
                    -- Apply mode logic with improved "Around" handling
                    local targetPos
                    if mode == "Behind" then
                        targetPos = predictedPos - (kHRP.CFrame.LookVector * 0.3)
                    elseif mode == "Around" then
                        local lookVec = kHRP.CFrame.LookVector
                        local rightVec = kHRP.CFrame.RightVector
                        local rel = (hrp.Position - kHRP.Position)
                        local lateralSpeed = killerVelocity:Dot(rightVec)
                        
                        local baseOffset = (rel.Magnitude > 0.1) and rel.Unit * 0.3 or Vector3.new()
                        local lateralOffset = rightVec * lateralSpeed * 0.3
                        targetPos = predictedPos + baseOffset + lateralOffset
                    end
                    
                    -- Constant live TP
                    hrp.CFrame = CFrame.new(targetPos, targetPos + kHRP.CFrame.LookVector)
                    
                    -- Only dagger once
                    if not didDagger then
                        didDagger = true
                        -- Keep aligning for 0.7s
                        local faceStart = tick()
                        local faceConn
                        
                        faceConn = RunService.Heartbeat:Connect(function()
                            if tick() - faceStart >= 0.7 or not kHRP or not kHRP.Parent then
                                if faceConn then faceConn:Disconnect() end
                                return
                            end
                            
                            -- Live align during window
                            local livePing = tonumber(stats.Network.ServerStatsItem["Data Ping"]:GetValueString():match("%d+")) or 50
                            local livePingSeconds = livePing / 1000
                            local liveVelocity = kHRP.Velocity
                            local liveMoveDir = liveVelocity.Magnitude > 0.1 and liveVelocity.Unit or Vector3.new()
                            local livePingOffset = liveMoveDir * (livePingSeconds * liveVelocity.Magnitude)
                            local livePredictedPos = kHRP.Position + livePingOffset
                            
                            local liveTargetPos
                            if mode == "Behind" then
                                liveTargetPos = livePredictedPos - (kHRP.CFrame.LookVector * 0.3)
                            elseif mode == "Around" then
                                local lookVec = kHRP.CFrame.LookVector
                                local rightVec = kHRP.CFrame.RightVector
                                local liveRel = (hrp.Position - kHRP.Position)
                                local liveLateralSpeed = liveVelocity:Dot(rightVec)
                                
                                local baseOffset = (liveRel.Magnitude > 0.1) and liveRel.Unit * 0.3 or Vector3.new()
                                local lateralOffset = rightVec * liveLateralSpeed * 0.3
                                liveTargetPos = livePredictedPos + baseOffset + lateralOffset
                            end
                            
                            hrp.CFrame = CFrame.new(liveTargetPos, liveTargetPos + kHRP.CFrame.LookVector)
                        end)
                        
                        daggerRemote:FireServer("UseActorAbility", "Dagger")
                    end
                end)
                
                -- Reset cooldown when out of range
                task.delay(2, function()
                    RunService.Heartbeat:Wait()
                    while isBehindTarget(hrp, kHRP) do
                        RunService.Heartbeat:Wait()
                    end
                    lastTarget = nil
                    cooldown = false
                end)
                
                break
            end
        end
    end
end)

-- Original UI Elements (from code 2)
local ParagraphInfoServer = InfoTab:CreateParagraph({Title = "Info", Content = "Loading"})
Rayfield:Notify({
   Title = "Cheat Version",
   Content = "V.0.40",
   Duration = 2.5,
   Image = "rewind",
})

local function getServerInfo()
    local Players = game:GetService("Players")
    local playerCount = #Players:GetPlayers()
    local maxPlayers = game:GetService("Players").MaxPlayers
    local isStudio = game:GetService("RunService"):IsStudio()

    return {
        PlaceId = game.PlaceId,
        JobId = game.JobId,
        IsStudio = isStudio,
        CurrentPlayers = playerCount,
        MaxPlayers = maxPlayers
    }
end

local Paragraph1 = UpdateTab:CreateParagraph({Title = "TP To Gen", Content = "This Function Work Now And If You Got Kicked I Guess Sorry!"})
local Paragraph2 = UpdateTab:CreateParagraph({Title = "Fixed Full Bright(V.0.23)", Content = "Normally Full Bright Is Fixed Try It!"})
local Paragraph3 = UpdateTab:CreateParagraph({Title = "Fixed Items(V.0.24)", Content = "Just Fixed Now!"})

local function CreateEsp(Char,Color,Text,Parent,number)
    if Char and not Char:FindFirstChildOfClass("Highlight") and not Parent:FindFirstChildOfClass("BillboardGui") then
        local NewHighlight = Instance.new("Highlight",Char)
        NewHighlight.OutlineColor = Color 
        NewHighlight.FillColor = Color
        local billboard = Char:FindFirstChild("ESP") or Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Size = UDim2.new(0, 50, 0, 25)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, number, 0)
        billboard.Adornee = Parent
        billboard.Enabled = true
        billboard.Parent = Parent

        local label = billboard:FindFirstChildOfClass("TextLabel") or Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = Text
        label.TextColor3 = Color
        label.TextScaled = true
        label.Parent = billboard
    end
end

local function KeepEsp(Char,parent)
    if Char and Char:FindFirstChildOfClass("Highlight") and parent:FindFirstChildOfClass("BillboardGui") then
        Char:FindFirstChildOfClass("Highlight"):Destroy()
        parent:FindFirstChildOfClass("BillboardGui"):Destroy()
    end
end

local EspSurvivorsToggle = EspTab:CreateToggle({
   Name = "Survivors Esp",
   CurrentValue = false,
   Flag = "EspSurvivors",
   Callback = function(Value)
      ActiveEspSurvivors = Value task.spawn(function()
        while ActiveEspSurvivors do task.spawn(function()
            for _,Players in pairs(workspace.Players.Survivors:GetChildren()) do 
                if Players:IsA("Model") and Players:FindFirstChild("Head") and not Players:FindFirstChildOfClass("Highlight") and not Players.Head:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(Players,Color3.fromRGB(0,255,0),Players.Name.." ("..Players:GetAttribute("Username")..")",Players.Head,2)
                end
            end
        end)
        task.wait(0.1)
        end 
        for _,Players in pairs(workspace.Players.Survivors:GetChildren()) do 
            if Players:IsA("Model") and Players:FindFirstChild("Head") and Players:FindFirstChildOfClass("Highlight") and Players.Head:FindFirstChildOfClass("BillboardGui") then
                KeepEsp(Players,Players.Head)
            end
        end 
      end)
   end,
})

local EspKillersToggle = EspTab:CreateToggle({
   Name = "Killers Esp",
   CurrentValue = false,
   Flag = "EspKiller",
   Callback = function(Value)
      ActiveEspKillers = Value task.spawn(function()
        while ActiveEspKillers do task.spawn(function()
            for _,Players in pairs(workspace.Players.Killers:GetChildren()) do 
                if Players:IsA("Model") and (Players.Name == "1x1x1x1" or Players.Name == "Jason" or Players.Name == "John Doe") and Players:FindFirstChild("Head") and Players:FindFirstChildOfClass("Highlight") and not Players.Head:FindFirstChildOfClass("BillboardGui") then
                    Players:FindFirstChildOfClass("Highlight"):Destroy()
                end
                if Players:IsA("Model") and Players:FindFirstChild("Head") and not Players:FindFirstChildOfClass("Highlight") and not Players.Head:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(Players,Color3.fromRGB(255,0,0),Players.Name.." ("..Players:GetAttribute("Username")..")",Players.Head,2)
                end
            end
        end)
        task.wait(0.1)
        end 
        for _,Players in pairs(workspace.Players.Killers:GetChildren()) do 
            if Players:IsA("Model") and Players:FindFirstChild("Head") and Players:FindFirstChildOfClass("Highlight") and Players.Head:FindFirstChildOfClass("BillboardGui") then
                KeepEsp(Players,Players.Head)
            end
        end 
      end)
   end,
})

local EspGeneratorToggle = EspTab:CreateToggle({
   Name = "Generator Esp",
   CurrentValue = false,
   Flag = "EspGenerator",
   Callback = function(Value)
      ActiveEspGenerator= Value task.spawn(function()
        while ActiveEspGenerator do
            if workspace.Map.Ingame:FindFirstChild("Map") then
                for _,Players in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
                    if Players:IsA("Model") and Players.PrimaryPart and Players.name == "Generator" and not Players:FindFirstChildOfClass("Highlight") and not Players.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Players,Color3.fromRGB(255,255,0),"Generator",Players.PrimaryPart,-2)
                    end
                end
            end
            task.wait(0.1) 
        end
        if workspace.Map.Ingame:FindFirstChild("Map") then
            for _,Players in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
                if Players:IsA("Model") and Players.PrimaryPart and Players.name == "Generator" and Players:FindFirstChildOfClass("Highlight") and Players.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                    KeepEsp(Players)
                end
            end
        end
      end)
   end,
})

local EspItemsToggle = EspTab:CreateToggle({
   Name = "Items Esp",
   CurrentValue = false,
   Flag = "EspItems",
   Callback = function(Value)
      ActiveEspItems = Value
      task.spawn(function()
        while ActiveEspItems do
            for _,Players in pairs(workspace.Map.Ingame:GetChildren()) do 
                if Players:IsA("Tool") and Players:FindFirstChild("ItemRoot") and not Players:FindFirstChildOfClass("Highlight") and not Players:FindFirstChild("ItemRoot"):FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(Players,Color3.fromRGB(0,0,255),Players.Name,Players:FindFirstChild("ItemRoot"),1)
                end
            end
            if workspace.Map.Ingame:FindFirstChild("Map") then
                for _,Players in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
                    if Players:IsA("Tool") and Players:FindFirstChild("ItemRoot") and not Players:FindFirstChildOfClass("Highlight") and not Players:FindFirstChild("ItemRoot"):FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Players,Color3.fromRGB(0,0,255),Players.Name,Players:FindFirstChild("ItemRoot"),1)
                    end
                end
            end
            task.wait(0.1) 
        end
        for _,Players in pairs(workspace.Map.Ingame:GetChildren()) do 
            if Players:IsA("Tool") and Players:FindFirstChild("ItemRoot") and Players:FindFirstChildOfClass("Highlight") and Players:FindFirstChild("ItemRoot"):FindFirstChildOfClass("BillboardGui") then
                KeepEsp(Players,Players:FindFirstChild("ItemRoot"))
            end
        end
        if workspace.Map.Ingame:FindFirstChild("Map") then
            for _,Players in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
                if Players:IsA("Tool") and Players:FindFirstChild("ItemRoot") and Players:FindFirstChildOfClass("Highlight") and Players:FindFirstChild("ItemRoot"):FindFirstChildOfClass("BillboardGui") then
                    KeepEsp(Players,Players:FindFirstChild("ItemRoot")) 
                end
            end
        end
      end)
   end,
})

local ValueSpeed = 16
local PlayerSpeedSlider = PlayerTab:CreateSlider({
   Name = "Player Speed(max 25 for not be a exploiter) ",
   Range = {0, 25},
   Increment = 1,
   Suffix = "Speeds",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
      CurrentValue = Value
      ValueSpeed = Value
   end,
})

local PlayerActiveModifyingSpeedToggle = PlayerTab:CreateToggle({
   Name = "Active Modifying Player Speed",
   CurrentValue = false,
   Flag = "ButtonSpeed",
   Callback = function(Value)
      ActiveSpeedBoost = Value 
      task.spawn(function()
        while ActiveSpeedBoost do 
            task.spawn(function()
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = ValueSpeed 
                game.Players.LocalPlayer.Character.Humanoid:SetAttribute("BaseSpeed",ValueSpeed)
            end)
            task.wait(0.1)
        end 
      end)
   end,
})

local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    else
        warn("setclipboard is not supported in this environment.")
    end
end

local DiscordLink = DiscordTab:CreateButton({
   Name = "Discord Link",
   Callback = function()
      copyToClipboard("https://discord.gg/E2TqYRsRP4")
   end,
})

local PlayerActiveAutoGeneratorToggle = PlayerTab:CreateToggle({
   Name = "Auto Generator(every 2.5 second)",
   CurrentValue = false,
   Flag = "ButtonAutoGen",
   Callback = function(Value)
      ActiveAutoGenerator = Value task.spawn(function()
        while ActiveAutoGenerator do task.spawn(function()
            for _,Players in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
                if Players:IsA("Model") and Players.name == "Generator" then 
                    if Players:FindFirstChild("Remotes"):FindFirstChild("RE") then 
                        Players:FindFirstChild("Remotes"):FindFirstChild("RE"):FireServer() 
                    end
                end
            end 
        end)
        task.wait(2.5)
        end 
      end)
   end,
})

local PlayerActiveInfStaminaToggle = PlayerTab:CreateToggle({
   Name = "Infinite Stamina(Don't work on solara and xeno,verified on Krnl!)",
   CurrentValue = false,
   Flag = "ButtonInfiniteStamina",
   Callback = function(Value)
      ActiveInfiniteStamina = Value task.spawn(function()
        while ActiveInfiniteStamina do 
            task.spawn(function()
                local m = require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
                m.StaminaLossDisabled = true 
                m.Stamina = 9999999
            end)
            task.wait(0.1)
        end 
        task.spawn(function()
            local m = require(game.ReplicatedStorage.Systems.Character.Game.Sprinting)
            m.StaminaLossDisabled = false 
            m.Stamina = 100
        end)
      end)
   end,
})

local PlayerNoStunToggle = PlayerTab:CreateToggle({
   Name = "No Stun",
   CurrentValue = false,
   Flag = "NoStunButton",
   Callback = function(Value)
      ActiveNoStun = Value task.spawn(function()
        while ActiveNoStun do task.spawn(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end)
        task.wait(0.001)
        end 
      end)
   end,
})

local PlayerAutoUseCoinFlipToggle = PlayerTab:CreateToggle({
   Name = "Auto Use Coin Flip",
   CurrentValue = false,
   Flag = "AutoUseCoinFlipbutton",
   Callback = function(Value)
      ActiveAutoUseCoinFlip = Value task.spawn(function()
        while ActiveAutoUseCoinFlip do task.spawn(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local RemoteEvent = ReplicatedStorage.Modules.Network.RemoteEvent
            RemoteEvent:FireServer("UseActorAbility", "CoinFlip")
        end)
        task.wait(1)
        end 
      end)
   end,
})

local PlayerActiveAutoKillSurvivorsToggle = PlayerTab:CreateToggle({
   Name = "Auto Kill Survivors(Unverified!)",
   CurrentValue = false,
   Flag = "ButtonAutoKillSurvivors",
   Callback = function(Value)
      ActiveAutoKillSurvivors = Value task.spawn(function()
        while ActiveAutoKillSurvivors do 
            task.spawn(function()
                for _,Players in pairs(workspace.Players.Survivors:GetChildren()) do 
                    if Players:IsA("Model") then
                        game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Players.HumanoidRootPart.CFrame
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local RemoteEvent = ReplicatedStorage.Modules.Network.RemoteEvent
                        RemoteEvent:FireServer("UseActorAbility", "Slash")
                    end
                end
            end)
            task.wait(0.05)
        end 
      end)
   end,
})

local DropdownTpGen = PlayerTab:CreateDropdown({
   Name = "Dropdown TP To Generators",
   Options = {},
   CurrentOption = {"Nothings"},
   MultipleOptions = false,
   Flag = nil,
   Callback = function(Options)   
      task.spawn(function()
        for _,Players in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
            if Players:IsA("Model") and Players.name == "Generator" then 
                if Players:FindFirstChild("GeneratorTP") then 
                    if Players:FindFirstChild("GeneratorTP").Value == Options[1] then 
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Players.PrimaryPart.CFrame + Vector3.new(0,5,0)
                    end  
                end 
            end
        end  
      end)
   end,
})

local PlayerRefreshGenButton = PlayerTab:CreateButton({
   Name = "Refresh Dropdown Generator",
   Callback = function(Value) 
      local num = 1
      task.spawn(function() 
        local GenTable = {} 
        for _,Players in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do 
            if Players:IsA("Model") and Players.name == "Generator" then 
                table.insert(GenTable,"Generator ".. num) 
                if not Players:FindFirstChild("GeneratorTP") then 
                    task.spawn(function() 
                        local NewValue = Instance.new("StringValue",Players) 
                        NewValue.Name = "GeneratorTP" 
                        NewValue.Value = "Generator "..num 
                    end) 
                end 
                num = num +1
            end
        end 
        DropdownTpGen:Refresh(GenTable)
      end)
   end,
})

local EspRagdollsToggle = EspTab:CreateToggle({
   Name = "Ragdolls & Enemy Rig Killer Esp",
   CurrentValue = false,
   Flag = "EspRagdolls", 
   Callback = function(Value)
      ActiveEspRagdolls = Value task.spawn(function()
        while ActiveEspRagdolls do task.spawn(function()
            for _,Players in pairs(workspace.Ragdolls:GetChildren()) do 
                if Players:IsA("Model") and Players.PrimaryPart and not Players:FindFirstChildOfClass("Highlight") and not Players.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                    CreateEsp(Players,Color3.fromRGB(47,47,47),Players.Name,Players.PrimaryPart,-1)
                end
            end
        end)
        task.wait(0.1)
        end 
        for _,Players in pairs(workspace.Ragdolls:GetChildren()) do 
            if Players:IsA("Model") and Players.PrimaryPart and Players:FindFirstChildOfClass("Highlight") and Players.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                KeepEsp(Players,Players.PrimaryPart)
            end
        end 
      end)
   end,
})

local ValueFieldOfView = 80
local OldFOV = game.Players.LocalPlayer.PlayerData.Settings.Game.FieldOfView.Value
local PlayerFieldOfViewSlider = PlayerTab:CreateSlider({
   Name = "Field Of View",
   Range = {80, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 80,
   Flag = "FOV1",
   Callback = function(Value)
      CurrentValue = Value
      ValueFieldOfView = Value
   end,
})

local ActiveModifiedFieldOfView = false 
local PlayerActiveModifyingFOVToggle = PlayerTab:CreateToggle({
   Name = "Active Modifying Player FOV",
   CurrentValue = false,
   Flag = "ButtonFOV", 
   Callback = function(Value)
      ActiveModifiedFieldOfView = Value 
      if ActiveModifiedFieldOfView then
          game.Players.LocalPlayer.PlayerData.Settings.Game.FieldOfView.Value = ValueFieldOfView 
      else
          game.Players.LocalPlayer.PlayerData.Settings.Game.FieldOfView.Value = OldFOV 
      end
   end,
})

local ActiveFullBright = false
local PlayerFullBright = PlayerTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(Value)
      ActiveFullBright = Value
      task.spawn(function()
        while ActiveFullBright do
            if game.Lighting then 
                game.Lighting.Brightness = 5
                game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            end  
            wait(0.1) 
        end 
      end)
   end,  
})

local PlayerRemoveLag = PlayerTab:CreateToggle({
   Name = "Remove Lag",
   CurrentValue = false,
   Flag = "RemoveLag",
   Callback = function(Value)
      RemoveLags = Value
      task.spawn(function()
        while RemoveLags do
            for _, asset in pairs(workspace:GetDescendants()) do
                if (asset:IsA("Part") or asset:IsA("MeshPart")) and asset.Transparency < 1 then
                    if not asset:GetAttribute("OldMaterial") then
                        asset:SetAttribute("OldMaterial",asset.Material.Name)
                    end
                    asset.Material = Enum.Material.SmoothPlastic
                    if asset:IsA("MeshPart") then
                        if asset.TextureID and asset.TextureID ~= "" and not asset:GetAttribute("OldTextureID") then
                            asset:SetAttribute("OldTextureID", asset.TextureID)
                            asset.TextureID = ""
                        end
                    end
                end
            end
            wait(0.1) 
        end 
        for _, asset in pairs(workspace:GetDescendants()) do
            if asset:IsA("Part") or asset:IsA("MeshPart")) then
                local oldMatName = asset:GetAttribute("OldMaterial")
                if oldMatName then
                    for _, enumItem in ipairs(Enum.Material:GetEnumItems()) do
                        if enumItem.Name == oldMatName then
                            asset.Material = enumItem
                            break
                        end
                    end
                end
                if asset:IsA("MeshPart") then
                    local oldTex = asset:GetAttribute("OldTextureID")
                    if oldTex then
                        asset.TextureID = oldTex
                    end
                end
            end
        end
      end)
   end,  
})

local ButtonUnloadCheat = SettingsTab:CreateButton({
   Name = "Unload Cheat",
   Callback = function()
      Rayfield:Destroy()
   end,
})

local Themes = {
   ["Default"] = "Default",
   ["Amber Glow"] = "AmberGlow",
   ["Amethyst"] = "Amethyst",
   ["Bloom"] = "Bloom",
   ["Dark Blue"] = "DarkBlue",
   ["Green"] = "Green",
   ["Light"] = "Light",
   ["Ocean"] = "Ocean",
   ["Serenity"] = "Serenity"
}

local Dropdown = SettingsTab:CreateDropdown({
   Name = "Change Theme",
   Options = {"Default", "Amber Glow", "Amethyst", "Bloom", "Dark Blue", "Green", "Light", "Ocean", "Serenity"},
   CurrentOption = selectedTheme,
   Flag = "ThemeSelection",
   Callback = function(Selected)
      local ident = Themes[Selected[1]]
      Window.ModifyTheme(ident)
   end, 
})

Rayfield:LoadConfiguration()

task.spawn(function()
    while true do
        task.wait(1) 
        task.spawn(function()
            local updatedInfo = getServerInfo()
            local updatedContent = string.format(
                "📌 PlaceId: %s\n🔑 JobId: %s\n🧪 IsStudio: %s\n👥 Players: %d/%d",
                updatedInfo.PlaceId,
                updatedInfo.JobId,
                tostring(updatedInfo.IsStudio),
                updatedInfo.CurrentPlayers,
                updatedInfo.MaxPlayers
            )
            ParagraphInfoServer:Set({
                Title = "Info",
                Content = updatedContent
            })
        end)
    end
end)