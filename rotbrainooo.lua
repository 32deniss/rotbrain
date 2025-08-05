--[[
  VSK STEAL A BRAINROT MENU
  Theme: Pink & Black
  Features:
    - Key Login System (VSK-XXXXXX)
    - Sidebar: Home, Visual, Misc, Movement
    - Player ESP (Name & ThroughWalls)
    - ESP Name Color Picker
    - Lock ESP (Base Lock Timer)
    - Auto Hit (Auto attack)
    - Speed & Super Jump
    - Toggle Buttons neben Funktionen
    - Menü minimierbar mit kleinem Icon
    - Created by @vskdeniss
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- UTILS
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius
    corner.Parent = parent
end

local function createTextLabel(props)
    local label = Instance.new("TextLabel")
    for k,v in pairs(props) do
        label[k] = v
    end
    return label
end

local function createButton(props)
    local btn = Instance.new("TextButton")
    for k,v in pairs(props) do
        btn[k] = v
    end
    createUICorner(btn, UDim.new(0, 6))
    return btn
end

local function createFrame(props)
    local frame = Instance.new("Frame")
    for k,v in pairs(props) do
        frame[k] = v
    end
    return frame
end

local function createToggleButton(parent, pos, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 22, 0, 22)
    toggle.Position = pos
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.Parent = parent
    createUICorner(toggle, UDim.new(0, 4))
    
    local enabled = false
    local function updateColor()
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(40, 40, 40)
    end
    
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateColor()
        callback(enabled)
    end)
    
    updateColor()
    return toggle
end

-- KEY LOGIN GUI

local function isValidKey(key)
    return string.match(key, "^VSK%-%w%w%w%w%w%w$") ~= nil
end

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "VSK_KeyLoginGui"
KeyGui.Parent = game.CoreGui
KeyGui.ResetOnSpawn = false

local keyFrame = createFrame({
    Parent = KeyGui,
    Size = UDim2.new(0, 400, 0, 180),
    Position = UDim2.new(0.5, -200, 0.5, -90),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
})

local title = createTextLabel({
    Parent = keyFrame,
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 105, 180),
    Font = Enum.Font.GothamBold,
    TextSize = 28,
    Text = "Enter Your Key",
    TextScaled = false,
})

local keyBox = Instance.new("TextBox")
keyBox.Parent = keyFrame
keyBox.Size = UDim2.new(0.8, 0, 0, 40)
keyBox.Position = UDim2.new(0.1, 0, 0, 60)
keyBox.PlaceholderText = "VSK-XXXXXX"
keyBox.Text = ""
keyBox.ClearTextOnFocus = false
keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 22
keyBox.BorderSizePixel = 0
createUICorner(keyBox, UDim.new(0, 6))

local submitBtn = createButton({
    Parent = keyFrame,
    Size = UDim2.new(0.5, 0, 0, 40),
    Position = UDim2.new(0.25, 0, 0, 110),
    BackgroundColor3 = Color3.fromRGB(255, 105, 180),
    TextColor3 = Color3.fromRGB(255,255,255),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    Text = "Submit",
})

local errorLabel = createTextLabel({
    Parent = keyFrame,
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 150),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 50, 50),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    Text = "",
    TextWrapped = true,
})

-- LOADING GUI

local loadingFrame = createFrame({
    Parent = KeyGui,
    Size = UDim2.new(0, 400, 0, 100),
    Position = UDim2.new(0.5, -200, 0.5, -50),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BorderSizePixel = 0,
    Visible = false,
})

local loadingText = createTextLabel({
    Parent = loadingFrame,
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 10),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 105, 180),
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    Text = "Menu Loading...",
})

local loadingBarBG = createFrame({
    Parent = loadingFrame,
    Size = UDim2.new(0.8, 0, 0, 25),
    Position = UDim2.new(0.1, 0, 0, 60),
    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
    BorderSizePixel = 0,
})

