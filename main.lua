--// RexHub Insta Stealer 1.0

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
	humanoid = c:WaitForChild("Humanoid")
end)

-- ESTADOS
local grabOn = false
local autoKick = false
local firstTP = true
local savedCFrame = nil
local minimized = false

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- SONIDO
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

-- PANEL
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.32, 0.42)
frame.Position = UDim2.fromScale(0.34, 0.28)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- TITULO
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.18)
title.BackgroundTransparency = 1
title.Text = "RexHub Insta Stealer 1.0"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0,170,255)

-- MINIMIZE BTN
local miniBtn = Instance.new("TextButton", frame)
miniBtn.Size = UDim2.fromScale(0.12,0.6)
miniBtn.Position = UDim2.fromScale(0.86,0.2)
miniBtn.Text = "-"
miniBtn.Font = Enum.Font.GothamBlack
miniBtn.TextScaled = true
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.BackgroundTransparency = 1

-- BOTON CREATOR
local function makeButton(text, posY)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9,0.2)
	b.Position = UDim2.fromScale(0.05,posY)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
	return b
end

-- BOTONES (ORDEN EXACTO)
local tpBtn   = makeButton("TP TO BASE", 0.22)
local grabBtn = makeButton("AUTO GRAB",  0.44)
local kickBtn = makeButton("AUTO KICK",  0.66)

-- MINIMIZAR
miniBtn.MouseButton1Click:Connect(function()
	click()
	minimized = not minimized
	if minimized then
		tpBtn.Visible = false
		grabBtn.Visible = false
		kickBtn.Visible = false
		frame.Size = UDim2.fromScale(0.32,0.18)
		miniBtn.Text = "+"
	else
		tpBtn.Visible = true
		grabBtn.Visible = true
		kickBtn.Visible = true
		frame.Size = UDim2.fromScale(0.32,0.42)
		miniBtn.Text = "-"
	end
end)

-- TELEPORT LOGICA
local function flyTo(cf)
	local start = hrp.Position
	local goal = cf.Position
	local dir = (goal - start).Unit
	local dist = (goal - start).Magnitude
	local speed = 200
	local traveled = 0

	while traveled < dist do
		RunService.Heartbeat:Wait()
		local step = speed * RunService.Heartbeat:Wait()
		traveled += step
		hrp.CFrame = CFrame.new(start + dir * traveled)
	end
	hrp.CFrame = cf
end

tpBtn.MouseButton1Click:Connect(function()
	click()
	if firstTP then
		firstTP = false
		humanoid.Health = 0
		player.CharacterAdded:Wait()
		task.wait(0.2)
		savedCFrame = hrp.CFrame
	else
		if savedCFrame then
			flyTo(savedCFrame)
		end
	end
end)

-- AUTO GRAB
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

-- AUTO KICK
kickBtn.MouseButton1Click:Connect(function()
	click()
	autoKick = not autoKick
end)

local function scanGUI(parent)
	for _,obj in pairs(parent:GetDescendants()) do
		if obj:IsA("TextLabel") or obj:IsA("TextButton") then
			obj:GetPropertyChangedSignal("Text"):Connect(function()
				if autoKick and string.find(string.lower(obj.Text),"you stole") then
					player:Kick("You stole a pet by rezxKurd")
				end
			end)
		end
	end
end

scanGUI(player.PlayerGui)
player.PlayerGui.ChildAdded:Connect(scanGUI)

-- DRAG PANEL
local dragging, dragStart, startPos
title.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = i.Position
		startPos = frame.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging then
		local d = i.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + d.X,
			startPos.Y.Scale, startPos.Y.Offset + d.Y
		)
	end
end)

UIS.InputEnded:Connect(function()
	dragging = false
end)

print("✅ RexHub Insta Stealer 1.0 cargado correctamente")
