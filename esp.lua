local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function createBox(character)
    local box = Instance.new("Part")
    box.Name = "PlayerBox"
    box.Size = character:GetExtentsSize()
    box.Transparency = 0.5
    box.Material = Enum.Material.ForceField
    box.CanCollide = false
    box.Anchored = false
    box.Parent = character

    local function updateBoxSize()
        box.Size = character:GetExtentsSize()
    end

    character:FindFirstChild("HumanoidRootPart"):Connect(function()
        updateBoxSize()
    end)

    character.ChildAdded:Connect(function(child)
        if child:IsA("BasePart") then
            child:FindFirstChild("Size"):Connect(function()
                updateBoxSize()
            end)
        end
    end)

    character.ChildRemoved:Connect(function(child)
        if child:IsA("BasePart") then
            updateBoxSize()
        end
    end)

    RunService.RenderStepped:Connect(function()
        if character:FindFirstChild("HumanoidRootPart") then
            box.CFrame = character.HumanoidRootPart.CFrame
        end
    end)

    return box
end

local function onCharacterAdded(character)
    local box = createBox(character)

    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = playerGui

    local toggleButton = Instance.new("TextButton")
    toggleButton.Text = "Toggle Box"
    toggleButton.Size = UDim2.new(0, 100, 0, 50)
    toggleButton.Position = UDim2.new(0.5, -50, 0.5, -25)
    toggleButton.Parent = screenGui

    local isVisible = true

    toggleButton.MouseButton1Click:Connect(function()
        isVisible = not isVisible
        box.Visible = isVisible
    end)
end

local player = Players.LocalPlayer
player.CharacterAdded:Connect(onCharacterAdded)

if player.Character then
    onCharacterAdded(player.Character)
end

