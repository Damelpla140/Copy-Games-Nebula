-- LocalScript en StarterCharacterScripts
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local PhysicsService = game:GetService("PhysicsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local launchEvent = ReplicatedStorage:WaitForChild("LaunchPlayer")

-- COLLISION GROUP
pcall(function()
    PhysicsService:RegisterCollisionGroup("FlyGroup")
    PhysicsService:CollisionGroupSetCollidable("FlyGroup", "Default", false)
end)

local function setNoclip(character, noclip)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CollisionGroup = noclip and "FlyGroup" or "Default"
        end
    end
end

-- =============================================
-- GUI CYBERPUNK
-- =============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HackGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player.PlayerGui

-- PANEL PRINCIPAL
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 360)
mainFrame.Position = UDim2.new(0, 16, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Borde neón
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 255, 180)
stroke.Thickness = 1.5
stroke.Transparency = 0.2
stroke.Parent = mainFrame

-- Línea de acento superior
local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(1, 0, 0, 3)
accentBar.Position = UDim2.new(0, 0, 0, 0)
accentBar.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
accentBar.BorderSizePixel = 0
accentBar.Parent = mainFrame

-- Efecto scanline (decorativo)
local scanline = Instance.new("Frame")
scanline.Size = UDim2.new(1, 0, 0, 1)
scanline.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
scanline.BackgroundTransparency = 0.85
scanline.BorderSizePixel = 0
scanline.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.Position = UDim2.new(0, 0, 0, 3)
header.BackgroundTransparency = 1
header.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -10, 0, 24)
titleLabel.Position = UDim2.new(0, 10, 0, 6)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
titleLabel.Text = "⬡ PHANTOM"
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.Code
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1, -10, 0, 14)
subLabel.Position = UDim2.new(0, 10, 0, 28)
subLabel.BackgroundTransparency = 1
subLabel.TextColor3 = Color3.fromRGB(80, 255, 200)
subLabel.Text = "v2.0 | EXPLOIT SUITE"
subLabel.TextSize = 10
subLabel.Font = Enum.Font.Code
subLabel.TextXAlignment = Enum.TextXAlignment.Left
subLabel.Parent = header

-- Separador
local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, -20, 0, 1)
sep.Position = UDim2.new(0, 10, 0, 50)
sep.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
sep.BackgroundTransparency = 0.7
sep.BorderSizePixel = 0
sep.Parent = mainFrame

-- =============================================
-- FUNCIÓN PARA CREAR BOTONES
-- =============================================
local function createToggleBtn(yPos, icon, label, colorOn, colorOff)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 42)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = mainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = colorOff
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 30, 1, 0)
    iconLbl.Position = UDim2.new(0, 8, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 16
    iconLbl.Font = Enum.Font.Code
    iconLbl.TextColor3 = colorOff
    iconLbl.Parent = btn

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -80, 1, 0)
    nameLbl.Position = UDim2.new(0, 40, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = label
    nameLbl.TextSize = 12
    nameLbl.Font = Enum.Font.Code
    nameLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = btn

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(0, 36, 0, 18)
    statusLbl.Position = UDim2.new(1, -44, 0.5, -9)
    statusLbl.BackgroundColor3 = colorOff
    statusLbl.BackgroundTransparency = 0.7
    statusLbl.Text = "OFF"
    statusLbl.TextSize = 9
    statusLbl.Font = Enum.Font.Code
    statusLbl.TextColor3 = colorOff
    statusLbl.BorderSizePixel = 0
    statusLbl.Parent = btn
    Instance.new("UICorner", statusLbl).CornerRadius = UDim.new(0, 4)

    local enabled = false

    local function setEnabled(val)
        enabled = val
        local c = val and colorOn or colorOff
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = c, Transparency = val and 0.1 or 0.5}):Play()
        TweenService:Create(iconLbl, TweenInfo.new(0.2), {TextColor3 = c}):Play()
        TweenService:Create(statusLbl, TweenInfo.new(0.2), {BackgroundColor3 = c, TextColor3 = c}):Play()
        statusLbl.Text = val and "ON" or "OFF"
    end

    btn.MouseButton1Click:Connect(function()
        setEnabled(not enabled)
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(18, 18, 30)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(12, 12, 20)}):Play()
    end)

    return btn, function() return enabled end, setEnabled
