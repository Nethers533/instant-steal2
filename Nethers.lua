local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- =====================
-- RGB BORDER / TEXT
-- =====================
local function RGBStroke(obj)
    local stroke = Instance.new("UIStroke", obj)
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    task.spawn(function()
        local h = 0
        while obj.Parent do
            stroke.Color = Color3.fromHSV(h,1,1)
            h = (h + 0.01) % 1
            task.wait()
        end
    end)
end

local function RGBText(obj)
    task.spawn(function()
        local h = 0
        while obj.Parent do
            obj.TextColor3 = Color3.fromHSV(h,1,1)
            h = (h + 0.01) % 1
            task.wait()
        end
    end)
end

-- =====================
-- DRAG SYSTEM
-- =====================
local function MakeDraggable(frame, dragBar)
    local dragging = false
    local dragInput, startPos, startFramePos

    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position
            startFramePos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startPos
            frame.Position = UDim2.new(
                startFramePos.X.Scale,
                startFramePos.X.Offset + delta.X,
                startFramePos.Y.Scale,
                startFramePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- =====================
-- UI
-- =====================
local gui = Instance.new("ScreenGui", PlayerGui)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 270)
main.Position = UDim2.new(.5,0,.5,0)
main.AnchorPoint = Vector2.new(.5,.5)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)
RGBStroke(main)

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,40)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "Nethers Instant Steal"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)

-- MADE BY NETHERS TEXT RGB
local credit = Instance.new("TextLabel", main)
credit.Size = UDim2.new(1,0,0,20)
credit.Position = UDim2.new(0,0,0,22)
credit.BackgroundTransparency = 1
credit.Text = "made by nethers 🔥"
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextStrokeTransparency = 0.8
RGBText(credit)

MakeDraggable(main, top)

-- =====================
-- VARIABLES
-- =====================
local savedPosition = nil
local dashDistance = 20 -- studs forward

-- =====================
-- BUTTONS
-- =====================

-- SET TP
local setBtn = Instance.new("TextButton", main)
setBtn.Size = UDim2.new(.8,0,0,50)
setBtn.Position = UDim2.new(.1,0,.35,0)
setBtn.Text = "Set TP"
setBtn.Font = Enum.Font.GothamBold
setBtn.TextSize = 16
setBtn.TextColor3 = Color3.new(1,1,1)
setBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
setBtn.BorderSizePixel = 0
Instance.new("UICorner", setBtn).CornerRadius = UDim.new(0,10)
RGBStroke(setBtn)

-- INSTANT STEAL
local tpBtn = Instance.new("TextButton", main)
tpBtn.Size = UDim2.new(.8,0,0,50)
tpBtn.Position = UDim2.new(.1,0,.55,0)
tpBtn.Text = "Instant Steal"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 16
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
tpBtn.BorderSizePixel = 0
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0,10)
RGBStroke(tpBtn)

-- TP FORWARD (DASH)
local dashBtn = Instance.new("TextButton", main)
dashBtn.Size = UDim2.new(.8,0,0,50)
dashBtn.Position = UDim2.new(.1,0,.75,0)
dashBtn.Text = "TP Forward (Dash)"
dashBtn.Font = Enum.Font.GothamBold
dashBtn.TextSize = 16
dashBtn.TextColor3 = Color3.new(1,1,1)
dashBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
dashBtn.BorderSizePixel = 0
Instance.new("UICorner", dashBtn).CornerRadius = UDim.new(0,10)
RGBStroke(dashBtn)

-- =====================
-- LOGIC
-- =====================

-- Save Position
setBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    savedPosition = root.Position
    setBtn.Text = "Position Saved!"
    task.wait(1)
    setBtn.Text = "Set TP"
end)

-- Instant Steal
tpBtn.MouseButton1Click:Connect(function()

    if not savedPosition then
        tpBtn.Text = "No Position Saved!"
        task.wait(1)
        tpBtn.Text = "Instant Steal"
        return
    end

    tpBtn.Text = "Stealing..."
    task.wait(2)

    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    root.CFrame = CFrame.new(savedPosition)

    task.wait(0.5)
    player:Kick("successfuly steal taxed by nethers 🔥 | made by nethers")
end)

-- TP Forward / Dash
dashBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    -- Calcul du dash forward
    local forwardVector = root.CFrame.LookVector
    local newPosition = root.Position + forwardVector * dashDistance
    root.CFrame = CFrame.new(newPosition)
end)
