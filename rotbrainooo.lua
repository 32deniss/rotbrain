--[[
  VSK STEAL A BRAINROT MENU
  Theme: Pink & Black
  Features:
    - Key Login System (VSK-XXXXXX)
    - Sidebar: Home, Visual, Misc, Movement
    - Player ESP (Name & ThroughWalls)
    - Lock ESP (Base Lock Timer)
    - Auto Hit (Auto attack)
    - Speed & Super Jump
    - Toggle Buttons neben Funktionen
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

-- Funktion zum Wechseln der Tabs
local function switchTab(name)
    selectedTab = name
    for _, btn in pairs(sidebarButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    end
    for _, btn in pairs(sidebarButtons) do
        if btn.Name == name then
            btn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
        end
    end
    -- Inhalt löschen
    for _, child in pairs(contentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
    -- Inhalte je Tab hinzufügen:
    if name == "Home" then
        local homeTitle = createTextLabel({
            Parent = contentFrame,
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 105, 180),
            Font = Enum.Font.GothamBold,
            TextSize = 30,
            Text = "Welcome to VSK Menu",
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local homeDesc = createTextLabel({
            Parent = contentFrame,
            Size = UDim2.new(1, -20, 0, 80),
            Position = UDim2.new(0, 10, 0, 60),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(230,230,230),
            Font = Enum.Font.Gotham,
            TextSize = 18,
            Text = "This menu supports:\n- Player ESP (Names & Through Walls)\n- Lock ESP (Timer)\n- Auto Hit\n- Speed & Super Jump\n\nCreated by @vskdeniss",
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
        })
    elseif name == "Visual" then
        -- Player ESP toggle
        local espLabel = createTextLabel({
            Parent = contentFrame,
            Size = UDim2.new(0.8, -10, 0, 30),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 105, 180),
            Font = Enum.Font.GothamBold,
            TextSize = 22,
            Text = "Player ESP",
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local playerEspToggle = createToggleButton(contentFrame, UDim2.new(0.82, 0, 0, 10), function(state)
            playerESPEnabled = state
        end)
        
        -- Lock ESP toggle
        local lockLabel = createTextLabel({
            Parent = contentFrame,
            Size = UDim2.new(0.8, -10, 0, 30),
            Position = UDim2.new(0, 10, 0, 60),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 105, 180),
            Font = Enum.Font.GothamBold,
            TextSize = 22,
            Text = "Lock ESP (Timer)",
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local lockEspToggle = createToggleButton(contentFrame, UDim2.new(0.82, 0, 0, 60), function(state)
            lockESPEnabled = state
        end)
        
    elseif name == "Misc" then
        local autoHitLabel = createTextLabel({
            Parent = contentFrame,
            Size = UDim2.new(0.8, -10, 0, 30),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 105, 180),
            Font = Enum.Font.GothamBold,
            TextSize = 22,
            Text = "Auto Hit",
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local autoHitToggle = createToggleButton(contentFrame, UDim2.new(0.82, 0, 0, 10), function(state)
            autoHitEnabled = state
        end)
    elseif name == "Movement" then
        local speedLabel = createTextLabel({
            Parent = contentFrame,
            Size = UDim2.new(0.8, -10, 0, 30),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 105, 180),
            Font = Enum.Font.GothamBold,
            TextSize = 22,
            Text = "Speed",
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local speedToggle = createToggleButton(contentFrame, UDim2.new(0.82, 0, 0, 10), function(state)
            speedEnabled = state
        end)
        
        local superJumpLabel = createTextLabel({
            Parent = contentFrame,
            Size = UDim2.new(0.8, -10, 0, 30),
            Position = UDim2.new(0, 10, 0, 60),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 105, 180),
            Font = Enum.Font.GothamBold,
            TextSize = 22,
            Text = "Super Jump",
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local superJumpToggle = createToggleButton(contentFrame, UDim2.new(0.82, 0, 0, 60), function(state)
            superJumpEnabled = state
        end)
    end
end

-- Sidebar Buttons erstellen
local btnHeight = 60
for i, tab in ipairs(tabs) do
    local btn = createButton({
        Parent = sidebar,
        Name = tab.Name,
        Size = UDim2.new(1, 0, 0, btnHeight),
        Position = UDim2.new(0, 0, 0, (i-1)*btnHeight),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Text = tab.Icon .. "  " .. tab.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        TextColor3 = Color3.fromRGB(255, 105, 180),
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
    })
    createUICorner(btn, UDim.new(0, 10))
    btn.MouseButton1Click:Connect(function()
        switchTab(tab.Name)
    end)
    table.insert(sidebarButtons, btn)
end

switchTab("Home")

-- TOGGLE VARS
local playerESPEnabled = false
local lockESPEnabled = false
local autoHitEnabled = false
local speedEnabled = false
local superJumpEnabled = false

-- ESP IMPLEMENTATION

local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "VSK_ESP_Folder"

local espBoxes = {}

local function createESPForPlayer(targetPlayer)
    if espBoxes[targetPlayer] then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = nil
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Color3 = Color3.fromRGB(255, 105, 180)
    box.Transparency = 0.5
    box.Size = Vector3.new(4, 6, 4)
    box.Parent = espFolder
    
    -- Name Display
    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Adornee = nil
    nameBillboard.Size = UDim2.new(0, 100, 0, 40)
    nameBillboard.AlwaysOnTop = true
    nameBillboard.Parent = espFolder
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 20
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Text = targetPlayer.Name
    nameLabel.Parent = nameBillboard
    
    espBoxes[targetPlayer] = {
        box = box,
        nameGui = nameBillboard,
        nameLabel = nameLabel
    }
end

local function removeESPForPlayer(targetPlayer)
    if espBoxes[targetPlayer] then
        espBoxes[targetPlayer].box:Destroy()
        espBoxes[targetPlayer].nameGui:Destroy()
        espBoxes[targetPlayer] = nil
    end
end

-- ESP Update Loop
RunService.Heartbeat:Connect(function()
    if playerESPEnabled then
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                createESPForPlayer(targetPlayer)
                local esp = espBoxes[targetPlayer]
                esp.box.Adornee = targetPlayer.Character.HumanoidRootPart
                esp.nameGui.Adornee = targetPlayer.Character.HumanoidRootPart
                -- Durch Wände sehen, also AlwaysOnTop true - ist gesetzt
            else
                removeESPForPlayer(targetPlayer)
            end
        end
    else
        -- Alle ESP entfernen
        for plr, _ in pairs(espBoxes) do
            removeESPForPlayer(plr)
        end
    end
end)

-- LOCK ESP (Timer Anzeige)

local lockESPLabels = {}

local function createLockESPForBase(basePart)
    if lockESPLabels[basePart] then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.Adornee = basePart
    billboard.Parent = espFolder
    
    local timerLabel = Instance.new("TextLabel")
    timerLabel.Size = UDim2.new(1, 0, 1, 0)
    timerLabel.BackgroundTransparency = 1
    timerLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
    timerLabel.Font = Enum.Font.GothamBold
    timerLabel.TextSize = 20
    timerLabel.TextStrokeTransparency = 0
    timerLabel.Text = "Lock: 00:00"
    timerLabel.Parent = billboard
    
    lockESPLabels[basePart] = {
        gui = billboard,
        label = timerLabel,
        endTime = tick() + 30 -- Beispiel: 30 Sek Timer
    }
end

local function removeLockESP(basePart)
    if lockESPLabels[basePart] then
        lockESPLabels[basePart].gui:Destroy()
        lockESPLabels[basePart] = nil
    end
end

-- Beispiel-Bases für Lock ESP (hier anpassen)
local baseParts = {} -- Füge deine Base Parts hier ein

-- Update Lock Timer
RunService.Heartbeat:Connect(function()
    if lockESPEnabled then
        for _, base in pairs(baseParts) do
            createLockESPForBase(base)
            local info = lockESPLabels[base]
            local remaining = math.max(0, math.floor(info.endTime - tick()))
            local minutes = math.floor(remaining / 60)
            local seconds = remaining % 60
            info.label.Text = string.format("Lock: %02d:%02d", minutes, seconds)
        end
    else
        for base, _ in pairs(lockESPLabels) do
            removeLockESP(base)
        end
    end
end)

-- AUTO HIT

local autoHitConn

local function startAutoHit()
    if autoHitConn then return end
    autoHitConn = RunService.Heartbeat:Connect(function()
        -- Simuliere Schlagen: 
        -- Hier anpassen für dein Spiel, z.B. RemoteEvent Fire oder Tasten-Simulation
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            -- Beispiel: Humanoid:TakeDamage(5) oder ein Angriff auslösen
            -- Ohne genaue Spiel-API schwer, hier ein Platzhalter
            -- print("Auto Hit tick")
        end
    end)
end

local function stopAutoHit()
    if autoHitConn then
        autoHitConn:Disconnect()
        autoHitConn = nil
    end
end

-- MOVEMENT (Speed & Super Jump)

local normalWalkSpeed = 16
local normalJumpPower = 50

local function setSpeed(enabled)
    if enabled then
        humanoid.WalkSpeed = 30
    else
        humanoid.WalkSpeed = normalWalkSpeed
    end
end

local function setSuperJump(enabled)
    if enabled then
        humanoid.JumpPower = 100
    else
        humanoid.JumpPower = normalJumpPower
    end
end

-- Bind Toggle Vars to Funktion

-- Visual
local function setPlayerESP(state)
    playerESPEnabled = state
end

local function setLockESP(state)
    lockESPEnabled = state
end

-- Misc
local function setAutoHit(state)
    autoHitEnabled = state
    if state then
        startAutoHit()
    else
        stopAutoHit()
    end
end

-- Movement
local function setSpeedEnabled(state)
    speedEnabled = state
    setSpeed(state)
end

local function setSuperJumpEnabled(state)
    superJumpEnabled = state
    setSuperJump(state)
end

-- Login Button Click

submitBtn.MouseButton1Click:Connect(function()
    local key = keyBox.Text:upper()
    if isValidKey(key) then
        errorLabel.Text = ""
        keyBox.Text = ""
        keyFrame.Visible = false
        loadingFrame.Visible = true
        runLoading()
        wait(0.5)
        KeyGui.Enabled = false
        MenuGui.Enabled = true
    else
        errorLabel.Text = "Invalid Key! Format: VSK-XXXXXX"
    end
end)

-- Menü einblenden, wenn Login erfolgreich
-- Der Wechsel der Tabs setzt schon Toggle-Buttons.

-- Tasten zum Öffnen/Schließen des Menüs (z.B. mit RightCtrl)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        MenuGui.Enabled = not MenuGui.Enabled
    end
end)
