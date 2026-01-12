local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- CONFIG
local UI_CONFIG = {
    MainColor = Color3.fromRGB(20, 15, 30),
    StrokeColor = Color3.fromRGB(130, 50, 210),
    TextColor = Color3.fromRGB(100, 150, 255),
    AccentColor = Color3.fromRGB(140, 40, 220),
    Font = Enum.Font.GothamBold,
    CornerRadius = UDim.new(0, 12)
}

-- CREATE FUNCTION
local function Create(className, properties, children)
    local inst = Instance.new(className)
    for k,v in pairs(properties or {}) do inst[k] = v end
    for _,child in pairs(children or {}) do child.Parent = inst end
    return inst
end

-- REMOVE EXISTING GUI
if CoreGui:FindFirstChild("rexHub") then
    CoreGui.rexHub:Destroy()
end

local ScreenGui = Create("ScreenGui", {
    Name = "rexHub",
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local MainFrame = Create("Frame", {
    Name = "MainFrame",
    BackgroundColor3 = UI_CONFIG.MainColor,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -120, 0.5, -60),
    Size = UDim2.new(0, 240, 0, 120),
    Parent = ScreenGui
}, {
    Create("UICorner", {CornerRadius = UI_CONFIG.CornerRadius}),
    Create("UIStroke", {Color = UI_CONFIG.StrokeColor, Thickness = 2})
})

-- HEADER
local Header = Create("Frame", {
    Name = "Header",
    BackgroundTransparency = 1,
    Size = UDim2.new(1,0,0,40),
    Parent = MainFrame
}, {
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0,10,0,5),
        Size = UDim2.new(1, -20, 0, 30),
        Font = UI_CONFIG.Font,
        Text = "rexHub",
        TextColor3 = UI_CONFIG.TextColor,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
})

-- START BUTTON
local StartBtn = Create("TextButton", {
    Name = "StartBtn",
    BackgroundColor3 = UI_CONFIG.AccentColor,
    Size = UDim2.new(0, 200, 0, 50),
    Position = UDim2.new(0.5, -100, 0.5, -25),
    Font = UI_CONFIG.Font,
    Text = "Start",
    TextColor3 = Color3.new(1,1,1),
    TextSize = 18,
    Parent = MainFrame
}, {
    Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
    Create("UIStroke", {Color = UI_CONFIG.StrokeColor, Thickness = 2})
})

-- BUTTON SOUND
local function PlayClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://12222225" -- Puedes poner otro sonido
    sound.Volume = 1
    sound.Parent = MainFrame
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

-- SOURCE PLACEHOLDER
local sourceExecuted = false
local function ExecuteSource()
    if sourceExecuted then return end
    sourceExecuted = true
    -- Aquí pones el source que me enviaste
end

-- START BUTTON LOGIC
StartBtn.MouseButton1Click:Connect(function()
    PlayClickSound()
    ExecuteSource()
    StartBtn.Text = "Stop"
    StartBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    -- No afecta el source, solo visual del botón
end)

-- PANEL DRAG
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
