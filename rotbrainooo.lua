-- VSK BRAINROT V1 LUA MENU for ROBLOX
-- BLUE/BLACK Theme + Speed Hack + Super Jump + UI auto-open

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- UI Creation
local gui = Instance.new("ScreenGui")
gui.Name = "VSK_BRAINROT_V1"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui
gui.Enabled = true -- Menü direkt sichtbar

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 26)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "VSK BRAINROT V1"
title.TextColor3 = Color3.fromRGB(102, 204, 255)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- Speed Button
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(0.9, 0, 0, 40)
speedBtn.Position = UDim2.new(0.05, 0, 0, 40)
speedBtn.BackgroundColor3 = Color3.fromRGB(0, 31, 63)
speedBtn.TextColor3 = Color3.new(1, 1, 1)
speedBtn.Font = Enum.Font.SourceSans
speedBtn.Text = "Toggle Speed"

-- Jump Button
local jumpBtn = Instance.new("TextButton", frame)
jumpBtn.Size = UDim2.new(0.9, 0, 0, 40)
jumpBtn.Position = UDim2.new(0.05, 0, 0, 90)
jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 31, 63)
jumpBtn.TextColor3 = Color3.new(1, 1, 1)
jumpBtn.Font = Enum.Font.SourceSans
jumpBtn.Text = "Toggle Super Jump"

-- Notification function
local function notify(text, color)
    StarterGui:SetCore("SendNotification", {
        Title = "VSK BRAINROT V1",
        Text = text,
        Duration = 3,
        Icon = "rbxassetid://6031071050", -- Default gear icon
        Button1 = "OK"
    })
end

-- Speed logic
local speedEnabled = false
speedBtn.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        humanoid.WalkSpeed = 100
        notify("Speed Activated", Color3.fromRGB(0, 200, 255))
    else
        humanoid.WalkSpeed = 16
        notify("Speed Deactivated", Color3.fromRGB(255, 50, 50))
    end
end)

-- Jump logic
local jumpEnabled = false
jumpBtn.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    if jumpEnabled then
        humanoid.JumpPower = 150
        notify("Super Jump Enabled", Color3.fromRGB(0, 200, 255))
    else
        humanoid.JumpPower = 50
        notify("Super Jump Disabled", Color3.fromRGB(255, 50, 50))
    end
end)

-- Optional: RightShift toggles menu on/off
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
