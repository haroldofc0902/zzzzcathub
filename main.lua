-- ================== SERVICES ==================
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
end)

-- ================== ESTADOS ==================
local speedOn = false
local autoKick = false
local espOn = false
local xrayOn = false
local autoGrabOn = false

local normalSpeed = 28
local fastSpeed = 35

-- ================== GUI ==================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "CatHub"
gui.ResetOnSpawn = false

-- ================== SONIDO ==================
local clickSound = Instance.new("Sound", gui)
clickSound.SoundId = "rbxassetid://12221967"
clickSound.Volume = 1
local function click() clickSound:Play() end

-- ================== FRAME ==================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.36,0.55)
frame.Position = UDim2.fromScale(0.32,0.22)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- ================== TITULO ==================
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.1)
title.BackgroundTransparency = 1
title.Text = "CAT HUB"
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255,80,80)

-- ================== BOTONES ==================
local function makeButton(text,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9,0.1)
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

local teleBtn  = makeButton("TELEGUIADO",0.12)
local speedBtn = makeButton("SPEED",0.23)
local kickBtn  = makeButton("AUTO KICK",0.34)

local espBtn = makeButton("ESP",0.45)
espBtn.Size = UDim2.fromScale(0.43,0.1)

local xrayBtn = makeButton("X-RAY",0.45)
xrayBtn.Position = UDim2.fromScale(0.52,0.45)
xrayBtn.Size = UDim2.fromScale(0.43,0.1)

local grabBtn = makeButton("AUTO GRAB",0.58)

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

-- ================== ESP ==================
local espObjects = {}
local function clearESP()
	for _,v in pairs(espObjects) do v:Destroy() end
	espObjects = {}
end

espBtn.MouseButton1Click:Connect(function()
	click()
	espOn = not espOn
	clearESP()

	if espOn then
		for _,plr in pairs(Players:GetPlayers()) do
			if plr.Character and plr.Character:FindFirstChild("Head") then
				local bb = Instance.new("BillboardGui", plr.Character.Head)
				bb.Size = UDim2.new(0,200,0,50)
				bb.AlwaysOnTop = true

				local tl = Instance.new("TextLabel", bb)
				tl.Size = UDim2.fromScale(1,1)
				tl.BackgroundTransparency = 1
				tl.Text = plr.Name
				tl.TextColor3 = Color3.fromRGB(255,0,0)
				tl.TextScaled = true
				tl.Font = Enum.Font.GothamBlack

				table.insert(espObjects, bb)
			end
		end
	end
end)

-- ================== X-RAY ==================
xrayBtn.MouseButton1Click:Connect(function()
	click()
	xrayOn = not xrayOn
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v.Name:lower():find("floor") then
			v.LocalTransparencyModifier = xrayOn and 0.6 or 0
		end
	end
end)

-- ================== AUTO GRAB ==================
RunService.Heartbeat:Connect(function()
	if autoGrabOn then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				local t = v.ActionText:lower()
				if (t:find("robar") or t:find("steal")) and
				(v.Parent.Position - hrp.Position).Magnitude < v.MaxActivationDistance then
					fireproximityprompt(v)
				end
			end
		end
	end
end)

grabBtn.MouseButton1Click:Connect(function()
	click()
	autoGrabOn = not autoGrabOn
end)

-- ================== DESYNC ==================
local DESYNC_FLAGS = {
	{"DFIntS2PhysicsSenderRate","-30"},
	{"WorldStepMax","-1"},
	{"DFIntTouchSenderMaxBandwidthBps","-1"},
	{"DFFlagUseClientAuthoritativePhysicsForHumanoids","True"},
	{"DFFlagClientCharacterControllerPhysicsOverride","True"},
	{"DFIntClientPhysicsMaxSendRate","2147483647"},
	{"DFIntNetworkSendRate","2147483647"},
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

local desyncBtn = Instance.new("TextButton", gui)
desyncBtn.Size = UDim2.fromScale(0.22,0.08)
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

		-- 🔁 REINICIO AUTOMÁTICO
		task.delay(0.1,function()
			if player.Character and player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid.Health = 0
			end
		end)
	else
		desyncBtn.Text = "DESYNCOFF"
		desyncBtn.BackgroundColor3 = Color3.fromRGB(15,15,15)
		if desyncConn then
			desyncConn:Disconnect()
			desyncConn = nil
		end
	end
end)
