-- Memuat library Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Tema UI Neon (Mirip Web TopUp Modern)
local customTheme = {
    TextColor = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(15, 15, 20),
    Topbar = Color3.fromRGB(20, 20, 25),
    Shadow = Color3.fromRGB(0, 255, 255), -- Warna Glow Cyan
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
    Name = "TopUp Hub | UI Scanner",
    LoadingTitle = "Memuat Sistem...",
    LoadingSubtitle = "Menyiapkan Auto Click & Scanner",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
    Theme = customTheme
})

-- ==========================================
-- TAB 1: SCANNER MENU LAYAR (UI DETECTOR)
-- ==========================================
local ScannerTab = Window:CreateTab("Scan Layar", 10034237190)
local activeScanner = false

local UIResult = ScannerTab:CreateParagraph({
    Title = "Menunggu Interaksi...",
    Content = "Aktifkan toggle di bawah, lalu tap/klik sesuatu di dalam game (misal: 'Train'). Jika ada menu baru yang muncul di layar, namanya akan terdeteksi di sini."
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

-- Logika Deteksi Layar (Mendeteksi Frame/ScreenGui yang tiba-tiba muncul)
local function MonitorUI(guiElement)
    -- Hanya mengecek frame, textlabel, image, atau screengui
    if guiElement:IsA("GuiObject") or guiElement:IsA("ScreenGui") then
        guiElement:GetPropertyChangedSignal("Visible"):Connect(function()
            if activeScanner and guiElement.Visible then
                local path = guiElement.Name
                local parent = guiElement.Parent
                -- Membuat path agar gampang dicari
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
end

-- Menerapkan fungsi monitor ke semua UI yang sudah ada di layar
for _, gui in pairs(LocalPlayer:WaitForChild("PlayerGui"):GetDescendants()) do
    MonitorUI(gui)
end

-- Menerapkan fungsi monitor ke UI yang baru saja dibuat/ditambahkan oleh game
LocalPlayer.PlayerGui.DescendantAdded:Connect(function(desc)
    MonitorUI(desc)
    if activeScanner and (desc:IsA("ScreenGui") or desc:IsA("Frame")) then
        task.wait(0.1) -- Jeda sebentar memastikan properti termuat
        if desc.Visible then
            UIResult:Set({
                Title = "⚡ Layar Baru Ditambahkan!",
                Content = "Nama UI: " .. desc.Name
            })
        end
    end
end)


-- ==========================================
-- TAB 2: AUTO CLICK CURSOR
-- ==========================================
local ClickTab = Window:CreateTab("Auto Click", 6536645908)
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
    Name = "Aktifkan Auto Click (Di Posisi Kursor)",
    CurrentValue = false,
    Flag = "ClickToggle",
    Callback = function(Value)
        autoClicking = Value
        if autoClicking then
            task.spawn(function()
                while autoClicking do
                    -- Mengeklik otomatis di tempat kursor Anda berada
                    if mouse1click then
                        mouse1click() -- Fungsi bawaan executor
                    else
                        -- Fallback jika executor tidak support mouse1click
                        VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 1)
                    end
                    task.wait(1 / cps)
                end
            end)
        end
    end,
})


-- ==========================================
-- TAB 3: SETTINGS & DESTROY GUI
-- ==========================================
-- Tab baru khusus agar tombol Destroy gampang ditemukan
local SettingsTab = Window:CreateTab("⚙️ Settings", 10734949856)

SettingsTab:CreateButton({
    Name = "❌ DESTROY GUI (Tutup Script)",
    Callback = function()
        -- Mematikan sistem background sebelum tutup
        autoClicking = false 
        activeScanner = false
        
        -- Menghapus seluruh GUI dari layar
        Rayfield:Destroy()
    end,
})
