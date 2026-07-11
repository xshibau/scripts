
local DarkraiX = loadstring(game:HttpGet("https://raw.githubusercontent.com/xshibau/scripts/refs/heads/main/Uiscript.lua", true))()

local Library = DarkraiX:Window("Aura Hub [P]","","",Enum.KeyCode.RightControl);

Tab1 = Library:Tab("Main Farm")
Tab2 = Library:Tab("Players Setting")
Tab3 = Library:Tab("💰 Token 💰")
Tab4 = Library:Tab("🏠 Items 🏠")

Tab1:Seperator("Food")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local foodConnection = nil
local isFoodRunning = false

-- Danh sách các món ăn mày muốn săn (viết thường hết để check cho chuẩn)
local targetFoods = {["burger"] = true, ["hotdog"] = true, ["ham"] = true}

local function findAndEatFood()
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and targetFoods[string.lower(obj.Name)] then
            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt") or obj:FindFirstChildWhichIsA("ProximityPrompt", true)
            
            if not prompt then
                for _, child in pairs(obj:GetDescendants()) do
                    if child:IsA("ProximityPrompt") then
                        prompt = child
                        break
                    end
                end
            end

            if prompt then
                local targetPart = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if targetPart then
                    hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.1)
                    
                    prompt:InputHoldBegin()
                    task.wait(prompt.HoldDuration)
                    prompt:InputHoldEnd()
                    
                    task.wait(0.1)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0, 0))
                    
                    break
                end
            end
        end
    end
end

Tab1:Toggle("Auto Eat Food", false, function(value)
    isFoodRunning = value
    
    if isFoodRunning then
        foodConnection = RunService.Heartbeat:Connect(function()
            if isFoodRunning then
                findAndEatFood()
            end
        end)
    else
        if foodConnection then
            foodConnection:Disconnect()
            foodConnection = nil
        end
    end
end)


Tab1:Seperator("Survive")
Tab1:Toggle("Auto Survive (Beta)", false, function(value)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    
    -- Kiểm tra xem đã có cái linh hồn nâng người nào được tạo trước đó chưa
    local bp = hrp:FindFirstChild("FlyHeightBP")
    
    if value then
        -- Khi BẬT: Lưu lại độ cao hiện tại và cộng thêm 40 studs
        if not bp then
            bp = Instance.new("BodyPosition")
            bp.Name = "FlyHeightBP"
            bp.MaxForce = Vector3.new(0, math.huge, 0) -- Chỉ tác dụng lực lên trục Y (độ cao)
            bp.Position = Vector3.new(0, hrp.Position.Y + 20, 0)
            bp.Parent = hrp
        end
    else
        -- Khi TẮT: Xóa nó đi để rớt xuống đất như người bình thường
        if bp then
            bp:Destroy()
        end
    end
end)

Tab1:Seperator("Farming")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local targetMob = nil
local flyConnection = nil
local clickThread = nil
local isRunning = false

