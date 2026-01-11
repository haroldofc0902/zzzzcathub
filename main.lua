--// HAROLDCUPS FINAL

-- SERVICIOS
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

local defaultSpeed = 28
local speedValue = 36 -- velocidad inicial al activar SPEED

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- SONIDO CLICK
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

-- FRAME PRINCIPAL
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.38,0.62)
frame.Position = UDim2.fromScale(0.31,0.2)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- TITULO
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.12)
title.BackgroundTransparency = 1
title.Text = "HAROLD CUPS"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,90,90)
title.Active = true

-- CREAR BOTONES
local function makeButton(text,posY,width)
	local b = Instance.new("TextButton",frame)
	b.Size = UDim2.fromScale(width or 0.9,0.12)
	b.Position = UDim2.fromScale(0.05,posY)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextSize = 32
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,14)
	return b
end

-- BOTONES PRINCIPALES (LETRAS GRANDES Y MÁS ABAJO)
local teleBtn  = makeButton("TELEGUIADO",0.18)
local speedBtn = makeButton("SPEED : OFF",0.3)
local kickBtn  = makeButton("AUTO KICK : OFF",0.42)
local espBtn   = makeButton("ESP : OFF",0.54,0.43)
espBtn.Position = UDim2.fromScale(0.05,0.54)
local xrayBtn  = makeButton("X-RAY : OFF",0.54,0.43)
xrayBtn.Position = UDim2.fromScale(0.52,0.54)
local grabBtn  = makeButton("AUTO GRAB : OFF",0.66)
local closeBtn = makeButton("CLOSE",0.78)
local teleKBtn = makeButton("TELE-K",0.9)
teleKBtn.BackgroundColor3 = Color3.fromRGB(255,50,50) -- rojo
teleKBtn.TextColor3 = Color3.new(1,1,1)

-- FUNCION TELEGUIADO VOLANDO
local function doTeleport(targetCFrame)
	local startPos = hrp.Position
	local endPos = targetCFrame.Position
	local direction = (endPos - startPos).Unit
	local distance = (endPos - startPos).Magnitude
	local speed = 300 -- ultra rápido

	local travelled = 0
	while travelled < distance do
		RunService.Heartbeat:Wait()
		local step = speed * RunService.Heartbeat:Wait()
		travelled = travelled + step
		local newPos = startPos + direction * math.min(travelled,distance)
		hrp.CFrame = CFrame.new(newPos,endPos)
	end
	hrp.CFrame = targetCFrame
end

teleBtn.MouseButton1Click:Connect(function()
	click()
	doTeleport(spawnCFrame)
end)

-- SPEED
speedBtn.MouseButton1Click:Connect(function()
	click()
	speedOn = not speedOn
	humanoid.WalkSpeed = speedOn and speedValue or defaultSpeed
	speedBtn.Text = speedOn and "SPEED : ON" or "SPEED : OFF"
end)

-- AUTO KICK
kickBtn.MouseButton1Click:Connect(function()
	click()
	autoKick = not autoKick
	kickBtn.Text = autoKick and "AUTO KICK : ON" or "AUTO KICK : OFF"
end)

-- CERRAR MENU
local open = true
closeBtn.MouseButton1Click:Connect(function()
	click()
	open=false
	frame.Visible=false
end)

-- ESP
local espObjs = {}
local function clearESP()
	for _,v in pairs(espObjs) do if v then v:Destroy() end end
	table.clear(espObjs)
end
local function createESP(plr,color)
	if not plr.Character or not plr.Character:FindFirstChild("Head") then return end
	local bb = Instance.new("BillboardGui",gui)
	bb.Adornee = plr.Character.Head
	bb.Size = UDim2.new(0,260,0,45)
	bb.AlwaysOnTop=true

	local t = Instance.new("TextLabel",bb)
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency=1
	t.Text=plr.Name
	t.Font=Enum.Font.GothamBlack
	t.TextScaled=true
	t.TextColor3=color
	t.TextStrokeTransparency=0

	table.insert(espObjs,bb)
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

-- X-RAY
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

-- AUTO GRAB
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
						v.HoldDuration=0
						v:InputHoldBegin()
					end)
				end
			end
		end
	end
end)

-- DRAG MENU PRINCIPAL
local dragging,dragStart,startPos
title.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dragging=true
		dragStart=i.Position
		startPos=frame.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-dragStart
		frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
	end
end)
UIS.InputEnded:Connect(function() dragging=false end)

