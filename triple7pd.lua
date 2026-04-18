--[[
i hate doing this
for now i got no clue on what to add, might experiment :>
has: antiafk, no recoil, no spread
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vaultedcargo/triple7/refs/heads/main/librarysrc.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/vaultedcargo/triple7/refs/heads/main/libraryfunc/themefunc.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/vaultedcargo/triple7/refs/heads/main/libraryfunc/savefunc.lua"))()

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Camera = workspace.CurrentCamera
RunService.Heartbeat:Connect(function()
    if os.clock() % 10 < 0.05 then
        if Camera then
            Camera.CFrame = Camera.CFrame * CFrame.Angles(0, 0.001, 0)
        end
    end
end)

local Window = Library:CreateWindow({
    Title = "triple7 Project Delta / 0.0.2 / 18.04.2026",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0
})

local CombatTab = Window:AddTab("Combat")
local WeaponModsGroup = CombatTab:AddLeftGroupbox("Weapon Mods")

local originalValues = {}
local ammoTypesFolder = ReplicatedStorage:FindFirstChild("AmmoTypes")

local function applyWeaponMods()
    if not ammoTypesFolder then return end

    for _, ammoType in ipairs(ammoTypesFolder:GetChildren()) do
        if not ammoType:IsA("Instance") then continue end

        local name = ammoType:GetFullName()
        if not originalValues[name] then
            originalValues[name] = {
                RecoilStrength = ammoType:GetAttribute("RecoilStrength"),
                ProjectileDrop = ammoType:GetAttribute("ProjectileDrop"),
                AccuracyDeviation = ammoType:GetAttribute("AccuracyDeviation"),
            }
        end

        if Toggles.NoRecoil and Toggles.NoRecoil.Value then
            ammoType:SetAttribute("RecoilStrength", 0)
        else
            local orig = originalValues[name].RecoilStrength
            if orig ~= nil then
                ammoType:SetAttribute("RecoilStrength", orig)
            end
        end

        if Toggles.NoSpread and Toggles.NoSpread.Value then
            ammoType:SetAttribute("ProjectileDrop", 0)
            ammoType:SetAttribute("AccuracyDeviation", 0)
        else
            local origDrop = originalValues[name].ProjectileDrop
            local origAcc = originalValues[name].AccuracyDeviation
            if origDrop ~= nil then
                ammoType:SetAttribute("ProjectileDrop", origDrop)
            end
            if origAcc ~= nil then
                ammoType:SetAttribute("AccuracyDeviation", origAcc)
            end
        end
    end
end

WeaponModsGroup:AddToggle("NoRecoil", {
    Text = "No Recoil",
    Default = false,
    Tooltip = "Sets RecoilStrength to 0",
    Callback = function(value)
        applyWeaponMods()
    end
})

WeaponModsGroup:AddToggle("NoSpread", {
    Text = "No Spread",
    Default = false,
    Tooltip = "Sets AccuracyDeviation and ProjectileDrop to 0",
    Callback = function(value)
        applyWeaponMods()
    end
})

if ammoTypesFolder then
    ammoTypesFolder.ChildAdded:Connect(function(child)
        task.wait()
        applyWeaponMods()
    end)
end

local UISettingsTab = Window:AddTab("Settings")
local MenuGroup = UISettingsTab:AddLeftGroupbox("Menu")
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "Insert",
    NoUI = true,
    Text = "UI keybind"
})
Library.ToggleKeybind = Options.MenuKeybind

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("triple7pd")
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
SaveManager:BuildConfigSection(UISettingsTab)

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("triple7pd")
ThemeManager:ApplyToTab(UISettingsTab)

Library:SetWatermark("triple7 PD | FPS: 60 | Ping: 0")
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
    Library:SetWatermark(string.format("triple7 PD | FPS: %d | Ping: %d", FPS, Ping))
    if Library.Watermark then
        Library.Watermark.AnchorPoint = Vector2.new(0.5, 0)
        Library.Watermark.Position = UDim2.new(0.5, 0, 0, 10)
    end
end)

Library:Notify("triple7 loaded", 3)
