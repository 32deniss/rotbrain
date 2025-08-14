--[[
  Name-ESP mit Menü (LocalScript)
  - Menü erscheint beim Start
  - Buttons: "ESP AN" / "ESP AUS"
  - Hotkey: "M" zum Menü ein-/ausblenden
  - Zeigt Spielernamen über Köpfen (BillboardGui)
  - Nur Roblox-APIs (für eigene Spiele / mit Erlaubnis verwenden)
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

-- === Konfig ===
local HOTKEY_TOGGLE_MENU = Enum.KeyCode.M
local LABEL_OFFSET = Vector3.new(0, 2.5, 0)
local LABEL_SIZE = UDim2.new(0, 200, 0, 40)

-- === State ===
local ESP_ENABLED = false
local espStore = {} -- [Character] = BillboardGui
local ui = nil      -- ScreenGui Referenz

-- === UI erstellen ===
local function createUI()
	local screen = Instance.new("ScreenGui")
	screen.Name = "ESP_Menu"
	screen.ResetOnSpawn = false

	local frame = Instance.new("Frame")
	frame.Name = "Panel"
	frame.AnchorPoint = Vector2.new(0.5, 0)
	frame.Position = UDim2.new(0.5, 0, 0.1, 0)
	frame.Size = UDim2.new(0, 260, 0, 140)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Parent = screen
	-- Rundung
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = frame

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -20, 0, 36)
	title.Position = UDim2.new(0, 10, 0, 8)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextSize = 20
	title.Text = "ESP Menü"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = frame

	local status = Instance.new("TextLabel")
	status.Name = "Status"
	status.Size = UDim2.new(1, -20, 0, 24)
	status.Position = UDim2.new(0, 10, 0, 44)
	status.BackgroundTransparency = 1
	status.Font = Enum.Font.Gotham
	status.TextSize = 16
	status.Text = "Status: AUS"
	status.TextColor3 = Color3.fromRGB(220, 220, 220)
	status.TextXAlignment = Enum.TextXAlignment.Left
	status.Parent = frame

	local btnOn = Instance.new("TextButton")
	btnOn.Name = "BtnOn"
	btnOn.Size = UDim2.new(0.45, -10, 0, 40)
	btnOn.Position = UDim2.new(0.05, 0, 0, 80)
	btnOn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
	btnOn.BorderSizePixel = 0
	btnOn.Text = "ESP AN"
	btnOn.Font = Enum.Font.GothamBold
	btnOn.TextSize = 18
	btnOn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btnOn.Parent = frame
	local onCorner = Instance.new("UICorner")
	onCorner.CornerRadius = UDim.new(0, 10)
	onCorner.Parent = btnOn

	local btnOff = Instance.new("TextButton")
	btnOff.Name = "BtnOff"
	btnOff.Size = UDim2.new(0.45, -10, 0, 40)
	btnOff.Position = UDim2.new(0.5, 10, 0, 80)
	btnOff.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	btnOff.BorderSizePixel = 0
	btnOff.Text = "ESP AUS"
	btnOff.Font = Enum.Font.GothamBold
	btnOff.TextSize = 18
	btnOff.TextColor3 = Color3.fromRGB(255, 255, 255)
	btnOff.Parent = frame
	local offCorner = Instance.new("UICorner")
	offCorner.CornerRadius = UDim.new(0, 10)
	offCorner.Parent = btnOff

	-- Draggable (einfach)
	local dragging = false
	local dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	ui = screen
	screen.Parent = LocalPlayer:WaitForChild("PlayerGui")

	return {
		screen = screen,
		frame = frame,
		status = status,
		btnOn = btnOn,
		btnOff = btnOff,
	}
end

-- === ESP Logik ===
local function createBillboardGui(adornPart, playerName)
	local bb = Instance.new("BillboardGui")
	bb.Name = "NameESP"
	bb.AlwaysOnTop = true
	bb.Size = LABEL_SIZE
	bb.StudsOffset = LABEL_OFFSET
	bb.Adornee = adornPart
	bb.LightInfluence = 0

	local tl = Instance.new("TextLabel")
	tl.Name = "Label"
	tl.Size = UDim2.new(1, 0, 1, 0)
	tl.BackgroundTransparency = 1
	tl.TextScaled = true
	tl.Font = Enum.Font.GothamBold
	tl.Text = playerName
	tl.TextColor3 = Color3.new(1, 1, 1)
	tl.TextStrokeTransparency = 0.5
	tl.Parent = bb

	return bb
end

local function addESPForCharacter(character, player)
	if not ESP_ENABLED then return end
	if not character or not character.Parent then return end
	if espStore[character] then return end

	local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 3)
	if not head then return end

	local bb = createBillboardGui(head, player and player.Name or "Player")
	bb.Parent = head
	espStore[character] = bb
end

local function removeESPForCharacter(character)
	local bb = espStore[character]
	if bb then
		bb:Destroy()
		espStore[character] = nil
	end
end

local function clearAllESP()
	for character, _ in pairs(espStore) do
		removeESPForCharacter(character)
	end
end

local function setESPEnabled(state, statusLabel)
	ESP_ENABLED = state
	if ESP_ENABLED then
		-- Für alle vorhandenen Spieler aktivieren
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local char = plr.Character or plr.CharacterAdded:Wait()
				addESPForCharacter(char, plr)
			end
		end
		if statusLabel then statusLabel.Text = "Status: AN" end
	else
		clearAllESP()
		if statusLabel then statusLabel.Text = "Status: AUS" end
	end
end

-- === Setup ===
local elements = createUI()
elements.btnOn.MouseButton1Click:Connect(function()
	setESPEnabled(true, elements.status)
end)
elements.btnOff.MouseButton1Click:Connect(function()
	setESPEnabled(false, elements.status)
end)

-- Menü per Hotkey ein-/ausblenden
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == HOTKEY_TOGGLE_MENU then
		if ui then
			ui.Enabled = not ui.Enabled
		end
	end
end)

-- Spieler-Events
Players.PlayerAdded:Connect(function(plr)
	if plr == LocalPlayer then return end
	plr.CharacterAdded:Connect(function(char)
		if ESP_ENABLED then
			task.wait(0.1)
			addESPForCharacter(char, plr)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(plr)
	if plr == LocalPlayer then return end
	local char = plr.Character
	if char then removeESPForCharacter(char) end
end)

-- Cleanup wenn Charakter verschwindet
RunService.Heartbeat:Connect(function()
	for character, _ in pairs(espStore) do
		if not character.Parent then
			removeESPForCharacter(character)
		end
	end
end)

print("[ESP-Menü] Mit Buttons AN/AUS steuern, 'M' für Menü anzeigen/verstecken.")
