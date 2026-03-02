local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- =====================
-- SYSTEME DE WHITELIST (VÉRIFICATION RENFORCÉE)
-- =====================
local WhitelistedIDs = {
    ["2354866600"] = true, -- Ton ID
    ["7714389292"] = true  -- ID de ton ami
}

-- On attend que le UserId soit bien chargé par le moteur
if not player.UserId or player.UserId == 0 then
    task.wait(1)
end

local currentId = tostring(player.UserId)

if not WhitelistedIDs[currentId] then
    -- Son d'erreur
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://135431631525798"
    sound.Volume = 10
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    
    task.wait(0.2)
    
    -- Kick immédiat
    player:Kick("\n[SECURITY]\nAccess Denied.\nYour ID: " .. currentId .. "\nBuy here: https://discord.gg/QbAe3zKW")
    return 
end

-- =====================
-- CONFIGURATION POSITION
-- =====================
local Hauteur = 30       
local Recul = 94         
local Lateral = -337.0   
local TARGET_POS = CFrame.new(Lateral, Hauteur, Recul)

local savedPos = nil 
local noclip = false 

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

local function removeGlow(char)
    task.wait(0.1)
    if char then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("ForceField") then v:Destroy() end
        end
    end
end

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    removeGlow(char)
    local root = char:WaitForChild("HumanoidRootPart", 5)
    if root then task.wait(0.5) savedPos = root.CFrame end
end)

if player.Character then 
    removeGlow(player.Character)
    local r = player.Character:FindFirstChild("HumanoidRootPart") 
    if r then savedPos = r.CFrame end 
end

-- =====================
-- INTERFACE GRAPHIQUE
-- =====================
local gui = Instance.new("ScreenGui")
gui.Name = "NethersStealGui"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 240)
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

-- DRAG SYSTEM
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

local bestBtn = createButton("TP TO BEST BRAINROT", 0.25)
local stealBtn = createButton("INSTANT STEAL", 0.60)

bestBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        noclip = true 
        root.CFrame = TARGET_POS
        removeGlow(char)
        task.wait(0.5) 
        noclip = false
        bestBtn.Text = "TP SUCCESS"
        task.wait(0.8)
        bestBtn.Text = "TP TO BEST BRAINROT"
    end
end)

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
        stealBtn.Text = "WAIT FOR SPAWN..."
    end
    task.wait(0.8)
    stealBtn.Text = "INSTANT STEAL"
end)
