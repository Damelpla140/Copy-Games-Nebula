--[[
╔═══════════════════════════════════════════════════════════════════════════╗
║                    ✨ NEBULA STUDIOS - iOS STYLE GUI ✨                    ║
╚═══════════════════════════════════════════════════════════════════════════╝
--]]

-- ═══════════════════════════════════════════════════════════════════════════
--                              SERVICES
-- ═══════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ═══════════════════════════════════════════════════════════════════════════
--                              VARIABLES
-- ═══════════════════════════════════════════════════════════════════════════

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Estados
local FlyEnabled = false
local NoclipEnabled = false
local GodmodeEnabled = false
local InfiniteJumpEnabled = false
local ESPEnabled = false

-- Valores
local FlySpeed = 50
local WalkSpeed = 16
local JumpPower = 50

-- Conexiones
local FlyConnection
local NoclipConnection
local InfiniteJumpConnection

-- ═══════════════════════════════════════════════════════════════════════════
--                              EXPLOIT FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

local function ToggleFly(state)
    FlyEnabled = state
    
    if FlyEnabled then
        local BV = Instance.new("BodyVelocity")
        local BG = Instance.new("BodyGyro")
        
        BV.Name = "FlyVelocity"
        BV.Parent = HumanoidRootPart
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BV.Velocity = Vector3.new(0, 0, 0)
        
        BG.Name = "FlyGyro"
        BG.Parent = HumanoidRootPart
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = HumanoidRootPart.CFrame
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not FlyEnabled then return end
            
            local Camera = workspace.CurrentCamera
            local MoveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                MoveDirection = MoveDirection + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                MoveDirection = MoveDirection - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                MoveDirection = MoveDirection - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                MoveDirection = MoveDirection + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                MoveDirection = MoveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                MoveDirection = MoveDirection - Vector3.new(0, 1, 0)
            end
            
            if MoveDirection.Magnitude > 0 then
                MoveDirection = MoveDirection.Unit
            end
            
            BV.Velocity = MoveDirection * FlySpeed
            BG.CFrame = Camera.CFrame
        end)
    else
        if FlyConnection then
            FlyConnection:Disconnect()
        end
        
        if HumanoidRootPart:FindFirstChild("FlyVelocity") then
            HumanoidRootPart.FlyVelocity:Destroy()
        end
        if HumanoidRootPart:FindFirstChild("FlyGyro") then
            HumanoidRootPart.FlyGyro:Destroy()
        end
    end
end

local function ToggleNoclip(state)
    NoclipEnabled = state
    
    if NoclipEnabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            if not NoclipEnabled then return end
            
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
        end
        
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function ToggleGodmode(state)
    GodmodeEnabled = state
    
    if GodmodeEnabled then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
    else
        Humanoid.MaxHealth = 100
        Humanoid.Health = 100
    end
end

local function ToggleInfiniteJump(state)
    InfiniteJumpEnabled = state
    
    if InfiniteJumpEnabled then
        InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if InfiniteJumpEnabled then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if InfiniteJumpConnection then
            InfiniteJumpConnection:Disconnect()
        end
    end
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local BillboardGui = Instance.new("BillboardGui")
    local TextLabel = Instance.new("TextLabel")
    
    BillboardGui.Name = "ESP"
    BillboardGui.Parent = hrp
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 100, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
    
    TextLabel.Parent = BillboardGui
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    TextLabel.TextStrokeTransparency = 0
    TextLabel.TextSize = 14
    TextLabel.Text = player.Name
    
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "ESP_Highlight"
    Highlight.Parent = char
    Highlight.FillColor = Color3.fromRGB(0, 255, 100)
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 0.5
end

local function RemoveESP(player)
    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp:FindFirstChild("ESP") then
            hrp.ESP:Destroy()
        end
        if char:FindFirstChild("ESP_Highlight") then
            char.ESP_Highlight:Destroy()
        end
    end
end

