-- Roblox ESP & High Jump Menu with Key Input and Neon Design by @vskdeniss

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local correctKey = "VSK-65929"

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeyInputGui"
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- ************** KEY INPUT POPUP ******************

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Visible = true

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Please enter the key:"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24
titleLabel.Parent = frame

local keyBox = Instance.new("TextBox")
keyBox.PlaceholderText = "Your key here"
keyBox.Size = UDim2.new(1, -20, 0, 40)
keyBox.Position = UDim2.new(0, 10, 0, 50)
keyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
keyBox.TextColor3 = Color3.new(1, 1, 1)
keyBox.Font = Enum.Font.SourceSans
keyBox.TextSize = 24
keyBox.ClearTextOnFocus = false
keyBox.Parent = frame
keyBox.Text = ""

local submitButton = Instance.new("TextButton")
submitButton.Text = "Confirm"
submitButton.Size = UDim2.new(1, -20, 0, 40)
submitButton.Position = UDim2.new(0, 10, 0, 100)
submitButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
submitButton.TextColor3 = Color3.new(1, 1, 1)
submitButton.Font = Enum.Font.SourceSansBold
submitButton.TextSize = 24
submitButton.Parent = frame

local errorLabel = Instance.new("TextLabel")
errorLabel.Text = ""
errorLabel.Size = UDim2.new(1, -20, 0, 25)
errorLabel.Position = UDim2.new(0, 10, 0, 145)
errorLabel.TextColor3 = Color3.new(1, 0, 0)
errorLabel.BackgroundTransparency = 1
errorLabel.Font = Enum.Font.SourceSansBold
errorLabel.TextSize = 18
errorLabel.Parent = frame

-- ************** MENU GUI ******************

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 350, 0, 300)
menuFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 50)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = false
menuFrame.Parent = screenGui
menuFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(170, 0, 255)
uiStroke.Thickness = 3
uiStroke.Parent = menuFrame

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 100, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
sidebar.Parent = menuFrame

local uiStrokeSidebar = Instance.new("UIStroke")
uiStrokeSidebar.Color = Color3.fromRGB(150, 0, 230)
uiStrokeSidebar.Thickness = 2
uiStrokeSidebar.Parent = sidebar

local tabs = {"🏠 Home", "👁️ Visual", "🚶 Movement", "⚙️ Misc"}

local selectedTab = nil

local function clearContent()
    for _, child in pairs(menuFrame:GetChildren()) do
        if child.Name == "Content" then
            child:Destroy()
        end
    end
end

local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -100, 1, 0)
contentFrame.Position = UDim2.new(0, 100, 0, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
contentFrame.Parent = menuFrame

local function createTabButton(name, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.Position = UDim2.new(0, 0, 0, (index - 1) * 50)
    btn.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
    btn.TextColor3 = Color3.fromRGB(220, 190, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Text = name
    btn.AutoButtonColor = false
    btn.Parent = sidebar

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(170, 0, 255)
    stroke.Thickness = 2
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
    end)
    btn.MouseLeave:Connect(function()
        if selectedTab ~= btn then
            btn.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if selectedTab then
            selectedTab.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
        end
        selectedTab = btn
        selectedTab.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
        clearContent()
        if name == "🏠 Home" then
            showHome()
        elseif name == "👁️ Visual" then
            showVisual()
        elseif name == "🚶 Movement" then
            showMovement()
        elseif name == "⚙️ Misc" then
            showMisc()
        end
    end)

    return btn
end

-- Create tabs
for i, tabName in ipairs(tabs) do
    createTabButton(tabName, i)
end

-- ********* Notification function ************
local function showNotification(text)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 250, 0, 50)
    notif.Position = UDim2.new(0.5, -125, 0.8, 0)
    notif.BackgroundColor3 = Color3.fromRGB(70, 0, 130)
    notif.TextColor3 = Color3.fromRGB(230, 190, 255)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 24
    notif.Text = text
    notif.BackgroundTransparency = 0.1
    notif.BorderSizePixel = 0
    notif.Parent = screenGui
    notif.AnchorPoint = Vector2.new(0.5, 0.5)

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(170, 0, 255)
    uiStroke.Thickness = 3
    uiStroke.Parent = notif

    -- Fade out after 3 seconds
    spawn(function()
        wait(3)
        for i = 1, 20 do
            notif.TextTransparency = i * 0.05
            notif.BackgroundTransparency = notif.BackgroundTransparency + 0.05
            wait(0.05)
        end
        notif:Destroy()
    end)
end

-- ********** ESP Functions **************

local espEnabled = false
local nameTags = {}

local function createNameTag(player)
    if player == localPlayer then return end
    local head = player.Character and player.Character:FindFirstChild("Head")
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NameTag"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 120, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true

    local textLabel = Instance.new("TextLabel", billboard)
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = player.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 105, 180) -- Pink
    textLabel.TextStrokeColor3 = Color3.fromRGB(120, 0, 80)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = true

    billboard.Parent = head
    return billboard
