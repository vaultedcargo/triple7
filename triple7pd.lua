local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vaultedcargo/triple7/refs/heads/main/librarysrc.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/vaultedcargo/triple7/refs/heads/main/libraryfunc/themefunc.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/vaultedcargo/triple7/refs/heads/main/libraryfunc/savefunc.lua"))()

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local Window = Library:CreateWindow({
    Title = "triple7 Project Delta / 0.0.1 / 18.04.2026",
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0
})

local UISettingsTab = Window:AddTab("UI Settings")
local MenuGroup = UISettingsTab:AddLeftGroupbox("Menu")
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
    Default = "Insert",
    NoUI = true,
    Text = "Menu keybind"
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

Library:OnUnload(function()
end)
