local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- CONFIG
local UI_CONFIG = {
    MainColor = Color3.fromRGB(20, 15, 30),
    StrokeColor = Color3.fromRGB(80, 120, 255),
    TextColor = Color3.fromRGB(80, 120, 255),
    ButtonColor = Color3.fromRGB(40, 40, 50),
    ButtonTextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    CornerRadius = UDim.new(0, 10)
}

-- HELPER
local function Create(className, properties, children)
    local inst = Instance.new(className)
    for k,v in pairs(properties or {}) do inst[k] = v end
    for _,c in pairs(children or {}) do c.Parent = inst end
    return inst
end

-- CLEANUP
if CoreGui:FindFirstChild("rexHub") then
    CoreGui.rexHub:Destroy()
end

-- SCREEN GUI
local ScreenGui = Create("ScreenGui", {Name = "rexHub", Parent = CoreGui})

-- MAIN PANEL
local MainFrame = Create("Frame", {
    Name = "MainFrame",
    BackgroundColor3 = UI_CONFIG.MainColor,
    Size = UDim2.new(0, 200, 0, 160),
    Position = UDim2.new(0.5, -100, 0.5, -80),
    BorderSizePixel = 0,
    Parent = ScreenGui
}, {
    Create("UICorner", {CornerRadius = UI_CONFIG.CornerRadius}),
    Create("UIStroke", {Color = UI_CONFIG.StrokeColor, Thickness = 2})
})

-- HEADER TEXT
local Header = Create("TextLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1,0,0,25),
    Position = UDim2.new(0,0,0,0),
    Font = UI_CONFIG.Font,
    Text = "rezxKurd",
    TextColor3 = UI_CONFIG.TextColor,
    TextSize = 18,
    Parent = MainFrame
})

-- DRAGGING LOGIC
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- BUTTON CREATOR
local function CreateButton(name, parent)
    local btn = Create("TextButton", {
        Name = name,
        BackgroundColor3 = UI_CONFIG.ButtonColor,
        Size = UDim2.new(0.9,0,0,50),
        Position = UDim2.new(0.05,0,0,0),
        Font = UI_CONFIG.Font,
        Text = name,
        TextColor3 = UI_CONFIG.ButtonTextColor,
        TextSize = 16,
        Parent = parent,
        AutoButtonColor = true
    }, {
        Create("UICorner",{CornerRadius = UDim.new(0,8)}),
        Create("UIStroke",{Color = UI_CONFIG.StrokeColor, Thickness = 1})
    })
    return btn
end

-- CONTAINER FOR BUTTONS
local ButtonsFrame = Create("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1,0,1,-30),
    Position = UDim2.new(0,0,0,30),
    Parent = MainFrame
})

-- TELEPORT BUTTON
local TeleportBtn = CreateButton("TELEPORT", ButtonsFrame)
TeleportBtn.Position = UDim2.new(0.05,0,0,0)

-- AUTO KICK BUTTON
local AutoKickBtn = CreateButton("AUTO KICK [OFF]", ButtonsFrame)
AutoKickBtn.Position = UDim2.new(0.05,0,0,60)

-- SOUND
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://9118821472" -- simple click sound
clickSound.Volume = 1
clickSound.Parent = MainFrame

-- TELEPORT FUNCTION
local function teleportPlayer()
    clickSound:Play()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local spawnPos = player.RespawnLocation or workspace:WaitForChild("SpawnLocation")
    
    TeleportBtn.Text = "teleporting..."
    
    local distance = (spawnPos.Position - hrp.Position).Magnitude
    local speed = 500
    local duration = distance/speed
    local startPos = hrp.Position
    local goalPos = spawnPos.Position
    local t = 0
    
    local conn
    conn = RunService.RenderStepped:Connect(function(dt)
        t = t + dt
        local alpha = math.clamp(t/duration,0,1)
        hrp.CFrame = CFrame.new(startPos:Lerp(goalPos, alpha))
        if alpha >= 1 then
            conn:Disconnect()
            TeleportBtn.Text = "TELEPORT"
        end
    end)
end

-- AUTO KICK LOGIC
local autoKickActive = false
local function toggleAutoKick()
    clickSound:Play()
    autoKickActive = not autoKickActive
    AutoKickBtn.Text = autoKickActive and "AUTO KICK [ON]" or "AUTO KICK [OFF]"
    
    if autoKickActive then
        spawn(function()
            local keyword = "you stole"
            local kickMessage = "You stole a pet by rezxKurd"

            local function hasKeyword(text)
                if typeof(text) ~= "string" then return false end
                return string.find(string.lower(text), keyword) ~= nil
            end

            local function kickPlayer()
                pcall(function()
                    player:Kick(kickMessage)
                end)
            end

            local function scanGuiObjects(parent)
                for _, obj in ipairs(parent:GetDescendants()) do
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                        if hasKeyword(obj.Text) then
                            kickPlayer()
                            return true
                        end
                        obj:GetPropertyChangedSignal("Text"):Connect(function()
                            if hasKeyword(obj.Text) and autoKickActive then kickPlayer() end
                        end)
                    end
                end
                return false
            end

            local function setupGuiWatcher(gui)
                gui.DescendantAdded:Connect(function(desc)
                    if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
                        if hasKeyword(desc.Text) and autoKickActive then
                            kickPlayer()
                        end
                        desc:GetPropertyChangedSignal("Text"):Connect(function()
                            if hasKeyword(desc.Text) and autoKickActive then kickPlayer() end
                        end)
                    end
                end)
            end

            for _, gui in ipairs(player:WaitForChild("PlayerGui"):GetChildren()) do
                setupGuiWatcher(gui)
            end

            player.PlayerGui.ChildAdded:Connect(function(gui)
                setupGuiWatcher(gui)
                scanGuiObjects(gui)
            end)

            scanGuiObjects(player.PlayerGui)
        end)
    end
end

-- BUTTON CONNECTIONS
TeleportBtn.MouseButton1Click:Connect(teleportPlayer)
AutoKickBtn.MouseButton1Click:Connect(toggleAutoKick)
