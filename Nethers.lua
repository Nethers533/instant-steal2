local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- =====================
-- RGB FUNCTIONS
-- =====================

local function RGBStroke(obj)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = obj

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
-- DRAG SYSTEM (PC + MOBILE OPTIMISÉ)
-- =====================

local function MakeDraggable(frame, dragBar)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
                update(input)
            end
        end
    end)
end

-- =====================
-- UI SETUP
-- =====================

local gui = Instance.new("ScreenGui")
gui.Parent = PlayerGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 260)
main.Position = UDim2.new(.5,0,.5,0)
main.AnchorPoint = Vector2.new(.5,.5)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)
RGBStroke(main)

local top = Instance.new("Frame")
top.Size = UDim2.new(1,0,0,40)
top.BackgroundTransparency = 1
top.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "Steal A Exotic Script"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.Parent = top

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1,0,0,20)
credit.Position = UDim2.new(0,0,0,22)
credit.BackgroundTransparency = 1
credit.Text = "made by nethers 🔥"
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextStrokeTransparency = 0.8
credit.Parent = main
RGBText(credit)

MakeDraggable(main, top)

-- =====================
-- VARIABLES
-- =====================

local savedPosition = nil
local dashDistance = 20

-- =====================
-- BUTTON CREATOR
-- =====================

local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(.8,0,0,45)
    btn.Position = UDim2.new(.1,0,posY,0)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    btn.BorderSizePixel = 0
    btn.Parent = main

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    RGBStroke(btn)

    return btn
end

local setBtn = createButton("Set Position", 0.25)
local stealBtn = createButton("Instant Steal", 0.45)
local dashBtn = createButton("Dash Forward", 0.65)

-- =====================
-- LOGIC
-- =====================

setBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    savedPosition = root.Position
    setBtn.Text = "Position Saved!"
    task.wait(1)
    setBtn.Text = "Set Position"
end)

stealBtn.MouseButton1Click:Connect(function()
    if not savedPosition then
        stealBtn.Text = "No Position Saved!"
        task.wait(1)
        stealBtn.Text = "Instant Steal"
        return
    end

    stealBtn.Text = "Stealing..."
    task.wait(1)

    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    root.CFrame = CFrame.new(savedPosition)

    task.wait(0.5)

    player:Kick("successfuly steal made by nethers 🔥")
end)

dashBtn.MouseButton1Click:Connect(function()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    root.CFrame = root.CFrame + root.CFrame.LookVector * dashDistance
end)
