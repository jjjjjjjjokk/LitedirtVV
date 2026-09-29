-- // LITEDIRT CUSTOM UI + DELETE LOCATION FEATURE // --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Hapus UI lama jika ada agar tidak numpuk
if CoreGui:FindFirstChild("LitedirtCustomUI") then
    CoreGui.LitedirtCustomUI:Destroy()
end

local currentLang = "EN"
local texts = {
    EN = {
        title = "LITEDIRT | KEYLESS | RIDE STORM",
        tabTP = "🌍 Teleport Locations",
        tabSet = "⚙ Settings",
        nameInput = "Item / Location Name",
        namePlaceholder = "Enter name...",
        coordInput = "Coordinates (X, Y, Z)",
        coordPlaceholder = "Ex: 0, 100, 0",
        getPos = "📍 Get Current Position",
        save = "💾 Save Location",
        savedSec = "Saved Locations",
        preset = "📦 Load Preset: Ride Storm",
        notifSuccess = "Success",
        notifPos = "Position Captured!",
        notifSaved = "Saved",
        notifLocSaved = "Location saved successfully!",
        notifDel = "Deleted",
        notifLocDel = "Location deleted!",
        notifPreset = "Preset Loaded",
        notifPresetDesc = "Ride Storm preset added!"
    },
    PT = {
        title = "LITEDIRT | KEYLESS | RIDE STORM",
        tabTP = "🌍 Locais de Teleporte",
        tabSet = "⚙️ Configurações",
        nameInput = "Nome do Local",
        namePlaceholder = "Digite o nome...",
        coordInput = "Coordenadas (X, Y, Z)",
        coordPlaceholder = "Ex: 0, 100, 0",
        getPos = "📍 Obter Posição",
        save = "💾 Salvar Local",
        savedSec = "Locais Salvos",
        preset = "📦 Carregar Preset: Ride Storm",
        notifSuccess = "Sucesso",
        notifPos = "Posição Capturada!",
        notifSaved = "Salvo",
        notifLocSaved = "Local salvo com sucesso!",
        notifDel = "Excluído",
        notifLocDel = "Local excluído!",
        notifPreset = "Preset Carregado",
        notifPresetDesc = "Preset Ride Storm adicionado!"
    },
    ID = {
        title = "LITEDIRT | KEYLESS | RIDE STORM",
        tabTP = "🌍 Lokasi Teleport",
        tabSet = "⚙ Pengaturan",
        nameInput = "Nama Item / Lokasi",
        namePlaceholder = "Masukkan nama...",
        coordInput = "Kordinat (X, Y, Z)",
        coordPlaceholder = "Cth: 0, 100, 0",
        getPos = "📍 Ambil Posisi Saat Ini",
        save = "💾 Simpan Lokasi",
        savedSec = "Lokasi Tersimpan",
        preset = "📦 Load Preset: Ride Storm",
        notifSuccess = "Berhasil",
        notifPos = "Posisi Berhasil Diambil!",
        notifSaved = "Disimpan",
        notifLocSaved = "Lokasi berhasil disimpan!",
        notifDel = "Dihapus",
        notifLocDel = "Lokasi berhasil dihapus!",
        notifPreset = "Preset Dimuat",
        notifPresetDesc = "Preset Ride Storm ditambahkan!"
    }
}

local function t(key)
    return texts[currentLang][key] or texts["EN"][key] or key
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LitedirtCustomUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.Size = UDim2.new(0, 550, 0, 360)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- TopBar
local TopBar = Instance.new("Frame", MainFrame)
TopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Text = t("title")
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
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

-- Sidebar Tabs
local Sidebar = Instance.new("ScrollingFrame", MainFrame)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.Size = UDim2.new(0, 150, 1, -35)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 100)
Sidebar.ScrollBarThickness = 2

