local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UntitledTeleporterUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 170)
frame.Position = UDim2.new(0.5, -140, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.ZIndex = 10
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local shadow = Instance.new("ImageLabel")
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5554236805"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.45
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(23, 23, 277, 277)
shadow.ZIndex = 1
shadow.Parent = frame

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Untitled Teleporter UI"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 10

local closeButton = Instance.new("TextButton")
closeButton.Parent = frame
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BackgroundTransparency = 1
closeButton.ZIndex = 10

closeButton.MouseEnter:Connect(function()
	closeButton.TextColor3 = Color3.fromRGB(255, 150, 150)
end)
closeButton.MouseLeave:Connect(function()
	closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
end)
closeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

local textBox = Instance.new("TextBox")
textBox.Parent = frame
textBox.Size = UDim2.new(1, -30, 0, 40)
textBox.Position = UDim2.new(0, 15, 0, 50)
textBox.PlaceholderText = "Enter player name..."
textBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 16
textBox.ZIndex = 10

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 8)
tbCorner.Parent = textBox

local teleportButton = Instance.new("TextButton")
teleportButton.Parent = frame
teleportButton.Size = UDim2.new(1, -30, 0, 40)
teleportButton.Position = UDim2.new(0, 15, 0, 100)
teleportButton.Text = "Teleport to Player"
teleportButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 16
teleportButton.ZIndex = 10

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = teleportButton

teleportButton.MouseEnter:Connect(function()
	TweenService:Create(teleportButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(85, 125, 245)}):Play()
end)
teleportButton.MouseLeave:Connect(function()
	TweenService:Create(teleportButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 105, 225)}):Play()
end)

local function findClosestPlayerName(inputName)
	local closestPlayer
	local closestDistance = math.huge
	inputName = inputName:lower()
	for _, player in ipairs(Players:GetPlayers()) do
		local name = player.Name:lower()
		if name:sub(1, #inputName) == inputName then
			closestPlayer = player
			break
		else
			local distance = math.abs(#name - #inputName)
			if distance < closestDistance then
				closestDistance = distance
				closestPlayer = player
			end
		end
	end
	return closestPlayer
end

teleportButton.MouseButton1Click:Connect(function()
	local targetName = textBox.Text
	if targetName ~= "" then
		local targetPlayer = findClosestPlayerName(targetName)
		if targetPlayer and targetPlayer.Character and LocalPlayer.Character and
		   targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position + Vector3.new(2,0,0))
			teleportButton.Text = "Teleported!"
		else
			teleportButton.Text = "Teleport failed!"
		end
		task.wait(1)
		teleportButton.Text = "Teleport to Player"
	end
end)

local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
