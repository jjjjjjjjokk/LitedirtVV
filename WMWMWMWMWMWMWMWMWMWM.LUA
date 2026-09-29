local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/fluent.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

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

local Window = Fluent:CreateWindow({
    Title = t("title"),
    SubTitle = "by Community (Fluent UI)",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    TP = Window:AddTab({ Title = t("tabTP"), Icon = "globe" }),
    Settings = Window:AddTab({ Title = t("tabSet"), Icon = "settings" })
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

Tabs.TP:AddInput("InputNama", {
    Title = t("nameInput"),
    Default = "",
    Placeholder = t("namePlaceholder"),
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        inputNama = Value
    end
})

Tabs.TP:AddInput("InputCoord", {
    Title = t("coordInput"),
    Default = "",
    Placeholder = t("coordPlaceholder"),
    Numeric = false,
    Finished = false,
    Callback = function(Value)
        inputCoord = Value
    end
})

Tabs.TP:AddButton({
    Title = t("getPos"),
    Description = "",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local pos = LocalPlayer.Character.HumanoidRootPart.Position
            inputCoord = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
            Fluent:Notify({Title = t("notifSuccess"), Content = t("notifPos"), Duration = 2})
        end
    end
})

Tabs.TP:AddButton({
    Title = t("save"),
    Description = "",
    Callback = function()
        if inputNama ~= "" and inputCoord ~= "" then
            local split = string.split(inputCoord, ",")
            if #split >= 3 then
                table.insert(daftarLokasi, {Nama = inputNama, X = tonumber(split[1]), Y = tonumber(split[2]), Z = tonumber(split[3])})
                simpanData()
                Fluent:Notify({Title = t("notifSaved"), Content = t("notifLocSaved"), Duration = 2})
            end
        end
    end
})

Tabs.TP:AddParagraph({
    Title = t("savedSec"),
    Content = "List of saved custom locations below:"
})

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
    Tabs.TP:AddButton({
        Title = "TP to: " .. data.Nama,
        Description = string.format("X: %.1f | Y: %.1f | Z: %.1f", data.X, data.Y, data.Z),
        Callback = function()
            teleportKe(data.X, data.Y, data.Z)
        end
    })
end

local holdTimeInput = 1.5
local delayTimeInput = 0.5
local autoTPDelayInput = 3

Tabs.Settings:AddInput("HoldInput", {
    Title = t("holdInput"),
    Default = "1.5",
    Placeholder = "1.5",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        holdTimeInput = tonumber(Value) or 1.5
    end
})

Tabs.Settings:AddInput("DelayInput", {
    Title = t("delayInput"),
    Default = "0.5",
    Placeholder = "0.5",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        delayTimeInput = tonumber(Value) or 0.5
    end
})

local AutoEToggle = Tabs.Settings:AddToggle("AutoEToggle", {Title = t("autoE"), Default = false })
AutoEToggle:OnChanged(function()
    local autoEAktif = AutoEToggle.Value
    if autoEAktif then
        task.spawn(function()
            while AutoEToggle.Value do
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

Tabs.Settings:AddInput("AutoTPDelayInput", {
    Title = t("autoTPDelay"),
    Default = "3",
    Placeholder = "3",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        autoTPDelayInput = tonumber(Value) or 3
    end
})

local AutoTPToggle = Tabs.Settings:AddToggle("AutoTPToggle", {Title = t("autoTP"), Default = false })
AutoTPToggle:OnChanged(function()
    local autoTPAktif = AutoTPToggle.Value
    if autoTPAktif then
        task.spawn(function()
            local indexTP = 1
            while AutoTPToggle.Value do
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

Tabs.Settings:AddButton({
    Title = t("preset"),
    Description = "",
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
        Fluent:Notify({Title = t("notifPreset"), Content = t("notifPresetDesc"), Duration = 2})
    end
})

Tabs.Settings:AddDropdown("LangDropdown", {
    Title = t("langLabel"),
    Values = {"English", "Português", "Indo"},
    Default = 1,
    Callback = function(Value)
        if Value == "English" then
            currentLang = "EN"
        elseif Value == "Português" then
            currentLang = "PT"
        elseif Value == "Indo" then
            currentLang = "ID"
        end
        Fluent:Notify({Title = "Language", Content = "Language changed. Please re-execute script to update UI elements.", Duration = 3})
    end
})

Window:SelectTab(1)
Fluent:Notify({
    Title = "LITEDIRT",
    Content = "Loaded successfully with Fluent UI & Smooth Tween!",
    Duration = 5
})