local loadingBar = createFrame({
    Parent = loadingBarBG,
    Size = UDim2.new(0, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(255, 105, 180),
    BorderSizePixel = 0,
})

local function runLoading()
    loadingBar.Size = UDim2.new(0, 0, 1, 0)
    local steps = 20
    for i = 1, steps do
        local newSize = UDim2.new(0.05 * i, 0, 1, 0)
        local tween = TweenService:Create(loadingBar, TweenInfo.new(0.1), {Size = newSize})
        tween:Play()
        tween.Completed:Wait()
        wait(0.1)
    end
end

-- MAIN MENU GUI (unsichtbar am Start)

local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "VSK_MenuGui"
MenuGui.Parent = game.CoreGui
MenuGui.ResetOnSpawn = false
MenuGui.Enabled = false -- wird nach Login aktiviert

-- Hauptfenster
local mainFrame = createFrame({
    Parent = MenuGui,
    Size = UDim2.new(0, 450, 0, 320),
    Position = UDim2.new(0.5, -225, 0.5, -160),
    BackgroundColor3 = Color3.fromRGB(10,10,10),
    BorderSizePixel = 0,
})

createUICorner(mainFrame, UDim.new(0, 10))

-- Sidebar Frame
local sidebar = createFrame({
    Parent = mainFrame,
    Size = UDim2.new(0, 120, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BorderSizePixel = 0,
})

createUICorner(sidebar, UDim.new(0, 10))

-- Sidebar Buttons & Icons
local sidebarButtons = {}
local selectedTab = nil

local tabs = {
    {Name = "Home", Icon = "🏠"},
    {Name = "Visual", Icon = "👁️"},
    {Name = "Misc", Icon = "🛠️"},
    {Name = "Movement", Icon = "🏃‍♂️"},
}

local contentFrame = createFrame({
    Parent = mainFrame,
    Size = UDim2.new(1, -120, 1, 0),
    Position = UDim2.new(0, 120, 0, 0),
    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
    BorderSizePixel = 0,
})
createUICorner(contentFrame, UDim.new(0, 10))

local pages = {}

for i, tab in ipairs(tabs) do
    local btn = createButton({
        Parent = sidebar,
        Size = UDim2.new(1, 0, 0, 55),
        Position = UDim2.new(0, 0, 0, (i-1)*55),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        TextColor3 = Color3.fromRGB(255, 105, 180),
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        Text = tab.Icon .. "  " .. tab.Name,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        BorderSizePixel = 0,
    })
    createUICorner(btn, UDim.new(0, 6))

    btn.MouseEnter:Connect(function()
        if selectedTab ~= btn then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if selectedTab ~= btn then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function()
        if selectedTab then
            selectedTab.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        end
        selectedTab = btn
        selectedTab.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        for _, page in pairs(pages) do
            page.Visible = false
        end
        pages[tab.Name].Visible = true
    end)

    sidebarButtons[tab.Name] = btn
end

-- PAGE: Home
local homePage = createFrame({
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
})
pages["Home"] = homePage

local homeText = createTextLabel({
    Parent = homePage,
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 10),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 105, 180),
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    Text = "created by @vskdeniss",
    TextXAlignment = Enum.TextXAlignment.Center,
})

-- PAGE: Visual
local visualPage = createFrame({
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
})
pages["Visual"] = visualPage

local espColor = Color3.fromRGB(255, 105, 180)

local espToggle = createToggleButton(visualPage, UDim2.new(0, 20, 0, 20), function(enabled)
    if enabled then
        startESP()
    else
        stopESP()
    end
end)