end

-- =============================================
-- CREAR TODOS LOS BOTONES
-- =============================================
local GREEN  = Color3.fromRGB(0, 255, 140)
local CYAN   = Color3.fromRGB(0, 200, 255)
local RED    = Color3.fromRGB(255, 60, 100)
local ORANGE = Color3.fromRGB(255, 160, 0)
local PURPLE = Color3.fromRGB(180, 80, 255)

local launchBtn, getLaunch, setLaunch = createToggleBtn(60,  "⚡", "LAUNCH PLAYERS", GREEN,  Color3.fromRGB(60,60,60))
local flyBtn,    getFly,    setFly    = createToggleBtn(112, "✈", "FLY + NOCLIP",   CYAN,   Color3.fromRGB(60,60,60))
local godBtn,    getGod,    setGod    = createToggleBtn(164, "♥", "GOD MODE",        RED,    Color3.fromRGB(60,60,60))
local espBtn,    getEsp,    setEsp    = createToggleBtn(216, "◈", "ESP PLAYERS",     ORANGE, Color3.fromRGB(60,60,60))
local speedBtn,  getSpeed,  setSpeed  = createToggleBtn(268, "▶", "SPEED HACK",      PURPLE, Color3.fromRGB(60,60,60))

-- Label de estado abajo
local statusBar = Instance.new("TextLabel")
statusBar.Size = UDim2.new(1, -20, 0, 20)
statusBar.Position = UDim2.new(0, 10, 1, -28)
statusBar.BackgroundTransparency = 1
statusBar.Text = "● CONNECTED  |  " .. player.Name
statusBar.TextSize = 9
statusBar.Font = Enum.Font.Code
statusBar.TextColor3 = Color3.fromRGB(0, 255, 180)
statusBar.TextXAlignment = Enum.TextXAlignment.Left
statusBar.Parent = mainFrame

-- Animación scanline
local scanY = 0
RunService.Heartbeat:Connect(function(dt)
    scanY = (scanY + dt * 60) % 360
    scanline.Position = UDim2.new(0, 0, 0, scanY)
end)

-- =============================================
-- LAUNCH LOGIC
-- =============================================
local launchCooldowns = {}
local LAUNCH_RADIUS = 5

local function checkAndLaunch()
    local character = player.Character
    if not character then return end
    local myHRP = character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer == player then continue end
        local otherChar = otherPlayer.Character
        if not otherChar then continue end
        local otherHRP = otherChar:FindFirstChild("HumanoidRootPart")
        local otherHumanoid = otherChar:FindFirstChild("Humanoid")
        if not otherHRP or not otherHumanoid then continue end
        if otherHumanoid.Health <= 0 then continue end

        local distance = (myHRP.Position - otherHRP.Position).Magnitude
        if distance <= LAUNCH_RADIUS then
            if launchCooldowns[otherPlayer.UserId] then continue end
            launchCooldowns[otherPlayer.UserId] = true
            task.delay(1.5, function() launchCooldowns[otherPlayer.UserId] = nil end)

            local dir = (otherHRP.Position - myHRP.Position)
            dir = dir.Magnitude > 0 and dir.Unit or Vector3.new(1, 0, 0)
            launchEvent:FireServer(otherPlayer, dir)
        end
    end
end

-- =============================================
-- FLY LOGIC
-- =============================================
local flyConnection
local function startFly()
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end

    humanoid.PlatformStand = true
    setNoclip(character, true)

    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlyVelocity"
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Parent = hrp

    local bg = Instance.new("BodyGyro")
    bg.Name = "FlyGyro"
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.P = 1e4
    bg.Parent = hrp

    flyConnection = RunService.Heartbeat:Connect(function()
        if not getFly() then return end
        local camera = workspace.CurrentCamera
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end
        bv.Velocity = if moveDir.Magnitude > 0 then moveDir.Unit * 60 else Vector3.zero
        bg.CFrame = camera.CFrame
        if getLaunch() then checkAndLaunch() end
    end)
