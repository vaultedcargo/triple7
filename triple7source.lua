local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vaultedcargo/triple7/refs/heads/main/librarysrc.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/vaultedcargo/triple7/refs/heads/main/libraryfunc/themefunc.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/vaultedcargo/triple7/refs/heads/main/libraryfunc/savefunc.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")

local Window = Library:CreateWindow({
    Title = "triple7 alpha / 1.1.4 / 17.04.2026",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- Combat Tab (Aimbot)
local CombatTab = Window:AddTab("Combat")

local AimbotGroup = CombatTab:AddLeftGroupbox("Aimbot")
local AimbotToggle = AimbotGroup:AddToggle("EnableAimbot", { Text = "Enable Aimbot" })
AimbotToggle:AddKeyPicker("AimbotKey", {
    Default = "MB2",
    Mode = "Hold",
    Modes = { "Hold", "Toggle", "Always" },
    Text = "Aimbot Key",
    SyncToggleState = false
})
AimbotGroup:AddToggle("InstantLock", { Text = "Instant Lock" })
AimbotGroup:AddToggle("TeamCheck", { Text = "Team Check" })
AimbotGroup:AddToggle("WallCheck", { Text = "Wall Check", Default = false })
AimbotGroup:AddToggle("DebugMode", { Text = "Debug Mode" })

local PriorityGroup = CombatTab:AddLeftGroupbox("Target Priority")
PriorityGroup:AddToggle("ProfitableFallback", { Text = "Profitable Fallback", Default = false })
PriorityGroup:AddDropdown("PriorityPart", {
    Text = "Priority Part",
    Values = { "Head", "Torso", "Arms", "Legs" },
    Default = "Head"
})

local PredictGroup = CombatTab:AddRightGroupbox("Prediction & Drop")
PredictGroup:AddToggle("Prediction", { Text = "Velocity Prediction" })
PredictGroup:AddSlider("PredictFactor", {
    Text = "Prediction Factor",
    Default = 0.05,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Suffix = ""
})
PredictGroup:AddToggle("DropComp", { Text = "Drop Compensation" })
PredictGroup:AddSlider("Gravity", {
    Text = "Gravity",
    Default = 0.1,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Suffix = ""
})

local FOVGroup = CombatTab:AddRightGroupbox("FOV")
FOVGroup:AddToggle("ShowFOV", { Text = "Show FOV Circle" })
FOVGroup:AddSlider("FOVRadius", {
    Text = "FOV Radius",
    Default = 100,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Suffix = "px"
})

local SettingsGroup = CombatTab:AddLeftGroupbox("Settings")
SettingsGroup:AddSlider("MaxDistance", {
    Text = "Max Distance",
    Default = 1000,
    Min = 67,
    Max = 10067,
    Rounding = 0,
    Suffix = " studs"
})
SettingsGroup:AddSlider("AimSpeed", {
    Text = "Aimbot Speed",
    Default = 100,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Suffix = "%"
})

local IgnoreGroup = CombatTab:AddRightGroupbox("Ignore List")
IgnoreGroup:AddDropdown("IgnorePlayers", {
    Text = "Ignored Players",
    SpecialType = "Player",
    Multi = true,
    AllowNull = true,
    Callback = function() end
})

-- Visuals Tab (Chams ESP)
local VisualsTab = Window:AddTab("Visuals")

local ChamsGroup = VisualsTab:AddLeftGroupbox("Chams ESP")
ChamsGroup:AddToggle("ChamsEnabled", { Text = "Enable Chams", Default = false })
ChamsGroup:AddToggle("ChamsTeamColor", { Text = "Use Team Color", Default = false })
ChamsGroup:AddToggle("ChamsVisibleOnly", { Text = "Visible Only", Default = false })

local FillToggle = ChamsGroup:AddToggle("ChamsFill", { Text = "Fill", Default = false })
FillToggle:AddColorPicker("ChamsFillColor", {
    Default = Color3.new(1, 0, 0),
    Title = "Fill Color"
})

local OutlineToggle = ChamsGroup:AddToggle("ChamsOutline", { Text = "Outline", Default = true })
OutlineToggle:AddColorPicker("ChamsOutlineColor", {
    Default = Color3.new(1, 0, 0),
    Title = "Outline Color"
})

ChamsGroup:AddSlider("ChamsFillTransparency", {
    Text = "Fill Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Suffix = ""
})

ChamsGroup:AddSlider("ChamsMaxFPS", {
    Text = "Max ESP FPS",
    Default = 30,
    Min = 5,
    Max = 120,
    Rounding = 0,
    Suffix = " FPS"
})

-- UI Settings Tab
local UISettingsTab = Window:AddTab("UI Settings")
local MenuGroup = UISettingsTab:AddLeftGroupbox("Menu")
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind"
})
Library.ToggleKeybind = Options.MenuKeybind

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("triple7")
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
SaveManager:BuildConfigSection(UISettingsTab)

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("triple7")
ThemeManager:ApplyToTab(UISettingsTab)

