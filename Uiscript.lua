local PlaceName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)

if not game:IsLoaded() then repeat game.Loaded:Wait() until game:IsLoaded() end

repeat wait() until game:GetService("Players")

if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then repeat wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end
    
wait(1)

do local GUI = game.CoreGui:FindFirstChild("Darkrai");if GUI then GUI:Destroy();end;if _G.Color == nil then
   _G.Color = Color3.fromRGB(255, 0, 0) -- Đổi màu chủ đạo thành màu Đỏ theo ý mày
end 
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function MakeDraggable(topbarobject, object)
local Dragging = nil
local DragInput = nil
local DragStart = nil
local StartPosition = nil

local function Update(input)
    local Delta = input.Position - DragStart
    local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    local Tween = TweenService:Create(object, TweenInfo.new(0.15), {Position = pos})
    Tween:Play()
end

topbarobject.InputBegan:Connect(
    function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(
                function()
                    if input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end
            )
        end
    end
)

topbarobject.InputChanged:Connect(
    function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch
        then
            DragInput = input
        end
    end
)

UserInputService.InputChanged:Connect(
    function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end
)
end

local DarkraiX = {}

function DarkraiX:ToggleUi()
if game.CoreGui:FindFirstChild("Darkrai").Main.Size == UDim2.new(0, 0, 0, 0) then
game.CoreGui:FindFirstChild("Darkrai").Main:TweenSize(UDim2.new(0, 600, 0, 340),"Out","Quad",0.4,true)
else
game.CoreGui:FindFirstChild("Darkrai").Main:TweenSize(UDim2.new(0, 0, 0, 0),"In","Quad",0.4,true)
end
end
function DarkraiX:Window(text,gamenme,logo,keybind)
local hubname = text
local gamename = gamenme
local uihide = false
local abc = false
local logo = logo or 0
local currentpage = ""
local keybind = keybind or Enum.KeyCode.RightControl
local yoo = string.gsub(tostring(keybind),"Enum.KeyCode.","")
if gamename == "" then 
    gamename = ""..PlaceName.Name
end

local Darkrai = Instance.new("ScreenGui")
Darkrai.Name = "Darkrai"
Darkrai.Parent = game.CoreGui
Darkrai.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Thêm Nút nhỏ 70x30 ở góc trái màn hình để bật/tắt trực tiếp
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = Darkrai
ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10) -- Góc trái trên cùng
ToggleBtn.Size = UDim2.new(0, 70, 0, 30)
ToggleBtn.Font = Enum.Font.GothamSemibold
ToggleBtn.Text = "UI: ON"
ToggleBtn.TextColor3 = _G.Color -- Màu đỏ
ToggleBtn.TextSize = 14.000

local TBCNR = Instance.new("UICorner")
TBCNR.CornerRadius = UDim.new(0, 5)
TBCNR.Parent = ToggleBtn

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = Darkrai
Main.ClipsDescendants = true
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0, 600, 0, 340)

local MCNR = Instance.new("UICorner")
MCNR.Name = "MCNR"
MCNR.Parent = Main

local Top = Instance.new("Frame")
Top.Name = "Top"
Top.Parent = Main
Top.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Top.Size = UDim2.new(0, 600, 0, 27)

local TCNR = Instance.new("UICorner")
TCNR.Name = "TCNR"
TCNR.Parent = Top

local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Parent = Top
Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Logo.BackgroundTransparency = 1.000
Logo.Position = UDim2.new(0, 10, 0, 1)
Logo.Size = UDim2.new(0, 25, 0, 25)
Logo.Image = ""

local Name = Instance.new("TextLabel")
Name.Name = "Name"
Name.Parent = Top
Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Name.BackgroundTransparency = 1.000
Name.Position = UDim2.new(0, 40, 0, 0)
Name.Size = UDim2.new(0, 61, 0, 27)
Name.Font = Enum.Font.GothamSemibold
Name.Text = hubname
Name.TextColor3 = _G.Color -- Đổi sang Đỏ
Name.TextSize = 17.000

local Hub = Instance.new("TextLabel")
Hub.Name = "Hub"
Hub.Parent = Top
Hub.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Hub.BackgroundTransparency = 1.000
Hub.Position = UDim2.new(0, 110, 0, 0)
Hub.Size = UDim2.new(0, 81, 0, 27)
Hub.Font = Enum.Font.GothamSemibold
Hub.Text = "  | "..gamename
Hub.TextColor3 = _G.Color -- Đổi sang Đỏ
Hub.TextSize = 17.000
Hub.TextXAlignment = Enum.TextXAlignment.Left