local TabTPBtn = Instance.new("TextButton", Sidebar)
TabTPBtn.Text = "🌍 Teleport"
TabTPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TabTPBtn.TextSize = 12
TabTPBtn.Font = Enum.Font.GothamMedium
TabTPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
TabTPBtn.Size = UDim2.new(1, -16, 0, 35)
TabTPBtn.Position = UDim2.new(0, 8, 0, 10)
Instance.new("UICorner", TabTPBtn).CornerRadius = UDim.new(0, 6)

local TabSetBtn = Instance.new("TextButton", Sidebar)
TabSetBtn.Text = "⚙ Settings"
TabSetBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
TabSetBtn.TextSize = 12
TabSetBtn.Font = Enum.Font.GothamMedium
TabSetBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TabSetBtn.Size = UDim2.new(1, -16, 0, 35)
TabSetBtn.Position = UDim2.new(0, 8, 0, 55)
Instance.new("UICorner", TabSetBtn).CornerRadius = UDim.new(0, 6)

-- Containers
local ContainerTP = Instance.new("ScrollingFrame", MainFrame)
ContainerTP.BackgroundTransparency = 1
ContainerTP.Position = UDim2.new(0, 160, 0, 45)
ContainerTP.Size = UDim2.new(1, -170, 1, -55)
ContainerTP.CanvasSize = UDim2.new(0, 0, 0, 600)
ContainerTP.ScrollBarThickness = 4

local ContainerSet = Instance.new("ScrollingFrame", MainFrame)
ContainerSet.BackgroundTransparency = 1
ContainerSet.Position = UDim2.new(0, 160, 0, 45)
ContainerSet.Size = UDim2.new(1, -170, 1, -55)
ContainerSet.CanvasSize = UDim2.new(0, 0, 0, 700)
ContainerSet.Visible = false
ContainerSet.ScrollBarThickness = 4

TabTPBtn.MouseButton1Click:Connect(function()
    ContainerTP.Visible = true
    ContainerSet.Visible = false
    TabTPBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    TabTPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabSetBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    TabSetBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
end)

TabSetBtn.MouseButton1Click:Connect(function()
    ContainerTP.Visible = false
    ContainerSet.Visible = true
    TabSetBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    TabSetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabTPBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    TabTPBtn.TextColor3 = Color3.fromRGB(170, 170, 170)
end)

-- Notif System
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
    task.delay(2, function()
        notif:Destroy()
    end)
end

-- Logic & Data
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
                if type(hasilDecode) == "table" then
                    daftarLokasi = hasilDecode
                end
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
    box.FocusLost:Connect(function()
        callback(box.Text)
    end)
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

createInput(ContainerTP, t("namePlaceholder"), 10, function(txt) inputNama = txt end)
local coordBox = createInput(ContainerTP, t("coordPlaceholder"), 50, function(txt) inputCoord = txt end)

createButton(ContainerTP, t("getPos"), 90, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = LocalPlayer.Character.HumanoidRootPart.Position
        inputCoord = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
        coordBox.Text = inputCoord
        sendNotif(t("notifSuccess"), t("notifPos"))
    end
end)

-- Forward declaration for render function
local renderLocations

createButton(ContainerTP, t("save"), 130, function()
    if inputNama ~= "" and inputCoord ~= "" then
        local split = string.split(inputCoord, ",")
        if #split >= 3 then
            table.insert(daftarLokasi, {Nama = inputNama, X = tonumber(split[1]), Y = tonumber(split[2]), Z = tonumber(split[3])})
            simpanData()
            renderLocations()
            sendNotif(t("notifSaved"), t("notifLocSaved"))
        end
    end
end)

