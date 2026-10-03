-- // LITEDIRT LOCKED TABS - CLEAN MINIMAL (NO AUTO DRIVE) // --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Hapus bersih GUI lama agar tidak ke-dupe saat di-run ulang
pcall(function()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "LitedirtLockedTabs" then 
            gui:Destroy() 
        end
    end
    for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "LitedirtLockedTabs" then 
            gui:Destroy() 
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LitedirtLockedTabs"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local function makeDraggable(dragHandle, targetFrame)
    local dragging, dragStart, startPos = false, nil, nil
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function createFloatingTab(name, startX)
    local TabFrame = Instance.new("Frame", ScreenGui)
    TabFrame.Size = UDim2.new(0, 115, 0, 32)
    TabFrame.Position = UDim2.new(0.5, startX, 0, 10)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Active = true

    local TabBtn = Instance.new("TextButton", TabFrame)
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.Position = UDim2.new(0, 0, 0, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TabBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
    TabBtn.Text = "[+] " .. name
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 11
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", TabBtn).Color = Color3.fromRGB(0, 200, 255)

    makeDraggable(TabBtn, TabFrame)

    local Panel = Instance.new("ScrollingFrame", TabFrame)
    Panel.Size = UDim2.new(1, 0, 0, 150)
    Panel.Position = UDim2.new(0, 0, 0, 35)
    Panel.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Panel.BackgroundTransparency = 0.05
    Panel.Visible = false
    Panel.ScrollBarThickness = 2
    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Panel).Color = Color3.fromRGB(40, 40, 50)
    
    local layout = Instance.new("UIListLayout", Panel)
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local pad = Instance.new("UIPadding", Panel)
    pad.PaddingTop = UDim.new(0, 5)
    pad.PaddingBottom = UDim.new(0, 5)

    TabBtn.MouseButton1Click:Connect(function()
        Panel.Visible = not Panel.Visible
        TabFrame.Size = Panel.Visible and UDim2.new(0, 115, 0, 185) or UDim2.new(0, 115, 0, 32)
        TabBtn.Text = Panel.Visible and "[-] " .. name or "[+] " .. name
    end)

    return Panel
end

local TabAuto = createFloatingTab("Auto", -175)      
local TabConfig = createFloatingTab("Config", -57)   
local TabTeleport = createFloatingTab("Teleport", 60)  

local fileName = "cordinat-litedirr.json"
local daftarLokasi = {}

local function simpanData()
    pcall(function() if writefile then writefile(fileName, HttpService:JSONEncode(daftarLokasi)) end end)
end

local function muatData()
    pcall(function()
        if isfile and readfile and isfile(fileName) then 
            local hasil = HttpService:JSONDecode(readfile(fileName))
            if type(hasil) == "table" then daftarLokasi = hasil end
        end 
    end)
end
muatData()

local function manualTp(x, y, z)
    pcall(function()
        local c = LocalPlayer.Character
        if not c then return end
        local r = c:FindFirstChild("HumanoidRootPart")
        if r then
            r.Velocity = Vector3.zero
            r.CFrame = CFrame.new(x, y + 4, z)
        end
    end)
end

local function jobTp(x, y, z)
    pcall(function()
        local c = LocalPlayer.Character
        if not c then return end
        local r, h = c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
        local targetCF = CFrame.new(x, y + 4, z)
        local tM = nil

        if h and h.SeatPart then
            local pObj = h.SeatPart.Parent
            while pObj and pObj ~= workspace do
                if pObj:IsA("Model") then tM = pObj break end
                pObj = pObj.Parent
            end
        end

        if not tM and r then
            for _, o in ipairs(workspace:GetDescendants()) do
                if o:IsA("Model") and (o:FindFirstChildOfClass("VehicleSeat") or o:FindFirstChildOfClass("Seat")) then
                    local p = o.PrimaryPart or o:FindFirstChild("HumanoidRootPart") or o:FindFirstChildWhichIsA("BasePart")
                    if p and (p.Position - r.Position).Magnitude <= 12 then tM = o break end
                end
            end
        end

        if tM then
            for _, p in ipairs(tM:GetDescendants()) do
                if p:IsA("BasePart") then p.Velocity = Vector3.zero p.RotVelocity = Vector3.zero end
            end
            tM:PivotTo(targetCF)
        elseif r then
            r.Velocity = Vector3.zero
            r.CFrame = targetCF
        end
    end)
end

local autoJobAktif = false
local AutoJobBtn = Instance.new("TextButton", TabAuto)
AutoJobBtn.Size = UDim2.new(0.9, 0, 0, 32)
AutoJobBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AutoJobBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
AutoJobBtn.Text = "Auto Job"
AutoJobBtn.Font = Enum.Font.GothamBold
AutoJobBtn.TextSize = 10
Instance.new("UICorner", AutoJobBtn).CornerRadius = UDim.new(0, 5)

AutoJobBtn.MouseButton1Click:Connect(function()
    autoJobAktif = not autoJobAktif
    AutoJobBtn.TextColor3 = autoJobAktif and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(150, 150, 150)
    
    if autoJobAktif then
        task.spawn(function()
            while autoJobAktif do
                if #daftarLokasi == 0 then 
                    autoJobAktif = false 
                    AutoJobBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
                    break 
                end
                
                for _, loc in ipairs(daftarLokasi) do
                    if not autoJobAktif then break end
                    jobTp(loc.X, loc.Y, loc.Z)
                    task.wait(0.3) -- Jeda teleport super cepat

                    local st = tick()
                    local ok = false
                    
                    -- Batas pencarian tombol E maksimal 1 detik
                    while autoJobAktif and (tick() - st < 1.0) do
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local px = nil
                            for _, obj in ipairs(workspace:GetDescendants()) do
                                if obj:IsA("ProximityPrompt") and obj.Enabled then
                                    local p = obj.Parent:IsA("BasePart") and obj.Parent.Position or (obj.Parent:IsA("Model") and obj.Parent.PrimaryPart and obj.Parent.PrimaryPart.Position)
                                    if p and (hrp.Position - p).Magnitude <= 18 then px = obj break end
                                end
                            end

                            if px then
                                if fireproximityprompt then pcall(function() fireproximityprompt(px) end) end
                                if VirtualInputManager then pcall(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game) end) end
                                task.wait(px.HoldDuration > 0 and px.HoldDuration or 0.1)
                                if VirtualInputManager then pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game) end) end
                                
                                ok = true
                                task.wait(0.1)
                                break
                            end
                        end
                        task.wait(0.05) -- Pengecekan super ngebut tiap 0.05 detik
                    end
                    
                    if not ok then task.wait(0.1) end
                end
                task.wait(0.2)
            end
        end)
    else
        autoJobAktif = false
    end
