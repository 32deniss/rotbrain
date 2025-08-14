--[[
  Advanced ESP + Movement Tools (LocalScript)
  ------------------------------------------------
  Features
  - Name-ESP (AN/AUS) + Farbwahl
  - HP im Label (AN/AUS)
  - Distanz-Filter (0 = aus)
  - Box-ESP via Highlight (durch Wände sichtbar) + eigene Farbwahl
  - Super Jump (AN/AUS + JumpPower)
  - Sprint (AN/AUS + SprintSpeed, Shift zum Sprinten)
  - Kamera-FOV (Set + Reset)
  - Menü-Hotkeys: M (UI zeigen/verstecken), N (Box-ESP togglen)
  Hinweis: Für eigene Spiele/mit Erlaubnis nutzen.
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==== Defaults / Config ====
local HOTKEY_TOGGLE_MENU = Enum.KeyCode.M
local HOTKEY_TOGGLE_BOX  = Enum.KeyCode.N

local LABEL_OFFSET = Vector3.new(0, 2.5, 0)
local LABEL_SIZE   = UDim2.new(0, 220, 0, 42)

local DEFAULT_WALKSPEED  = 16
local DEFAULT_JUMPPOWER  = 50
local DEFAULT_FOV        = 70

-- ==== State ====
local ESP_ENABLED   = false
local SHOW_HP       = false
local CUR_COLOR     = Color3.new(1, 1, 1) -- Textfarbe
local MAX_DIST      = 0 -- 0 = kein Limit

local BOXESP_ENABLED = false
local BOX_COLOR      = Color3.fromRGB(0, 255, 120)

local SUPER_JUMP   = false
local JUMP_POWER   = 75

local SPRINT       = false
local SPRINT_SPEED = 24
local shiftDown    = false

local FOV          = DEFAULT_FOV

local espStore     = {} -- [Character] = BillboardGui
local boxStore     = {} -- [Character] = Highlight
local ui           = nil
local elements     = nil

-- ==== Utils ====
local function getHumanoid(character)
	if not character then return nil end
	return character:FindFirstChildOfClass("Humanoid")
end

local function getTorsoOrHead(character)
	if not character then return nil end
	return character:FindFirstChild("Head")
		or character:FindFirstChild("UpperTorso")
		or character:FindFirstChild("HumanoidRootPart")
end

local function getMagnitudeFromLocal(char)
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local myChar = LocalPlayer.Character
	local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not hrp or not myHrp then return math.huge end
	return (hrp.Position - myHrp.Position).Magnitude
end

local function parseNumber(s, defaultValue)
	local n = tonumber(s)
	if n and n == n and n ~= math.huge and n ~= -math.huge then
		return n
	end
	return defaultValue
end

-- ==== ESP (Name Label) ====
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
	tl.TextColor3 = CUR_COLOR
	tl.TextStrokeTransparency = 0.5
	tl.Parent = bb

	return bb
end

local function addESPForCharacter(character, player)
	if not ESP_ENABLED then return end
	if not character or not character.Parent then return end
	if espStore[character] then return end

	local adorn = getTorsoOrHead(character)
	if not adorn then return end

	local bb = createBillboardGui(adorn, player and player.Name or "Player")
	bb.Parent = adorn
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

local function refreshESPColors()
	for character, bb in pairs(espStore) do
		if bb and bb:FindFirstChild("Label") then
			bb.Label.TextColor3 = CUR_COLOR
		end
	end
end

local function setESPEnabled(state, statusLabel)
	ESP_ENABLED = state
	if ESP_ENABLED then
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

-- ==== Box ESP (Highlight) ====
local function addBoxESPForCharacter(character)
	if not BOXESP_ENABLED then return end
	if not character or not character.Parent then return end
	if boxStore[character] then return end

	local hl = Instance.new("Highlight")
	hl.Name = "BoxESP"
	hl.Adornee = character
	hl.FillTransparency = 1
	hl.OutlineTransparency = 0
	hl.OutlineColor = BOX_COLOR
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = character

	boxStore[character] = hl
end

local function removeBoxESPForCharacter(character)
	local hl = boxStore[character]
	if hl then
		hl:Destroy()
		boxStore[character] = nil
	end
end

local function clearAllBoxESP()
	for character, _ in pairs(boxStore) do
		removeBoxESPForCharacter(character)
	end
end

local function refreshBoxColors()
	for _, hl in pairs(boxStore) do
		if hl and hl.Parent then
			hl.OutlineColor = BOX_COLOR
		end
	end
end

local function setBoxESPEnabled(state)
	BOXESP_ENABLED = state
	if BOXESP_ENABLED then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local char = plr.Character or plr.CharacterAdded:Wait()
				if char then addBoxESPForCharacter(char) end
			end
		end
	else
		clearAllBoxESP()
	end
end

-- ==== Movement: Sprint & Super Jump ====
local function applyMovementDefaults()
	local char = LocalPlayer.Character
	local hum = getHumanoid(char)
	if not hum then return end
	hum.WalkSpeed = DEFAULT_WALKSPEED
	hum.JumpPower = DEFAULT_JUMPPOWER
end

local function applySprint()
	local char = LocalPlayer.Character
	local hum = getHumanoid(char)
	if not hum then return end
	if SPRINT and shiftDown then
		hum.WalkSpeed = SPRINT_SPEED
	else
		hum.WalkSpeed = DEFAULT_WALKSPEED
	end
end

local function applyJump()
	local char = LocalPlayer.Character
	local hum = getHumanoid(char)
	if not hum then return end
	if SUPER_JUMP then
		hum.JumpPower = JUMP_POWER
	else
		hum.JumpPower = DEFAULT_JUMPPOWER
	end
end

-- ==== Camera FOV ====
local function applyFOV()
	if Camera then
		Camera.FieldOfView = FOV
	end
end

-- ==== UI helpers ====
local function makeButton(parent, text, pos, size, bg)
	local b = Instance.new("TextButton")
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.AutoButtonColor = true
	b.BorderSizePixel = 0
	b.BackgroundColor3 = bg or Color3.fromRGB(58,58,68)
	b.Size = size
	b.Position = pos
	b.Parent = parent
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 10)
	c.Parent = b
	return b
end

local function addLabel(parent, text, pos, size)
	local l = Instance.new("TextLabel")
	l.Text = text
	l.Font = Enum.Font.Gotham
	l.TextSize = 16
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.BackgroundTransparency = 1
	l.Size = size
	l.Position = pos
	l.TextColor3 = Color3.fromRGB(220,220,220)
	l.Parent = parent
	return l
end

local function makeTextbox(parent, placeholder, pos, size)
	local tb = Instance.new("TextBox")
	tb.PlaceholderText = placeholder
	tb.Text = ""
	tb.Font = Enum.Font.Gotham
	tb.TextSize = 16
	tb.TextColor3 = Color3.fromRGB(240,240,240)
	tb.BackgroundColor3 = Color3.fromRGB(35,35,40)
	tb.BorderSizePixel = 0
	tb.Size = size
	tb.Position = pos
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = tb
	tb.Parent = parent
	return tb
end

local function colorBtn(parent, txt, col, pos)
	local b = makeButton(parent, txt, pos, UDim2.new(0, 60, 0, 28), col)
	b.Text = txt
	return b
end

-- ==== UI erstellen ====
local function createUI()
	local screen = Instance.new("ScreenGui")
	screen.Name = "ESP_Menu_Advanced"
	screen.ResetOnSpawn = false

	local frame = Instance.new("Frame")
	frame.Name = "Panel"
	frame.AnchorPoint = Vector2.new(0.5, 0)
	frame.Position = UDim2.new(0.5, 0, 0.08, 0)
	frame.Size = UDim2.new(0, 420, 0, 470)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	frame.BackgroundTransparency = 0.08
	frame.BorderSizePixel = 0
	frame.Parent = screen
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = frame

	-- Dragging
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

	local title = addLabel(frame, "ESP Menü (Erweitert)", UDim2.new(0, 12, 0, 8), UDim2.new(1, -24, 0, 28))
	title.Font = Enum.Font.GothamBold
	title.TextSize = 20
	title.TextColor3 = Color3.fromRGB(255,255,255)

	local status = addLabel(frame, "Status: AUS", UDim2.new(0, 12, 0, 36), UDim2.new(1, -24, 0, 22))

	-- Row: ESP On/Off
	local btnOn  = makeButton(frame, "ESP AN",  UDim2.new(0, 12, 0, 64),  UDim2.new(0.48, -18, 0, 36), Color3.fromRGB(40,170,90))
	local btnOff = makeButton(frame, "ESP AUS", UDim2.new(0.52, 6, 0, 64), UDim2.new(0.48, -18, 0, 36), Color3.fromRGB(200,60,60))

	-- Row: Farbe Name
	addLabel(frame, "Namen-Farbe:", UDim2.new(0,12,0,108), UDim2.new(0,120,0,22))
	local cWhite = colorBtn(frame, "Weiß", Color3.fromRGB(255,255,255), UDim2.new(0, 12, 0, 132))
	local cRed   = colorBtn(frame, "Rot",   Color3.fromRGB(220,60,60),  UDim2.new(0, 86, 0, 132))
	local cGreen = colorBtn(frame, "Grün",  Color3.fromRGB(40,170,90),  UDim2.new(0, 160,0, 132))
	local cBlue  = colorBtn(frame, "Blau",  Color3.fromRGB(70,90,200),  UDim2.new(0, 234,0, 132))
	local cYellow= colorBtn(frame, "Gelb",  Color3.fromRGB(240,200,40), UDim2.new(0, 308,0, 132))

	-- Row: HP Toggle
	local btnHP = makeButton(frame, "HP im Label: AUS", UDim2.new(0, 12, 0, 168), UDim2.new(1, -24, 0, 32), Color3.fromRGB(58,100,150))

	-- Row: Distanz Filter
	addLabel(frame, "Distanz-Filter (Studs, 0=aus):", UDim2.new(0,12,0,206), UDim2.new(0.6,0,0,22))
	local tbDist = makeTextbox(frame, "z.B. 150", UDim2.new(0.6, 8, 0, 202), UDim2.new(0.4, -20, 0, 30))

	-- Row: Box-ESP + Farbe
	local btnBox = makeButton(frame, "BOX-ESP: AUS", UDim2.new(0, 12, 0, 240), UDim2.new(1, -24, 0, 32), Color3.fromRGB(70, 90, 200))
	addLabel(frame, "Box-Farbe:", UDim2.new(0,12,0,278), UDim2.new(0,100,0,22))
	local bWhite = colorBtn(frame, "Weiß", Color3.fromRGB(255,255,255), UDim2.new(0, 12, 0, 302))
	local bRed   = colorBtn(frame, "Rot",   Color3.fromRGB(220,60,60),  UDim2.new(0, 86, 0, 302))
	local bGreen = colorBtn(frame, "Grün",  Color3.fromRGB(40,170,90),  UDim2.new(0, 160,0, 302))
	local bBlue  = colorBtn(frame, "Blau",  Color3.fromRGB(70,90,200),  UDim2.new(0, 234,0, 302))
	local bYellow= colorBtn(frame, "Gelb",  Color3.fromRGB(240,200,40), UDim2.new(0, 308,0, 302))

	-- Row: Super Jump
	local btnSJ  = makeButton(frame, "Super Jump: AUS", UDim2.new(0, 12, 0, 340), UDim2.new(0.58, -18, 0, 32), Color3.fromRGB(160, 90, 220))
	local tbJP   = makeTextbox(frame, "JumpPower", UDim2.new(0.62, 6, 0, 340), UDim2.new(0.38, -18, 0, 32))

	-- Row: Sprint
	local btnSprint = makeButton(frame, "Sprint: AUS (Shift)", UDim2.new(0, 12, 0, 378), UDim2.new(0.58, -18, 0, 32), Color3.fromRGB(90, 160, 220))
	local tbSpd     = makeTextbox(frame, "Sprint Speed", UDim2.new(0.62, 6, 0, 378), UDim2.new(0.38, -18, 0, 32))

	-- Row: FOV
	addLabel(frame, "FOV:", UDim2.new(0,12,0,416), UDim2.new(0,60,0,22))
	local tbFov = makeTextbox(frame, tostring(DEFAULT_FOV), UDim2.new(0, 62, 0, 412), UDim2.new(0, 120, 0, 30))
	local btnFovSet = makeButton(frame, "Set", UDim2.new(0, 188, 0, 412), UDim2.new(0, 80, 0, 30), Color3.fromRGB(80,160,120))
	local btnFovReset = makeButton(frame, "Reset", UDim2.new(0, 274, 0, 412), UDim2.new(0, 120, 0, 30), Color3.fromRGB(150,80,80))

	-- Pack return
	ui = screen
	screen.Parent = LocalPlayer:WaitForChild("PlayerGui")

	return {
		screen = screen,
		frame  = frame,
		status = status,
		btnOn  = btnOn,
		btnOff = btnOff,

		-- Colors name
		cWhite = cWhite, cRed = cRed, cGreen = cGreen, cBlue = cBlue, cYellow = cYellow,

		btnHP  = btnHP,
		tbDist = tbDist,

		-- Box
		btnBox = btnBox,
		bWhite = bWhite, bRed = bRed, bGreen = bGreen, bBlue = bBlue, bYellow = bYellow,

		-- Super Jump
		btnSJ  = btnSJ,
		tbJP   = tbJP,

		-- Sprint
		btnSprint = btnSprint,
		tbSpd     = tbSpd,

		-- FOV
		tbFov = tbFov,
		btnFovSet = btnFovSet,
		btnFovReset = btnFovReset,
	}
end

-- ==== Setup ====
elements = createUI()

-- ESP On/Off
elements.btnOn.MouseButton1Click:Connect(function()
	setESPEnabled(true, elements.status)
end)
elements.btnOff.MouseButton1Click:Connect(function()
	setESPEnabled(false, elements.status)
end)

-- Name Color buttons
elements.cWhite.MouseButton1Click:Connect(function() CUR_COLOR = Color3.fromRGB(255,255,255); refreshESPColors() end)
elements.cRed.MouseButton1Click:Connect(function()   CUR_COLOR = Color3.fromRGB(220,60,60);   refreshESPColors() end)
elements.cGreen.MouseButton1Click:Connect(function() CUR_COLOR = Color3.fromRGB(40,170,90);   refreshESPColors() end)
elements.cBlue.MouseButton1Click:Connect(function()  CUR_COLOR = Color3.fromRGB(70,90,200);   refreshESPColors() end)
elements.cYellow.MouseButton1Click:Connect(function()CUR_COLOR = Color3.fromRGB(240,200,40);  refreshESPColors() end)

-- HP Toggle
elements.btnHP.MouseButton1Click:Connect(function()
	SHOW_HP = not SHOW_HP
	elements.btnHP.Text = SHOW_HP and "HP im Label: AN" or "HP im Label: AUS"
end)

-- Distanz Filter
elements.tbDist.FocusLost:Connect(function(enterPressed)
	MAX_DIST = math.max(0, parseNumber(elements.tbDist.Text, MAX_DIST or 0) or 0)
end)

-- Box Toggle
elements.btnBox.MouseButton1Click:Connect(function()
	setBoxESPEnabled(not BOXESP_ENABLED)
	elements.btnBox.Text = BOXESP_ENABLED and "BOX-ESP: AN" or "BOX-ESP: AUS"
end)
-- Box Color buttons
elements.bWhite.MouseButton1Click:Connect(function() BOX_COLOR = Color3.fromRGB(255,255,255); refreshBoxColors() end)
elements.bRed.MouseButton1Click:Connect(function()   BOX_COLOR = Color3.fromRGB(220,60,60);   refreshBoxColors() end)
elements.bGreen.MouseButton1Click:Connect(function() BOX_COLOR = Color3.fromRGB(40,170,90);   refreshBoxColors() end)
elements.bBlue.MouseButton1Click:Connect(function()  BOX_COLOR = Color3.fromRGB(70,90,200);   refreshBoxColors() end)
elements.bYellow.MouseButton1Click:Connect(function()BOX_COLOR = Color3.fromRGB(240,200,40);  refreshBoxColors() end)

-- Super Jump
elements.btnSJ.MouseButton1Click:Connect(function()
	SUPER_JUMP = not SUPER_JUMP
	elements.btnSJ.Text = SUPER_JUMP and "Super Jump: AN" or "Super Jump: AUS"
	applyJump()
end)
elements.tbJP.FocusLost:Connect(function()
	JUMP_POWER = math.max(0, parseNumber(elements.tbJP.Text, JUMP_POWER or 75) or 75)
	if SUPER_JUMP then applyJump() end
end)

-- Sprint
elements.btnSprint.MouseButton1Click:Connect(function()
	SPRINT = not SPRINT
	elements.btnSprint.Text = SPRINT and "Sprint: AN (Shift)" or "Sprint: AUS (Shift)"
	applySprint()
end)
elements.tbSpd.FocusLost:Connect(function()
	SPRINT_SPEED = math.max(0, parseNumber(elements.tbSpd.Text, SPRINT_SPEED or 24) or 24)
	applySprint()
end)

-- FOV
elements.btnFovSet.MouseButton1Click:Connect(function()
	FOV = math.clamp(parseNumber(elements.tbFov.Text, FOV or DEFAULT_FOV) or DEFAULT_FOV, 40, 120)
	applyFOV()
end)
elements.btnFovReset.MouseButton1Click:Connect(function()
	FOV = DEFAULT_FOV
	elements.tbFov.Text = tostring(DEFAULT_FOV)
	applyFOV()
end)

-- Menü-Hotkeys
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == HOTKEY_TOGGLE_MENU then
		if ui then ui.Enabled = not ui.Enabled end
	elseif input.KeyCode == HOTKEY_TOGGLE_BOX then
		setBoxESPEnabled(not BOXESP_ENABLED)
		if elements and elements.btnBox then
			elements.btnBox.Text = BOXESP_ENABLED and "BOX-ESP: AN" or "BOX-ESP: AUS"
		end
	elseif input.KeyCode == Enum.KeyCode.LeftShift then
		shiftDown = true
		applySprint()
	end
end)

