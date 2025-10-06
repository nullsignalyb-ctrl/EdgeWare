--[[
    Minimal UI Loader (Tabs Only)
    Made by Late
]]

--// --- PLACE YOUR COMPONENTS LINK HERE ---
local COMPONENTS_URL = "https://raw.githubusercontent.com/yourusername/yourrepo/main/Components.lua"
local Components = loadstring(game:HttpGet(COMPONENTS_URL))()

--// Services
local GetService = game.GetService
local LocalPlayer = GetService(game,"Players").LocalPlayer
local TweenService = GetService(game,"TweenService")
local UserInput = GetService(game,"UserInputService")
local RunService = GetService(game,"RunService")

--// Settings
local Setup = {
    Keybind = Enum.KeyCode.LeftControl,
    Transparency = 0.2,
    ThemeMode = "Dark",
    Size = UDim2.new(0,400,0,250),
}

local Theme = {
    Primary = Color3.fromRGB(30,30,30),
    Secondary = Color3.fromRGB(35,35,35),
    Tab = Color3.fromRGB(200,200,200),
    Title = Color3.fromRGB(240,240,240),
}

--// Loader Window
local Screen
if identifyexecutor then
    Screen = GetService(game,"InsertService"):LoadLocalAsset("rbxassetid://18490507748")
else
    Screen = script.Parent
end

Screen.Main.Visible = false
pcall(function() Screen.Parent = game.CoreGui end)
if not Screen.Parent then
    Screen.Parent = LocalPlayer.PlayerGui
end

--// Utilities
local function Tween(Object,Time,Props,Info)
    local Style = Info and Info.EasingStyle or Enum.EasingStyle.Sine
    local Dir = Info and Info.EasingDirection or Enum.EasingDirection.Out
    TweenService:Create(Object,TweenInfo.new(Time,Style,Dir),Props):Play()
end

local function Drag(Frame)
    if not Frame then return end
    local dragging, start, startPos, dragInput
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInput.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - start
            Frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,
                                       startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end

--// Animations
local Animations = {}
function Animations:Open(Window,Transparency)
    Window.Size = UDim2.new(Window.Size.X.Scale*1.1,Window.Size.X.Offset*1.1,
                            Window.Size.Y.Scale*1.1,Window.Size.Y.Offset*1.1)
    Window.GroupTransparency = 1
    Window.Visible = true
    Tween(Window,.25,{Size=Setup.Size,GroupTransparency=Transparency or Setup.Transparency})
end
function Animations:Close(Window)
    Window.GroupTransparency = 1
    Tween(Window,.25,{Size=UDim2.new(Window.Size.X.Scale*1.1,Window.Size.X.Offset*1.1,
                                     Window.Size.Y.Scale*1.1,Window.Size.Y.Offset*1.1)})
    task.wait(.25)
    Window.Size = Setup.Size
    Window.Visible = false
end

--// Library
local Library = {}

function Library:CreateWindow(Settings)
    local Window = Screen.Main
    Window.Visible = true
    Drag(Window)

    -- Tabs Table
    local Options = {}
    local StoredTabs = {}

    function Options:AddTab(TabName)
        local Tab = Instance.new("Frame") -- Minimal placeholder tab; you can replace with your component
        Tab.Name = TabName
        Tab.Size = UDim2.new(0,150,0,30)
        Tab.BackgroundColor3 = Theme.Secondary
        Tab.Parent = Window.Sidebar
        StoredTabs[TabName] = {Tab=Tab, Pages={}}
        return Tab -- Return tab so users can add components externally
    end

    function Options:SetTab(TabName)
        for Name,data in pairs(StoredTabs) do
            data.Tab.BackgroundColor3 = (Name==TabName and Theme.Primary or Theme.Secondary)
            for _,Page in pairs(data.Pages) do
                Page.Visible = Name==TabName
            end
        end
    end

    -- Keybind toggle
    local Opened = true
    UserInput.InputBegan:Connect(function(input,focused)
        if (input.KeyCode == Setup.Keybind) and not focused then
            Opened = not Opened
            if Opened then
                Animations:Open(Window)
            else
                Animations:Close(Window)
            end
        end
    end)

    return Options
end

return Library
