--// HAROLDCUPS - CAT HUB REVISADO

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
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- SONIDO CLICK
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

--------------------------------------------------
-- FRAME PRINCIPAL (ESTILO |    |)
--------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.2,0.6) -- estrecho y alto
frame.Position = UDim2.fromScale(0.4,0.2) -- centrado
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

--------------------------------------------------
-- TITULO
--------------------------------------------------
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.12)
title.Position = UDim2.fromScale(0,0)
title.BackgroundTransparency = 1
title.Text = "HAROLDCUPS"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,90,90)
title.Active = true

--------------------------------------------------
-- FUNCION CREAR BOTONES
--------------------------------------------------
local function makeButton(text,posY)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9,0.09)
	b.Position = UDim2.fromScale(0.05,posY)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextSize = 28
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	return b
end

--------------------------------------------------
-- BOTONES PRINCIPALES (SEPARADOS)
--------------------------------------------------
local teleBtn  = makeButton("TELEGUIADO",0.12)
local speedBtn = makeButton("SPEED : OFF",0.25)
local kickBtn  = makeButton("AUTO KICK : OFF",0.38)

local espBtn   = makeButton("ESP : OFF",0.51)
local xrayBtn  = makeButton("X-RAY : OFF",0.51)
xrayBtn.Position = UDim2.fromScale(0.52,0.51)

local grabBtn  = makeButton("AUTO GRAB : OFF",0.64)
local keybindBtn = makeButton("KEYBIND-T",0.77)
local closeBtn = makeButton("CLOSE",0.9)

--------------------------------------------------
-- TELEGUIADO FUNCION
--------------------------------------------------
local function doTeleport()
	local startPos = hrp.Position
	local endPos = spawnCFrame.Position
	local direction = (endPos - startPos).Unit
	local distance = (endPos - startPos).Magnitude
	local speed = 300 -- ultra rapido

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
-- SPEED FUNCION
--------------------------------------------------
speedBtn.MouseButton1Click:Connect(function()
	click()
	speedOn = not speedOn
	humanoid.WalkSpeed = speedOn and fastSpeed or normalSpeed
	currentSpeed = humanoid.WalkSpeed
	speedBtn.Text = speedOn and "SPEED : ON" or "SPEED : OFF"
end)

--------------------------------------------------
-- AUTO KICK FUNCION
--------------------------------------------------
kickBtn.MouseButton1Click:Connect(function()
	click()
	autoKick = not autoKick
	kickBtn.Text = autoKick and "AUTO KICK : ON" or "AUTO KICK : OFF"
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
-- ESP FUNCION
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

--------------------------------------------------
-- X-RAY FUNCION
--------------------------------------------------
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
-- AUTO GRAB FUNCION
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
-- DRAG MENU PRINCIPAL
--------------------------------------------------
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

--------------------------------------------------
-- ICONO PEQUEÑO (MOVIBLE)
--------------------------------------------------
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromScale(0.08,0.08)
icon.Position = UDim2.fromScale(0.03,0.45)
icon.Text = "O"
icon.Font = Enum.Font.GothamBlack
icon.TextScaled = true
icon.TextColor3 = Color3.new(1,1,1)
icon.BackgroundColor3 = Color3.fromRGB(0,0,0)
icon.BorderSizePixel = 0
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

local iconMenu = Instance.new("Frame", gui)
iconMenu.Size = UDim2.fromScale(0.2,0.25)
iconMenu.Position = UDim2.fromScale(0.05,0.3)
iconMenu.BackgroundColor3 = Color3.fromRGB(25,25,25)
iconMenu.Visible = false
Instance.new("UICorner", iconMenu).CornerRadius = UDim.new(0,16)

-- BOTONES ICONO
local hideBtn = Instance.new("TextButton", iconMenu)
hideBtn.Size = UDim2.fromScale(0.9,0.15)
hideBtn.Position = UDim2.fromScale(0.05,0.05)
hideBtn.Text = "HIDE MENU"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextScaled = true
hideBtn.TextSize = 26
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0,12)

local speedFrame = Instance.new("Frame", iconMenu)
speedFrame.Size = UDim2.fromScale(0.9,0.35)
speedFrame.Position = UDim2.fromScale(0.05,0.25)
speedFrame.BackgroundTransparency = 1

local minusBtn = Instance.new("TextButton", speedFrame)
minusBtn.Size = UDim2.fromScale(0.3,0.25)
minusBtn.Position = UDim2.fromScale(0,0)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextScaled = true
minusBtn.TextSize = 26
minusBtn.TextColor3 = Color3.new(1,1,1)
minusBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0,12)

local plusBtn = Instance.new("TextButton", speedFrame)
plusBtn.Size = UDim2.fromScale(0.3,0.25)
plusBtn.Position = UDim2.fromScale(0.65,0)
plusBtn.Text = "+"
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextScaled = true
plusBtn.TextSize = 26
plusBtn.TextColor3 = Color3.new(1,1,1)
plusBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0,12)

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.fromScale(1,0.25)
speedLabel.Position = UDim2.fromScale(0,0.35)
speedLabel.Text = tostring(currentSpeed)
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextScaled = true
speedLabel.BackgroundTransparency = 1

-- DRAG ICONO
local dI,dS,dP
icon.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dI = true
		dS = i.Position
		dP = icon.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dI and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local delta = i.Position - dS
		icon.Position = UDim2.new(dP.X.Scale,dP.X.Offset+delta.X,dP.Y.Scale,dP.Y.Offset+delta.Y)
	end
end)

UIS.InputEnded:Connect(function() dI = false end)

-- BOTONES ICONO FUNCIONES
icon.MouseButton1Click:Connect(function()
	click()
	iconMenu.Visible = not iconMenu.Visible
end)

hideBtn.MouseButton1Click:Connect(function()
	click()
	frame.Visible = not frame.Visible
end)

plusBtn.MouseButton1Click:Connect(function()
	click()
	currentSpeed = currentSpeed + 1
	speedLabel.Text = tostring(currentSpeed)
	if speedOn then humanoid.WalkSpeed = currentSpeed end
end)

minusBtn.MouseButton1Click:Connect(function()
	click()
	currentSpeed = currentSpeed - 1
	if currentSpeed < 0 then currentSpeed = 0 end
	speedLabel.Text = tostring(currentSpeed)
	if speedOn then humanoid.WalkSpeed = currentSpeed end
end)

-- TELE-K (FIJO ARRIBA DERECHA)
local teleK = Instance.new("TextButton", gui)
teleK.Size = UDim2.fromScale(0.08,0.08)
teleK.Position = UDim2.fromScale(0.85,0.05)
teleK.BackgroundColor3 = Color3.fromRGB(255,0,0)
teleK.Text = "T"
teleK.Font = Enum.Font.GothamBlack
teleK.TextScaled = true
teleK.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", teleK).CornerRadius = UDim.new(0,8)
teleK.Active = true
teleK.Visible = false

keybindBtn.MouseButton1Click:Connect(function()
	click()
	teleK.Visible = not teleK.Visible
end)

teleK.MouseButton1Click:Connect(function()
	click()
	doTeleport()
end)

print("✅ HAROLDCUPS listo, menus movibles, botones grandes, TELE-K fijo y velocidad sincronizada")
