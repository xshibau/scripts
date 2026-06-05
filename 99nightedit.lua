local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI:AddTheme({
    Name = "Premium",
    
    Accent = Color3.fromHex("#EC4899"),     
    Background = Color3.fromHex("#7F1D1D"), 
    Outline = Color3.fromHex("#FFFDD0"),    
    Text = Color3.fromHex("#FFFDD0"),        
    Placeholder = Color3.fromHex("#FFFDD0"),
    Button = Color3.fromHex("#1C1C1C"),     
    Icon = Color3.fromHex("#BE185D"),      
})
WindUI:AddTheme({
    Name = "Sakura",
    
    Accent = Color3.fromHex("#F472B6"),     -- Hồng Sakura chủ đạo
    Background = Color3.fromHex("#FFF1F2"), -- Nền hồng siêu nhạt
    Outline = Color3.fromHex("#FDA4AF"),    -- Viền hồng nhẹ
    Text = Color3.fromHex("#4C0519"),       -- Chữ hồng đậm (dễ đọc hơn trắng trên nền hồng nhạt)
    Placeholder = Color3.fromHex("#FBCFE8"),
    Button = Color3.fromHex("#EC4899"),     -- Nút nhấn hồng tươi
    Icon = Color3.fromHex("#BE185D"),       -- Icon hồng đậm
})
WindUI:AddTheme({
    Name = "Orange",
    
    Accent = Color3.fromHex("#F97316"),     -- Cam mặt trời chủ đạo
    Background = Color3.fromHex("#FFF7ED"), -- Nền cam siêu nhạt
    Outline = Color3.fromHex("#FDBA74"),    -- Viền cam nhẹ
    Text = Color3.fromHex("#7C2D12"),       -- Chữ nâu cam đậm (để đọc cho rõ)
    Placeholder = Color3.fromHex("#FFEDD5"),
    Button = Color3.fromHex("#EA580C"),     -- Nút nhấn cam đậm
    Icon = Color3.fromHex("#C2410C"),       -- Icon cam tối
})
local Window = WindUI:CreateWindow({
    Title = "36 Hub",
    Icon = "door-open",
    Author = "ThanhloAsian",
    Folder = "MySuperHub",

    Size = UDim2.fromOffset(670, 640),
    MinSize = Vector2.new(300, 280),
    MaxSize = Vector2.new(1050, 800),
    ToggleKey = Enum.KeyCode.LeftShift,
    Transparent = true,
    Theme = "Premium",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,

    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
        end,
    },
})
Window:EditOpenButton({
    Title = "Open E36 Script",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})



local Tab = Window:Tab({
    Title = "Main Farm",
    Icon = "house", -- optional
    Locked = false,
})
local Settings = Window:Tab({
    Title = "Player Settings",
    Icon = "settings", -- optional
    Locked = false,
})
local Section = Tab:Section({ 
    Title = "Main Fire",
})
local CollectionService = game:GetService("CollectionService")

local Toggle = Tab:Toggle({
    Title = "Auto Bring Fire (Full Fix)",
    Desc = "",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        _G.AutoLogBring = state
        if not state then return end
        
        local brought = {}
        local pos = CFrame.new(0.54, 12.5, -0.72) -- Làm tròn cho đỡ rối
        local list = {["Log"] = true, ["Fuel"] = true, ["Coal"] = true}

        task.spawn(function()
            while _G.AutoLogBring do
                for _, obj in pairs(workspace:GetChildren()) do
                    -- Check xem có đúng tên trong list và là Model không
                    if list[obj.Name] and obj:IsA("Model") then
                        -- Lấy PrimaryPart hoặc cái Part đầu tiên tìm thấy
                        local targetPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                        
                        if targetPart and not brought[obj] then
                            -- Chỉnh lại CFrame một chút để tránh kẹt
                            obj:PivotTo(pos)
                            brought[obj] = true
                        end
                    end
                end
                task.wait(0.3) -- Giảm delay tí cho mượt
            end
        end)
    end
})


