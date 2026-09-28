-- Memuat library Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Custom Theme (Modern, Menyala/Glowing ala Web Top-up)
local customTheme = {
    TextColor = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(15, 15, 20),
    Topbar = Color3.fromRGB(20, 20, 25),
    Shadow = Color3.fromRGB(0, 255, 255), -- Glow Cyan
    DialogBackground = Color3.fromRGB(20, 20, 25),
    TabBackground = Color3.fromRGB(15, 15, 20),
    TabStroke = Color3.fromRGB(0, 255, 255),
    TabBackgroundSelected = Color3.fromRGB(30, 30, 40),
    TabTextColor = Color3.fromRGB(255, 255, 255),
    SelectedTabTextColor = Color3.fromRGB(0, 255, 255),
    ElementBackground = Color3.fromRGB(25, 25, 30),
    ElementBackgroundHover = Color3.fromRGB(35, 35, 40),
    SecondaryElementBackground = Color3.fromRGB(35, 35, 40),
    ElementStroke = Color3.fromRGB(0, 255, 255),
    SecondaryElementStroke = Color3.fromRGB(0, 255, 255),
    SliderBackground = Color3.fromRGB(0, 255, 255),
    SliderProgress = Color3.fromRGB(0, 200, 255),
    SliderStroke = Color3.fromRGB(0, 255, 255),
    ToggleBackground = Color3.fromRGB(25, 25, 30),
    ToggleEnabled = Color3.fromRGB(0, 255, 255),
    DropdownSelected = Color3.fromRGB(0, 255, 255),
    DropdownUnselected = Color3.fromRGB(25, 25, 30),
    InputBackground = Color3.fromRGB(25, 25, 30),
    InputStroke = Color3.fromRGB(0, 255, 255),
    PlaceholderColor = Color3.fromRGB(178, 178, 178)
}

-- Membuat Window Utama
local Window = Rayfield:CreateWindow({
    Name = "TopUp Hub | Model & Auto",
    LoadingTitle = "Memuat Sistem...",
    LoadingSubtitle = "Menyiapkan UI Modern",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
    Theme = customTheme -- Mengaplikasikan tema menyala
})

-- ==========================================
-- TAB 1: SCANNER MODEL (Dari sebelumnya)
-- ==========================================
local ScanTab = Window:CreateTab("Scanner", 4483362458)
local scanRadius = 50

ScanTab:CreateSlider({
    Name = "Radius Scan (Studs)",
    Range = {10, 500},
    Increment = 10,
    Suffix = "Studs",
    CurrentValue = 50,
    Flag = "RadiusSlider",
    Callback = function(Value) scanRadius = Value end,
})

local ResultsParagraph = ScanTab:CreateParagraph({
    Title = "Hasil Scan", 
    Content = "Belum ada pemindaian."
})

ScanTab:CreateButton({
    Name = "Scan Model di Sekitar",
    Callback = function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local count = 0
        local displayText = ""
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= char then
                local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if primaryPart and (primaryPart.Position - hrp.Position).Magnitude <= scanRadius then
                    count = count + 1
                    if count <= 15 then
                        displayText = displayText .. "- " .. obj.Name .. "\n"
                    end
                end
            end
        end
        
        if count > 15 then displayText = displayText .. "... dan lainnya." end
        if count == 0 then displayText = "Tidak ada model ditemukan." end
        
        ResultsParagraph:Set({Title = "Ditemukan " .. count .. " Model", Content = displayText})
    end,
})

-- ==========================================
-- TAB 2: AUTO CLICKER
-- ==========================================
local AutoTab = Window:CreateTab("Auto Click", 6536645908)
local autoClickEnabled = false
local clickSpeed = 10

AutoTab:CreateSlider({
    Name = "Kecepatan Klik (CPS)",
    Range = {1, 50},
    Increment = 1,
    Suffix = "Klik/Detik",
    CurrentValue = 10,
    Flag = "CPS_Slider",
    Callback = function(Value)
        clickSpeed = Value
    end,
})

AutoTab:CreateToggle({
    Name = "Aktifkan Auto Click",
    CurrentValue = false,
    Flag = "AutoClickToggle",
    Callback = function(Value)
        autoClickEnabled = Value
        if autoClickEnabled then
            task.spawn(function()
                while autoClickEnabled do
                    -- Menggunakan executor native klik (mouse1click) jika ada, jika tidak pakai VirtualInputManager
                    if mouse1click then
                        mouse1click()
                    else
                        local x, y = LocalPlayer:GetMouse().X, LocalPlayer:GetMouse().Y
                        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
                    end
                    task.wait(1 / clickSpeed)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 3: DETECTOR LAYAR "TRAIN"
-- ==========================================
local DetectTab = Window:CreateTab("Monitor Train", 10034237190)
local isMonitoring = false

local MonitorUIInfo = DetectTab:CreateParagraph({
    Title = "Status Monitor", 
    Content = "Monitor tidak aktif."
})

DetectTab:CreateToggle({
    Name = "Monitor 'Train' & Layar",
    CurrentValue = false,
    Flag = "MonitorToggle",
    Callback = function(Value)
        isMonitoring = Value
        if isMonitoring then
            MonitorUIInfo:Set({Title = "Status Monitor", Content = "Sedang mencari interaksi 'Train'..."})
        else
            MonitorUIInfo:Set({Title = "Status Monitor", Content = "Monitor dihentikan."})
        end
    end,
})

-- Logika pendeteksi layar yang muncul
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
PlayerGui.DescendantAdded:Connect(function(descendant)
    if not isMonitoring then return end
    
    -- Menunggu sebentar agar UI termuat, lalu cek jika GUI visible (muncul)
    task.spawn(function()
        task.wait(0.1)
        if descendant:IsA("Frame") or descendant:IsA("ScreenGui") then
            -- Mengecek apakah GUI ini muncul karena kita memencet sesuatu (seperti 'Train')
            descendant:GetPropertyChangedSignal("Visible"):Connect(function()
                if descendant.Visible and isMonitoring then
                    MonitorUIInfo:Set({
                        Title = "⚠ Layar Baru Terdeteksi!", 
                        Content = "Nama GUI: " .. descendant.Name .. "\nPath: PlayerGui->" .. descendant.Parent.Name
                    })
                    Rayfield:Notify({
                        Title = "Layar Terdeteksi", 
                        Content = "GUI bernama " .. descendant.Name .. " baru saja muncul!", 
                        Duration = 4
                    })
                end
            end)
        end
    end)
end)

-- Deteksi jika ProximityPrompt "Train" dipicu
local ProximityPromptService = game:GetService("ProximityPromptService")
ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
    if isMonitoring and player == LocalPlayer then
        if string.find(string.lower(prompt.ActionText), "train") or string.find(string.lower(prompt.ObjectText), "train") then
            MonitorUIInfo:Set({
                Title = "✅ Interaksi Train Ditekan!", 
                Content = "Menunggu layar/GUI merespon..."
            })
        end
    end
end)

-- ==========================================
-- TAB 4: SETTINGS (DESTROY GUI)
-- ==========================================
local SettingsTab = Window:CreateTab("Settings", 10734949856)

SettingsTab:CreateButton({
    Name = "Tutup & Hapus GUI (Destroy)",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- Selesai Load
Rayfield:Notify({
    Title = "Script Berhasil Dimuat!",
    Content = "TopUp Hub siap digunakan.",
    Duration = 3
})
