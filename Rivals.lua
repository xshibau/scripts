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
-- Made by Blissful#4992
local Players = game:service("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = game:service("Workspace").CurrentCamera
local RS = game:service("RunService")
local UIS = game:service("UserInputService")

repeat wait() until Player.Character ~= nil and Player.Character.PrimaryPart ~= nil

local LerpColorModule = loadstring(game:HttpGet("https://pastebin.com/raw/wRnsJeid"))()
local HealthBarLerp = LerpColorModule:Lerp(Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0))

local function NewCircle(Transparency, Color, Radius, Filled, Thickness)
    local c = Drawing.new("Circle")
    c.Transparency = Transparency
    c.Color = Color
    c.Visible = false
    c.Thickness = Thickness
    c.Position = Vector2.new(0, 0)
    c.Radius = Radius
    c.NumSides = math.clamp(Radius*55/100, 10, 75)
    c.Filled = Filled
    return c
end

local RadarInfo = {
    Position = Vector2.new(200, 200),
    Radius = 100,
    Scale = 1, -- Determinant factor on the effect of the relative position for the 2D integration
    RadarBack = Color3.fromRGB(10, 10, 10),
    RadarBorder = Color3.fromRGB(75, 75, 75),
    LocalPlayerDot = Color3.fromRGB(255, 255, 255),
    PlayerDot = Color3.fromRGB(60, 170, 255),
    Team = Color3.fromRGB(0, 255, 0),
    Enemy = Color3.fromRGB(255, 0, 0),
    Health_Color = true,
    Team_Check = true
}

local RadarBackground = NewCircle(0.9, RadarInfo.RadarBack, RadarInfo.Radius, true, 1)
RadarBackground.Visible = true
RadarBackground.Position = RadarInfo.Position

local RadarBorder = NewCircle(0.75, RadarInfo.RadarBorder, RadarInfo.Radius, false, 3)
RadarBorder.Visible = true
RadarBorder.Position = RadarInfo.Position

local function GetRelative(pos)
    local char = Player.Character
    if char ~= nil and char.PrimaryPart ~= nil then
        local pmpart = char.PrimaryPart
        local camerapos = Vector3.new(Camera.CFrame.Position.X, pmpart.Position.Y, Camera.CFrame.Position.Z)
        local newcf = CFrame.new(pmpart.Position, camerapos)
        local r = newcf:PointToObjectSpace(pos)
        return r.X, r.Z
    else
        return 0, 0
    end
end

