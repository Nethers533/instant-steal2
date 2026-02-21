local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")

local tpPosition = hrp.CFrame

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NethersTP"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0.5, -100, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0

local function makeButton(text, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60,120,255)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0
    return btn
end

local setTP = makeButton("Set TP", 10)
local normalTP = makeButton("TP", 50)
local forwardBtn = makeButton("TP Forward", 90)

local credit = Instance.new("TextLabel", frame)
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -20)
credit.BackgroundTransparency = 1
credit.Text = "Made by Nethers"
credit.TextColor3 = Color3.fromRGB(180,180,180)
credit.Font = Enum.Font.SourceSans
credit.TextSize = 14

-- SET TP
setTP.MouseButton1Click:Connect(function()
    tpPosition = hrp.CFrame
end)

-- TP TEMPORAIRE
local function doTempTP()
    local old = hrp.CFrame
    hrp.CFrame = tpPosition
    task.wait(0.5)
    hrp.CFrame = old
end

-- TP NORMAL
local function doNormalTP()
    hrp.CFrame = tpPosition
end

-- NOCLIP UTILS
local function setCollision(state)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = state
        end
    end
end

-- TP FORWARD AVEC NOCLIP
local function tpForward(distance, steps)
    distance = distance or 8
    steps = steps or 25
    
    local stepSize = distance / steps
    
    setCollision(false) -- noclip ON
    
    for i = 1, steps do
        hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * stepSize)
        task.wait()
    end
    
    setCollision(true) -- noclip OFF
end

-- BOUTONS
normalTP.MouseButton1Click:Connect(doNormalTP)
forwardBtn.MouseButton1Click:Connect(tpForward)

-- TOUCHES CLAVIER
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        doTempTP()
        
    elseif input.KeyCode == Enum.KeyCode.G then
        doNormalTP()
        
    elseif input.KeyCode == Enum.KeyCode.R then
        tpForward()
    end
end)
