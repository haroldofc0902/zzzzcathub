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
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

--------------------------------------------------
-- MENU PRINCIPAL
--------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.38,0.65)
frame.Position = UDim2.fromScale(0.31,0.2)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.12)
title.BackgroundTransparency = 1
title.Text = "HAROLDCUPS"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,90,90)
title.Active = true

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

-- BOTONES PRINCIPALES
local teleBtn  = makeButton("TELEGUIADO",0.15)
local speedBtn = makeButton("SPEED : OFF",0.26)
local kickBtn  = makeButton("AUTO KICK : OFF",0.37)

local espBtn = makeButton("ESP : OFF",0.48,0.43)
espBtn.Position = UDim2.fromScale(0.05,0.48)

local xrayBtn = makeButton("X-RAY : OFF",0.48,0.43)
xrayBtn.Position = UDim2.fromScale(0.52,0.48)

local teleKBtn = makeButton("TELE-K",0.59,0.3)
teleKBtn.Position = UDim2.fromScale(0.35,0.59)
teleKBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)

local closeBtn = makeButton("CLOSE",0.70)

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
		local dt = RunService.Heartbeat:Wait()
		local step = speed * dt
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
-- CLOSE
--------------------------------------------------
local open = true
closeBtn.MouseButton1Click:Connect(function()
	click()
	open = false
	frame.Visible = false
end)

--------------------------------------------------
-- ESP / X-RAY
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

--------------------------------------------------
-- TELE-K BUTTON (FIJO)
--------------------------------------------------
teleKBtn.MouseButton1Click:Connect(function()
	click()
	doTeleport()
end)

--------------------------------------------------
-- MENU ICONO
--------------------------------------------------
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

local iconFrame = Instance.new("Frame", gui)
iconFrame.Size = UDim2.fromScale(0.38,0.65)
iconFrame.Position = UDim2.fromScale(0.45,0.2)
iconFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", iconFrame).CornerRadius = UDim.new(0,18)
iconFrame.Visible = false

-- DRAG ICONO
local dragging, dragStart, startPos
icon.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = i.Position
		startPos = icon.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local delta = i.Position - dragStart
		icon.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
	end
end)

UIS.InputEnded:Connect(function() dragging = false end)

-- BOTONES MENU ICONO
local hideBtn = Instance.new("TextButton", iconFrame)
hideBtn.Size = UDim2.fromScale(0.9,0.09)
hideBtn.Position = UDim2.fromScale(0.05,0.12)
hideBtn.Text = "HIDE MENU"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextScaled = true
hideBtn.TextSize = 28
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
hideBtn.BorderSizePixel = 0
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0,14)

local keySpeedBtn = Instance.new("TextButton", iconFrame)
keySpeedBtn.Size = UDim2.fromScale(0.3,0.08)
keySpeedBtn.Position = UDim2.fromScale(0.35,0.23)
keySpeedBtn.Text = "SPEED"
keySpeedBtn.Font = Enum.Font.GothamBlack
keySpeedBtn.TextScaled = true
keySpeedBtn.TextColor3 = Color3.fromRGB(255,0,0)
keySpeedBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
keySpeedBtn.BorderSizePixel = 0
Instance.new("UICorner", keySpeedBtn).CornerRadius = UDim.new(0,10)

local plusBtn = Instance.new("TextButton", iconFrame)
plusBtn.Size = UDim2.fromScale(0.13,0.07)
plusBtn.Position = UDim2.fromScale(0.1,0.38)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextScaled = true
plusBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
plusBtn.BorderSizePixel = 0
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0,10)

local minusBtn = Instance.new("TextButton", iconFrame)
minusBtn.Size = UDim2.fromScale(0.13,0.07)
minusBtn.Position = UDim2.fromScale(0.77,0.38)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextScaled = true
minusBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
minusBtn.BorderSizePixel = 0
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0,10)

local speedLabel = Instance.new("TextLabel", iconFrame)
speedLabel.Size = UDim2.fromScale(0.9,0.07)
speedLabel.Position = UDim2.fromScale(0.05,0.50)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextScaled = true
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Text = tostring(currentSpeed)

-- FUNCIONES BOTONES ICONO
icon.MouseButton1Click:Connect(function()
	click()
	iconFrame.Visible = not iconFrame.Visible
end)

hideBtn.MouseButton1Click:Connect(function()
	click()
	frame.Visible = not frame.Visible
end)

keySpeedBtn.MouseButton1Click:Connect(function()
	click()
	if keySpeedBtn.BackgroundColor3 == Color3.fromRGB(255,0,0) then
		keySpeedBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
		currentSpeed = humanoid.WalkSpeed
	else
		keySpeedBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
		currentSpeed = humanoid.WalkSpeed
	end
end)

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

RunService.Heartbeat:Connect(function()
	if speedOn then humanoid.WalkSpeed = currentSpeed end
end)

print("🐱 HAROLDCUPS — Script completo listo, con menú icono movible y SPEED sincronizado 🚀")
