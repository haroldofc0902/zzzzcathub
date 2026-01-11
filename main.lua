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

--------------------------------------------------
-- ESTADOS
--------------------------------------------------
local speedOn = false
local autoKick = false
local espOn = false
local xrayOn = false
local grabOn = false

local normalSpeed = 28
local fastSpeed = 36
local currentSpeed = normalSpeed

--------------------------------------------------
-- GUI PRINCIPAL
--------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

--------------------------------------------------
-- MENU HAROLD CUP
--------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260, 400)
frame.Position = UDim2.fromScale(0.35,0.2)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.08)
title.Position = UDim2.fromScale(0,0)
title.BackgroundTransparency = 1
title.Text = "harold cup"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,90,90)

local function makeButton(text, posY, width)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(width or 0.9,0.1)
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

-- BOTONES MENU HAROLD CUP
local teleBtn  = makeButton("TELEGUIADO",0.12)
local speedBtn = makeButton("SPEED",0.22)
local kickBtn  = makeButton("AUTO KICK",0.32)
local espBtn   = makeButton("ESP : OFF",0.42,0.43)
local xrayBtn  = makeButton("X-RAY : OFF",0.42,0.43)
xrayBtn.Position = UDim2.fromScale(0.52,0.42)
local grabBtn  = makeButton("AUTO GRAB",0.52)
local keyTBtn  = makeButton("KEY-T",0.62)
local closeBtn = makeButton("CLOSE",0.72)

--------------------------------------------------
-- TELEGUIADO
--------------------------------------------------
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

--------------------------------------------------
-- SPEED
--------------------------------------------------
speedBtn.MouseButton1Click:Connect(function()
	click()
	speedOn = not speedOn
	humanoid.WalkSpeed = speedOn and fastSpeed or normalSpeed
	currentSpeed = humanoid.WalkSpeed
end)

--------------------------------------------------
-- AUTO KICK
--------------------------------------------------
kickBtn.MouseButton1Click:Connect(function()
	click()
	autoKick = not autoKick
end)

--------------------------------------------------
-- ESP/X-RAY
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
	bb.Size = UDim2.new(0,150,0,35)
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

--------------------------------------------------
-- AUTO GRAB
--------------------------------------------------
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

--------------------------------------------------
-- CLOSE BUTTON
--------------------------------------------------
closeBtn.MouseButton1Click:Connect(function()
	click()
	frame.Visible = false
end)

--------------------------------------------------
-- ICONO MOVIBLE
--------------------------------------------------
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromScale(0.08,0.08)
icon.Position = UDim2.fromScale(0.02,0.4)
icon.Text = "O"
icon.Font = Enum.Font.GothamBlack
icon.TextScaled = true
icon.TextColor3 = Color3.new(1,1,1)
icon.BackgroundColor3 = Color3.new(0,0,0)
icon.BorderSizePixel = 0
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

local iconMenu = Instance.new("Frame", gui)
iconMenu.Size = UDim2.fromOffset(260,300)
iconMenu.Position = UDim2.fromScale(0.3,0.5)
iconMenu.BackgroundColor3 = Color3.fromRGB(30,30,30)
iconMenu.Visible = false
Instance.new("UICorner", iconMenu).CornerRadius = UDim.new(0,18)

local hideMenuBtn = Instance.new("TextButton", iconMenu)
hideMenuBtn.Size = UDim2.fromScale(0.9,0.12)
hideMenuBtn.Position = UDim2.fromScale(0.05,0.05)
hideMenuBtn.Text = "Hide menu"
hideMenuBtn.Font = Enum.Font.GothamBold
hideMenuBtn.TextScaled = true
hideMenuBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
hideMenuBtn.BorderSizePixel = 0
Instance.new("UICorner", hideMenuBtn).CornerRadius = UDim.new(0,14)

local keySpeedBtn = Instance.new("TextButton", iconMenu)
keySpeedBtn.Size = UDim2.fromScale(0.9,0.12)
keySpeedBtn.Position = UDim2.fromScale(0.05,0.22)
keySpeedBtn.Text = "KEY-SPEED"
keySpeedBtn.Font = Enum.Font.GothamBold
keySpeedBtn.TextScaled = true
keySpeedBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
keySpeedBtn.BorderSizePixel = 0
Instance.new("UICorner", keySpeedBtn).CornerRadius = UDim.new(0,14)

