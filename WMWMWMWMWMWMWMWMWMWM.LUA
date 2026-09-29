local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local currentLang = "EN"
local texts = {
    EN = {
        title = "LITEDIRT | KEYLESS | RIDE STORM",
        tabTP = "🌍 Teleport Locations",
        tabSet = "⚙️ Settings",
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
        nameInput = "Nome do Item / Local",
        namePlaceholder = "Digite o nome...",
        coordInput = "Coordenadas (X, Y, Z)",
        coordPlaceholder = "Ex: 0, 100, 0",
        getPos = "📍 Obter Posição Atual",
        save = "💾 Salvar Local",
        savedSec = "Locais Salvos",
        holdInput = "Segurar Auto E (segundos)",
        delayInput = "Atraso Auto E (segundos)",
        autoE = "Auto E",
        autoTPDelay = "Atraso Auto TP (segundos)",
        autoTP = "Auto TP",
        preset = "📦 Carregar Preset: Ride Storm",
        langLabel = "🌐 Language / Bahasa / Idioma",
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
        tabSet = "⚙️ Pengaturan",
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
        langLabel = "🌐 Language / Bahasa / Idioma",
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

local Window = Rayfield:CreateWindow({
    Name = t("title"),
    LoadingTitle = "LITEDIRT PANEL",
    LoadingSubtitle = "by Community",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "LitedirtConfig",
        FileName = "Config"
    },
    KeySystem = false,
})

local TabTP = Window:CreateTab(t("tabTP"), 4483362458)
local TabSet = Window:CreateTab(t("tabSet"), 4483345998)

local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
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

TabTP:CreateInput({
    Name = t("nameInput"),
    PlaceholderText = t("namePlaceholder"),
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        inputNama = text
    end
})

TabTP:CreateInput({
    Name = t("coordInput"),
    PlaceholderText = t("coordPlaceholder"),
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        inputCoord = text
    end
})

TabTP:CreateButton({
    Name = t("getPos"),
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local pos = LocalPlayer.Character.HumanoidRootPart.Position
            inputCoord = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
            Rayfield:Notify({Title = t("notifSuccess"), Content = t("notifPos"), Duration = 2})
        end
    end
})

TabTP:CreateButton({
    Name = t("save"),
    Callback = function()
        if inputNama ~= "" and inputCoord ~= "" then
            local split = string.split(inputCoord, ",")
            if #split >= 3 then
                table.insert(daftarLokasi, {Nama = inputNama, X = tonumber(split[1]), Y = tonumber(split[2]), Z = tonumber(split[3])})
                simpanData()
                Rayfield:Notify({Title = t("notifSaved"), Content = t("notifLocSaved"), Duration = 2})
            end
        end
    end
})

TabTP:CreateSection(t("savedSec"))

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

for _, data in ipairs(daftarLokasi) do
    TabTP:CreateButton({
        Name = "TP to: " .. data.Nama,
        Callback = function()
            teleportKe(data.X, data.Y, data.Z)
        end
    })
end

local holdTimeInput = 1.5
local delayTimeInput = 0.5
local autoTPDelayInput = 3

TabSet:CreateInput({
    Name = t("holdInput"),
    PlaceholderText = "1.5",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        holdTimeInput = tonumber(text) or 1.5
    end
})

TabSet:CreateInput({
    Name = t("delayInput"),
    PlaceholderText = "0.5",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        delayTimeInput = tonumber(text) or 0.5
    end
})

local autoEAktif = false
TabSet:CreateToggle({
    Name = t("autoE"),
    CurrentValue = false,
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

TabSet:CreateInput({
    Name = t("autoTPDelay"),
    PlaceholderText = "3",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        autoTPDelayInput = tonumber(text) or 3
    end
})

local autoTPAktif = false
TabSet:CreateToggle({
    Name = t("autoTP"),
    CurrentValue = false,
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

TabSet:CreateButton({
    Name = t("preset"),
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
        Rayfield:Notify({Title = t("notifPreset"), Content = t("notifPresetDesc"), Duration = 2})
    end
})

TabSet:CreateDropdown({
    Name = t("langLabel"),
    Options = {"English", "Português", "Indo"},
    CurrentOption = {"English"},
    Callback = function(Option)
        local opt = Option[1]
        if opt == "English" then
            currentLang = "EN"
        elseif opt == "Português" then
            currentLang = "PT"
        elseif opt == "Indo" then
            currentLang = "ID"
        end
        Rayfield:Notify({Title = "Language", Content = "Language changed. Please restart/re-execute script to update all UI texts.", Duration = 3})
    end
})

Rayfield:LoadConfiguration()