local function ToggleESP(state)
    ESPEnabled = state
    
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            CreateESP(player)
        end
        
        Players.PlayerAdded:Connect(function(player)
            if ESPEnabled then
                player.CharacterAdded:Connect(function()
                    task.wait(1)
                    CreateESP(player)
                end)
            end
        end)
    else
        for _, player in pairs(Players:GetPlayers()) do
            RemoveESP(player)
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
--                              iOS STYLE GUI CREATION
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateiOSGUI()
    -- Crear ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NebulaIOSGui"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- ═══════════════════════════════════════════════════════════════════════
    --                          BLUR BACKGROUND (Efecto iOS)
    -- ═══════════════════════════════════════════════════════════════════════
    
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Parent = game:GetService("Lighting")
    BlurEffect.Size = 0
    
    local function UpdateBlur(visible)
        local targetSize = visible and 12 or 0
        TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = targetSize}):Play()
    end
    
    -- ═══════════════════════════════════════════════════════════════════════
    --                          MAIN FRAME (Ventana Principal - Glassmorphism)
    -- ═══════════════════════════════════════════════════════════════════════
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BackgroundTransparency = 0.3  -- Transparencia estilo iOS
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0, 520, 0, 470)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    
    -- Corner para el MainFrame
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 20)
    MainCorner.Parent = MainFrame
    
    -- Borde estilo iOS
    local Border = Instance.new("UIStroke")
    Border.Parent = MainFrame
    Border.Color = Color3.fromRGB(255, 255, 255)
    Border.Transparency = 0.8
    Border.Thickness = 1
    
    -- Efecto de vidrio (Glassmorphism)
    local GlassEffect = Instance.new("Frame")
    GlassEffect.Name = "GlassEffect"
    GlassEffect.Parent = MainFrame
    GlassEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlassEffect.BackgroundTransparency = 0.95
    GlassEffect.BorderSizePixel = 0
    GlassEffect.Size = UDim2.new(1, 0, 1, 0)
    GlassEffect.ZIndex = 0
    
    local GlassCorner = Instance.new("UICorner")
    GlassCorner.CornerRadius = UDim.new(0, 20)
    GlassCorner.Parent = GlassEffect
    
    -- Gradiente sutil
    local Gradient = Instance.new("UIGradient")
    Gradient.Parent = GlassEffect
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 255, 200))
    }
    Gradient.Rotation = 45
    Gradient.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(1, 0.95)
    }
    
    -- ═══════════════════════════════════════════════════════════════════════
    --                          TOP BAR (Barra Superior iOS)
    -- ═══════════════════════════════════════════════════════════════════════
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopBar.BackgroundTransparency = 0.9
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 60)
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 20)
    TopBarCorner.Parent = TopBar
    
    -- Borde inferior sutil
    local TopBarDivider = Instance.new("Frame")
    TopBarDivider.Parent = TopBar
    TopBarDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopBarDivider.BackgroundTransparency = 0.9
    TopBarDivider.BorderSizePixel = 0
    TopBarDivider.Position = UDim2.new(0, 15, 1, -1)
    TopBarDivider.Size = UDim2.new(1, -30, 0, 1)
    
    -- Logo/Icono
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Parent = TopBar
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 20, 0.5, -15)
    Logo.Size = UDim2.new(0, 30, 0, 30)
    Logo.Image = "rbxassetid://4483362458"
    Logo.ImageColor3 = Color3.fromRGB(0, 255, 100)
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 8)
    LogoCorner.Parent = Logo
    
    -- Título
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 60, 0, 0)
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "NEBULA STUDIOS"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Parent = TopBar
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 60, 0, 25)
    Subtitle.Size = UDim2.new(0, 300, 0, 20)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = "Modern iOS Style"
    Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    Subtitle.TextSize = 12
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.TextTransparency = 0.3
    
    -- Botones de Control iOS Style
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -45, 0.5, -10)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = ""
    CloseButton.AutoButtonColor = false
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseButton
    
    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Parent = CloseButton
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Position = UDim2.new(0.5, -5, 0.5, -5)
    CloseIcon.Size = UDim2.new(0, 10, 0, 10)
    CloseIcon.Image = "rbxassetid://3926305904"
    CloseIcon.ImageRectOffset = Vector2.new(284, 4)
    CloseIcon.ImageRectSize = Vector2.new(24, 24)
    CloseIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 204, 0)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -75, 0.5, -10)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = ""
    MinimizeButton.AutoButtonColor = false
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(1, 0)
    MinimizeCorner.Parent = MinimizeButton
    
    -- ═══════════════════════════════════════════════════════════════════════
    --                          SIDEBAR (Menú Lateral iOS)
    -- ═══════════════════════════════════════════════════════════════════════
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Sidebar.BackgroundTransparency = 0.95
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 10, 0, 70)
    Sidebar.Size = UDim2.new(0, 130, 1, -80)
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 15)
    SidebarCorner.Parent = Sidebar
    
    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.Parent = Sidebar
    SidebarStroke.Color = Color3.fromRGB(255, 255, 255)
    SidebarStroke.Transparency = 0.9
    SidebarStroke.Thickness = 1
    
    local SidebarList = Instance.new("UIListLayout")
    SidebarList.Parent = Sidebar
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 8)
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = Sidebar
    SidebarPadding.PaddingTop = UDim.new(0, 12)
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)
    SidebarPadding.PaddingBottom = UDim.new(0, 10)
    
    -- ═══════════════════════════════════════════════════════════════════════
    --                          CONTENT AREA (Área de Contenido iOS)
    -- ═══════════════════════════════════════════════════════════════════════
    
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ContentArea.BackgroundTransparency = 0.95
    ContentArea.BorderSizePixel = 0
    ContentArea.Position = UDim2.new(0, 150, 0, 70)
    ContentArea.Size = UDim2.new(1, -160, 1, -80)
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 15)
    ContentCorner.Parent = ContentArea
    
    local ContentStroke = Instance.new("UIStroke")
    ContentStroke.Parent = ContentArea
    ContentStroke.Color = Color3.fromRGB(255, 255, 255)
    ContentStroke.Transparency = 0.9
    ContentStroke.Thickness = 1
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.Parent = ContentArea
    ContentPadding.PaddingTop = UDim.new(0, 15)
    ContentPadding.PaddingLeft = UDim.new(0, 15)
    ContentPadding.PaddingRight = UDim.new(0, 15)
    ContentPadding.PaddingBottom = UDim.new(0, 15)
    
    -- ═══════════════════════════════════════════════════════════════════════
    --                          FUNCIONES DE UTILIDAD iOS
    -- ═══════════════════════════════════════════════════════════════════════
    
    local function CreateSidebarButton(text, icon, layoutOrder)
        local Button = Instance.new("TextButton")
        Button.Name = text .. "Button"
        Button.Parent = Sidebar
        Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Button.BackgroundTransparency = 0.9
        Button.BorderSizePixel = 0
        Button.Size = UDim2.new(1, 0, 0, 45)
        Button.Font = Enum.Font.GothamMedium
        Button.Text = "  " .. icon .. " " .. text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Button.LayoutOrder = layoutOrder
        Button.AutoButtonColor = false
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 10)
        ButtonCorner.Parent = Button
        
        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Parent = Button
        ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
        ButtonStroke.Transparency = 0.95
        ButtonStroke.Thickness = 1
        
        -- Efecto hover iOS
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.85
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            if Button.BackgroundTransparency ~= 0.7 then
                TweenService:Create(Button, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0.9
                }):Play()
            end
        end)
        
        return Button
    end
    
    local function CreateToggle(parent, text, yPos, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = text .. "Toggle"
        ToggleFrame.Parent = parent
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleFrame.BackgroundTransparency = 0.9
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Position = UDim2.new(0, 0, 0, yPos)
        ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 12)
        ToggleCorner.Parent = ToggleFrame
        
        local ToggleStroke = Instance.new("UIStroke")
        ToggleStroke.Parent = ToggleFrame
        ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
        ToggleStroke.Transparency = 0.9
        ToggleStroke.Thickness = 1
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Parent = ToggleFrame
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
        ToggleLabel.Size = UDim2.new(0, 200, 1, 0)
        ToggleLabel.Font = Enum.Font.GothamMedium
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleLabel.TextSize = 15
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleFrame
        ToggleButton.BackgroundColor3 = Color3.fromRGB(120, 120, 128)
        ToggleButton.BackgroundTransparency = 0.2
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Position = UDim2.new(1, -65, 0.5, -13)
        ToggleButton.Size = UDim2.new(0, 51, 0, 26)
        ToggleButton.Text = ""
        ToggleButton.AutoButtonColor = false
        
        local ToggleBtnCorner = Instance.new("UICorner")
        ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
        ToggleBtnCorner.Parent = ToggleButton
        
        local ToggleIndicator = Instance.new("Frame")
        ToggleIndicator.Name = "Indicator"
        ToggleIndicator.Parent = ToggleButton
        ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleIndicator.BorderSizePixel = 0
        ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -11)
        ToggleIndicator.Size = UDim2.new(0, 22, 0, 22)
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = ToggleIndicator
        
        -- Sombra del indicador
        local IndicatorShadow = Instance.new("UIStroke")
        IndicatorShadow.Parent = ToggleIndicator
        IndicatorShadow.Color = Color3.fromRGB(0, 0, 0)
        IndicatorShadow.Transparency = 0.8
        IndicatorShadow.Thickness = 1
        
        local toggled = false
        
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            local indicatorPos = toggled and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
            local buttonColor = toggled and Color3.fromRGB(52, 199, 89) or Color3.fromRGB(120, 120, 128)
            
            TweenService:Create(ToggleIndicator, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = indicatorPos
            }):Play()
            
            TweenService:Create(ToggleButton, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundColor3 = buttonColor,
                BackgroundTransparency = toggled and 0 or 0.2
            }):Play()
            
            if callback then
                callback(toggled)
            end
        end)
        
        return ToggleFrame
    end
    
    local function CreateSlider(parent, text, yPos, minVal, maxVal, defaultVal, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = text .. "Slider"
        SliderFrame.Parent = parent
        SliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderFrame.BackgroundTransparency = 0.9
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Position = UDim2.new(0, 0, 0, yPos)
        SliderFrame.Size = UDim2.new(1, 0, 0, 55)
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 12)
        SliderCorner.Parent = SliderFrame
        
        local SliderStroke = Instance.new("UIStroke")
        SliderStroke.Parent = SliderFrame
        SliderStroke.Color = Color3.fromRGB(255, 255, 255)
        SliderStroke.Transparency = 0.9
        SliderStroke.Thickness = 1
        
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Parent = SliderFrame
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Position = UDim2.new(0, 15, 0, 5)
        SliderLabel.Size = UDim2.new(0, 200, 0, 20)
        SliderLabel.Font = Enum.Font.GothamMedium
        SliderLabel.Text = text
        SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderLabel.TextSize = 14
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Parent = SliderFrame
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Position = UDim2.new(1, -60, 0, 5)
        ValueLabel.Size = UDim2.new(0, 50, 0, 20)
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.Text = tostring(defaultVal)
        ValueLabel.TextColor3 = Color3.fromRGB(52, 199, 89)
        ValueLabel.TextSize = 14
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        local SliderBar = Instance.new("Frame")
        SliderBar.Name = "SliderBar"
        SliderBar.Parent = SliderFrame
        SliderBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderBar.BackgroundTransparency = 0.8
        SliderBar.BorderSizePixel = 0
        SliderBar.Position = UDim2.new(0, 15, 1, -20)
        SliderBar.Size = UDim2.new(1, -30, 0, 4)
        
        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = SliderBar
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "Fill"
        SliderFill.Parent = SliderBar
        SliderFill.BackgroundColor3 = Color3.fromRGB(52, 199, 89)
        SliderFill.BorderSizePixel = 0
        SliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
        
        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = SliderFill
        
        local SliderButton = Instance.new("TextButton")
        SliderButton.Parent = SliderBar
        SliderButton.BackgroundTransparency = 1
        SliderButton.Size = UDim2.new(1, 0, 3, 0)
        SliderButton.Position = UDim2.new(0, 0, -1, 0)
        SliderButton.Text = ""
        
        local dragging = false
        
        SliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mousePos = UserInputService:GetMouseLocation().X
                local barPos = SliderBar.AbsolutePosition.X
                local barSize = SliderBar.AbsoluteSize.X
                local relative = math.clamp((mousePos - barPos) / barSize, 0, 1)
                local value = math.floor(minVal + (maxVal - minVal) * relative)
                
                TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(relative, 0, 1, 0)}):Play()
                ValueLabel.Text = tostring(value)
                
                if callback then
                    callback(value)
                end
            end
        end)
        
        return SliderFrame
    end
    
    local function CreateButton(parent, text, yPos, callback)
        local Button = Instance.new("TextButton")
        Button.Name = text .. "Button"
        Button.Parent = parent
        Button.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
        Button.BackgroundTransparency = 0.1
        Button.BorderSizePixel = 0
        Button.Position = UDim2.new(0, 0, 0, yPos)
        Button.Size = UDim2.new(1, 0, 0, 45)
        Button.Font = Enum.Font.GothamBold
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 15
        Button.AutoButtonColor = false
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 12)
        ButtonCorner.Parent = Button
        
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0,
                BackgroundColor3 = Color3.fromRGB(10, 132, 255)
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.1,
                BackgroundColor3 = Color3.fromRGB(0, 122, 255)
            }):Play()
        end)
        
        if callback then
            Button.MouseButton1Click:Connect(callback)
        end
        
        return Button
    end
    
    -- ═══════════════════════════════════════════════════════════════════════
    --                          CREAR PÁGINAS
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Página Home
    local HomePage = Instance.new("ScrollingFrame")
    HomePage.Name = "HomePage"
    HomePage.Parent = ContentArea
    HomePage.BackgroundTransparency = 1
    HomePage.BorderSizePixel = 0
    HomePage.Size = UDim2.new(1, 0, 1, 0)
    HomePage.CanvasSize = UDim2.new(0, 0, 0, 100)
    HomePage.ScrollBarThickness = 4
    HomePage.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    HomePage.ScrollBarImageTransparency = 0.8
    HomePage.Visible = true
    
    CreateButton(HomePage, "📦 Copy Game", 10, function()
        local success, SaveInstance = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/saveinstance.luau", true))()
        end)
        
        if success then
            task.spawn(function()
                pcall(function()
                    SaveInstance({mode = "optimized", ShowStatus = true, ReadMe = true, SaveBytecode = true, timeout = 15})
                end)
            end)
        end
    end)
    
    -- Página Player
    local PlayerPage = Instance.new("ScrollingFrame")
    PlayerPage.Name = "PlayerPage"
    PlayerPage.Parent = ContentArea
    PlayerPage.BackgroundTransparency = 1
    PlayerPage.BorderSizePixel = 0
    PlayerPage.Size = UDim2.new(1, 0, 1, 0)
    PlayerPage.CanvasSize = UDim2.new(0, 0, 0, 600)
    PlayerPage.ScrollBarThickness = 4
    PlayerPage.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    PlayerPage.ScrollBarImageTransparency = 0.8
    PlayerPage.Visible = false
    
    CreateToggle(PlayerPage, "✈️ Fly", 10, function(state) ToggleFly(state) end)
    CreateSlider(PlayerPage, "Fly Speed", 70, 10, 200, 50, function(val) FlySpeed = val end)
    CreateToggle(PlayerPage, "👻 Noclip", 135, function(state) ToggleNoclip(state) end)
    CreateToggle(PlayerPage, "🛡️ God Mode", 195, function(state) ToggleGodmode(state) end)
    CreateToggle(PlayerPage, "🦘 Infinite Jump", 255, function(state) ToggleInfiniteJump(state) end)
    CreateSlider(PlayerPage, "Walk Speed", 315, 16, 200, 16, function(val)
        WalkSpeed = val
        if Humanoid then Humanoid.WalkSpeed = val end
    end)
    CreateSlider(PlayerPage, "Jump Power", 380, 50, 300, 50, function(val)
        JumpPower = val
        if Humanoid then Humanoid.JumpPower = val end
    end)
    
    -- Página Visual
    local VisualPage = Instance.new("ScrollingFrame")
    VisualPage.Name = "VisualPage"
    VisualPage.Parent = ContentArea
    VisualPage.BackgroundTransparency = 1
    VisualPage.BorderSizePixel = 0
    VisualPage.Size = UDim2.new(1, 0, 1, 0)
    VisualPage.CanvasSize = UDim2.new(0, 0, 0, 400)
    VisualPage.ScrollBarThickness = 4
    VisualPage.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    VisualPage.ScrollBarImageTransparency = 0.8
    VisualPage.Visible = false
    
    CreateToggle(VisualPage, "👁️ ESP", 10, function(state) ToggleESP(state) end)
    CreateToggle(VisualPage, "🌙 Fullbright", 70, function(state)
        local Lighting = game:GetService("Lighting")
        if state then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        end
    end)
    CreateSlider(VisualPage, "🎥 FOV", 130, 70, 120, 70, function(val)
        workspace.CurrentCamera.FieldOfView = val
    end)
    
    -- Página Game Info
    local GameInfoPage = Instance.new("ScrollingFrame")
    GameInfoPage.Name = "GameInfoPage"
    GameInfoPage.Parent = ContentArea
    GameInfoPage.BackgroundTransparency = 1
    GameInfoPage.BorderSizePixel = 0
    GameInfoPage.Size = UDim2.new(1, 0, 1, 0)
    GameInfoPage.CanvasSize = UDim2.new(0, 0, 0, 800)
    GameInfoPage.ScrollBarThickness = 4
    GameInfoPage.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    GameInfoPage.ScrollBarImageTransparency = 0.8
    GameInfoPage.Visible = false
    
    -- Función para crear info cards
    local function CreateInfoCard(parent, title, content, yPos)
        local Card = Instance.new("Frame")
        Card.Parent = parent
        Card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Card.BackgroundTransparency = 0.9
        Card.BorderSizePixel = 0
        Card.Position = UDim2.new(0, 0, 0, yPos)
        Card.Size = UDim2.new(1, 0, 0, 90)
        
        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 12)
        CardCorner.Parent = Card
        
        local CardStroke = Instance.new("UIStroke")
        CardStroke.Parent = Card
        CardStroke.Color = Color3.fromRGB(255, 255, 255)
        CardStroke.Transparency = 0.9
        CardStroke.Thickness = 1
        
        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Parent = Card
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Position = UDim2.new(0, 15, 0, 10)
        TitleLabel.Size = UDim2.new(1, -30, 0, 20)
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        TitleLabel.TextSize = 13
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local ContentLabel = Instance.new("TextLabel")
        ContentLabel.Parent = Card
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Position = UDim2.new(0, 15, 0, 35)
        ContentLabel.Size = UDim2.new(1, -30, 1, -45)
        ContentLabel.Font = Enum.Font.Gotham
        ContentLabel.Text = content
        ContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ContentLabel.TextSize = 14
        ContentLabel.TextWrapped = true
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
        
        return Card
    end
    
    -- Obtener información del juego
    local GameName = "Loading..."
    pcall(function()
        GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)
    
    local function GetFPS()
        local fps = 0
        pcall(function()
            fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
        end)
        return fps
    end
    
    local function GetMemoryUsage()
        local memory = game:GetService("Stats"):GetTotalMemoryUsageMb()
        return string.format("%.2f MB", memory)
    end
    
    -- Game Details Card
    CreateInfoCard(GameInfoPage, "🎮 GAME DETAILS", 
        string.format("Name: %s\nPlace ID: %d\nVersion: %d\nCreator Type: %s",
            GameName,
            game.PlaceId,
            game.PlaceVersion,
            game.CreatorType == Enum.CreatorType.User and "User" or "Group"
        ), 10)
    
    -- Player Info Card
    CreateInfoCard(GameInfoPage, "👤 YOUR ACCOUNT",
        string.format("Username: %s\nDisplay Name: %s\nUser ID: %d\nAccount Age: %d days",
            LocalPlayer.Name,
            LocalPlayer.DisplayName,
            LocalPlayer.UserId,
            LocalPlayer.AccountAge
        ), 110)
    
    -- Server Info Card
    CreateInfoCard(GameInfoPage, "🌐 SERVER INFO",
        string.format("Players: %d/%d\nJob ID: %s\nServer Type: %s\nPrivate Server: %s",
            #Players:GetPlayers(),
            Players.MaxPlayers,
            string.sub(game.JobId, 1, 25) .. "...",
            game.PrivateServerId ~= "" and "Private" or "Public",
            game.PrivateServerId ~= "" and "Yes" or "No"
        ), 210)
    
    -- Performance Card
    CreateInfoCard(GameInfoPage, "⚡ PERFORMANCE",
        string.format("FPS: ~%d\nPing: %d ms\nMemory: %s\nGraphics Quality: %s",
            GetFPS(),
            math.floor(LocalPlayer:GetNetworkPing() * 1000),
            GetMemoryUsage(),
            tostring(workspace.CurrentCamera.CameraType)
        ), 310)
    
    -- Character Stats Card
    local characterStats = "Health: N/A\nWalk Speed: N/A\nJump Power: N/A"
    if Humanoid then
        characterStats = string.format("Health: %.0f/%.0f\nWalk Speed: %.0f\nJump Power: %.0f\nState: %s",
            Humanoid.Health,
            Humanoid.MaxHealth,
            Humanoid.WalkSpeed,
            Humanoid.JumpPower,
            tostring(Humanoid:GetState())
        )
    end
    CreateInfoCard(GameInfoPage, "❤️ CHARACTER STATS", characterStats, 410)
    
    -- Workspace Info Card
    local function GetWorkspaceInfo()
        local parts = 0
        local models = 0
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                parts = parts + 1
            elseif obj:IsA("Model") then
                models = models + 1
            end
        end
        return parts, models
    end
    
    local parts, models = GetWorkspaceInfo()
    CreateInfoCard(GameInfoPage, "📦 WORKSPACE",
        string.format("Total Parts: %d\nTotal Models: %d\nGravity: %.1f\nStreaming Enabled: %s",
            parts,
            models,
            workspace.Gravity,
            tostring(workspace.StreamingEnabled)
        ), 510)
    
    -- Device Info Card
    local function GetDeviceType()
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            return "📱 Mobile"
        elseif UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
            return "💻 Desktop"
        elseif UserInputService.GamepadEnabled then
            return "🎮 Console"
        else
            return "❓ Unknown"
        end
    end
    
    CreateInfoCard(GameInfoPage, "📱 DEVICE INFO",
        string.format("Type: %s\nKeyboard: %s\nMouse: %s\nTouch: %s\nGamepad: %s",
            GetDeviceType(),
            UserInputService.KeyboardEnabled and "Yes" or "No",
            UserInputService.MouseEnabled and "Yes" or "No",
            UserInputService.TouchEnabled and "Yes" or "No",
            UserInputService.GamepadEnabled and "Yes" or "No"
        ), 610)
    
    -- Refresh Button
    CreateButton(GameInfoPage, "🔄 Refresh Info", 710, function()
        -- Recreate all info cards with updated data
        for _, child in pairs(GameInfoPage:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Recreate cards
        local GameName = "Loading..."
        pcall(function()
            GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
        end)
        
        CreateInfoCard(GameInfoPage, "🎮 GAME DETAILS", 
            string.format("Name: %s\nPlace ID: %d\nVersion: %d\nCreator Type: %s",
                GameName,
                game.PlaceId,
                game.PlaceVersion,
                game.CreatorType == Enum.CreatorType.User and "User" or "Group"
            ), 10)
        
        CreateInfoCard(GameInfoPage, "👤 YOUR ACCOUNT",
            string.format("Username: %s\nDisplay Name: %s\nUser ID: %d\nAccount Age: %d days",
                LocalPlayer.Name,
                LocalPlayer.DisplayName,
                LocalPlayer.UserId,
                LocalPlayer.AccountAge
            ), 110)
        
        CreateInfoCard(GameInfoPage, "🌐 SERVER INFO",
            string.format("Players: %d/%d\nJob ID: %s\nServer Type: %s\nPrivate Server: %s",
                #Players:GetPlayers(),
                Players.MaxPlayers,
                string.sub(game.JobId, 1, 25) .. "...",
                game.PrivateServerId ~= "" and "Private" or "Public",
                game.PrivateServerId ~= "" and "Yes" or "No"
            ), 210)
        
        CreateInfoCard(GameInfoPage, "⚡ PERFORMANCE",
            string.format("FPS: ~%d\nPing: %d ms\nMemory: %s\nGraphics Quality: %s",
                GetFPS(),
                math.floor(LocalPlayer:GetNetworkPing() * 1000),
                GetMemoryUsage(),
                tostring(workspace.CurrentCamera.CameraType)
            ), 310)
        
        local characterStats = "Health: N/A\nWalk Speed: N/A\nJump Power: N/A"
        if Humanoid then
            characterStats = string.format("Health: %.0f/%.0f\nWalk Speed: %.0f\nJump Power: %.0f\nState: %s",
                Humanoid.Health,
                Humanoid.MaxHealth,
                Humanoid.WalkSpeed,
                Humanoid.JumpPower,
                tostring(Humanoid:GetState())
            )
        end
        CreateInfoCard(GameInfoPage, "❤️ CHARACTER STATS", characterStats, 410)
        
        local parts, models = GetWorkspaceInfo()
        CreateInfoCard(GameInfoPage, "📦 WORKSPACE",
            string.format("Total Parts: %d\nTotal Models: %d\nGravity: %.1f\nStreaming Enabled: %s",
                parts,
                models,
                workspace.Gravity,
                tostring(workspace.StreamingEnabled)
            ), 510)
        
        CreateInfoCard(GameInfoPage, "📱 DEVICE INFO",
            string.format("Type: %s\nKeyboard: %s\nMouse: %s\nTouch: %s\nGamepad: %s",
                GetDeviceType(),
                UserInputService.KeyboardEnabled and "Yes" or "No",
                UserInputService.MouseEnabled and "Yes" or "No",
                UserInputService.TouchEnabled and "Yes" or "No",
                UserInputService.GamepadEnabled and "Yes" or "No"
            ), 610)
        
        CreateButton(GameInfoPage, "🔄 Refresh Info", 710, function() end)
    end)
    
    -- Página Settings
    local SettingsPage = Instance.new("ScrollingFrame")
    SettingsPage.Name = "SettingsPage"
    SettingsPage.Parent = ContentArea
    SettingsPage.BackgroundTransparency = 1
    SettingsPage.BorderSizePixel = 0
    SettingsPage.Size = UDim2.new(1, 0, 1, 0)
    SettingsPage.CanvasSize = UDim2.new(0, 0, 0, 300)
    SettingsPage.ScrollBarThickness = 4
    SettingsPage.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    SettingsPage.ScrollBarImageTransparency = 0.8
    SettingsPage.Visible = false
    
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Parent = SettingsPage
    InfoLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    InfoLabel.BackgroundTransparency = 0.9
    InfoLabel.BorderSizePixel = 0
    InfoLabel.Size = UDim2.new(1, 0, 0, 140)
    InfoLabel.Font = Enum.Font.GothamMedium
    InfoLabel.Text = "✨ NEBULA STUDIOS\n\nVersion 3.0 iOS Edition\nCreated by Ladix\n\nModern iOS 26 Style GUI\nPress K to toggle"
    InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    InfoLabel.TextSize = 14
    InfoLabel.TextWrapped = true
    InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
    
    local InfoCorner = Instance.new("UICorner")
    InfoCorner.CornerRadius = UDim.new(0, 12)
    InfoCorner.Parent = InfoLabel
    
    local InfoStroke = Instance.new("UIStroke")
    InfoStroke.Parent = InfoLabel
    InfoStroke.Color = Color3.fromRGB(255, 255, 255)
    InfoStroke.Transparency = 0.9
    InfoStroke.Thickness = 1
    
    local InfoPadding = Instance.new("UIPadding")
    InfoPadding.Parent = InfoLabel
    InfoPadding.PaddingTop = UDim.new(0, 15)
    InfoPadding.PaddingLeft = UDim.new(0, 15)
    InfoPadding.PaddingRight = UDim.new(0, 15)
    
    -- ═══════════════════════════════════════════════════════════════════════
    --                          CREAR BOTONES DE SIDEBAR
    -- ═══════════════════════════════════════════════════════════════════════
    
    local HomeBtn = CreateSidebarButton("Home", "🏠", 1)
    local PlayerBtn = CreateSidebarButton("Player", "🎮", 2)
    local VisualBtn = CreateSidebarButton("Visual", "👁️", 3)
    local GameInfoBtn = CreateSidebarButton("Info", "📊", 4)
    local SettingsBtn = CreateSidebarButton("Settings", "⚙️", 5)
    
    local currentPage = HomePage
    
    local function SwitchPage(newPage, button)
        currentPage.Visible = false
        newPage.Visible = true
        currentPage = newPage
        
        -- Reset all buttons
        for _, btn in pairs(Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundTransparency = 0.9
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
        
        -- Highlight selected button
        button.BackgroundTransparency = 0.7
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    HomeBtn.MouseButton1Click:Connect(function() SwitchPage(HomePage, HomeBtn) end)
    PlayerBtn.MouseButton1Click:Connect(function() SwitchPage(PlayerPage, PlayerBtn) end)
    VisualBtn.MouseButton1Click:Connect(function() SwitchPage(VisualPage, VisualBtn) end)
    GameInfoBtn.MouseButton1Click:Connect(function() SwitchPage(GameInfoPage, GameInfoBtn) end)
    SettingsBtn.MouseButton1Click:Connect(function() SwitchPage(SettingsPage, SettingsBtn) end)
    
    -- Set Home as default
    HomeBtn.BackgroundTransparency = 0.7
    
    -- ═══════════════════════════════════════════════════════════════════════
    --                          BOTONES DE CONTROL
    -- ═══════════════════════════════════════════════════════════════════════
    
    CloseButton.MouseButton1Click:Connect(function()
        ToggleFly(false)
        ToggleNoclip(false)
        ToggleGodmode(false)
        ToggleInfiniteJump(false)
        ToggleESP(false)
        UpdateBlur(false)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(0, 520, 0, 60) or UDim2.new(0, 520, 0, 470)
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    end)
    
    -- ═══════════════════════════════════════════════════════════════════════
    --                          TOGGLE UI CON TECLA
    -- ═══════════════════════════════════════════════════════════════════════
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
            MainFrame.Visible = not MainFrame.Visible
            UpdateBlur(MainFrame.Visible)
        end
    end)
    
    -- Activar blur inicial
    UpdateBlur(true)
end

-- ═══════════════════════════════════════════════════════════════════════════
--                              INICIAR GUI
-- ═══════════════════════════════════════════════════════════════════════════

CreateiOSGUI()

print([[
╔═══════════════════════════════════════════════════════════════════════════╗
║                  ✨ NEBULA STUDIOS - iOS 26 STYLE GUI ✨                   ║
║                                                                           ║
║  ✅ GUI Loaded Successfully                                              ║
║  📱 iOS Glassmorphism Effect Active                                      ║
║  ⌨️  Press K to toggle UI                                                 ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
]])
