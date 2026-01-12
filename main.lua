-- Services
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- CONFIG
local PANEL_COLOR = Color3.fromRGB(15, 15, 15)
local BUTTON_COLOR = Color3.fromRGB(15, 15, 15)
local BUTTON_ACTIVE_COLOR = Color3.fromRGB(255, 0, 0)
local BUTTON_STROKE_COLOR = Color3.fromRGB(255, 255, 255)
local BUTTON_STROKE_ACTIVE = Color3.fromRGB(255, 150, 150)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)

-- // PANEL //
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "rexHub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 120, 0, 80)
MainFrame.Position = UDim2.new(0.5, -60, 0.5, -40)
MainFrame.BackgroundColor3 = PANEL_COLOR
MainFrame.BorderSizePixel = 0

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- DRAG LOGIC FOR PANEL
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- // DESYNC BUTTON //
local DesyncButton = Instance.new("TextButton")
DesyncButton.Parent = MainFrame
DesyncButton.Size = UDim2.new(1, -10, 1, -10)
DesyncButton.Position = UDim2.new(0, 5, 0, 5)
DesyncButton.BackgroundColor3 = BUTTON_COLOR
DesyncButton.Font = Enum.Font.FredokaOne
DesyncButton.TextSize = 16
DesyncButton.TextColor3 = TEXT_COLOR
DesyncButton.Text = "Desync"

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 12)
ButtonCorner.Parent = DesyncButton

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Color = BUTTON_STROKE_COLOR
ButtonStroke.Thickness = 3
ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ButtonStroke.Parent = DesyncButton

-- // DESYNC LOGIC FROM YOUR SOURCE //
local DESYNC_FLAGS = {
    {"DFIntS2PhysicsSenderRate", "-30"},          
    {"WorldStepMax", "-1"},                                 
    {"DFIntTouchSenderMaxBandwidthBps", "-1"},            
    {"DFFlagUseClientAuthoritativePhysicsForHumanoids", "True"},
    {"DFFlagClientCharacterControllerPhysicsOverride", "True"},
    {"DFIntSimBlockLargeLocalToolWeldManipulationsThreshold", "-1"},
    {"DFIntClientPhysicsMaxSendRate", "2147483647"},
    {"DFIntPhysicsSenderRate", "2147483647"},
    {"DFIntClientPhysicsSendRate", "2147483647"},
    {"DFIntNetworkSendRate", "2147483647"},
    {"DFIntDebugSimPrimalNewtonIts", "0"},
    {"DFIntDebugSimPrimalPreconditioner", "0"},
    {"DFIntDebugSimPrimalPreconditionerMinExp", "0"},
    {"DFIntDebugSimPrimalToleranceInv", "0"},
    {"DFIntMinClientSimulationRadius", "2147000000"},
    {"DFIntMaxClientSimulationRadius", "2147000000"},
    {"DFIntClientSimulationRadiusBuffer", "2147000000"},
    {"DFIntMinimalSimRadiusBuffer", "2147000000"},
    {"DFIntSimVelocityCorrectionDampening", "0"},
    {"DFIntSimPositionCorrectionDampening", "0"},
    {"DFFlagDebugDisablePositionCorrection", "True"},
    {"GameNetPVHeaderRotationalVelocityZeroCutoffExponent", "-2147483647"},
    {"GameNetPVHeaderLinearVelocityZeroCutoffExponent", "-2147483647"},
    {"DFIntUnstickForceAttackInTenths", "-20"},
}

local isMacroActive = false
local loopConnection = nil

local function spamFlags()
    if setfflag then
        for _, flagData in ipairs(DESYNC_FLAGS) do
            pcall(function()
                setfflag(flagData[1], flagData[2])
            end)
        end
    end
end

DesyncButton.MouseButton1Click:Connect(function()
    isMacroActive = not isMacroActive
    
    if isMacroActive then
        -- Cambia texto a "Desync..." mientras ejecuta
        DesyncButton.Text = "Desync..."
        DesyncButton.BackgroundColor3 = BUTTON_ACTIVE_COLOR
        ButtonStroke.Color = BUTTON_STROKE_ACTIVE
        loopConnection = RunService.RenderStepped:Connect(spamFlags)
    else
        -- Vuelve a texto original
        DesyncButton.Text = "Desync"
        DesyncButton.BackgroundColor3 = BUTTON_COLOR
        ButtonStroke.Color = BUTTON_STROKE_COLOR
        if loopConnection then
            loopConnection:Disconnect()
            loopConnection = nil
        end
        
        if setfflag then
            pcall(function()
                for _, flagData in ipairs(DESYNC_FLAGS) do
                    setfflag(flagData[1], "False")
                end
            end)
        end
    end
end)
