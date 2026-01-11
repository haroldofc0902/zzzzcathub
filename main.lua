-- CAT HUB FINAL 2.0

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- CHARACTER
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
-- STATES
--------------------------------------------------
local speedOn = false
local normalSpeed = 28
local fastSpeed = 38
local autoKickOn = false

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "CatHub"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- CLICK SOUND
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
clickSound.Parent = gui

--------------------------------------------------
-- MAIN FRAME
--------------------------------------------------
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.38,0.58)
frame.Position = UDim2.fromScale(0.31,0.21)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.1)
title.BackgroundTransparency = 1
title.Text = "CAT HUB"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

--------------------------------------------------
-- BUTTON CREATOR
--------------------------------------------------
local function makeButton(text,pos,sizeX)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(sizeX or 0.9,0.11)
	b.Position = pos
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
	return b
end

--------------------------------------------------
-- BUTTON ORDER (EXACT)
--------------------------------------------------
local teleBtn  = makeButton("TELEGUIADO",UDim2.fromScale(0.05,0.12))
local speedBtn = makeButton("SPEED : OFF",UDim2.fromScale(0.05,0.24))
local kickBtn  = makeButton("AUTO KICK : OFF",UDim2.fromScale(0.05,0.36))
local espBtn   = makeButton("ESP",UDim2.fromScale(0.05,0.48),0.42)
local xrayBtn  = makeButton("X-RAY",UDim2.fromScale(0.53,0.48),0.42)
local grabBtn  = makeButton("AUTO GRAB",UDim2.fromScale(0.05,0.62))
local closeBtn = makeButton("CLOSE",UDim2.fromScale(0.05,0.76),0.4) -- más pequeño

--------------------------------------------------
-- TELEGUIADO
--------------------------------------------------
local function teleport()
	hrp.CFrame = spawnCFrame
end

teleBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	teleport()
end)

--------------------------------------------------
-- SPEED TOGGLE
--------------------------------------------------
speedBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	speedOn = not speedOn
	humanoid.WalkSpeed = speedOn and fastSpeed or normalSpeed
	speedBtn.Text = speedOn and "SPEED : ON" or "SPEED : OFF"
end)

--------------------------------------------------
-- AUTO KICK (ANTI "YOU STOLE")
--------------------------------------------------
local keyword = "you stole"
local kickMessage = "You stole brainrot!"

local function hasKeyword(text)
	if typeof(text) ~= "string" then return false end
	return string.find(string.lower(text), keyword) ~= nil
end

local function kickPlayer()
	local success, err = pcall(function()
		player:Kick(kickMessage)
	end)
	if not success then
		warn("Kick fallido: "..tostring(err))
	end
end

local function scanGuiObjects(parent)
	for _, obj in ipairs(parent:GetDescendants()) do
		if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
			if hasKeyword(obj.Text) then
				print("⚡ Detectado 'You stole' → Kick local player")
				kickPlayer()
				return true
			end
			obj:GetPropertyChangedSignal("Text"):Connect(function()
				if hasKeyword(obj.Text) then
					print("⚡ GUI text cambió a 'You stole' → Kick local player")
					kickPlayer()
				end
			end)
		end
	end
	return false
end

local function setupGuiWatcher(gui)
	gui.DescendantAdded:Connect(function(desc)
		if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
			if hasKeyword(desc.Text) then
				print("⚡ Detectado 'You stole' → Kick local player")
				kickPlayer()
			end
			desc:GetPropertyChangedSignal("Text"):Connect(function()
				if hasKeyword(desc.Text) then
					print("⚡ GUI text cambió a 'You stole' → Kick local player")
					kickPlayer()
				end
			end)
		end
	end)
end

for _, guiObj in ipairs(PlayerGui:GetChildren()) do
	setupGuiWatcher(guiObj)
end

PlayerGui.ChildAdded:Connect(function(guiObj)
	setupGuiWatcher(guiObj)
	scanGuiObjects(guiObj)
end)

scanGuiObjects(PlayerGui)

kickBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	autoKickOn = not autoKickOn
	kickBtn.Text = autoKickOn and "AUTO KICK : ON" or "AUTO KICK : OFF"
end)

--------------------------------------------------
-- CLOSE MENU
--------------------------------------------------
local open = true
closeBtn.MouseButton1Click:Connect(function()
	clickSound:Play()
	open = false
	frame.Visible = false
end)

--------------------------------------------------
-- DRAG FUNCTION
--------------------------------------------------
local function makeDraggable(obj)
	local dragging, dragStart, startPos
	obj.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = obj.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - dragStart
			obj.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
	UIS.InputEnded:Connect(function()
		dragging = false
	end)
end

makeDraggable(frame)

--------------------------------------------------
-- FLOATING ICON
--------------------------------------------------
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromScale(0.08,0.08)
icon.Position = UDim2.fromScale(0.03,0.45)
icon.Text = "🐱"
icon.Font = Enum.Font.GothamBlack
icon.TextScaled = true
icon.BackgroundColor3 = Color3.fromRGB(0,0,0)
icon.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

makeDraggable(icon)

icon.MouseButton1Click:Connect(function()
	clickSound:Play()
	open = not open
	frame.Visible = open
end)

--------------------------------------------------
-- TELEGUIADO FLOATING KEY (ROJO)
--------------------------------------------------
local teleKey = Instance.new("TextButton", gui)
teleKey.Size = UDim2.fromScale(0.13,0.07)
teleKey.Position = UDim2.fromScale(0.8,0.15)
teleKey.Text = "TELEGUIADO"
teleKey.Font = Enum.Font.GothamBlack
teleKey.TextScaled = true
teleKey.BackgroundColor3 = Color3.fromRGB(255,0,0) -- rojo
teleKey.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", teleKey).CornerRadius = UDim.new(0,16)

makeDraggable(teleKey)

teleKey.MouseButton1Click:Connect(function()
	clickSound:Play()
	teleport()
end)

--------------------------------------------------
print("🐱 CAT HUB FINAL 2.0 — listo, draggable y con sonido")