end

local function stopFly()
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if hrp then
        local bv = hrp:FindFirstChild("FlyVelocity")
        local bg = hrp:FindFirstChild("FlyGyro")
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
    setNoclip(character, false)
    if humanoid then humanoid.PlatformStand = false end
end

flyBtn.MouseButton1Click:Connect(function()
    if getFly() then startFly() else stopFly() end
end)

-- =============================================
-- GOD MODE (Vida Infinita)
-- =============================================
local godConnection
godBtn.MouseButton1Click:Connect(function()
    if getGod() then
        godConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if not character then return end
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    else
        if godConnection then godConnection:Disconnect() godConnection = nil end
    end
end)

-- =============================================
-- ESP (Caja sobre jugadores)
-- =============================================
local espBillboards = {}

local function createESP(otherPlayer)
    if espBillboards[otherPlayer] then return end
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 80, 0, 80)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Name = "ESP_" .. otherPlayer.Name

    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 0
    box.Parent = bb

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(255, 160, 0)
    uiStroke.Thickness = 2
    uiStroke.Parent = box

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, 0, 0, 14)
    nameLbl.Position = UDim2.new(0, 0, 0, -16)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = otherPlayer.Name
    nameLbl.TextColor3 = Color3.fromRGB(255, 160, 0)
    nameLbl.TextSize = 11
    nameLbl.Font = Enum.Font.Code
    nameLbl.Parent = bb

    local hpLbl = Instance.new("TextLabel")
    hpLbl.Size = UDim2.new(1, 0, 0, 12)
    hpLbl.Position = UDim2.new(0, 0, 1, 2)
    hpLbl.BackgroundTransparency = 1
    hpLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
    hpLbl.TextSize = 10
    hpLbl.Font = Enum.Font.Code
    hpLbl.Parent = bb

    espBillboards[otherPlayer] = {bb = bb, hpLbl = hpLbl}

    -- Adjuntar al personaje cuando cargue
    local function attachToChar(char)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if hrp then bb.Adornee = hrp bb.Parent = hrp end
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            RunService.Heartbeat:Connect(function()
                if getEsp() and hum then
                    hpLbl.Text = "HP: " .. math.floor(hum.Health)
                end
            end)
        end
    end

    if otherPlayer.Character then attachToChar(otherPlayer.Character) end
    otherPlayer.CharacterAdded:Connect(attachToChar)
end

local function removeESP(otherPlayer)
    local data = espBillboards[otherPlayer]
    if data then
        data.bb:Destroy()
        espBillboards[otherPlayer] = nil
    end
end

espBtn.MouseButton1Click:Connect(function()
    if getEsp() then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then createESP(p) end
        end
        Players.PlayerAdded:Connect(function(p) if getEsp() then createESP(p) end end)
    else
        for _, p in ipairs(Players:GetPlayers()) do
            removeESP(p)
        end
    end
end)

-- =============================================
-- SPEED HACK
-- =============================================
local originalSpeed = 16
speedBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    if getSpeed() then
        originalSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = 80
    else
        humanoid.WalkSpeed = originalSpeed
    end
end)

-- =============================================
-- LAUNCH LOOP
-- =============================================
local function launchLoop()
    while true do
        task.wait(0.1)
        if getLaunch() and not getFly() then
            checkAndLaunch()
        end
    end
end

player.CharacterAdded:Connect(function()
    setFly(false)
    stopFly()
    task.wait(1)
    task.spawn(launchLoop)

    -- Restaurar speed hack si estaba activo
    local character = player.Character
    if character and getSpeed() then
        local hum = character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 80 end
    end
end)

if player.Character then
    task.spawn(launchLoop)
end