local function getClosestMob()
    local closestMob = nil
    local shortestDistance = math.huge
    local character = player.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Humanoid") and obj.Parent ~= character and obj.Health > 0 then
            local mobHrp = obj.Parent:FindFirstChild("HumanoidRootPart")
            if mobHrp then
                local distance = (hrp.Position - mobHrp.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestMob = obj.Parent
                end
            end
        end
    end
    return closestMob
end

Tab1:Toggle("Attack Mob (Gun)", false, function(value)
    isRunning = value
    
    if isRunning then
        flyConnection = RunService.RenderStepped:Connect(function()
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            if not targetMob or not targetMob:FindFirstChild("HumanoidRootPart") or (targetMob:FindFirstChild("Humanoid") and targetMob.Humanoid.Health <= 0) then
                targetMob = getClosestMob()
            end
            
            if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                local mobHrp = targetMob.HumanoidRootPart
                hrp.CFrame = mobHrp.CFrame * CFrame.new(0, 15, 0)
                camera.CFrame = CFrame.new(camera.CFrame.Position, mobHrp.Position)
            end
        end)
        
        clickThread = task.spawn(function()
            while isRunning do
                task.wait(1)
                if isRunning then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton1(Vector2.new(0, 0))
                end
            end
        end)
    else
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        if clickThread then task.cancel(clickThread) clickThread = nil end
        targetMob = nil
    end
end)

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local isRunning = false
local farmConnection = nil
local clickThread = nil
local currentTween = nil

-- Hàm tìm máu tùy biến trong nhân vật hoặc Player
local function getCustomHealth()
    local character = player.Character
    if not character then return 100 end -- Mặc định coi như đầy máu nếu chưa load xong
    
    -- Quét tìm các Object chứa máu phổ biến (Health, HP, MaxHealth, vv)
    local healthObj = character:FindFirstChild("Health") or character:FindFirstChild("HP") 
        or player:FindFirstChild("Health") or player:FindFirstChild("HP")
        or character:FindFirstChildWhichIsA("NumberValue") or character:FindFirstChildWhichIsA("IntValue")

    if healthObj and (healthObj:IsA("NumberValue") or healthObj:IsA("IntValue")) then
        return healthObj.Value
    end
    
    -- Nếu có Humanoid nhưng game đổi cách tính khác, thử check thuộc tính Health gốc
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if humanoid then return humanoid.Health end

    return 100 -- Nếu đéo tìm thấy gì thì coi như bất tử, trả về 100 cho đỡ lỗi
end

local function getClosestMob()
    local character = player.Character
    if not character then return nil end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closestMob = nil
    local shortestDistance = math.huge

    for _, obj in pairs(workspace:GetDescendants()) do
        -- Tìm các thực thể có HumanoidRootPart và không phải bản thân mày
        if obj:IsA("Model") and obj ~= character and obj:FindFirstChild("HumanoidRootPart") then
            local mobHrp = obj.HumanoidRootPart
            local distance = (hrp.Position - mobHrp.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestMob = obj
            end
        end
    end
    return closestMob
end

Tab1:Toggle("Attacks Mob (Gun/Sword)", false, function(value)
    isRunning = value
    
    if isRunning then
        farmConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            -- CẤP CỨU: Lấy máu tùy biến, dưới 10 là sút lên trời ngay
            local currentHealth = getCustomHealth()
            if currentHealth < 10 then
                if currentTween then currentTween:Cancel() currentTween = nil end
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 500, 0)
                task.wait(0.5)
                return
            end
            
            local targetMob = getClosestMob()
            if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                local mobHrp = targetMob.HumanoidRootPart
                local targetCFrame = mobHrp.CFrame * CFrame.new(0, 15, 0)
                
                local distance = (hrp.Position - targetCFrame.Position).Magnitude
                local duration = distance / 50
                
                if currentTween then currentTween:Cancel() end
                
                currentTween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
                currentTween:Play()
            else
                if currentTween then currentTween:Cancel() currentTween = nil end
            end
        end)
        
        clickThread = task.spawn(function()
            while isRunning do
                task.wait(1)
                if isRunning then
                    local currentHealth = getCustomHealth()
                    if currentHealth >= 10 then
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(0, 0))
                    end
                end
            end
        end)
    else
        if farmConnection then farmConnection:Disconnect() farmConnection = nil end
        if clickThread then task.cancel(clickThread) clickThread = nil end
        if currentTween then currentTween:Cancel() currentTween = nil end
    end
end)



Tab1:Seperator("Bring Item")
local MapItems = workspace:WaitForChild("Map"):WaitForChild("Util"):WaitForChild("Items")
local toolList = {}
local selectedItemName = nil

local function updateList()
    toolList = {}
    for _, item in pairs(MapItems:GetChildren()) do
        if item:IsA("Tool") or item:IsA("Model") or item:IsA("Part") then
            table.insert(toolList, item.Name)
        end
    end
end

updateList()

local MyDropdown = Tab1:Dropdown("Select Item", toolList, function(value)
    selectedItemName = value
end)

Tab1:Button("Teleport To Item", function()
    if not selectedItemName then return end
    local targetItem = MapItems:FindFirstChild(selectedItemName)
    if targetItem then
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        local targetCFrame = nil
        
        if targetItem:IsA("Tool") and targetItem:FindFirstChild("Handle") then
            targetCFrame = targetItem.Handle.CFrame
        elseif targetItem:IsA("Model") and targetItem.PrimaryPart then
            targetCFrame = targetItem.PrimaryPart.CFrame
        elseif targetItem:IsA("Part") or targetItem:IsA("MeshPart") then
            targetCFrame = targetItem.CFrame
        else
            local extPart = targetItem:FindFirstChildWhichIsA("BasePart")
            if extPart then targetCFrame = extPart.CFrame end
        end
        
        if targetCFrame then
            hrp.CFrame = targetCFrame + Vector3.new(0, 3, 0)
        end
    end
end)

