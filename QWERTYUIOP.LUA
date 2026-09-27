local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- LINK DISCORD & NAMA KREATOR
local DISCORD_LINK = "https://discord.gg/ZuHqAq7h4"

-- Hapus UI lama jika ada
if CoreGui:FindFirstChild("DeltaModernUI") then CoreGui.DeltaModernUI:Destroy() end
if CoreGui:FindFirstChild("StartMenuUI") then CoreGui.StartMenuUI:Destroy() end

local function applyCorner(gui, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = gui
end

-- ==========================================
-- FUNGSI UNTUK MEMUAT MENU UTAMA SCRIPT
-- ==========================================
local function muatMenuUtama()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeltaModernUI"
    ScreenGui.Parent = CoreGui

    local fileName = "cordinat-litedirr.json" 
    local daftarLokasi = {}

    local function simpanData()
        pcall(function() if writefile then writefile(fileName, HttpService:JSONEncode(daftarLokasi)) end end)
    end
    local function muatData()
        pcall(function() if isfile and readfile and isfile(fileName) then daftarLokasi = HttpService:JSONDecode(readfile(fileName)) end end)
    end
    muatData()

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 110, 0, 40)
    ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
    ToggleBtn.Text = "OPEN"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 14
    ToggleBtn.Parent = ScreenGui
    applyCorner(ToggleBtn, 8)

    local menuWidth, menuHeight = 340, 470 
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, menuWidth, 0, menuHeight)
    MainFrame.Position = UDim2.new(0.5, -170, 0.5, -235)
    MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    applyCorner(MainFrame, 10)

    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -20, 0, 35)
    TabBar.Position = UDim2.new(0, 10, 0, 10)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = MainFrame

    local TabTPBtn = Instance.new("TextButton")
    TabTPBtn.Size = UDim2.new(0.5, -5, 1, 0)
    TabTPBtn.Text = "🌍 Teleport"
    TabTPBtn.BackgroundColor3 = Color3.fromRGB(45, 100, 200)
    TabTPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabTPBtn.Font = Enum.Font.GothamBold
    TabTPBtn.Parent = TabBar
    applyCorner(TabTPBtn, 6)

    local TabSetBtn = Instance.new("TextButton")
    TabSetBtn.Size = UDim2.new(0.5, -5, 1, 0)
    TabSetBtn.Position = UDim2.new(0.5, 5, 0, 0)
    TabSetBtn.Text = "⚙️ Setting"
    TabSetBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TabSetBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabSetBtn.Font = Enum.Font.GothamBold
    TabSetBtn.Parent = TabBar
    applyCorner(TabSetBtn, 6)

    -- CONTAINER TELEPORT
    local TPContainer = Instance.new("Frame")
    TPContainer.Size = UDim2.new(1, 0, 1, -95)
    TPContainer.Position = UDim2.new(0, 0, 0, 55)
    TPContainer.BackgroundTransparency = 1
    TPContainer.Parent = MainFrame

    local NameInput = Instance.new("TextBox")
    NameInput.Size = UDim2.new(1, -20, 0, 35)
    NameInput.Position = UDim2.new(0, 10, 0, 0)
    NameInput.PlaceholderText = "Nama Lokasi..."
    NameInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    NameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameInput.ClearTextOnFocus = false
    NameInput.Parent = TPContainer
    applyCorner(NameInput, 6)

    local CoordInput = Instance.new("TextBox")
    CoordInput.Size = UDim2.new(1, -20, 0, 35)
    CoordInput.Position = UDim2.new(0, 10, 0, 45)
    CoordInput.PlaceholderText = "X, Y, Z (Kordinat)"
    CoordInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    CoordInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    CoordInput.ClearTextOnFocus = false
    CoordInput.Parent = TPContainer
    applyCorner(CoordInput, 6)

    local GetPosBtn = Instance.new("TextButton")
    GetPosBtn.Size = UDim2.new(0.5, -15, 0, 35)
    GetPosBtn.Position = UDim2.new(0, 10, 0, 90)
    GetPosBtn.Text = "Ambil Posisi"
    GetPosBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    GetPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetPosBtn.Font = Enum.Font.GothamBold
    GetPosBtn.Parent = TPContainer
    applyCorner(GetPosBtn, 6)

    local SaveBtn = Instance.new("TextButton")
    SaveBtn.Size = UDim2.new(0.5, -15, 0, 35)
    SaveBtn.Position = UDim2.new(0.5, 5, 0, 90)
    SaveBtn.Text = "Simpan"
    SaveBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 100)
    SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveBtn.Font = Enum.Font.GothamBold
    SaveBtn.Parent = TPContainer
    applyCorner(SaveBtn, 6)

    local ScrollList = Instance.new("ScrollingFrame")
    ScrollList.Size = UDim2.new(1, -20, 1, -135)
    ScrollList.Position = UDim2.new(0, 10, 0, 135)
    ScrollList.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    ScrollList.ScrollBarThickness = 5
    ScrollList.Parent = TPContainer
    applyCorner(ScrollList, 6)

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = ScrollList
    ListLayout.Padding = UDim.new(0, 5)

    -- CONTAINER SETTING
    local SetContainer = Instance.new("Frame")
    SetContainer.Size = UDim2.new(1, 0, 1, -95)
    SetContainer.Position = UDim2.new(0, 0, 0, 55)
    SetContainer.BackgroundTransparency = 1
    SetContainer.Visible = false
    SetContainer.Parent = MainFrame

    local HoldInput = Instance.new("TextBox")
    HoldInput.Size = UDim2.new(1, -20, 0, 35)
    HoldInput.Position = UDim2.new(0, 10, 0, 5)
    HoldInput.PlaceholderText = "Tahan Auto E (Cth: 1.5s)"
    HoldInput.Text = "1.5" 
    HoldInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    HoldInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    HoldInput.ClearTextOnFocus = false
    HoldInput.Parent = SetContainer
    applyCorner(HoldInput, 6)

    local DelayInput = Instance.new("TextBox")
    DelayInput.Size = UDim2.new(1, -20, 0, 35)
    DelayInput.Position = UDim2.new(0, 10, 0, 45)
    DelayInput.PlaceholderText = "Jeda Auto E (Cth: 0.5s)"
    DelayInput.Text = "0.5" 
    DelayInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    DelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    DelayInput.ClearTextOnFocus = false
    DelayInput.Parent = SetContainer
    applyCorner(DelayInput, 6)

    local AutoEBtn = Instance.new("TextButton")
    AutoEBtn.Size = UDim2.new(1, -20, 0, 40)
    AutoEBtn.Position = UDim2.new(0, 10, 0, 85)
    AutoEBtn.Text = "Auto E (Mati)"
    AutoEBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    AutoEBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoEBtn.Font = Enum.Font.GothamBold
    AutoEBtn.Parent = SetContainer
    applyCorner(AutoEBtn, 6)

    local AutoTPDelayInput = Instance.new("TextBox")
    AutoTPDelayInput.Size = UDim2.new(1, -20, 0, 35)
    AutoTPDelayInput.Position = UDim2.new(0, 10, 0, 145)
    AutoTPDelayInput.PlaceholderText = "Jeda Auto TP (Cth: 3 detik)"
    AutoTPDelayInput.Text = "3" 
    AutoTPDelayInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    AutoTPDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoTPDelayInput.ClearTextOnFocus = false
    AutoTPDelayInput.Parent = SetContainer
    applyCorner(AutoTPDelayInput, 6)

    local AutoTPBtn = Instance.new("TextButton")
    AutoTPBtn.Size = UDim2.new(1, -20, 0, 40)
    AutoTPBtn.Position = UDim2.new(0, 10, 0, 185)
    AutoTPBtn.Text = "Auto TP (Mati)"
    AutoTPBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    AutoTPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    AutoTPBtn.Font = Enum.Font.GothamBold
    AutoTPBtn.Parent = SetContainer
    applyCorner(AutoTPBtn, 6)

    -- TOMBOL PRESET RIDE STORM
    local PresetBtn = Instance.new("TextButton")
    PresetBtn.Size = UDim2.new(1, -20, 0, 40)
    PresetBtn.Position = UDim2.new(0, 10, 0, 240)
    PresetBtn.Text = "Load Preset: Auto Farm Ride Storm"
    PresetBtn.BackgroundColor3 = Color3.fromRGB(150, 75, 200) -- Warna ungu
    PresetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    PresetBtn.Font = Enum.Font.GothamBold
    PresetBtn.TextSize = 13
    PresetBtn.Parent = SetContainer
    applyCorner(PresetBtn, 6)

    local ResizeFrame = Instance.new("Frame")
    ResizeFrame.Size = UDim2.new(1, 0, 0, 35)
    ResizeFrame.Position = UDim2.new(0, 0, 1, -40)
    ResizeFrame.BackgroundTransparency = 1
    ResizeFrame.Parent = MainFrame

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0.5, -15, 1, 0)
    MinBtn.Position = UDim2.new(0, 10, 0, 0)
    MinBtn.Text = "- Perkecil"
    MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = ResizeFrame
    applyCorner(MinBtn, 6)

    local PlusBtn = Instance.new("TextButton")
    PlusBtn.Size = UDim2.new(0.5, -15, 1, 0)
    PlusBtn.Position = UDim2.new(0.5, 5, 0, 0)
    PlusBtn.Text = "+ Perbesar"
    PlusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    PlusBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlusBtn.Font = Enum.Font.GothamBold
    PlusBtn.Parent = ResizeFrame
    applyCorner(PlusBtn, 6)

    -- Fungsi Teleport dengan Anti-Void (Di Bawah Kaki)
    local function teleportKe(x, y, z)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            hrp.Anchored = true
            hrp.CFrame = CFrame.new(x, y, z)
            
            local platform = Instance.new("Part")
            platform.Size = Vector3.new(15, 1, 15)
            platform.Position = Vector3.new(x, y - 3.5, z)
            platform.Anchored = true
            platform.CanCollide = true
            platform.Transparency = 0.5 
            platform.BrickColor = BrickColor.new("Cyan")
            platform.Parent = workspace
            
            task.delay(1, function()
                if hrp then hrp.Anchored = false end
                if platform then platform:Destroy() end
            end)
        end
    end

    local function perbaruiDaftar()
        for _, item in ipairs(ScrollList:GetChildren()) do
            if item:IsA("Frame") then item:Destroy() end
        end
        local tinggiCanvas = 0
        for index, data in ipairs(daftarLokasi) do
            local ItemFrame = Instance.new("Frame")
            ItemFrame.Size = UDim2.new(1, -10, 0, 35)
            ItemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            ItemFrame.Parent = ScrollList
            applyCorner(ItemFrame, 6)
            
            local Judul = Instance.new("TextLabel")
            Judul.Size = UDim2.new(1, -100, 1, 0)
            Judul.Position = UDim2.new(0, 10, 0, 0)
            Judul.BackgroundTransparency = 1
            Judul.Text = data.Nama
            Judul.TextColor3 = Color3.fromRGB(255, 255, 255)
            Judul.TextXAlignment = Enum.TextXAlignment.Left
            Judul.Parent = ItemFrame
            
            local TPBtn = Instance.new("TextButton")
            TPBtn.Size = UDim2.new(0, 40, 0, 25)
            TPBtn.Position = UDim2.new(1, -95, 0, 5)
            TPBtn.Text = "TP"
            TPBtn.BackgroundColor3 = Color3.fromRGB(45, 100, 200)
            TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TPBtn.Parent = ItemFrame
            applyCorner(TPBtn, 4)
            
            local DelBtn = Instance.new("TextButton")
            DelBtn.Size = UDim2.new(0, 45, 0, 25)
            DelBtn.Position = UDim2.new(1, -50, 0, 5)
            DelBtn.Text = "Hapus"
            DelBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            DelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            DelBtn.Parent = ItemFrame
            applyCorner(DelBtn, 4)
            
            TPBtn.MouseButton1Down:Connect(function() teleportKe(data.X, data.Y, data.Z) end)
            DelBtn.MouseButton1Down:Connect(function()
                table.remove(daftarLokasi, index)
                simpanData()
                perbaruiDaftar()
            end)
            tinggiCanvas = tinggiCanvas + 40
        end
        ScrollList.CanvasSize = UDim2.new(0, 0, 0, tinggiCanvas)
    end

    ToggleBtn.MouseButton1Down:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        ToggleBtn.Text = MainFrame.Visible and "CLOSE" or "OPEN"
    end)
    TabTPBtn.MouseButton1Down:Connect(function()
        TPContainer.Visible = true; SetContainer.Visible = false
        TabTPBtn.BackgroundColor3 = Color3.fromRGB(45, 100, 200); TabTPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabSetBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40); TabSetBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)
    TabSetBtn.MouseButton1Down:Connect(function()
        TPContainer.Visible = false; SetContainer.Visible = true
        TabSetBtn.BackgroundColor3 = Color3.fromRGB(45, 100, 200); TabSetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabTPBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40); TabTPBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    end)

    GetPosBtn.MouseButton1Down:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local pos = LocalPlayer.Character.HumanoidRootPart.Position
            CoordInput.Text = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        end
    end)
    
    SaveBtn.MouseButton1Down:Connect(function()
        local nama, kordinat = NameInput.Text, CoordInput.Text
        if nama ~= "" and kordinat ~= "" then
            local split = string.split(kordinat, ",")
            if #split >= 3 then
                table.insert(daftarLokasi, {Nama = nama, X = tonumber(split[1]), Y = tonumber(split[2]), Z = tonumber(split[3])})
                simpanData(); perbaruiDaftar()
                NameInput.Text = ""; CoordInput.Text = ""
            end
        end
    end)

    -- LOGIKA TOMBOL PRESET RIDE STORM
    PresetBtn.MouseButton1Down:Connect(function()
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
        perbaruiDaftar()
        
        PresetBtn.Text = "Preset Berhasil Ditambahkan!"
        PresetBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 100)
        task.wait(1.5)
        PresetBtn.Text = "Load Preset: Auto Farm Ride Storm"
        PresetBtn.BackgroundColor3 = Color3.fromRGB(150, 75, 200)
    end)

    local autoEAktif = false
    AutoEBtn.MouseButton1Down:Connect(function()
        autoEAktif = not autoEAktif
        if autoEAktif then
            AutoEBtn.Text = "Auto E (Hidup)"
            AutoEBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 100)
            task.spawn(function()
                while autoEAktif do
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local adaPromptDekat = false
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") and obj.Enabled then
                                local pos = obj.Parent:IsA("BasePart") and obj.Parent.Position or (obj.Parent:IsA("Model") and obj.Parent.PrimaryPart and obj.Parent.PrimaryPart.Position)
                                if pos and (hrp.Position - pos).Magnitude <= 12 then
                                    adaPromptDekat = true
                                    if fireproximityprompt then pcall(function() fireproximityprompt(obj) end) end
                                    break
                                end
                            end
                        end
                        if adaPromptDekat then
                            local holdTime = tonumber(HoldInput.Text) or 1.5
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            task.wait(holdTime)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        end
                    end
                    task.wait(tonumber(DelayInput.Text) or 0.5)
                end
            end)
        else
            AutoEBtn.Text = "Auto E (Mati)"
            AutoEBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end)

    local autoTPAktif = false; local indexTP = 1
    AutoTPBtn.MouseButton1Down:Connect(function()
        if #daftarLokasi == 0 then return end 
        autoTPAktif = not autoTPAktif
        if autoTPAktif then
            AutoTPBtn.Text = "Auto TP (Hidup)"
            AutoTPBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 100)
            task.spawn(function()
                while autoTPAktif do
                    if #daftarLokasi == 0 then break end
                    if indexTP > #daftarLokasi then indexTP = 1 end
                    local loc = daftarLokasi[indexTP]
                    if loc then teleportKe(loc.X, loc.Y, loc.Z) end
                    indexTP = indexTP + 1
                    task.wait(tonumber(AutoTPDelayInput.Text) or 3)
                end
                autoTPAktif = false; AutoTPBtn.Text = "Auto TP (Mati)"; AutoTPBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end)
        else
            AutoTPBtn.Text = "Auto TP (Mati)"; AutoTPBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end)

    PlusBtn.MouseButton1Down:Connect(function() if menuWidth < 500 then menuWidth = menuWidth + 40; menuHeight = menuHeight + 50; MainFrame.Size = UDim2.new(0, menuWidth, 0, menuHeight) end end)
    MinBtn.MouseButton1Down:Connect(function() if menuWidth > 280 then menuWidth = menuWidth - 40; menuHeight = menuHeight - 50; MainFrame.Size = UDim2.new(0, menuWidth, 0, menuHeight) end end)
    
    perbaruiDaftar()
