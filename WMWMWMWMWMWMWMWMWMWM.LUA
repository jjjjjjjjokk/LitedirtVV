local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()

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
        holdInput = "Hold Auto E (seconds)",
        delayInput = "Delay Auto E (seconds)",
        autoE = "Auto E",
        autoTPDelay = "Auto TP Delay (seconds)",
        autoTP = "Auto TP",
        preset = "📦 Load Preset: Ride Storm",
        langLabel = "🌐 Language / Bahasa / Idioma",
        notifSuccess = "Success",
        notifPos = "Position Captured!",
        notifSaved = "Saved",
        notifLocSaved = "Location saved successfully!",
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
        holdInput = "Segurar Auto E (seg)",
        delayInput = "Atraso Auto E (seg)",
        autoE = "Auto E",
        autoTPDelay = "Atraso Auto TP (seg)",
        autoTP = "Auto TP",
        preset = "📦 Carregar Preset: Ride Storm",
        langLabel = "🌐 Idioma",
        notifSuccess = "Sucesso",
        notifPos = "Posição Capturada!",
        notifSaved = "Salvo",
        notifLocSaved = "Local salvo com sucesso!",
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
        holdInput = "Tahan Auto E (detik)",
        delayInput = "Jeda Auto E (detik)",
        autoE = "Auto E",
        autoTPDelay = "Jeda Auto TP (detik)",
        autoTP = "Auto TP",
        preset = "📦 Load Preset: Ride Storm",
        langLabel = "🌐 Bahasa",
        notifSuccess = "Berhasil",
        notifPos = "Posisi Berhasil Diambil!",
        notifSaved = "Disimpan",
        notifLocSaved = "Lokasi berhasil disimpan!",
        notifPreset = "Preset Dimuat",
        notifPresetDesc = "Preset Ride Storm ditambahkan!"
    }
}

local function t(key)
    return texts[currentLang][key] or texts["EN"][key] or key
end

-- Create Window
local Window = WindUI:CreateWindow({
    Title = t("title"),
    Icon = "globe",
    Author = "by Community",
    Folder = "LitedirtConfig",
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    Transparent = true,
    Resizable = true,
})

local Tabs = {
    TP = Window:Tab({ Title = t("tabTP"), Icon = "map-pin" }),
    Settings = Window:Tab({ Title = t("tabSet"), Icon = "settings" })
}

local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer

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

Tabs.TP:Input({
    Title = t("nameInput"),
    Placeholder = t("namePlaceholder"),
    Callback = function(text)
        inputNama = text
    end
})

Tabs.TP:Input({
    Title = t("coordInput"),
    Placeholder = t("coordPlaceholder"),
    Callback = function(text)
        inputCoord = text
    end
})

Tabs.TP:Button({
    Title = t("getPos"),
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local pos = LocalPlayer.Character.HumanoidRootPart.Position
            inputCoord = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
            WindUI:Notify({Title = t("notifSuccess"), Content = t("notifPos"), Duration = 2})
        end
    end
})

Tabs.TP:Button({
    Title = t("save"),
    Callback = function()
        if inputNama ~= "" and inputCoord ~= "" then
            local split = string.split(inputCoord, ",")
            if #split >= 3 then
                table.insert(daftarLokasi, {Nama = inputNama, X = tonumber(split[1]), Y = tonumber(split[2]), Z = tonumber(split[3])})
                simpanData()
                WindUI:Notify({Title = t("notifSaved"), Content = t("notifLocSaved"), Duration = 2})
            end
        end
    end
})

Tabs.TP:Divider()

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

for _, data in ipairs(daftarLokasi) do
    Tabs.TP:Button({
        Title = "TP to: " .. data.Nama,
        Desc = string.format("X: %.1f | Y: %.1f | Z: %.1f", data.X, data.Y, data.Z),
        Callback = function()
            teleportKe(data.X, data.Y, data.Z)
        end
    })
end

local holdTimeInput = 1.5
local delayTimeInput = 0.5
local autoTPDelayInput = 3

Tabs.Settings:Input({
    Title = t("holdInput"),
    Default = "1.5",
    Callback = function(text)
        holdTimeInput = tonumber(text) or 1.5
    end
})

Tabs.Settings:Input({
    Title = t("delayInput"),
    Default = "0.5",
    Callback = function(text)
        delayTimeInput = tonumber(text) or 0.5
    end
})

local autoEAktif = false
Tabs.Settings:Toggle({
    Title = t("autoE"),
    Default = false,
    Callback = function(Value)
        autoEAktif = Value
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
    end
})

Tabs.Settings:Input({
    Title = t("autoTPDelay"),
    Default = "3",
    Callback = function(text)
        autoTPDelayInput = tonumber(text) or 3
    end
})

local autoTPAktif = false
Tabs.Settings:Toggle({
    Title = t("autoTP"),
    Default = false,
    Callback = function(Value)
        autoTPAktif = Value
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
    end
})

Tabs.Settings:Button({
    Title = t("preset"),
    Callback = function()
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
        WindUI:Notify({Title = t("notifPreset"), Content = t("notifPresetDesc"), Duration = 2})
    end
})

Tabs.Settings:Dropdown({
    Title = t("langLabel"),
    Values = {"English", "Português", "Indo"},
    Value = "English",
    Callback = function(Option)
        if Option == "English" then
            currentLang = "EN"
        elseif Option == "Português" then
            currentLang = "PT"
        elseif Option == "Indo" then
            currentLang = "ID"
        end
        WindUI:Notify({Title = "Language", Content = "Language changed. Please re-execute script to update UI elements.", Duration = 3})
    end
})

WindUI:Notify({
    Title = "LITEDIRT",
    Content = "Loaded successfully with WindUI & Smooth Tween!",
    Duration = 5
})