-- Watermark
Library:SetWatermark("triple7 alpha | FPS: 60 | Ping: 0")
Library:SetWatermarkVisibility(true)
if Library.Watermark then
    Library.Watermark.AnchorPoint = Vector2.new(0.5, 0)
    Library.Watermark.Position = UDim2.new(0.5, 0, 0, 10)
end

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60
RunService.RenderStepped:Connect(function()
    FrameCounter += 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    local Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    Library:SetWatermark(string.format("triple7 | FPS: %d | Ping: %d", FPS, Ping))
    if Library.Watermark then
        Library.Watermark.AnchorPoint = Vector2.new(0.5, 0)
        Library.Watermark.Position = UDim2.new(0.5, 0, 0, 10)
    end
end)

-- FOV Circle (follows mouse)
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "FOVCircle"
fovGui.Parent = CoreGui
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local fovFrame = Instance.new("Frame")
fovFrame.Size = UDim2.new(0, 200, 0, 200)
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.BackgroundTransparency = 1
fovFrame.BorderSizePixel = 0
fovFrame.Visible = false
fovFrame.ZIndex = 1000
fovFrame.Parent = fovGui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovFrame

local outlineStroke = Instance.new("UIStroke")
outlineStroke.Thickness = 3
outlineStroke.Color = Color3.fromRGB(0, 0, 0)
outlineStroke.Transparency = 0
outlineStroke.LineJoinMode = Enum.LineJoinMode.Round
outlineStroke.Parent = fovFrame

local innerStroke = Instance.new("UIStroke")
innerStroke.Thickness = 1.5
innerStroke.Color = Color3.fromRGB(255, 255, 255)
innerStroke.Transparency = 0.2
innerStroke.LineJoinMode = Enum.LineJoinMode.Round
innerStroke.Parent = fovFrame

-- Debug text
local debugText = Drawing.new("Text")
debugText.Visible = false
debugText.Color = Color3.new(1, 1, 1)
debugText.Size = 14
debugText.Center = true
debugText.Outline = true
debugText.OutlineColor = Color3.new(0, 0, 0)

-- Chams ESP Storage
local chamsFolder = Instance.new("Folder")
chamsFolder.Name = "ChamsESP"
chamsFolder.Parent = CoreGui

local playerChams = {}

local function updateChams()
    for plr, highlight in pairs(playerChams) do
        if not plr.Parent then
            highlight:Destroy()
            playerChams[plr] = nil
        end
    end

    if not Toggles.ChamsEnabled.Value then
        for _, highlight in pairs(playerChams) do
            highlight.Enabled = false
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then
            if playerChams[plr] then
                playerChams[plr].Enabled = false
            end
            continue
        end

        local highlight = playerChams[plr]
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Parent = chamsFolder
            playerChams[plr] = highlight
        end

        highlight.Adornee = char
        highlight.Enabled = true

        highlight.FillTransparency = Toggles.ChamsFill.Value and Options.ChamsFillTransparency.Value or 1
        highlight.OutlineTransparency = Toggles.ChamsOutline.Value and 0 or 1

        if Toggles.ChamsTeamColor.Value and plr.Team then
            local teamColor = plr.Team.TeamColor.Color
            highlight.FillColor = teamColor
            highlight.OutlineColor = teamColor
        else
            highlight.FillColor = Options.ChamsFillColor.Value
            highlight.OutlineColor = Options.ChamsOutlineColor.Value
        end

        highlight.DepthMode = Toggles.ChamsVisibleOnly.Value and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
    end
end

-- Profitable fallback order (R6 and R15)
local R6_PROFITABLE = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"}
local R15_PROFITABLE = {
    "Head",
    "UpperTorso", "LowerTorso", "Torso",
    "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand",
    "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot",
    "HumanoidRootPart"
}

local PRIORITY_MAP = {
    Head = {"Head"},
    Torso = {"UpperTorso", "LowerTorso", "Torso"},
    Arms = {"LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand", "Left Arm", "Right Arm"},
    Legs = {"LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot", "Left Leg", "Right Leg"}
}

-- Cache player data per frame
local playerCache = {}

local function updatePlayerCache()
    table.clear(playerCache)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
                    playerCache[plr] = {
                        char = char,
                        root = root,
                        velocity = root and root.Velocity or Vector3.zero,
                        isR15 = char:FindFirstChild("UpperTorso") ~= nil,
                        team = plr.Team,
                        name = plr.Name
                    }
                end
            end
        end
    end
end

local function isVisible(part, char)
    local camPos = Camera.CFrame.Position
    local dir = (part.Position - camPos).Unit
    local dist = (part.Position - camPos).Magnitude
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = { LocalPlayer.Character, char }
    return workspace:Raycast(camPos, dir * dist, params) == nil
end