end

-- ==========================================
-- MEMBUAT TAMPILAN START AWAL (DENGAN WATERMARK)
-- ==========================================
local StartGui = Instance.new("ScreenGui")
StartGui.Name = "StartMenuUI"
StartGui.Parent = CoreGui

local StartFrame = Instance.new("Frame")
StartFrame.Size = UDim2.new(0, 280, 0, 160)
StartFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
StartFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
StartFrame.Active = true
StartFrame.Draggable = true
StartFrame.Parent = StartGui
applyCorner(StartFrame, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "BETA"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = StartFrame
applyCorner(Title, 10)

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, -20, 0, 45)
InfoText.Position = UDim2.new(0, 10, 0, 50)
InfoText.Text = "Script by LITEDIRT"
InfoText.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoText.BackgroundTransparency = 1
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 12
InfoText.TextWrapped = true
InfoText.Parent = StartFrame

local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(1, -40, 0, 40)
StartBtn.Position = UDim2.new(0, 20, 0, 105)
StartBtn.Text = "START"
StartBtn.BackgroundColor3 = Color3.fromRGB(45, 100, 200)
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 16
StartBtn.Parent = StartFrame
applyCorner(StartBtn, 8)

-- LOGIKA SAAT TOMBOL START DITEKAN
StartBtn.MouseButton1Down:Connect(function()
    pcall(function()
        if setclipboard then
            setclipboard(DISCORD_LINK)
        end
    end)
    
    StartBtn.Text = "LOADING"
    StartBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 100)
    
    task.wait(0.8)
    StartGui:Destroy()
    muatMenuUtama()
end)
