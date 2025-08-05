-- VSK BRAINROT V1 LUA MENU for ROBLOX
-- Blau/Schwarz Theme + Sidebar mit Icons + Speed + Super Jump + ESP + Misc
-- Created by @vskdeniss

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "VSK_BRAINROT_V1"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 26)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

-- UI Colors
local blue = Color3.fromRGB(0, 122, 255)
local darkBlue = Color3.fromRGB(0, 31, 63)
local lightBlue = Color3.fromRGB(102, 204, 255)
local white = Color3.new(1,1,1)

-- Sidebar Frame
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 100, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = darkBlue

-- Sidebar Buttons Container
local sidebarButtons = {}

-- Content Frame (für Tabs)
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -100, 1, 0)
contentFrame.Position = UDim2.new(0, 100, 0, 0)
contentFrame.BackgroundColor3 = Color3.fromRGB(15,15,40)
contentFrame.BorderSizePixel = 0

-- Function: createSidebarButton
local function createSidebarButton(text, iconText)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.BackgroundColor3 = darkBlue
    btn.BorderSizePixel = 0
    btn.Text = iconText.."  "..text
    btn.TextColor3 = lightBlue
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = blue
        btn.TextColor3 = white
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = darkBlue
        btn.TextColor3 = lightBlue
    end)
    return btn
end

-- Tabs
local tabs = {}

-- Funktion um Tabs zu erstellen
local function createTab(name)
    local frame = Instance.new("ScrollingFrame", contentFrame)
    frame.Name = name
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.ScrollBarThickness = 6
    frame.Visible = false

    -- Layout für Buttons
    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0,10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top

    -- Automatische CanvasSize-Anpassung
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    tabs[name] = frame
    return frame
end

-- Create Sidebar Buttons & Tabs
local sidebarNames = {
    {name = "Home", icon = "🏠"},
    {name = "Visual", icon = "👁️"},
    {name = "Misc", icon = "⚙️"},
}

for i, tabInfo in ipairs(sidebarNames) do
    local btn = createSidebarButton(tabInfo.name, tabInfo.icon)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*50)
    btn.Parent = sidebar
    sidebarButtons[tabInfo.name] = btn
    createTab(tabInfo.name)
end

-- Show Tab Funktion
local currentTab = nil
local function showTab(name)
    if currentTab then
        tabs[currentTab].Visible = false
        sidebarButtons[currentTab].BackgroundColor3 = darkBlue
        sidebarButtons[currentTab].TextColor3 = lightBlue
    end
    currentTab = name
    tabs[name].Visible = true
    sidebarButtons[name].BackgroundColor3 = blue
    sidebarButtons[name].TextColor3 = white
end

-- Sidebar Button Click Verbindung
for name, btn in pairs(sidebarButtons) do
    btn.MouseButton1Click:Connect(function()
        showTab(name)
    end)
end

-- Starte mit Home Tab
showTab("Home")

-- *** Home Tab Content ***
do
    local frame = tabs["Home"]
    local title = Instance.new("TextLabel", frame)
    title.Text = "VSK BRAINROT V1"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 30
    title.TextColor3 = lightBlue
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 40)
    title.TextStrokeColor3 = Color3.new(0,0,0)
    title.TextStrokeTransparency = 0.7
    title.TextYAlignment = Enum.TextYAlignment.Top
    title.Position = UDim2.new(0, 0, 0, 10)

    local desc = Instance.new("TextLabel", frame)
    desc.Text = "Advanced cheat menu for Steal a Brainrot.\n\nCreated by @vskdeniss\n\nFeatures:\n- Speed Hack\n- Super Jump\n- ESP with player names\n- Misc options"
    desc.Font = Enum.Font.SourceSans
    desc.TextSize = 18
    desc.TextColor3 = white
    desc.BackgroundTransparency = 1
    desc.Size = UDim2.new(1, -20, 0, 150)
    desc.Position = UDim2.new(0, 10, 0, 60)
    desc.TextWrapped = true
end

-- *** Visual Tab Content ***
do
    local frame = tabs["Visual"]

    -- ESP toggle
    local espEnabled = false
    local espToggle = Instance.new("TextButton", frame)
    espToggle.Size = UDim2.new(0.8, 0, 0, 40)
    espToggle.BackgroundColor3 = darkBlue
    espToggle.TextColor3 = white
    espToggle.Font = Enum.Font.SourceSansBold
    espToggle.TextSize = 22
    espToggle.Text = "Toggle Player ESP"
    espToggle.AutoButtonColor = false
    espToggle.AnchorPoint = Vector2.new(0.5, 0)
    espToggle.Position = UDim2.new(0.5, 0, 0, 20)

    espToggle.MouseEnter:Connect(function()
        espToggle.BackgroundColor3 = blue
    end)
    espToggle.MouseLeave:Connect(function()
        espToggle.BackgroundColor3 = darkBlue
    end)

    -- Funktion: ESP zeichnen
    local espBoxes = {}

    local function createEspBox(player)
        if espBoxes[player] then return end
        local box = Instance.new("BillboardGui")
        box.Name = "ESP_Box"
        box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        box.Size = UDim2.new(0, 100, 0, 40)
        box.StudsOffset = Vector3.new(0, 2, 0)
        box.AlwaysOnTop = true

        local label = Instance.new("TextLabel", box)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 0, 0) -- Rot
        label.TextStrokeColor3 = Color3.new(0,0,0)
        label.TextStrokeTransparency = 0.5
        label.Font = Enum.Font.SourceSansBold
        label.TextScaled = true
        label.Text = player.Name

        box.Parent = game.CoreGui
        espBoxes[player] = box
    end

    local function removeEspBox(player)
        if espBoxes[player] then
            espBoxes[player]:Destroy()
            espBoxes[player] = nil
        end
    end

    local function updateEsp()
        if not espEnabled then return end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if not espBoxes[plr] then
                    createEspBox(plr)
                end
            else
                removeEspBox(plr)
            end
        end
    end

    espToggle.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        if espEnabled then
            espToggle.Text = "Disable Player ESP"
            updateEsp()
        else
            espToggle.Text = "Enable Player ESP"
            for _, box in pairs(espBoxes) do
                box:Destroy()
            end
            espBoxes = {}
        end
    end)

    -- Update ESP regelmäßig
    game:GetService("RunService").RenderStepped:Connect(function()
        if espEnabled then
            updateEsp()
        end
    end)
