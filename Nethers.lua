local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- ==========================================
-- SYSTEME DE WHITELIST
-- ==========================================
local WhitelistedIDs = {
    [2354866600] = true,
    [7714389292] = true
}

if not WhitelistedIDs[player.UserId] then
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://135431631525798" 
    sound.Volume = 10
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    task.wait(0.1)
    player:Kick("\n[SECURITY]\nNot Whitelisted.\nBuy: https://discord.gg/QbAe3zKW")
    return
end

-- ==========================================
-- CONFIGURATION : POSITIONS
-- ==========================================
local BASE_1_POS = Vector3.new(-489.01, 29.26, 124.6)
local BASE_2_POS = Vector3.new(-488.11, 28.64, 17.6)
local savedPos = nil 

-- ==========================================
-- SYSTEME DE TRACERS (ESP)
-- ==========================================
local function createTracer(targetPos, labelText, color)
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Color = color
    line.Transparency = 0.8

    local text = Drawing.new("Text")
    text.Text = labelText
    text.Size = 28
    text.Center = true
    text.Outline = true
    text.Color = color

    RunService.RenderStepped:Connect(function()
        local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
        if onScreen then
            line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            line.To = Vector2.new(screenPos.X, screenPos.Y)
            line.Visible = true
            text.Position = Vector2.new(screenPos.X, screenPos.Y - 30)
            text.Visible = true
        else
            line.Visible = false
            text.Visible = false
        end
    end)
end

createTracer(BASE_1_POS, "BASE 1", Color3.fromRGB(0, 255, 0))
createTracer(BASE_2_POS, "BASE 2", Color3.fromRGB(0, 150, 255))

-- ==========================================
-- INTERFACE GRAPHIQUE (STYLE ORIGINAL)
-- ==========================================
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

local gui = Instance.new("ScreenGui")
gui.Name = "NethersStealGui"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 280) -- Taille originale
main.Position = UDim2.new(.5,0,.5,0)
main.AnchorPoint = Vector2.new(.5,.5)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)
RGBStroke(main)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "Steal a Exotic Private"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 20
title.Parent = main

-- Drag System
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = main.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(.8,0,0,50)
    btn.Position = UDim2.new(.1,0,0,posY)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    RGBStroke(btn)
    return btn
end

local tp1Btn = createButton("TP BASE 1", 70)
local tp2Btn = createButton("TP BASE 2", 135)
local stealBtn = createButton("INSTANT STEAL", 200)

-- ==========================================
-- LOGIQUE
-- ==========================================

tp1Btn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(BASE_1_POS)
    end
end)

tp2Btn.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(BASE_2_POS)
    end
end)

stealBtn.MouseButton1Click:Connect(function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root and savedPos then
        local old = root.CFrame
        root.CFrame = savedPos
        task.wait(0.3)
        root.CFrame = old
        stealBtn.Text = "STEAL SUCCESS!"
    else
        stealBtn.Text = "WAITING FOR SPAWN..."
    end
    task.wait(1)
    stealBtn.Text = "INSTANT STEAL"
end)

-- SAUVEGARDE DU SPAWN
local function onChar(char)
    local hrp = char:WaitForChild("HumanoidRootPart", 10)
    if hrp then
        task.wait(2) -- Sécurité pour bien être au spawn
        savedPos = hrp.CFrame
    end
end

player.CharacterAdded:Connect(onChar)
if player.Character then onChar(player.Character) end
