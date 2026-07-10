
local DarkraiX = loadstring(game:HttpGet("https://raw.githubusercontent.com/xshibau/scripts/refs/heads/main/Uiscript.lua", true))()

local Library = DarkraiX:Window("Aura Hub","","",Enum.KeyCode.RightControl);

Tab1 = Library:Tab("Main Farm")
Tab2 = Library:Tab("Players Farm")


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
            bp.Position = Vector3.new(0, hrp.Position.Y + 28, 0)
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
                hrp.CFrame = mobHrp.CFrame * CFrame.new(0, 16, 0)
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


Tab2:Toggle("Xịn Speed 🗿", false, function(value)
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

