game.StarterGui:SetCore("SendNotification", {
    Title = "Aura Hub",
    Text = "Success Loading",
    Icon = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420",
    Duration = 5,
    Callback = function()
    end
})
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AuraHub_LoadingScreen"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif getgui then
    ScreenGui.Parent = getgui()
else
    ScreenGui.Parent = CoreGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 15)
UIListLayout.Parent = MainFrame

local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 120, 0, 120)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxthumb://type=Asset&id=131484641795167&w=420&h=420"
Logo.LayoutOrder = 1
Logo.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 500, 0, 50)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Aura Hub | UI_v1.100"
TitleLabel.Font = Enum.Font.FredokaOne
TitleLabel.TextSize = 32
TitleLabel.LayoutOrder = 2
TitleLabel.Parent = MainFrame

local function Map(x, inMin, inMax, outMin, outMax)
    return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

task.spawn(function()
    local counter = 0
    while MainFrame.Parent do
        local hue = Map(counter % 100, 0, 100, 0, 1)
        TitleLabel.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
        counter = counter + 0.1
        task.wait()
    end
end)

local function FadeOutAndDestroy()
    task.wait(3)
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    TweenService:Create(TitleLabel, tweenInfo, {TextTransparency = 1}):Play()
    TweenService:Create(Logo, tweenInfo, {ImageTransparency = 1}):Play()
    
    local backgroundTween = TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 1})
    backgroundTween:Play()
    
    backgroundTween.Completed:Connect(function()
        ScreenGui:Destroy()
    end)
end

task.spawn(function()
    task.spawn(FadeOutAndDestroy)
    
  local TweenService = game:GetService("TweenService")

local TARGET_POSITION = Vector3.new(-38, 17, 38117)
local SPEED = getgenv().Speed or 300 

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local function flyToDestination()
	local startPosition = humanoidRootPart.Position
	local distance = (TARGET_POSITION - startPosition).Magnitude
	local duration = distance / SPEED
	
	local tweenInfo = TweenInfo.new(
		duration,
		Enum.EasingStyle.Linear, 
		Enum.EasingDirection.Out
	)
	
	local targetCFrame = CFrame.new(TARGET_POSITION) * humanoidRootPart.CFrame.Rotation
	local tweenProperties = {CFrame = targetCFrame}
	
	local tween = TweenService:Create(humanoidRootPart, tweenInfo, tweenProperties)
	tween:Play()
end

flyToDestination()
  
end)