local function partIntersectsFOV(part, center, radius, predictedPos)
    local half = part.Size / 2
    local corners = {
        predictedPos + Vector3.new( half.X,  half.Y,  half.Z),
        predictedPos + Vector3.new(-half.X,  half.Y,  half.Z),
        predictedPos + Vector3.new( half.X, -half.Y,  half.Z),
        predictedPos + Vector3.new(-half.X, -half.Y,  half.Z),
        predictedPos + Vector3.new( half.X,  half.Y, -half.Z),
        predictedPos + Vector3.new(-half.X,  half.Y, -half.Z),
        predictedPos + Vector3.new( half.X, -half.Y, -half.Z),
        predictedPos + Vector3.new(-half.X, -half.Y, -half.Z)
    }
    for _, corner in ipairs(corners) do
        local screenPos, onScreen = Camera:WorldToScreenPoint(corner)
        if onScreen then
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
            if dist <= radius then
                return true
            end
        end
    end
    return false
end

local function getTarget()
    updatePlayerCache()
    local mousePos = UserInputService:GetMouseLocation()
    local radius = Options.FOVRadius.Value
    local maxDist = Options.MaxDistance.Value
    local teamCheck = Toggles.TeamCheck.Value
    local wallCheck = Toggles.WallCheck.Value
    local prediction = Toggles.Prediction.Value
    local predictFactor = Options.PredictFactor.Value
    local dropComp = Toggles.DropComp.Value
    local gravity = Options.Gravity.Value
    local profitable = Toggles.ProfitableFallback.Value
    local priority = Options.PriorityPart.Value

    local ignored = Options.IgnorePlayers.Value or {}

    local bestPlayer, bestPart, bestPos, bestScreenDist = nil, nil, nil, math.huge

    for plr, data in pairs(playerCache) do
        if ignored[plr.Name] then continue end
        if teamCheck and data.team == LocalPlayer.Team then continue end

        local partList = profitable and (data.isR15 and R15_PROFITABLE or R6_PROFITABLE) or PRIORITY_MAP[priority] or {"Head"}

        for _, partName in ipairs(partList) do
            local part = data.char:FindFirstChild(partName)
            if part then
                local basePos = part.Position
                if prediction then
                    basePos = basePos + data.velocity * predictFactor
                end
                if dropComp then
                    local dist = (Camera.CFrame.Position - basePos).Magnitude
                    basePos = basePos + Vector3.new(0, dist * gravity * 0.1, 0)
                end

                local dist3D = (Camera.CFrame.Position - basePos).Magnitude
                if dist3D <= maxDist then
                    if partIntersectsFOV(part, mousePos, radius, basePos) then
                        if not wallCheck or isVisible(part, data.char) then
                            local screenPos = Camera:WorldToScreenPoint(basePos)
                            local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if screenDist < bestScreenDist then
                                bestScreenDist = screenDist
                                bestPlayer = plr
                                bestPart = part
                                bestPos = basePos
                            end
                            break
                        end
                    end
                end
            end
        end
    end
    return bestPlayer, bestPart, bestPos
end

-- FPS Limiter for ESP updates
local espUpdateTimer = 0
local espUpdateInterval = 1 / 30

-- Main loop
RunService.RenderStepped:Connect(function(deltaTime)
    -- Update ESP at limited framerate
    espUpdateTimer = espUpdateTimer + deltaTime
    espUpdateInterval = 1 / Options.ChamsMaxFPS.Value
    if espUpdateTimer >= espUpdateInterval then
        updateChams()
        espUpdateTimer = espUpdateTimer - espUpdateInterval
    end

    local mousePos = UserInputService:GetMouseLocation()
    local radius = Options.FOVRadius.Value

    if Toggles.ShowFOV.Value then
        fovFrame.Size = UDim2.new(0, radius * 2, 0, radius * 2)
        fovFrame.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
        fovFrame.Visible = true
    else
        fovFrame.Visible = false
    end

    local aimbotActive = Toggles.EnableAimbot.Value and Options.AimbotKey:GetState()
    local targetPlayer, targetPart, targetPos = nil, nil, nil

    if aimbotActive then
        targetPlayer, targetPart, targetPos = getTarget()
    end

    if Toggles.DebugMode.Value and aimbotActive and targetPart then
        local screenPos = Camera:WorldToScreenPoint(targetPart.Position)
        debugText.Visible = true
        debugText.Text = targetPart.Name .. " [" .. targetPlayer.Name .. "]"
        debugText.Position = Vector2.new(screenPos.X, screenPos.Y) + Vector2.new(0, -20)
    else
        debugText.Visible = false
    end

    if aimbotActive and targetPos then
        local lookAt = CFrame.lookAt(Camera.CFrame.Position, targetPos)
        if Toggles.InstantLock.Value then
            Camera.CFrame = lookAt
        else
            local alpha = math.min((Options.AimSpeed.Value / 100) * deltaTime * 10, 1)
            Camera.CFrame = Camera.CFrame:Lerp(lookAt, alpha)
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if playerChams[plr] then
        playerChams[plr]:Destroy()
        playerChams[plr] = nil
    end
end)

Library:OnUnload(function()
    SaveManager:Save(SaveManager:GetActiveProfile())
    fovGui:Destroy()
    debugText:Remove()
    chamsFolder:Destroy()
end)
