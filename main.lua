-- Serviços
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Remotes
local fruitStorageRemote = ReplicatedStorage:WaitForChild("FruitStorageRemote") -- Ajuste conforme necessário
local boneRollRemote = ReplicatedStorage:WaitForChild("BoneRollRemote") -- Ajuste conforme necessário
local killRemote = ReplicatedStorage:WaitForChild("KillRemote") -- Ajuste conforme necessário

-- Configurações
local autoFarmLevelEnabled = true
local autoFarmBoneEnabled = true
local autoRollBoneEnabled = true
local autoKillAllBossesEnabled = true
local autoTeleportFruitEnabled = true
local autoChestEnabled = true

-- Função para mover o jogador para uma nova posição com tween
local function moveToPosition(targetPosition)
    local tweenInfo = TweenInfo.new(
        1, -- Duração do tween (em segundos)
        Enum.EasingStyle.Linear, -- Estilo de interpolação
        Enum.EasingDirection.InOut -- Direção de interpolação
    )
    local goal = {Position = targetPosition}
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
    tween:Play()
end

-- Auto Farm Level
local function autoFarmLevel()
    while autoFarmLevelEnabled do
        -- Lógica para coleta de XP (ajuste conforme necessário)
        wait(5) -- Aguarda 5 segundos antes de tentar novamente
    end
end

-- Auto Farm Bone
local function autoFarmBone()
    while autoFarmBoneEnabled do
        -- Lógica para coleta de ossos (ajuste conforme necessário)
        wait(5) -- Aguarda 5 segundos antes de tentar novamente
    end
end

-- Auto Roll Bone
local function autoRollBone()
    while autoRollBoneEnabled do
        boneRollRemote:FireServer() -- Ajuste conforme necessário
        wait(60) -- Aguarda 60 segundos entre rotação
    end
end

-- Auto Kill All Bosses
local function autoKillAllBosses()
    while autoKillAllBossesEnabled do
        for _, boss in pairs(Workspace:GetChildren()) do
            if boss:IsA("Model") and boss:FindFirstChild("Humanoid") and boss.Name == "Boss" then
                -- Ataca o boss (ajuste conforme necessário)
                killRemote:FireServer(boss) -- Ajuste conforme necessário
            end
        end
        wait(30) -- Aguarda 30 segundos antes de tentar novamente
    end
end

-- Auto Teleport Fruit
local function autoTeleportFruit()
    while autoTeleportFruitEnabled do
        local fruits = Workspace:FindPartsInRegion3(Workspace.CurrentCamera.CFrame:ToWorldSpace(character.HumanoidRootPart.CFrame).CFrame:ToRegion3(), nil, 100)
        for _, part in pairs(fruits) do
            if part:IsA("Part") and part.Name == "Fruit" then
                moveToPosition(part.Position)
                wait(1) -- Aguarda o tween terminar
                -- Simula a coleta da fruta
                local proximityPrompt = part:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt then
                    proximityPrompt:InputBegan()
                end
            end
        end
        wait(10) -- Aguarda 10 segundos antes de procurar novamente
    end
end

-- Auto Chest
local function autoChest()
    while autoChestEnabled do
        local chests = Workspace:FindPartsInRegion3(Workspace.CurrentCamera.CFrame:ToWorldSpace(character.HumanoidRootPart.CFrame).CFrame:ToRegion3(), nil, 100)
        for _, part in pairs(chests) do
            if part:IsA("Part") and part.Name == "Chest" then
                moveToPosition(part.Position)
                wait(1) -- Aguarda o tween terminar
                -- Simula a coleta do baú
                local proximityPrompt = part:FindFirstChildOfClass("ProximityPrompt")
                if proximityPrompt then
                    proximityPrompt:InputBegan()
                end
            end
        end
        wait(15) -- Aguarda 15 segundos antes de procurar novamente
    end
end

-- Função para trocar de servidor
local function serverHop()
    local placeId = game.PlaceId
    TeleportService:Teleport(placeId, player) -- Teleporta o jogador para o mesmo lugar em um novo servidor
end

-- Executar todas as funcionalidades automaticamente
spawn(autoFarmLevel)
spawn(autoFarmBone)
spawn(autoRollBone)
spawn(autoKillAllBosses)
spawn(autoTeleportFruit)
spawn(autoChest)

-- Criar a UI de controle
local TweenService = game:GetService("TweenService")
local playerGui = player:WaitForChild("PlayerGui")

-- Criar a UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ControlGui"
screenGui.Parent = playerGui