Tab1:Button("Resetlist", function()
    updateList()
    -- Thay 'Update' hoặc 'Refresh' tùy theo UI Library mày đang xài
    if MyDropdown.Update then
        MyDropdown:Update(toolList)
    elseif MyDropdown.Refresh then
        MyDropdown:Refresh(toolList)
    end
end)

Tab2:Seperator("Players")

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local speedConnection = nil
local isSpeedEnabled = false
local targetSpeed = 100
-- Biến cấu hình cho Inf Jump
local infJumpEnabled = false
local jumpConnection = nil


Tab2:Toggle("Speed Boost (Premium)", false, function(value)
    isSpeedEnabled = value
    
    if isSpeedEnabled then
        speedConnection = RunService.Heartbeat:Connect(function(deltaTime)
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChild("Humanoid")
            
            if hrp and humanoid and humanoid.MoveDirection.Magnitude > 0 then
                -- Tính toán vị trí mới dựa trên hướng di chuyển và delta time để mượt mà
                local velocity = humanoid.MoveDirection * targetSpeed
                hrp.CFrame = hrp.CFrame + (velocity * deltaTime)
            end
        end)
    else
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
    end
end)

-- 2. Toggle Infinite Jump
Tab2:Toggle("Infinite Jump", false, function(value)
    infJumpEnabled = value
    
    if infJumpEnabled then
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            if infJumpEnabled and character and humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end)
local Lighting = game:GetService("Lighting")

local isFullBright = false
local origBrightness = Lighting.Brightness
local origClockTime = Lighting.ClockTime
local origFogEnd = Lighting.FogEnd
local origGlobalShadows = Lighting.GlobalShadows
local origAmbient = Lighting.Ambient

Tab2:Toggle("Full Bright", false, function(value)
    isFullBright = value
    
    if isFullBright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = origBrightness
        Lighting.ClockTime = origClockTime
        Lighting.FogEnd = origFogEnd
        Lighting.GlobalShadows = origGlobalShadows
        Lighting.Ambient = origAmbient
    end
end)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local noclipConnection = nil
local isNoclipEnabled = false

