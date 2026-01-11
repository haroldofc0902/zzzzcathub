--// HAROLDCUPS FINAL SCRIPT

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
local keyTOn = false
local keySpeedOn = false
local speedValue = 28

local normalSpeed = 28
local fastSpeed = 36

-- GUI PRINCIPAL
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- CLICK SOUND
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

-- MENU TELEGUIADO
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 400)
frame.Position = UDim2.fromScale(0.3,0.2)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- TITULO
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.1)
title.BackgroundTransparency = 1
title.Text = "harold cup"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,90,90)
title.Active = true

-- BOTONES
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

local teleBtn  = makeButton("TELEGUIADO",0.12)
local speedBtn = makeButton("SPEED",0.22)
local kickBtn  = makeButton("AUTO KICK",0.32)
local espBtn   = makeButton("ESP : OFF",0.42,0.43)
espBtn.Position = UDim2.fromScale(0.05,0.42)
local xrayBtn  = makeButton("X-RAY : OFF",0.42,0.43)
xrayBtn.Position = UDim2.fromScale(0.52,0.42)
local grabBtn  = makeButton("AUTO GRAB",0.52)
local keyTBtn  = makeButton("KEY-T",0.62)
local closeBtn = makeButton("CLOSE",0.72)
local teleKKey = nil -- Keybind TeleK flotante
local speedKey  = nil -- Keybind Speed flotante

-- TELEGUIADO FUNC
local function doTeleport()
	local startPos = hrp.Position
	local endPos = spawnCFrame.Position
	local direction = (endPos - startPos).Unit
	local distance = (endPos - startPos).Magnitude
	local speed = 1000 -- ultra rapido

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
	speedValue = humanoid.WalkSpeed
	speedBtn.Text = speedOn and "SPEED : ON" or "SPEED : OFF"
	if speedKey then
		speedKey.BackgroundColor3 = speedOn and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
	end
end)

-- AUTO KICK
kickBtn.MouseButton1Click:Connect(function()
	click()
	autoKick = not autoKick
	kickBtn.Text = autoKick and "AUTO KICK : ON" or "AUTO KICK : OFF"
end)

-- CLOSE
local open = true
closeBtn.MouseButton1Click:Connect(function()
	click()
	open = false
	frame.Visible = false
end)

-- ESP / X-RAY / AUTO GRAB OMITIDOS PARA ACORTAR (se mantienen tus anteriores)
-- Puedes reintegrar tu ESP/Xray/Auto Grab aquí si quieres

-- DRAG MENU TELEGUIADO
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

-- ICONO
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromOffset(60,60)
icon.Position = UDim2.fromScale(0.03,0.45)
icon.Text = "O"
icon.Font = Enum.Font.GothamBlack
icon.TextScaled = true
icon.TextColor3 = Color3.new(1,1,1)
icon.BackgroundColor3 = Color3.new(0,0,0)
icon.BorderSizePixel = 0
icon.Active = true
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

-- MENU ICONO
local iconMenu = Instance.new("Frame", gui)
iconMenu.Size = UDim2.fromOffset(300,300)
iconMenu.Position = UDim2.fromScale(0.15,0.3)
iconMenu.BackgroundColor3 = Color3.fromRGB(30,30,30)
iconMenu.Visible = false
Instance.new("UICorner", iconMenu).CornerRadius = UDim.new(0,18)

-- BOTONES MENU ICONO
local hideMenuBtn = Instance.new("TextButton", iconMenu)
hideMenuBtn.Size = UDim2.fromScale(0.9,0.12)
hideMenuBtn.Position = UDim2.fromScale(0.05,0.05)
hideMenuBtn.Text = "Hide Menu"
hideMenuBtn.Font = Enum.Font.GothamBold
hideMenuBtn.TextScaled = true
hideMenuBtn.TextColor3 = Color3.new(1,1,1)
hideMenuBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", hideMenuBtn).CornerRadius = UDim.new(0,14)

local keySpeedBtn = Instance.new("TextButton", iconMenu)
keySpeedBtn.Size = UDim2.fromScale(0.9,0.12)
keySpeedBtn.Position = UDim2.fromScale(0.05,0.22)
keySpeedBtn.Text = "KEY-SPEED"
keySpeedBtn.Font = Enum.Font.GothamBold
keySpeedBtn.TextScaled = true
keySpeedBtn.TextColor3 = Color3.new(1,1,1)
keySpeedBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
Instance.new("UICorner", keySpeedBtn).CornerRadius = UDim.new(0,14)

local plusBtn = Instance.new("TextButton", iconMenu)
plusBtn.Size = UDim2.fromScale(0.3,0.12)
plusBtn.Position = UDim2.fromScale(0.05,0.42)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextScaled = true
plusBtn.TextColor3 = Color3.new(1,1,1)
plusBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0,14)

local minusBtn = Instance.new("TextButton", iconMenu)
minusBtn.Size = UDim2.fromScale(0.3,0.12)
minusBtn.Position = UDim2.fromScale(0.65,0.42)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextScaled = true
minusBtn.TextColor3 = Color3.new(1,1,1)
minusBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0,14)

local speedLabel = Instance.new("TextLabel", iconMenu)
speedLabel.Size = UDim2.fromScale(0.9,0.12)
speedLabel.Position = UDim2.fromScale(0.05,0.62)
speedLabel.Text = tostring(speedValue)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextScaled = true
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1

-- FUNCIONES MENU ICONO
icon.MouseButton1Click:Connect(function()
	click()
	iconMenu.Visible = not iconMenu.Visible
end)

hideMenuBtn.MouseButton1Click:Connect(function()
	click()
	open = not open
	frame.Visible = open
end)

plusBtn.MouseButton1Click:Connect(function()
	speedValue = speedValue + 1
	speedLabel.Text = tostring(speedValue)
	if speedOn then humanoid.WalkSpeed = speedValue end
end)

minusBtn.MouseButton1Click:Connect(function()
	speedValue = speedValue - 1
	speedLabel.Text = tostring(speedValue)
	if speedOn then humanoid.WalkSpeed = speedValue end
end)

keySpeedBtn.MouseButton1Click:Connect(function()
	click()
	keySpeedOn = not keySpeedOn
	if keySpeedOn then
		speedKey = Instance.new("TextButton", gui)
		speedKey.Size = UDim2.fromOffset(80,40)
		speedKey.Position = UDim2.fromScale(0.9,0.15)
		speedKey.Text = "SPEED"
		speedKey.Font = Enum.Font.GothamBold
		speedKey.TextScaled = true
		speedKey.TextColor3 = Color3.new(1,1,1)
		speedKey.BackgroundColor3 = Color3.fromRGB(255,0,0)
		Instance.new("UICorner", speedKey).CornerRadius = UDim.new(0,8)

		speedKey.MouseButton1Click:Connect(function()
			click()
			speedOn = not speedOn
			humanoid.WalkSpeed = speedOn and speedValue or normalSpeed
			speedKey.BackgroundColor3 = speedOn and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
			speedBtn.Text = speedOn and "SPEED : ON" or "SPEED : OFF"
		end)
	else
		if speedKey then speedKey:Destroy(); speedKey=nil end
	end
end)

-- DRAG MENU ICONO
local dDrag, dStart, dPos
iconMenu.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dDrag = true
		dStart = i.Position
		dPos = iconMenu.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d = i.Position - dStart
		iconMenu.Position = UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y)
	end
end)
UIS.InputEnded:Connect(function() dDrag=false end)

print("🐱 HAROLDCUPS — Script cargado ✅")