local Toggle = Tab:Toggle({
    Title = "Auto Fire",
    Desc = "ยิงอัตโนมัติ",
    Type = "Checkbox",
    Locked = true,
    Value = false,
    Callback = function(state)
        _G.AutoLog = state
        
        if not state then return end

        task.spawn(function()
            local player = game.Players.LocalPlayer
            local cookPos = CFrame.new(0.5406733, 12.499372, -0.7186632)
            local originalPos = nil

            -- Lưu vị trí gốc khi bắt đầu
            local char = player.Character or player.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then originalPos = hrp.CFrame end

            while _G.AutoLog do
                task.wait(0.1)

                local characterNow = player.Character
                local humanoidRootPartNow = characterNow and characterNow:FindFirstChild("HumanoidRootPart")
                
                if humanoidRootPartNow then
                    local nearestLog = nil
                    local nearestDistance = math.huge
                    
                    -- Quét tìm Log gần nhất
                    for _, possibleLog in pairs(workspace:GetDescendants()) do
                        if possibleLog:IsA("Model") and possibleLog.Name == "Log" and possibleLog.PrimaryPart then
                            local dist = (possibleLog.PrimaryPart.Position - humanoidRootPartNow.Position).Magnitude
                            if dist < nearestDistance then
                                nearestDistance = dist
                                nearestLog = possibleLog
                            end
                        end
                    end

                    -- Nếu thấy Log thì "di cư" tới đó và đưa vào lò
                    if nearestLog then
                        humanoidRootPartNow.CFrame = nearestLog.PrimaryPart.CFrame
                        nearestLog:SetPrimaryPartCFrame(cookPos)
                        task.wait(0.15)
                    end
                end
            end

            -- Khi tắt Toggle thì trả về chỗ cũ
            if originalPos then
                local finalChar = player.Character
                local finalHRP = finalChar and finalChar:FindFirstChild("HumanoidRootPart")
                if finalHRP then
                    finalHRP.CFrame = originalPos
                end
            end
        end)
    end
})
local Toggle = Tab:Toggle({
    Title = "Auto Cooked",
    Desc = "Improved and fixed the bug that didn't bring the cooked food to the desired result.",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        _G.AutoMorsel = state
        if not state then return end

        task.spawn(function()
            local cookPos = CFrame.new(0.5406733, 12.499372, -0.7186632)
            local processed = {} -- List những món đã xử lý xong

            while _G.AutoMorsel do
                task.wait(0.2)
                
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name == "Morsel" and obj:IsA("Model") and obj.PrimaryPart then
                        -- Check xem đã xử lý chưa, nếu chưa thì mới lôi
                        if not processed[obj] then
                            obj:PivotTo(cookPos)
                            processed[obj] = true
                            
                            -- Đợi một chút để vật thể ổn định tại vị trí mới
                            task.wait(0.5) 
                        end
                    end
                end
            end
            
            table.clear(processed)
        end)
    end
})