-- 1. Toggle Noclip (Đi xuyên tường)
Tab2:Toggle("Noclip", false, function(value)
    isNoclipEnabled = value
    
    if isNoclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local character = player.Character
            if character and isNoclipEnabled then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        -- Trả lại va chạm bình thường cho nhân vật khi tắt
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- 2. Toggle Anti-Lag (Tăng FPS)
Tab2:Toggle("Anti Lag", false, function(value)
    if value then
        -- Bật Anti-Lag: Tắt bóng, hạ thấp hiệu ứng ánh sáng, xóa rác kết cấu
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("CornerWedgePart") or obj:IsA("TrussPart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.CastShadow = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
                obj.Enabled = false
            end
        end
    else
        -- Tắt Anti-Lag: Trả lại đồ họa mặc định của game
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Lighting.GlobalShadows = true
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("CornerWedgePart") or obj:IsA("TrussPart") then
                obj.Material = Enum.Material.Plastic -- Trả về mặc định cơ bản
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 0
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
                obj.Enabled = true
            end
        end
    end
end)

Tab2:Seperator("Esp")
local RunService = game:GetService("RunService")
local PlayersService = game:GetService("Players")

local Camera = workspace.CurrentCamera
local Lines = {}
local Quads = {}
local espConnection = nil
local isEspEnabled = false

local function HasCharacter(Player)
    return Player ~= PlayersService.LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
end

local function DrawQuad(PosA, PosB, PosC, PosD)
    local PosAScreen, PosAVisible = Camera:WorldToViewportPoint(PosA)
    local PosBScreen, PosBVisible = Camera:WorldToViewportPoint(PosB)
    local PosCScreen, PosCVisible = Camera:WorldToViewportPoint(PosC)
    local PosDScreen, PosDVisible = Camera:WorldToViewportPoint(PosD)

    if not PosAVisible and not PosBVisible and not PosCVisible and not PosDVisible then return end

    local Quad = Drawing.new("Quad")
    Quad.Thickness = .5
    Quad.Color = Color3.fromRGB(255, 255, 255)
    Quad.Transparency = .25
    Quad.ZIndex = 1
    Quad.Filled = true
    Quad.Visible = true
    Quad.PointA = Vector2.new(PosAScreen.X, PosAScreen.Y)
    Quad.PointB = Vector2.new(PosBScreen.X, PosBScreen.Y)
    Quad.PointC = Vector2.new(PosCScreen.X, PosCScreen.Y)
    Quad.PointD = Vector2.new(PosDScreen.X, PosDScreen.Y)

    table.insert(Quads, Quad)
end

local function DrawLine(From, To)
    local FromScreen, FromVisible = Camera:WorldToViewportPoint(From)
    local ToScreen, ToVisible = Camera:WorldToViewportPoint(To)

    if not FromVisible and not ToVisible then return end

    local Line = Drawing.new("Line")
    Line.Thickness = 1
    Line.From = Vector2.new(FromScreen.X, FromScreen.Y)
    Line.To = Vector2.new(ToScreen.X, ToScreen.Y)
    Line.Color = Color3.fromRGB(255, 255, 255)
    Line.Transparency = 1
    Line.ZIndex = 1
    Line.Visible = true

    table.insert(Lines, Line)
end

local function GetCorners(Part)
    local CF, Size, Corners = Part.CFrame, Part.Size / 2, {}
    for X = -1, 1, 2 do for Y = -1, 1, 2 do for Z = -1, 1, 2 do
        Corners[#Corners+1] = (CF * CFrame.new(Size * Vector3.new(X, Y, Z))).Position     
    end end end
    return Corners
end

local function DrawEsp(Player)
    local HRP = Player.Character.HumanoidRootPart
    local CubeVertices = GetCorners({CFrame = HRP.CFrame * CFrame.new(0, -0.5, 0), Size = Vector3.new(3, 5, 3)})

    DrawLine(CubeVertices[1], CubeVertices[2])
    DrawLine(CubeVertices[2], CubeVertices[6])
    DrawLine(CubeVertices[6], CubeVertices[5])
    DrawLine(CubeVertices[5], CubeVertices[1])
    DrawQuad(CubeVertices[1], CubeVertices[2], CubeVertices[6], CubeVertices[5])
   
    DrawLine(CubeVertices[1], CubeVertices[3])
    DrawLine(CubeVertices[2], CubeVertices[4])
    DrawLine(CubeVertices[6], CubeVertices[8])
    DrawLine(CubeVertices[5], CubeVertices[7])
    DrawQuad(CubeVertices[2], CubeVertices[4], CubeVertices[8], CubeVertices[6])
    DrawQuad(CubeVertices[1], CubeVertices[2], CubeVertices[4], CubeVertices[3])
    DrawQuad(CubeVertices[1], CubeVertices[5], CubeVertices[7], CubeVertices[3])
    DrawQuad(CubeVertices[5], CubeVertices[7], CubeVertices[8], CubeVertices[6])

    DrawLine(CubeVertices[3], CubeVertices[4])
    DrawLine(CubeVertices[4], CubeVertices[8])
    DrawLine(CubeVertices[8], CubeVertices[7])
    DrawLine(CubeVertices[7], CubeVertices[3])
    DrawQuad(CubeVertices[3], CubeVertices[4], CubeVertices[8], CubeVertices[7])
end

local function ClearEsp()
    for i = 1, #Lines do
        local Line = rawget(Lines, i)
        if Line then Line:Remove() end
    end
    Lines = {}

    for i = 1, #Quads do
        local Quad = rawget(Quads, i)
        if Quad then Quad:Remove() end
    end
    Quads = {}
end

local function BoxEsp()
    ClearEsp()
    if not isEspEnabled then return end
    
    local Players = PlayersService:GetPlayers()
    for i = 1, #Players do
        local Player = rawget(Players, i)
        if HasCharacter(Player) then
            DrawEsp(Player)
        end
    end
end

Tab2:Toggle("3D Box ESP", false, function(value)
    isEspEnabled = value
    
    if isEspEnabled then
        espConnection = RunService.RenderStepped:Connect(BoxEsp)
    else
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        ClearEsp()
    end
end)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Blissful4992/ESPs/main/UniversalSkeleton.lua"))()

local Skeletons = {}
local playerAddedConnection = nil
local isSkeletonEnabled = false

local function clearSkeletons()
    for _, skeleton in pairs(Skeletons) do
        if skeleton and skeleton.Remove then
            pcall(function() skeleton:Remove() end)
        elseif skeleton and skeleton.Destroy then
            pcall(function() skeleton:Destroy() end)
        end
    end
    Skeletons = {}
end

Tab2:Toggle("Skeleton ESP", false, function(value)
    isSkeletonEnabled = value
    
    if isSkeletonEnabled then
        -- Bật: Quét toàn bộ người chơi hiện tại để tạo khung xương
        for _, Player in next, game.Players:GetChildren() do
            if Player ~= game.Players.LocalPlayer then
                table.insert(Skeletons, Library:NewSkeleton(Player, true))
            end
        end
        
        -- Lắng nghe khi có thằng khác vào phòng thì tự động tạo thêm
        playerAddedConnection = game.Players.PlayerAdded:Connect(function(Player)
            if isSkeletonEnabled then
                table.insert(Skeletons, Library:NewSkeleton(Player, true))
            end
        end)
    else
        -- Tắt: Ngắt kết nối lắng nghe người chơi mới và xóa sạch khung xương cũ
        if playerAddedConnection then
            playerAddedConnection:Disconnect()
            playerAddedConnection = nil
        end
        clearSkeletons()
    end
end)
Tab2:Seperator("Server Hob")

local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local targetServerId = ""

Tab2:Textbox("Enter Server JobId", "", true, function(value)
    targetServerId = value
end)

Tab2:Button("Join (Jobid in but)", function()
    if targetServerId and targetServerId ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServerId, player)
    end
end)

Tab2:Button("Copy Server JobId", function()
    local setClipboard = setclipboard or tostring
    setClipboard(tostring(game.JobId))
end)

Tab2:Button("Join Server Randoms", function()
    local success, result = pcall(function()
        -- Lấy danh sách các server đang hoạt động công khai từ API Roblox
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if success and result and result.data then
        local validServers = {}
        for _, server in pairs(result.data) do
            -- Chỉ chọn server còn chỗ trống và không phải server hiện tại đang chơi
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(validServers, server.id)
            end
        end
        
        if #validServers > 0 then
            local randomServerId = validServers[math.random(1, #validServers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServerId, player)
        end
    end
end)
Tab3:Seperator("Premium Features")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local tokenConnection = nil
local isTokenRunning = false

local function findAndTriggerToken()
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local mapUtil = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Util")
    if not mapUtil then return end

    -- Quét tìm Tool có tên Token trong mục Map -> Util
    local targetToken = nil
    for _, obj in pairs(mapUtil:GetDescendants()) do
        if obj:IsA("Tool") and string.lower(obj.Name) == "token" then
            targetToken = obj
            break
        end
    end

    if targetToken then
        local targetPart = targetToken:FindFirstChild("Handle") or targetToken:FindFirstChildWhichIsA("BasePart")
        if targetPart then
            -- Teleport đến sát cái Token
            hrp.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
            
            -- Lock góc nhìn Camera thẳng vào cái Token
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
            
            -- Tìm và kích hoạt ProximityPrompt gần nhất của nó
            local prompt = targetToken:FindFirstChildWhichIsA("ProximityPrompt") or targetToken:FindFirstChildWhichIsA("ProximityPrompt", true)
            if not prompt then
                for _, child in pairs(targetToken:GetDescendants()) do
                    if child:IsA("ProximityPrompt") then
                        prompt = child
                        break
                    end
                end
            end

            if prompt then
                task.wait(0.1)
                prompt:InputHoldBegin()
                task.wait(prompt.HoldDuration)
                prompt:InputHoldEnd()
            end
        end
    end
end

Tab3:Toggle("Auto Farm Token", false, function(value)
    isTokenRunning = value
    
    if isTokenRunning then
        tokenConnection = RunService.Heartbeat:Connect(function()
            if isTokenRunning then
                findAndTriggerToken()
            end
        end)
    else
        if tokenConnection then
            tokenConnection:Disconnect()
            tokenConnection = nil
        end
    end
end)
Tab3:TextLabel("This feature is currently being tested as it is a beta version. If you encounter any errors, please report them to us immediately")
Tab3:TextLabel("This feature only works when the server has spawned tokens; it's not a bug, it's a feature optimized to prevent anti-cheating")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local tokenConnection = nil
local isScanning = false

local function sendNotification(title, text, iconId)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Icon = iconId or "rbxassetid://0", -- Thả ID ảnh vào đây nếu muốn đổi hình
        Duration = 3
    })
end

Tab3:Toggle("Scan Token", false, function(value)
    isScanning = value
    
    if isScanning then
        -- Chờ 0.1 giây để tránh bị spam thông báo ngay lập tức khi vừa nhấn nút
        task.wait(0.1)
        
        -- Quét toàn bộ Workspace xem có cục Token nào không
        local foundToken = false
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") and string.lower(obj.Name) == "token" then
                foundToken = true
                break
            end
        end
        
        -- Bắn thông báo kết quả chuẩn bài "nhận huy hiệu"
        if foundToken then
            sendNotification(
                "FOUND ✅", 
                "Token detected on the Map!", 
                "rbxassetid://12521191544" -- Icon cái cúp/huy hiệu vàng nhìn cho uy tín
            )
        else
            sendNotification(
                "FAILURE ❌", 
                "There are no tokens on the map, find another room!", 
                "rbxassetid://11419714815" -- Icon dấu X màu đỏ
            )
        end
    else
        if tokenConnection then
            tokenConnection:Disconnect()
            tokenConnection = nil
        end
    end
end)
Tab4:Seperator("Warning: May cause system lag.")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local itemConnection = nil
local isFarmRunning = false
local originalPos = nil
local skyPos = nil

-- CẤU HÌNH TẠI ĐÂY (Mày vào game xem túi đồ tối đa chứa được bao nhiêu cái thì sửa số 10 lại)
local MAX_BAG_ITEMS = 10 

-- Hàm kiểm tra số lượng item trong túi đồ (Backpack)
local function getBackpackCount()
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        return #backpack:GetChildren()
    end
    return 0
end

-- Hàm tự động thả sạch đồ trong người xuống đất khi đầy túi
local function dropAllItems()
    local character = player.Character
    if not character then return end
    local backpack = player:FindFirstChild("Backpack")
    
    if backpack then
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                item.Parent = character -- Lôi ra tay
                task.wait(0.05)
                item.Parent = workspace -- Thả xuống đất
            end
        end
    end
end

local function startUltraFarm()
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- 1. Kiểm tra túi đồ, nếu max thì xả sạch xuống chân
    if getBackpackCount() >= MAX_BAG_ITEMS then
        dropAllItems()
        task.wait(0.2)
    end

    -- 2. Quét map bring toàn bộ Tool (Item) về vị trí chân player trên trời
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj.Parent ~= character and obj.Parent ~= player:FindFirstChild("Backpack") then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            if handle then
                -- Ép tọa độ của item về ngay dưới chân mày trên trời
                handle.CFrame = hrp.CFrame * CFrame.new(0, -3, 0)
            end
        end
    end

    -- 3. Quét tìm model chứa chữ "Key" để bay tới húp rồi quay lại
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(string.lower(obj.Name), "key") then
            local keyPart = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
            if keyPart then
                -- Bay xuống húp Key
                hrp.CFrame = keyPart.CFrame
                task.wait(0.2) -- Chờ tí cho game nhận va chạm nhặt key
                
                -- Húp xong bay ngược trở lại vị trí an toàn trên trời liền
                hrp.CFrame = skyPos
                break
            end
        end
    end
end

Tab4:Toggle("Bring Item", false, function(value)
    isFarmRunning = value
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if isFarmRunning then
        if hrp then
            -- Lưu lại vị trí đứng ban đầu dưới đất
            originalPos = hrp.CFrame
            -- Tính toán tọa độ trên trời cao hơn vị trí cũ 25 studs
            skyPos = originalPos * CFrame.new(0, 25, 0)
            -- Đưa player lên trời ngay lập tức
            hrp.CFrame = skyPos
            
            -- Chạy vòng lặp quét map liên tục
            itemConnection = RunService.Heartbeat:Connect(function()
                if isFarmRunning then
                    startUltraFarm()
                end
            end)
        end
    else
        -- Khi tắt: Ngắt vòng lặp và đưa nhân vật về lại vị trí cũ dưới đất cho mày
        if itemConnection then
            itemConnection:Disconnect()
            itemConnection = nil
        end
        if hrp and originalPos then
            hrp.CFrame = originalPos
        end
    end
end)
Tab4:TextLabel("Features under development may have bugs or not work. If a feature is incomplete or in beta, the risk of being banned is very high; its use is not recommended.")
Tab4:TextLabel("The script is not 100% complete yet, so it will be updated three more times, and updates will stop after those three times.")
