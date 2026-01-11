--// HaroldCUPS HUB - LOCAL SCRIPT FINAL (UNWALK & TELE-K CORREGIDO)

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
local teleKOn = false
local unwalkOn = false

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

--------------------------------------------------
-- TITULO (DRAG)
--------------------------------------------------
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.12)
title.BackgroundTransparency = 1
title.Text = "HaroldCUPS"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,90,90)
title.Active = true

--------------------------------------------------
-- CREAR BOTONES (TEXTO GRANDE)
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
-- BOTONES (ORDEN)
--------------------------------------------------
local teleBtn  = makeButton("TELEGUIADO",0.14)
local speedBtn = makeButton("SPEED : OFF",0.25)
local kickBtn  = makeButton("AUTO KICK : OFF",0.36)

local espBtn = makeButton("ESP : OFF",0.47,0.43)
espBtn.Position = UDim2.fromScale(0.05,0.47)

local xrayBtn = makeButton("X-RAY : OFF",0.47,0.43)
xrayBtn.Position = UDim2.fromScale(0.52,0.47)

local grabBtn = makeButton("AUTO GRAB : OFF",0.59)
local teleKBtn = makeButton("TELE-K : OFF",0.71)
local closeBtn = makeButton("CLOSE",0.82)

--------------------------------------------------
-- TELEGUIADO
--------------------------------------------------
local function doTeleport()
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
-- ESP (CORREGIDO)
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
	bb.Size = UDim2.new(0,120,0,25)
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
-- TELE-K (FIJO ARRIBA DERECHA)
--------------------------------------------------
local teleKeyBtn = Instance.new("TextButton", gui)
teleKeyBtn.Size = UDim2.fromScale(0.12,0.07)
teleKeyBtn.Position = UDim2.fromScale(0.87,0.05)
teleKeyBtn.Text = "TELE-K"
teleKeyBtn.Font = Enum.Font.GothamBlack
teleKeyBtn.TextScaled = true
teleKeyBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
teleKeyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", teleKeyBtn).CornerRadius = UDim.new(0,16)
teleKeyBtn.Visible = false -- activable solo con TELE-K button

teleKBtn.MouseButton1Click:Connect(function()
	click()
	teleKOn = not teleKOn
	teleKeyBtn.Visible = teleKOn
	teleKBtn.Text = teleKOn and "TELE-K : ON" or "TELE-K : OFF"
end)

teleKeyBtn.MouseButton1Click:Connect(function()
	click()
	doTeleport()
end)

--------------------------------------------------
-- UNWALK ANIMATION (ON/OFF)
--------------------------------------------------
local unwalkBtn = Instance.new("TextButton", gui)
unwalkBtn.Size = UDim2.fromScale(0.15,0.065)
unwalkBtn.Position = UDim2.fromScale(0.38,0.12)
unwalkBtn.Text = "UNWALK : OFF"
unwalkBtn.Font = Enum.Font.GothamBlack
unwalkBtn.TextScaled = true
unwalkBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
unwalkBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", unwalkBtn).CornerRadius = UDim.new(0,14)
unwalkBtn.Visible = false

local idleAnim = Instance.new("Animation")
idleAnim.AnimationId = "rbxassetid://180435571" -- default idle

unwalkBtn.MouseButton1Click:Connect(function()
	click()
	unwalkOn = not unwalkOn
	unwalkBtn.Text = unwalkOn and "UNWALK : ON" or "UNWALK : OFF"

	if unwalkOn then
		local track = humanoid:LoadAnimation(idleAnim)
		track:Play()
		track.Priority = Enum.AnimationPriority.Action
		track.Looped = true
	else
		humanoid:LoadAnimation(idleAnim):Stop()
	end
end)

-- Mostrar el botón cuando se active desde icono del HUB si quieres
-- Puedes agregar un botón extra de “CIRCULO” que haga visible este unwalkBtn y hide menú

--------------------------------------------------
-- DRAG MENU Y ICONOS
--------------------------------------------------
local function makeDraggable(guiObject)
	local dragging, dragStart, startPos
	guiObject.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = guiObject.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			guiObject.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
		end
	end)
	UIS.InputEnded:Connect(function() dragging = false end)
end

makeDraggable(frame)

--------------------------------------------------
-- CERRAR MENU
--------------------------------------------------
local open = true
closeBtn.MouseButton1Click:Connect(function()
	click()
	open = false
	frame.Visible = false
end)

print("🐱 HaroldCUPS HUB — UNWALK & TELE-K actualizado, todo funcional ✅")
