-- Memuat library Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Membuat Window Utama
local Window = Rayfield:CreateWindow({
    Name = "Model Scanner (Rayfield)",
    LoadingTitle = "Memuat Scanner...",
    LoadingSubtitle = "Script Deteksi Model",
    ConfigurationSaving = {
       Enabled = false,
    },
    KeySystem = false, -- Ubah ke true jika ingin menggunakan sistem key
})

-- Membuat Tab Baru
local ScanTab = Window:CreateTab("Scanner", 4483362458) -- Angka adalah ID Ikon

-- Variabel Player
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Konfigurasi Default
local scanRadius = 50

-- Membuat Slider untuk Radius
ScanTab:CreateSlider({
    Name = "Radius Scan (Studs)",
    Range = {10, 500},
    Increment = 10,
    Suffix = "Studs",
    CurrentValue = 50,
    Flag = "RadiusSlider",
    Callback = function(Value)
        scanRadius = Value
    end,
})

-- Paragraf untuk menampilkan hasil
local ResultsParagraph = ScanTab:CreateParagraph({
    Title = "Hasil Scan", 
    Content = "Belum ada pemindaian. Silakan tekan tombol scan."
})

-- Tombol untuk mulai mendeteksi
ScanTab:CreateButton({
    Name = "Scan Model di Sekitar",
    Callback = function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if not hrp then
            Rayfield:Notify({
                Title = "Error", 
                Content = "Karakter tidak ditemukan!", 
                Duration = 3,
                Image = 4483362458
            })
            return
        end

        local foundModels = {}
        local count = 0

        -- Looping semua objek di Workspace
        for _, obj in pairs(workspace:GetDescendants()) do
            -- Mengecek apakah objek adalah Model dan bukan karakter pemain sendiri
            if obj:IsA("Model") and obj ~= char then
                -- Mencari part patokan untuk mengukur jarak
                local primaryPart = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                
                if primaryPart then
                    local distance = (primaryPart.Position - hrp.Position).Magnitude
                    
                    if distance <= scanRadius then
                        table.insert(foundModels, string.format("%s (%.1f studs)", obj.Name, distance))
                        count = count + 1
                    end
                end
            end
        end

        -- Memformat output agar UI tidak lag jika terlalu banyak model
        if count > 0 then
            local maxDisplay = 15 -- Batas maksimal model yang ditampilkan di UI
            local displayText = ""
            
            for i, text in ipairs(foundModels) do
                if i <= maxDisplay then
                    displayText = displayText .. "- " .. text .. "\n"
                elseif i == maxDisplay + 1 then
                    displayText = displayText .. "... dan " .. (count - maxDisplay) .. " model lainnya."
                    break
                end
            end
            
            ResultsParagraph:Set({
                Title = "Ditemukan " .. count .. " Model", 
                Content = displayText
            })
            
            Rayfield:Notify({
                Title = "Sukses", 
                Content = "Berhasil menemukan " .. count .. " model!", 
                Duration = 3
            })
        else
            ResultsParagraph:Set({
                Title = "Hasil Scan", 
                Content = "Tidak ada model yang ditemukan dalam radius " .. scanRadius .. " studs."
            })
        end
    end,
})