end)

local inputNama, inputCoord = "", ""

local NameBox = Instance.new("TextBox", TabConfig)
NameBox.Size = UDim2.new(0.9, 0, 0, 26)
NameBox.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
NameBox.PlaceholderText = "Name"
NameBox.Font = Enum.Font.Gotham
NameBox.TextSize = 10
Instance.new("UICorner", NameBox).CornerRadius = UDim.new(0, 5)
NameBox.FocusLost:Connect(function() inputNama = NameBox.Text end)

local CoordBox = Instance.new("TextBox", TabConfig)
CoordBox.Size = UDim2.new(0.9, 0, 0, 26)
CoordBox.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
CoordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CoordBox.PlaceholderText = "X, Y, Z"
CoordBox.Font = Enum.Font.Gotham
CoordBox.TextSize = 10
Instance.new("UICorner", CoordBox).CornerRadius = UDim.new(0, 5)
CoordBox.FocusLost:Connect(function() inputCoord = CoordBox.Text end)

local GetPosBtn = Instance.new("TextButton", TabConfig)
GetPosBtn.Size = UDim2.new(0.9, 0, 0, 26)
GetPosBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
GetPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetPosBtn.Text = "Get Pos"
GetPosBtn.Font = Enum.Font.GothamBold
GetPosBtn.TextSize = 10
Instance.new("UICorner", GetPosBtn).CornerRadius = UDim.new(0, 5)

GetPosBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        inputCoord = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        CoordBox.Text = inputCoord
    end
end)

local SaveBtn = Instance.new("TextButton", TabConfig)
SaveBtn.Size = UDim2.new(0.9, 0, 0, 26)
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Text = "Save"
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 10
Instance.new("UICorner", SaveBtn).CornerRadius = UDim.new(0, 5)

local renderTPList
SaveBtn.MouseButton1Click:Connect(function()
    if inputNama ~= "" and inputCoord ~= "" then
        local split = string.split(inputCoord, ",")
        if #split >= 3 then
            table.insert(daftarLokasi, {Nama = inputNama, X = tonumber(split[1]), Y = tonumber(split[2]), Z = tonumber(split[3])})
            simpanData()
            renderTPList()
        end
    end
end)

local PresetBtn = Instance.new("TextButton", TabConfig)
PresetBtn.Size = UDim2.new(0.9, 0, 0, 26)
PresetBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 150)
PresetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PresetBtn.Text = "Preset"
PresetBtn.Font = Enum.Font.GothamBold
PresetBtn.TextSize = 10
Instance.new("UICorner", PresetBtn).CornerRadius = UDim.new(0, 5)

PresetBtn.MouseButton1Click:Connect(function()
    local p = {
        {Y=2078, X=-1587, Z=-1820, Nama="Ride Storm 1A"},
        {Y=2111, X=13968, Z=7278, Nama="Ride Storm 1B"},
        {Y=2076, X=-1074, Z=-7919, Nama="Ride Storm 2A"},
        {Y=2231, X=-4278, Z=22925, Nama="Ride Storm 2B"}
    }
    for _, l in ipairs(p) do table.insert(daftarLokasi, {Nama=l.Nama, X=l.X, Y=l.Y, Z=l.Z}) end
    simpanData()
    renderTPList()
end)

renderTPList = function()
    for _, v in ipairs(TabTeleport:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    
    for i, d in ipairs(daftarLokasi) do
        local fr = Instance.new("Frame", TabTeleport)
        fr.Size = UDim2.new(0.9, 0, 0, 26)
        fr.BackgroundTransparency = 1
        
        local btn = Instance.new("TextButton", fr)
        btn.Size = UDim2.new(1, -20, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Text = d.Nama
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        btn.MouseButton1Click:Connect(function() manualTp(d.X, d.Y, d.Z) end)
        
        local del = Instance.new("TextButton", fr)
        del.Size = UDim2.new(0, 18, 1, 0)
        del.Position = UDim2.new(1, -18, 0, 0)
        del.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        del.TextColor3 = Color3.fromRGB(255, 255, 255)
        del.Text = "X"
        del.Font = Enum.Font.GothamBold
        Instance.new("UICorner", del).CornerRadius = UDim.new(0, 5)
        del.MouseButton1Click:Connect(function()
            table.remove(daftarLokasi, i)
            simpanData()
            renderTPList()
        end)
    end
end
renderTPList()