local function PlaceDot(plr)
    local PlayerDot = NewCircle(1, RadarInfo.PlayerDot, 3, true, 1)

    local function Update()
        local c 
        c = game:service("RunService").RenderStepped:Connect(function()
            local char = plr.Character
            if char and char:FindFirstChildOfClass("Humanoid") and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local scale = RadarInfo.Scale
                local relx, rely = GetRelative(char.PrimaryPart.Position)
                local newpos = RadarInfo.Position - Vector2.new(relx * scale, rely * scale) 
                
                if (newpos - RadarInfo.Position).magnitude < RadarInfo.Radius-2 then 
                    PlayerDot.Radius = 3   
                    PlayerDot.Position = newpos
                    PlayerDot.Visible = true
                else 
                    local dist = (RadarInfo.Position - newpos).magnitude
                    local calc = (RadarInfo.Position - newpos).unit * (dist - RadarInfo.Radius)
                    local inside = Vector2.new(newpos.X + calc.X, newpos.Y + calc.Y)
                    PlayerDot.Radius = 2
                    PlayerDot.Position = inside
                    PlayerDot.Visible = true
                end

                PlayerDot.Color = RadarInfo.PlayerDot
                if RadarInfo.Team_Check then
                    if plr.TeamColor == Player.TeamColor then
                        PlayerDot.Color = RadarInfo.Team
                    else
                        PlayerDot.Color = RadarInfo.Enemy
                    end
                end

                if RadarInfo.Health_Color then
                    PlayerDot.Color = HealthBarLerp(hum.Health / hum.MaxHealth)
                end
            else 
                PlayerDot.Visible = false
                if Players:FindFirstChild(plr.Name) == nil then
                    PlayerDot:Remove()
                    c:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

for _,v in pairs(Players:GetChildren()) do
    if v.Name ~= Player.Name then
        PlaceDot(v)
    end
end

local function NewLocalDot()
    local d = Drawing.new("Triangle")
    d.Visible = true
    d.Thickness = 1
    d.Filled = true
    d.Color = RadarInfo.LocalPlayerDot
    d.PointA = RadarInfo.Position + Vector2.new(0, -6)
    d.PointB = RadarInfo.Position + Vector2.new(-3, 6)
    d.PointC = RadarInfo.Position + Vector2.new(3, 6)
    return d
end

local LocalPlayerDot = NewLocalDot()

Players.PlayerAdded:Connect(function(v)
    if v.Name ~= Player.Name then
        PlaceDot(v)
    end
    LocalPlayerDot:Remove()
    LocalPlayerDot = NewLocalDot()
end)

-- Loop
coroutine.wrap(function()
    local c 
    c = game:service("RunService").RenderStepped:Connect(function()
        if LocalPlayerDot ~= nil then
            LocalPlayerDot.Color = RadarInfo.LocalPlayerDot
            LocalPlayerDot.PointA = RadarInfo.Position + Vector2.new(0, -6)
            LocalPlayerDot.PointB = RadarInfo.Position + Vector2.new(-3, 6)
            LocalPlayerDot.PointC = RadarInfo.Position + Vector2.new(3, 6)
        end
        RadarBackground.Position = RadarInfo.Position
        RadarBackground.Radius = RadarInfo.Radius
        RadarBackground.Color = RadarInfo.RadarBack

        RadarBorder.Position = RadarInfo.Position
        RadarBorder.Radius = RadarInfo.Radius
        RadarBorder.Color = RadarInfo.RadarBorder
    end)
end)()

-- Draggable
local inset = game:service("GuiService"):GetGuiInset()

local dragging = false
local offset = Vector2.new(0, 0)
UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and (Vector2.new(Mouse.X, Mouse.Y + inset.Y) - RadarInfo.Position).magnitude < RadarInfo.Radius then
        offset = RadarInfo.Position - Vector2.new(Mouse.X, Mouse.Y)
        dragging = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

coroutine.wrap(function()
    local dot = NewCircle(1, Color3.fromRGB(255, 255, 255), 3, true, 1)
    local c 
    c = game:service("RunService").RenderStepped:Connect(function()
        if (Vector2.new(Mouse.X, Mouse.Y + inset.Y) - RadarInfo.Position).magnitude < RadarInfo.Radius then
            dot.Position = Vector2.new(Mouse.X, Mouse.Y + inset.Y)
            dot.Visible = true
        else 
            dot.Visible = false
        end
        if dragging then
            RadarInfo.Position = Vector2.new(Mouse.X, Mouse.Y) + offset
        end
    end)
end)()

end)
task.spawn(function()
-- Services
local RunService = game:GetService("RunService");
local PlayersService = game:GetService("Players");

-- Variables
local Camera = workspace.CurrentCamera;
local LastPos;
local Lines = {};
local Quads = {};

-- Functions
local function HasCharacter(Player)
    return Player.Character and Player.Character:FindFirstChild("HumanoidRootPart");
end;

local function DrawQuad(PosA, PosB, PosC, PosD)
    local PosAScreen, PosAVisible = Camera:WorldToViewportPoint(PosA);
    local PosBScreen, PosBVisible = Camera:WorldToViewportPoint(PosB);
    local PosCScreen, PosCVisible = Camera:WorldToViewportPoint(PosC);
    local PosDScreen, PosDVisible = Camera:WorldToViewportPoint(PosD);

    if (not PosAVisible and not PosBVisible and not PosCVisible and not PosDVisible) then return; end;

    local PosAVec = Vector2.new(PosAScreen.X, PosAScreen.Y);
    local PosBVec = Vector2.new(PosBScreen.X, PosBScreen.Y);
    local PosCVec = Vector2.new(PosCScreen.X, PosCScreen.Y);
    local PosDVec = Vector2.new(PosDScreen.X, PosDScreen.Y);

    local Quad = Drawing.new("Quad");
        Quad.Thickness = .5;
        Quad.Color = Color3.fromRGB(255, 255, 255);
        Quad.Transparency = .25;
        Quad.ZIndex = 1;
        Quad.Filled = true
        Quad.Visible = true;

        Quad.PointA = PosAVec;
        Quad.PointB = PosBVec;
        Quad.PointC = PosCVec;
        Quad.PointD = PosDVec;

    table.insert(Quads, Quad)
end

local function DrawLine(From, To)
    local FromScreen, FromVisible = Camera:WorldToViewportPoint(From);
    local ToScreen, ToVisible = Camera:WorldToViewportPoint(To);

    if (not FromVisible and not ToVisible) then return; end;

    local FromPos = Vector2.new(FromScreen.X, FromScreen.Y);
    local ToPos = Vector2.new(ToScreen.X, ToScreen.Y);

    local Line = Drawing.new("Line");
        Line.Thickness = 1;
        Line.From = FromPos
        Line.To = ToPos
        Line.Color = Color3.fromRGB(255, 255, 255);
        Line.Transparency = 1;
        Line.ZIndex = 1;
        Line.Visible = true;

    table.insert(Lines, Line)
end

-- Thank you Nahida#5000 for this function (GetCorners = GetVertices)
local function GetCorners(Part)
    local CF, Size, Corners = Part.CFrame, Part.Size / 2, {};
    for X = -1, 1, 2 do for Y = -1, 1, 2 do for Z = -1, 1, 2 do
        Corners[#Corners+1] = (CF * CFrame.new(Size * Vector3.new(X, Y, Z))).Position;      
    end; end; end;
    return Corners;
end;

local function DrawEsp(Player)
    local HRP = Player.Character.HumanoidRootPart;

    -- Constructing the 3d box.
    local CubeVertices = GetCorners({CFrame = HRP.CFrame * CFrame.new(0, -0.5, 0), Size = Vector3.new(3, 5, 3)});

    -- Drawing the 3d box.
        -- Bottom face:
        DrawLine(CubeVertices[1], CubeVertices[2]);
        DrawLine(CubeVertices[2], CubeVertices[6]);
        DrawLine(CubeVertices[6], CubeVertices[5]);
        DrawLine(CubeVertices[5], CubeVertices[1]);

        DrawQuad(CubeVertices[1], CubeVertices[2], CubeVertices[6], CubeVertices[5]);
       
        -- Side faces:
        DrawLine(CubeVertices[1], CubeVertices[3]);
        DrawLine(CubeVertices[2], CubeVertices[4]);
        DrawLine(CubeVertices[6], CubeVertices[8]);
        DrawLine(CubeVertices[5], CubeVertices[7]);

        DrawQuad(CubeVertices[2], CubeVertices[4], CubeVertices[8], CubeVertices[6]);
        DrawQuad(CubeVertices[1], CubeVertices[2], CubeVertices[4], CubeVertices[3]);
        DrawQuad(CubeVertices[1], CubeVertices[5], CubeVertices[7], CubeVertices[3]);
        DrawQuad(CubeVertices[5], CubeVertices[7], CubeVertices[8], CubeVertices[6]);

        -- Top face:
        DrawLine(CubeVertices[3], CubeVertices[4]);
        DrawLine(CubeVertices[4], CubeVertices[8]);
        DrawLine(CubeVertices[8], CubeVertices[7]);
        DrawLine(CubeVertices[7], CubeVertices[3]);
       
        DrawQuad(CubeVertices[3], CubeVertices[4], CubeVertices[8], CubeVertices[7]);
end;

local function BoxEsp()
    local Players = PlayersService:GetPlayers();

    for i = 1, #Lines do
        local Line = rawget(Lines, i);
        if (Line) then Line:Remove(); end;
    end;

    Lines = {};

    for i = 1, #Quads do
        local Quad = rawget(Quads, i);
        if (Quad) then Quad:Remove(); end;
    end;

    Quads = {};

    for i = 1, #Players do
        local Player = rawget(Players, i);
        if HasCharacter(Player) then
            DrawEsp(Player);
        end;
    end;
end;

-- Main
RunService.RenderStepped:Connect(BoxEsp);
end)
task.spawn(function()
-- Preview: https://cdn.discordapp.com/attachments/807887111667056680/820258191224340490/chams.png
-- Made by Blissful#4992
local Settings = {
    TeamCheck = true, -- Overules Color
    Red = Color3.fromRGB(255, 0, 0),
    Green = Color3.fromRGB(0, 255, 0),
    Color = Color3.fromRGB(255, 0, 0),
    TeamColor = false
}

--// Locals
local player = game:GetService("Players").LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local mouse = player:GetMouse()

local function NewQuad(color)
    local quad = Drawing.new("Quad")
    quad.Visible = false
    quad.PointA = Vector2.new(0,0)
    quad.PointB = Vector2.new(0,0)
    quad.PointC = Vector2.new(0,0)
    quad.PointD = Vector2.new(0,0)
    quad.Color = color
    quad.Filled = true
    quad.Thickness = 1
    quad.Transparency = 0.25
    return quad
end

local function Colorize(color, lib)
    for i, v in pairs(lib) do
        v.Color = color
    end
end

local function ESP(object, plr)
    local part = object
    --// Quads for 3D box (6)
    local quads = {
        quad1 = NewQuad(Settings.Color),
        quad2 = NewQuad(Settings.Color),
        quad3 = NewQuad(Settings.Color),
        quad4 = NewQuad(Settings.Color),
        quad5 = NewQuad(Settings.Color),
        quad6 = NewQuad(Settings.Color)
    }

    --// Updates ESP in render loop
    local function Updater()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild(object.Name) ~= nil then
                    local partpos, onscreen = camera:WorldToViewportPoint(part.Position)
                    if onscreen then
                        local size_X = part.Size.X/2
                        local size_Y = part.Size.Y/2
                        local size_Z = part.Size.Z/2
                        
                        local Top1 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(-size_X, size_Y, -size_Z)).p)
                        local Top2 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(-size_X, size_Y, size_Z)).p)
                        local Top3 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(size_X, size_Y, size_Z)).p)
                        local Top4 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(size_X, size_Y, -size_Z)).p)
    
                        local Bottom1 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(-size_X, -size_Y, -size_Z)).p)
                        local Bottom2 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(-size_X, -size_Y, size_Z)).p)
                        local Bottom3 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(size_X, -size_Y, size_Z)).p)
                        local Bottom4 = camera:WorldToViewportPoint((part.CFrame * CFrame.new(size_X, -size_Y, -size_Z)).p)
    
                        --// Top:
                        quads.quad1.PointA = Vector2.new(Top1.X, Top1.Y)
                        quads.quad1.PointB = Vector2.new(Top2.X, Top2.Y)
                        quads.quad1.PointC = Vector2.new(Top3.X, Top3.Y)
                        quads.quad1.PointD = Vector2.new(Top4.X, Top4.Y)
    
                        --//Bottom:
                        quads.quad2.PointA = Vector2.new(Bottom1.X, Bottom1.Y)
                        quads.quad2.PointB = Vector2.new(Bottom2.X, Bottom2.Y)
                        quads.quad2.PointC = Vector2.new(Bottom3.X, Bottom3.Y)
                        quads.quad2.PointD = Vector2.new(Bottom4.X, Bottom4.Y)
    
                        --//Sides:
                        quads.quad3.PointA = Vector2.new(Top1.X, Top1.Y)
                        quads.quad3.PointB = Vector2.new(Top2.X, Top2.Y)
                        quads.quad3.PointC = Vector2.new(Bottom2.X, Bottom2.Y)
                        quads.quad3.PointD = Vector2.new(Bottom1.X, Bottom1.Y)
                        
                        quads.quad4.PointA = Vector2.new(Top2.X, Top2.Y)
                        quads.quad4.PointB = Vector2.new(Top3.X, Top3.Y)
                        quads.quad4.PointC = Vector2.new(Bottom3.X, Bottom3.Y)
                        quads.quad4.PointD = Vector2.new(Bottom2.X, Bottom2.Y)
                        
                        quads.quad5.PointA = Vector2.new(Top3.X, Top3.Y)
                        quads.quad5.PointB = Vector2.new(Top4.X, Top4.Y)
                        quads.quad5.PointC = Vector2.new(Bottom4.X, Bottom4.Y)
                        quads.quad5.PointD = Vector2.new(Bottom3.X, Bottom3.Y)
    
                        quads.quad6.PointA = Vector2.new(Top4.X, Top4.Y)
                        quads.quad6.PointB = Vector2.new(Top1.X, Top1.Y)
                        quads.quad6.PointC = Vector2.new(Bottom1.X, Bottom1.Y)
                        quads.quad6.PointD = Vector2.new(Bottom4.X, Bottom4.Y)
    
                        if Settings.Team_Check then
                            if plr.TeamColor == player.TeamColor then
                                local group_color = Settings.Green
                                Colorize(group_color, quads)
                            else 
                                local group_color = Settings.Red
                                Colorize(group_color, quads)
                            end
                        else 
                            local group_color = Settings.Color
                            Colorize(group_color, quads)
                        end

                        if Settings.TeamColor then
                            Colorize(plr.TeamColor.Color, quads)
                        end
    
                        for u, x in pairs(quads) do
                            x.Visible = true
                        end
                    else 
                        for u, x in pairs(quads) do
                            x.Visible = false
                        end
                    end
            else 
                for u, x in pairs(quads) do
                    x.Visible = false
                end
                if game.Players:FindFirstChild(plr.Name) == nil then
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

