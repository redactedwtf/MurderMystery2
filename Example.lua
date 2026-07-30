local Arcane = loadstring(game:HttpGet("https://raw.githubusercontent.com/redactedwtf/MurderMystery2/refs/heads/main/Library.lua"))()

local Window = Arcane:Window({
    Name = "larp.cc",
    User = game.Players.LocalPlayer.Name,
    Logo = "97741915311873"
})

local Combat = Window:Page({ Name = "Combat", Icon = "swords" })

local Home = Combat:SubPage({ Name = "Home", Icon = "home" })
local Aim = Combat:SubPage({ Name = "Aim", Icon = "crosshair" })

local HomeLeft = Home:Section({ Name = "Aimbot", Side = 1 })
local HomeRight = Home:Section({ Name = "Visuals", Side = 2 })

HomeLeft:Toggle({
    Name = "Enable Toggle",
    Default = true,
    Flag = "Aimbot",
    Tooltip = "aimbot switch",
    Callback = function(State)
        Arcane:Notification({
            Name = "Aimbot",
            Description = State and "Enabled" or "Disabled",
            Duration = 3,
            Icon = "zap",
            Color = Color3.fromRGB(254, 0, 67)
        })
    end
})

HomeLeft:Slider({ Name = "Slider Drag", Min = 0, Max = 100, Default = 90, Suffix = "°", Flag = "FOV" })
HomeLeft:Dropdown({ Name = "Build Parts", Items = { "Option1", "Option2", "Option3", "Option4", "Option5" }, Default = "Option3", Flag = "TargetPart", SearchBarEnabled = true })
HomeLeft:Button({ Name = "Reset Settings", Callback = function() print("reset") end })

HomeRight:Toggle({ Name = "Enable Toggle", Default = false, Flag = "ESP" })
HomeRight:Dropdown({ Name = "ESP Features", Items = { "Box", "Name", "Health", "Distance" }, Multi = true, Default = { "Box", "Name" }, Flag = "ESPFeatures" })
HomeRight:Textbox({ Name = "Target Name", Placeholder = "username", Flag = "Target" })
HomeRight:Colorpicker({ Name = "ESP Color", Default = Color3.fromRGB(254, 0, 67), Flag = "ESPColor", Callback = function(c) print(c) end })

local HomeLeft2 = Home:Section({ Name = "Triggerbot", Side = 1 })
local HomeRight2 = Home:Section({ Name = "World", Side = 2 })

HomeLeft2:Toggle({ Name = "Enable Toggle", Default = false, Flag = "Triggerbot" })
HomeLeft2:Slider({ Name = "Slider Drag", Min = 0, Max = 500, Default = 120, Suffix = "ms", Flag = "TriggerDelay" })
HomeLeft2:Button({ Name = "Apply", Callback = function() print("apply") end })

HomeRight2:Toggle({ Name = "Enable Toggle", Default = true, Flag = "Fullbright" })
HomeRight2:Dropdown({ Name = "Build Parts", Items = { "Low", "Medium", "High" }, Default = "Medium", Flag = "WorldQuality" })
HomeRight2:Colorpicker({ Name = "Sky Color", Default = Color3.fromRGB(120, 180, 255), Flag = "SkyColor" })

local AimLeft = Aim:Section({ Name = "Prediction", Side = 1 })
local AimRight = Aim:Section({ Name = "Smoothing", Side = 2 })
local AimLeft2 = Aim:Section({ Name = "Targeting", Side = 1 })
local AimRight2 = Aim:Section({ Name = "Misc", Side = 2 })

AimLeft:Toggle({ Name = "Enable Toggle", Default = true, Flag = "Prediction" })
AimLeft:Slider({ Name = "Slider Drag", Min = 0, Max = 1, Default = 0.4, Decimals = 0.01, Flag = "PredAmount" })
AimLeft:Dropdown({ Name = "Build Parts", Items = { "Velocity", "Resolver", "Hybrid" }, Default = "Hybrid", Flag = "PredMode" })

AimRight:Toggle({ Name = "Enable Toggle", Default = false, Flag = "Smoothing" })
AimRight:Slider({ Name = "Slider Drag", Min = 0, Max = 50, Default = 12, Flag = "SmoothAmount" })
AimRight:Colorpicker({ Name = "FOV Color", Default = Color3.fromRGB(0, 255, 200), Flag = "FOVColor" })
AimRight:Textbox({ Name = "Config Note", Placeholder = "note", Flag = "AimNote" })

AimLeft2:Toggle({ Name = "Enable Toggle", Default = true, Flag = "Targeting" })
AimLeft2:Dropdown({ Name = "Build Parts", Items = { "Closest", "Lowest HP", "Crosshair" }, Default = "Closest", Flag = "TargetMode" })
AimLeft2:Button({ Name = "Lock Target", Callback = function() print("lock") end })

AimRight2:Toggle({ Name = "Enable Toggle", Default = false, Flag = "AntiAim" })
AimRight2:Slider({ Name = "Slider Drag", Min = 0, Max = 360, Default = 180, Suffix = "°", Flag = "AntiAimAngle" })

local Player = Window:Page({ Name = "Player", Icon = "user" })
local PlayerMain = Player:SubPage({ Name = "Main", Icon = "user" })

local PlayerLeft = PlayerMain:Section({ Name = "Movement", Side = 1 })
local PlayerRight = PlayerMain:Section({ Name = "Character", Side = 2 })

PlayerLeft:Toggle({ Name = "Enable Toggle", Default = false, Flag = "Fly" })
PlayerLeft:Slider({ Name = "Slider Drag", Min = 16, Max = 500, Default = 50, Flag = "WalkSpeed" })
PlayerLeft:Slider({ Name = "Slider Drag", Min = 50, Max = 500, Default = 50, Flag = "JumpPower" })
PlayerLeft:Button({ Name = "Reset Character", Callback = function() print("reset char") end })

PlayerRight:Toggle({ Name = "Enable Toggle", Default = false, Flag = "Noclip" })
PlayerRight:Dropdown({ Name = "Build Parts", Items = { "R6", "R15" }, Default = "R15", Flag = "RigType" })
PlayerRight:Textbox({ Name = "Set Display", Placeholder = "name", Flag = "DisplayName" })

local Settings = Window:Page({ Name = "Settings", Icon = "settings" })
local ConfigSub = Settings:SubPage({ Name = "Configs", Icon = "save" })

local ConfigLeft = ConfigSub:Section({ Name = "Config System", Side = 1 })
local ThemeRight = ConfigSub:Section({ Name = "Theming", Side = 2 })

ConfigLeft:Config()
ThemeRight:Theming()

Arcane:Notification({ Name = "ARCANE", Description = "Loaded — Right Ctrl to toggle.", Duration = 5, Icon = "check", Color = Color3.fromRGB(52, 255, 164) })
Window:Watermark({ Title = "This is a watermark" })
