--// HAROLD CUP - LOCAL SCRIPT

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

--------------------------------------------------
-- ESTADOS
--------------------------------------------------
local speedOn = false
local autoKick = false
local espOn = false
local xrayOn = false
local grabOn = false
local teleKActive = false
local speedKeyActive = false

local normalSpeed = 28
local fastSpeed = 36
local currentSpeed = normalSpeed

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

--------------------------------------------------
-- SONIDO CLICK
--------------------------------------------------
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

--------------------------------------------------
-- FRAME PRINCIPAL
--------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.3,0.6)
frame.Position = UDim2.fromScale(0.35,0.2)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

--------------------------------------------------
-- TITULO
--------------------------------------------------
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.08)
title.BackgroundTransparency = 1
title.Text = "harold cup"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,90,90)
title.Active = true

--------------------------------------------------
-- CREAR BOTONES
--------------------------------------------------
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

--------------------------------------------------
-- BOTONES MENU
--------------------------------------------------
local teleBtn  = makeButton("TELEGUIADO",0.12)
local speedBtn = makeButton("SPEED",0.23)
local kickBtn  = makeButton("AUTO KICK",0.34)
local espBtn = makeButton("ESP",0.45,0.43)
espBtn.Position = UDim2.fromScale(0.05,0.45)
local xrayBtn = makeButton("X-RAY",0.45,0.43)
xrayBtn.Position = UDim2.fromScale(0.52,0.45)
local grabBtn = makeButton("AUTO GRAB",0.56)
local keyTBtn = makeButton("KEY-T",0.67)
local closeBtn = makeButton("CLOSE",0.78)

--------------------------------------------------
-- TELEGUIADO
--------------------------------------------------
local function doTeleport()
    local startPos = hrp.Position
    local endPos = spawnCFrame.Position
    local direction = (endPos - startPos).Unit
    local distance = (endPos - startPos).Magnitude
    local speed = 300

    local travelled = 0
    while travelled < distance do
        RunService.Heartbeat:Wait()
        local step = speed * RunService.Heartbeat:Wait()
        travelled = travelled + step
        local newPos = startPos + direction * math.min(travelled,distance)
        hrp.CFrame = CFrame.new(newPos,endPos)
    end
    hrp.CFrame = spawnCFrame
end

teleBtn.MouseButton1Click:Connect(function()
    click()
    doTeleport()
end)

--------------------------------------------------
-- SPEED
--------------------------------------------------
speedBtn.MouseButton1Click:Connect(function()
    click()
    speedOn = not speedOn
    humanoid.WalkSpeed = speedOn and fastSpeed or normalSpeed
    currentSpeed = humanoid.WalkSpeed
    speedBtn.Text = speedOn and "SPEED : ON" or "SPEED : OFF"
end)

--------------------------------------------------
-- AUTO KICK
--------------------------------------------------
kickBtn.MouseButton1Click:Connect(function()
    click()
    autoKick = not autoKick
    kickBtn.Text = autoKick and "AUTO KICK : ON" or "AUTO KICK : OFF"
end)

--------------------------------------------------
-- ESP
--------------------------------------------------
local espObjs = {}
local function clearESP()
    for _,v in pairs(espObjs) do if v then v:Destroy() end end
    table.clear(espObjs)
end

local function createESP(plr,color)
    if not plr.Character or not plr.Character:FindFirstChild("Head") then return end
    local bb = Instance.new("BillboardGui", gui)
    bb.Adornee = plr.Character.Head
    bb.Size = UDim2.new(0,260,0,45)
    bb.AlwaysOnTop = true
    local t = Instance.new("TextLabel", bb)
    t.Size = UDim2.new(1,0,1,0)
    t.BackgroundTransparency = 1
    t.Text = plr.Name
    t.Font = Enum.Font.GothamBlack
    t.TextScaled = true
    t.TextColor3 = color
    t.TextStrokeTransparency = 0
    table.insert(espObjs, bb)
end

espBtn.MouseButton1Click:Connect(function()
    click()
    espOn = not espOn
    espBtn.Text = espOn and "ESP : ON" or "ESP : OFF"
    clearESP()
    if espOn then
        createESP(player,Color3.fromRGB(0,170,255))
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= player then
                createESP(p,Color3.fromRGB(255,0,0))
            end
        end
    end
end)

xrayBtn.MouseButton1Click:Connect(function()
    click()
    xrayOn = not xrayOn
    xrayBtn.Text = xrayOn and "X-RAY : ON" or "X-RAY : OFF"
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(char) then
            if not v.Name:lower():find("floor") then
                v.LocalTransparencyModifier = xrayOn and 0.6 or 0
            end
        end
    end
end)