UIS.InputEnded:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.LeftShift then
		shiftDown = false
		applySprint()
	end
end)

-- Spieler Events
Players.PlayerAdded:Connect(function(plr)
	if plr == LocalPlayer then return end
	plr.CharacterAdded:Connect(function(char)
		if ESP_ENABLED then
			task.wait(0.1)
			addESPForCharacter(char, plr)
		end
		if BOXESP_ENABLED then
			task.wait(0.05)
			addBoxESPForCharacter(char)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(plr)
	if plr == LocalPlayer then return end
	local char = plr.Character
	if char then
		removeESPForCharacter(char)
		removeBoxESPForCharacter(char)
	end
end)

-- Cleanup, Refresh & Ticks
RunService.Heartbeat:Connect(function()
	-- Entferne verwaiste
	for character, _ in pairs(espStore) do
		if not character.Parent then
			removeESPForCharacter(character)
		end
	end
	for character, _ in pairs(boxStore) do
		if not character.Parent then
			removeBoxESPForCharacter(character)
		end
	end

	-- Update ESP Labels (HP + Distanz + Farbe)
	if ESP_ENABLED then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				local char = plr.Character
				local bb = char and espStore[char]
				if bb and bb:FindFirstChild("Label") then
					local hum = getHumanoid(char)
					local nameText = plr.Name
					if SHOW_HP and hum then
						nameText = string.format("%s [%d]", plr.Name, math.max(0, math.floor(hum.Health)))
					end
					bb.Label.Text = nameText
					bb.Label.TextColor3 = CUR_COLOR

					-- Distanz-Filter
					if MAX_DIST > 0 then
						local dist = getMagnitudeFromLocal(char)
						bb.Enabled = dist <= MAX_DIST
					else
						bb.Enabled = true
					end
				end
			end
		end
	end

	-- Safety: falls Kamera/Char wechselt
	applyFOV()
end)

-- Reset Movement on spawn & apply settings
LocalPlayer.CharacterAdded:Connect(function(char)
	applyMovementDefaults()
	applySprint()
	applyJump()
end)

-- Initial apply
applyMovementDefaults()
applySprint()
applyJump()
applyFOV()

print("[Advanced ESP] Bereit. M: Menü, N: Box-ESP toggle, Shift: Sprint (wenn aktiv).")
