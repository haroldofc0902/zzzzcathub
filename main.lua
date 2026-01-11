--// HAROLDCUPS HUB - FINAL

-- SERVICES
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
-- MENU TELEGUIADO
--------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.4,0.62)
frame.Position = UDim2.fromScale(0.3,0.18)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.12)
title.BackgroundTransparency = 1
title.Text = "HAROLDCUPS"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,90,90)
title.Active = true

local function makeButton(text,posY,width)
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

-- BOTONES PRINCIPALES
local teleBtn  = makeButton("TELEGUIADO",0.14)
local speedBtn = makeButton("SPEED : OFF",0.25)
local kickBtn  = makeButton("AUTO KICK : OFF",0.36)
local espBtn   = makeButton("ESP : OFF",0.47,0.43)
local xrayBtn  = makeButton("X-RAY : OFF",0.47,0.43)
espBtn.Position = UDim2.fromScale(0.05,0.47)
xrayBtn.Position = UDim2.fromScale(0.52,0.47)
local grabBtn  = makeButton("AUTO GRAB : OFF",0.59)
local teleKBtn = makeButton("KEYBIND-T",0.7)
local closeBtn = makeButton("CLOSE",0.82)

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
		local newPos = startPos + direction * math.min(travelled, distance)
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
-- ESP / X-RAY / AUTO GRAB
--------------------------------------------------
local espObjs = {}
local function clearESP()
	for _,v in pairs(espObjs) do if v then v:Destroy() end end
	table.clear(espObjs)
end

local function createESP(plr,color)
	if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
	local box = Instance.new("BoxHandleAdornment",workspace)
	box.Adornee = plr.Character:FindFirstChild("HumanoidRootPart")
	box.Size = Vector3.new(4,6,2)
	box.Transparency = 0.5
	box.Color = color
	box.AlwaysOnTop = true
	box.ZIndex = 10
	table.insert(espObjs, box)
end

espBtn.MouseButton1Click:Connect(function()
	click()
	espOn = not espOn
	espBtn.Text = espOn and "ESP : ON" or "ESP : OFF"
	clearESP()
	if espOn then
		createESP(player,Color3.fromRGB(0,0,255))
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
-- CLOSE MENU
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
icon.Size = UDim2.fromScale(0.08,0.08)
icon.Position = UDim2.fromScale(0.03,0.45)
icon.Text = "🐱"
icon.Font = Enum.Font.GothamBlack
icon.TextScaled = true
icon.BackgroundColor3 = Color3.fromRGB(0,0,0)
icon.TextColor3 = Color3.new(1,1,1)
icon.BorderSizePixel = 0
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)
icon.Active = true

local draggingIcon, startIconPos, startIconPos2
icon.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		draggingIcon = true
		startIconPos = i.Position
		startIconPos2 = icon.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if draggingIcon and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local d = i.Position - startIconPos
		icon.Position = UDim2.new(startIconPos2.X.Scale,startIconPos2.X.Offset+d.X,startIconPos2.Y.Scale,startIconPos2.Y.Offset+d.Y)
	end
end)
UIS.InputEnded:Connect(function() draggingIcon = false end)

-- MENU DEL ICONO
local iconMenu = Instance.new("Frame", gui)
iconMenu.Size = UDim2.fromScale(0.4,0.62)
iconMenu.Position = UDim2.fromScale(0.15,0.15)
iconMenu.BackgroundColor3 = Color3.fromRGB(25,25,25)
iconMenu.Visible = false
Instance.new("UICorner", iconMenu).CornerRadius = UDim.new(0,18)

-- DRAG MENU ICONO
local dragIconMenu, dragStartIconMenu, startPosIconMenu
iconMenu.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragIconMenu = true
		dragStartIconMenu = i.Position
		startPosIconMenu = iconMenu.Position
	end
end)
UIS.InputChanged:Connect(function(i)
	if dragIconMenu and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		local d = i.Position - dragStartIconMenu
		iconMenu.Position = UDim2.new(startPosIconMenu.X.Scale,startPosIconMenu.X.Offset+d.X,startPosIconMenu.Y.Scale,startPosIconMenu.Y.Offset+d.Y)
	end
end)
UIS.InputEnded:Connect(function() dragIconMenu = false end)

