if getgenv().Arcane and getgenv().Arcane.Unload then
    getgenv().Arcane:Unload()
end

local Library = { } do
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local GuiService = game:GetService("GuiService")
    local CoreGui = (cloneref and cloneref(game:GetService("CoreGui"))) or game:GetService("CoreGui")

    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local GuiInset = GuiService:GetGuiInset().Y
    local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

    gethui = gethui or function() return CoreGui end

    local Lucide
    pcall(function()
        Lucide = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/icons.lua"))()
    end)

    local function ResolveIcon(Icon)
        if type(Icon) == "number" then
            return "rbxassetid://" .. Icon
        end

        if type(Icon) == "string" then
            if string.match(Icon, "^rbxassetid://") then
                return Icon
            end

            if string.match(Icon, "^%d+$") then
                return "rbxassetid://" .. Icon
            end

            local Name = string.lower(Icon)

            if type(Lucide) == "function" then
                local Success, Data = pcall(Lucide, Name)
                if Success and type(Data) == "table" then
                    local Id = Data.id or Data.Id or Data[1]
                    local Size = Data.imageRectSize or Data.ImageRectSize or Data[2]
                    local Offset = Data.imageRectOffset or Data.imageRectPosition or Data.ImageRectOffset or Data[3]
                    if Id then return "rbxassetid://" .. tostring(Id), Offset, Size end
                end
            elseif type(Lucide) == "table" then
                for _, Set in { Lucide["48px"], Lucide["256px"], Lucide } do
                    if type(Set) == "table" then
                        local Data = Set[Name]
                        if type(Data) == "table" and Data[1] then
                            return "rbxassetid://" .. tostring(Data[1]), Data[3], Data[2]
                        end
                    end
                end
            end
        end

        return "rbxassetid://0"
    end

    local function ToVector2(Value)
        if typeof(Value) == "Vector2" then return Value end
        if type(Value) == "table" then return Vector2.new(Value[1] or Value.X or 0, Value[2] or Value.Y or 0) end
        return Vector2.new(0, 0)
    end

    local function ApplyIcon(Object, Icon)
        if not Icon then return end
        local Image, Offset, Size = ResolveIcon(Icon)
        Object.Image = Image
        Object.ImageRectOffset = ToVector2(Offset)
        Object.ImageRectSize = ToVector2(Size)
    end

    local Themes = {
        ["Dark"] = {
            Background = Color3.fromRGB(16, 16, 18), Topbar = Color3.fromRGB(22, 22, 26), Section = Color3.fromRGB(21, 20, 25),
            Element = Color3.fromRGB(27, 26, 33), Accent = Color3.fromRGB(254, 0, 67), Text = Color3.fromRGB(255, 255, 255),
            DimText = Color3.fromRGB(120, 120, 130), Border = Color3.fromRGB(30, 29, 34), Selected = Color3.fromRGB(29, 28, 37), ToggleOff = Color3.fromRGB(35, 25, 38)
        },
        ["Light"] = {
            Background = Color3.fromRGB(228, 228, 233), Topbar = Color3.fromRGB(235, 235, 240), Section = Color3.fromRGB(245, 245, 249),
            Element = Color3.fromRGB(230, 230, 236), Accent = Color3.fromRGB(254, 0, 67), Text = Color3.fromRGB(24, 24, 30),
            DimText = Color3.fromRGB(140, 140, 150), Border = Color3.fromRGB(205, 205, 214), Selected = Color3.fromRGB(216, 216, 224), ToggleOff = Color3.fromRGB(210, 202, 206)
        },
        ["Ocean"] = {
            Background = Color3.fromRGB(14, 17, 22), Topbar = Color3.fromRGB(20, 24, 31), Section = Color3.fromRGB(18, 22, 28),
            Element = Color3.fromRGB(24, 29, 37), Accent = Color3.fromRGB(0, 170, 255), Text = Color3.fromRGB(235, 240, 245),
            DimText = Color3.fromRGB(90, 100, 115), Border = Color3.fromRGB(28, 33, 42), Selected = Color3.fromRGB(28, 35, 48), ToggleOff = Color3.fromRGB(26, 34, 46)
        },
        ["Crimson"] = {
            Background = Color3.fromRGB(18, 14, 15), Topbar = Color3.fromRGB(26, 20, 21), Section = Color3.fromRGB(23, 18, 19),
            Element = Color3.fromRGB(32, 24, 26), Accent = Color3.fromRGB(230, 40, 70), Text = Color3.fromRGB(245, 235, 237),
            DimText = Color3.fromRGB(120, 95, 100), Border = Color3.fromRGB(38, 28, 31), Selected = Color3.fromRGB(42, 28, 31), ToggleOff = Color3.fromRGB(40, 26, 30)
        },
        ["Emerald"] = {
            Background = Color3.fromRGB(14, 19, 16), Topbar = Color3.fromRGB(20, 27, 23), Section = Color3.fromRGB(18, 24, 20),
            Element = Color3.fromRGB(24, 33, 28), Accent = Color3.fromRGB(0, 200, 130), Text = Color3.fromRGB(235, 245, 240),
            DimText = Color3.fromRGB(95, 115, 105), Border = Color3.fromRGB(28, 38, 32), Selected = Color3.fromRGB(28, 44, 36), ToggleOff = Color3.fromRGB(26, 40, 32)
        },
        ["Amethyst"] = {
            Background = Color3.fromRGB(17, 14, 22), Topbar = Color3.fromRGB(24, 20, 31), Section = Color3.fromRGB(21, 18, 28),
            Element = Color3.fromRGB(30, 25, 39), Accent = Color3.fromRGB(170, 90, 255), Text = Color3.fromRGB(240, 236, 248),
            DimText = Color3.fromRGB(110, 100, 125), Border = Color3.fromRGB(35, 28, 46), Selected = Color3.fromRGB(40, 32, 54), ToggleOff = Color3.fromRGB(36, 28, 48)
        }
    }

    local function DeriveTheme()
        local T = Library.Theme
        T.Inline = T.Topbar
        T.AccentDark = T.Accent
        T.Divider = T.Border
        T.DimIcon = T.DimText:Lerp(T.Background, 0.45)
        T.SliderBack = T.Element
        T.DropdownBack = T.Element
        T.DropdownSelected = T.Element:Lerp(T.Text, 0.045)
        T.ToggleOn = T.Accent:Lerp(T.Section, 0.72)
        T.ToggleOffCircle = T.ToggleOff:Lerp(T.DimText, 0.5)
    end

    Library.__index = Library
    Library.Theme = table.clone(Themes.Dark)
    DeriveTheme()
    Library.CurrentTheme = "Dark"
    Library.PreviousTheme = "Dark"
    Library.Flags = { }
    Library.Threads = { }
    Library.Connections = { }
    Library.ThemingStuff = { }
    Library.ThemeMap = { }
    Library.OpenFrames = { }
    Library.Windows = { }
    Library.MenuKeybind = tostring(Enum.KeyCode.RightControl)
    Library.SetFlags = { }
    Library.Directory = "Arcane"
    Library.ConfigFolder = "Arcane/Configs"
    Library.ThemeKeys = { "Background", "Topbar", "Section", "Element", "Accent", "Text", "DimText", "Border" }
    Library.ThemeList = { "Dark", "Light", "Ocean", "Crimson", "Emerald", "Amethyst" }

    Library.Animation = {
        Time = 0.25,
        Style = Enum.EasingStyle.Quart,
        Direction = Enum.EasingDirection.Out
    }

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Properties = Properties,
            Instance = Instance.new(Class)
        }

        for Property, Value in Properties do
            if Property == "FontFace" then
                Data.Instance.FontFace = Library.Font
                continue
            end

            if Property == "Name" then
                Data.Instance.Name = "\0"
                continue
            end

            Data.Instance[Property] = Value
        end

        return setmetatable(Data, Library)
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)
        coroutine.resume(NewThread)
        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if type(Signal) == "string" and Self.Instance then
            if IsMobile and (Signal == "MouseButton1Down" or Signal == "MouseButton1Click") then
                Connection = Self.Instance.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Callback(Input)
                    end
                end)
            else
                Connection = Self.Instance[Signal]:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.SafeCall = function(Self, Function, ...)
        if type(Function) ~= "function" then return end
        local Success, Result = pcall(Function, ...)
        if not Success then warn(Result) end
        return Success, Result
    end

    Library.Round = function(Self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return math.floor(Number * Multiplier) / Multiplier
    end

    Library.GetScreenScale = function(Self)
        return (Library.UIScale and Library.UIScale.Instance and Library.UIScale.Instance.Scale) or 1
    end

    if isfolder and not isfolder(Library.Directory) then makefolder(Library.Directory) end
    if isfolder and not isfolder(Library.ConfigFolder) then makefolder(Library.ConfigFolder) end

    Library.GetConfig = function(Self)
        local Config = { }
        for Index, Value in Library.Flags do
            if typeof(Value) == "Color3" then
                Config[Index] = { __color = Value:ToHex() }
            else
                Config[Index] = Value
            end
        end

        local ThemeColors = { }
        for Key, Color in Library.Theme do
            if typeof(Color) == "Color3" then
                ThemeColors[Key] = Color:ToHex()
            end
        end
        Config.__theme = ThemeColors

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        for Index, Value in Decoded do
            local SetFunction = Library.SetFlags[Index]
            if SetFunction then
                if type(Value) == "table" and Value.__color then
                    SetFunction(Color3.fromHex(Value.__color), Value.__alpha)
                else
                    SetFunction(Value)
                end
            end
        end

        if type(Decoded.__theme) == "table" then
            for Key, Hex in Decoded.__theme do
                local Ok, Color = pcall(Color3.fromHex, Hex)
                if Ok then Library.Theme[Key] = Color end
            end
            Library:ApplyTheme()
        elseif type(Decoded.__theme) == "string" then
            Library:SetTheme(Decoded.__theme)
        end
    end

    Library.GetConfigsList = function(Self, Element)
        local List = { }
        for _, File in listfiles(Library.ConfigFolder) do
            if File:sub(-5) == ".json" then
                local Name = File:match("([^/\\]+)%.json$")
                if Name then table.insert(List, Name) end
            end
        end
        if Element then Element:Refresh(List) end
        return List
    end

    Library.Tween = function(Self, Properties, Info, RawItem)
        local Object = RawItem or Self.Instance
        Info = Info or TweenInfo.new(Library.Animation.Time, Library.Animation.Style, Library.Animation.Direction)
        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()
        return NewTween
    end

    Library.GetTweenProperty = function(Self, RawItem)
        local Object = RawItem or Self.Instance

        if Object:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Object:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("UIStroke") then
            return { "Transparency" }
        end
    end

    Library.Fade = function(Self, Property, Visibility, RawItem)
        local Object = RawItem or Self.Instance
        local OldTransparency = Object[Property]
        Object[Property] = Visibility and 1 or OldTransparency

        local NewTween = Library:Tween({
            [Property] = Visibility and OldTransparency or 1
        }, nil, Object)

        Library:Connect(NewTween.Completed, function()
            if not Visibility then
                task.wait()
                Object[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        if Visibility then
            Self.Instance.Visible = true
        end

        local NewTween
        local Children = Self.Instance:GetDescendants()
        table.insert(Children, Self.Instance)

        for _, Child in Children do
            local Properties = Library:GetTweenProperty(Child)

            if not Properties then
                continue
            end

            for _, Property in Properties do
                NewTween = Library:Fade(Property, Visibility, Child)
            end
        end

        if NewTween then
            Library:Connect(NewTween.Completed, function()
                if Callback then Callback() end
                Self.Instance.Visible = Visibility
            end)
        elseif Callback then
            Callback()
        end
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties
        }

        for Property, Value in Properties do
            if type(Value) == "string" then
                Object[Property] = Library.Theme[Value]
            else
                Object[Property] = Value()
            end
        end

        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData
        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance
        if not Library.ThemeMap[Object] then return end
        Library.ThemeMap[Object].Properties = Properties
    end

    Library.SetTheme = function(Self, Name)
        local NewTheme = Themes[Name]
        if not NewTheme then return end

        Library.CurrentTheme = Name
        if Name ~= "Light" then
            Library.PreviousTheme = Name
        end

        for Key, Color in NewTheme do
            Library.Theme[Key] = Color
        end

        DeriveTheme()

        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" then
                    Library:Tween({ [Property] = Library.Theme[Value] }, nil, Item.Item)
                elseif type(Value) == "function" then
                    Library:Tween({ [Property] = Value() }, nil, Item.Item)
                end
            end
        end
    end

    Library.ApplyTheme = function(Self)
        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" then
                    Library:Tween({ [Property] = Library.Theme[Value] }, nil, Item.Item)
                elseif type(Value) == "function" then
                    Library:Tween({ [Property] = Value() }, nil, Item.Item)
                end
            end
        end
    end

    Library.OnHover = function(Self, OnEnter, OnLeave)
        local Object = Self.Instance
        Library:Connect(Object.MouseEnter, OnEnter)
        Library:Connect(Object.MouseLeave, OnLeave)
    end

    Library.MakeDraggable = function(Self, Handle)
        local Gui = Self.Instance
        Handle = Handle or Gui

        local Dragging = false
        local DragStart
        local StartPosition

        local function Set(Input)
            local Scale = Library:GetScreenScale()
            local DragDelta = (Input.Position - DragStart) / Scale
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y
            local ScreenSize = Gui.Parent.AbsoluteSize / Scale
            local GuiSize = Gui.AbsoluteSize / Scale
            NewX = math.clamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = math.clamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
            Self:Tween({ Position = UDim2.new(0, NewX, 0, NewY) }, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end

        local InputChanged

        Library:Connect(Handle.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position

                if InputChanged then return end

                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then
                    Set(Input)
                end
            end
        end)
    end

    Library.IsMouseOverFrame = function(Self)
        local Object = Self.Instance
        local Position = Vector2.new(Mouse.X, Mouse.Y)

        return Position.X >= Object.AbsolutePosition.X and Position.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
        and Position.Y >= Object.AbsolutePosition.Y and Position.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
    end

    Library.Unload = function(Self)
        for _, Connection in Library.Connections do
            Connection:Disconnect()
        end

        for _, Thread in Library.Threads do
            pcall(coroutine.close, Thread)
        end

        if Library.Holder then Library.Holder.Instance:Destroy() end
        if Library.UnusedHolder then Library.UnusedHolder.Instance:Destroy() end

        getgenv().Arcane = nil
    end

    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Name .. ".ttf") then
                writefile(Name .. ".ttf", game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = { {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Name .. ".ttf")
                } }
            }

            if not isfile(Name .. ".font") then
                writefile(Name .. ".font", HttpService:JSONEncode(FontData))
            end

            return Font.new(getcustomasset(Name .. ".font"))
        end

        local Success, Result = pcall(function()
            return CustomFont:New("ArcaneInter", 600, "Normal", {
                Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterSemibold.ttf"
            })
        end)

        Library.Font = Success and Result or Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold)
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
        IgnoreGuiInset = true
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        Enabled = false,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Library:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 0, 0, GuiInset),
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X
    })

    Library:Create("UIPadding", {
        Parent = Library.NotifHolder.Instance,
        PaddingTop = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15)
    })

    Library:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })

    Library.UIScale = Library:Create("UIScale", {
        Parent = Library.Holder.Instance,
        Scale = 1
    })

    local function UpdateScale()
        local Scale = 1

        if IsMobile and workspace.CurrentCamera then
            local Viewport = workspace.CurrentCamera.ViewportSize
            Scale = math.clamp(math.min((Viewport.X * 0.94) / 526, (Viewport.Y * 0.94) / 515), 0.4, 1)
        end

        Library.UIScale.Instance.Scale = Scale

        for _, Window in Library.Windows do
            if Window.Center then Window:Center() end
        end
    end

    UpdateScale()
    Library:Connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
        task.wait()
        UpdateScale()
    end)

    Library.Notification = function(Self, Params)
        Params = Params or { }

        local Name = Params.Name or Params.name or "Notification"
        local Description = Params.Description or Params.description or ""
        local Duration = Params.Duration or Params.duration or 5
        local Icon = Params.Icon or Params.icon
        local Accent = Params.Color or Params.color or Library.Theme.Accent

        local Height = 73
        local Items = { }

        Items.Notification = Library:Create("Frame", {
            Parent = Library.NotifHolder.Instance,
            Name = "\0",
            Size = UDim2.new(0, 0, 0, Height),
            ClipsDescendants = true,
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.Section
        }):AddToTheme({ BackgroundColor3 = "Section" })

        Library:Create("UICorner", {
            Parent = Items.Notification.Instance,
            CornerRadius = UDim.new(0, 10)
        })

        Library:Create("UIStroke", {
            Parent = Items.Notification.Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Library.Theme.Border,
            Transparency = 0.4
        }):AddToTheme({ Color = "Border" })

        local TitleX = 12

        if Icon then
            Items.Icon = Library:Create("ImageLabel", {
                Parent = Items.Notification.Instance,
                Name = "\0",
                ImageColor3 = Accent,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 13),
                Size = UDim2.new(0, 18, 0, 18),
                BorderSizePixel = 0
            })
            ApplyIcon(Items.Icon.Instance, Icon)
            TitleX = 38
        end

        Items.Title = Library:Create("TextLabel", {
            Parent = Items.Notification.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Text,
            Text = Name,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, TitleX, 0, 12),
            Size = UDim2.new(0, 260 - TitleX - 12, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "Text" })

        Items.Description = Library:Create("TextLabel", {
            Parent = Items.Notification.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.DimText,
            TextTransparency = 0.35,
            Text = Description,
            TextSize = 13,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 36),
            Size = UDim2.new(0, 150, 0, 15),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "DimText" })

        Items.Duration = Library:Create("TextLabel", {
            Parent = Items.Notification.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.DimText,
            Text = Duration .. "s",
            TextSize = 13,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -12, 0, 36),
            Size = UDim2.new(0, 60, 0, 15),
            TextXAlignment = Enum.TextXAlignment.Right,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "DimText" })

        Items.Liner = Library:Create("Frame", {
            Parent = Items.Notification.Instance,
            Name = "\0",
            Position = UDim2.new(0, 12, 0, 59),
            Size = UDim2.new(1, -24, 0, 4),
            BorderSizePixel = 0,
            BackgroundColor3 = Accent
        })

        Library:Create("UICorner", {
            Parent = Items.Liner.Instance,
            CornerRadius = UDim.new(1, 0)
        })

        local Fades = { }

        for _, Value in Items do
            local Object = Value.Instance
            if Object:IsA("ImageLabel") then
                table.insert(Fades, { Object = Value, Property = "ImageTransparency", Original = Object.ImageTransparency })
            elseif Object:IsA("TextLabel") then
                table.insert(Fades, { Object = Value, Property = "TextTransparency", Original = Object.TextTransparency })
            elseif Object:IsA("Frame") then
                table.insert(Fades, { Object = Value, Property = "BackgroundTransparency", Original = Object.BackgroundTransparency })
            end
        end

        for _, Fade in Fades do
            Fade.Object.Instance[Fade.Property] = 1
        end

        local Info = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
        local Alive = true

        Library:Thread(function()
            Items.Notification:Tween({ Size = UDim2.new(0, 260, 0, Height) }, Info)

            for _, Fade in Fades do
                Fade.Object:Tween({ [Fade.Property] = Fade.Original }, Info)
            end

            Items.Liner:Tween({ Size = UDim2.new(0, 0, 0, 4) }, TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out))

            task.spawn(function()
                local Remaining = Duration
                while Alive and Remaining > 0 do
                    task.wait(0.1)
                    Remaining = math.max(Remaining - 0.1, 0)
                    if Items.Duration.Instance.Parent then
                        Items.Duration.Instance.Text = Library:Round(Remaining, 0.1) .. "s"
                    end
                end
            end)

            task.delay(Duration + 0.1, function()
                Alive = false

                for _, Fade in Fades do
                    Fade.Object:Tween({ [Fade.Property] = 1 }, Info)
                end

                Items.Notification:Tween({ Size = UDim2.new(0, 0, 0, 0) }, Info)
                task.wait(0.5)
                Items.Notification.Instance:Destroy()
            end)
        end)
    end

    Library.Tooltip = function(Self, Text)
        local Object = Self.Instance
        if IsMobile then return end
        if not Object or Text == nil or Text == "" then return end

        local Items = { }

        Items.Tooltip = Library:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "\0",
            ClipsDescendants = true,
            Size = UDim2.new(0, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, 0),
            ZIndex = 999,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = Library.Theme.Section
        }):AddToTheme({ BackgroundColor3 = "Section" })

        Library:Create("UICorner", {
            Parent = Items.Tooltip.Instance,
            CornerRadius = UDim.new(0, 8)
        })

        Library:Create("UIPadding", {
            Parent = Items.Tooltip.Instance,
            PaddingRight = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 12)
        })

        Items.Text = Library:Create("TextLabel", {
            Parent = Items.Tooltip.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Text,
            Text = Text,
            TextSize = 13,
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.new(0, 0, 0, 15),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 4, 0.5, 0),
            ZIndex = 999,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X
        }):AddToTheme({ TextColor3 = "Text" })

        Items.Liner = Library:Create("Frame", {
            Parent = Items.Tooltip.Instance,
            Name = "\0",
            Position = UDim2.new(0, -12, 0, 0),
            Size = UDim2.new(0, 4, 1, 0),
            ZIndex = 999,
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.Accent
        }):AddToTheme({ BackgroundColor3 = "Accent" })

        local function Toggle(Bool)
            for _, Value in Items do
                if Value.Instance:IsA("Frame") then
                    Value:Tween({ BackgroundTransparency = Bool and 0 or 1 })
                elseif Value.Instance:IsA("TextLabel") then
                    Value:Tween({ TextTransparency = Bool and 0 or 1 })
                end
            end
        end

        Toggle(false)

        local RenderStepped

        Self:OnHover(function()
            local Location = UserInputService:GetMouseLocation()
            Items.Tooltip.Instance.Position = UDim2.new(0, Location.X + 18, 0, Location.Y + 12)
            Toggle(true)

            RenderStepped = RunService.RenderStepped:Connect(function()
                Location = UserInputService:GetMouseLocation()
                Items.Tooltip.Instance.Position = UDim2.new(0, Location.X + 18, 0, Location.Y + 12)
            end)
        end, function()
            Toggle(false)
            if RenderStepped then
                RenderStepped:Disconnect()
                RenderStepped = nil
            end
        end)
    end

    Library.Window = function(Self, Params)
        Params = Params or { }

        local Window = {
            Name = Params.Name or Params.name or "ARCANE",
            User = Params.User or Params.user or LocalPlayer.Name,
            Logo = Params.Logo or Params.logo or "72939878637463",
            IsOpen = true,
            Pages = { },
            Items = { }
        }

        local Items = { }

        local Scale = Library:GetScreenScale()
        local Viewport = workspace.CurrentCamera.ViewportSize

        Items.MainFrame = Library:Create("Frame", {
            Parent = Library.Holder.Instance,
            Name = "\0",
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromOffset(Viewport.X / (2 * Scale) - 263, Viewport.Y / (2 * Scale) - 258),
            Size = UDim2.new(0, 526, 0, 515),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.Background
        }):AddToTheme({ BackgroundColor3 = "Background" })

        Library:Create("UICorner", {
            Parent = Items.MainFrame.Instance,
            CornerRadius = UDim.new(0, 10)
        })

        Items.TopBar = Library:Create("Frame", {
            Parent = Items.MainFrame.Instance,
            Name = "\0",
            Size = UDim2.new(1, 0, 0, 37),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.Topbar
        }):AddToTheme({ BackgroundColor3 = "Topbar" })

        Library:Create("UICorner", {
            Parent = Items.TopBar.Instance,
            CornerRadius = UDim.new(0, 10)
        })

        Items.MainFrame:MakeDraggable(Items.TopBar.Instance)

        Items.Logo = Library:Create("ImageLabel", {
            Parent = Items.TopBar.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 10),
            Size = UDim2.new(0, 27, 0, 20),
            BorderSizePixel = 0
        })
        ApplyIcon(Items.Logo.Instance, Window.Logo)

        Items.HubName = Library:Create("TextLabel", {
            Parent = Items.TopBar.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Accent,
            Text = Window.Name,
            TextSize = 16,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 46, 0, 0),
            Size = UDim2.new(0, 200, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "Accent" })

        Items.User = Library:Create("TextLabel", {
            Parent = Items.TopBar.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.DimText,
            Text = Window.User,
            TextSize = 14,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -12, 0, 0),
            Size = UDim2.new(0, 157, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Right,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "DimText" })

        Items.Line = Library:Create("Frame", {
            Parent = Items.MainFrame.Instance,
            Name = "\0",
            Position = UDim2.new(0, 0, 0, 36),
            Size = UDim2.new(1, 0, 0, 2),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.Divider
        }):AddToTheme({ BackgroundColor3 = "Divider" })

        Items.ThemeHolder = Library:Create("Frame", {
            Parent = Items.MainFrame.Instance,
            Name = "\0",
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -15, 0, 53),
            Size = UDim2.new(0, 96, 0, 40),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.Topbar
        }):AddToTheme({ BackgroundColor3 = "Topbar" })

        Library:Create("UICorner", {
            Parent = Items.ThemeHolder.Instance,
            CornerRadius = UDim.new(0, 10)
        })

        Library:Create("UIListLayout", {
            Parent = Items.ThemeHolder.Instance,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local ThemeButtons = { }

        local function MakeThemeButton(Icon, ThemeName)
            local Button = Library:Create("TextButton", {
                Parent = Items.ThemeHolder.Instance,
                Name = "\0",
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 40, 0, 32),
                ZIndex = 3,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Selected
            }):AddToTheme({ BackgroundColor3 = "Selected" })

            Library:Create("UICorner", {
                Parent = Button.Instance,
                CornerRadius = UDim.new(0, 8)
            })

            local ButtonIcon = Library:Create("ImageLabel", {
                Parent = Button.Instance,
                Name = "\0",
                ImageColor3 = Library.Theme.DimIcon,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0, 14, 0, 14),
                ZIndex = 3,
                BorderSizePixel = 0
            }):AddToTheme({ ImageColor3 = "DimIcon" })
            ApplyIcon(ButtonIcon.Instance, Icon)

            local Data = { Button = Button, Icon = ButtonIcon, Theme = ThemeName }

            function Data:Set(Active)
                if Active then
                    Button:ChangeItemTheme({ BackgroundColor3 = "Selected" })
                    ButtonIcon:ChangeItemTheme({ ImageColor3 = "Accent" })
                    Button:Tween({ BackgroundTransparency = 0, BackgroundColor3 = Library.Theme.Selected })
                    ButtonIcon:Tween({ ImageColor3 = Library.Theme.Accent })
                else
                    ButtonIcon:ChangeItemTheme({ ImageColor3 = "DimIcon" })
                    Button:Tween({ BackgroundTransparency = 1 })
                    ButtonIcon:Tween({ ImageColor3 = Library.Theme.DimIcon })
                end
            end

            Button:Connect("MouseButton1Down", function()
                if ThemeName == "Light" then
                    Library:SetTheme("Light")
                else
                    Library:SetTheme(Library.PreviousTheme or "Dark")
                end

                local IsLight = Library.CurrentTheme == "Light"
                for _, Value in ThemeButtons do
                    Value:Set((Value.Theme == "Light") == IsLight)
                end
            end)

            table.insert(ThemeButtons, Data)
            return Data
        end

        MakeThemeButton("moon", "Dark"):Set(true)
        MakeThemeButton("sun", "Light"):Set(false)

        Items.PagesHolder = Library:Create("Frame", {
            Parent = Items.MainFrame.Instance,
            Name = "\0",
            Position = UDim2.new(0, 15, 1, -56),
            Size = UDim2.new(0, 0, 0, 40),
            ZIndex = 3,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = Library.Theme.Topbar
        }):AddToTheme({ BackgroundColor3 = "Topbar" })

        Library:Create("UICorner", {
            Parent = Items.PagesHolder.Instance,
            CornerRadius = UDim.new(0, 10)
        })

        Library:Create("UIPadding", {
            Parent = Items.PagesHolder.Instance,
            PaddingRight = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4)
        })

        Library:Create("UIListLayout", {
            Parent = Items.PagesHolder.Instance,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Window.Items = Items

        Library:Connect(UserInputService.InputBegan, function(Input, Processed)
            if Processed then return end
            if tostring(Input.KeyCode) == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        function Window:SetOpen(Bool)
            Window.IsOpen = Bool
            if not Bool then
                for _, Value in Library.OpenFrames do
                    if Value.SetOpen then Value:SetOpen(false) end
                end
            end
            Items.MainFrame:FadeDescendants(Bool)
            if Items.MobileText then
                Items.MobileText.Instance.Text = Bool and "Close" or "Open"
            end
        end

        function Window:Center()
            local CScale = Library:GetScreenScale()
            local Vp = workspace.CurrentCamera.ViewportSize
            Items.MainFrame.Instance.Position = UDim2.fromOffset(Vp.X / (2 * CScale) - 263, Vp.Y / (2 * CScale) - 258)
        end

        function Window:Watermark(Params)
            Params = Params or { }
            local Title = Params.Title or Params.title or Window.Name
            local Icon = Params.Icon or Params.icon or Window.Logo

            local WItems = { }

            WItems.Holder = Library:Create("Frame", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                Active = true,
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -16, 0, 16),
                Size = UDim2.new(0, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundTransparency = 1,
                BorderSizePixel = 0
            })

            Library:Create("UIListLayout", {
                Parent = WItems.Holder.Instance,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5)
            })

            local function MakePill(Order)
                local Pill = Library:Create("Frame", {
                    Parent = WItems.Holder.Instance,
                    Name = "\0",
                    Size = UDim2.new(0, 0, 0, 34),
                    AutomaticSize = Enum.AutomaticSize.X,
                    LayoutOrder = Order,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme.Section
                }):AddToTheme({ BackgroundColor3 = "Section" })

                Library:Create("UICorner", { Parent = Pill.Instance, CornerRadius = UDim.new(0, 10) })

                Library:Create("UIStroke", {
                    Parent = Pill.Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Library.Theme.Border,
                    Transparency = 0.4
                }):AddToTheme({ Color = "Border" })

                Library:Create("UIPadding", {
                    Parent = Pill.Instance,
                    PaddingLeft = UDim.new(0, 14),
                    PaddingRight = UDim.new(0, 14)
                })

                Library:Create("UIListLayout", {
                    Parent = Pill.Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 8)
                })

                return Pill
            end

            WItems.TitlePill = MakePill(1)

            WItems.Icon = Library:Create("ImageLabel", {
                Parent = WItems.TitlePill.Instance,
                Name = "\0",
                ImageColor3 = Library.Theme.Accent,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 27, 0, 20),
                LayoutOrder = 1,
                BorderSizePixel = 0
            }):AddToTheme({ ImageColor3 = "Accent" })
            ApplyIcon(WItems.Icon.Instance, Icon)

            WItems.Title = Library:Create("TextLabel", {
                Parent = WItems.TitlePill.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                Text = Title,
                TextSize = 15,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = 2,
                BorderSizePixel = 0
            }):AddToTheme({ TextColor3 = "Text" })

            WItems.FpsPill = MakePill(2)
            WItems.Fps = Library:Create("TextLabel", {
                Parent = WItems.FpsPill.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                Text = "0 FPS",
                TextSize = 15,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextXAlignment = Enum.TextXAlignment.Center,
                BorderSizePixel = 0
            }):AddToTheme({ TextColor3 = "Text" })

            WItems.PingPill = MakePill(3)
            WItems.Ping = Library:Create("TextLabel", {
                Parent = WItems.PingPill.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                Text = "0 ping",
                TextSize = 15,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                TextXAlignment = Enum.TextXAlignment.Center,
                BorderSizePixel = 0
            }):AddToTheme({ TextColor3 = "Text" })

            WItems.Holder:MakeDraggable()

            local Stats = game:GetService("Stats")
            local Frames, Clock = 0, 0

            Library:Connect(RunService.RenderStepped, function(Delta)
                Frames += 1
                Clock += Delta
                if Clock >= 0.5 then
                    WItems.Fps.Instance.Text = math.floor(Frames / Clock) .. " FPS"
                    Frames = 0
                    Clock = 0

                    local Ok, Ping = pcall(function()
                        return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                    end)
                    WItems.Ping.Instance.Text = (Ok and Ping or 0) .. " ping"
                end
            end)

            local function PushNotifs()
                local Bottom = WItems.Holder.Instance.Position.Y.Offset + (WItems.Holder.Instance.AbsoluteSize.Y / Library:GetScreenScale())
                Library.NotifHolder.Instance.Position = UDim2.new(1, 0, 0, Bottom)
            end
            Library:Connect(WItems.Holder.Instance:GetPropertyChangedSignal("AbsoluteSize"), PushNotifs)
            task.defer(PushNotifs)

            Window.Items.Watermark = WItems
            return WItems
        end

        table.insert(Library.Windows, Window)

        if IsMobile then
            Items.MobileToggle = Library:Create("TextButton", {
                Parent = Library.Holder.Instance,
                Name = "\0",
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.new(0.5, 0, 0, 10),
                Size = UDim2.new(0, 140, 0, 40),
                ZIndex = 60,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Topbar
            }):AddToTheme({ BackgroundColor3 = "Topbar" })

            Library:Create("UICorner", {
                Parent = Items.MobileToggle.Instance,
                CornerRadius = UDim.new(0, 10)
            })

            Library:Create("UIStroke", {
                Parent = Items.MobileToggle.Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Border,
                Transparency = 0.4
            }):AddToTheme({ Color = "Border" })

            local MobileLogo = Library:Create("ImageLabel", {
                Parent = Items.MobileToggle.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 12, 0.5, 0),
                Size = UDim2.new(0, 22, 0, 22),
                ZIndex = 60,
                BorderSizePixel = 0
            })
            ApplyIcon(MobileLogo.Instance, Window.Logo)

            Items.MobileText = Library:Create("TextLabel", {
                Parent = Items.MobileToggle.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                Text = "Close",
                TextSize = 15,
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 42, 0.5, 0),
                Size = UDim2.new(1, -50, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 60,
                BorderSizePixel = 0
            }):AddToTheme({ TextColor3 = "Text" })

            Items.MobileToggle:Connect("MouseButton1Down", function()
                Window:SetOpen(not Window.IsOpen)
            end)
        end

        return setmetatable(Window, Library)
    end

    local function MakeTab(Holder, Name, Icon)
        local Tab = { }

        Tab.Button = Library:Create("TextButton", {
            Parent = Holder,
            Name = "\0",
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 36, 0, 32),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.Selected
        }):AddToTheme({ BackgroundColor3 = "Selected" })

        Library:Create("UICorner", {
            Parent = Tab.Button.Instance,
            CornerRadius = UDim.new(0, 8)
        })

        Tab.Icon = Library:Create("ImageLabel", {
            Parent = Tab.Button.Instance,
            Name = "\0",
            ImageColor3 = Library.Theme.DimIcon,
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, 0),
            Size = UDim2.new(0, 16, 0, 16),
            ZIndex = 3,
            BorderSizePixel = 0
        }):AddToTheme({ ImageColor3 = "DimIcon" })
        ApplyIcon(Tab.Icon.Instance, Icon)

        Tab.Text = Library:Create("TextLabel", {
            Parent = Tab.Button.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Text,
            Text = Name,
            TextSize = 13,
            Visible = false,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 33, 0, 0),
            Size = UDim2.new(0, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.X,
            ZIndex = 3,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "Text" })

        return Tab
    end

    Library.Page = function(Self, Params)
        Params = Params or { }

        local Page = {
            Name = Params.Name or Params.name or "Page",
            Icon = Params.Icon or Params.icon or "swords",
            Window = Self,
            SubPages = { },
            Active = false,
            Debounce = false,
            Items = { }
        }

        local Items = { }
        local Tab = MakeTab(Page.Window.Items.PagesHolder.Instance, Page.Name, Page.Icon)
        Items.Tab = Tab.Button
        Items.Icon = Tab.Icon
        Items.Text = Tab.Text

        Items.Content = Library:Create("Frame", {
            Parent = Library.UnusedHolder.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            BorderSizePixel = 0
        })

        Items.SubPagesHolder = Library:Create("Frame", {
            Parent = Items.Content.Instance,
            Name = "\0",
            Position = UDim2.new(0, 15, 0, 53),
            Size = UDim2.new(0, 0, 0, 40),
            ZIndex = 2,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = Library.Theme.Topbar
        }):AddToTheme({ BackgroundColor3 = "Topbar" })

        Library:Create("UICorner", {
            Parent = Items.SubPagesHolder.Instance,
            CornerRadius = UDim.new(0, 10)
        })

        Library:Create("UIPadding", {
            Parent = Items.SubPagesHolder.Instance,
            PaddingRight = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4)
        })

        Library:Create("UIListLayout", {
            Parent = Items.SubPagesHolder.Instance,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Items.Columns = Library:Create("Frame", {
            Parent = Items.Content.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 110),
            Size = UDim2.new(1, -30, 1, -176),
            BorderSizePixel = 0
        })

        Page.Items = Items

        Items.Tab:OnHover(function()
            if Page.Active then return end
            Items.Icon:Tween({ ImageColor3 = Library.Theme.Text })
        end, function()
            if Page.Active then return end
            Items.Icon:Tween({ ImageColor3 = Library.Theme.DimIcon })
        end)

        function Page:Switch(Bool)
            if Page.Debounce then return end

            Page.Active = Bool
            Items.Content.Instance.Parent = Bool and Page.Window.Items.MainFrame.Instance or Library.UnusedHolder.Instance
            Items.Content.Instance.Visible = Bool

            Page.Debounce = true

            if Bool then
                Items.Text.Instance.Visible = true
                Items.Tab:ChangeItemTheme({ BackgroundColor3 = "Selected" })
                Items.Icon:ChangeItemTheme({ ImageColor3 = "Accent" })
                Items.Tab:Tween({ BackgroundTransparency = 0, Size = UDim2.new(0, Items.Text.Instance.TextBounds.X + 44, 0, 32) })
                Items.Icon:Tween({ ImageColor3 = Library.Theme.Accent })
                Items.Content.Instance.Position = UDim2.new(0, 0, 0, 14)
                Items.Content:Tween({ Position = UDim2.new(0, 0, 0, 0) })

                Items.SubPagesHolder:FadeDescendants(true)
                Page.Debounce = false

                for _, Sub in Page.SubPages do
                    if Sub.Active then
                        for _, Section in Sub.Sections do
                            if Section.Appear then Section:Appear() end
                        end
                    end
                end
            else
                Items.Text.Instance.Visible = false
                Items.Icon:ChangeItemTheme({ ImageColor3 = "DimIcon" })
                Items.Tab:Tween({ BackgroundTransparency = 1, Size = UDim2.new(0, 36, 0, 32) })
                Items.Icon:Tween({ ImageColor3 = Library.Theme.DimIcon })

                Items.Content:FadeDescendants(false, function()
                    Page.Debounce = false
                end)
            end
        end

        Items.Tab:Connect("MouseButton1Down", function()
            for _, Value in Library.OpenFrames do
                Value:SetOpen(false)
            end
            for _, Value in Page.Window.Pages do
                Value:Switch(Value == Page)
            end
        end)

        if #Page.Window.Pages == 0 then
            Page:Switch(true)
        end

        table.insert(Page.Window.Pages, Page)
        return setmetatable(Page, Library)
    end

    Library.SubPage = function(Self, Params)
        Params = Params or { }

        local SubPage = {
            Name = Params.Name or Params.name or "SubPage",
            Icon = Params.Icon or Params.icon or "house",
            Window = Self.Window,
            Page = Self,
            Active = false,
            Debounce = false,
            ColumnsData = { },
            Sections = { },
            Items = { }
        }

        local Items = { }
        local Tab = MakeTab(SubPage.Page.Items.SubPagesHolder.Instance, SubPage.Name, SubPage.Icon)
        Items.Tab = Tab.Button
        Items.Icon = Tab.Icon
        Items.Text = Tab.Text

        Items.Content = Library:Create("Frame", {
            Parent = Library.UnusedHolder.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            BorderSizePixel = 0
        })

        Items.Left = Library:Create("ScrollingFrame", {
            Parent = Items.Content.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            ScrollBarImageTransparency = 1,
            ScrollBarThickness = 0,
            Selectable = false,
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0.5, -8, 1, 0),
            ZIndex = 2,
            BorderSizePixel = 0
        })

        Library:Create("UIListLayout", {
            Parent = Items.Left.Instance,
            Padding = UDim.new(0, 14),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Items.Right = Library:Create("ScrollingFrame", {
            Parent = Items.Content.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            ScrollBarImageTransparency = 1,
            ScrollBarThickness = 0,
            Selectable = false,
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, 0, 0, 0),
            Size = UDim2.new(0.5, -8, 1, 0),
            ZIndex = 2,
            BorderSizePixel = 0
        })

        Library:Create("UIListLayout", {
            Parent = Items.Right.Instance,
            Padding = UDim.new(0, 14),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        SubPage.ColumnsData[1] = Items.Left
        SubPage.ColumnsData[2] = Items.Right
        SubPage.Items = Items

        Items.Tab:OnHover(function()
            if SubPage.Active then return end
            Items.Icon:Tween({ ImageColor3 = Library.Theme.Text })
        end, function()
            if SubPage.Active then return end
            Items.Icon:Tween({ ImageColor3 = Library.Theme.DimIcon })
        end)

        function SubPage:Switch(Bool)
            if SubPage.Debounce then return end

            SubPage.Active = Bool
            Items.Content.Instance.Parent = Bool and SubPage.Page.Items.Columns.Instance or Library.UnusedHolder.Instance
            Items.Content.Instance.Visible = Bool

            SubPage.Debounce = true

            if Bool then
                Items.Text.Instance.Visible = true
                Items.Tab:ChangeItemTheme({ BackgroundColor3 = "Selected" })
                Items.Icon:ChangeItemTheme({ ImageColor3 = "Accent" })
                Items.Tab:Tween({ BackgroundTransparency = 0, Size = UDim2.new(0, Items.Text.Instance.TextBounds.X + 44, 0, 32) })
                Items.Icon:Tween({ ImageColor3 = Library.Theme.Accent })
                Items.Content.Instance.Position = UDim2.new(0, 0, 0, 14)
                Items.Content:Tween({ Position = UDim2.new(0, 0, 0, 0) })

                SubPage.Debounce = false
                for _, Section in SubPage.Sections do
                    if Section.Appear then Section:Appear() end
                end
            else
                Items.Text.Instance.Visible = false
                Items.Icon:ChangeItemTheme({ ImageColor3 = "DimIcon" })
                Items.Tab:Tween({ BackgroundTransparency = 1, Size = UDim2.new(0, 36, 0, 32) })
                Items.Icon:Tween({ ImageColor3 = Library.Theme.DimIcon })

                Items.Content:FadeDescendants(false, function()
                    SubPage.Debounce = false
                end)
            end
        end

        Items.Tab:Connect("MouseButton1Down", function()
            for _, Value in Library.OpenFrames do
                Value:SetOpen(false)
            end
            for _, Value in SubPage.Page.SubPages do
                Value:Switch(Value == SubPage)
            end
        end)

        if #SubPage.Page.SubPages == 0 then
            SubPage:Switch(true)
        end

        table.insert(SubPage.Page.SubPages, SubPage)
        return setmetatable(SubPage, Library)
    end

    Library.Section = function(Self, Params)
        Params = Params or { }

        local Section = {
            Name = Params.Name or Params.name or "Section",
            Side = Params.Side or Params.side or 1,
            LastDivider = nil,
            Items = { }
        }

        local Items = { }

        Items.Section = Library:Create("Frame", {
            Parent = Self.ColumnsData[Section.Side].Instance,
            Name = "\0",
            Size = UDim2.new(1, 0, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Library.Theme.Section
        }):AddToTheme({ BackgroundColor3 = "Section" })

        Library:Create("UICorner", {
            Parent = Items.Section.Instance,
            CornerRadius = UDim.new(0, 10)
        })

        Items.Stroke = Library:Create("UIStroke", {
            Parent = Items.Section.Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Library.Theme.Border,
            Transparency = 0.5
        }):AddToTheme({ Color = "Border" })

        Items.Content = Library:Create("Frame", {
            Parent = Items.Section.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y
        })

        Library:Create("UIListLayout", {
            Parent = Items.Content.Instance,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Section.Items = Items
        Section.AppearToken = 0

        function Section:Appear()
            Section.AppearToken += 1
            local Token = Section.AppearToken

            local SectionInst = Items.Section.Instance
            local ContentInst = Items.Content.Instance

            local Shell = {
                { Obj = SectionInst, Prop = "BackgroundTransparency", Orig = SectionInst.BackgroundTransparency }
            }
            if Items.Stroke then
                table.insert(Shell, { Obj = Items.Stroke.Instance, Prop = "Transparency", Orig = Items.Stroke.Instance.Transparency })
            end

            local Elements = { }
            for _, Obj in ContentInst:GetDescendants() do
                local Props = Library:GetTweenProperty(Obj)
                if Props then
                    if type(Props) ~= "table" then Props = { Props } end
                    for _, Prop in Props do
                        table.insert(Elements, { Obj = Obj, Prop = Prop, Orig = Obj[Prop] })
                    end
                end
            end

            for _, F in Shell do F.Obj[F.Prop] = 1 end
            for _, F in Elements do F.Obj[F.Prop] = 1 end

            task.defer(function()
                RunService.Heartbeat:Wait()
                if Section.AppearToken ~= Token then return end

                local FullHeight = SectionInst.AbsoluteSize.Y / Library:GetScreenScale()

                if FullHeight < 1 then
                    for _, F in Shell do F.Obj[F.Prop] = F.Orig end
                    for _, F in Elements do F.Obj[F.Prop] = F.Orig end
                    return
                end

                SectionInst.AutomaticSize = Enum.AutomaticSize.None
                SectionInst.ClipsDescendants = true
                SectionInst.Size = UDim2.new(1, 0, 0, 28)

                for _, F in Shell do
                    Library:Tween({ [F.Prop] = F.Orig }, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), F.Obj)
                end

                task.wait(0.16)
                if Section.AppearToken ~= Token then return end

                Library:Tween({ Size = UDim2.new(1, 0, 0, FullHeight) }, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), SectionInst)
                for _, F in Elements do
                    Library:Tween({ [F.Prop] = F.Orig }, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), F.Obj)
                end

                task.wait(0.32)
                if Section.AppearToken ~= Token then return end
                SectionInst.AutomaticSize = Enum.AutomaticSize.Y
                SectionInst.ClipsDescendants = false
            end)
        end

        if Self.Sections then
            table.insert(Self.Sections, Section)
        end

        return setmetatable(Section, Library)
    end

    local function AddDivider(Section, Parent)
        if Section.LastDivider then
            Section.LastDivider.Instance.Visible = true
        end

        local Divider = Library:Create("Frame", {
            Parent = Parent,
            Name = "\0",
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, 0),
            Size = UDim2.new(1, -24, 0, 1),
            Visible = false,
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.Divider
        }):AddToTheme({ BackgroundColor3 = "Divider" })

        Section.LastDivider = Divider
        return Divider
    end

    Library.Toggle = function(Self, Params)
        Params = Params or { }

        local Toggle = {
            Name = Params.Name or Params.name or "Toggle",
            Default = Params.Default or Params.default or false,
            Callback = Params.Callback or Params.callback or function() end,
            Tooltip = Params.Tooltip or Params.tooltip,
            Flag = Params.Flag or Params.flag,
            Value = false,
            Items = { }
        }

        local Items = { }

        Items.Holder = Library:Create("Frame", {
            Parent = Self.Items.Content.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35),
            BorderSizePixel = 0
        })

        if Toggle.Tooltip then Items.Holder:Tooltip(Toggle.Tooltip) end

        Items.Button = Library:Create("TextButton", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 2,
            BorderSizePixel = 0
        })

        Items.Name = Library:Create("TextLabel", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Text,
            Text = Toggle.Name,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -60, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "Text" })

        Items.Background = Library:Create("Frame", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.new(0, 28, 0, 14),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.ToggleOff
        }):AddToTheme({ BackgroundColor3 = "ToggleOff" })

        Library:Create("UICorner", {
            Parent = Items.Background.Instance,
            CornerRadius = UDim.new(0, 6)
        })

        Items.Circle = Library:Create("Frame", {
            Parent = Items.Background.Instance,
            Name = "\0",
            Position = UDim2.new(0, 3, 0, 3),
            Size = UDim2.new(0, 8, 0, 8),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.ToggleOffCircle
        }):AddToTheme({ BackgroundColor3 = "ToggleOffCircle" })

        Library:Create("UICorner", {
            Parent = Items.Circle.Instance,
            CornerRadius = UDim.new(1, 0)
        })

        AddDivider(Self, Items.Holder.Instance)

        Toggle.Items = Items

        function Toggle:Set(Bool)
            Toggle.Value = Bool

            if Toggle.Flag then
                Library.Flags[Toggle.Flag] = Bool
            end

            if Bool then
                Items.Background:ChangeItemTheme({ BackgroundColor3 = "ToggleOn" })
                Items.Circle:ChangeItemTheme({ BackgroundColor3 = "AccentDark" })
                Items.Background:Tween({ BackgroundColor3 = Library.Theme.ToggleOn })
                Items.Circle:Tween({ BackgroundColor3 = Library.Theme.AccentDark, Position = UDim2.new(0, 17, 0, 3) })
            else
                Items.Background:ChangeItemTheme({ BackgroundColor3 = "ToggleOff" })
                Items.Circle:ChangeItemTheme({ BackgroundColor3 = "ToggleOffCircle" })
                Items.Background:Tween({ BackgroundColor3 = Library.Theme.ToggleOff })
                Items.Circle:Tween({ BackgroundColor3 = Library.Theme.ToggleOffCircle, Position = UDim2.new(0, 3, 0, 3) })
            end

            Library:SafeCall(Toggle.Callback, Bool)
        end

        function Toggle:Get()
            return Toggle.Value
        end

        Items.Button:Connect("MouseButton1Down", function()
            Toggle:Set(not Toggle.Value)
        end)

        Toggle:Set(Toggle.Default)

        if Toggle.Flag then
            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end
        end

        return setmetatable(Toggle, Library)
    end

    Library.Slider = function(Self, Params)
        Params = Params or { }

        local Slider = {
            Name = Params.Name or Params.name or "Slider",
            Min = Params.Min or Params.min or 0,
            Max = Params.Max or Params.max or 100,
            Default = Params.Default or Params.default or 0,
            Decimals = Params.Decimals or Params.decimals or 1,
            Suffix = Params.Suffix or Params.suffix or "",
            Callback = Params.Callback or Params.callback or function() end,
            Tooltip = Params.Tooltip or Params.tooltip,
            Flag = Params.Flag or Params.flag,
            Value = 0,
            Sliding = false,
            Items = { }
        }

        local Items = { }

        Items.Holder = Library:Create("Frame", {
            Parent = Self.Items.Content.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 48),
            BorderSizePixel = 0
        })

        if Slider.Tooltip then Items.Holder:Tooltip(Slider.Tooltip) end

        Items.Name = Library:Create("TextLabel", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.DimText,
            Text = Slider.Name,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 4),
            Size = UDim2.new(0.6, 0, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "DimText" })

        Items.Value = Library:Create("TextLabel", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Text,
            Text = "",
            TextSize = 14,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -12, 0, 4),
            Size = UDim2.new(0.4, 0, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Right,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "Text" })

        Items.Track = Library:Create("Frame", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            Position = UDim2.new(0, 14, 0, 32),
            Size = UDim2.new(1, -28, 0, 5),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.SliderBack
        }):AddToTheme({ BackgroundColor3 = "SliderBack" })

        Library:Create("UICorner", {
            Parent = Items.Track.Instance,
            CornerRadius = UDim.new(0, 2)
        })

        Items.Fill = Library:Create("Frame", {
            Parent = Items.Track.Instance,
            Name = "\0",
            BackgroundColor3 = Library.Theme.Accent,
            Size = UDim2.new(0, 0, 1, 0),
            BorderSizePixel = 0
        }):AddToTheme({ BackgroundColor3 = "Accent" })

        Library:Create("UICorner", {
            Parent = Items.Fill.Instance,
            CornerRadius = UDim.new(0, 2)
        })

        Library:Create("UIGradient", {
            Parent = Items.Fill.Instance,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
            })
        })

        Items.Drag = Library:Create("Frame", {
            Parent = Items.Fill.Instance,
            Name = "\0",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 7, 0.5, 0),
            Size = UDim2.new(0, 14, 0, 8),
            BorderSizePixel = 0
        })

        Library:Create("UICorner", {
            Parent = Items.Drag.Instance,
            CornerRadius = UDim.new(0, 3)
        })

        Items.Input = Library:Create("TextButton", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 26),
            Size = UDim2.new(1, -28, 0, 18),
            ZIndex = 3,
            BorderSizePixel = 0
        })

        AddDivider(Self, Items.Holder.Instance)

        Slider.Items = Items

        function Slider:Set(Value)
            Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)

            if Slider.Flag then
                Library.Flags[Slider.Flag] = Slider.Value
            end

            local Fraction = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
            Items.Fill:Tween({ Size = UDim2.new(Fraction, 0, 1, 0) }, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            Items.Value.Instance.Text = tostring(Slider.Value) .. Slider.Suffix

            Library:SafeCall(Slider.Callback, Slider.Value)
        end

        function Slider:Get()
            return Slider.Value
        end

        local function Calculate(Input)
            local Fraction = (Input.Position.X - Items.Track.Instance.AbsolutePosition.X) / Items.Track.Instance.AbsoluteSize.X
            return Slider.Min + (Slider.Max - Slider.Min) * math.clamp(Fraction, 0, 1)
        end

        local InputChanged

        Items.Input:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Slider.Sliding = true
                Items.Drag:Tween({ Size = UDim2.new(0, 18, 0, 12) }, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                Slider:Set(Calculate(Input))

                if InputChanged then return end

                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Slider.Sliding = false
                        Items.Drag:Tween({ Size = UDim2.new(0, 14, 0, 8) }, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Slider.Sliding then
                    Slider:Set(Calculate(Input))
                end
            end
        end)

        Slider:Set(Slider.Default)

        if Slider.Flag then
            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end
        end

        return setmetatable(Slider, Library)
    end

    Library.Dropdown = function(Self, Params)
        Params = Params or { }

        local Dropdown = {
            Name = Params.Name or Params.name or "Dropdown",
            Options = Params.Items or Params.items or { },
            Default = Params.Default or Params.default,
            Multi = Params.Multi or Params.multi or false,
            Callback = Params.Callback or Params.callback or function() end,
            Tooltip = Params.Tooltip or Params.tooltip,
            Flag = Params.Flag or Params.flag,
            SearchBarEnabled = Params.SearchBarEnabled or Params.searchBarEnabled or false,
            Value = nil,
            IsOpen = false,
            Debounce = false,
            OptionData = { },
            Order = { },
            Items = { }
        }

        if Dropdown.Multi then Dropdown.Value = { } end

        local Items = { }

        Items.Holder = Library:Create("Frame", {
            Parent = Self.Items.Content.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 60),
            BorderSizePixel = 0
        })

        if Dropdown.Tooltip then Items.Holder:Tooltip(Dropdown.Tooltip) end

        Items.Name = Library:Create("TextLabel", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.DimText,
            Text = Dropdown.Name,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 2),
            Size = UDim2.new(1, -24, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "DimText" })

        Items.Back = Library:Create("TextButton", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            Text = "",
            AutoButtonColor = false,
            Position = UDim2.new(0, 12, 0, 28),
            Size = UDim2.new(1, -24, 0, 25),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.DropdownBack
        }):AddToTheme({ BackgroundColor3 = "DropdownBack" })

        Library:Create("UICorner", {
            Parent = Items.Back.Instance,
            CornerRadius = UDim.new(0, 4)
        })

        Items.Selected = Library:Create("TextLabel", {
            Parent = Items.Back.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Text,
            Text = "-",
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -34, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "Text" })

        Items.Arrow = Library:Create("ImageLabel", {
            Parent = Items.Back.Instance,
            Name = "\0",
            ImageColor3 = Library.Theme.DimText,
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -8, 0.5, 0),
            Size = UDim2.new(0, 14, 0, 14),
            BorderSizePixel = 0
        }):AddToTheme({ ImageColor3 = "DimText" })
        ApplyIcon(Items.Arrow.Instance, "127296511745226")

        Items.Opened = Library:Create("Frame", {
            Parent = Library.UnusedHolder.Instance,
            Name = "\0",
            Visible = false,
            ClipsDescendants = true,
            Size = UDim2.new(0, 218, 0, 0),
            ZIndex = 50,
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.DropdownBack
        }):AddToTheme({ BackgroundColor3 = "DropdownBack" })

        Library:Create("UICorner", {
            Parent = Items.Opened.Instance,
            CornerRadius = UDim.new(0, 4)
        })

        local SearchHeight = Dropdown.SearchBarEnabled and 30 or 0

        if Dropdown.SearchBarEnabled then
            Items.SearchBack = Library:Create("Frame", {
                Parent = Items.Opened.Instance,
                Name = "\0",
                Position = UDim2.new(0, 6, 0, 6),
                Size = UDim2.new(1, -12, 0, 22),
                ZIndex = 51,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.DropdownSelected
            }):AddToTheme({ BackgroundColor3 = "DropdownSelected" })

            Library:Create("UICorner", {
                Parent = Items.SearchBack.Instance,
                CornerRadius = UDim.new(0, 4)
            })

            Items.SearchInput = Library:Create("TextBox", {
                Parent = Items.SearchBack.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme.Text,
                PlaceholderColor3 = Library.Theme.DimText,
                PlaceholderText = "Search...",
                Text = "",
                TextSize = 14,
                ClearTextOnFocus = false,
                CursorPosition = -1,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 8, 0.5, 0),
                Size = UDim2.new(1, -16, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 51,
                BorderSizePixel = 0
            }):AddToTheme({ TextColor3 = "Text", PlaceholderColor3 = "DimText" })
        end

        Items.Scroll = Library:Create("ScrollingFrame", {
            Parent = Items.Opened.Instance,
            Name = "\0",
            ClipsDescendants = true,
            ScrollBarImageTransparency = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Library.Theme.Accent,
            Selectable = false,
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, 0, 0, SearchHeight),
            Size = UDim2.new(1, 0, 1, -SearchHeight),
            ZIndex = 50,
            BackgroundTransparency = 1,
            BorderSizePixel = 0
        }):AddToTheme({ ScrollBarImageColor3 = "Accent" })

        Library:Create("UIListLayout", {
            Parent = Items.Scroll.Instance,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        if Dropdown.SearchBarEnabled then
            Library:Connect(Items.SearchInput.Instance:GetPropertyChangedSignal("Text"), function()
                local Query = string.lower(Items.SearchInput.Instance.Text)
                local Shown = 0
                for _, Data in Dropdown.Order do
                    local Match = Query == "" or string.find(string.lower(Data.Name), Query, 1, true) ~= nil
                    Data.Row.Instance.Visible = Match
                    if Match then Shown += 1 end
                end
                Dropdown:RefreshCorners()
                if Dropdown.IsOpen then
                    local Current = Items.Opened.Instance.Size
                    Items.Opened:Tween({ Size = UDim2.new(Current.X.Scale, Current.X.Offset, 0, 30 + math.min(Shown * 25, 125)) }, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                end
            end)
        end

        AddDivider(Self, Items.Holder.Instance)

        Dropdown.Items = Items

        Items.Back:OnHover(function()
            Items.Back:Tween({ BackgroundColor3 = Library.Theme.DropdownSelected })
        end, function()
            Items.Back:Tween({ BackgroundColor3 = Library.Theme.DropdownBack })
        end)

        local function UpdateDisplay()
            if Dropdown.Multi then
                Items.Selected.Instance.Text = #Dropdown.Value > 0 and table.concat(Dropdown.Value, ", ") or "-"
            else
                Items.Selected.Instance.Text = Dropdown.Value or "-"
            end
        end

        function Dropdown:AddOption(Option)
            local Row = Library:Create("Frame", {
                Parent = Items.Scroll.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                ZIndex = 50,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.DropdownSelected
            }):AddToTheme({ BackgroundColor3 = "DropdownSelected" })

            local Button = Library:Create("TextButton", {
                Parent = Row.Instance,
                Name = "\0",
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 51,
                BorderSizePixel = 0
            })

            local Text = Library:Create("TextLabel", {
                Parent = Row.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme.DimText,
                Text = Option,
                TextSize = 15,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -10, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 51,
                BorderSizePixel = 0
            }):AddToTheme({ TextColor3 = "DimText" })

            local Check = Library:Create("ImageLabel", {
                Parent = Row.Instance,
                Name = "\0",
                ImageColor3 = Library.Theme.Accent,
                ImageTransparency = 1,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 7),
                Size = UDim2.new(0, 12, 0, 12),
                ZIndex = 51,
                BorderSizePixel = 0
            }):AddToTheme({ ImageColor3 = "Accent" })
            ApplyIcon(Check.Instance, "10709790644")

            local Data = { Name = Option, Selected = false, Row = Row, Text = Text, Check = Check }

            function Data:Toggle(Active)
                Data.Selected = Active
                if Active then
                    Text:ChangeItemTheme({ TextColor3 = "Text" })
                    Row:Tween({ BackgroundTransparency = 0 })
                    Text:Tween({ TextColor3 = Library.Theme.Text, Position = UDim2.new(0, 30, 0, 0) })
                    Check:Tween({ ImageTransparency = 0 })
                else
                    Text:ChangeItemTheme({ TextColor3 = "DimText" })
                    Row:Tween({ BackgroundTransparency = 1 })
                    Text:Tween({ TextColor3 = Library.Theme.DimText, Position = UDim2.new(0, 10, 0, 0) })
                    Check:Tween({ ImageTransparency = 1 })
                end
            end

            Button:Connect("MouseButton1Down", function()
                if Dropdown.Multi then
                    local Index = table.find(Dropdown.Value, Option)
                    if Index then
                        table.remove(Dropdown.Value, Index)
                        Data:Toggle(false)
                    else
                        table.insert(Dropdown.Value, Option)
                        Data:Toggle(true)
                    end
                else
                    Dropdown.Value = Option
                    for _, Other in Dropdown.OptionData do
                        Other:Toggle(Other == Data)
                    end
                end

                if Dropdown.Flag then
                    Library.Flags[Dropdown.Flag] = Dropdown.Value
                end

                UpdateDisplay()
                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end)

            Data:Toggle(false)
            Dropdown.OptionData[Option] = Data
            table.insert(Dropdown.Order, Data)
            Dropdown:RefreshCorners()
            return Data
        end

        function Dropdown:RefreshCorners()
            local Visible = { }
            for _, Data in Dropdown.Order do
                if Data.Row.Instance.Visible then
                    table.insert(Visible, Data)
                end
            end
            for _, Data in Dropdown.Order do
                local Edge = (Visible[1] == Data) or (Visible[#Visible] == Data)
                if Edge and not Data.Corner then
                    Data.Corner = Library:Create("UICorner", {
                        Parent = Data.Row.Instance,
                        CornerRadius = UDim.new(0, 4)
                    })
                elseif not Edge and Data.Corner then
                    Data.Corner.Instance:Destroy()
                    Data.Corner = nil
                end
            end
        end

        function Dropdown:Set(Value)
            if Dropdown.Multi then
                if type(Value) ~= "table" then return end
                Dropdown.Value = Value
                for _, Data in Dropdown.OptionData do
                    Data:Toggle(table.find(Value, Data.Name) ~= nil)
                end
            else
                if not Dropdown.OptionData[Value] then return end
                Dropdown.Value = Value
                for _, Data in Dropdown.OptionData do
                    Data:Toggle(Data.Name == Value)
                end
            end

            if Dropdown.Flag then
                Library.Flags[Dropdown.Flag] = Dropdown.Value
            end

            UpdateDisplay()
            Library:SafeCall(Dropdown.Callback, Dropdown.Value)
        end

        function Dropdown:Get()
            return Dropdown.Value
        end

        function Dropdown:RemoveOption(Name)
            local Data = Dropdown.OptionData[Name]
            if Data then
                local Index = table.find(Dropdown.Order, Data)
                if Index then table.remove(Dropdown.Order, Index) end
                Data.Row.Instance:Destroy()
                Dropdown.OptionData[Name] = nil
                Dropdown:RefreshCorners()
            end
        end

        function Dropdown:Refresh(List)
            for Name in Dropdown.OptionData do
                Dropdown:RemoveOption(Name)
            end
            Dropdown.Options = List
            for _, Option in List do
                Dropdown:AddOption(Option)
            end
            UpdateDisplay()
        end

        local function TargetSize()
            local Scale = Library:GetScreenScale()
            return UDim2.new(0, Items.Back.Instance.AbsoluteSize.X / Scale, 0, (Dropdown.SearchBarEnabled and 30 or 0) + math.min(#Dropdown.Options * 25, 125))
        end

        local function PopupPosition(ExtraY)
            local Scale = Library:GetScreenScale()
            return UDim2.fromOffset(Items.Back.Instance.AbsolutePosition.X / Scale, (Items.Back.Instance.AbsolutePosition.Y + Items.Back.Instance.AbsoluteSize.Y + GuiInset + (ExtraY or 0)) / Scale)
        end

        function Dropdown:SetOpen(Bool)
            if Dropdown.Debounce then return end

            Dropdown.IsOpen = Bool
            Dropdown.Debounce = true
            Items.Arrow:Tween({ Rotation = Bool and 180 or 0 })

            if Bool then
                Items.Opened.Instance.Parent = Library.Holder.Instance
                Items.Opened.Instance.Size = TargetSize()
                Items.Opened.Instance.Position = PopupPosition(0)
                Items.Opened.Instance.Visible = true
                Items.Opened:Tween({ Position = PopupPosition(10) })

                for _, Value in Library.OpenFrames do
                    if Value ~= Dropdown then Value:SetOpen(false) end
                end

                Library.OpenFrames[Dropdown] = Dropdown

                Items.Opened:FadeDescendants(true, function()
                    Dropdown.Debounce = false
                end)
            else
                Library.OpenFrames[Dropdown] = nil

                local Current = Items.Opened.Instance.Position
                Items.Opened:Tween({ Position = UDim2.new(Current.X.Scale, Current.X.Offset, Current.Y.Scale, Current.Y.Offset - 10) })
                Items.Opened:FadeDescendants(false, function()
                    Dropdown.Debounce = false
                    Items.Opened.Instance.Parent = Library.UnusedHolder.Instance
                end)
            end
        end

        Items.Back:Connect("MouseButton1Down", function()
            Dropdown:SetOpen(not Dropdown.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Dropdown.IsOpen and not Items.Opened:IsMouseOverFrame() and not Items.Back:IsMouseOverFrame() then
                    Dropdown:SetOpen(false)
                end
            end
        end)

        for _, Option in Dropdown.Options do
            Dropdown:AddOption(Option)
        end

        if Dropdown.Default then
            Dropdown:Set(Dropdown.Default)
        end

        if Dropdown.Flag then
            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end
        end

        return setmetatable(Dropdown, Library)
    end

    Library.Button = function(Self, Params)
        Params = Params or { }

        local Button = {
            Name = Params.Name or Params.name or "Button",
            Callback = Params.Callback or Params.callback or function() end,
            Tooltip = Params.Tooltip or Params.tooltip,
            Items = { }
        }

        local Items = { }

        Items.Holder = Library:Create("Frame", {
            Parent = Self.Items.Content.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 46),
            BorderSizePixel = 0
        })

        if Button.Tooltip then Items.Holder:Tooltip(Button.Tooltip) end

        Items.Button = Library:Create("TextButton", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            Text = "",
            AutoButtonColor = false,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 9),
            Size = UDim2.new(1, -24, 0, 28),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.DropdownBack
        }):AddToTheme({ BackgroundColor3 = "DropdownBack" })

        Library:Create("UICorner", {
            Parent = Items.Button.Instance,
            CornerRadius = UDim.new(0, 4)
        })

        Items.Text = Library:Create("TextLabel", {
            Parent = Items.Button.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Text,
            Text = Button.Name,
            TextSize = 14,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "Text" })

        AddDivider(Self, Items.Holder.Instance)

        Button.Items = Items

        Items.Button:OnHover(function()
            Items.Button:Tween({ BackgroundColor3 = Library.Theme.DropdownSelected })
        end, function()
            Items.Button:Tween({ BackgroundColor3 = Library.Theme.DropdownBack })
        end)

        function Button:Press()
            Items.Button:Tween({ BackgroundColor3 = Library.Theme.Accent })
            task.wait(0.12)
            Items.Button:Tween({ BackgroundColor3 = Library.Theme.DropdownBack })
            Library:SafeCall(Button.Callback)
        end

        function Button:SetText(Text)
            Items.Text.Instance.Text = tostring(Text)
        end

        Items.Button:Connect("MouseButton1Down", function()
            Button:Press()
        end)

        return setmetatable(Button, Library)
    end

    Library.Textbox = function(Self, Params)
        Params = Params or { }

        local Textbox = {
            Name = Params.Name or Params.name or "Textbox",
            Default = Params.Default or Params.default or "",
            Placeholder = Params.Placeholder or Params.placeholder or "...",
            Callback = Params.Callback or Params.callback or function() end,
            Finished = Params.Finished or Params.finished or false,
            Tooltip = Params.Tooltip or Params.tooltip,
            Flag = Params.Flag or Params.flag,
            Value = "",
            Items = { }
        }

        local Items = { }

        Items.Holder = Library:Create("Frame", {
            Parent = Self.Items.Content.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 60),
            BorderSizePixel = 0
        })

        if Textbox.Tooltip then Items.Holder:Tooltip(Textbox.Tooltip) end

        Items.Name = Library:Create("TextLabel", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.DimText,
            Text = Textbox.Name,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 2),
            Size = UDim2.new(1, -24, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "DimText" })

        Items.Back = Library:Create("Frame", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            Position = UDim2.new(0, 12, 0, 28),
            Size = UDim2.new(1, -24, 0, 25),
            ClipsDescendants = true,
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.DropdownBack
        }):AddToTheme({ BackgroundColor3 = "DropdownBack" })

        Library:Create("UICorner", {
            Parent = Items.Back.Instance,
            CornerRadius = UDim.new(0, 4)
        })

        Items.Input = Library:Create("TextBox", {
            Parent = Items.Back.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Text,
            PlaceholderColor3 = Library.Theme.DimText,
            PlaceholderText = Textbox.Placeholder,
            Text = "",
            TextSize = 14,
            ClearTextOnFocus = false,
            CursorPosition = -1,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 10, 0.5, 0),
            Size = UDim2.new(1, -20, 1, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "Text", PlaceholderColor3 = "DimText" })

        AddDivider(Self, Items.Holder.Instance)

        Textbox.Items = Items

        function Textbox:Set(Value)
            Textbox.Value = tostring(Value)
            Items.Input.Instance.Text = Textbox.Value
            if Textbox.Flag then Library.Flags[Textbox.Flag] = Textbox.Value end
            Library:SafeCall(Textbox.Callback, Textbox.Value)
        end

        function Textbox:Get()
            return Textbox.Value
        end

        if Textbox.Finished then
            Items.Input:Connect("FocusLost", function(Enter)
                if Enter then Textbox:Set(Items.Input.Instance.Text) end
            end)
        else
            Library:Connect(Items.Input.Instance:GetPropertyChangedSignal("Text"), function()
                Textbox:Set(Items.Input.Instance.Text)
            end)
        end

        if Textbox.Default ~= "" then
            Textbox:Set(Textbox.Default)
        end

        if Textbox.Flag then
            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end
        end

        return setmetatable(Textbox, Library)
    end

    Library.List = function(Self, Params)
        Params = Params or { }

        local List = {
            Name = Params.Name or Params.name or "List",
            Empty = Params.Empty or Params.empty or "It's still empty here",
            Callback = Params.Callback or Params.callback or function() end,
            Tooltip = Params.Tooltip or Params.tooltip,
            Value = nil,
            OptionData = { },
            Order = { },
            Items = { }
        }

        local Items = { }

        Items.Holder = Library:Create("Frame", {
            Parent = Self.Items.Content.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 178),
            BorderSizePixel = 0
        })

        if List.Tooltip then Items.Holder:Tooltip(List.Tooltip) end

        Items.Name = Library:Create("TextLabel", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.DimText,
            Text = List.Name,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 2),
            Size = UDim2.new(1, -24, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "DimText" })

        Items.Box = Library:Create("Frame", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            Position = UDim2.new(0, 12, 0, 26),
            Size = UDim2.new(1, -24, 0, 138),
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.DropdownBack
        }):AddToTheme({ BackgroundColor3 = "DropdownBack" })

        Library:Create("UICorner", { Parent = Items.Box.Instance, CornerRadius = UDim.new(0, 6) })

        Items.Empty = Library:Create("TextLabel", {
            Parent = Items.Box.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.DimText,
            Text = List.Empty,
            TextSize = 14,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Center,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "DimText" })

        Items.Scroll = Library:Create("ScrollingFrame", {
            Parent = Items.Box.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageTransparency = 0,
            ScrollBarImageColor3 = Library.Theme.Accent,
            Selectable = false,
            Active = true,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 2,
            BorderSizePixel = 0
        }):AddToTheme({ ScrollBarImageColor3 = "Accent" })

        Library:Create("UIPadding", {
            Parent = Items.Scroll.Instance,
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4)
        })

        Library:Create("UIListLayout", {
            Parent = Items.Scroll.Instance,
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        AddDivider(Self, Items.Holder.Instance)

        List.Items = Items

        local function UpdateEmpty()
            Items.Empty.Instance.Visible = #List.Order == 0
        end

        function List:AddOption(Option)
            local Row = Library:Create("Frame", {
                Parent = Items.Scroll.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 28),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.DropdownSelected
            }):AddToTheme({ BackgroundColor3 = "DropdownSelected" })

            local Button = Library:Create("TextButton", {
                Parent = Row.Instance,
                Name = "\0",
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 3,
                BorderSizePixel = 0
            })

            local Line = Library:Create("Frame", {
                Parent = Row.Instance,
                Name = "\0",
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 6, 0.5, 0),
                Size = UDim2.new(0, 3, 0, 14),
                BackgroundTransparency = 1,
                ZIndex = 3,
                BorderSizePixel = 0,
                BackgroundColor3 = Library.Theme.Accent
            }):AddToTheme({ BackgroundColor3 = "Accent" })

            Library:Create("UICorner", { Parent = Line.Instance, CornerRadius = UDim.new(1, 0) })

            local Text = Library:Create("TextLabel", {
                Parent = Row.Instance,
                Name = "\0",
                FontFace = Library.Font,
                TextColor3 = Library.Theme.DimText,
                Text = Option,
                TextSize = 14,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -20, 1, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 3,
                BorderSizePixel = 0
            }):AddToTheme({ TextColor3 = "DimText" })

            local Data = { Name = Option, Selected = false, Row = Row, Text = Text, Line = Line }

            function Data:Toggle(Active)
                Data.Selected = Active
                if Active then
                    Text:ChangeItemTheme({ TextColor3 = "Text" })
                    Row:Tween({ BackgroundTransparency = 0 })
                    Text:Tween({ TextColor3 = Library.Theme.Text, Position = UDim2.new(0, 24, 0, 0) })
                    Line:Tween({ BackgroundTransparency = 0, Position = UDim2.new(0, 12, 0.5, 0) })
                else
                    Text:ChangeItemTheme({ TextColor3 = "DimText" })
                    Row:Tween({ BackgroundTransparency = 1 })
                    Text:Tween({ TextColor3 = Library.Theme.DimText, Position = UDim2.new(0, 12, 0, 0) })
                    Line:Tween({ BackgroundTransparency = 1, Position = UDim2.new(0, 6, 0.5, 0) })
                end
            end

            Button:Connect("MouseButton1Down", function()
                if Data.Selected then
                    List.Value = nil
                    Data:Toggle(false)
                else
                    List.Value = Option
                    for _, Other in List.Order do
                        Other:Toggle(Other == Data)
                    end
                end
                Library:SafeCall(List.Callback, List.Value)
            end)

            Data:Toggle(false)
            List.OptionData[Option] = Data
            table.insert(List.Order, Data)
            UpdateEmpty()
            return Data
        end

        function List:RemoveOption(Name)
            local Data = List.OptionData[Name]
            if Data then
                local Index = table.find(List.Order, Data)
                if Index then table.remove(List.Order, Index) end
                Data.Row.Instance:Destroy()
                List.OptionData[Name] = nil
                if List.Value == Name then List.Value = nil end
                UpdateEmpty()
            end
        end

        function List:Refresh(NewList)
            for Name in List.OptionData do
                List:RemoveOption(Name)
            end
            for _, Option in NewList do
                List:AddOption(Option)
            end
            UpdateEmpty()
        end

        function List:Set(Value)
            if not List.OptionData[Value] then return end
            List.Value = Value
            for _, Data in List.Order do
                Data:Toggle(Data.Name == Value)
            end
            Library:SafeCall(List.Callback, List.Value)
        end

        function List:Get()
            return List.Value
        end

        for _, Option in (Params.Items or Params.items or { }) do
            List:AddOption(Option)
        end

        UpdateEmpty()

        return setmetatable(List, Library)
    end

    Library.Colorpicker = function(Self, Params)
        Params = Params or { }

        local Colorpicker = {
            Name = Params.Name or Params.name or "Colorpicker",
            Default = Params.Default or Params.default or Color3.fromRGB(254, 0, 67),
            Callback = Params.Callback or Params.callback or function() end,
            Tooltip = Params.Tooltip or Params.tooltip,
            Flag = Params.Flag or Params.flag,
            Hue = 0, Saturation = 0, Value = 0,
            Transparency = Params.Transparency or Params.transparency or 0,
            Color = Color3.fromRGB(255, 255, 255),
            IsOpen = false,
            Debounce = false,
            Items = { }
        }

        local Items = { }

        Items.Holder = Library:Create("Frame", {
            Parent = Self.Items.Content.Instance,
            Name = "\0",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35),
            BorderSizePixel = 0
        })

        if Colorpicker.Tooltip then Items.Holder:Tooltip(Colorpicker.Tooltip) end

        Items.Name = Library:Create("TextLabel", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Text,
            Text = Colorpicker.Name,
            TextSize = 14,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -60, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0
        }):AddToTheme({ TextColor3 = "Text" })

        Items.Swatch = Library:Create("TextButton", {
            Parent = Items.Holder.Instance,
            Name = "\0",
            Text = "",
            AutoButtonColor = false,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -12, 0.5, 0),
            Size = UDim2.new(0, 34, 0, 16),
            BorderSizePixel = 0,
            BackgroundColor3 = Colorpicker.Default
        })

        Library:Create("UICorner", { Parent = Items.Swatch.Instance, CornerRadius = UDim.new(0, 5) })
        Library:Create("UIStroke", {
            Parent = Items.Swatch.Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Library.Theme.Border,
            Transparency = 0.3
        }):AddToTheme({ Color = "Border" })

        AddDivider(Self, Items.Holder.Instance)

        Items.Window = Library:Create("Frame", {
            Parent = Library.UnusedHolder.Instance,
            Name = "\0",
            Visible = false,
            Size = UDim2.new(0, 210, 0, 210),
            ZIndex = 50,
            BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.Section
        }):AddToTheme({ BackgroundColor3 = "Section" })

        Library:Create("UICorner", { Parent = Items.Window.Instance, CornerRadius = UDim.new(0, 8) })
        Library:Create("UIStroke", {
            Parent = Items.Window.Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Library.Theme.Border,
            Transparency = 0.4
        }):AddToTheme({ Color = "Border" })

        Items.Window:MakeDraggable()

        Items.Palette = Library:Create("ImageButton", {
            Parent = Items.Window.Instance,
            Name = "\0",
            AutoButtonColor = false,
            Position = UDim2.new(0, 12, 0, 12),
            Size = UDim2.new(1, -24, 0, 108),
            ZIndex = 51,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        })
        Library:Create("UICorner", { Parent = Items.Palette.Instance, CornerRadius = UDim.new(0, 6) })

        Items.Sat = Library:Create("Frame", {
            Parent = Items.Palette.Instance, Name = "\0",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(1, 0, 1, 0), ZIndex = 51, BorderSizePixel = 0
        })
        Library:Create("UIGradient", { Parent = Items.Sat.Instance, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }) })
        Library:Create("UICorner", { Parent = Items.Sat.Instance, CornerRadius = UDim.new(0, 6) })

        Items.Val = Library:Create("Frame", {
            Parent = Items.Palette.Instance, Name = "\0",
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0), ZIndex = 51, BorderSizePixel = 0
        })
        Library:Create("UIGradient", { Parent = Items.Val.Instance, Rotation = 90, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) }) })
        Library:Create("UICorner", { Parent = Items.Val.Instance, CornerRadius = UDim.new(0, 6) })

        Items.PaletteDrag = Library:Create("Frame", {
            Parent = Items.Palette.Instance, Name = "\0",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0, 10, 0, 10), ZIndex = 52, BorderSizePixel = 0
        })
        Library:Create("UICorner", { Parent = Items.PaletteDrag.Instance, CornerRadius = UDim.new(1, 0) })
        Library:Create("UIStroke", { Parent = Items.PaletteDrag.Instance, Color = Color3.fromRGB(255, 255, 255), Thickness = 1.5 })

        Items.Hue = Library:Create("ImageButton", {
            Parent = Items.Window.Instance, Name = "\0",
            AutoButtonColor = false,
            Position = UDim2.new(0, 12, 0, 128),
            Size = UDim2.new(1, -54, 0, 14),
            ZIndex = 51, BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        })
        Library:Create("UICorner", { Parent = Items.Hue.Instance, CornerRadius = UDim.new(0, 4) })
        Library:Create("UIGradient", {
            Parent = Items.Hue.Instance,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })
        })

        Items.HueDrag = Library:Create("Frame", {
            Parent = Items.Hue.Instance, Name = "\0",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 5, 1, 8), ZIndex = 52, BorderSizePixel = 0
        })
        Library:Create("UICorner", { Parent = Items.HueDrag.Instance, CornerRadius = UDim.new(0, 3) })
        Library:Create("UIStroke", { Parent = Items.HueDrag.Instance, Color = Library.Theme.Section, Thickness = 1.5 }):AddToTheme({ Color = "Section" })

        Items.Alpha = Library:Create("ImageButton", {
            Parent = Items.Window.Instance, Name = "\0",
            AutoButtonColor = false,
            Position = UDim2.new(0, 12, 0, 148),
            Size = UDim2.new(1, -54, 0, 14),
            ZIndex = 51, BorderSizePixel = 0,
            BackgroundColor3 = Colorpicker.Default
        })
        Library:Create("UICorner", { Parent = Items.Alpha.Instance, CornerRadius = UDim.new(0, 4) })
        Library:Create("UIGradient", { Parent = Items.Alpha.Instance, Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) }) })

        Items.AlphaDrag = Library:Create("Frame", {
            Parent = Items.Alpha.Instance, Name = "\0",
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0, 5, 1, 8), ZIndex = 52, BorderSizePixel = 0
        })
        Library:Create("UICorner", { Parent = Items.AlphaDrag.Instance, CornerRadius = UDim.new(0, 3) })
        Library:Create("UIStroke", { Parent = Items.AlphaDrag.Instance, Color = Library.Theme.Section, Thickness = 1.5 }):AddToTheme({ Color = "Section" })

        Items.Copy = Library:Create("TextButton", {
            Parent = Items.Window.Instance, Name = "\0",
            Text = "", AutoButtonColor = false,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -8, 0, 148),
            Size = UDim2.new(0, 28, 0, 40),
            ZIndex = 51, BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.DropdownBack
        }):AddToTheme({ BackgroundColor3 = "DropdownBack" })
        Library:Create("UICorner", { Parent = Items.Copy.Instance, CornerRadius = UDim.new(0, 4) })

        Items.CopyIcon = Library:Create("ImageLabel", {
            Parent = Items.Copy.Instance, Name = "\0",
            ImageColor3 = Library.Theme.DimText,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 16, 0, 16),
            BackgroundTransparency = 1, ZIndex = 51, BorderSizePixel = 0
        }):AddToTheme({ ImageColor3 = "DimText" })
        ApplyIcon(Items.CopyIcon.Instance, "10709812159")

        Items.Hex = Library:Create("TextBox", {
            Parent = Items.Window.Instance, Name = "\0",
            FontFace = Library.Font,
            TextColor3 = Library.Theme.Text,
            PlaceholderColor3 = Library.Theme.DimText,
            PlaceholderText = "#ffffff", Text = "#ffffff", TextSize = 14,
            ClearTextOnFocus = false, CursorPosition = -1,
            Position = UDim2.new(0, 12, 0, 172),
            Size = UDim2.new(1, -44, 0, 26),
            ZIndex = 51, BorderSizePixel = 0,
            BackgroundColor3 = Library.Theme.DropdownBack
        }):AddToTheme({ TextColor3 = "Text", PlaceholderColor3 = "DimText", BackgroundColor3 = "DropdownBack" })
        Library:Create("UICorner", { Parent = Items.Hex.Instance, CornerRadius = UDim.new(0, 5) })
        Library:Create("UIPadding", { Parent = Items.Hex.Instance, PaddingLeft = UDim.new(0, 8) })

        Items.Paste = Library:Create("ImageButton", {
            Parent = Items.Window.Instance, Name = "\0",
            AutoButtonColor = false,
            ImageColor3 = Library.Theme.Accent,
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -12, 0, 185),
            Size = UDim2.new(0, 18, 0, 18),
            ZIndex = 51, BorderSizePixel = 0
        }):AddToTheme({ ImageColor3 = "Accent" })
        ApplyIcon(Items.Paste.Instance, "10709798443")

        Colorpicker.Items = Items

        function Colorpicker:Update()
            Colorpicker.Color = Color3.fromHSV(Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value)
            Items.Swatch:Tween({ BackgroundColor3 = Colorpicker.Color, BackgroundTransparency = Colorpicker.Transparency })
            Items.Palette:Tween({ BackgroundColor3 = Color3.fromHSV(Colorpicker.Hue, 1, 1) })
            Items.Alpha:Tween({ BackgroundColor3 = Colorpicker.Color })

            if not Items.Hex.Instance:IsFocused() then
                Items.Hex.Instance.Text = "#" .. Colorpicker.Color:ToHex()
            end

            if Colorpicker.Flag then
                Library.Flags[Colorpicker.Flag] = { __color = Colorpicker.Color:ToHex(), __alpha = Colorpicker.Transparency }
            end

            Library:SafeCall(Colorpicker.Callback, Colorpicker.Color, Colorpicker.Transparency)
        end

        function Colorpicker:Set(Color, Alpha)
            if type(Color) == "table" then Color = Color3.fromRGB(Color[1], Color[2], Color[3]) end
            if type(Color) == "string" then Color = Color3.fromHex(Color) end
            Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
            Colorpicker.Transparency = Alpha or Colorpicker.Transparency or 0
            Items.PaletteDrag.Instance.Position = UDim2.new(Colorpicker.Saturation, 0, 1 - Colorpicker.Value, 0)
            Items.HueDrag.Instance.Position = UDim2.new(Colorpicker.Hue, 0, 0.5, 0)
            Items.AlphaDrag.Instance.Position = UDim2.new(Colorpicker.Transparency, 0, 0.5, 0)
            Colorpicker:Update()
        end

        function Colorpicker:Get()
            return Colorpicker.Color, Colorpicker.Transparency
        end

        local SlidingPalette, SlidingHue, SlidingAlpha = false, false, false
        local PaletteChanged, HueChanged, AlphaChanged

        local function SlidePalette(Input)
            if not SlidingPalette or not Input then return end
            local SX = math.clamp((Input.Position.X - Items.Palette.Instance.AbsolutePosition.X) / Items.Palette.Instance.AbsoluteSize.X, 0, 1)
            local SY = math.clamp((Input.Position.Y - Items.Palette.Instance.AbsolutePosition.Y) / Items.Palette.Instance.AbsoluteSize.Y, 0, 1)
            Colorpicker.Saturation = SX
            Colorpicker.Value = 1 - SY
            Items.PaletteDrag:Tween({ Position = UDim2.new(SX, 0, SY, 0) }, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            Colorpicker:Update()
        end

        local function SlideHue(Input)
            if not SlidingHue or not Input then return end
            local HX = math.clamp((Input.Position.X - Items.Hue.Instance.AbsolutePosition.X) / Items.Hue.Instance.AbsoluteSize.X, 0, 1)
            Colorpicker.Hue = HX
            Items.HueDrag:Tween({ Position = UDim2.new(HX, 0, 0.5, 0) }, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            Colorpicker:Update()
        end

        local function SlideAlpha(Input)
            if not SlidingAlpha or not Input then return end
            local AX = math.clamp((Input.Position.X - Items.Alpha.Instance.AbsolutePosition.X) / Items.Alpha.Instance.AbsoluteSize.X, 0, 1)
            Colorpicker.Transparency = AX
            Items.AlphaDrag:Tween({ Position = UDim2.new(AX, 0, 0.5, 0) }, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            Colorpicker:Update()
        end

        Items.Palette:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingPalette = true
                SlidePalette(Input)
                if PaletteChanged then return end
                PaletteChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingPalette = false
                        PaletteChanged:Disconnect()
                        PaletteChanged = nil
                    end
                end)
            end
        end)

        Items.Hue:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingHue = true
                SlideHue(Input)
                if HueChanged then return end
                HueChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingHue = false
                        HueChanged:Disconnect()
                        HueChanged = nil
                    end
                end)
            end
        end)

        Items.Alpha:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                SlidingAlpha = true
                SlideAlpha(Input)
                if AlphaChanged then return end
                AlphaChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        SlidingAlpha = false
                        AlphaChanged:Disconnect()
                        AlphaChanged = nil
                    end
                end)
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if SlidingPalette then SlidePalette(Input) end
                if SlidingHue then SlideHue(Input) end
                if SlidingAlpha then SlideAlpha(Input) end
            end
        end)

        Items.Hex:Connect("FocusLost", function()
            local Text = string.gsub(Items.Hex.Instance.Text, "#", "")
            local Ok, Color = pcall(function() return Color3.fromHex(Text) end)
            if Ok and Color then
                Colorpicker:Set(Color, Colorpicker.Transparency)
            else
                Items.Hex.Instance.Text = "#" .. Colorpicker.Color:ToHex()
            end
        end)

        Items.Copy:Connect("MouseButton1Down", function()
            local Hex = "#" .. Colorpicker.Color:ToHex()
            local Clip = setclipboard or toclipboard
            if Clip then Clip(Hex) end
            Library:Notification({
                Name = "Copied to clipboard",
                Description = Hex,
                Duration = 2,
                Icon = "10709812159",
                Color = Colorpicker.Color
            })
        end)

        Items.Paste:Connect("MouseButton1Down", function()
            local Read = getclipboard or readclipboard
            if Read then
                local Text = Read()
                if type(Text) == "string" and Text ~= "" then
                    local Ok, Color = pcall(function() return Color3.fromHex((string.gsub(Text, "#", ""))) end)
                    if Ok and Color then
                        Colorpicker:Set(Color, Colorpicker.Transparency)
                    end
                end
            end
        end)

        local function PopupPosition(ExtraY)
            local Scale = Library:GetScreenScale()
            return UDim2.fromOffset(Items.Swatch.Instance.AbsolutePosition.X / Scale - 176, (Items.Swatch.Instance.AbsolutePosition.Y + Items.Swatch.Instance.AbsoluteSize.Y + GuiInset + (ExtraY or 0)) / Scale)
        end

        function Colorpicker:SetOpen(Bool)
            if Colorpicker.Debounce then return end
            Colorpicker.IsOpen = Bool
            Colorpicker.Debounce = true

            if Bool then
                Items.Window.Instance.Parent = Library.Holder.Instance
                Items.Window.Instance.Position = PopupPosition(0)
                Items.Window.Instance.Visible = true
                Items.Window:Tween({ Position = PopupPosition(10) })

                for _, Value in Library.OpenFrames do
                    if Value ~= Colorpicker then Value:SetOpen(false) end
                end
                Library.OpenFrames[Colorpicker] = Colorpicker

                Items.Window:FadeDescendants(true, function()
                    Colorpicker.Debounce = false
                end)
            else
                Library.OpenFrames[Colorpicker] = nil
                local Current = Items.Window.Instance.Position
                Items.Window:Tween({ Position = UDim2.new(Current.X.Scale, Current.X.Offset, Current.Y.Scale, Current.Y.Offset - 10) })
                Items.Window:FadeDescendants(false, function()
                    Colorpicker.Debounce = false
                    Items.Window.Instance.Parent = Library.UnusedHolder.Instance
                end)
            end
        end

        Items.Swatch:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Colorpicker.IsOpen and not Items.Window:IsMouseOverFrame() and not Items.Swatch:IsMouseOverFrame() then
                    Colorpicker:SetOpen(false)
                end
            end
        end)

        Colorpicker:Set(Colorpicker.Default, Colorpicker.Transparency)

        if Colorpicker.Flag then
            Library.SetFlags[Colorpicker.Flag] = function(Color, Alpha)
                Colorpicker:Set(Color, Alpha)
            end
        end

        return setmetatable(Colorpicker, Library)
    end

    Library.Config = function(Self)
        local AutoLoadFile = Library.Directory .. "/autoload.txt"
        local SelectedConfig = ""
        local ConfigName = ""
        local List

        List = Self:List({
            Name = "Config List",
            Empty = "It's still empty here",
            Items = Library:GetConfigsList(),
            Callback = function(Value) SelectedConfig = Value or "" end
        })

        Self:Textbox({ Name = "Config Name", Placeholder = "my config", Callback = function(Value) ConfigName = Value end })

        Self:Button({ Name = "Create", Callback = function()
            if ConfigName ~= "" then
                writefile(Library.ConfigFolder .. "/" .. ConfigName .. ".json", Library:GetConfig())
                Library:GetConfigsList(List)
                Library:Notification({ Name = "Config", Description = "Created " .. ConfigName, Duration = 3, Icon = "check", Color = Color3.fromRGB(52, 255, 164) })
            end
        end })

        Self:Button({ Name = "Save", Callback = function()
            if SelectedConfig ~= "" then
                writefile(Library.ConfigFolder .. "/" .. SelectedConfig .. ".json", Library:GetConfig())
                Library:Notification({ Name = "Config", Description = "Saved " .. SelectedConfig, Duration = 3, Icon = "check", Color = Color3.fromRGB(52, 255, 164) })
            end
        end })

        Self:Button({ Name = "Load", Callback = function()
            if SelectedConfig ~= "" and isfile(Library.ConfigFolder .. "/" .. SelectedConfig .. ".json") then
                Library:LoadConfig(readfile(Library.ConfigFolder .. "/" .. SelectedConfig .. ".json"))
                Library:Notification({ Name = "Config", Description = "Loaded " .. SelectedConfig, Duration = 3, Icon = "check", Color = Color3.fromRGB(52, 255, 164) })
            end
        end })

        Self:Button({ Name = "Delete", Callback = function()
            if SelectedConfig ~= "" and isfile(Library.ConfigFolder .. "/" .. SelectedConfig .. ".json") then
                delfile(Library.ConfigFolder .. "/" .. SelectedConfig .. ".json")
                Library:GetConfigsList(List)
            end
        end })

        Self:Button({ Name = "Refresh", Callback = function() Library:GetConfigsList(List) end })

        Self:Toggle({
            Name = "Auto Load",
            Default = isfile and isfile(AutoLoadFile) or false,
            Callback = function(State)
                if State and SelectedConfig ~= "" then
                    writefile(AutoLoadFile, SelectedConfig)
                elseif not State and isfile(AutoLoadFile) then
                    delfile(AutoLoadFile)
                end
            end
        })

        if isfile and isfile(AutoLoadFile) then
            local Name = readfile(AutoLoadFile)
            if isfile(Library.ConfigFolder .. "/" .. Name .. ".json") then
                task.defer(function()
                    Library:LoadConfig(readfile(Library.ConfigFolder .. "/" .. Name .. ".json"))
                    List:Set(Name)
                end)
            end
        end

        return List
    end

    Library.Theming = function(Self)
        local Pickers = { }

        Self:Dropdown({
            Name = "Preset Theme",
            Items = Library.ThemeList,
            Default = Library.CurrentTheme,
            Callback = function(Name)
                Library:SetTheme(Name)
                for Key, CP in Pickers do
                    CP:Set(Library.Theme[Key])
                end
            end
        })

        for _, Key in Library.ThemeKeys do
            Pickers[Key] = Self:Colorpicker({
                Name = Key,
                Default = Library.Theme[Key],
                Flag = "Theme" .. Key,
                Callback = function(Color)
                    Library:ChangeTheme(Key, Color)
                end
            })
        end
    end

    getgenv().Arcane = Library
end

return Library