local Toggle = Tab:Toggle({
    Title = "Auto Farm Tree",
    Desc = "ฟาร์มต้นไม้ (Small Tree)",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        _G.AutoFarmTree = state
        if not state then return end

        task.spawn(function()
            local player = game.Players.LocalPlayer
            local virtualUser = game:GetService("VirtualUser")

            while _G.AutoFarmTree do
                local nearestTree = nil
                local nearestDistance = math.huge
                
                -- Tìm Small Tree gần nhất
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == "Small Tree" and obj.PrimaryPart then
                        local dist = (obj.PrimaryPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if dist < nearestDistance then
                            nearestDistance = dist
                            nearestTree = obj
                        end
                    end
                end

                if nearestTree then
                    -- Teleport tới gốc cây
                    player.Character.HumanoidRootPart.CFrame = nearestTree.PrimaryPart.CFrame
                    
                    -- Click liên tục mỗi 1 giây trong 17 giây
                    local startTime = tick()
                    while tick() - startTime < 17 and _G.AutoFarmTree do
                        virtualUser:ClickButton1(Vector2.new(0, 0))
                        task.wait(1)
                    end
                    
                    -- Nghỉ 2 giây trước khi sang cây mới
                    task.wait(2)
                else
                    task.wait(1) -- Không thấy cây thì chờ tí rồi tìm tiếp
                end
            end
        end)
    end
})
local Section = Tab:Section({ 
    Title = "Help Kid",
})
local Toggle = Tab:Toggle({
    Title = "Auto Kid (Beta)",
    Desc = "เด็กอัตโนมัติ (เบต้า)",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        _G.AutoRescue = state
        if not state then return end

        task.spawn(function()
            local player = game.Players.LocalPlayer
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            while _G.AutoRescue do
                local foundChild = nil
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name == "Lose Child" and obj.PrimaryPart then
                        foundChild = obj
                        break
                    end
                end

                if foundChild then
                    hrp.CFrame = foundChild.PrimaryPart.CFrame
                    task.wait(0.5)

                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            local dist = (obj.Parent.Position - hrp.Position).Magnitude
                            if dist <= 50 then
                                fireproximityprompt(obj)
                            end
                        end
                    end
                    task.wait(1)
                else
                    break -- Không còn đứa nào thì ngưng
                end
            end
        end)
    end
})

local Section = Tab:Section({ 
    Title = "Mob Settings",
})
local Paragraph = Tab:Paragraph({
    Title = "Mob Setings",
    Desc = "Upcoming feature, please wait.",
    Color = "Green",
    Locked = false,
})
local Toggle = Tab:Toggle({
    Title = "Kill Aura Mob",
    Desc = "สังหารมอนสเตอร์ออร่า",
    Type = "Checkbox",
    Locked = true,
    Value = false, -- default value
    Callback = function(state) 
     end
})

local Toggle = Tab:Toggle({
    Title = "Auto Farm Mob",
    Desc = "ออโต้ฟาร์มโมบ",
    Type = "Checkbox",
    Locked = true,
    Value = false, -- default value
    Callback = function(state) 
     end
})

local Input = Settings:Input({
    Title = "WalkSpeed",
    Desc = "ใส่ความเร็ว (1-100)",
    Value = "16",
    InputIcon = "zap",
    Type = "Input",
    Placeholder = "...",
    Callback = function(text)
        local val = tonumber(text)
        if val then
            _G.WalkSpeedValue = math.clamp(val, 1, 100)
            if _G.IsSpeedEnabled then
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue
                end
            end
        end
    end
})

local Toggle = Settings:Toggle({
    Title = "Auto WalkSpeed",
    Desc = "เปิดใช้งานความเร็ว",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        _G.IsSpeedEnabled = state
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then
            if state then
                humanoid.WalkSpeed = _G.WalkSpeedValue or 16
            else
                humanoid.WalkSpeed = 16
            end
        end
    end
})
Settings:Toggle({
    Title = "Full Bright",
    Desc = "ทำให้สว่างเต็มที่",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        local lighting = game:GetService("Lighting")
        if state then
            _G.OldBrightness = lighting.Brightness
            _G.OldAmbient = lighting.Ambient
            _G.OldOutdoorAmbient = lighting.OutdoorAmbient
            lighting.Brightness = 2
            lighting.Ambient = Color3.fromRGB(255, 255, 255)
            lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            lighting.Brightness = _G.OldBrightness or 2
            lighting.Ambient = _G.OldAmbient or Color3.fromRGB(0, 0, 0)
            lighting.OutdoorAmbient = _G.OldOutdoorAmbient or Color3.fromRGB(0, 0, 0)
        end
    end
})

Settings:Toggle({
    Title = "Infinite Jump",
    Desc = "กระโดดไม่จำกัด",
    Type = "Checkbox",
    Value = false,
    Callback = function(state)
        _G.InfJump = state
        if not _G.JumpConnection then
            _G.JumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.InfJump then
                    game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState("Jumping")
                end
            end)
        end
    end
})
local Section = Settings:Section({ 
    Title = "Ui Settings",
})
local Dropdown = Settings:Dropdown({
    Title = "Theme Selector",
    Desc = "เลือกสีธีมที่ต้องการ",
    Values = { "Sakura", "Orange" },
    Value = { "Dark" }, -- Mặc định
    Multi = false, -- Để false cho chắc, chọn 1 cái thôi
    AllowNone = false,
    Callback = function(option) 
        -- option trả về là 1 cái bảng, lấy phần tử đầu tiên
        local selectedTheme = option[1]
        if selectedTheme then
            WindUI:SetTheme(selectedTheme)
        end
    end
})
