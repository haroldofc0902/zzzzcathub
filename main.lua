--// HAROLD CUP - LOCAL SCRIPT FINAL (3 BOTONES, PANEL ORIGINAL)

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
local autoKick = false
local grabOn = false

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- SONIDO CLICK
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

-- FRAME PRINCIPAL (NO TOCADO)
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
title.Text = "rezxKurd"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0,150,255)
title.Active = true

-- FUNCION BOTONES (ORIGINAL)
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

-- BOTONES (SOLO 3)
local teleBtn = makeButton("TELEPORT",0.15)
local grabBtn = makeButton("AUTO GRAB",0.25)
local kickBtn = makeButton("AUTO KICK",0.35)

-- TELEPORT
local function doTeleport()
    click()
    teleBtn.Text = "teleporting..."

    local startPos = hrp.Position
    local endPos = spawnCFrame.Position
    local dir = (endPos - startPos).Unit
    local dist = (endPos - startPos).Magnitude
    local speed = 300
    local moved = 0

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        moved += speed * dt
        hrp.CFrame = CFrame.new(startPos + dir * math.min(moved, dist))
        if moved >= dist then
            hrp.CFrame = spawnCFrame
            teleBtn.Text = "TELEPORT"
            conn:Disconnect()
        end
    end)
end

teleBtn.MouseButton1Click:Connect(doTeleport)

-- AUTO GRAB (SOURCE ORIGINAL)
grabBtn.MouseButton1Click:Connect(function()
    click()
    grabOn = not grabOn
end)

RunService.Heartbeat:Connect(function()
    if grabOn then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                local t = string.lower(v.ActionText or "")
                if t:find("robar") or t:find("steal") then
                    pcall(function()
                        v.HoldDuration = 0
                        v:InputHoldBegin()
                    end)
                end
            end
        end
    end
end)

-- AUTO KICK TOGGLE
local function enableAutoKick()
    local function scanGUI(parent)
        for _,obj in ipairs(parent:GetDescendants()) do
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

kickBtn.MouseButton1Click:Connect(function()
    click()
    autoKick = not autoKick
    kickBtn.Text = autoKick and "AUTO KICK ON" or "AUTO KICK"
    if autoKick then
        enableAutoKick()
    end
end)

-- PANEL MOVIBLE (ORIGINAL)
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
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)
UIS.InputEnded:Connect(function()
    dragging = false
end)

print("🔥 HAROLD CUP — TELEPORT / AUTO GRAB / AUTO KICK cargados sin tocar el panel")