-- BOTONES DEL MENU DEL ICONO
local hideMenuBtn = Instance.new("TextButton", iconMenu)
hideMenuBtn.Size = UDim2.fromScale(0.9,0.1)
hideMenuBtn.Position = UDim2.fromScale(0.05,0.1)
hideMenuBtn.Text = "HIDE MENU"
hideMenuBtn.Font = Enum.Font.GothamBold
hideMenuBtn.TextScaled = true
hideMenuBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
hideMenuBtn.BorderSizePixel = 0
hideMenuBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", hideMenuBtn).CornerRadius = UDim.new(0,14)

hideMenuBtn.MouseButton1Click:Connect(function()
	click()
	frame.Visible = not frame.Visible
end)

-- VELOCIDAD ICONO
local speedMinus = Instance.new("TextButton", iconMenu)
speedMinus.Size = UDim2.fromScale(0.15,0.1)
speedMinus.Position = UDim2.fromScale(0.05,0.3)
speedMinus.Text = "-"
speedMinus.Font = Enum.Font.GothamBold
speedMinus.TextScaled = true
speedMinus.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedMinus.BorderSizePixel = 0
speedMinus.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedMinus).CornerRadius = UDim.new(0,14)

local speedPlus = Instance.new("TextButton", iconMenu)
speedPlus.Size = UDim2.fromScale(0.15,0.1)
speedPlus.Position = UDim2.fromScale(0.25,0.3)
speedPlus.Text = "+"
speedPlus.Font = Enum.Font.GothamBold
speedPlus.TextScaled = true
speedPlus.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedPlus.BorderSizePixel = 0
speedPlus.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", speedPlus).CornerRadius = UDim.new(0,14)

local speedValueLabel = Instance.new("TextLabel", iconMenu)
speedValueLabel.Size = UDim2.fromScale(0.55,0.1)
speedValueLabel.Position = UDim2.fromScale(0.45,0.3)
speedValueLabel.Text = tostring(currentSpeed)
speedValueLabel.Font = Enum.Font.GothamBold
speedValueLabel.TextScaled = true
speedValueLabel.TextColor3 = Color3.new(1,1,1)
speedValueLabel.BackgroundTransparency = 1

speedPlus.MouseButton1Click:Connect(function()
	click()
	currentSpeed = currentSpeed + 1
	humanoid.WalkSpeed = speedOn and currentSpeed or humanoid.WalkSpeed
	speedValueLabel.Text = tostring(currentSpeed)
end)

speedMinus.MouseButton1Click:Connect(function()
	click()
	currentSpeed = currentSpeed - 1
	humanoid.WalkSpeed = speedOn and currentSpeed or humanoid.WalkSpeed
	speedValueLabel.Text = tostring(currentSpeed)
end)

icon.MouseButton1Click:Connect(function()
	click()
	iconMenu.Visible = not iconMenu.Visible
end)

--------------------------------------------------
-- TELE K
--------------------------------------------------
local teleKFloat = Instance.new("TextButton", gui)
teleKFloat.Size = UDim2.fromScale(0.08,0.08)
teleKFloat.Position = UDim2.fromScale(0.92,0.05)
teleKFloat.Text = "TELE-K"
teleKFloat.Font = Enum.Font.GothamBold
teleKFloat.TextScaled = true
teleKFloat.TextColor3 = Color3.new(1,1,1)
teleKFloat.BackgroundColor3 = Color3.fromRGB(255,0,0)
teleKFloat.BorderSizePixel = 0
Instance.new("UICorner", teleKFloat).CornerRadius = UDim.new(0,10)
teleKFloat.Visible = false

teleKBtn.MouseButton1Click:Connect(function()
	click()
	teleKActive = not teleKActive
	teleKFloat.Visible = teleKActive
end)

teleKFloat.MouseButton1Click:Connect(function()
	click()
	doTeleport()
end)

print("🐱 HAROLDCUPS HUB — Todo listo ✅, icono movible, TELEG-K ultra rápido 🚀")
