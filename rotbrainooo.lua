-- VSK BRAINROT V1 MENU for Roblox "Steal a Brainrot"
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/32deniss/rotbrain/refs/heads/main/rotbrainooo.lua"))()

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "VSK_BRAINROT_GUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 45)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BRAINROT"
Title.TextColor3 = Color3.fromRGB(102, 204, 255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

-- Tabs
local tabs = {}
local currentTab = nil

local function createTab(name)
    local tabBtn = Instance.new("TextButton", Sidebar)
    tabBtn.Size = UDim2.new(1, 0, 0, 30)
    tabBtn.BackgroundColor3 = Color3.fromRGB(0, 20, 50)
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.new(1,1,1)

    local tabFrame = Instance.new("Frame", MainFrame)
    tabFrame.Size = UDim2.new(1, -120, 1, 0)
    tabFrame.Position = UDim2.new(0, 120, 0, 0)
    tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    tabFrame.Visible = false

    tabBtn.MouseButton1Click:Connect(function()
        if currentTab then currentTab.Visible = false end
        tabFrame.Visible = true
        currentTab = tabFrame
    end)

    tabs[name] = tabFrame
end

createTab("Visual")
createTab("Movement")
createTab("Misc")

-- Auto show first tab
tabs["Visual"].Visible = true
currentTab = tabs["Visual"]

-- Add Buttons
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, (#parent:GetChildren()-1)*45 + 10)
    btn.BackgroundColor3 = Color3.fromRGB(0, 31, 63)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.TextScaled = true
    btn.MouseButton1Click:Connect(callback)
end

-- Visual Tab
createButton(tabs["Visual"], "ESP (Red Names)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local billboard = Instance.new("BillboardGui", p.Character.Head)
            billboard.Size = UDim2.new(0,100,0,40)
            billboard.AlwaysOnTop = true
            local nameLabel = Instance.new("TextLabel", billboard)
            nameLabel.Size = UDim2.new(1, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = p.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            nameLabel.TextScaled = true
        end
    end
end)

-- Movement Tab
local speedOn = false
createButton(tabs["Movement"], "Toggle Speed", function()
    speedOn = not speedOn
    Humanoid.WalkSpeed = speedOn and 100 or 16
    StarterGui:SetCore("SendNotification", {
        Title = "Speed",
        Text = speedOn and "Speed ON" or "Speed OFF",
        Duration = 2
    })
end)

local jumpOn = false
createButton(tabs["Movement"], "Toggle Super Jump", function()
    jumpOn = not jumpOn
    Humanoid.JumpPower = jumpOn and 150 or 50
    StarterGui:SetCore("SendNotification", {
        Title = "Jump",
        Text = jumpOn and "Super Jump ON" or "Super Jump OFF",
        Duration = 2
    })
end)

-- Misc Tab
createButton(tabs["Misc"], "Fly (F Key)", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/YWwFmj9p"))()
end)

createButton(tabs["Misc"], "Invisibility", function()
    local head = LocalPlayer.Character:FindFirstChild("Head")
    if head then
        head.Transparency = 1
    end
end)

-- Credit
local credit = Instance.new("TextLabel", MainFrame)
credit.Size = UDim2.new(0, 200, 0, 20)
credit.Position = UDim2.new(1, -200, 1, -25)
credit.BackgroundTransparency = 1
credit.Text = "created by @vskdeniss"
credit.TextColor3 = Color3.fromRGB(100, 100, 255)
credit.TextScaled = true
credit.Font = Enum.Font.Code

-- UI toggle key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
