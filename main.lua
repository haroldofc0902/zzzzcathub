--// HAROLD CUP - LOCAL SCRIPT FINAL INTEGRADO

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local spawnCFrame = hrp.CFrame

player.CharacterAdded:Connect(function(c)
    char = c
    hrp = c:WaitForChild("HumanoidRootPart")
    humanoid = c:WaitForChild("Humanoid")
    spawnCFrame = hrp.CFrame
end)

-- ESTADOS
local speedOn = false
local autoKick = false
local currentSpeed = 28
local normalSpeed = 28
local fastSpeed = 36

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- SONIDO CLICK
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

-- FRAME PRINCIPAL HAROLD CUP
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.35,0.60)
frame.Position = UDim2.fromScale(0.32,0.18)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- TITULO
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.08)
title.BackgroundTransparency = 1
title.Text = "rezxKurd" -- Nombre arriba del panel
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0,150,255)
title.Active = true

-- FUNCION PARA BOTONES GRANDES
local function makeButton(text, posY, width)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.fromScale(width or 0.9,0.09)
    b.Position = UDim2.fromScale(0.05,posY)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.TextSize = 28
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
    return b
end

-- BOTONES PANEL
local teleBtn  = makeButton("TELEPORT",0.15)
local kickBtn  = makeButton("AUTO KICK",0.35)

-- SONIDO Y FUNCIONES BOTONES
local function doTeleport()
    click() -- reproducir sonido
    local startPos = hrp.Position
    local endPos = spawnCFrame.Position
    local direction = (endPos - startPos).Unit
    local distance = (endPos - startPos).Magnitude
    local speed = 300
    local travelled = 0

    teleBtn.Text = "teleporting..."

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        local step = speed * dt
        travelled = travelled + step
        local newPos = startPos + direction * math.min(travelled, distance)
        hrp.CFrame = CFrame.new(newPos, endPos)
        if travelled >= distance then
            hrp.CFrame = spawnCFrame
            teleBtn.Text = "TELEPORT"
            conn:Disconnect()
        end
    end)
end

teleBtn.MouseButton1Click:Connect(doTeleport)

-- AUTO KICK TOGGLE
local function autoKickFunc()
    if autoKick then
        autoKick = false
        kickBtn.Text = "AUTO KICK"
    else
        autoKick = true
        kickBtn.Text = "AUTO KICK ON"
        -- Escanea GUI y kickea si detecta "you stole"
        local function scanGUI(parent)
            for _, obj in ipairs(parent:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    obj:GetPropertyChangedSignal("Text"):Connect(function()
                        if string.find(string.lower(obj.Text),"you stole") then
                            player:Kick("You stole a pet by rezxKurd")
                        end
                    end)
                end
            end
        end
        scanGUI(player.PlayerGui)
        player.PlayerGui.ChildAdded:Connect(scanGUI)
    end
end

kickBtn.MouseButton1Click:Connect(function()
    click()
    autoKickFunc()
end)

-- SPEED (para mantener funcional)
speedBtn = makeButton("SPEED",0.25)
speedBtn.MouseButton1Click:Connect(function()
    click()
    speedOn = not speedOn
    humanoid.WalkSpeed = speedOn and fastSpeed or normalSpeed
    currentSpeed = humanoid.WalkSpeed
end)

-- PANEL MOVIBLE
local dragging, dragStart, startPos
title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = i.Position
        startPos = frame.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function() dragging = false end)

print("🐱 Script completo con TELEPORT y AUTO KICK toggle listo ✅")
