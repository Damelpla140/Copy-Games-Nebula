--[[
╔═══════════════════════════════════════════════════════════════════════════╗
║                    ✨ NEBULA STUDIOS - COPY GAME ✨                       ║
╚═══════════════════════════════════════════════════════════════════════════╝
--]]

-- ═══════════════════════════════════════════════════════════════════════════
--                              SERVICES
-- ═══════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

-- ═══════════════════════════════════════════════════════════════════════════
--                              GET EXECUTOR INFO
-- ═══════════════════════════════════════════════════════════════════════════

local function GetExecutorName()
    local executors = {
        "Synapse X", "Fluxus", "Krnl", "Script-Ware", "Sentinel", 
        "Trigon", "Arceus X", "Delta", "Codex", "Electron",
        "Wave", "Solara", "Nezur", "Evon", "Hydrogen"
    }
    
    if identifyexecutor then
        return identifyexecutor()
    elseif getexecutorname then
        return getexecutorname()
    elseif whatexecutor then
        return whatexecutor()
    end
    
    -- Detectar por funciones específicas
    for _, executor in ipairs(executors) do
        if _G[executor:gsub(" ", "")] or _G[executor:lower():gsub(" ", "")] then
            return executor
        end
    end
    
    return "Unknown"
end

local ExecutorName = GetExecutorName()

-- ═══════════════════════════════════════════════════════════════════════════
--                              GET DEVICE INFO
-- ═══════════════════════════════════════════════════════════════════════════

local function GetDeviceType()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "📱 Mobile"
    elseif UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        return "💻 PC"
    elseif UserInputService.GamepadEnabled then
        return "🎮 Console"
    else
        return "❓ Unknown"
    end
end

local function GetPlatform()
    if UserInputService.TouchEnabled then
        if game:GetService("GuiService"):IsTenFootInterface() then
            return "Console"
        else
            return "Mobile"
        end
    else
        return "Desktop"
    end
end

local DeviceType = GetDeviceType()
local Platform = GetPlatform()

-- ═══════════════════════════════════════════════════════════════════════════
--                              GET GAME INFO
-- ═══════════════════════════════════════════════════════════════════════════

