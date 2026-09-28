-- ==========================================
-- CAR FLIPPER - NO KEY SYSTEM & NEW UI
-- ==========================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Bersihkan UI lama jika ada
for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "CarFlipperModernGUI" or gui.Name == "CarFlipperKeyGUI" or gui.Name == "CarFlipperCustomGUI" then
        gui:Destroy()
    end
end

-- ==========================================
-- UI SETUP (MODERN FLAT DESIGN)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CarFlipperModernGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 500)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true -- Membuat UI bisa digeser

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 12)
UICornerMain.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(33, 36, 45)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local UICornerHeader = Instance.new("UICorner")
UICornerHeader.CornerRadius = UDim.new(0, 12)
UICornerHeader.Parent = Header

local HeaderPatch = Instance.new("Frame") -- Menutupi sudut bawah header
HeaderPatch.Size = UDim2.new(1, 0, 0, 10)
HeaderPatch.Position = UDim2.new(0, 0, 1, -10)
HeaderPatch.BackgroundColor3 = Color3.fromRGB(33, 36, 45)
HeaderPatch.BorderSizePixel = 0
HeaderPatch.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Text = "🚗 CAR FLIPPER V2"
Title.Parent = Header

-- Toggle Button (Buka/Tutup Menu)
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleMenuBtn.Position = UDim2.new(0, 20, 0, 20)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(33, 36, 45)
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.Font = Enum.Font.GothamBold
ToggleMenuBtn.TextSize = 20
ToggleMenuBtn.Text = "👁️"
ToggleMenuBtn.Parent = ScreenGui

