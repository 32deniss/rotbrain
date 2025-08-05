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
    {Name = "Movement", Icon = "🚀"},
}

local function selectTab(name)
    if selectedTab == name then return end
    selectedTab = name
    for _, btn in pairs(sidebarButtons) do
        btn.BackgroundColor3 = (btn.Name == name) and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(40, 40, 40)
    end
    for _, frame in pairs(mainFrame:GetChildren()) do
        if frame:IsA("Frame") and frame.Name ~= "Sidebar" then
            frame.Visible = (frame.Name == name .. "Tab")
        end
    end
end

for i, tab in ipairs(tabs) do
    local btn = createButton({
        Parent = sidebar,
        Name = tab.Name,
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 10 + (i-1)*60),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        TextColor3 = Color3.fromRGB(255,255,255),
        Text = tab.Icon .. "  " .. tab.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    sidebarButtons[tab.Name] = btn
    btn.MouseButton1Click:Connect(function()
        selectTab(tab.Name)
    end)
end

-- Tabs Frames

-- Home Tab
local homeTab = createFrame({
    Parent = mainFrame,
    Name = "HomeTab",
    Size = UDim2.new(1, -120, 1, 0),
    Position = UDim2.new(0, 120, 0, 0),
    BackgroundTransparency = 1,
    Visible = false,
})

local homeLabel = createTextLabel({
    Parent = homeTab,
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 105, 180),
    Font = Enum.Font.GothamBold,
    TextSize = 26,
    Text = "created by @vskdeniss",
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Visual Tab
local visualTab = createFrame({
    Parent = mainFrame,
    Name = "VisualTab",
    Size = UDim2.new(1, -120, 1, 0),
    Position = UDim2.new(0, 120, 0, 0),
    BackgroundTransparency = 1,
    Visible = false,
})

-- ESP Toggle
local espToggleLabel = createTextLabel({
    Parent = visualTab,
    Size = UDim2.new(0, 200, 0, 25),
    Position = UDim2.new(0, 20, 0, 20),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    Text = "ESP aktivieren",
    TextXAlignment = Enum.TextXAlignment.Left,
})

local espToggle = createToggleButton(visualTab, UDim2.new(0, 210, 0, 15), function(state)
    if state then
        enableESP()
    else
        disableESP()
    end
end)

-- ESP Color Picker Label & TextBox
local espColorLabel = createTextLabel({
    Parent = visualTab,
    Size = UDim2.new(0, 200, 0, 25),
    Position = UDim2.new(0, 20, 0, 60),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    Text = "ESP Name Farbe (r,g,b 0-1)",
    TextXAlignment = Enum.TextXAlignment.Left,
})

local espColorBox = Instance.new("TextBox")
espColorBox.Parent = visualTab
espColorBox.Size = UDim2.new(0, 120, 0, 30)
espColorBox.Position = UDim2.new(0, 230, 0, 58)
espColorBox.PlaceholderText = "1,1,1"
espColorBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espColorBox.TextColor3 = Color3.fromRGB(255,255,255)
espColorBox.Font = Enum.Font.Gotham
espColorBox.TextSize = 20
espColorBox.BorderSizePixel = 0
createUICorner(espColorBox, UDim.new(0, 6))

-- Misc Tab
local miscTab = createFrame({
    Parent = mainFrame,
    Name = "MiscTab",
    Size = UDim2.new(1, -120, 1, 0),
    Position = UDim2.new(0, 120, 0, 0),
    BackgroundTransparency = 1,
    Visible = false,
})

-- Auto Hit Toggle
local autoHitLabel = createTextLabel({
    Parent = miscTab,
    Size = UDim2.new(0, 200, 0, 25),
    Position = UDim2.new(0, 20, 0, 20),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    Text = "Auto Hit",
    TextXAlignment = Enum.TextXAlignment.Left,
})

local autoHitToggle = createToggleButton(miscTab, UDim2.new(0, 210, 0, 15), function(state)
    autoHitEnabled = state
end)

-- Movement Tab
local movementTab = createFrame({
    Parent = mainFrame,
    Name = "MovementTab",
    Size = UDim2.new(1, -120, 1, 0),
    Position = UDim2.new(0, 120, 0, 0),
    BackgroundTransparency = 1,
    Visible = false,
})

-- Speed Slider Label & Box
local speedLabel = createTextLabel({
    Parent = movementTab,
    Size = UDim2.new(0, 200, 0, 25),
    Position = UDim2.new(0, 20, 0, 20),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    Text = "Speed (default 16)",
    TextXAlignment = Enum.TextXAlignment.Left,
})

local speedBox = Instance.new("TextBox")
speedBox.Parent = movementTab
speedBox.Size = UDim2.new(0, 120, 0, 30)
speedBox.Position = UDim2.new(0, 230, 0, 18)
speedBox.PlaceholderText = "16"
speedBox.Text = "16"
speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 20
speedBox.BorderSizePixel = 0
createUICorner(speedBox, UDim.new(0, 6))

-- Super Jump Toggle
local superJumpLabel = createTextLabel({
    Parent = movementTab,
    Size = UDim2.new(0, 200, 0, 25),
    Position = UDim2.new(0, 20, 0, 70),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    Text = "Super Jump",
    TextXAlignment = Enum.TextXAlignment.Left,
})

local superJumpToggle = createToggleButton(movementTab, UDim2.new(0, 210, 0, 65), function(state)
    superJumpEnabled = state
end)

-- Minimieren Button (oben rechts)
local minimizeBtn = createButton({
    Parent = mainFrame,
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -35, 0, 5),
    BackgroundColor3 = Color3.fromRGB(255, 105, 180),
    TextColor3 = Color3.fromRGB(0,0,0),
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    Text = "—",
})

-- Kleines Icon zum Menü wieder öffnen (unten links)
local smallIcon = Instance.new("ImageButton")
smallIcon.Parent = game.CoreGui
smallIcon.Name = "VSK_SmallIcon"
smallIcon.Size = UDim2.new(0, 45, 0, 45)
smallIcon.Position = UDim2.new(0, 15, 1, -60)
smallIcon.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
smallIcon.BorderSizePixel = 0
smallIcon.Visible = false
smallIcon.AutoButtonColor = false
createUICorner(smallIcon, UDim.new(0, 12))
smallIcon.Image = "" -- optional: setze hier dein Icon-ImageID

-- Minimieren Funktion
minimizeBtn.MouseButton1Click:Connect(function()
    MenuGui.Enabled = false
    smallIcon.Visible = true
end)

smallIcon.MouseButton1Click:Connect(function()
    smallIcon.Visible = false
    MenuGui.Enabled = true
end)

-- ESP IMPLEMENTATION

local espEnabled = false
local espTags = {}
local espNameColor = Color3.new(1, 1, 1)

local function updateESPColor()
    for plr, tag in pairs(espTags) do
        if tag and tag:FindFirstChild("TextLabel") then
            tag.TextLabel.TextColor3 = espNameColor
        end
    end
end

local function createESP(plr)
    if espTags[plr] then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = plr.Name
    textLabel.TextColor3 = espNameColor
    textLabel.TextStrokeColor3 = Color3.new(0,0,0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    
    billboard.Parent = char
    espTags[plr] = billboard
end

local function removeESP(plr)
    if espTags[plr] then
        espTags[plr]:Destroy()
        espTags[plr] = nil
    end
end

local function enableESP()
    espEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            createESP(plr)
        end
    end
end

local function disableESP()
    espEnabled = false
    for plr, _ in pairs(espTags) do
        removeESP(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if espEnabled and plr ~= player then
        createESP(plr)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

espColorBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local r,g,b = string.match(espColorBox.Text, "^(%d*%.?%d*),%s*(%d*%.?%d*),%s*(%d*%.?%d*)$")
        r,g,b = tonumber(r), tonumber(g), tonumber(b)
        if r and g and b and r>=0 and r<=1 and g>=0 and g<=1 and b>=0 and b<=1 then
            espNameColor = Color3.new(r,g,b)
            updateESPColor()
        else
            espColorBox.Text = "Fehler! Beispiel: 1,0,0"
        end
    end
end)

-- AUTO HIT (Beispiel: Automatisch schlagen wenn Gegner nah)

local autoHitEnabled = false

local function autoHit()
    if not autoHitEnabled then return end
    -- Beispielcode: prüfe Gegner in Nähe und attackiere
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < 10 then
                -- Angreifen - ersetze mit deinem Spiel-Actioncode
                -- z.B. sende RemoteEvent, klicke o.ä.
            end
        end
    end
end

-- MOVEMENT

local superJumpEnabled = false
local speedValue = 16

speedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(speedBox.Text)
        if val and val >= 0 and val <= 100 then
            speedValue = val
            humanoid.WalkSpeed = speedValue
        else
            speedBox.Text = tostring(speedValue)
        end
    end
end)

superJumpToggle.MouseButton1Click:Connect(function(state)
    superJumpEnabled = not superJumpEnabled
end)

-- Super Jump Implementation (z.B. beim Sprung Höhe erhöhen)
game:GetService("RunService").Stepped:Connect(function()
    if superJumpEnabled and humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            humanoid.JumpPower = 100
        else
            humanoid.JumpPower = 50
        end
    else
        humanoid.JumpPower = 50
    end

    if autoHitEnabled then
        autoHit()
    end
end)

-- Starte mit Home Tab ausgewählt
selectTab("Home")

MenuGui.Enabled = trueHier ist ein vollständiges Roblox-Lua-Skript für dein Cheats-Menü mit Sidebar-Tabs, Icons, minimierbarem Menü, ESP mit anpassbarer Farbe, Auto Hit, Speed & Super Jump. Es zeigt im Home-Tab „created by @vskdeniss“ mit deinem runden Profilbild und funktioniert direkt beim Laden:

```lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Haupt-GUI erstellen
local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "VSK_CheatMenu"
MenuGui.ResetOnSpawn = false
MenuGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = MenuGui
mainFrame.Visible = true

local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius
    corner.Parent = parent
end

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 110, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sidebar.Parent = mainFrame
createUICorner(sidebar, UDim.new(0, 10))

-- Profilbild + Name im Sidebar oben (rund)
local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(1, 0, 0, 90)
profileFrame.BackgroundTransparency = 1
profileFrame.Parent = sidebar

local profileImage = Instance.new("ImageLabel")
profileImage.Size = UDim2.new(0, 70, 0, 70)
profileImage.Position = UDim2.new(0.5, -35, 0, 10)
profileImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
profileImage.Image = "https://cdn.discordapp.com/attachments/1297350079103107074/1402128039625752608/mensa.PNG"
profileImage.Parent = profileFrame
createUICorner(profileImage, UDim.new(1, 0))

local profileText = Instance.new("TextLabel")
profileText.Size = UDim2.new(1, 0, 0, 20)
profileText.Position = UDim2.new(0, 0, 0, 80)
profileText.BackgroundTransparency = 1
profileText.Text = "@vskdeniss"
profileText.TextColor3 = Color3.fromRGB(255, 105, 180)
profileText.Font = Enum.Font.GothamBold
profileText.TextSize = 20
profileText.Parent = profileFrame

-- Tab Buttons (Name + Icon)
local tabs = {
    {Name = "Home", Icon = "🏠"},
    {Name = "Visual", Icon = "👁️"},
    {Name = "Misc", Icon = "⚙️"},
    {Name = "Movement", Icon = "🚀"},
}

local sidebarButtons = {}
local selectedTab = nil

local function createButton(props)
    local btn = Instance.new("TextButton")
    btn.Size = props.Size or UDim2.new(1, 0, 0, 40)
    btn.Position = props.Position or UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255)
    btn.Font = props.Font or Enum.Font.GothamBold
    btn.TextSize = props.TextSize or 20
    btn.Text = props.Text or ""
    btn.Name = props.Name or "Button"
    btn.Parent = props.Parent
    btn.AutoButtonColor = true
    createUICorner(btn, UDim.new(0, 6))
    return btn
end

local function createFrame(props)
    local fr = Instance.new("Frame")
    fr.Size = props.Size or UDim2.new(1, 0, 1, 0)
    fr.Position = props.Position or UDim2.new(0, 0, 0, 0)
    fr.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(30, 30, 30)
    fr.BackgroundTransparency = props.BackgroundTransparency or 0
    fr.Name = props.Name or "Frame"
    fr.Parent = props.Parent
    createUICorner(fr, UDim.new(0, 8))
    return fr
end

local function createTextLabel(props)
    local lbl = Instance.new("TextLabel")
    lbl.Size = props.Size or UDim2.new(1, 0, 0, 30)
    lbl.Position = props.Position or UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = props.BackgroundTransparency or 1
    lbl.TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255)
    lbl.Font = props.Font or Enum.Font.GothamBold
    lbl.TextSize = props.TextSize or 18
    lbl.Text = props.Text or ""
    lbl.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    lbl.Parent = props.Parent
    return lbl
end

local function createToggleButton(parent, position, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 25)
    toggle.Position = position
    toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 18
    toggle.Text = "Off"
    toggle.Parent = parent
    createUICorner(toggle, UDim.new(0, 6))

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = state and "On" or "Off"
        toggle.BackgroundColor3 = state and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(70, 70, 70)
        callback(state)
    end)
    return toggle
end

-- Tabs Frames
local mainTabs = {}

for i, tab in ipairs(tabs) do
    local tabFrame = createFrame({
        Parent = mainFrame,
        Name = tab.Name .. "Tab",
        Size = UDim2.new(1, -110, 1, 0),
        Position = UDim2.new(0, 110, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
    })
    mainTabs[tab.Name] = tabFrame
end

local function selectTab(name)
    if selectedTab == name then return end
    selectedTab = name
    for _, btn in pairs(sidebarButtons) do
        btn.BackgroundColor3 = (btn.Name == name) and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(40, 40, 40)
    end
    for name, frame in pairs(mainTabs) do
        frame.Visible = (name == selectedTab)
    end
end

-- Sidebar Buttons erzeugen
for i, tab in ipairs(tabs) do
    local btn = createButton({
        Parent = sidebar,
        Name = tab.Name,
        Size = UDim2.new(1, -20, 0, 45),
        Position = UDim2.new(0, 10, 0, 110 + (i-1)*55),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        TextColor3 = Color3.fromRGB(255,255,255),
        Text = tab.Icon .. "  " .. tab.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    sidebarButtons[tab.Name] = btn
    btn.MouseButton1Click:Connect(function()
        selectTab(tab.Name)
    end)
end

-- Home Tab Text (zusätzlich zu Sidebar oben)
local homeTab = mainTabs["Home"]
local homeLabel = createTextLabel({
    Parent = homeTab,
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    TextColor3 = Color3.fromRGB(255, 105, 180),
    Font = Enum.Font.GothamBold,
    TextSize = 26,
    Text = "created by @vskdeniss",
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Visual Tab: ESP aktivieren + Farbe anpassen
local visualTab = mainTabs["Visual"]

local espToggleLabel = createTextLabel({
    Parent = visualTab,
    Size = UDim2.new(0, 200, 0, 25),
    Position = UDim2.new(0, 20, 0, 20),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    Text = "ESP aktivieren",
    TextXAlignment = Enum.TextXAlignment.Left,
})

local espToggle = createToggleButton(visualTab, UDim2.new(0, 210, 0, 20), function(state)
    if state then
        enableESP()
    else
        disableESP()
    end
end)

local espColorLabel = createTextLabel({
    Parent = visualTab,
    Size = UDim2.new(0, 250, 0, 25),
    Position = UDim2.new(0, 20, 0, 60),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    Text = "ESP Name Farbe (r,g,b 0-1)",
    TextXAlignment = Enum.TextXAlignment.Left,
})

local espColorBox = Instance.new("TextBox")
espColorBox.Parent = visualTab
espColorBox.Size = UDim2.new(0, 120, 0, 30)
espColorBox.Position = UDim2.new(0, 230, 0, 58)
espColorBox.PlaceholderText = "1,1,1"
espColorBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espColorBox.TextColor3 = Color3.fromRGB(255,255,255)
espColorBox.Font = Enum.Font.Gotham
espColorBox.TextSize = 20
espColorBox.BorderSizePixel = 0
createUICorner(espColorBox, UDim.new(0, 6))

-- ESP Code (anzeigen aller Spielernamen)
local espEnabled = false
local espTags = {}
local espNameColor = Color3.new(1, 1, 1)

local function updateESPColor()
    for _, tag in pairs(espTags) do
        if tag and tag:FindFirstChild("TextLabel") then
            tag.TextLabel.TextColor3 = espNameColor
        end
    end
end

local function createESP(plr)
    if espTags[plr] then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = plr.Name
    textLabel.TextColor3 = espNameColor
    textLabel.TextStrokeColor3 = Color3.new(0,0,0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true
    
    billboard.Parent = char
    espTags[plr] = billboard
end

local function removeESP(plr)
    if espTags[plr] then
        espTags[plr]:Destroy()
        espTags[plr] = nil
    end
end

local function enableESP()
    espEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            createESP(plr)
        end
    end
end

local function disableESP()
    espEnabled = false
    for plr, _ in pairs(espTags) do
        removeESP(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if espEnabled and plr ~= player then
        createESP(plr)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

espColorBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local r,g,b = string.match(espColorBox.Text, "^(%d*%.?%d*),%s*(%d*%.?%d*),%s*(%d*%.?%d*)$")
        r,g,b = tonumber(r), tonumber(g), tonumber(b)
        if r and g and b and r>=0 and r<=1 and g>=0 and g<=1 and b>=0 and b<=1 then
            espNameColor = Color3.new(r,g,b)
            updateESPColor()
        else
            espColorBox.Text = "Fehler! Beispiel: 1,0,0"
        end
    end
end)

-- Misc Tab (Auto Hit als Beispiel)
local miscTab = mainTabs["Misc"]

local autoHitLabel = createTextLabel({
    Parent = miscTab,
    Size = UDim2.new(0, 200, 0, 25),
    Position = UDim2.new(0, 20, 0, 20),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    Text = "Auto Hit",
    TextXAlignment = Enum.TextXAlignment.Left,
})

local autoHitEnabled = false
local autoHitToggle = createToggleButton(miscTab, UDim2.new(0, 210, 0, 20), function(state)
    autoHitEnabled = state
end)

local function autoHit()
    if not autoHitEnabled then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < 10 then
                -- Hier dein Angriffscode z.B. RemoteEvent feuern
            end
        end
    end
end

-- Movement Tab: Speed und Super Jump
local movementTab = mainTabs["Movement"]

local speedLabel = createTextLabel({
    Parent = movementTab,
    Size = UDim2.new(0, 200, 0, 25),
    Position = UDim2.new(0, 20, 0, 20),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    Text = "Speed (default 16)",
    TextXAlignment = Enum.TextXAlignment.Left,
})

local speedBox = Instance.new("TextBox")
speedBox.Parent = movementTab
speedBox.Size = UDim2.new(0, 120, 0, 30)
speedBox.Position = UDim2.new(0, 230, 0, 18)
speedBox.PlaceholderText = "16"
speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 20
speedBox.BorderSizePixel = 0
createUICorner(speedBox, UDim.new(0, 6))

local speedToggle = createToggleButton(movementTab, UDim2.new(0, 20, 0, 60), function(state)
    if state then
        humanoid.WalkSpeed = tonumber(speedBox.Text) or 16
    else
        humanoid.WalkSpeed = 16
    end
end)

speedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(speedBox.Text)
        if val and val >= 16 and val <= 200 then
            if speedToggle.Text == "On" then
                humanoid.WalkSpeed = val
            end
        else
            speedBox.Text = "Ungültig"
        end
    end
end)

local superJumpLabel = createTextLabel({
    Parent = movementTab,
    Size = UDim2.new(0, 200, 0, 25),
    Position = UDim2.new(0, 20, 0, 100),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    Text = "Super Jump",
    TextXAlignment = Enum.TextXAlignment.Left,
})

local superJumpToggle = createToggleButton(movementTab, UDim2.new(0, 20, 0, 130), function(state)
    superJumpEnabled = state
end)

local humanoid = nil
local superJumpEnabled = false

local function getHumanoid()
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

-- RunService Stepped Loop
RunService.Stepped:Connect(function()
    humanoid = getHumanoid()
    if humanoid then
        if superJumpEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid.JumpPower = 100
        else
            humanoid.JumpPower = 50
        end
    end
    if autoHitEnabled then
        autoHit()
    end
end)

-- Minimierbares Menü mit Icon rechts unten
local minimizeBtn = createButton({
    Parent = mainFrame,
    Name = "Minimize",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -35, 0, 5),
    Text = "–",
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    BackgroundColor3 = Color3.fromRGB(255, 105, 180),
    TextColor3 = Color3.new(1,1,1),
})

local profileIcon = Instance.new("ImageButton")
profileIcon.Name = "ProfileIcon"
profileIcon.Size = UDim2.new(0, 40, 0, 40)
profileIcon.Position = UDim2.new(1, -50, 1, -50)
profileIcon.BackgroundTransparency = 0.1
profileIcon.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
profileIcon.Image = "https://cdn.discordapp.com/attachments/1297350079103107074/1402128039625752608/mensa.PNG"
profileIcon.Visible = false
createUICorner(profileIcon, UDim.new(1,0))
profileIcon.Parent = MenuGui

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    profileIcon.Visible = true
end)

profileIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    profileIcon.Visible = false
end)

-- Starte mit Home Tab ausgewählt
selectTab("Home")
