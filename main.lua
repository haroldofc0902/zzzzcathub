--// RexHub Insta Stealer 1.0 + Minimize Button

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "RexHubGUI"
gui.ResetOnSpawn = false

-- PANEL
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Position = UDim2.fromScale(0.35, 0.2)
frame.Size = UDim2.fromScale(0.32, 0)
frame.AutomaticSize = Enum.AutomaticSize.Y
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

-- HEADER
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,40)
header.BackgroundColor3 = Color3.fromRGB(240,240,240)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "RexHub Insta Stealer 1.0"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0,0,0)
title.TextXAlignment = Enum.TextXAlignment.Left

-- BOTÓN MINIMIZAR
local toggleBtn = Instance.new("TextButton", header)
toggleBtn.Size = UDim2.new(0,30,0,30)
toggleBtn.Position = UDim2.new(1,-35,0.5,-15)
toggleBtn.Text = "-"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 22
toggleBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
toggleBtn.TextColor3 = Color3.fromRGB(0,0,0)
toggleBtn.BorderSizePixel = 0
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

-- CONTENEDOR
local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1,-16,0,0)
container.Position = UDim2.new(0,8,0,48)
container.AutomaticSize = Enum.AutomaticSize.Y
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,10)

-- BOTÓN BASE
local function createButton(text)
	local btn = Instance.new("TextButton", container)
	btn.Size = UDim2.new(1,0,0,60)
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 20
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,12)
	return btn
end

-- BOTONES
local tpBtn   = createButton("TP to base")
local grabBtn = createButton("AUTO GRAB")
local kickBtn = createButton("AUTO KICK")

-- ====== MINIMIZAR / RESTAURAR ======
local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	container.Visible = not minimized
	toggleBtn.Text = minimized and "+" or "-"
end)

-- ====== TP VOLANDO ======
local spawnCFrame = hrp.CFrame
player.CharacterAdded:Connect(function(c)
	char = c
	hrp = c:WaitForChild("HumanoidRootPart")
	humanoid = c:WaitForChild("Humanoid")
	spawnCFrame = hrp.CFrame
end)

tpBtn.MouseButton1Click:Connect(function()
	local startPos = hrp.Position
	local endPos = spawnCFrame.Position
	local dir = (endPos - startPos).Unit
	local dist = (endPos - startPos).Magnitude
	local speed = 200
	local moved = 0

	local conn
	conn = RunService.Heartbeat:Connect(function(dt)
		local step = speed * dt
		moved += step
		hrp.CFrame = CFrame.new(startPos + dir * moved, endPos)
		if moved >= dist then
			hrp.CFrame = spawnCFrame
			conn:Disconnect()
		end
	end)
end)

-- ====== AUTO GRAB ======
local grabOn = false
grabBtn.MouseButton1Click:Connect(function()
	grabOn = not grabOn
	grabBtn.Text = grabOn and "AUTO GRAB (ON)" or "AUTO GRAB"
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

-- ====== AUTO KICK ======
local autoKick = false
kickBtn.MouseButton1Click:Connect(function()
	autoKick = not autoKick
	kickBtn.Text = autoKick and "AUTO KICK (ON)" or "AUTO KICK"
end)

player.PlayerGui.DescendantAdded:Connect(function(obj)
	if autoKick and (obj:IsA("TextLabel") or obj:IsA("TextButton")) then
		obj:GetPropertyChangedSignal("Text"):Connect(function()
			if string.find(string.lower(obj.Text),"you stole") then
				player:Kick("Auto Kick by RexHub")
			end
		end)
	end
end)

print("✅ RexHub listo con minimizador (- / +)")