end

local function addESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") and not nameTags[player] then
            local tag = createNameTag(player)
            nameTags[player] = tag
        end
    end
end

local function removeESP()
    for player, tag in pairs(nameTags) do
        if tag then tag:Destroy() end
    end
    nameTags = {}
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espEnabled then
            wait(1)
            if player.Character and player.Character:FindFirstChild("Head") then
                if not nameTags[player] then
                    local tag = createNameTag(player)
                    nameTags[player] = tag
                end
            end
        end
    end)
end)

-- ********** Home Tab **********

function showHome()
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 80)
    label.Position = UDim2.new(0, 10, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(230, 190, 255)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 32
    label.Text = "✨ Menu created by @vskdeniss ✨"
    label.TextWrapped = true
    label.TextStrokeColor3 = Color3.fromRGB(150, 0, 200)
    label.TextStrokeTransparency = 0
    label.Parent = contentFrame
end

-- ********** Visual Tab **********

function showVisual()
    local espToggle = Instance.new("TextButton")
    espToggle.Size = UDim2.new(0, 150, 0, 50)
    espToggle.Position = UDim2.new(0, 20, 0, 20)
    espToggle.Text = "Toggle ESP"
    espToggle.Font = Enum.Font.GothamBold
    espToggle.TextSize = 22
    espToggle.BackgroundColor3 = Color3.fromRGB(80, 0, 130)
    espToggle.TextColor3 = Color3.fromRGB(255, 192, 203) -- Pink
    espToggle.Parent = contentFrame

    espToggle.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        if espEnabled then
            addESP()
            showNotification("ESP Enabled")
        else
            removeESP()
            showNotification("ESP Disabled")
        end
    end)
end

-- ********** Movement Tab **********

local highJumpEnabled = false
local defaultJumpPower = localPlayer.Character and localPlayer.Character.Humanoid.JumpPower or 50

function showMovement()
    local jumpToggle = Instance.new("TextButton")
    jumpToggle.Size = UDim2.new(0, 150, 0, 50)
    jumpToggle.Position = UDim2.new(0, 20, 0, 20)
    jumpToggle.Text = "Toggle High Jump"
    jumpToggle.Font = Enum.Font.GothamBold
    jumpToggle.TextSize = 22
    jumpToggle.BackgroundColor3 = Color3.fromRGB(80, 0, 130)
    jumpToggle.TextColor3 = Color3.fromRGB(255, 192, 203) -- Pink
    jumpToggle.Parent = contentFrame

    jumpToggle.MouseButton1Click:Connect(function()
        highJumpEnabled = not highJumpEnabled
        local char = localPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if highJumpEnabled then
                    humanoid.JumpPower = 150
                    showNotification("High Jump Enabled")
                else
                    humanoid.JumpPower = 50
                    showNotification("High Jump Disabled")
                end
            end
        end
    end)
end

-- ********** Misc Tab (empty for now) **********

function showMisc()
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 50)
    infoLabel.Position = UDim2.new(0, 10, 0, 20)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(230, 190, 255)
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 24
    infoLabel.Text = "No misc options yet"
    infoLabel.Parent = contentFrame
end

-- ********** Submit Button Logic **********

submitButton.MouseButton1Click:Connect(function()
    if keyBox.Text == correctKey then
        frame.Visible = false
        menuFrame.Visible = true
        -- Auto select Home tab
        sidebar:GetChildren()[1].MouseButton1Click:Fire()
    else
        errorLabel.Text = "Incorrect key, please try again."
        keyBox.Text = ""
    end
end)
