-- VSK BRAINROT V3: Toggle Switches, viele Funktionen, Snaplines, ESP
-- Created by @vskdeniss

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Farben & Design
local colors = {
    dark = Color3.fromRGB(15, 15, 40),
    sidebar = Color3.fromRGB(30, 30, 60),
    highlight = Color3.fromRGB(100, 60, 190),
    text = Color3.fromRGB(220, 220, 230),
    buttonHover = Color3.fromRGB(80, 50, 150),
    boxPurple = Color3.fromRGB(140, 90, 220),
    switchOff = Color3.fromRGB(120, 120, 130),
    switchOn = Color3.fromRGB(140, 90, 220),
}

-- Hilfsfunktion: Toggle Switch (kleiner Button rechts)
local function createToggleSwitch(parent, posY)
    local switch = Instance.new("TextButton", parent)
    switch.Size = UDim2.new(0, 40, 0, 25)
    switch.Position = UDim2.new(1, -50, 0, posY + 5)
    switch.BackgroundColor3 = colors.switchOff
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Name = "ToggleSwitch"
    switch.ClipsDescendants = true

    local uicorner = Instance.new("UICorner", switch)
    uicorner.CornerRadius = UDim.new(0, 12)

    local circle = Instance.new("Frame", switch)
    circle.Name = "Circle"
    circle.Size = UDim2.new(0, 20, 0, 20)
    circle.Position = UDim2.new(0, 3, 0, 3)
    circle.BackgroundColor3 = Color3.new(1,1,1)
    circle.ClipsDescendants = true

    local circleCorner = Instance.new("UICorner", circle)
    circleCorner.CornerRadius = UDim.new(1, 0)

    local toggled = false

    local function updateSwitch()
        if toggled then
            switch.BackgroundColor3 = colors.switchOn
            circle:TweenPosition(UDim2.new(1, -23, 0, 3), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        else
            switch.BackgroundColor3 = colors.switchOff
            circle:TweenPosition(UDim2.new(0, 3, 0, 3), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end
    end

    switch.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateSwitch()
        if switch.OnToggle then
            switch.OnToggle(toggled)
        end
    end)

    updateSwitch()

    return switch, function() return toggled end, function(state)
        toggled = state
        updateSwitch()
    end
end

-- Haupt GUI
local gui = Instance.new("ScreenGui")
gui.Name = "VSK_BRAINROT_V3"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 380)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -190)
mainFrame.BackgroundColor3 = colors.dark
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.ClipsDescendants = true
local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 14)

local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 90, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = colors.sidebar
local sideCorner = Instance.new("UICorner", sidebar)
sideCorner.CornerRadius = UDim.new(0, 14)

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -90, 1, 0)
contentFrame.Position = UDim2.new(0, 90, 0, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 60)
contentFrame.BorderSizePixel = 0
local contentCorner = Instance.new("UICorner", contentFrame)
contentCorner.CornerRadius = UDim.new(0, 14)

-- Sidebar Buttons
local sidebarItems = {
    {name = "Home", icon = "🏠"},
    {name = "Visual", icon = "👁️"},
    {name = "Misc", icon = "⚙️"},
}

local sidebarButtons = {}
local tabs = {}

local function createSidebarButton(text, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.BackgroundColor3 = colors.sidebar
    btn.BorderSizePixel = 0
    btn.Text = icon.."  "..text
    btn.TextColor3 = colors.text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false

    local uicorner = Instance.new("UICorner", btn)
    uicorner.CornerRadius = UDim.new(0, 10)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = colors.buttonHover
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = colors.sidebar
    end)

    return btn
end

local function createTab(name)
    local frame = Instance.new("ScrollingFrame", contentFrame)
    frame.Name = name
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.ScrollBarThickness = 5
    frame.Visible = false

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)

    tabs[name] = frame
    return frame
end

for i, item in ipairs(sidebarItems) do
    local btn = createSidebarButton(item.name, item.icon)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*55)
    btn.Parent = sidebar
    sidebarButtons[item.name] = btn
    createTab(item.name)
end

local currentTab = nil
local function showTab(name)
    if currentTab then
        tabs[currentTab].Visible = false
        sidebarButtons[currentTab].BackgroundColor3 = colors.sidebar
        sidebarButtons[currentTab].TextColor3 = colors.text
    end
    currentTab = name
    tabs[name].Visible = true
    sidebarButtons[name].BackgroundColor3 = colors.highlight
    sidebarButtons[name].TextColor3 = Color3.new(1,1,1)
end

for name, btn in pairs(sidebarButtons) do
    btn.MouseButton1Click:Connect(function()
        showTab(name)
    end)
end

showTab("Home")