local plusBtn = Instance.new("TextButton", iconMenu)
plusBtn.Size = UDim2.fromScale(0.4,0.12)
plusBtn.Position = UDim2.fromScale(0.05,0.42)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextScaled = true
plusBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
plusBtn.BorderSizePixel = 0
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0,14)

local minusBtn = Instance.new("TextButton", iconMenu)
minusBtn.Size = UDim2.fromScale(0.4,0.12)
minusBtn.Position = UDim2.fromScale(0.55,0.42)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextScaled = true
minusBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
minusBtn.BorderSizePixel = 0
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0,14)

local speedLabel = Instance.new("TextLabel", iconMenu)
speedLabel.Size = UDim2.fromScale(0.9,0.12)
speedLabel.Position = UDim2.fromScale(0.05,0.6)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = tostring(normalSpeed)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextScaled = true
speedLabel.TextColor3 = Color3.new(1,1,1)

-- ICONO ABRIR MENU
icon.MouseButton1Click:Connect(function()
	click()
	iconMenu.Visible = not iconMenu.Visible
end)

-- DRAG ICONO
local draggingIcon, startPosIcon, iconStart
icon.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingIcon = true
		startPosIcon = input.Position
		iconStart = icon.Position
	end
end)
UIS.InputChanged:Connect(function(input)
	if draggingIcon and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - startPosIcon
		icon.Position = UDim2.new(iconStart.X.Scale, iconStart.X.Offset+delta.X, iconStart.Y.Scale, iconStart.Y.Offset+delta.Y)
	end
end)
UIS.InputEnded:Connect(function() draggingIcon = false end)

-- DRAG MENU HAROLD CUP
local draggingMenu, startPosMenu, menuStart
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMenu = true
		startPosMenu = input.Position
		menuStart = frame.Position
	end
end)
UIS.InputChanged:Connect(function(input)
	if draggingMenu and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - startPosMenu
		frame.Position = UDim2.new(menuStart.X.Scale, menuStart.X.Offset+delta.X, menuStart.Y.Scale, menuStart.Y.Offset+delta.Y)
	end
end)
UIS.InputEnded:Connect(function() draggingMenu = false end)

-- FUNCIONALIDAD HIDE MENU
hideMenuBtn.MouseButton1Click:Connect(function()
	click()
	frame.Visible = not frame.Visible
end)

-- FUNCIONALIDAD KEY SPEED
local keySpeedActive = false
local keySpeedFlotante
keySpeedBtn.MouseButton1Click:Connect(function()
	click()
	keySpeedActive = not keySpeedActive
	keySpeedBtn.BackgroundColor3 = keySpeedActive and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)

	if keySpeedActive then
		if not keySpeedFlotante then
			keySpeedFlotante = Instance.new("TextButton", gui)
			keySpeedFlotante.Size = UDim2.fromScale(0.08,0.08)
			keySpeedFlotante.Position = UDim2.fromScale(0.9,0.05)
			keySpeedFlotante.Text = "SPEED"
			keySpeedFlotante.Font = Enum.Font.GothamBlack
			keySpeedFlotante.TextScaled = true
			keySpeedFlotante.TextColor3 = Color3.new(1,1,1)
			keySpeedFlotante.BackgroundColor3 = Color3.fromRGB(200,0,0)
			keySpeedFlotante.BorderSizePixel = 0
			keySpeedFlotante.Active = true
			Instance.new("UICorner", keySpeedFlotante).CornerRadius = UDim.new(0,12)

			keySpeedFlotante.MouseButton1Click:Connect(function()
				click()
				speedOn = not speedOn
				humanoid.WalkSpeed = speedOn and currentSpeed or normalSpeed
				keySpeedFlotante.BackgroundColor3 = speedOn and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
			end)
		end
	end
	if not keySpeedActive and keySpeedFlotante then
		keySpeedFlotante:Destroy()
		keySpeedFlotante = nil
	end
end)

-- SUBIDOR / BAJADOR DE VELOCIDAD
plusBtn.MouseButton1Click:Connect(function()
	currentSpeed = currentSpeed + 1
	speedLabel.Text = tostring(currentSpeed)
	if speedOn then humanoid.WalkSpeed = currentSpeed end
end)
minusBtn.MouseButton1Click:Connect(function()
	currentSpeed = currentSpeed - 1
	speedLabel.Text = tostring(currentSpeed)
	if speedOn then humanoid.WalkSpeed = currentSpeed end
end)

print("🐱 HAROLD CUP — Listo con TELEGUIADO, SPEED, AUTO KICK, ESP/X-RAY, AUTO GRAB, KEY-T y KEY-SPEED 🚀")