local GameName = "Loading..."
pcall(function()
    GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

local function GetMemoryUsage()
    local memory = Stats:GetTotalMemoryUsageMb()
    return string.format("%.2f MB", memory)
end

local function GetFPS()
    local fps = 0
    pcall(function()
        fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
    end)
    return fps
end

-- ═══════════════════════════════════════════════════════════════════════════
--                              UI LIBRARY
-- ═══════════════════════════════════════════════════════════════════════════

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ═══════════════════════════════════════════════════════════════════════════
--                              WINDOW
-- ═══════════════════════════════════════════════════════════════════════════

local Window = Rayfield:CreateWindow({
    Name = "✨ NEBULA - COPY GAME",
    LoadingTitle = "Nebula Studios",
    LoadingSubtitle = "by Ladix",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- ═══════════════════════════════════════════════════════════════════════════
--                              TAB: COPY GAME
-- ═══════════════════════════════════════════════════════════════════════════

local MainTab = Window:CreateTab("📦 COPY GAME", 4483362458)

MainTab:CreateLabel("════════════════════════════════")
MainTab:CreateLabel("✨ NEBULA STUDIOS")
MainTab:CreateLabel("════════════════════════════════")

MainTab:CreateButton({
    Name = "📦 COPY GAME",
    Callback = function()
        Rayfield:Notify({
            Title = "⏳ Loading",
            Content = "Loading SaveInstance...",
            Duration = 3,
            Image = 4483362458,
        })
        
        local success, SaveInstance = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/saveinstance.luau", true), "saveinstance")()
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "❌ Error",
                Content = "Failed to load SaveInstance",
                Duration = 5,
                Image = 4483362458,
            })
            return
        end
        
        Rayfield:Notify({
            Title = "💾 Saving",
            Content = "Saving game... Please wait",
            Duration = 5,
            Image = 4483362458,
        })
        
        task.spawn(function()
            local ok = pcall(function()
                SaveInstance({
                    mode = "optimized",
                    ShowStatus = true,
                    ReadMe = true,
                    SaveBytecode = true,
                    timeout = 15,
                })
            end)
            
            if ok then
                Rayfield:Notify({
                    Title = "✅ Success",
                    Content = "Game saved successfully!",
                    Duration = 8,
                    Image = 4483362458,
                })
            else
                Rayfield:Notify({
                    Title = "❌ Error",
                    Content = "Failed to save game",
                    Duration = 8,
                    Image = 4483362458,
                })
            end
        end)
    end,
})

-- ═══════════════════════════════════════════════════════════════════════════
--                              TAB: GAME INFO
-- ═══════════════════════════════════════════════════════════════════════════

local GameTab = Window:CreateTab("🎮 GAME INFO", 4483362458)

GameTab:CreateLabel("════════════════════════════════")
GameTab:CreateLabel("🎮 GAME INFORMATION")
GameTab:CreateLabel("════════════════════════════════")

GameTab:CreateParagraph({
    Title = "📋 Game Details",
    Content = string.format(
        "Name: %s\nPlace ID: %d\nVersion: %d\nCreator: %s",
        GameName,
        game.PlaceId,
        game.PlaceVersion,
        game.CreatorType == Enum.CreatorType.User and "User" or "Group"
    )
})

GameTab:CreateParagraph({
    Title = "👥 Players",
    Content = string.format(
        "Current: %d\nMax Players: %d\nPrivate Server: %s",
        #Players:GetPlayers(),
        Players.MaxPlayers,
        game.PrivateServerId ~= "" and "Yes" or "No"
    )
})

GameTab:CreateParagraph({
    Title = "⚙️ Performance",
    Content = string.format(
        "Memory Usage: %s\nFPS: ~%d\nPing: %d ms",
        GetMemoryUsage(),
        GetFPS(),
        math.floor(Players.LocalPlayer:GetNetworkPing() * 1000)
    )
})

GameTab:CreateParagraph({
    Title = "🌐 Server Info",
    Content = string.format(
        "Job ID: %s\nServer Type: %s",
        string.sub(game.JobId, 1, 20) .. "...",
        game.PrivateServerId ~= "" and "Private" or "Public"
    )
})

-- ═══════════════════════════════════════════════════════════════════════════
--                              TAB: PLAYER INFO
-- ═══════════════════════════════════════════════════════════════════════════

local PlayerTab = Window:CreateTab("👤 PLAYER INFO", 4483362458)

PlayerTab:CreateLabel("════════════════════════════════")
PlayerTab:CreateLabel("👤 YOUR INFORMATION")
PlayerTab:CreateLabel("════════════════════════════════")

PlayerTab:CreateParagraph({
    Title = "👤 Account",
    Content = string.format(
        "Username: %s\nDisplay Name: %s\nUser ID: %d\nAccount Age: %d days",
        LocalPlayer.Name,
        LocalPlayer.DisplayName,
        LocalPlayer.UserId,
        LocalPlayer.AccountAge
    )
})

PlayerTab:CreateParagraph({
    Title = "⭐ Membership",
    Content = string.format(
        "Premium: %s\nVerified: %s",
        LocalPlayer.MembershipType == Enum.MembershipType.Premium and "Yes ⭐" or "No",
        LocalPlayer.HasVerifiedBadge and "Yes ✓" or "No"
    )
})

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")

PlayerTab:CreateParagraph({
    Title = "❤️ Character Stats",
    Content = string.format(
        "Health: %.0f/%.0f\nWalk Speed: %d\nJump Power: %d",
        Humanoid and Humanoid.Health or 0,
        Humanoid and Humanoid.MaxHealth or 0,
        Humanoid and Humanoid.WalkSpeed or 0,
        Humanoid and Humanoid.JumpPower or 0
    )
})

-- ═══════════════════════════════════════════════════════════════════════════
--                              TAB: DEVICE INFO
-- ═══════════════════════════════════════════════════════════════════════════

local DeviceTab = Window:CreateTab("📱 DEVICE INFO", 4483362458)

DeviceTab:CreateLabel("════════════════════════════════")
DeviceTab:CreateLabel("📱 DEVICE INFORMATION")
DeviceTab:CreateLabel("════════════════════════════════")

DeviceTab:CreateParagraph({
    Title = "💻 Device Type",
    Content = string.format(
        "Type: %s\nPlatform: %s\nTouch Enabled: %s",
        DeviceType,
        Platform,
        UserInputService.TouchEnabled and "Yes" or "No"
    )
})

DeviceTab:CreateParagraph({
    Title = "⌨️ Input Methods",
    Content = string.format(
        "Keyboard: %s\nMouse: %s\nGamepad: %s\nTouch: %s",
        UserInputService.KeyboardEnabled and "✓" or "✗",
        UserInputService.MouseEnabled and "✓" or "✗",
        UserInputService.GamepadEnabled and "✓" or "✗",
        UserInputService.TouchEnabled and "✓" or "✗"
    )
})

DeviceTab:CreateParagraph({
    Title = "🖥️ Display",
    Content = string.format(
        "Resolution: %dx%d\nVR Enabled: %s\nGyroscope: %s",
        workspace.CurrentCamera.ViewportSize.X,
        workspace.CurrentCamera.ViewportSize.Y,
        UserInputService.VREnabled and "Yes" or "No",
        UserInputService.GyroscopeEnabled and "Yes" or "No"
    )
})

-- ═══════════════════════════════════════════════════════════════════════════
--                              TAB: EXECUTOR INFO
-- ═══════════════════════════════════════════════════════════════════════════

local ExecTab = Window:CreateTab("⚡ EXECUTOR INFO", 4483362458)

ExecTab:CreateLabel("════════════════════════════════")
ExecTab:CreateLabel("⚡ EXECUTOR INFORMATION")
ExecTab:CreateLabel("════════════════════════════════")

ExecTab:CreateParagraph({
    Title = "🔧 Executor",
    Content = string.format(
        "Name: %s\nVersion: %s",
        ExecutorName,
        version and version() or "Unknown"
    )
})

-- Detectar funciones disponibles
local functions = {
    {"writefile", writefile ~= nil},
    {"readfile", readfile ~= nil},
    {"appendfile", appendfile ~= nil},
    {"isfile", isfile ~= nil},
    {"delfile", delfile ~= nil},
    {"decompile", decompile ~= nil},
    {"getscriptbytecode", getscriptbytecode ~= nil},
    {"gethiddenproperty", gethiddenproperty ~= nil},
    {"getnilinstances", getnilinstances ~= nil},
    {"hookfunction", hookfunction ~= nil},
}

local availableCount = 0
for _, func in ipairs(functions) do
    if func[2] then
        availableCount = availableCount + 1
    end
end

ExecTab:CreateParagraph({
    Title = "✓ Available Functions",
    Content = string.format(
        "Total: %d/%d available\n\nwritefile: %s\nreadfile: %s\ndecompile: %s\ngethiddenproperty: %s",
        availableCount,
        #functions,
        writefile and "✓" or "✗",
        readfile and "✓" or "✗",
        decompile and "✓" or "✗",
        gethiddenproperty and "✓" or "✗"
    )
})

ExecTab:CreateParagraph({
    Title = "🔐 Security Level",
    Content = string.format(
        "Thread Identity: %d\nCan Save Files: %s\nCan Decompile: %s",
        getthreadidentity and getthreadidentity() or 0,
        writefile and "Yes ✓" or "No ✗",
        decompile and "Yes ✓" or "No ✗"
    )
})

-- ═══════════════════════════════════════════════════════════════════════════
--                              TAB: SETTINGS
-- ═══════════════════════════════════════════════════════════════════════════

local SettingsTab = Window:CreateTab("⚙️ SETTINGS", 4483362458)

SettingsTab:CreateLabel("════════════════════════════════")
SettingsTab:CreateLabel("⚙️ SETTINGS")
SettingsTab:CreateLabel("════════════════════════════════")

SettingsTab:CreateParagraph({
    Title = "📋 About",
    Content = "Nebula Studios - Copy Game\nVersion: 2.0\nCreated by: Ladix\n\nSimple tool to copy Roblox games"
})

SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "K",
    HoldToInteract = false,
    Callback = function() end,
})

SettingsTab:CreateButton({
    Name = "❌ Close GUI",
    Callback = function()
        Rayfield:Notify({
            Title = "👋 Goodbye",
            Content = "Closing GUI...",
            Duration = 2,
            Image = 4483362458,
        })
        task.wait(2)
        Rayfield:Destroy()
    end,
})

-- ═══════════════════════════════════════════════════════════════════════════
--                              FINAL MESSAGE
-- ═══════════════════════════════════════════════════════════════════════════

print([[
╔═══════════════════════════════════════════════════════════════════════════╗
║                    ✨ NEBULA STUDIOS - COPY GAME ✨                       ║
║                                                                           ║
║  ✅ GUI Loaded Successfully                                              ║
║  🎮 Executor: ]] .. ExecutorName .. string.rep(" ", 54 - #ExecutorName) .. [[║
║  📱 Device: ]] .. DeviceType .. string.rep(" ", 56 - #DeviceType) .. [[║
║  ⌨️  Press K to toggle UI                                                 ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
]])

Rayfield:Notify({
    Title = "✨ Welcome!",
    Content = "Nebula Studios loaded!\nPress K to toggle UI",
    Duration = 5,
    Image = 4483362458,
})