local controlFrame = Instance.new("Frame")
controlFrame.Name = "ControlFrame"
controlFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
controlFrame.Position = UDim2.new(0.7, 0, 0.25, 0)
controlFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
controlFrame.BackgroundTransparency = 0.5
controlFrame.BorderSizePixel = 0
controlFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Blox Fruits Auto Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = controlFrame

-- Funções para criar botões
local function createToggleButton(name, position, toggleFunc)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 0.1, 0)
    button.Position = position
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    button.BackgroundTransparency = 0.5
    button.Parent = controlFrame

    button.MouseButton1Click:Connect(function()
        toggleFunc()
    end)
end

-- Estado dos toggles
local function toggleAutoFarmLevel()
    autoFarmLevelEnabled = not autoFarmLevelEnabled
    updateButton(controlFrame:FindFirstChild("Auto Farm Level"), autoFarmLevelEnabled)
end

local function toggleAutoFarmBone()
    autoFarmBoneEnabled = not autoFarmBoneEnabled
    updateButton(controlFrame:FindFirstChild("Auto Farm Bone"), autoFarmBoneEnabled)
end

local function toggleAutoRollBone()
    autoRollBoneEnabled = not autoRollBoneEnabled
    updateButton(controlFrame:FindFirstChild("Auto Roll Bone"), autoRollBoneEnabled)
end

local function toggleAutoKillAllBosses()
    autoKillAllBossesEnabled = not autoKillAllBossesEnabled
    updateButton(controlFrame:FindFirstChild("Auto Kill Bosses"), autoKillAllBossesEnabled)
end

local function toggleAutoTeleportFruit()
    autoTeleportFruitEnabled = not autoTeleportFruitEnabled
    updateButton(controlFrame:FindFirstChild("Auto Teleport Fruit"), autoTeleportFruitEnabled)
end

local function toggleAutoChest()
    autoChestEnabled = not autoChestEnabled
    updateButton(controlFrame:FindFirstChild("Auto Chest"), autoChestEnabled)
end

-- Função para atualizar o botão de acordo com o estado
local function updateButton(button, enabled)
    if enabled then
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        button.Text = button.Name .. " [ON]"
    else
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        button.Text = button.Name .. " [OFF]"
    end
end

-- Criar botões para cada funcionalidade
createToggleButton("Auto Farm Level", UDim2.new(0, 0, 0.1, 0), toggleAutoFarmLevel)
createToggleButton("Auto Farm Bone", UDim2.new(0, 0, 0.2, 0), toggleAutoFarmBone)
createToggleButton("Auto Roll Bone", UDim2.new(0, 0, 0.3, 0), toggleAutoRollBone)
createToggleButton("Auto Kill Bosses", UDim2.new(0, 0, 0.4, 0), toggleAutoKillAllBosses)
createToggleButton("Auto Teleport Fruit", UDim2.new(0, 0, 0.5, 0), toggleAutoTeleportFruit)
createToggleButton("Auto Chest", UDim2.new(0, 0, 0.6, 0), toggleAutoChest)

-- Atualizar o estado inicial dos botões
for _, button in pairs(controlFrame:GetChildren()) do
    if button:IsA("TextButton") then
        local state = false
        if button.Name == "Auto Farm Level" then
            state = autoFarmLevelEnabled
        elseif button.Name == "Auto Farm Bone" then
            state = autoFarmBoneEnabled
        elseif button.Name == "Auto Roll Bone" then
            state = autoRollBoneEnabled
        elseif button.Name == "Auto Kill Bosses" then
            state = autoKillAllBossesEnabled
        elseif button.Name == "Auto Teleport Fruit" then
            state = autoTeleportFruitEnabled
        elseif button.Name == "Auto Chest" then
            state = autoChestEnabled
        end
        updateButton(button, state)
    end
end

-- Atualizar o estado dos botões quando clicados
for _, button in pairs(controlFrame:GetChildren()) do
    if button:IsA("TextButton") then
        button.MouseButton1Click:Connect(function()
            local toggleFunc
            if button.Name == "Auto Farm Level" then
                toggleFunc = toggleAutoFarmLevel
            elseif button.Name == "Auto Farm Bone" then
                toggleFunc = toggleAutoFarmBone
            elseif button.Name == "Auto Roll Bone" then
                toggleFunc = toggleAutoRollBone
            elseif button.Name == "Auto Kill Bosses" then
                toggleFunc = toggleAutoKillAllBosses
            elseif button.Name == "Auto Teleport Fruit" then
                toggleFunc = toggleAutoTeleportFruit
            elseif button.Name == "Auto Chest" then
                toggleFunc = toggleAutoChest
            end
            if toggleFunc then
                toggleFunc()
                updateButton(button, button.BackgroundColor3 == Color3.fromRGB(255, 0, 0))
            end
        end)
    end
end
