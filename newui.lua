-- [[ DARKRAI UI REMAKE - PART 1: SYSTEM & FLOATING TOGGLE ]] --
local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)

if not game:IsLoaded() then 
    repeat game.Loaded:Wait() until game:IsLoaded() 
end

repeat task.wait() until game:GetService("Players")

if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
    repeat task.wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") 
end
    
task.wait(1)

do 
    local GUI = game.CoreGui:FindFirstChild("Darkrai")
    if GUI then GUI:Destroy() end
    -- Đổi màu chủ đạo thành Đỏ chuẩn Gaming
    _G.Color = Color3.fromRGB(220, 20, 20)
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Hàm kéo thả mượt mà cho cả PC và Mobile
local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, startPosition.Y.Offset + Delta.Y)
		TweenService:Create(object, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = pos}):Play()
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			dragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then Dragging = false end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then Update(input) end
	end)
end

local DarkraiX = {}

function DarkraiX:Window(text, gamenme, logo, keybind)
    local hubname = text
    local gamename = gamenme
	local uihide = false
	local abc = false
	local currentpage = ""
	local keybind = keybind or Enum.KeyCode.RightControl
	local yoo = string.gsub(tostring(keybind), "Enum.KeyCode.", "")
	if gamename == "" or gamename == nil then gamename = tostring(PlaceName.Name) end
	
	local Darkrai = Instance.new("ScreenGui")
	Darkrai.Name = "Darkrai"
	Darkrai.Parent = game.CoreGui
	Darkrai.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- PANEL CHÍNH: Fix cứng kích thước 600x340 theo ý mày
	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Parent = Darkrai
	Main.ClipsDescendants = true
	Main.AnchorPoint = Vector2.new(0.5, 0.5)
	Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Đen huyền bí
	Main.Position = UDim2.new(0.5, 0, 0.5, 0)
	Main.Size = UDim2.new(0, 600, 0, 340)
	
	local MCNR = Instance.new("UICorner")
	MCNR.CornerRadius = URadius.new(0, 8)
	MCNR.Parent = Main

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = Color3.fromRGB(35, 35, 35)
	MainStroke.Thickness = 1
	MainStroke.Parent = Main

	-- NÚT BẬT TẮT UI GÓC TRÁI MÀN HÌNH (Không cần phím)
	local ToggleButton = Instance.new("TextButton")
	ToggleButton.Name = "MobileToggle"
	ToggleButton.Parent = Darkrai
	ToggleButton.Size = UDim2.new(0, 42, 0, 42)
	ToggleButton.Position = UDim2.new(0, 15, 0.4, 0)
	ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	ToggleButton.Text = "🔴"
	ToggleButton.TextSize = 16
	ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	MakeDraggable(ToggleButton, ToggleButton) -- Cho phép kéo nút đi chỗ khác nếu vướng

	local TGCorner = Instance.new("UICorner")
	TGCorner.CornerRadius = URadius.new(1, 0)
	TGCorner.Parent = ToggleButton

	local TGStroke = Instance.new("UIStroke")
	TGStroke.Color = _G.Color
	TGStroke.Thickness = 1.5
	TGStroke.Parent = ToggleButton

	ToggleButton.MouseButton1Click:Connect(function()
		uihide = not uihide
		Main.Visible = not uihide
		ToggleButton.Text = uihide and "⚫" or "🔴"
	end)
	-- [[ DARKRAI UI REMAKE - PART 2: TOPBAR & CLEAN SIDEBAR ]] --
	local Top = Instance.new("Frame")
	Top.Name = "Top"
	Top.Parent = Main
	Top.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	Top.Size = UDim2.new(1, 0, 0, 32)

	local TCNR = Instance.new("UICorner")
	TCNR.CornerRadius = URadius.new(0, 8)
	TCNR.Parent = Top

	local Name = Instance.new("TextLabel")
	Name.Name = "Name"
	Name.Parent = Top
	Name.BackgroundTransparency = 1.000
	Name.Position = UDim2.new(0, 12, 0, 0)
	Name.Size = UDim2.new(0, 120, 1, 0)
	Name.Font = Enum.Font.GothamBold
	Name.Text = hubname
	Name.TextColor3 = _G.Color -- Màu đỏ
	Name.TextSize = 14.000
	Name.TextXAlignment = Enum.TextXAlignment.Left

	local Hub = Instance.new("TextLabel")
	Hub.Name = "Hub"
	Hub.Parent = Top
	Hub.BackgroundTransparency = 1.000
	Hub.Position = UDim2.new(0, 100, 0, 0)
	Hub.Size = UDim2.new(1, -110, 1, 0)
	Hub.Font = Enum.Font.GothamBold
	Hub.Text = "  |  " .. gamename
	Hub.TextColor3 = Color3.fromRGB(180, 180, 180)
	Hub.TextSize = 13.000
	Hub.TextXAlignment = Enum.TextXAlignment.Left

	-- THANH CHỨA TAB (Gọn gàng bên trái)
	local Tab = Instance.new("Frame")
	Tab.Name = "Tab"
	Tab.Parent = Main
	Tab.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	Tab.Position = UDim2.new(0, 6, 0, 38)
	Tab.Size = UDim2.new(0, 140, 0, 296)

	local TBCNR = Instance.new("UICorner")
	TBCNR.CornerRadius = URadius.new(0, 6)
	TBCNR.Parent = Tab

	local ScrollTab = Instance.new("ScrollingFrame")
	ScrollTab.Name = "ScrollTab"
	ScrollTab.Parent = Tab
	ScrollTab.Active = true
	ScrollTab.BackgroundTransparency = 1.000
	ScrollTab.Size = UDim2.new(1, 0, 1, 0)
	ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollTab.ScrollBarThickness = 0

	local PLL = Instance.new("UIListLayout")
	PLL.Parent = ScrollTab
	PLL.SortOrder = Enum.SortOrder.LayoutOrder
	PLL.Padding = UDim.new(0, 8)

	local PPD = Instance.new("UIPadding")
	PPD.Parent = ScrollTab
	PPD.PaddingLeft = UDim.new(0, 8)
	PPD.PaddingTop = UDim.new(0, 8)

	local Page = Instance.new("Frame")
	Page.Name = "Page"
	Page.Parent = Main
	Page.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	Page.Position = UDim2.new(0, 152, 0, 38)
	Page.Size = UDim2.new(0, 442, 0, 296)

	local PCNR = Instance.new("UICorner")
	PCNR.CornerRadius = URadius.new(0, 6)
	PCNR.Parent = Page

	local MainPage = Instance.new("Frame")
	MainPage.Name = "MainPage"
	MainPage.Parent = Page
	MainPage.ClipsDescendants = true
	MainPage.BackgroundTransparency = 1.000
	MainPage.Size = UDim2.new(1, 0, 1, 0)

	local PageList = Instance.new("Folder")
	PageList.Name = "PageList"
	PageList.Parent = MainPage

	local UIPageLayout = Instance.new("UIPageLayout")
	UIPageLayout.Parent = PageList
	UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
	UIPageLayout.FillDirection = Enum.FillDirection.Vertical
	UIPageLayout.TweenTime = 0.35
	UIPageLayout.ScrollWheelInputEnabled = false
	UIPageLayout.TouchInputEnabled = false
	
	MakeDraggable(Top, Main)

	-- Vẫn giữ tính năng ẩn/hiện bằng phím dự phòng nếu cần
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode[yoo] then
			uihide = not uihide
			Main.Visible = not uihide
		end
	end)
	
	local uitab = {}
	-- [[ DARKRAI UI REMAKE - PART 3: BUTTON, TOGGLE, SLIDER ]] --
	function uitab:Tab(text)
		local TabButton = Instance.new("TextButton")
		TabButton.Parent = ScrollTab
		TabButton.Name = text .. "Server"
		TabButton.Text = text
		TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		-- GIẢI QUYẾT: Không viền tím, chữ in đậm hoàn toàn
        TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(0, 124, 0, 28)
		TabButton.Font = Enum.Font.GothamBold
		TabButton.TextColor3 = Color3.fromRGB(160, 160, 160)
		TabButton.TextSize = 13.000

		local TBCor = Instance.new("UICorner")
		TBCor.CornerRadius = URadius.new(0, 4)
		TBCor.Parent = TabButton

		local MainFramePage = Instance.new("ScrollingFrame")
		MainFramePage.Name = text .. "_Page"
		MainFramePage.Parent = PageList
		MainFramePage.Active = true
		MainFramePage.BackgroundTransparency = 1.000
		MainFramePage.BorderSizePixel = 0
		MainFramePage.Size = UDim2.new(1, 0, 1, 0)
		MainFramePage.CanvasSize = UDim2.new(0, 0, 0, 0)
		MainFramePage.ScrollBarThickness = 2
		MainFramePage.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
		
		local UIPadding = Instance.new("UIPadding")
		local UIListLayout = Instance.new("UIListLayout")
		
		UIPadding.Parent = MainFramePage
		UIPadding.PaddingLeft = UDim.new(0, 10)
		UIPadding.PaddingTop = UDim.new(0, 10)

		UIListLayout.Padding = UDim.new(0, 8)
		UIListLayout.Parent = MainFramePage
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		
		TabButton.MouseButton1Click:Connect(function()
			for i, v in next, ScrollTab:GetChildren() do
				if v:IsA("TextButton") then
					TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(160, 160, 160), BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
				end
			end
			TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = _G.Color}):Play()
			
			for i, v in next, PageList:GetChildren() do
				currentpage = string.gsub(TabButton.Name, "Server", "") .. "_Page"
				if v.Name == currentpage then UIPageLayout:JumpTo(v) end
			end
		end)

		if abc == false then
			TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			TabButton.BackgroundColor3 = _G.Color
			UIPageLayout:JumpToIndex(1)
			abc = true
		end
		
		MainFramePage.ChildAdded:Connect(function()
			MainFramePage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
		end)
		ScrollTab.CanvasSize = UDim2.new(0, 0, 0, PLL.AbsoluteContentSize.Y + 20)
		
		local main = {}
		
		function main:Button(text, callback)
			local Button = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local TextBtn = Instance.new("TextButton")
			
			Button.Name = "Button"
			Button.Parent = MainFramePage
			Button.BackgroundColor3 = _G.Color -- Màu đỏ viền
			Button.Size = UDim2.new(0, 420, 0, 30)
			
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = Button
			
			TextBtn.Name = "TextBtn"
			TextBtn.Parent = Button
			TextBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
			TextBtn.Position = UDim2.new(0, 1, 0, 1)
			TextBtn.Size = UDim2.new(0, 418, 0, 28)
			TextBtn.Font = Enum.Font.GothamBold
			TextBtn.Text = text
			TextBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
			TextBtn.TextSize = 13.000
			Instance.new("UICorner").CornerRadius = URadius.new(0, 4)
			TextBtn.UICorner.Parent = TextBtn
			
			TextBtn.MouseButton1Click:Connect(function() pcall(callback) end)
		end

		function main:Toggle(text, config, callback)
			config = config or false
			local toggled = config
			local Toggle = Instance.new("Frame")
			local Button = Instance.new("TextButton")
			local Label = Instance.new("TextLabel")
			local ToggleImage = Instance.new("Frame")
			local Circle = Instance.new("Frame")

			Toggle.Name = "Toggle"
			Toggle.Parent = MainFramePage
			Toggle.BackgroundColor3 = _G.Color
			Toggle.Size = UDim2.new(0, 420, 0, 32)
			Instance.new("UICorner").CornerRadius = URadius.new(0, 4)
			Toggle.UICorner.Parent = Toggle

			Button.Name = "Button"
			Button.Parent = Toggle
			Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
			Button.Position = UDim2.new(0, 1, 0, 1)
			Button.Size = UDim2.new(0, 418, 0, 30)
			Instance.new("UICorner").CornerRadius = URadius.new(0, 4)
			Button.UICorner.Parent = Button

			Label.Name = "Label"
			Label.Parent = Toggle
			Label.BackgroundTransparency = 1.000
			Label.Position = UDim2.new(0, 12, 0, 0)
			Label.Size = UDim2.new(0, 300, 1, 0)
			Label.Font = Enum.Font.GothamBold
			Label.Text = text
			Label.TextColor3 = Color3.fromRGB(230, 230, 230)
			Label.TextSize = 13.000
			Label.TextXAlignment = Enum.TextXAlignment.Left

			ToggleImage.Name = "ToggleImage"
			ToggleImage.Parent = Toggle
			ToggleImage.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			ToggleImage.Position = UDim2.new(0, 370, 0, 7)
			ToggleImage.Size = UDim2.new(0, 36, 0, 18)
			Instance.new("UICorner").CornerRadius = URadius.new(1, 0)
			ToggleImage.UICorner.Parent = ToggleImage

			Circle.Name = "Circle"
			Circle.Parent = ToggleImage
			Circle.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
			Circle.Position = UDim2.new(0, 2, 0, 2)
			Circle.Size = UDim2.new(0, 14, 0, 14)
			Instance.new("UICorner").CornerRadius = URadius.new(1, 0)
			Circle.UICorner.Parent = Circle

			local function updateToggle()
				local targetX = toggled and 20 or 2
				local targetColor = toggled and _G.Color or Color3.fromRGB(120, 30, 30)
				Circle:TweenPosition(UDim2.new(0, targetX, 0, 2), "Out", "Quad", 0.15, true)
				TweenService:Create(Circle, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
				pcall(callback, toggled)
			end

			Button.MouseButton1Click:Connect(function() toggled = not toggled updateToggle() end)
			if config == true then updateToggle() end
		end

		function main:Slider(text, min, max, set, callback)
			local Slider = Instance.new("Frame")
			local sliderr = Instance.new("Frame")
			local SliderLabel = Instance.new("TextLabel")
			local AHEHE = Instance.new("TextButton")
			local bar = Instance.new("Frame")
			local bar1 = Instance.new("Frame")
			local circlebar = Instance.new("Frame")
			local TextBox = Instance.new("TextBox")

			Slider.Name = "Slider"
			Slider.Parent = MainFramePage
			Slider.BackgroundColor3 = _G.Color
			Slider.Size = UDim2.new(0, 420, 0, 46)
			Instance.new("UICorner").CornerRadius = URadius.new(0, 4)
			Slider.UICorner.Parent = Slider

			sliderr.Name = "sliderr"
			sliderr.Parent = Slider
			sliderr.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
			sliderr.Position = UDim2.new(0, 1, 0, 1)
			sliderr.Size = UDim2.new(0, 418, 0, 44)
			Instance.new("UICorner").CornerRadius = URadius.new(0, 4)
			sliderr.UICorner.Parent = sliderr

			SliderLabel.Name = "SliderLabel"
			SliderLabel.Parent = sliderr
			SliderLabel.BackgroundTransparency = 1.000
			SliderLabel.Position = UDim2.new(0, 12, 0, 4)
			SliderLabel.Size = UDim2.new(0, 200, 0, 20)
			SliderLabel.Font = Enum.Font.GothamBold
			SliderLabel.Text = text
			SliderLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
			SliderLabel.TextSize = 13.000
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

			AHEHE.Name = "AHEHE"
			AHEHE.Parent = sliderr
			AHEHE.BackgroundTransparency = 1.000
			AHEHE.Position = UDim2.new(0, 12, 0, 30)
			AHEHE.Size = UDim2.new(0, 394, 0, 6)
			AHEHE.Text = ""

			bar.Name = "bar"
			bar.Parent = AHEHE
			bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			bar.Size = UDim2.new(1, 0, 1, 0)
			Instance.new("UICorner").Parent = bar

			bar1.Name = "bar1"
			bar1.Parent = bar
			bar1.BackgroundColor3 = _G.Color
			bar1.Size = UDim2.new((set - min)/(max - min), 0, 1, 0)
			Instance.new("UICorner").Parent = bar1

			circlebar.Name = "circlebar"
			circlebar.Parent = bar1
			circlebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			circlebar.Position = UDim2.new(1, -3, 0.5, -4)
			circlebar.Size = UDim2.new(0, 8, 0, 8)
			Instance.new("UICorner").Parent = circlebar

			TextBox.Parent = sliderr
			TextBox.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
			TextBox.Position = UDim2.new(0, 355, 0, 5)
			TextBox.Size = UDim2.new(0, 50, 0, 18)
			TextBox.Font = Enum.Font.GothamBold
			TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBox.TextSize = 11.000
			TextBox.Text = tostring(set)
			Instance.new("UICorner").CornerRadius = URadius.new(0, 3)
			TextBox.UICorner.Parent = TextBox

			local mouse = game.Players.LocalPlayer:GetMouse()
			local uis = game:GetService("UserInputService")
			local Value = set

			local function updateSlider(val)
				Value = math.clamp(math.round(val), min, max)
				TextBox.Text = tostring(Value)
				bar1.Size = UDim2.new((Value - min)/(max - min), 0, 1, 0)
				pcall(callback, Value)
			end

			AHEHE.MouseButton1Down:Connect(function()
				local moveconn, releaseconn
				local function snap()
					local percentage = math.clamp((mouse.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					updateSlider(min + (percentage * (max - min)))
				end
				snap()
				moveconn = mouse.Move:Connect(snap)
				releaseconn = uis.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						moveconn:Disconnect()
						releaseconn:Disconnect()
					end
				end)
			end)

			TextBox.FocusLost:Connect(function()
				local n = tonumber(TextBox.Text)
				if n then updateSlider(n) else TextBox.Text = tostring(Value) end
			end)
		end
		-- [[ DARKRAI UI REMAKE - PART 4: TEXTBOX, DROPDOWN & EXPORT ]] --
		function main:Dropdown(text, option, callback)
			local isdropping = false
			local Dropdown = Instance.new("Frame")
			local DropTitle = Instance.new("TextLabel")
			local DropScroll = Instance.new("ScrollingFrame")
			local UIListLayout = Instance.new("UIListLayout")
			local DropButton = Instance.new("TextButton")
			
			Dropdown.Name = "Dropdown"
			Dropdown.Parent = MainFramePage
			Dropdown.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
			Dropdown.ClipsDescendants = true
			Dropdown.Size = UDim2.new(0, 420, 0, 32)
			Instance.new("UICorner").CornerRadius = URadius.new(0, 4)
			Dropdown.UICorner.Parent = Dropdown
			
			local DropStroke = Instance.new("UIStroke")
			DropStroke.Color = Color3.fromRGB(45, 45, 45)
			DropStroke.Parent = Dropdown
			
			DropTitle.Name = "DropTitle"
			DropTitle.Parent = Dropdown
			DropTitle.BackgroundTransparency = 1.000
			DropTitle.Size = UDim2.new(0, 420, 0, 32)
			DropTitle.Font = Enum.Font.GothamBold
			DropTitle.Text = "  " .. text .. " : "
			DropTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
			DropTitle.TextSize = 13.000
			DropTitle.TextXAlignment = Enum.TextXAlignment.Left
			
			DropScroll.Name = "DropScroll"
			DropScroll.Parent = DropTitle
			DropScroll.Active = true
			DropScroll.BackgroundTransparency = 1.000
			DropScroll.BorderSizePixel = 0
			DropScroll.Position = UDim2.new(0, 0, 0, 32)
			DropScroll.Size = UDim2.new(0, 420, 0, 90)
			DropScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
			DropScroll.ScrollBarThickness = 2
			
			UIListLayout.Parent = DropScroll
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 4)
			Instance.new("UIPadding").PaddingLeft = UDim.new(0, 12)
			DropScroll.UIPadding.Parent = DropScroll
			
			DropButton.Name = "DropButton"
			DropButton.Parent = Dropdown
			DropButton.BackgroundTransparency = 1.000
			DropButton.Size = UDim2.new(1, 0, 0, 32)
			DropButton.Text = ""

			local function createItems()
				for _, child in pairs(DropScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
				for _, v in next, option do
					local Item = Instance.new("TextButton")
					Item.Name = "Item"
					Item.Parent = DropScroll
					Item.BackgroundTransparency = 1.000
					Item.Size = UDim2.new(0, 400, 0, 24)
					Item.Font = Enum.Font.GothamBold
					Item.Text = tostring(v)
					Item.TextColor3 = Color3.fromRGB(180, 180, 180)
					Item.TextSize = 12.000
					Item.TextXAlignment = Enum.TextXAlignment.Left

					Item.MouseButton1Click:Connect(function()
						isdropping = false
						Dropdown:TweenSize(UDim2.new(0, 420, 0, 32), "Out", "Quad", 0.15, true)
						callback(Item.Text)
						DropTitle.Text = "  " .. text .. " : " .. Item.Text
					end)
				end
				DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
			end
			createItems()

			DropButton.MouseButton1Click:Connect(function()
				isdropping = not isdropping
				local targetH = isdropping and 125 or 32
				Dropdown:TweenSize(UDim2.new(0, 420, 0, targetH), "Out", "Quad", 0.15, true)
				task.wait(0.16) MainFramePage.CanvasSize = UDim2.new(0, 0, 0, MainFramePage.UIListLayout.AbsoluteContentSize.Y + 20)
			end)

			local dropfunc = {}
			function dropfunc:Add(t) table.insert(option, t) createItems() end
			function dropfunc:Clear() option = {} createItems() DropTitle.Text = "  " .. text .. " : " end
			return dropfunc
		end

		function main:Textbox(text, disappear, callback)
			local Textbox = Instance.new("Frame")
			local TextboxLabel = Instance.new("TextLabel")
			local RealTextbox = Instance.new("TextBox")

			Textbox.Name = "Textbox"
			Textbox.Parent = MainFramePage
			Textbox.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
			Textbox.Size = UDim2.new(0, 420, 0, 32)
			Instance.new("UICorner").CornerRadius = URadius.new(0, 4)
			Textbox.UICorner.Parent = Textbox
			local TBStroke = Instance.new("UIStroke")
			TBStroke.Color = Color3.fromRGB(45, 45, 45)
			TBStroke.Parent = Textbox

			TextboxLabel.Name = "TextboxLabel"
			TextboxLabel.Parent = Textbox
			TextboxLabel.BackgroundTransparency = 1.000
			TextboxLabel.Position = UDim2.new(0, 12, 0, 0)
			TextboxLabel.Size = UDim2.new(0, 200, 1, 0)
			TextboxLabel.Font = Enum.Font.GothamBold
			TextboxLabel.Text = text
			TextboxLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
			TextboxLabel.TextSize = 13.000
			TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left

			RealTextbox.Name = "RealTextbox"
			RealTextbox.Parent = Textbox
			RealTextbox.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
			RealTextbox.Position = UDim2.new(0, 305, 0, 5)
			RealTextbox.Size = UDim2.new(0, 100, 0, 22)
			RealTextbox.Font = Enum.Font.GothamBold
			RealTextbox.Text = ""
			RealTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
			RealTextbox.TextSize = 11.000
			Instance.new("UICorner").CornerRadius = URadius.new(0, 4)
			RealTextbox.UICorner.Parent = RealTextbox

			RealTextbox.FocusLost:Connect(function()
				pcall(callback, RealTextbox.Text)
				if disappear then RealTextbox.Text = "" end
			end)
		end

		function main:Label(text)
			local Label = Instance.new("TextLabel")
			local labelfunc = {}
	
			Label.Name = "Label"
			Label.Parent = MainFramePage
			Label.BackgroundTransparency = 1.000
			Label.Size = UDim2.new(0, 420, 0, 22)
			Label.Font = Enum.Font.GothamBold
			Label.TextColor3 = Color3.fromRGB(200, 200, 200)
			Label.TextSize = 13.000
			Label.Text = text
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Instance.new("UIPadding").PaddingLeft = UDim.new(0, 12)
			Label.UIPadding.Parent = Label
	
			function labelfunc:Set(newtext) Label.Text = newtext end
			return labelfunc
		end

		function main:Seperator(text)
			local Seperator = Instance.new("Frame")
			local Sep1 = Instance.new("Frame")
			local Sep2 = Instance.new("TextLabel")
			local Sep3 = Instance.new("Frame")
			
			Seperator.Name = "Seperator"
			Seperator.Parent = MainFramePage
			Seperator.BackgroundTransparency = 1.000
			Seperator.Size = UDim2.new(0, 420, 0, 22)
			
			Sep1.Name = "Sep1"
			Sep1.Parent = Seperator
			Sep1.BackgroundColor3 = _G.Color
			Sep1.BorderSizePixel = 0
			Sep1.Position = UDim2.new(0, 6, 0, 11)
			Sep1.Size = UDim2.new(0, 60, 0, 1)
			
			Sep2.Name = "Sep2"
			Sep2.Parent = Seperator
			Sep2.BackgroundTransparency = 1.000
			Sep2.Position = UDim2.new(0, 70, 0, 0)
			Sep2.Size = UDim2.new(0, 280, 1, 0)
			Sep2.Font = Enum.Font.GothamBold
			Sep2.Text = text
			Sep2.TextColor3 = Color3.fromRGB(255, 255, 255)
			Sep2.TextSize = 12.000
			
			Sep3.Name = "Sep3"
			Sep3.Parent = Seperator
			Sep3.BackgroundColor3 = _G.Color
			Sep3.BorderSizePixel = 0
			Sep3.Position = UDim2.new(0, 354, 0, 11)
			Sep3.Size = UDim2.new(0, 60, 0, 1)
		end

		function main:Line()
			local Linee = Instance.new("Frame")
			local Line = Instance.new("Frame")
			
			Linee.Name = "Linee"
			Linee.Parent = MainFramePage
			Linee.BackgroundTransparency = 1.000
			Linee.Size = UDim2.new(0, 420, 0, 15)
			
			Line.Name = "Line"
			Line.Parent = Linee
			Line.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			Line.BorderSizePixel = 0
			Line.Position = UDim2.new(0, 6, 0, 7)
			Line.Size = UDim2.new(0, 408, 0, 1)
		end
		return main
	end
	return uitab
end

return DarkraiX
