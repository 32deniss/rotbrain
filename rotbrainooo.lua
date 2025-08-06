--// SETTINGS
local webhookURL = "https://discord.com/api/webhooks/1402792571083821197/S56XzWZoEp-FOqmQmh7RQun82YzpoTm_Y_t41svPyHzezvxm3EegcvSBtpBLEDyXCzGE" -- << DEIN WEBHOOK HIER >>

--// HELFER: Zahl konvertieren (z.B. "900M/s" -> 900000000)
local function ConvertToNumber(str)
    local num = str:match("(%d+%.?%d*)")
    local suffix = str:match("[KMBTQ]?/s") or ""

    local multipliers = {
        ["K/s"] = 1e3,
        ["M/s"] = 1e6,
        ["B/s"] = 1e9,
        ["T/s"] = 1e12,
        ["Q/s"] = 1e15,
    }

    return tonumber(num) * (multipliers[suffix] or 1)
end

--// TEUERSTEN BRAINROT FINDEN
local function ScanForBestBrainrot()
    local bestValue = 0
    local bestText = "N/A"

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text:match("/s") then
            local value = ConvertToNumber(v.Text)
            if value > bestValue then
                bestValue = value
                bestText = v.Text
            end
        end
    end

    return bestText, bestValue
end

--// WEBHOOK SENDEN
local function SendWebhook(brainrotText, serverId)
    local HttpService = game:GetService("HttpService")
    local data = {
        ["content"] = "**🧠 Neuer Server gescannt**\n" ..
                      "🔢 Teuerster Brainrot: `" .. brainrotText .. "`\n" ..
                      "🌐 Server-ID: `" .. serverId .. "`\n" ..
                      "🔗 [Joinen](roblox://placeId=".. game.PlaceId .."&gameInstanceId=".. serverId ..")"
    }

    local jsonData = HttpService:JSONEncode(data)

    syn.request({
        Url = webhookURL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = jsonData
    })
end

--// GUI ERSTELLEN
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local TextLabel = Instance.new("TextLabel", Frame)
local HopButton = Instance.new("TextButton", Frame)
local Minimize = Instance.new("TextButton", Frame)

ScreenGui.Name = "BrainrotGUI"
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0

TextLabel.Size = UDim2.new(1, 0, 0.5, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.new(1,1,1)
TextLabel.TextScaled = true
TextLabel.Text = "Wird geladen..."

HopButton.Size = UDim2.new(0.45, 0, 0.3, 0)
HopButton.Position = UDim2.new(0.05, 0, 0.6, 0)
HopButton.Text = "Nächster Server"
HopButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
HopButton.TextColor3 = Color3.new(1,1,1)
HopButton.BorderSizePixel = 0

Minimize.Size = UDim2.new(0.45, 0, 0.3, 0)
Minimize.Position = UDim2.new(0.5, 0, 0.6, 0)
Minimize.Text = "Minimieren"
Minimize.BackgroundColor3 = Color3.fromRGB(50,50,50)
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.BorderSizePixel = 0

local minimized = false
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    Frame.Size = minimized and UDim2.new(0, 150, 0, 40) or UDim2.new(0, 300, 0, 150)
    TextLabel.Visible = not minimized
    HopButton.Visible = not minimized
    Minimize.Text = minimized and "Maximieren" or "Minimieren"
end)

--// SERVERHOP
local function ServerHop()
    local tpservice = game:GetService("TeleportService")
    local http = game:GetService("HttpService")
    local servers = {}
    local req = syn.request({
        Url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"
    })
    local body = http:JSONDecode(req.Body)

    for i,v in pairs(body.data) do
        if v.playing < v.maxPlayers then
            table.insert(servers, v.id)
        end
    end

    tpservice:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
end

HopButton.MouseButton1Click:Connect(ServerHop)

--// Start Scan
task.spawn(function()
    wait(2)
    local bestText, bestVal = ScanForBestBrainrot()
    local serverId = game.JobId
    TextLabel.Text = "Teuerster Brainrot:\n"..bestText
    SendWebhook(bestText, serverId)
end)