local UICornerToggle = Instance.new("UICorner")
UICornerToggle.CornerRadius = UDim.new(0, 10)
UICornerToggle.Parent = ToggleMenuBtn

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Content Area (Scrolling)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -55)
ScrollFrame.Position = UDim2.new(0, 0, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y 
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = ScrollFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingBottom = UDim.new(0, 15)
UIPadding.Parent = ScrollFrame

-- ==========================================
-- VARIABLES & LOGIC
-- ==========================================
local autoScan, autoBuy, autoAuctionSkip = false, false, false
local scanRadius = 5000 
local latestScanData = {} 
local rarities = {"⚪ Common", "🟢 Uncommon", "🔵 Rare", "🟣 Epic", "🟡 Legendary", "🔴 Mythic"}
local tpRarityIdx, abRarityIdx = 1, 1

-- Helper Function untuk membuat tombol
local function CreateButton(text, color, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Text = text
    btn.LayoutOrder = order
    btn.Parent = ScrollFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

-- ==========================================
-- UI COMPONENTS & FEATURES
-- ==========================================

-- 1. Counter Info
local CountLabel = Instance.new("TextLabel")
CountLabel.Size = UDim2.new(0.9, 0, 0, 30)
CountLabel.BackgroundColor3 = Color3.fromRGB(40, 44, 52)
CountLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
CountLabel.Font = Enum.Font.GothamBold
CountLabel.TextSize = 12
CountLabel.Text = "⚪ 0 | 🟢 0 | 🔵 0 | 🟣 0 | 🟡 0 | 🔴 0"
CountLabel.LayoutOrder = 1
CountLabel.Parent = ScrollFrame
Instance.new("UICorner", CountLabel).CornerRadius = UDim.new(0, 8)

-- 2. Auto Scan Toggle
local ScanBtn = CreateButton("Auto Scan: OFF", Color3.fromRGB(50, 54, 63), 2)
ScanBtn.MouseButton1Click:Connect(function()
    autoScan = not autoScan
    ScanBtn.Text = autoScan and "Auto Scan: ON" or "Auto Scan: OFF"
    ScanBtn.BackgroundColor3 = autoScan and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 54, 63)
    
    if autoScan then
        task.spawn(function()
            while autoScan do
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then task.wait(1.5) continue end
                local root = char.HumanoidRootPart
                
                local counts = {["⚪ Common"]=0, ["🟢 Uncommon"]=0, ["🔵 Rare"]=0, ["🟣 Epic"]=0, ["🟡 Legendary"]=0, ["🔴 Mythic"]=0}
                latestScanData = {}

                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("VehicleSeat") or (obj:IsA("Seat") and obj.Name:lower():match("drive")) then
                        local carModel = obj:FindFirstAncestorWhichIsA("Model")
                        if carModel and (root.Position - obj.Position).Magnitude <= scanRadius then
                            
                            local rawRarity = "⚪ Common"
                            -- Simulasi mendeteksi Rarity dari TextLabel/Nama
                            for _, desc in pairs(carModel:GetDescendants()) do
                                if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                                    local txtLower = desc.Text:lower()
                                    if txtLower:match("mythic") then rawRarity = "🔴 Mythic"
                                    elseif txtLower:match("legendary") then rawRarity = "🟡 Legendary"
                                    elseif txtLower:match("epic") then rawRarity = "🟣 Epic"
                                    elseif txtLower:match("rare") then rawRarity = "🔵 Rare"
                                    elseif txtLower:match("uncommon") then rawRarity = "🟢 Uncommon"
                                    end
                                end
                            end

                            counts[rawRarity] = (counts[rawRarity] or 0) + 1
                            table.insert(latestScanData, {model = carModel, rarity = rawRarity, part = obj})
                        end
                    end
                end
                
                CountLabel.Text = string.format("⚪ %d | 🟢 %d | 🔵 %d | 🟣 %d | 🟡 %d | 🔴 %d", 
                    counts["⚪ Common"], counts["🟢 Uncommon"], counts["🔵 Rare"], counts["🟣 Epic"], counts["🟡 Legendary"], counts["🔴 Mythic"])
                
                task.wait(2)
            end
        end)
    end
end)

-- 3. Scan Range
local ScanRangeBtn = CreateButton("Scan Range: 5000", Color3.fromRGB(142, 68, 173), 3)
ScanRangeBtn.MouseButton1Click:Connect(function()
    if scanRadius == 1000 then scanRadius = 3000
    elseif scanRadius == 3000 then scanRadius = 5000
    elseif scanRadius == 5000 then scanRadius = 10000
    elseif scanRadius == 10000 then scanRadius = 99999 
    else scanRadius = 1000 end
    ScanRangeBtn.Text = "Scan Range: " .. (scanRadius == 99999 and "Infinite" or scanRadius)
end)

-- 4. Teleport Target & Button
local TpRarityBtn = CreateButton("TP Target: " .. rarities[tpRarityIdx], Color3.fromRGB(41, 128, 185), 4)
TpRarityBtn.MouseButton1Click:Connect(function()
    tpRarityIdx = (tpRarityIdx % #rarities) + 1
    TpRarityBtn.Text = "TP Target: " .. rarities[tpRarityIdx]
end)

local TpBtn = CreateButton("🚀 Teleport Sekarang", Color3.fromRGB(52, 152, 219), 5)
TpBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local targetRarity = rarities[tpRarityIdx]
    for _, carData in pairs(latestScanData) do
        if carData.rarity == targetRarity and carData.part then
            char.HumanoidRootPart.CFrame = carData.part.CFrame + Vector3.new(0, 5, 0)
            break
        end
    end
end)

-- 5. Auto Buy Target & Toggle
local AbRarityBtn = CreateButton("Auto Buy Target: " .. rarities[abRarityIdx], Color3.fromRGB(211, 84, 0), 6)
AbRarityBtn.MouseButton1Click:Connect(function()
    abRarityIdx = (abRarityIdx % #rarities) + 1
    AbRarityBtn.Text = "Auto Buy Target: " .. rarities[abRarityIdx]
end)

local BuyBtn = CreateButton("Auto Buy: OFF", Color3.fromRGB(50, 54, 63), 7)
BuyBtn.MouseButton1Click:Connect(function()
    autoBuy = not autoBuy
    BuyBtn.Text = autoBuy and "Auto Buy: ON" or "Auto Buy: OFF"
    BuyBtn.BackgroundColor3 = autoBuy and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 54, 63)
    
    -- Logic Auto Buy (Simulasi Click)
    if autoBuy then
        task.spawn(function()
            while autoBuy do
                -- Tambahkan logika API pembelian game spesifik di sini (ProximityPrompt/FireServer)
                task.wait(1)
            end
        end)
    end
end)

-- 6. Auction Skip Toggle
local AuctionBtn = CreateButton("Auction Skip: OFF", Color3.fromRGB(50, 54, 63), 8)
AuctionBtn.MouseButton1Click:Connect(function()
    autoAuctionSkip = not autoAuctionSkip
    AuctionBtn.Text = autoAuctionSkip and "Auction Skip: ON" or "Auction Skip: OFF"
    AuctionBtn.BackgroundColor3 = autoAuctionSkip and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(50, 54, 63)
    
    if autoAuctionSkip then
        task.spawn(function()
            while autoAuctionSkip do
                local pGui = player:WaitForChild("PlayerGui")
                for _, gui in pairs(pGui:GetDescendants()) do
                    if gui:IsA("TextButton") and (gui.Text:lower():match("skip") or gui.Text:lower():match("leave")) then
                        pcall(function()
                            if getconnections then
                                for _, conn in pairs(getconnections(gui.MouseButton1Click)) do conn:Fire() end
                            end
                        end)
                    end
                end
                task.wait(2)
            end
        end)
    end
end)

-- 7. Destroy Script
local DestroyBtn = CreateButton("❌ Tutup & Hapus Script", Color3.fromRGB(192, 57, 43), 9)
DestroyBtn.MouseButton1Click:Connect(function()
    autoScan, autoBuy, autoAuctionSkip = false, false, false
    ScreenGui:Destroy()
end)