for i, v in pairs(game:GetService("Players"):GetPlayers()) do
    spawn(function()
        if v.Name ~= player.Name then
            repeat wait() until v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("Head") ~= nil
            for u, x in pairs(v.Character:GetChildren()) do
                if x:IsA("MeshPart") or x.Name == "Head" or x.Name == "Left Arm" or x.Name == "Right Arm" or x.Name == "Right Leg" or x.Name == "Left Leg" or x.Name == "Torso" then
                    coroutine.wrap(ESP)(x, v)
                end
            end
        end
    end)
end

game.Players.PlayerAdded:Connect(function(newplr)
    spawn(function()
        if newplr.Name ~= player.Name then
            repeat wait() until newplr.Character ~= nil and newplr.Character:FindFirstChild("Humanoid") ~= nil and newplr.Character:FindFirstChild("HumanoidRootPart") ~= nil and newplr.Character.Humanoid.Health > 0 and newplr.Character:FindFirstChild("Head") ~= nil
            for u, x in pairs(newplr.Character:GetChildren()) do
                if x:IsA("MeshPart") or x.Name == "Head" or x.Name == "Left Arm" or x.Name == "Right Arm" or x.Name == "Right Leg" or x.Name == "Left Leg" or x.Name == "Torso" then
                    coroutine.wrap(ESP)(x, newplr)
                end
            end
        end
    end)
end)
end)
task.spawn(function()
-- LocalScript trong StarterPlayerScripts hoặc StarterGui
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

-- Bảng lưu trữ các đường line đã tạo cho từng người chơi
local lines = {}

-- Hàm tạo một Line UI
local function createLine()
    local line = Instance.new("Frame")
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Màu đỏ 🔴
    line.BorderSizePixel = 0
    line.Visible = false
    
    -- Tạo ScreenGui chứa Line nếu chưa có
    local screenGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ESP_Gui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ESP_Gui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    line.Parent = screenGui
    return line
end

-- Cập nhật vị trí và độ dài đường Line mỗi frame
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local headPosition, onScreen = Camera:WorldToViewportPoint(head.Position)

            -- Nếu nhân vật nằm trong tầm nhìn màn hình 📐
            if onScreen then
                if not lines[player] then
                    lines[player] = createLine()
                end
                
                local line = lines[player]
                
                -- Điểm bắt đầu: Chính giữa đỉnh màn hình khi xoay ngang 📲
                local startPos = Vector2.new(Camera.ViewportSize.X / 2, 0)
                -- Điểm kết thúc: Vị trí đầu của Player
                local endPos = Vector2.new(headPosition.X, headPosition.Y)

                -- Tính toán độ dài và góc xoay cho Frame
                local distance = (endPos - startPos).Magnitude
                local center = (startPos + endPos) / 2
                local angle = math.atan2(endPos.Y - startPos.Y, endPos.X - startPos.X)

                -- Cập nhật thuộc tính của Line
                line.Size = UDim2.new(0, distance, 0, 2) -- Độ dày đường kẻ = 2px
                line.Position = UDim2.new(0, center.X, 0, center.Y)
                line.Rotation = math.deg(angle)
                line.Visible = true
            else
                if lines[player] then
                    lines[player].Visible = false
                end
            end
        else
            if lines[player] then
                lines[player].Visible = false
            end
        end
    end
end)

-- Dọn dẹp khi có Player rời game 🚪
Players.PlayerRemoving:Connect(function(player)
    if lines[player] then
        lines[player]:Destroy()
        lines[player] = nil
    end
end)
end)
