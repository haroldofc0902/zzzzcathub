--// HAROLD CUP - LOCAL SCRIPT FINAL

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
local espOn = false
local xrayOn = false
local grabOn = false
local teleKActive = false
local speedKeyActive = false
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
title.Text = "harold cup"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,90,90)
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

-- BOTONES HAROLD CUP
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

-- TELEGUIADO
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
        local newPos = startPos + direction * math.min(travelled, distance)
        hrp.CFrame = CFrame.new(newPos, endPos)
    end
    hrp.CFrame = spawnCFrame
end

teleBtn.MouseButton1Click:Connect(function()
    click()
    doTeleport()
end)

-- SPEED
speedBtn.MouseButton1Click:Connect(function()
    click()
    speedOn = not speedOn
    humanoid.WalkSpeed = speedOn and fastSpeed or normalSpeed
    currentSpeed = humanoid.WalkSpeed
end)

-- AUTO KICK
kickBtn.MouseButton1Click:Connect(function()
    click()
    autoKick = not autoKick
end)

-- ESP Y X-RAY
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
    clearESP()
    if espOn then
        createESP(player, Color3.fromRGB(0,170,255))
        for _,p in pairs(Players:GetPlayers()) do
            if p ~= player then
                createESP(p, Color3.fromRGB(255,0,0))
            end
        end
    end
end)

xrayBtn.MouseButton1Click:Connect(function()
    click()
    xrayOn = not xrayOn
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsDescendantOf(char) then
            if not v.Name:lower():find("floor") then
                v.LocalTransparencyModifier = xrayOn and 0.6 or 0
            end
        end
    end
end)

-- AUTO GRAB
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

-- CERRAR MENU
local open = true
closeBtn.MouseButton1Click:Connect(function()
    click()
    open = false
    frame.Visible = false
end)

-- DRAG MENU
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

-- ICONO MOVIBLE
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromScale(0.09,0.09)
icon.Position = UDim2.fromScale(0.03,0.45)
icon.Text = "O"
icon.Font = Enum.Font.GothamBlack
icon.TextScaled = true
icon.TextColor3 = Color3.new(1,1,1)
icon.BackgroundColor3 = Color3.new(0,0,0)
icon.BorderSizePixel = 0
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

local iconMenu = Instance.new("Frame", gui)
iconMenu.Size = frame.Size
iconMenu.Position = UDim2.fromScale(0.32,0.18)
iconMenu.BackgroundColor3 = Color3.fromRGB(25,25,25)
iconMenu.BorderSizePixel = 0
iconMenu.Visible = false
Instance.new("UICorner", iconMenu).CornerRadius = UDim.new(0,18)

local hideMenuBtn = Instance.new("TextButton", iconMenu)
hideMenuBtn.Size = UDim2.fromScale(0.9,0.1)
hideMenuBtn.Position = UDim2.fromScale(0.05,0.05)
hideMenuBtn.Text = "HIDE MENU"
hideMenuBtn.Font = Enum.Font.GothamBold
hideMenuBtn.TextScaled = true
hideMenuBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
hideMenuBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", hideMenuBtn).CornerRadius = UDim.new(0,14)

local keySpeedBtn = Instance.new("TextButton", iconMenu)
keySpeedBtn.Size = UDim2.fromScale(0.9,0.1)
keySpeedBtn.Position = UDim2.fromScale(0.05,0.18)
keySpeedBtn.Text = "KEY-SPEED"
keySpeedBtn.Font = Enum.Font.GothamBold
keySpeedBtn.TextScaled = true
keySpeedBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
keySpeedBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keySpeedBtn).CornerRadius = UDim.new(0,14)

local speedIncBtn = Instance.new("TextButton", iconMenu)
speedIncBtn.Size = UDim2.fromScale(0.43,0.08)
speedIncBtn.Position = UDim2.fromScale(0.05,0.31)
speedIncBtn.Text = "+"
speedIncBtn.Font = Enum.Font.GothamBold
speedIncBtn.TextScaled = true
speedIncBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedIncBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedIncBtn).CornerRadius = UDim.new(0,14)

local speedDecBtn = Instance.new("TextButton", iconMenu)
speedDecBtn.Size = UDim2.fromScale(0.43,0.08)
speedDecBtn.Position = UDim2.fromScale(0.52,0.31)
speedDecBtn.Text = "-"
speedDecBtn.Font = Enum.Font.GothamBold
speedDecBtn.TextScaled = true
speedDecBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedDecBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedDecBtn).CornerRadius = UDim.new(0,14)

local speedLabel = Instance.new("TextLabel", iconMenu)
speedLabel.Size = UDim2.fromScale(0.9,0.08)
speedLabel.Position = UDim2.fromScale(0.05,0.42)
speedLabel.Text = tostring(currentSpeed)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextScaled = true
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1

icon.MouseButton1Click:Connect(function()
    click()
    iconMenu.Visible = not iconMenu.Visible
end)

hideMenuBtn.MouseButton1Click:Connect(function()
    click()
    frame.Visible = not frame.Visible
end)

speedIncBtn.MouseButton1Click:Connect(function()
    click()
    currentSpeed = currentSpeed + 1
    speedLabel.Text = tostring(currentSpeed)
    if speedOn or speedKeyActive then humanoid.WalkSpeed = currentSpeed end
end)

speedDecBtn.MouseButton1Click:Connect(function()
    click()
    currentSpeed = currentSpeed - 1
    if currentSpeed < 1 then currentSpeed = 1 end
    speedLabel.Text = tostring(currentSpeed)
    if speedOn or speedKeyActive then humanoid.WalkSpeed = currentSpeed end
end)

keySpeedBtn.MouseButton1Click:Connect(function()
    click()
    speedKeyActive = not speedKeyActive
    keySpeedBtn.BackgroundColor3 = speedKeyActive and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
    speedOn = speedKeyActive
    humanoid.WalkSpeed = speedOn and currentSpeed or normalSpeed
end)

-- DRAG ICONO Y MENU
local dI, dStart, dPos
icon.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dI = true
        dStart = i.Position
        dPos = icon.Position
    end
end)
UIS.InputChanged:Connect(function(i)
    if dI and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dStart
        icon.Position = UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y)
        iconMenu.Position = iconMenu.Position -- menu movible igual que icono
    end
end)
UIS.InputEnded:Connect(function() dI = false end)

print("🐱 HAROLD CUP — Script cargado con Tele K y Speed Keybind funcionales ✅")
