local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local function getSafeGuiParent()
    local success, parent = pcall(function() if gethui then return gethui() end end)
    if success and parent then return parent end
    
    success, parent = pcall(function() return game:GetService("CoreGui") end)
    if success and parent then return parent end
    
    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = getSafeGuiParent()

pcall(function()
    if GuiParent:FindFirstChild("DeltaModernUI") then GuiParent.DeltaModernUI:Destroy() end
end)

local function applyCorner(gui, radius)
    pcall(function()
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or 8)
        corner.Parent = gui
    end)
end

local function applyGradient(parent, color1, color2)
    pcall(function()
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, color1),
            ColorSequenceKeypoint.new(1, color2)
        }
        gradient.Rotation = 45
        gradient.Parent = parent
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaModernUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GuiParent

local fileName = "cordinat-litedirr.json" 
local daftarLokasi = {}

local function simpanData()
    pcall(function() 
        if writefile then writefile(fileName, HttpService:JSONEncode(daftarLokasi)) end 
    end)
end

local function muatData()
    local success, err = pcall(function()
        if isfile and readfile and isfile(fileName) then 
            local kontenFile = readfile(fileName)
            if kontenFile and kontenFile ~= "" then
                local hasilDecode = HttpService:JSONDecode(kontenFile)
                if type(hasilDecode) == "table" then
                    daftarLokasi = hasilDecode
                else
                    daftarLokasi = {}
                end
            else
                daftarLokasi = {}
            end
        end 
    end)
    if not success then
        daftarLokasi = {}
        simpanData() 
    end
end
muatData()

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 140, 0, 45)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.Text = "💎 LITEDIRT PANEL"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 180)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12
ToggleBtn.Parent = ScreenGui
applyCorner(ToggleBtn, 10)
applyGradient(ToggleBtn, Color3.fromRGB(35, 35, 45), Color3.fromRGB(20, 20, 25))

local menuWidth, menuHeight = 360, 480 
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, menuWidth, 0, menuHeight)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Visible = true -- Langsung muncul setelah di load
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
applyCorner(MainFrame, 12)

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 50)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
HeaderFrame.Parent = MainFrame
applyCorner(HeaderFrame, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -65, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "LITEDIRT | KEYLESS | RIDE STORM"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 11
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = HeaderFrame

local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Size = UDim2.new(0, 35, 0, 30)
CollapseBtn.Position = UDim2.new(1, -42, 0, 10)
CollapseBtn.Text = "-"
CollapseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.Font = Enum.Font.GothamBold
CollapseBtn.TextSize = 18
CollapseBtn.Parent = HeaderFrame
applyCorner(CollapseBtn, 6)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 38)
TabBar.Position = UDim2.new(0, 10, 0, 60)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabTPBtn = Instance.new("TextButton")
TabTPBtn.Size = UDim2.new(0.5, -4, 1, 0)
TabTPBtn.Text = "🌍 Lokasi Teleport"
TabTPBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
TabTPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabTPBtn.Font = Enum.Font.GothamBold
TabTPBtn.Parent = TabBar
applyCorner(TabTPBtn, 8)

local TabSetBtn = Instance.new("TextButton")
TabSetBtn.Size = UDim2.new(0.5, -4, 1, 0)
TabSetBtn.Position = UDim2.new(0.5, 4, 0, 0)
TabSetBtn.Text = "⚙️ Pengaturan"
TabSetBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
TabSetBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
TabSetBtn.Font = Enum.Font.GothamBold
TabSetBtn.Parent = TabBar
applyCorner(TabSetBtn, 8)

local TPContainer = Instance.new("Frame")
TPContainer.Size = UDim2.new(1, 0, 1, -110)
TPContainer.Position = UDim2.new(0, 0, 0, 105)
TPContainer.BackgroundTransparency = 1
TPContainer.Parent = MainFrame

local NameInput = Instance.new("TextBox")
NameInput.Size = UDim2.new(1, -20, 0, 35)
NameInput.Position = UDim2.new(0, 10, 0, 0)
NameInput.PlaceholderText = "Nama Item / Lokasi..."
NameInput.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
NameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
NameInput.Font = Enum.Font.Gotham
NameInput.ClearTextOnFocus = false
NameInput.Parent = TPContainer
applyCorner(NameInput, 8)

local CoordInput = Instance.new("TextBox")
CoordInput.Size = UDim2.new(1, -20, 0, 35)
CoordInput.Position = UDim2.new(0, 10, 0, 42)
CoordInput.PlaceholderText = "X, Y, Z (Kordinat)"
CoordInput.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
CoordInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CoordInput.Font = Enum.Font.Gotham
CoordInput.ClearTextOnFocus = false
CoordInput.Parent = TPContainer
applyCorner(CoordInput, 8)