-- ICONO CIRCULAR
local icon = Instance.new("TextButton",gui)
icon.Size = UDim2.fromScale(0.12,0.12)
icon.Position = UDim2.fromScale(0.03,0.45)
icon.Text = "O"
icon.Font = Enum.Font.GothamBlack
icon.TextScaled=true
icon.TextColor3=Color3.new(1,1,1)
icon.BackgroundColor3=Color3.new(0,0,0)
icon.BorderSizePixel=0
icon.Active=true
Instance.new("UICorner",icon).CornerRadius=UDim.new(1,0)

-- MENU ICONO
local iconMenu = Instance.new("Frame",gui)
iconMenu.Size=UDim2.fromScale(0.45,0.45)
iconMenu.Position=UDim2.fromScale(0.05,0.55)
iconMenu.BackgroundColor3=Color3.fromRGB(30,30,30)
iconMenu.Visible=false
Instance.new("UICorner",iconMenu).CornerRadius=UDim.new(0,18)

-- HIDE MENU
local hideBtn = Instance.new("TextButton",iconMenu)
hideBtn.Size=UDim2.fromScale(0.9,0.3)
hideBtn.Position=UDim2.fromScale(0.05,0.05)
hideBtn.Text="HIDE MENU"
hideBtn.Font=Enum.Font.GothamBold
hideBtn.TextScaled=true
hideBtn.TextColor3=Color3.new(1,1,1)
hideBtn.BackgroundColor3=Color3.fromRGB(50,50,50)
Instance.new("UICorner",hideBtn).CornerRadius=UDim.new(0,12)
hideBtn.MouseButton1Click:Connect(function()
	click()
	open = not open
	frame.Visible = open
end)

-- VELOCIDAD
local speedLabel = Instance.new("TextLabel",iconMenu)
speedLabel.Size=UDim2.fromScale(0.9,0.2)
speedLabel.Position=UDim2.fromScale(0.05,0.4)
speedLabel.Text=tostring(speedValue)
speedLabel.TextScaled=true
speedLabel.TextColor3=Color3.new(1,1,1)
speedLabel.BackgroundTransparency=1
speedLabel.Font=Enum.Font.GothamBold
speedLabel.TextStrokeTransparency=0

-- BOTONES + Y -
local plusBtn = Instance.new("TextButton",iconMenu)
plusBtn.Size=UDim2.fromScale(0.4,0.2)
plusBtn.Position=UDim2.fromScale(0.05,0.7)
plusBtn.Text="+"
plusBtn.Font=Enum.Font.GothamBold
plusBtn.TextScaled=true
plusBtn.TextColor3=Color3.new(1,1,1)
plusBtn.BackgroundColor3=Color3.fromRGB(50,50,50)
Instance.new("UICorner",plusBtn).CornerRadius=UDim.new(0,12)

local minusBtn = Instance.new("TextButton",iconMenu)
minusBtn.Size=UDim2.fromScale(0.4,0.2)
minusBtn.Position=UDim2.fromScale(0.55,0.7)
minusBtn.Text="-"
minusBtn.Font=Enum.Font.GothamBold
minusBtn.TextScaled=true
minusBtn.TextColor3=Color3.new(1,1,1)
minusBtn.BackgroundColor3=Color3.fromRGB(50,50,50)
Instance.new("UICorner",minusBtn).CornerRadius=UDim.new(0,12)

-- FUNCIONES + Y -
plusBtn.MouseButton1Click:Connect(function()
	speedValue = speedValue + 1
	speedLabel.Text = tostring(speedValue)
	if speedOn then humanoid.WalkSpeed = speedValue end
	click()
end)
minusBtn.MouseButton1Click:Connect(function()
	speedValue = speedValue - 1
	speedLabel.Text = tostring(speedValue)
	if speedOn then humanoid.WalkSpeed = speedValue end
	click()
end)

-- MOSTRAR MENU ICONO
icon.MouseButton1Click:Connect(function()
	click()
	iconMenu.Visible = not iconMenu.Visible
end)

-- DRAG ICONO
local dI,dStart,dPos
icon.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		dI=true
		dStart=i.Position
		dPos=icon.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if dI and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-dStart
		icon.Position=UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y)
	end
end)
UIS.InputEnded:Connect(function() dI=false end)

-- TELE-K FIJO
teleKBtn.Position=UDim2.fromScale(0.78,0.02)
teleKBtn.MouseButton1Click:Connect(function()
	click()
	doTeleport(spawnCFrame)
end)

print("✅ HAROLDCUPS — Menu final listo, todo alineado, botones grandes, TELE-K rojo fijo, SPEED sincronizado con icono.")