-- Home Tab
do
    local frame = tabs["Home"]

    local title = Instance.new("TextLabel", frame)
    title.Text = "VSK BRAINROT V3"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = colors.highlight
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)

    local info = Instance.new("TextLabel", frame)
    info.Text = [[
- ESP mit Snaplines
- Speed & Jump Hacks
- Invisibility, No Clip
- Auto Collect Brainrot Items
- Auto Heal bei wenig HP
- Toggle Switches neben jeder Funktion
    ]]
    info.Font = Enum.Font.Gotham
    info.TextSize = 14
    info.TextColor3 = colors.text
    info.BackgroundTransparency = 1
    info.Size = UDim2.new(1, -20, 0, 120)
    info.Position = UDim2.new(0, 10, 0, 60)
    info.TextWrapped = true

    local creatorLabel = Instance.new("TextLabel", frame)
    creatorLabel.Text = "created by @vskdeniss"
    creatorLabel.Font = Enum.Font.GothamItalic
    creatorLabel.TextSize = 12
    creatorLabel.TextColor3 = colors.highlight
    creatorLabel.BackgroundTransparency = 1
    creatorLabel.Size = UDim2.new(1, -20, 0, 20)
    creatorLabel.Position = UDim2.new(0, 10, 1, -30)
end

-- Visual Tab
do
    local frame = tabs["Visual"]

    local espEnabled = false
    local snaplinesEnabled = false
    local distanceEnabled = false

    local espBoxes = {}
    local snaplines = {}

    local function makeRound(frame, radius)
        local c = Instance.new("UICorner", frame)
        c.CornerRadius = radius
        return c
    end

    local function createPlayerBox(plr)
        if espBoxes[plr] then return end
        local box = Instance.new("Frame")
        box.Name = "ESPBox"
        box.BackgroundColor3 = colors.boxPurple
        box.BorderSizePixel = 0
        box.Size = UDim2.new(0, 100, 0, 25)
        box.AnchorPoint = Vector2.new(0.5, 0.5)
        box.ClipsDescendants = true

        local label = Instance.new("TextLabel", box)
        label.Name = "NameLabel"
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -10, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left

        makeRound(box, UDim.new(0, 6))

        box.Parent = frame
        espBoxes[plr] = box
    end

    local function removePlayerBox(plr)
        if espBoxes[plr] then
            espBoxes[plr]:Destroy()
            espBoxes[plr] = nil
        end
    end

    local function updateBoxes()
        for plr, box in pairs(espBoxes) do
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if char and hrp and plr.Team ~= player.Team then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    box.Visible = true
                    box.Position = UDim2.new(0, pos.X - box.Size.X.Offset/2, 0, pos.Y - box.Size.Y.Offset/2)
                    box.NameLabel.Text = plr.Name

                    if distanceEnabled then
                        local dist = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                        box.NameLabel.Text = plr.Name .. string.format(" (%.0f)", dist)
                    end
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        end
    end

    local function createSnapline(plr)
        if snaplines[plr] then return end
        local line = Drawing.new("Line")
        line.Color = colors.boxPurple
        line.Thickness = 1.5
        line.Transparency = 0.8
        snaplines[plr] = line
    end

    local function removeSnapline(plr)
        if snaplines[plr] then
            snaplines[plr]:Remove()
            snaplines[plr] = nil
        end
    end

    local function updateSnaplines()
        local camera = workspace.CurrentCamera
        local centerX = camera.ViewportSize.X / 2
        local centerY = camera.ViewportSize.Y

        for plr, line in pairs(snaplines) do
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if char and hrp and plr.Team ~= player.Team then
                local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    line.From = Vector2.new(centerX, centerY)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end
    end

    local function updateVisual()
        updateBoxes()
        updateSnaplines()
    end

    -- Toggle Buttons mit Switch rechts
    local toggleY = 10
    local function addToggleOption(text, onToggle)
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(0.8, -50, 0, 30)
        label.Position = UDim2.new(0, 10, 0, toggleY)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 18
        label.TextColor3 = colors.text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = text

        local switch, getState, setState = createToggleSwitch(frame, toggleY)

        switch.OnToggle = function(state)
            onToggle(state)
        end

        toggleY = toggleY + 45
    end

    addToggleOption("ESP", function(state)
        espEnabled = state
        if not state then
            for plr, _ in pairs(espBoxes) do removePlayerBox(plr) end
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player then createPlayerBox(plr) end
            end
        end
    end)

    addToggleOption("Snaplines", function(state)
        snaplinesEnabled = state
        if not state then
            for plr, _ in pairs(snaplines) do removeSnapline(plr) end
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= player then createSnapline(plr) end
            end
        end
    end)

    addToggleOption("Entfernung anzeigen", function(state)
        distanceEnabled = state
    end)

    -- Update Schleife für Visual Elemente
    RunService.Heartbeat:Connect(function()
        if espEnabled then updateBoxes() end
        if snaplinesEnabled then updateSnaplines() end
    end)

    -- Spieler hinzufügen/entfernen Events
    Players.PlayerAdded:Connect(function(plr)
        if espEnabled then createPlayerBox(plr) end
        if snaplinesEnabled then createSnapline(plr) end
    end)
    Players.PlayerRemoving:Connect(function(plr)
        removePlayerBox(plr)
        removeSnapline(plr)
    end)
