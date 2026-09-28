-- Memuat library Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Tema UI Neon
local customTheme = {
    TextColor = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(15, 15, 20),
    Topbar = Color3.fromRGB(20, 20, 25),
    Shadow = Color3.fromRGB(0, 255, 255),
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

-- Membuat Window
local Window = Rayfield:CreateWindow({
    Name = "TopUp Hub | V2",
    LoadingTitle = "Memuat Sistem...",
    LoadingSubtitle = "Menyiapkan Auto Click & Scanner",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
    Theme = customTheme
})

-- ==========================================
-- MEMBUAT SEMUA TAB TERLEBIH DAHULU
-- ==========================================
local ScannerTab = Window:CreateTab("Scan Layar", 10034237190)
local ClickTab = Window:CreateTab("Auto Click", 6536645908)
local SettingsTab = Window:CreateTab("⚙️ Settings", 10734949856)

-- ==========================================
-- ISI TAB 1: SCANNER MENU LAYAR
-- ==========================================
local activeScanner = false

local UIResult = ScannerTab:CreateParagraph({
    Title = "Menunggu Interaksi...",
    Content = "Aktifkan toggle, lalu tap/klik sesuatu di layar (misal: 'Train'). Menu yang muncul akan terdeteksi di sini."
})

ScannerTab:CreateToggle({
    Name = "Aktifkan Deteksi Menu Layar",
    CurrentValue = false,
    Flag = "UIToggle",
    Callback = function(Value)
        activeScanner = Value
        if activeScanner then
            UIResult:Set({Title = "Status: Memantau 👀", Content = "Silakan klik/tap tombol di game. Menunggu menu muncul..."})
        else
            UIResult:Set({Title = "Status: Berhenti 🛑", Content = "Deteksi dimatikan."})
        end
    end,
})

-- ==========================================
-- ISI TAB 2: AUTO CLICK CURSOR
-- ==========================================
local autoClicking = false
local cps = 10

ClickTab:CreateSlider({
    Name = "Kecepatan (Klik per Detik)",
    Range = {1, 100},
    Increment = 1,
    Suffix = "CPS",
    CurrentValue = 10,
    Flag = "CPS",
    Callback = function(Value)
        cps = Value
    end,
})

ClickTab:CreateToggle({
    Name = "Auto Click (Posisi Kursor)",
    CurrentValue = false,
    Flag = "ClickToggle",
    Callback = function(Value)
        autoClicking = Value
        if autoClicking then
            task.spawn(function()
                while autoClicking do
                    pcall(function()
                        if mouse1click then
                            mouse1click()
                        else
                            VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 1)
                            VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 1)
                        end
                    end)
                    task.wait(1 / cps)
                end
            end)
        end
    end,
})

-- ==========================================
-- ISI TAB 3: SETTINGS & DESTROY GUI
-- ==========================================
SettingsTab:CreateButton({
    Name = "❌ DESTROY GUI (Tutup Script)",
    Callback = function()
        autoClicking = false 
        activeScanner = false
        Rayfield:Destroy()
    end,
})

-- ==========================================
-- LOGIKA SCANNER (DIPROSES DI BELAKANG)
-- ==========================================
local function MonitorUI(guiElement)
    pcall(function()
        if guiElement:IsA("GuiObject") or guiElement:IsA("ScreenGui") then
            guiElement:GetPropertyChangedSignal("Visible"):Connect(function()
                if activeScanner and guiElement.Visible then
                    local path = guiElement.Name
                    local parent = guiElement.Parent
                    
                    for i = 1, 3 do 
                        if parent and parent ~= LocalPlayer:FindFirstChild("PlayerGui") and parent.Name ~= "PlayerGui" then
                            path = parent.Name .. " -> " .. path
                            parent = parent.Parent
                        else
                            break
                        end
                    end
                    
                    UIResult:Set({
                        Title = "🔥 Menu Terdeteksi!",
                        Content = "Nama UI: " .. guiElement.Name .. "\nPath: " .. path
                    })
                end
            end)
        end
    end)
end

-- Menjalankan deteksi UI lama tanpa membuat script freeze
task.spawn(function()
    for _, gui in pairs(LocalPlayer:WaitForChild("PlayerGui"):GetDescendants()) do
        MonitorUI(gui)
    end
end)

-- Menjalankan deteksi untuk UI yang baru muncul saat game berjalan
LocalPlayer.PlayerGui.DescendantAdded:Connect(function(desc)
    MonitorUI(desc)
    pcall(function()
        if activeScanner and (desc:IsA("ScreenGui") or desc:IsA("Frame")) then
            task.wait(0.1)
            if desc.Visible then
                UIResult:Set({
                    Title = "⚡ Layar Baru Ditambahkan!",
                    Content = "Nama UI: " .. desc.Name
                })
            end
        end
    end)
end)

Rayfield:Notify({
    Title = "Script Berhasil Dimuat",
    Content = "Semua menu siap digunakan!",
    Duration = 3
})
