local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
frame.Size = UDim2.new(0, 320, 0, 320)
frame.Position = UDim2.new(0.5, -160, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.ZIndex = 10
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, -40, 0, 30)
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
textBox.Size = UDim2.new(1, -30, 0, 35)
textBox.Position = UDim2.new(0, 15, 0, 40)
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
teleportButton.Size = UDim2.new(0.5, -20, 0, 35)
teleportButton.Position = UDim2.new(0, 15, 0, 85)
teleportButton.Text = "Teleport"
teleportButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 16
teleportButton.ZIndex = 10

local teleportAllButton = Instance.new("TextButton")
teleportAllButton.Parent = frame
teleportAllButton.Size = UDim2.new(0.5, -20, 0, 35)
teleportAllButton.Position = UDim2.new(0.5, 5, 0, 85)
teleportAllButton.Text = "Teleport All"
teleportAllButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
teleportAllButton.TextColor3 = Color3.new(1, 1, 1)
teleportAllButton.Font = Enum.Font.GothamBold
teleportAllButton.TextSize = 16
teleportAllButton.ZIndex = 10

local listFrame = Instance.new("ScrollingFrame")
listFrame.Parent = frame
listFrame.Size = UDim2.new(1, -30, 1, -135)
listFrame.Position = UDim2.new(0, 15, 0, 130)
listFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
listFrame.ScrollBarThickness = 6
listFrame.BorderSizePixel = 0
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ZIndex = 10

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = listFrame

local layout = Instance.new("UIListLayout")
layout.Parent = listFrame
layout.Padding = UDim.new(0, 5)

local function findClosestPlayerName(inputName)
	local closestPlayer
	local closestDistance = math.huge
	inputName = inputName:lower()
	for _, player in ipairs(Players:GetPlayers()) do
		local name = player.Name:lower()
		if name:sub(1, #inputName) == inputName then
			return player
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

local function teleportToPlayer(targetPlayer)
	if targetPlayer and targetPlayer.Character and LocalPlayer.Character and
		targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position + Vector3.new(2,0,0))
	end
end

local function refreshPlayerList()
	for _, child in ipairs(listFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local button = Instance.new("TextButton")
			button.Parent = listFrame
			button.Size = UDim2.new(1, -10, 0, 30)
			button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
			button.TextColor3 = Color3.new(1, 1, 1)
			button.Text = player.Name
			button.Font = Enum.Font.Gotham
			button.TextSize = 14
			button.ZIndex = 10
			local bc = Instance.new("UICorner")
			bc.CornerRadius = UDim.new(0, 6)
			bc.Parent = button
			button.MouseButton1Click:Connect(function()
				teleportToPlayer(player)
			end)
			button.MouseEnter:Connect(function()
				TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(75, 75, 75)}):Play()
			end)
			button.MouseLeave:Connect(function()
				TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}):Play()
			end)
		end
	end
	listFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

refreshPlayerList()
task.spawn(function()
	while task.wait(10) do
		if frame.Visible then
			refreshPlayerList()
		end
	end
end)

teleportButton.MouseButton1Click:Connect(function()
	local targetName = textBox.Text
	if targetName ~= "" then
		local targetPlayer = findClosestPlayerName(targetName)
		if targetPlayer then
			teleportToPlayer(targetPlayer)
			teleportButton.Text = "Teleported!"
			task.wait(1)
			teleportButton.Text = "Teleport"
		else
			teleportButton.Text = "Not found!"
			task.wait(1)
			teleportButton.Text = "Teleport"
		end
	end
end)

teleportAllButton.MouseButton1Click:Connect(function()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			teleportToPlayer(player)
			task.wait(0.1)
		end
	end
	teleportAllButton.Text = "Teleported All!"
	task.wait(1)
	teleportAllButton.Text = "Teleport All"
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
