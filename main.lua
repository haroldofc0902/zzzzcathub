--// RexHub Insta Stealer 1.0 - PANEL NUEVO DESDE CERO

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "RexHubGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- PANEL PRINCIPAL
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Position = UDim2.fromScale(0.35, 0.2)
frame.Size = UDim2.fromScale(0.32, 0)
frame.AutomaticSize = Enum.AutomaticSize.Y
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

-- HEADER
local header = Instance.new("TextLabel")
header.Parent = frame
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(240,240,240)
header.Text = "RexHub Insta Stealer 1.0"
header.Font = Enum.Font.GothamBold
header.TextSize = 18
header.TextColor3 = Color3.fromRGB(0,0,0)
header.BorderSizePixel = 0

local hc = Instance.new("UICorner", header)
hc.CornerRadius = UDim.new(0, 12)

-- CONTENEDOR BOTONES
local container = Instance.new("Frame")
container.Parent = frame
container.Size = UDim2.new(1, -16, 0, 0)
container.Position = UDim2.new(0, 8, 0, 48)
container.AutomaticSize = Enum.AutomaticSize.Y
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout")
layout.Parent = container
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- FUNCIÓN BOTÓN (CUADRADO, GRANDE)
local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Parent = container
	btn.Size = UDim2.new(1, 0, 0, 60)
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 20
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = true

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
	return btn
end

-- === BOTONES (MISMO ORDEN QUE LA FOTO) ===
local tpBtn     = createButton("TP to base")
local desyncBtn = createButton("Desync (OFF)")
local speedBtn  = createButton("Speed (OFF)")

-- === FUNCIONES ===

-- TP VOLANDO RÁPIDO (NO TELEPORT INSTANTE)
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

-- DESYNC (VISUAL)
local desync = false
desyncBtn.MouseButton1Click:Connect(function()
	desync = not desync
	desyncBtn.Text = desync and "Desync (ON)" or "Desync (OFF)"
end)

-- SPEED
local speedOn = false
speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	humanoid.WalkSpeed = speedOn and 36 or 16
	speedBtn.Text = speedOn and "Speed (ON)" or "Speed (OFF)"
end)

print("✅ RexHub Insta Stealer 1.0 cargado | 3 botones | sin espacio invisible")