end

-- Misc Tab
do
    local frame = tabs["Misc"]

    local toggleY = 10

    local function addToggleOption(text, onToggle)
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(0.8, -50, 0, 30)
        label.Position = UDim2.new(0, 10, 0, toggleY)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 18
        label.TextColor3 = colors.text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = text

        local switch, getState, setState = createToggleSwitch(frame, toggleY)

        switch.OnToggle = function(state)
            onToggle(state)
        end

        toggleY = toggleY + 45
    end

    local speedEnabled = false
    local jumpEnabled = false
    local invisEnabled = false
    local noclipEnabled = false
    local autoCollectEnabled = false
    local autoHealEnabled = false

    addToggleOption("Speed Hack", function(state)
        speedEnabled = state
        if state then humanoid.WalkSpeed = 30 else humanoid.WalkSpeed = 16 end
    end)

    addToggleOption("Super Jump", function(state)
        jumpEnabled = state
        if state then humanoid.JumpPower = 150 else humanoid.JumpPower = 50 end
    end)

    addToggleOption("Unsichtbarkeit", function(state)
        invisEnabled = state
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = state and 0.8 or 0
            end
        end
    end)

    addToggleOption("No Clip", function(state)
        noclipEnabled = state
    end)

    addToggleOption("Auto Collect Brainrot", function(state)
        autoCollectEnabled = state
    end)

    addToggleOption("Auto Heal", function(state)
        autoHealEnabled = state
    end)

    -- No Clip Loop
    RunService.Stepped:Connect(function()
        if noclipEnabled then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        else
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)

    -- Auto Collect Brainrot
    RunService.Heartbeat:Connect(function()
        if autoCollectEnabled then
            for _, item in pairs(workspace:GetChildren()) do
                if item.Name == "Brainrot" and item:IsA("BasePart") then
                    local dist = (character.HumanoidRootPart.Position - item.Position).Magnitude
                    if dist < 20 then
                        item.CFrame = character.HumanoidRootPart.CFrame
                    end
                end
            end
        end
    end)

    -- Auto Heal (Beispiel: bei weniger als 50 HP heilt automatisch)
    RunService.Heartbeat:Connect(function()
        if autoHealEnabled then
            if humanoid.Health < 50 then
                humanoid.Health = humanoid.Health + 1
            end
        end
    end)
end

-- Best Brainrot Spieler auf Home Tab
do
    local homeFrame = tabs["Home"]
    local bestLabel = Instance.new("TextLabel", homeFrame)
    bestLabel.Size = UDim2.new(1, -20, 0, 40)
    bestLabel.Position = UDim2.new(0, 10, 1, -60)
    bestLabel.BackgroundTransparency = 0.5
    bestLabel.BackgroundColor3 = colors.boxPurple
    bestLabel.TextColor3 = Color3.new(1, 1, 1)
    bestLabel.Font = Enum.Font.GothamBold
    bestLabel.TextSize = 16
    bestLabel.TextWrapped = true
    makeRound(bestLabel, UDim.new(0, 10))

    local function updateBestBrainrot()
        local bestPlayer = nil
        local bestScore = -math.huge

        for _, plr in pairs(Players:GetPlayers()) do
            local leaderstats = plr:FindFirstChild("leaderstats")
            if leaderstats then
                local brainrotScore = leaderstats:FindFirstChild("Brainrot")
                if brainrotScore and brainrotScore.Value > bestScore then
                    bestScore = brainrotScore.Value
                    bestPlayer = plr
                end
            end
        end

        if bestPlayer then
            bestLabel.Text = string.format("Top Brainrot Spieler:\n%s mit %d Brainrot", bestPlayer.Name, bestScore)
        else
            bestLabel.Text = "Top Brainrot Spieler:\nKeine Daten verfügbar"
        end
    end

    updateBestBrainrot()

    Players.PlayerAdded:Connect(updateBestBrainrot)
    Players.PlayerRemoving:Connect(updateBestBrainrot)
    -- Update jede 10 Sekunden
    while true do
        wait(10)
        updateBestBrainrot()
    end
end

-- Fertig!
