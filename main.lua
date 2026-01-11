-- ================== SERVICES ==================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

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

-- ================== ESTADOS ==================
local speedOn = false
local autoKick = false

local normalSpeed = 28
local fastSpeed = 35

-- ================== GUI ==================
local gui = Instance.new("ScreenGui")
gui.Name = "CatHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ================== SONIDO ==================
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1

local function click()
	clickSound:Play()
end

-- ================== FRAME ==================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.36,0.5)
frame.Position = UDim2.fromScale(0.32,0.25)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- ================== TITULO ==================
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.12)
title.BackgroundTransparency = 1
title.Text = "CAT HUB"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,80,80)

-- ================== BOTONES ==================
local function makeButton(text,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9,0.12)
	b.Position = UDim2.fromScale(0.05,y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.BorderSizePixel = 0
	b.Active = true
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
	return b
end

local teleBtn = makeButton("TELEGUIADO",0.14)
local speedBtn = makeButton("SPEED",0.28)
local kickBtn = makeButton("AUTO KICK",0.42)

-- ================== TELEGUIADO ==================
teleBtn.MouseButton1Click:Connect(function()
	click()
	hrp.CFrame = spawnCFrame
	if autoKick then
		task.delay(2,function()
			player:Kick("Auto Kick Active")
		end)
	end
end)

-- ================== SPEED ==================
speedBtn.MouseButton1Click:Connect(function()
	click()
	speedOn = not speedOn
	humanoid.WalkSpeed = speedOn and fastSpeed or normalSpeed
end)

-- ================== AUTO KICK ==================
kickBtn.MouseButton1Click:Connect(function()
	click()
	autoKick = not autoKick
end)

-- ================== DRAG MENU ==================
do
	local drag, start, pos
	frame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true
			start = i.Position
			pos = frame.Position
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - start
			frame.Position = UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
		end
	end)

	UIS.InputEnded:Connect(function()
		drag = false
	end)
end

-- ================== ICONO CIRCULAR ==================
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.fromScale(0.08,0.08)
icon.Position = UDim2.fromScale(0.02,0.45)
icon.Text = "🐱"
icon.TextScaled = true
icon.BackgroundColor3 = Color3.new(0,0,0)
icon.TextColor3 = Color3.new(1,1,1)
icon.BorderSizePixel = 0
icon.Active = true
Instance.new("UICorner", icon).CornerRadius = UDim.new(1,0)

icon.MouseButton1Click:Connect(function()
	click()
	frame.Visible = not frame.Visible
end)

-- ================== BOTÓN TELEGUIADO FLOTANTE ==================
local teleFloat = Instance.new("TextButton", gui)
teleFloat.Size = UDim2.fromScale(0.22,0.08)
teleFloat.Position = UDim2.fromScale(0.39,0.03)
teleFloat.Text = "TELEGUIADO"
teleFloat.Font = Enum.Font.GothamBlack
teleFloat.TextScaled = true
teleFloat.TextColor3 = Color3.new(1,1,1)
teleFloat.BackgroundColor3 = Color3.fromRGB(255,80,80)
teleFloat.BorderSizePixel = 0
teleFloat.Active = true
Instance.new("UICorner", teleFloat).CornerRadius = UDim.new(1,0)

teleFloat.MouseButton1Click:Connect(function()
	click()
	hrp.CFrame = spawnCFrame
	if autoKick then
		task.delay(2,function()
			player:Kick("Auto Kick Active")
		end)
	end
end)

-- ================== DESYNC SOURCE REAL ==================
local DESYNC_FLAGS = {
	{"DFIntS2PhysicsSenderRate","-30"},
	{"WorldStepMax","-1"},
	{"DFIntTouchSenderMaxBandwidthBps","-1"},
	{"DFFlagUseClientAuthoritativePhysicsForHumanoids","True"},
	{"DFFlagClientCharacterControllerPhysicsOverride","True"},
	{"DFIntSimBlockLargeLocalToolWeldManipulationsThreshold","-1"},
	{"DFIntClientPhysicsMaxSendRate","2147483647"},
	{"DFIntPhysicsSenderRate","2147483647"},
	{"DFIntClientPhysicsSendRate","2147483647"},
	{"DFIntNetworkSendRate","2147483647"},
	{"DFIntDebugSimPrimalNewtonIts","0"},
	{"DFIntDebugSimPrimalPreconditioner","0"},
	{"DFIntDebugSimPrimalPreconditionerMinExp","0"},
	{"DFIntDebugSimPrimalToleranceInv","0"},
	{"DFIntMinClientSimulationRadius","2147000000"},
	{"DFIntMaxClientSimulationRadius","2147000000"},
	{"DFIntClientSimulationRadiusBuffer","2147000000"},
	{"DFIntMinimalSimRadiusBuffer","2147000000"},
	{"DFIntSimVelocityCorrectionDampening","0"},
	{"DFIntSimPositionCorrectionDampening","0"},
	{"DFFlagDebugDisablePositionCorrection","True"},
	{"GameNetPVHeaderRotationalVelocityZeroCutoffExponent","-2147483647"},
	{"GameNetPVHeaderLinearVelocityZeroCutoffExponent","-2147483647"},
	{"DFIntUnstickForceAttackInTenths","-20"},
}

local desyncOn = false
local desyncConn

local function spamFlags()
	if setfflag then
		for _,f in ipairs(DESYNC_FLAGS) do
			pcall(function()
				setfflag(f[1],f[2])
			end)
		end
	end
end

-- ================== BOTÓN DESYNC FLOTANTE ==================
local desyncBtn = Instance.new("TextButton", gui)
desyncBtn.Size = teleFloat.Size
desyncBtn.Position = UDim2.fromScale(0.62,0.03)
desyncBtn.Text = "DESYNCOFF"
desyncBtn.Font = Enum.Font.GothamBlack
desyncBtn.TextScaled = true
desyncBtn.TextColor3 = Color3.new(1,1,1)
desyncBtn.BackgroundColor3 = Color3.fromRGB(15,15,15)
desyncBtn.BorderSizePixel = 0
desyncBtn.Active = true
Instance.new("UICorner", desyncBtn).CornerRadius = UDim.new(1,0)

desyncBtn.MouseButton1Click:Connect(function()
	click()
	desyncOn = not desyncOn

	if desyncOn then
		desyncBtn.Text = "DESYNCACTIVE"
		desyncBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
		desyncConn = RunService.RenderStepped:Connect(spamFlags)
	else
		desyncBtn.Text = "DESYNCOFF"
		desyncBtn.BackgroundColor3 = Color3.fromRGB(15,15,15)
		if desyncConn then
			desyncConn:Disconnect()
			desyncConn = nil
		end
	end
end)