-- Smooth Tween Teleport Function
local function teleportKe(x, y, z)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local targetCFrame = CFrame.new(x, y, z)
        
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        local speed = 350 
        local duration = math.clamp(distance / speed, 0.1, 3.5)
        
        hrp.Anchored = true
        
        local platform = Instance.new("Part")
        platform.Size = Vector3.new(15, 1, 15)
        platform.Position = Vector3.new(x, y - 3.5, z)
        platform.Anchored = true
        platform.CanCollide = true
        platform.Transparency = 0.5 
        platform.BrickColor = BrickColor.new("Cyan")
        platform.Parent = workspace
        
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        
        tween:Play()
        tween.Completed:Wait()
        
        task.delay(0.5, function()
            if hrp then hrp.Anchored = false end
            if platform then platform:Destroy() end
        end)
    end
end

-- Render Saved Locations List with Delete Buttons
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
        tpBtn.MouseButton1Click:Connect(function()
            teleportKe(data.X, data.Y, data.Z)
        end)
        
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
            sendNotif(t("notifDel"), t("notifLocDel"))
        end)
        
        startY = startY + 40
    end
    ContainerTP.CanvasSize = UDim2.new(0, 0, 0, startY + 20)
end
renderLocations()

-- Settings Tab Logic
local holdTimeInput = 1.5
local delayTimeInput = 0.5
local autoTPDelayInput = 3

createInput(ContainerSet, "Hold Auto E (seconds) - Default: 1.5", 10, function(txt) holdTimeInput = tonumber(txt) or 1.5 end)
createInput(ContainerSet, "Delay Auto E (seconds) - Default: 0.5", 50, function(txt) delayTimeInput = tonumber(txt) or 0.5 end)

-- Auto E Toggle
local autoEAktif = false
local autoEBtn = createButton(ContainerSet, "Auto E: OFF", 90, function()
    autoEAktif = not autoEAktif
    autoEBtn.Text = autoEAktif and "Auto E: ON" or "Auto E: OFF"
    autoEBtn.BackgroundColor3 = autoEAktif and Color3.fromRGB(40, 120, 60) or Color3.fromRGB(45, 45, 60)
    
    if autoEAktif then
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
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(holdTimeInput)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end
                end
                task.wait(delayTimeInput)
            end
        end)
    end
end)

createInput(ContainerSet, "Auto TP Delay (seconds) - Default: 3", 140, function(txt) autoTPDelayInput = tonumber(txt) or 3 end)

-- Auto TP Toggle
local autoTPAktif = false
local autoTPBtn = createButton(ContainerSet, "Auto TP: OFF", 180, function()
    autoTPAktif = not autoTPAktif
    autoTPBtn.Text = autoTPAktif and "Auto TP: ON" or "Auto TP: OFF"
    autoTPBtn.BackgroundColor3 = autoTPAktif and Color3.fromRGB(40, 120, 60) or Color3.fromRGB(45, 45, 60)
    
    if autoTPAktif then
        task.spawn(function()
            local indexTP = 1
            while autoTPAktif do
                if #daftarLokasi == 0 then break end
                if indexTP > #daftarLokasi then indexTP = 1 end
                local loc = daftarLokasi[indexTP]
                if loc then teleportKe(loc.X, loc.Y, loc.Z) end
                indexTP = indexTP + 1
                task.wait(autoTPDelayInput)
            end
        end)
    end
end)

createButton(ContainerSet, t("preset"), 230, function()
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
    sendNotif(t("notifPreset"), t("notifPresetDesc"))
end)

-- Language Change Buttons
createButton(ContainerSet, "🌐 Language: English (EN)", 280, function()
    currentLang = "EN"
    TitleLabel.Text = t("title")
    sendNotif("Language", "Changed to English")
end)

createButton(ContainerSet, "🌐 Idioma: Português (PT)", 320, function()
    currentLang = "PT"
    TitleLabel.Text = t("title")
    sendNotif("Idioma", "Alterado para Português")
end)

createButton(ContainerSet, "🌐 Bahasa: Indonesia (ID)", 360, function()
    currentLang = "ID"
    TitleLabel.Text = t("title")
    sendNotif("Bahasa", "Diubah ke Bahasa Indonesia")
end)

sendNotif("LITEDIRT", "Custom Menu Loaded with Delete Feature!")