local BindButton = Instance.new("TextButton")
BindButton.Name = "BindButton"
BindButton.Parent = Top
BindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BindButton.BackgroundTransparency = 1.000
BindButton.Position = UDim2.new(1, -110, 0, 0)
BindButton.Size = UDim2.new(0, 100, 0, 27)
BindButton.Font = Enum.Font.GothamSemibold
BindButton.Text = "[CLICK BTN]" -- Đổi thông báo phím tắt thành Click Button
BindButton.TextColor3 = _G.Color -- Đổi sang Đỏ
BindButton.TextSize = 13.000

local Tab = Instance.new("Frame")
Tab.Name = "Tab"
Tab.Parent = Main
Tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Tab.BackgroundTransparency = 1.000 -- Đã ẩn nền của vùng chứa Tab theo ý mày
Tab.Position = UDim2.new(0, 5, 0, 32)
Tab.Size = UDim2.new(0, 140, 0, 303)
    local ScrollTab = Instance.new("ScrollingFrame")
ScrollTab.Name = "ScrollTab"
ScrollTab.Parent = Tab
ScrollTab.Active = true
ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollTab.BackgroundTransparency = 1.000
ScrollTab.Size = UDim2.new(0, 140, 0, 303)
ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollTab.ScrollBarThickness = 0

local PLL = Instance.new("UIListLayout")
PLL.Name = "PLL"
PLL.Parent = ScrollTab
PLL.SortOrder = Enum.SortOrder.LayoutOrder
PLL.Padding = UDim.new(0, 10)

local PPD = Instance.new("UIPadding")
PPD.Name = "PPD"
PPD.Parent = ScrollTab
PPD.PaddingLeft = UDim.new(0, 5)
PPD.PaddingTop = UDim.new(0, 10)

local Page = Instance.new("Frame")
Page.Name = "Page"
Page.Parent = Main
Page.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Page.Position = UDim2.new(0, 150, 0, 32)
Page.Size = UDim2.new(0, 445, 0, 303)

local PCNR = Instance.new("UICorner")
PCNR.Name = "PCNR"
PCNR.Parent = Page

local MainPage = Instance.new("Frame")
MainPage.Name = "MainPage"
MainPage.Parent = Page
MainPage.ClipsDescendants = true
MainPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainPage.BackgroundTransparency = 1.000
MainPage.Size = UDim2.new(0, 445, 0, 303)

local PageList = Instance.new("Folder")
PageList.Name = "PageList"
PageList.Parent = MainPage

local UIPageLayout = Instance.new("UIPageLayout")
UIPageLayout.Parent = PageList
UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIPageLayout.EasingDirection = Enum.EasingDirection.InOut
UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
UIPageLayout.FillDirection = Enum.FillDirection.Vertical
UIPageLayout.Padding = UDim.new(0, 15)
UIPageLayout.TweenTime = 0.400
UIPageLayout.GamepadInputEnabled = false
UIPageLayout.ScrollWheelInputEnabled = false
UIPageLayout.TouchInputEnabled = false

MakeDraggable(Top,Main)

-- Logic khi nhấn nút nhỏ ở góc trái để ẩn/hiện UI trực tiếp
ToggleBtn.MouseButton1Click:Connect(function()
    if uihide == false then
        uihide = true
        ToggleBtn.Text = "UI: OFF"
        Main:TweenSize(UDim2.new(0, 0, 0, 0),"In","Quad",0.4,true)
    else
        uihide = false
        ToggleBtn.Text = "UI: ON"
        Main:TweenSize(UDim2.new(0, 600, 0, 340),"Out","Quad",0.4,true)
    end
end)

local uitab = {}

function uitab:Tab(text)
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = ScrollTab
    TabButton.Name = text.."Server"
    TabButton.Text = text
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabButton.BackgroundTransparency = 1.000 -- Ẩn luôn nền của từng cái nút Tab con
    TabButton.BorderColor3 = _G.Color -- Đổi màu viền tính năng thành Đỏ
    TabButton.BorderSizePixel = 0 -- Bỏ viền thô kệch cho đẹp mắt
    TabButton.Size = UDim2.new(0, 130, 0, 23)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.TextColor3 = Color3.fromRGB(225, 225, 225)
    TabButton.TextSize = 15.000
    TabButton.TextTransparency = 0.500

    local MainFramePage = Instance.new("ScrollingFrame")
    MainFramePage.Name = text.."_Page"
    MainFramePage.Parent = PageList
    MainFramePage.Active = true
    MainFramePage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainFramePage.BackgroundTransparency = 1.000
    MainFramePage.BorderSizePixel = 0
    MainFramePage.Size = UDim2.new(0, 445, 0, 303)
    MainFramePage.CanvasSize = UDim2.new(0, 0, 0, 0)
    MainFramePage.ScrollBarThickness = 0
         
