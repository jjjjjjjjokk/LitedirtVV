-- // LITEDIRT CUSTOM UI + PERMANENT VEHICLE PROXIMITY TELEPORT FIX // --
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("LitedirtCustomUI") then
    CoreGui.LitedirtCustomUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LitedirtCustomUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.Size = UDim2.new(0, 550, 0, 360)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Text = "LITEDIRT | KEYLESS | RIDE STORM"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local isCollapsed = false
local CollapseBtn = Instance.new("TextButton", TopBar)
CollapseBtn.Text = "-"
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.TextSize = 16
CollapseBtn.Font = Enum.Font.GothamBold
CollapseBtn.Size = UDim2.new(0, 35, 0, 35)
CollapseBtn.Position = UDim2.new(1, -70, 0, 0)
CollapseBtn.BackgroundTransparency = 1

local ContentHolder = Instance.new("Folder", MainFrame)

local Sidebar = Instance.new("ScrollingFrame", MainFrame)
Sidebar.Name = "ContentChild"
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.Size = UDim2.new(0, 150, 1, -35)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 90)
Sidebar.ScrollBarThickness = 2
Sidebar.Parent = ContentHolder

local TabTPBtn = Instance.new("TextButton", Sidebar)
TabTPBtn.Text = "🌍 Teleport"
TabTPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabTPBtn.TextSize = 12
TabTPBtn.Font = Enum.Font.GothamMedium
TabTPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
TabTPBtn.Size = UDim2.new(1, -16, 0, 32)
TabTPBtn.Position = UDim2.new(0, 8, 0, 10)
Instance.new("UICorner", TabTPBtn).CornerRadius = UDim.new(0, 6)

local TabJobBtn = Instance.new("TextButton", Sidebar)
TabJobBtn.Text = "💼 Auto Job"
TabJobBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
TabJobBtn.TextSize = 12
TabJobBtn.Font = Enum.Font.GothamMedium
TabJobBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TabJobBtn.Size = UDim2.new(1, -16, 0, 32)
TabJobBtn.Position = UDim2.new(0, 8, 0, 50)
Instance.new("UICorner", TabJobBtn).CornerRadius = UDim.new(0, 6)

local ContainerTP = Instance.new("ScrollingFrame", MainFrame)
ContainerTP.Name = "ContentChild"
ContainerTP.BackgroundTransparency = 1
ContainerTP.Position = UDim2.new(0, 160, 0, 45)
ContainerTP.Size = UDim2.new(1, -170, 1, -55)
ContainerTP.CanvasSize = UDim2.new(0, 0, 0, 600)
ContainerTP.ScrollBarThickness = 4
ContainerTP.Parent = ContentHolder

local ContainerJob = Instance.new("ScrollingFrame", MainFrame)
ContainerJob.Name = "ContentChild"
ContainerJob.BackgroundTransparency = 1
ContainerJob.Position = UDim2.new(0, 160, 0, 45)
ContainerJob.Size = UDim2.new(1, -170, 1, -55)
ContainerJob.CanvasSize = UDim2.new(0, 0, 0, 500)
ContainerJob.Visible = false
ContainerJob.ScrollBarThickness = 4
ContainerJob.Parent = ContentHolder

local function switchTab(activeTab)
    ContainerTP.Visible = (activeTab == "TP")
    ContainerJob.Visible = (activeTab == "Job")

    TabTPBtn.BackgroundColor3 = activeTab == "TP" and Color3.fromRGB(40, 40, 52) or Color3.fromRGB(30, 30, 38)
    TabTPBtn.TextColor3 = activeTab == "TP" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 170, 170)

    TabJobBtn.BackgroundColor3 = activeTab == "Job" and Color3.fromRGB(40, 40, 52) or Color3.fromRGB(30, 30, 38)
    TabJobBtn.TextColor3 = activeTab == "Job" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(170, 170, 170)
end

TabTPBtn.MouseButton1Click:Connect(function() switchTab("TP") end)
TabJobBtn.MouseButton1Click:Connect(function() switchTab("Job") end)