--------------------------------------------------
-- AUTO GRAB
--------------------------------------------------
grabBtn.MouseButton1Click:Connect(function()
    click()
    grabOn = not grabOn
    grabBtn.Text = grabOn and "AUTO GRAB : ON" or "AUTO GRAB : OFF"
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

--------------------------------------------------
-- CLOSE
--------------------------------------------------
local open = true
closeBtn.MouseButton1Click:Connect(function()
    click()
    open = false
    frame.Visible = false
end)

--------------------------------------------------
-- ICONO PEQUEÑO
--------------------------------------------------
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromScale(0.08,0.08)
icon.Position = UDim2.fromScale(0.03,0.45)
icon.Text = "O"
icon.Font = Enum.Font.GothamBlack
icon.TextScaled = true
icon.TextColor3 = Color3.new(1,1,1)
icon.BackgroundColor3 = Color3.new(0,0,0)
icon.BorderSizePixel = 0
icon.Active = true
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

local draggingIcon, dragStartIcon, startPosIcon
icon.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        draggingIcon = true
        dragStartIcon = i.Position
        startPosIcon = icon.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if draggingIcon and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStartIcon
        icon.Position = UDim2.new(startPosIcon.X.Scale,startPosIcon.X.Offset+d.X,startPosIcon.Y.Scale,startPosIcon.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function() draggingIcon = false end)

-- MENU DEL ICONO
local iconMenu = Instance.new("Frame", gui)
iconMenu.Size = UDim2.fromScale(0.3,0.25)
iconMenu.Position = UDim2.fromScale(0.1,0.3)
iconMenu.BackgroundColor3 = Color3.fromRGB(25,25,25)
iconMenu.BorderSizePixel = 0
iconMenu.Visible = false
Instance.new("UICorner", iconMenu).CornerRadius = UDim.new(0,18)

local function createIconMenuButton(text,posY)
    local b = Instance.new("TextButton", iconMenu)
    b.Size = UDim2.fromScale(0.9,0.15)
    b.Position = UDim2.fromScale(0.05,posY)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.BorderSizePixel = 0
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,14)
    return b
end

local hideBtn = createIconMenuButton("HIDE MENU",0.05)
local keySpeedBtn = createIconMenuButton("KEY-SPEED",0.35)
local plusBtn = createIconMenuButton("+",0.6)
local minusBtn = createIconMenuButton("-",0.75)

icon.MouseButton1Click:Connect(function()
    click()
    iconMenu.Visible = not iconMenu.Visible
end)

--------------------------------------------------
-- FUNCION KEY-T TELE K
--------------------------------------------------
local teleKeyBtn
keyTBtn.MouseButton1Click:Connect(function()
    click()
    teleKActive = not teleKActive
    if teleKActive then
        if not teleKeyBtn then
            teleKeyBtn = Instance.new("TextButton", gui)
            teleKeyBtn.Size = UDim2.fromScale(0.08,0.08)
            teleKeyBtn.Position = UDim2.fromScale(0.9,0.05)
            teleKeyBtn.Text = "TELE K"
            teleKeyBtn.Font = Enum.Font.GothamBold
            teleKeyBtn.TextScaled = true
            teleKeyBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
            teleKeyBtn.BorderSizePixel = 0
            teleKeyBtn.TextColor3 = Color3.new(1,1,1)
            teleKeyBtn.MouseButton1Click:Connect(function()
                doTeleport()
            end)
        end
        teleKeyBtn.Visible = true
    else
        if teleKeyBtn then
            teleKeyBtn.Visible = false
        end
    end
end)

--------------------------------------------------
-- FUNCION KEY-SPEED
--------------------------------------------------
local speedKeyBtn
keySpeedBtn.MouseButton1Click:Connect(function()
    click()
    speedKeyActive = not speedKeyActive
    if speedKeyActive then
        if not speedKeyBtn then
            speedKeyBtn = Instance.new("TextButton", gui)
            speedKeyBtn.Size = UDim2.fromScale(0.08,0.08)
            speedKeyBtn.Position = UDim2.fromScale(0.9,0.15)
            speedKeyBtn.Text = "SPEED"
            speedKeyBtn.Font = Enum.Font.GothamBold
            speedKeyBtn.TextScaled = true
            speedKeyBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
            speedKeyBtn.BorderSizePixel = 0
            speedKeyBtn.TextColor3 = Color3.new(1,1,1)
            speedKeyBtn.MouseButton1Click:Connect(function()
                speedOn = not speedOn
                humanoid.WalkSpeed = speedOn and currentSpeed or normalSpeed
                speedBtn.Text = speedOn and "SPEED : ON" or "SPEED : OFF"
                speedKeyBtn.BackgroundColor3 = speedOn and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
            end)
        end
        speedKeyBtn.Visible = true
    else
        if speedKeyBtn then
            speedKeyBtn.Visible = false
        end
    end
end)

--------------------------------------------------
-- DRAG MENU HAROLD CUP
--------------------------------------------------
local draggingMenu, dragStartMenu, startPosMenu
frame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        draggingMenu = true
        dragStartMenu = i.Position
        startPosMenu = frame.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if draggingMenu and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStartMenu
        frame.Position = UDim2.new(startPosMenu.X.Scale,startPosMenu.X.Offset+d.X,startPosMenu.Y.Scale,startPosMenu.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function() draggingMenu = false end)

print("🐱 HAROLD CUP - Script listo con Tele K y Key Speed conectados ✅")
