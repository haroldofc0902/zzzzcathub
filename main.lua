--// HAROLDCUPS - CAT HUB FINAL

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
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
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
local unwalkOn = false
local teleKOn = false

local normalSpeed = 28
local fastSpeed = 35

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
title.Text = "HAROLDCUPS"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,90,90)
title.Active = true

--------------------------------------------------
-- CREAR BOTONES
--------------------------------------------------
local function makeButton(text,posY,width)
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
-- BOTONES (ORDEN EXACTO)
--------------------------------------------------
local teleBtn  = makeButton("TELEGUIADO",0.05)
local speedBtn = makeButton("SPEED : OFF",0.16)
local kickBtn  = makeButton("AUTO KICK : OFF",0.27)

local espBtn = makeButton("ESP : OFF",0.38,0.43)
espBtn.Position = UDim2.fromScale(0.05,0.38)
local xrayBtn = makeButton("X-RAY : OFF",0.38,0.43)
xrayBtn.Position = UDim2.fromScale(0.52,0.38)

local grabBtn = makeButton("AUTO GRAB : OFF",0.49)
local teleKBtn = makeButton("TELE-K",0.60)
local closeBtn = makeButton("CLOSE",0.71)

--------------------------------------------------
-- TELEGUIADO (VOLANDO RAPIDO)
--------------------------------------------------
local function doTeleport()
	local startPos = hrp.Position
	local endPos = spawnCFrame.Position
	local direction = (endPos - startPos).Unit
	local distance = (endPos - startPos).Magnitude
	local speed = 300 -- unidades por segundo

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
	bb.Size = UDim2.new(0,200,0,40)
	bb.AlwaysOnTop = true

	local t = Instance.new("TextLabel", bb)
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency = 1
	t.Text = plr.Name
	t.Font = Enum.Font.GothamBlack
	t.TextScaled = true
	t.TextColor3 = color
	t.TextStrokeTransparency = 0

	-- Hitbox
	for _,part in pairs(plr.Character:GetChildren()) do
		if part:IsA("BasePart") then
			part.LocalTransparencyModifier = 0.6
			part.Color = color
			part.Material = Enum.Material.Neon
			part.Size = part.Size * 1.2
		end
	end

	table.insert(espObjs, bb)
end

espBtn.MouseButton1Click:Connect(function()
	click()
	espOn = not espOn
	espBtn.Text = espOn and "ESP : ON" or "ESP : OFF"
	clearESP()

	if espOn then
		createESP(player, Color3.fromRGB(0,0,255)) -- tu hitbox azul
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= player then
				createESP(p, Color3.fromRGB(255,0,0)) -- hitbox roja
			end
		end
	end
end)

--------------------------------------------------
-- X-RAY
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
-- DRAG MENU
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
-- ICONO CIRCULAR
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

local iconMenu = Instance.new("Frame", gui)
iconMenu.Size = UDim2.fromScale(0.3,0.25)
iconMenu.Position = UDim2.fromScale(0.05,0.55)
iconMenu.BackgroundColor3 = Color3.fromRGB(20,20,20)
iconMenu.Visible = false
Instance.new("UICorner", iconMenu).CornerRadius = UDim.new(0,16)

local hideBtn = Instance.new("TextButton", iconMenu)
hideBtn.Size = UDim2.fromScale(0.9,0.35)
hideBtn.Position = UDim2.fromScale(0.05,0.05)
hideBtn.Text = "HIDE MENU"
hideBtn.Font = Enum.Font.GothamBold
hideBtn.TextScaled = true
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0,14)

local unwalkBtn = Instance.new("TextButton", iconMenu)
unwalkBtn.Size = UDim2.fromScale(0.9,0.35)
unwalkBtn.Position = UDim2.fromScale(0.05,0.55)
unwalkBtn.Text = "UNWALK ANIMATION : OFF"
unwalkBtn.Font = Enum.Font.GothamBold
unwalkBtn.TextScaled = true
unwalkBtn.TextColor3 = Color3.new(1,1,1)
unwalkBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", unwalkBtn).CornerRadius = UDim.new(0,14)

-- DRAG ICONO Y SU MENU
local dI,dStart,dPos
local draggingMenu = false
icon.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dI = true
		dStart = i.Position
		dPos = icon.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dI then
		local d = i.Position - dStart
		icon.Position = UDim2.new(dPos.X.Scale,dPos.X.Offset+d.X,dPos.Y.Scale,dPos.Y.Offset+d.Y)
		if iconMenu.Visible then
			iconMenu.Position = icon.Position + UDim2.fromOffset(0, icon.Size.Y.Offset + 5)
		end
	end
end)

UIS.InputEnded:Connect(function() dI = false end)

icon.MouseButton1Click:Connect(function()
	click()
	iconMenu.Visible = not iconMenu.Visible
end)

-- HIDE MENU BUTTON
hideBtn.MouseButton1Click:Connect(function()
	click()
	frame.Visible = not frame.Visible
end)

-- UNWALK BUTTON
unwalkBtn.MouseButton1Click:Connect(function()
	click()
	unwalkOn = not unwalkOn
	unwalkBtn.Text = unwalkOn and "UNWALK ANIMATION : ON" or "UNWALK ANIMATION : OFF"
end)

RunService.Heartbeat:Connect(function()
	if unwalkOn then
		humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) -- vuelve normal
	end
end)

--------------------------------------------------
-- TELE-K (FIJO ARRIBA DERECHA)
--------------------------------------------------
local teleK = Instance.new("TextButton", gui)
teleK.Size = UDim2.fromScale(0.18,0.08)
teleK.Position = UDim2.fromScale(0.8,0.03)
teleK.Text = "TELE-K"
teleK.Font = Enum.Font.GothamBlack
teleK.TextScaled = true
teleK.TextColor3 = Color3.new(1,1,1)
teleK.BackgroundColor3 = Color3.fromRGB(255,50,50)
Instance.new("UICorner", teleK).CornerRadius = UDim.new(0,16)

teleK.MouseButton1Click:Connect(function()
	click()
	doTeleport()
end)

print("🚀 HAROLDCUPS listo con TELE-K, UNWALK, ESP, AUTO GRAB y menús movibles con sonido")