CollapseBtn.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        CollapseBtn.Text = "+"
        MainFrame:TweenSize(UDim2.new(0, 550, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        task.delay(0.1, function()
            for _, child in ipairs(MainFrame:GetChildren()) do
                if child.Name == "ContentChild" then child.Visible = false end
            end
        end)
    else
        CollapseBtn.Text = "-"
        for _, child in ipairs(MainFrame:GetChildren()) do
            if child.Name == "ContentChild" then child.Visible = true end
        end
        if ContainerTP.Visible then switchTab("TP") else switchTab("Job") end
        MainFrame:TweenSize(UDim2.new(0, 550, 0, 360), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    end
end)

local function sendNotif(title, msg)
    local notif = Instance.new("TextLabel", ScreenGui)
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.TextSize = 12
    notif.Font = Enum.Font.GothamBold
    notif.Size = UDim2.new(0, 220, 0, 40)
    notif.Position = UDim2.new(1, -230, 1, -60)
    notif.Text = "<b>" .. title .. "</b>\n" .. msg
    notif.RichText = true
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 6)
    task.delay(2, function() notif:Destroy() end)
end

local fileName = "cordinat-litedirr.json"
local daftarLokasi = {}

local function simpanData()
    pcall(function() 
        if writefile then writefile(fileName, HttpService:JSONEncode(daftarLokasi)) end 
    end)
end

local function muatData()
    pcall(function()
        if isfile and readfile and isfile(fileName) then 
            local kontenFile = readfile(fileName)
            if kontenFile and kontenFile ~= "" then
                local hasilDecode = HttpService:JSONDecode(kontenFile)
                if type(hasilDecode) == "table" then daftarLokasi = hasilDecode end
            end
        end 
    end)
end
muatData()

local inputNama = ""
local inputCoord = ""

local function createInput(parent, placeholder, yPos, callback)
    local box = Instance.new("TextBox", parent)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    box.Text = ""
    box.TextSize = 12
    box.Font = Enum.Font.Gotham
    box.Size = UDim2.new(1, -15, 0, 32)
    box.Position = UDim2.new(0, 0, 0, yPos)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    box.FocusLost:Connect(function() callback(box.Text) end)
    return box
end

local function createButton(parent, text, yPos, callback)
    local btn = Instance.new("TextButton", parent)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Size = UDim2.new(1, -15, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, yPos, callback)
    local tFrame = Instance.new("Frame", parent)
    tFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    tFrame.Size = UDim2.new(1, -15, 0, 35)
    tFrame.Position = UDim2.new(0, 0, 0, yPos)
    Instance.new("UICorner", tFrame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", tFrame)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", tFrame)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    toggleBtn.Position = UDim2.new(1, -45, 0.5, -10)
    toggleBtn.Size = UDim2.new(0, 35, 0, 20)
    toggleBtn.Text = ""
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)

    local indicator = Instance.new("Frame", toggleBtn)
    indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    indicator.Position = UDim2.new(0, 2, 0.5, -8)
    indicator.Size = UDim2.new(0, 16, 0, 16)
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 8)

    local toggled = false
    tFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggled = not toggled
            if toggled then
                toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 70)
                indicator:TweenPosition(UDim2.new(1, -18, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
                indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            else
                toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
                indicator:TweenPosition(UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
                indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            end
            callback(toggled)
        end
    end)

    return tFrame
end

createInput(ContainerTP, "Enter item / location name...", 10, function(txt) inputNama = txt end)
local coordBoxRef = createInput(ContainerTP, "Ex: 0, 100, 0", 50, function(txt) inputCoord = txt end)
createButton(ContainerTP, "📍 Get Current Position", 90, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        inputCoord = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        coordBoxRef.Text = inputCoord
        sendNotif("Success", "Position Captured!")
    end
end)

local renderLocations
createButton(ContainerTP, "💾 Save Location", 130, function()
    if inputNama ~= "" and inputCoord ~= "" then
        local split = string.split(inputCoord, ",")
        if #split >= 3 then
            table.insert(daftarLokasi, {Nama = inputNama, X = tonumber(split[1]), Y = tonumber(split[2]), Z = tonumber(split[3])})
            simpanData()
            renderLocations()
            sendNotif("Saved", "Location saved successfully!")
        end
    end
end)

-- Sistem Teleport Dual-Check (SeatPart + Proximity Vehicle Detection)
local function teleportKe(x, y, z)
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local targetCF = CFrame.new(x, y + 4, z)
        
        local targetModel = nil

        -- 1. Cek lewat SeatPart standar
        if humanoid and humanoid.SeatPart then
            local parentObj = humanoid.SeatPart.Parent
            while parentObj and parentObj ~= workspace do
                if parentObj:IsA("Model") then
                    targetModel = parentObj
                    break
                end
                parentObj = parentObj.Parent
            end
        end

        -- 2. Jika SeatPart gagal terbaca di kali kedua, cari model kendaraan terdekat di sekitar karakter (radius 10 studs)
        if not targetModel and rootPart then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj:FindFirstChildOfClass("VehicleSeat") or obj:FindFirstChildOfClass("Seat")) then
                    local primary = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                    if primary and (primary.Position - rootPart.Position).Magnitude <= 12 then
                        targetModel = obj
                        break
                    end
                end
            end
        end

        -- Eksekusi Perpindahan
        if targetModel then
            -- Hentikan momentum fisik agar roda tidak terlepas atau mental
            for _, p in ipairs(targetModel:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.Velocity = Vector3.new(0, 0, 0)
                    p.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
            targetModel:PivotTo(targetCF)
        elseif rootPart then
            rootPart.Velocity = Vector3.new(0, 0, 0)
            rootPart.CFrame = targetCF
        end
    end)
end

renderLocations = function()
    for _, child in ipairs(ContainerTP:GetChildren()) do
        if child.Name == "DynamicTPContainer" then child:Destroy() end
    end
    
    local startY = 180
    for index, data in ipairs(daftarLokasi) do
        local itemFrame = Instance.new("Frame", ContainerTP)
        itemFrame.Name = "DynamicTPContainer"
        itemFrame.BackgroundTransparency = 1
        itemFrame.Size = UDim2.new(1, -15, 0, 32)
        itemFrame.Position = UDim2.new(0, 0, 0, startY)
        
        local tpBtn = Instance.new("TextButton", itemFrame)
        tpBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        tpBtn.TextColor3 = Color3.fromRGB(100, 220, 255)
        tpBtn.Text = "TP: " .. data.Nama
        tpBtn.TextSize = 12
        tpBtn.Font = Enum.Font.GothamMedium
        tpBtn.Size = UDim2.new(1, -40, 1, 0)
        Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
        tpBtn.MouseButton1Click:Connect(function() teleportKe(data.X, data.Y, data.Z) end)
        
        local delBtn = Instance.new("TextButton", itemFrame)
        delBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.Text = "❌"
        delBtn.TextSize = 12
        delBtn.Font = Enum.Font.GothamBold
        delBtn.Size = UDim2.new(0, 32, 1, 0)
        delBtn.Position = UDim2.new(1, -32, 0, 0)
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        delBtn.MouseButton1Click:Connect(function()
            table.remove(daftarLokasi, index)
            simpanData()
            renderLocations()
            sendNotif("Deleted", "Location deleted!")
        end)
        
        startY = startY + 40
    end
    ContainerTP.CanvasSize = UDim2.new(0, 0, 0, startY + 20)
end
renderLocations()

local vehicleDriveAktif = false
createToggle(ContainerJob, "🚗 Vehicle Drive", 10, function(state)
    vehicleDriveAktif = state
    if vehicleDriveAktif then
        task.spawn(function()
            while vehicleDriveAktif do
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                task.wait(0.1)
            end
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        end)
    else
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
    end
end)

local autoJobAktif = false
createToggle(ContainerJob, "💼 Auto Job (Sequential E + TP)", 55, function(state)
    autoJobAktif = state
    if autoJobAktif then
        task.spawn(function()
            while autoJobAktif do
                if #daftarLokasi == 0 then
                    sendNotif("Auto Job", "No saved locations found!")
                    autoJobAktif = false
                    break
                end

                for _, loc in ipairs(daftarLokasi) do
                    if not autoJobAktif then break end

                    teleportKe(loc.X, loc.Y, loc.Z)
                    task.wait(1.5)

                    local startTime = tick()
                    local promptCompleted = false

                    while autoJobAktif and (tick() - startTime < 6) do
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local foundPrompt = nil
                            for _, obj in ipairs(workspace:GetDescendants()) do
                                if obj:IsA("ProximityPrompt") and obj.Enabled then
                                    local pos = obj.Parent:IsA("BasePart") and obj.Parent.Position or (obj.Parent:IsA("Model") and obj.Parent.PrimaryPart and obj.Parent.PrimaryPart.Position)
                                    if pos and (hrp.Position - pos).Magnitude <= 15 then
                                        foundPrompt = obj
                                        break
                                    end
                                end
                            end

                            if foundPrompt then
                                if fireproximityprompt then
                                    pcall(function() fireproximityprompt(foundPrompt) end)
                                end
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                task.wait(foundPrompt.HoldDuration > 0 and foundPrompt.HoldDuration or 0.5)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                
                                promptCompleted = true
                                task.wait(0.5)
                                break
                            end
                        end
                        task.wait(0.3)
                    end

                    if not promptCompleted then
                        task.wait(0.5)
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

createButton(ContainerJob, "📦 Load Preset: Ride Storm", 100, function()
    local dataPreset = {
        {Y = 2078, X = -1587, Z = -1820, Nama = "Ride Storm - 1A"},
        {Y = 2111, X = 13968, Z = 7278, Nama = "Ride Storm - 1B"},
        {Y = 2076, X = -1074, Z = -7919, Nama = "Ride Storm - 2A"},
        {Y = 2231, X = -4278, Z = 22925, Nama = "Ride Storm - 2B"}
    }
    for _, loc in ipairs(dataPreset) do
        table.insert(daftarLokasi, {Nama = loc.Nama, X = loc.X, Y = loc.Y, Z = loc.Z})
    end
    simpanData()
    renderLocations()
    sendNotif("Preset Loaded", "Ride Storm preset added!")
end)

sendNotif("LITEDIRT", "SUBSCRIBE!")