end

-- *** Misc Tab Content ***
do
    local frame = tabs["Misc"]

    -- Speed Toggle
    local speedEnabled = false
    local speedBtn = Instance.new("TextButton", frame)
    speedBtn.Size = UDim2.new(0.8, 0, 0, 40)
    speedBtn.BackgroundColor3 = darkBlue
    speedBtn.TextColor3 = white
    speedBtn.Font = Enum.Font.SourceSansBold
    speedBtn.TextSize = 22
    speedBtn.Text = "Toggle Speed Hack"
    speedBtn.AutoButtonColor = false
    speedBtn.AnchorPoint = Vector2.new(0.5, 0)
    speedBtn.Position = UDim2.new(0.5, 0, 0, 20)

    speedBtn.MouseEnter:Connect(function()
        speedBtn.BackgroundColor3 = blue
    end)
    speedBtn.MouseLeave:Connect(function()
        speedBtn.BackgroundColor3 = darkBlue
    end)

    speedBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        if speedEnabled then
            humanoid.WalkSpeed = 100
            speedBtn.Text = "Disable Speed Hack"
            StarterGui:SetCore("SendNotification", {
                Title = "VSK BRAINROT V1",
                Text = "Speed Hack Enabled",
                Duration = 3,
                Icon = "rbxassetid://6031071050"
            })
        else
            humanoid.WalkSpeed = 16
            speedBtn.Text = "Enable Speed Hack"
            StarterGui:SetCore("SendNotification", {
                Title = "VSK BRAINROT V1",
                Text = "Speed Hack Disabled",
                Duration = 3,
                Icon = "rbxassetid://6031071050"
            })
        end
    end)

    -- Super Jump Toggle
    local jumpEnabled = false
    local jumpBtn = Instance.new("TextButton", frame)
    jumpBtn.Size = UDim2.new(0.8, 0, 0, 40)
    jumpBtn.BackgroundColor3 = darkBlue
    jumpBtn.TextColor3 = white
    jumpBtn.Font = Enum.Font.SourceSansBold
    jumpBtn.TextSize = 22
    jumpBtn.Text = "Toggle Super Jump"
    jumpBtn.AutoButtonColor = false
    jumpBtn.AnchorPoint = Vector2.new(0.5, 0)
    jumpBtn.Position = UDim2.new(0.5, 0, 0, 80)

    jumpBtn.MouseEnter:Connect(function()
        jumpBtn.BackgroundColor3 = blue
    end)
    jumpBtn.MouseLeave:Connect(function()
        jumpBtn.BackgroundColor3 = darkBlue
    end)

    jumpBtn.MouseButton1Click:Connect(function()
        jumpEnabled = not jumpEnabled
        if jumpEnabled then
            humanoid.JumpPower = 150
            jumpBtn.Text = "Disable Super Jump"
            StarterGui:SetCore("SendNotification", {
                Title = "VSK BRAINROT V1",
                Text = "Super Jump Enabled",
                Duration = 3,
                Icon = "rbxassetid://6031071050"
            })
        else
            humanoid.JumpPower = 50
            jumpBtn.Text = "Enable Super Jump"
            StarterGui:SetCore("SendNotification", {
                Title = "VSK BRAINROT V1",
                Text = "Super Jump Disabled",
                Duration = 3,
                Icon = "rbxassetid://6031071050"
            })
        end
    end)

    -- Invisibility Toggle
    local invisEnabled = false
    local invisBtn = Instance.new("TextButton", frame)
    invisBtn.Size = UDim2.new(0.8, 0, 0, 40)
    invisBtn.BackgroundColor3 = darkBlue
    invisBtn.TextColor3 = white
    invisBtn.Font = Enum.Font.SourceSansBold
    invisBtn.TextSize = 22
    invisBtn.Text = "Toggle Invisibility"
    invisBtn.AutoButtonColor = false
    invisBtn.AnchorPoint = Vector2.new(0.5, 0)
    invisBtn.Position = UDim2.new(0.5, 0, 0, 140)

    invisBtn.MouseEnter:Connect(function()
        invisBtn.BackgroundColor3 = blue
    end)
    invisBtn.MouseLeave:Connect(function()
        invisBtn.BackgroundColor3 = darkBlue
    end)

    invisBtn.MouseButton1Click:Connect(function()
        invisEnabled = not invisEnabled
        if invisEnabled then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.8
                end
            end
            invisBtn.Text = "Disable Invisibility"
            StarterGui:SetCore("SendNotification", {
                Title = "VSK BRAINROT V1",
                Text = "Invisibility Enabled",
                Duration = 3,
                Icon = "rbxassetid://6031071050"
            })
        else
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
            invisBtn.Text = "Enable Invisibility"
            StarterGui:SetCore("SendNotification", {
                Title = "VSK BRAINROT V1",
                Text = "Invisibility Disabled",
                Duration = 3,
                Icon = "rbxassetid://6031071050"
            })
        end
    end)
end

-- Toggle Menu mit RightShift
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed then
        gui.Enabled = not gui.Enabled
    end
end)

-- Menü anfangs sichtbar
gui.Enabled = true
