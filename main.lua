--// HAROLD CUP - LOCAL SCRIPT FINAL (PANEL AJUSTADO A 3 BOTONES)

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
local autoKick = false
local grabOn = false

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- SONIDO CLICK
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

-- FRAME (AJUSTADO EXACTO)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.35, 0.36) -- 👈 SIN ESPACIO ABAJO
frame.Position = UDim2.fromScale(0.32, 0.28)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- TITULO
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.14)
title.BackgroundTransparency = 1
title.Text = "rezxKurd"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(0,150,255)
title.Active = true

-- BOTONES (MISMO ESTILO)
local function makeButton(text, posY)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9,0.18)
	b.Position = UDim2.fromScale(0.05,posY)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
	return b
end

-- BOTONES
local teleBtn = makeButton("TELEPORT", 0.18)
local grabBtn = makeButton("AUTO GRAB", 0.40)
local kickBtn = makeButton("AUTO KICK", 0.62)

-- TELEPORT
teleBtn.MouseButton1Click:Connect(function()
	click()
	local startPos = hrp.Position
	local endPos = spawnCFrame.Position
	local dir = (endPos - startPos).Unit
	local dist = (endPos - startPos).Magnitude
	local speed = 300
	local moved = 0

	teleBtn.Text = "teleporting..."

	local conn
	conn = RunService.Heartbeat:Connect(function(dt)
		moved += speed * dt
		hrp.CFrame = CFrame.new(startPos + dir * math.min(moved, dist))
		if moved >= dist then
			hrp.CFrame = spawnCFrame
			teleBtn.Text = "TELEPORT"
			conn:Disconnect()
		end
	end)
end)

-- AUTO GRAB
grabBtn.MouseButton1Click:Connect(function()
	click()
	grabOn = not grabOn
	grabBtn.Text = grabOn and "AUTO GRAB ON" or "AUTO GRAB"
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
	kickBtn.Text = autoKick and "AUTO KICK ON" or "AUTO KICK"
end)

-- PANEL MOVIBLE
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
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + d.X,
			startPos.Y.Scale, startPos.Y.Offset + d.Y
		)
	end
end)

UIS.InputEnded:Connect(function()
	dragging = false
end)

print("Panel ajustado exacto a 3 botones 🔥")
