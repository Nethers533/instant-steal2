local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- =====================
-- CONFIGURATION V11
-- =====================
local Hauteur = 30       -- Axe Y (Hauteur)
local Recul = 94         -- Axe Z (93 + 1m de recul)
local Lateral = -337.0   -- Axe X (-336.5 - 0.5m vers la gauche)
local TARGET_POS = CFrame.new(Lateral, Hauteur, Recul)

local savedPos = nil 
local noclip = false
-- =====================

-- RGB STROKE (Effet arc-en-ciel sur les bordures)
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

-- EFFACER LA LUEUR (FORCEFIELD)
local function removeGlow(char)
    task.wait(0.1)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("ForceField") then v:Destroy() end
    end
end

-- BOUCLE NOCLIP (Permet de flotter sans collision)
RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- AUTO-SET POSITION AU SPAWN (Pour l'Instant Steal)
local function onCharacterAdded(char)
    removeGlow(char)
    local root = char:WaitForChild("HumanoidRootPart", 5)
    if root then
        task.wait(0.5)
        savedPos = root.CFrame
    end
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

-- UI SETUP (Grande et Draggable)
local gui = Instance.new("ScreenGui")
gui.Name = "NethersStealGui"
gui.Parent = PlayerGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 240)
main.Position = UDim2.new(.5,0,.5,0)
main.AnchorPoint = Vector2.new(.5,.5)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)
RGBStroke(main)

-- BARRE DE DRAG (Zone pour déplacer l'UI)
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 45)
dragBar.BackgroundTransparency = 1
dragBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "STEAL EXOTIC V11"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.Parent = main

-- SYSTEME DRAGGABLE
local dragging, dragStart, startPos
dragBar.InputBegan:Connect(function(input)
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

-- BOUTONS
local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(.8,0,0,55)
    btn.Position = UDim2.new(.1,0,posY,0)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    RGBStroke(btn)
    return btn
end

local bestBtn = createButton("TP TO BEST BRAINROT", 0.22)
local stealBtn = createButton("INSTANT STEAL", 0.55)

-- LOGIQUE TP
bestBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        noclip = true 
        root.CFrame = TARGET_POS
        removeGlow(char)
        bestBtn.Text = "TP V11 : OK"
        task.wait(0.8)
        bestBtn.Text = "TP TO BEST BRAINROT"
    end
end)

-- LOGIQUE STEAL (Aller-retour rapide)
stealBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and savedPos then
        local old = root.CFrame
        root.CFrame = savedPos
        task.wait(0.2)
        root.CFrame = old
        stealBtn.Text = "STEAL SUCCESS!"
    else
        stealBtn.Text = "ERREUR SPAWN..."
    end
    task.wait(0.8)
    stealBtn.Text = "INSTANT STEAL"
end)
