--// HAROLDCUPS - SCRIPT COMPLETO

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
local currentSpeed = 28

local normalSpeed = 28
local fastSpeed = 36

--------------------------------------------------
-- GUI PRINCIPAL
--------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- Sonido click
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

--------------------------------------------------
-- FRAME TELEGUIADO
--------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 420) -- grande y cuadrado
frame.Position = UDim2.fromScale(0.3,0.2)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- Titulo
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.12)
title.BackgroundTransparency = 1
title.Text = "HAROLDCUPS"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,90,90)
title.Active = true

-- Boton maker
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

-- Botones TELEGUIADO
local teleBtn  = makeButton("TELEGUIADO",0.14)
local speedBtn = makeButton("SPEED : OFF",0.25)
local kickBtn  = makeButton("AUTO KICK : OFF",0.36)

local espBtn = makeButton("ESP : OFF",0.47,0.43)
espBtn.Position = UDim2.fromScale(0.05,0.47)
local xrayBtn = makeButton("X-RAY : OFF",0.47,0.43)
xrayBtn.Position = UDim2.fromScale(0.52,0.47)

local grabBtn = makeButton("AUTO GRAB : OFF",0.59)
local keyBindBtn = makeButton("KEYBIND-T",0.7)
local closeBtn = makeButton("CLOSE",0.81)

--------------------------------------------------
-- TELEGUIADO FUNCTION
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
		local newPos = startPos + direction * math.min(travelled, distance)
		hrp.CFrame = CFrame.new(newPos, endPos)
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
-- ESP / X-RAY / AUTO GRAB
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
	xrayBtn.Text = xrayOn and "X-RAY : ON" or "X-RAY : OFF"
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v:IsDescendantOf(char) then
			if not v.Name:lower():find("floor") then
				v.LocalTransparencyModifier = xrayOn and 0.6 or 0
			end
		end
	end
end)

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
-- CERRAR MENU
--------------------------------------------------
local open = true
closeBtn.MouseButton1Click:Connect(function()
	click()
	open = false
	frame.Visible = false
end)

--------------------------------------------------
-- ICONO PEQUEÑO MOVIBLE
--------------------------------------------------
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromOffset(50,50)
icon.Position = UDim2.fromScale(0.03,0.45)
icon.Text = "O"
icon.Font = Enum.Font.GothamBlack
icon.TextScaled = true
icon.TextColor3 = Color3.new(1,1,1)
icon.BackgroundColor3 = Color3.new(0,0,0)
icon.BorderSizePixel = 0
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

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
	end
end)
UIS.InputEnded:Connect(function() dI = false end)

--------------------------------------------------
-- MENU DEL ICONO
--------------------------------------------------
local iconMenu = Instance.new("Frame", gui)
iconMenu.Size = UDim2.fromOffset(300,250)
iconMenu.Position = UDim2.fromScale(0.2,0.3)
iconMenu.BackgroundColor3 = Color3.fromRGB(25,25,25)
iconMenu.BorderSizePixel = 0
Instance.new("UICorner", iconMenu).CornerRadius = UDim.new(0,18)
iconMenu.Visible = false

-- DRAG iconMenu
local dragM, startM, posM
iconMenu.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragM = true
		startM = i.Position
		posM = iconMenu.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragM and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local d = i.Position - startM
		iconMenu.Position = UDim2.new(posM.X.Scale,posM.X.Offset+d.X,posM.Y.Scale,posM.Y.Offset+d.Y)
	end
end)
UIS.InputEnded:Connect(function() dragM = false end)

-- BOTONES MENU ICONO
local hideBtn = Instance.new("TextButton", iconMenu)
hideBtn.Size = UDim2.fromScale(0.9,0.12)
hideBtn.Position = UDim2.fromScale(0.05,0.05)
hideBtn.Text = "Hide Menu"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextScaled = true
hideBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
hideBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0,14)

hideBtn.MouseButton1Click:Connect(function()
	click()
	open = not open
	frame.Visible = open
end)

-- KEYBIND SPEED
local keySpeedBtn = Instance.new("TextButton", iconMenu)
keySpeedBtn.Size = UDim2.fromScale(0.9,0.12)
keySpeedBtn.Position = UDim2.fromScale(0.05,0.20)
keySpeedBtn.Text = "KEY-SPEED"
keySpeedBtn.Font = Enum.Font.GothamBold
keySpeedBtn.TextScaled = true
keySpeedBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
keySpeedBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", keySpeedBtn).CornerRadius = UDim.new(0,14)

local speedValue = Instance.new("TextLabel", iconMenu)
speedValue.Size = UDim2.fromScale(0.9,0.12)
speedValue.Position = UDim2.fromScale(0.05,0.35)
speedValue.Text = tostring(currentSpeed)
speedValue.Font = Enum.Font.GothamBold
speedValue.TextScaled = true
speedValue.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedValue.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedValue).CornerRadius = UDim.new(0,14)

local plusBtn = Instance.new("TextButton", iconMenu)
plusBtn.Size = UDim2.fromScale(0.43,0.12)
plusBtn.Position = UDim2.fromScale(0.05,0.5)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextScaled = true
plusBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
plusBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0,14)

local minusBtn = Instance.new("TextButton", iconMenu)
minusBtn.Size = UDim2.fromScale(0.43,0.12)
minusBtn.Position = UDim2.fromScale(0.52,0.5)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextScaled = true
minusBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
minusBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0,14)

-- FUNCIONES BOTONES
icon.MouseButton1Click:Connect(function()
	click()
	iconMenu.Visible = not iconMenu.Visible
end)

plusBtn.MouseButton1Click:Connect(function()
	click()
	currentSpeed = currentSpeed + 1
	speedValue.Text = tostring(currentSpeed)
	if speedOn then humanoid.WalkSpeed = currentSpeed end
end)

minusBtn.MouseButton1Click:Connect(function()
	click()
	currentSpeed = currentSpeed - 1
	speedValue.Text = tostring(currentSpeed)
	if speedOn then humanoid.WalkSpeed = currentSpeed end
end)

keySpeedBtn.MouseButton1Click:Connect(function()
	click()
	speedOn = not speedOn
	humanoid.WalkSpeed = speedOn and currentSpeed or normalSpeed
	speedBtn.Text = speedOn and "SPEED : ON" or "SPEED : OFF"
	keySpeedBtn.BackgroundColor3 = speedOn and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end)

print("🐱 HAROLDCUPS — Todo listo, TELE-K, SPEED, ICONO y MENUS MOVIBLES ✅")
