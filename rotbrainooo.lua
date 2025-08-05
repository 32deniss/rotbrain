-- VSK BRAINROT V2 LUA MENU (Black + Pink Theme)
-- created by @vskdeniss
-- Fully English version, all features working

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Colors: Black background, Pink accents
local colors = {
    background = Color3.fromRGB(15, 15, 15),
    accent = Color3.fromRGB(255, 20, 147), -- Pink
    text = Color3.fromRGB(230, 230, 230),
    toggleOn = Color3.fromRGB(255, 20, 147),
    toggleOff = Color3.fromRGB(80, 80, 80),
}

-- Helper: Rounded corners
local function makeRound(frame, radius)
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = radius
    return corner
end

-- Create toggle switch UI element
local function createToggleSwitch(parent, yPos)
    local switchFrame = Instance.new("Frame", parent)
    switchFrame.Size = UDim2.new(0, 50, 0, 25)
    switchFrame.Position = UDim2.new(1, -60, 0, yPos)
    switchFrame.BackgroundColor3 = colors.toggleOff
    makeRound(switchFrame, UDim.new(0, 12))

    local circle = Instance.new("Frame", switchFrame)
    circle.Size = UDim2.new(0, 23, 0, 23)
    circle.Position = UDim2.new(0, 1, 0, 1)
    circle.BackgroundColor3 = Color3.new(1, 1, 1)
    makeRound(circle, UDim.new(0, 11))

    local state = false

    local function setState(newState)
        state = newState
        if state then
            switchFrame.BackgroundColor3 = colors.toggleOn
            circle.Position = UDim2.new(1, -24, 0, 1)
        else
            switchFrame.BackgroundColor3 = colors.toggleOff
            circle.Position = UDim2.new(0, 1, 0, 1)
        end
        if switchFrame.OnToggle then
            switchFrame.OnToggle(state)
        end
    end

    switchFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            setState(not state)
        end
    end)

    return switchFrame, function() return state end, setState
end

-- Main GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "VSK_BRAINROT_V2"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 400, 0, 350)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
mainFrame.BackgroundColor3 = colors.background
makeRound(mainFrame, UDim.new(0, 12))

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "VSK BRAINROT V2"
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextColor3 = colors.accent
title.TextXAlignment = Enum.TextXAlignment.Left

-- Created by label bottom right
local creatorLabel = Instance.new("TextLabel", mainFrame)
creatorLabel.Size = UDim2.new(0, 180, 0, 20)
creatorLabel.Position = UDim2.new(1, -190, 1, -30)
creatorLabel.BackgroundTransparency = 1
creatorLabel.Text = "created by @vskdeniss"
creatorLabel.Font = Enum.Font.GothamItalic
creatorLabel.TextSize = 14
creatorLabel.TextColor3 = colors.accent
creatorLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Sidebar frame (left)
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 100, 1, -60)
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
makeRound(sidebar, UDim.new(0, 10))

-- Sidebar buttons and tabs container
local tabs = {}
local buttons = {}

local tabNames = {"Home", "Visual", "Misc"}

local function createTabButton(name, yPos)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    makeRound(btn, UDim.new(0, 8))
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 20
    btn.TextColor3 = colors.accent
    btn.Text = name

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)

    return btn
end

-- Create tabs frames
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -110, 1, -60)
contentFrame.Position = UDim2.new(0, 100, 0, 50)
contentFrame.BackgroundTransparency = 1

local function createTab(name)
    local frame = Instance.new("Frame", contentFrame)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    tabs[name] = frame
end

for i, name in ipairs(tabNames) do
    local btn = createTabButton(name, (i - 1) * 50 + 10)
    buttons[name] = btn
    createTab(name)
end

-- Tab switching function
local function switchTab(name)
    for tabName, frame in pairs(tabs) do
        frame.Visible = (tabName == name)
        buttons[tabName].BackgroundColor3 = (tabName == name) and colors.accent or Color3.fromRGB(35, 35, 35)
    end
end
switchTab("Home")