local GetPosBtn = Instance.new("TextButton")
GetPosBtn.Size = UDim2.new(0.5, -14, 0, 35)
GetPosBtn.Position = UDim2.new(0, 10, 0, 84)
GetPosBtn.Text = "📍 Ambil Posisi"
GetPosBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
GetPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GetPosBtn.Font = Enum.Font.GothamBold
GetPosBtn.Parent = TPContainer
applyCorner(GetPosBtn, 8)

local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(0.5, -14, 0, 35)
SaveBtn.Position = UDim2.new(0.5, 4, 0, 84)
SaveBtn.Text = "💾 Simpan"
SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.Parent = TPContainer
applyCorner(SaveBtn, 8)

local ScrollList = Instance.new("ScrollingFrame")
ScrollList.Size = UDim2.new(1, -20, 1, -130)
ScrollList.Position = UDim2.new(0, 10, 0, 125)
ScrollList.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
ScrollList.BorderSizePixel = 0
ScrollList.ScrollBarThickness = 4
ScrollList.Parent = TPContainer
applyCorner(ScrollList, 8)

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollList
ListLayout.Padding = UDim.new(0, 6)

local SetContainer = Instance.new("Frame")
SetContainer.Size = UDim2.new(1, 0, 1, -110)
SetContainer.Position = UDim2.new(0, 0, 0, 105)
SetContainer.BackgroundTransparency = 1
SetContainer.Visible = false
SetContainer.Parent = MainFrame

local HoldInput = Instance.new("TextBox")
HoldInput.Size = UDim2.new(1, -20, 0, 35)
HoldInput.Position = UDim2.new(0, 10, 0, 5)
HoldInput.PlaceholderText = "Tahan Auto E (Cth: 1.5s)"
HoldInput.Text = "1.5" 
HoldInput.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
HoldInput.TextColor3 = Color3.fromRGB(255, 255, 255)
HoldInput.Font = Enum.Font.Gotham
HoldInput.Parent = SetContainer
applyCorner(HoldInput, 8)

local DelayInput = Instance.new("TextBox")
DelayInput.Size = UDim2.new(1, -20, 0, 35)
DelayInput.Position = UDim2.new(0, 10, 0, 45)
DelayInput.PlaceholderText = "Jeda Auto E (Cth: 0.5s)"
DelayInput.Text = "0.5" 
DelayInput.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
DelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
DelayInput.Font = Enum.Font.Gotham
DelayInput.Parent = SetContainer
applyCorner(DelayInput, 8)

local AutoEBtn = Instance.new("TextButton")
AutoEBtn.Size = UDim2.new(1, -20, 0, 40)
AutoEBtn.Position = UDim2.new(0, 10, 0, 85)
AutoEBtn.Text = "Auto E (Mati)"
AutoEBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
AutoEBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoEBtn.Font = Enum.Font.GothamBold
AutoEBtn.Parent = SetContainer
applyCorner(AutoEBtn, 8)

local AutoTPDelayInput = Instance.new("TextBox")
AutoTPDelayInput.Size = UDim2.new(1, -20, 0, 35)
AutoTPDelayInput.Position = UDim2.new(0, 10, 0, 135)
AutoTPDelayInput.PlaceholderText = "Jeda Auto TP (Cth: 3)"
AutoTPDelayInput.Text = "3" 
AutoTPDelayInput.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
AutoTPDelayInput.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoTPDelayInput.Font = Enum.Font.Gotham
AutoTPDelayInput.Parent = SetContainer
applyCorner(AutoTPDelayInput, 8)

local AutoTPBtn = Instance.new("TextButton")
AutoTPBtn.Size = UDim2.new(1, -20, 0, 40)
AutoTPBtn.Position = UDim2.new(0, 10, 0, 175)
AutoTPBtn.Text = "Auto TP (Mati)"
AutoTPBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
AutoTPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoTPBtn.Font = Enum.Font.GothamBold
AutoTPBtn.Parent = SetContainer
applyCorner(AutoTPBtn, 8)

local PresetBtn = Instance.new("TextButton")
PresetBtn.Size = UDim2.new(1, -20, 0, 40)
PresetBtn.Position = UDim2.new(0, 10, 0, 225)
PresetBtn.Text = "📦 Load Preset: Ride Storm"
PresetBtn.BackgroundColor3 = Color3.fromRGB(110, 50, 200)
PresetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PresetBtn.Font = Enum.Font.GothamBold
PresetBtn.TextSize = 13
PresetBtn.Parent = SetContainer
applyCorner(PresetBtn, 8)