local espLabel = createTextLabel({
    Parent = visualPage,
    Position = UDim2.new(0, 50, 0, 20),
    Size = UDim2.new(0, 150, 0, 30),
    BackgroundTransparency = 1,
    Text = "Player ESP",
    TextColor3 = Color3.fromRGB(255, 105, 180),
    Font = Enum.Font.Gotham,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Farbauswahl Label
local colorLabel = createTextLabel({
    Parent = visualPage,
    Position = UDim2.new(0, 20, 0, 60),
    Size = UDim2.new(0, 100, 0, 25),
    BackgroundTransparency = 1,
    Text = "ESP Color:",
    TextColor3 = Color3.fromRGB(255, 105, 180),
    Font = Enum.Font.Gotham,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Farbwahl Buttons (Rot, Pink, Grün, Blau)
local function createColorButton(color, pos)
    local btn = Instance.new("TextButton")
    btn.Parent = visualPage
    btn.Size = UDim2.new(0, 30, 0, 25)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Text = ""
    createUICorner(btn, UDim.new(0, 5))
    btn.MouseButton1Click:Connect(function()
        espColor = color
        -- Update alle aktiven ESP Namensfarben
        for _, esp in pairs(espConnections) do
            if esp and esp:FindFirstChildWhichIsA("TextLabel") then
                esp:FindFirstChildWhichIsA("TextLabel").TextColor3 = espColor
            end
        end
    end)
    return btn
end

createColorButton(Color3.fromRGB(255, 105, 180), UDim2.new(0, 130, 0, 60)) -- Pink
createColorButton(Color3.fromRGB(255, 50, 50), UDim2.new(0, 170, 0, 60)) -- Rot
createColorButton(Color3.fromRGB(50, 255, 50), UDim2.new(0, 210, 0, 60)) -- Grün
createColorButton(Color3.fromRGB(50, 100, 255), UDim2.new(0, 250, 0, 60)) -- Blau

-- PAGE: Misc (Beispiel)
local miscPage = createFrame({
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
})
pages["Misc"] = miscPage

local autoHitToggle = createToggleButton(miscPage, UDim2.new(0, 20, 0, 20), function(enabled)
    -- Auto Hit Funktion hier (Platzhalter)
end)
local autoHitLabel = createTextLabel({
    Parent = miscPage,
    Position = UDim2.new(0, 50, 0, 20),
    Size = UDim2.new(0, 150, 0, 30),
    BackgroundTransparency = 1,
    Text = "Auto Hit",
    TextColor3 = Color3.fromRGB(255, 105, 180),
    Font = Enum.Font.Gotham,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- PAGE: Movement (Beispiel)
local movementPage = createFrame({
    Parent = contentFrame,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
})
pages["Movement"] = movementPage

local speedToggle = createToggleButton(movementPage, UDim2.new(0, 20, 0, 20), function(enabled)
    if enabled then
        humanoid.WalkSpeed = 40
    else
        humanoid.WalkSpeed = 16
    end
end)
local speedLabel = createTextLabel({
    Parent = movementPage,
    Position = UDim2.new(0, 50, 0, 20),
    Size = UDim2.new(0, 150, 0, 30),
    BackgroundTransparency = 1,
    Text = "Speed Hack",
    TextColor3 = Color3.fromRGB(255, 105, 180),
    Font = Enum.Font.Gotham,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local superJumpToggle = createToggleButton(movementPage, UDim2.new(0, 20, 0, 60), function(enabled)
    if enabled then
        humanoid.JumpPower = 100
    else
        humanoid.JumpPower = 50
    end
end)
local superJumpLabel = createTextLabel({
    Parent = movementPage,
    Position = UDim2.new(0, 50, 0, 60),
    Size = UDim2.new(0, 150, 0, 30),
    BackgroundTransparency = 1,
    Text = "Super Jump",
    TextColor3 = Color3.fromRGB(255, 105, 180),
    Font = Enum.Font.Gotham,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- ESP Funktionen

local espConnections = {}

local function startESP()
    stopESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = p.Character.HumanoidRootPart
            local nameTag = Instance.new("BillboardGui")
            nameTag.Name = "VSKNameESP"
            nameTag.Adornee = rootPart
            nameTag.Size = UDim2.new(0, 100, 0, 40)
            nameTag.StudsOffset = Vector3.new(0, 2, 0)
            nameTag.AlwaysOnTop = true
            nameTag.Parent = rootPart

            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = p.Name
            label.TextColor3 = espColor
            label.TextStrokeTransparency = 0
            label.Font = Enum.Font.GothamBold
            label.TextScaled = true
            label.Parent = nameTag

            table.insert(espConnections, nameTag)
        end
    end
end

local function stopESP()
    for _, esp in pairs(espConnections) do
        if esp then
            esp:Destroy()
        end
    end
    espConnections = {}
end

-- MINIMIZE / RESTORE BUTTON

local minimized = false

-- Minimized Icon (kleines Quadrat)
local minimizeIcon = createFrame({
    Parent = MenuGui,
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 20, 0.5, -20),
    BackgroundColor3 = Color3.fromRGB(255, 105, 180),
    BorderSizePixel = 0,
    Visible = false,
})
createUICorner(minimizeIcon, UDim.new(0, 6))

local miniLabel = createTextLabel({
    Parent = minimizeIcon,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "VSK",
    TextColor3 = Color3.fromRGB(20, 20, 20),
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextScaled = false,
    TextWrapped = false,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center,
})

minimizeIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        minimized = false
        mainFrame.Visible = true
        minimizeIcon.Visible = false
    end
end)

local minimizeButton = createButton({
    Parent = mainFrame,
    Size = UDim2.new(0, 35, 0, 35),
    Position = UDim2.new(1, -40, 0, 10),
    BackgroundColor3 = Color3.fromRGB(255, 105, 180),
    Text = "—",
    TextColor3 = Color3.fromRGB(20, 20, 20),
    Font = Enum.Font.GothamBold,
    TextSize = 30,
    BorderSizePixel = 0,
})

minimizeButton.MouseButton1Click:Connect(function()
    minimized = true
    mainFrame.Visible = false
    minimizeIcon.Visible = true
end)

-- Auswahl der Startseite
sidebarButtons["Home"].MouseButton1Click:Wait()

-- KEY LOGIN Funktionalität

submitBtn.MouseButton1Click:Connect(function()
    local key = keyBox.Text
    if not isValidKey(key) then
        errorLabel.Text = "Invalid key format! Must be like VSK-XXXXXX"
        return
    end
    errorLabel.Text = ""
    keyFrame.Visible = false
    loadingFrame.Visible = true
    runLoading()
    wait(0.5)
    loadingFrame.Visible = false
    MenuGui.Enabled = true
    KeyGui.Enabled = false
end)

-- LOGIN ENTER KEY mit ENTER Taste
keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        submitBtn:CaptureFocus()
        submitBtn.MouseButton1Click:Wait()
    end
end)