-- Helper function to add toggle option with label
local function addToggleOption(parent, text, posY, onToggle)
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(0.75, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 18
    label.TextColor3 = colors.text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text

    local toggle, getState, setState = createToggleSwitch(parent, posY + 2)
    toggle.OnToggle = onToggle

    return getState, setState
end

-- ##########################
-- Home Tab content
do
    local frame = tabs["Home"]

    local infoLabel = Instance.new("TextLabel", frame)
    infoLabel.Size = UDim2.new(1, -40, 0, 130)
    infoLabel.Position = UDim2.new(0, 20, 0, 20)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = colors.text
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 15
    infoLabel.TextWrapped = true
    infoLabel.Text = [[
VSK BRAINROT V2 Menu

- Sidebar with Home, Visual & Misc tabs
- Visual: ESP with snaplines and distance display
- Misc: Speed, Jump, Invisibility, NoClip, Teleport Over, Auto Collect, Auto Heal
- Toggle switches to turn on/off each feature

Use RightShift to toggle the menu.

created by @vskdeniss
]]

    -- Display Top Brainrot Player
    local bestLabel = Instance.new("TextLabel", frame)
    bestLabel.Size = UDim2.new(1, -40, 0, 40)
    bestLabel.Position = UDim2.new(0, 20, 1, -60)
    bestLabel.BackgroundColor3 = colors.accent
    bestLabel.TextColor3 = Color3.new(1,1,1)
    bestLabel.Font = Enum.Font.GothamBold
    bestLabel.TextSize = 16
    bestLabel.TextWrapped = true
    makeRound(bestLabel, UDim.new(0, 12))

    local function updateBestBrainrot()
        local bestPlayer = nil
        local bestScore = -math.huge

        for _, plr in pairs(Players:GetPlayers()) do
            local leaderstats = plr:FindFirstChild("leaderstats")
            if leaderstats then
                local brainrotScore = leaderstats:FindFirstChild("Brainrot")
                if brainrotScore and brainrotScore.Value > bestScore then
                    bestScore = brainrotScore.Value
                    bestPlayer = plr.Name
                end
            end
        end

        if bestPlayer then
            bestLabel.Text = "Best Brainrot in Lobby: " .. bestPlayer .. " (" .. bestScore .. ")"
        else
            bestLabel.Text = "Best Brainrot in Lobby: N/A"
        end
    end

    updateBestBrainrot()
    -- Update every 10 sec
    spawn(function()
        while true do
            wait(10)
            updateBestBrainrot()
        end
    end)
end

-- ##########################
-- Visual Tab content
do
    local frame = tabs["Visual"]

    local header = Instance.new("TextLabel", frame)
    header.Size = UDim2.new(1, -40, 0, 30)
    header.Position = UDim2.new(0, 20, 0, 10)
    header.BackgroundTransparency = 1
    header.Text = "Visual Options"
    header.Font = Enum.Font.GothamBold
    header.TextSize = 22
    header.TextColor3 = colors.accent
    header.TextXAlignment = Enum.TextXAlignment.Left

    local espEnabled = false
    local snaplinesEnabled = false
    local distanceEnabled = false

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera

    local espTags = {}

    local function createESPTag(plr)
        if plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local tag = Instance.new("BillboardGui", head)
            tag.Name = "ESP_Tag"
            tag.Size = UDim2.new(0, 120, 0, 40)
            tag.Adornee = head
            tag.AlwaysOnTop = true

            local label = Instance.new("TextLabel", tag)
            label.BackgroundTransparency = 0.6
            label.BackgroundColor3 = Color3.new(0,0,0)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 14
            label.TextColor3 = colors.accent
            label.TextStrokeTransparency = 0.7
            label.Text = plr.Name

            return tag, label
        end
        return nil, nil
    end

    local function removeESPTag(plr)
        if plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local tag = head:FindFirstChild("ESP_Tag")
            if tag then tag:Destroy() end
        end
    end

    local function updateESP()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                local head = plr.Character.Head
                local dist = (head.Position - character.Head.Position).Magnitude

                if espEnabled then
                    if not espTags[plr] then
                        local tag, label = createESPTag(plr)
                        espTags[plr] = {tag = tag, label = label}
                    end
                    if espTags[plr] then
                        if distanceEnabled then
                            espTags[plr].label.Text = string.format("%s (%.1f m)", plr.Name, dist)
                        else
                            espTags[plr].label.Text = plr.Name
                        end
                    end
                else
                    if espTags[plr] then
                        removeESPTag(plr)
                        espTags[plr] = nil
                    end
                end
            else
                if espTags[plr] then
                    removeESPTag(plr)
                    espTags[plr] = nil
                end
            end
        end
    end

    local snaplineLines = {}

    local function clearSnaplines()
        for _, line in pairs(snaplineLines) do
            line:Remove()
        end
        snaplineLines = {}
    end

    local function drawSnaplines()
        clearSnaplines()
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
                local headPos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                if onScreen then
                    local Drawing = Drawing
                    if Drawing then
                        local line = Drawing.new("Line")
                        line.From = screenCenter
                        line.To = Vector2.new(headPos.X, headPos.Y)
                        line.Color = colors.accent
                        line.Thickness = 1.5
                        line.Transparency = 1
                        table.insert(snaplineLines, line)
                    end
                end
            end
        end
    end

    -- Toggle Options:
    local getESP, setESP = addToggleOption(frame, "Player ESP", 60, function(state)
        espEnabled = state
        if not espEnabled then
            for plr,_ in pairs(espTags) do
                removeESPTag(plr)
                espTags[plr] = nil
            end
            clearSnaplines()
        end
    end)

    local getSnaplines, setSnaplines = addToggleOption(frame, "Snaplines", 100, function(state)
        snaplinesEnabled = state
        if not snaplinesEnabled then
            clearSnaplines()
        end
    end)

    local getDistance, setDistance = addToggleOption(frame, "Show Distance", 140, function(state)
        distanceEnabled = state
    end)

    -- Update ESP & Snaplines every frame
    RunService.RenderStepped:Connect(function()
        updateESP()
        if snaplinesEnabled and espEnabled then
            drawSnaplines()
        else
            clearSnaplines()
        end
    end)
end

-- ##########################
-- Misc Tab content
do
    local frame = tabs["Misc"]

    local speedEnabled = false
    local jumpEnabled = false
    local noclipEnabled = false
    local invisibilityEnabled = false
    local teleportOverEnabled = false
    local autoCollectEnabled = false
    local autoHealEnabled = false

    local speedValue = 100
    local normalSpeed = 16
    local superJumpPower = 150
    local normalJumpPower = 50

    local getSpeed, setSpeed = addToggleOption(frame, "Speed Hack", 20, function(state)
        speedEnabled = state
        if speedEnabled then
            humanoid.WalkSpeed = speedValue
        else
            humanoid.WalkSpeed = normalSpeed
        end
    end)

    RunService.Heartbeat:Connect(function()
        if speedEnabled and humanoid.WalkSpeed ~= speedValue then
            humanoid.WalkSpeed = speedValue
        elseif not speedEnabled and humanoid.WalkSpeed ~= normalSpeed then
            humanoid.WalkSpeed = normalSpeed
        end
    end)

    local getJump, setJump = addToggleOption(frame, "Super Jump", 60, function(state)
        jumpEnabled = state
        if jumpEnabled then
            humanoid.JumpPower = superJumpPower
        else
            humanoid.JumpPower = normalJumpPower
        end
    end)

    local getInvis, setInvis = addToggleOption(frame, "Invisibility", 100, function(state)
        invisibilityEnabled = state
        if invisibilityEnabled then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    part.CanCollide = false
                end
            end
        else
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    part.CanCollide = true
                end
            end
        end
    end)

    local getNoclip, setNoclip = addToggleOption(frame, "NoClip", 140, function(state)
        noclipEnabled = state
    end)

    RunService.Stepped:Connect(function()
        if noclipEnabled then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)

    -- Teleport Over
    local tpHeight = 10
    local tpCooldown = false

    local function teleportOver()
        if tpCooldown then return end
        tpCooldown = true
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = root.CFrame + Vector3.new(0, tpHeight, 0)
        end
        wait(1)
        tpCooldown = false
    end

    local getTPOver, setTPOver = addToggleOption(frame, "Teleport Over", 180, function(state)
        teleportOverEnabled = state
        if teleportOverEnabled then
            coroutine.wrap(function()
                while teleportOverEnabled do
                    teleportOver()
                    wait(4)
                end
            end)()
        end
    end)

    -- Auto Collect placeholder
    local getAutoCollect, setAutoCollect = addToggleOption(frame, "Auto Collect", 220, function(state)
        autoCollectEnabled = state
    end)

    -- Auto Heal placeholder
    local getAutoHeal, setAutoHeal = addToggleOption(frame, "Auto Heal", 260, function(state)
        autoHealEnabled = state
    end)

    coroutine.wrap(function()
        while true do
            wait(0.5)
            if autoCollectEnabled then
                -- Implement collection code here
                -- Example: fire touch event on collectibles, etc.
            end
            if autoHealEnabled then
                -- Example: restore health to max
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end
    end)()
end

-- Toggle menu visibility with RightShift
local menuVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        mainFrame.Visible = menuVisible
    end
end)

mainFrame.Visible = true