local isCollapsed = false
CollapseBtn.MouseButton1Down:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        CollapseBtn.Text = "+"
        MainFrame:TweenSize(UDim2.new(0, menuWidth, 0, 50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        TabBar.Visible = false
        TPContainer.Visible = false
        SetContainer.Visible = false
    else
        CollapseBtn.Text = "-"
        MainFrame:TweenSize(UDim2.new(0, menuWidth, 0, menuHeight), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        task.wait(0.1)
        TabBar.Visible = true
        TPContainer.Visible = TabTPBtn.BackgroundColor3 == Color3.fromRGB(0, 122, 255)
        SetContainer.Visible = not TPContainer.Visible
    end
end)

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
        ItemFrame.Size = UDim2.new(1, -10, 0, 40)
        ItemFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
        ItemFrame.Parent = ScrollList
        applyCorner(ItemFrame, 8)
        
        local Judul = Instance.new("TextLabel")
        Judul.Size = UDim2.new(1, -100, 1, 0)
        Judul.Position = UDim2.new(0, 10, 0, 0)
        Judul.BackgroundTransparency = 1
        Judul.Text = data.Nama
        Judul.TextColor3 = Color3.fromRGB(255, 255, 255)
        Judul.Font = Enum.Font.GothamMedium
        Judul.TextSize = 13
        Judul.TextXAlignment = Enum.TextXAlignment.Left
        Judul.Parent = ItemFrame
        
        local TPBtn = Instance.new("TextButton")
        TPBtn.Size = UDim2.new(0, 40, 0, 28)
        TPBtn.Position = UDim2.new(1, -95, 0, 6)
        TPBtn.Text = "TP"
        TPBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
        TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TPBtn.Font = Enum.Font.GothamBold
        TPBtn.Parent = ItemFrame
        applyCorner(TPBtn, 6)
        
        local DelBtn = Instance.new("TextButton")
        DelBtn.Size = UDim2.new(0, 45, 0, 28)
        DelBtn.Position = UDim2.new(1, -50, 0, 6)
        DelBtn.Text = "Hapus"
        DelBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        DelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        DelBtn.Font = Enum.Font.GothamBold
        DelBtn.Parent = ItemFrame
        applyCorner(DelBtn, 6)
        
        TPBtn.MouseButton1Down:Connect(function() teleportKe(data.X, data.Y, data.Z) end)
        DelBtn.MouseButton1Down:Connect(function()
            table.remove(daftarLokasi, index)
            simpanData()
            perbaruiDaftar()
        end)
        tinggiCanvas = tinggiCanvas + 46
    end
    ScrollList.CanvasSize = UDim2.new(0, 0, 0, tinggiCanvas)
end

ToggleBtn.MouseButton1Down:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

TabTPBtn.MouseButton1Down:Connect(function()
    if isCollapsed then return end
    TPContainer.Visible = true; SetContainer.Visible = false
    TabTPBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255); TabTPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabSetBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38); TabSetBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

TabSetBtn.MouseButton1Down:Connect(function()
    if isCollapsed then return end
    TPContainer.Visible = false; SetContainer.Visible = true
    TabSetBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255); TabSetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabTPBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38); TabTPBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
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
    PresetBtn.Text = "✨ Preset Dimuat!"
    task.wait(1.5)
    PresetBtn.Text = "📦 Load Preset: Ride Storm"
end)

local autoEAktif = false
AutoEBtn.MouseButton1Down:Connect(function()
    autoEAktif = not autoEAktif
    if autoEAktif then
        AutoEBtn.Text = "Auto E (Hidup)"
        AutoEBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
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
        AutoEBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    end
end)

local autoTPAktif = false; local indexTP = 1
AutoTPBtn.MouseButton1Down:Connect(function()
    if #daftarLokasi == 0 then return end 
    autoTPAktif = not autoTPAktif
    if autoTPAktif then
        AutoTPBtn.Text = "Auto TP (Hidup)"
        AutoTPBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
        task.spawn(function()
            while autoTPAktif do
                if #daftarLokasi == 0 then break end
                if indexTP > #daftarLokasi then indexTP = 1 end
                local loc = daftarLokasi[indexTP]
                if loc then teleportKe(loc.X, loc.Y, loc.Z) end
                indexTP = indexTP + 1
                task.wait(tonumber(AutoTPDelayInput.Text) or 3)
            end
            autoTPAktif = false; AutoTPBtn.Text = "Auto TP (Mati)"; AutoTPBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        end)
    else
        AutoTPBtn.Text = "Auto TP (Mati)"; AutoTPBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    end
end)

perbaruiDaftar()
print("✅ LITEDIRT Panel Berhasil Dimuat!")
