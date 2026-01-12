local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- CONFIG
local UI_CONFIG = {
    MainColor = Color3.fromRGB(20, 15, 30),
    StrokeColor = Color3.fromRGB(130, 50, 210),
    TextColor = Color3.fromRGB(100, 150, 255),
    AccentColor = Color3.fromRGB(140, 40, 220),
    ToggleOn = Color3.fromRGB(100, 255, 160),
    ToggleOff = Color3.fromRGB(60, 60, 60),
    Font = Enum.Font.GothamBold,
    CornerRadius = UDim.new(0, 12)
}

local function Create(className, properties, children)
    local instance = Instance.new(className)
    for k, v in pairs(properties or {}) do
        instance[k] = v
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

-- DESTROY EXISTING
if CoreGui:FindFirstChild("rexHub") then
    CoreGui.rexHub:Destroy()
end

local ScreenGui = Create("ScreenGui", {
    Name = "rexHub",
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

-- MAIN PANEL
local MainFrame = Create("Frame", {
    Name = "MainFrame",
    BackgroundColor3 = UI_CONFIG.MainColor,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -150, 0.5, -100),
    Size = UDim2.new(0, 300, 0, 150),
    Parent = ScreenGui
}, {
    Create("UICorner", {CornerRadius = UI_CONFIG.CornerRadius}),
    Create("UIStroke", {Color = UI_CONFIG.StrokeColor, Thickness = 2})
})

-- HEADER
local Header = Create("Frame", {
    Name = "Header",
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 30),
    Parent = MainFrame
}, {
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(1, -20, 0, 20),
        Font = UI_CONFIG.Font,
        Text = "rexHub",
        TextColor3 = UI_CONFIG.TextColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
})

-- DRAGGING LOGIC
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- BUTTON CREATION
local function CreateButton(text, color)
    local btnFrame = Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(25, 20, 35),
        Size = UDim2.new(1, 0, 0, 40),
        Parent = MainFrame
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
        Create("UIStroke", {Color = UI_CONFIG.StrokeColor, Thickness = 1})
    })

    local btn = Create("TextButton", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = UI_CONFIG.Font,
        Text = text,
        TextColor3 = color or UI_CONFIG.TextColor,
        TextSize = 16,
        Parent = btnFrame
    })
    return btnFrame, btn
end

-- START BUTTON
local StartFrame, StartBtn = CreateButton("Start", UI_CONFIG.AccentColor)
StartFrame.Position = UDim2.new(0, 0, 0, 50)
StartFrame.Parent = MainFrame

local LagEnabled = false

-- FUNCTION TO LAG OTHER PLAYERS
local function LagOtherPlayers()
    task.spawn(function()
        while LagEnabled do
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    -- Aquí va el código que causa "lag" o spameo, solo para otros
                    -- Ejemplo: mover el HumanoidRootPart ligeramente o spamear un evento remoto
                    -- NO TOCAR LocalPlayer para que no te afecte
                end
            end
            task.wait(0.05)
        end
    end)
end

StartBtn.MouseButton1Click:Connect(function()
    if not LagEnabled then
        LagEnabled = true
        StartBtn.Text = "Stop"
        StartBtn.TextColor3 = Color3.fromRGB(255,255,255)
        LagOtherPlayers()
    else
        LagEnabled = false
        StartBtn.Text = "Start"
    end
end)
