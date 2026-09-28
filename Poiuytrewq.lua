-- ==========================================
-- CAR FLIPPER - RAYFIELD UI
-- ==========================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🚗 CAR FLIPPER V2",
    LoadingTitle = "Car Flipper Menu",
    LoadingSubtitle = "by Litedirt",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false,
        Invite = "zDKNWFhJa",
        RememberJoins = true 
    },
    KeySystem = false
})

-- ==========================================
-- VARIABLES & LOGIC
-- ==========================================
local autoScan = false
local autoBuy = false
local autoAuctionSkip = false
local scanRadius = 5000 
local latestScanData = {} 
local rarities = {"⚪ Common", "🟢 Uncommon", "🔵 Rare", "🟣 Epic", "🟡 Legendary", "🔴 Mythic"}
local tpRarityTarget = "⚪ Common"
local abRarityTarget = "⚪ Common"

-- ==========================================
-- TABS
-- ==========================================
local TabScan = Window:CreateTab("📡 Scan & TP", 4483362458)
local TabBuy = Window:CreateTab("🛒 Auto Buy", 4483362458)
local TabMisc = Window:CreateTab("⚙️ Misc", 4483362458)

-- ==========================================
-- TAB: SCAN & TP
-- ==========================================
local InfoLabel = TabScan:CreateLabel("⚪ 0 | 🟢 0 | 🔵 0 | 🟣 0 | 🟡 0 | 🔴 0")

local ScanToggle = TabScan:CreateToggle({
    Name = "Auto Scan",
    CurrentValue = false,
    Flag = "AutoScan",
    Callback = function(Value)
        autoScan = Value
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
                    
                    InfoLabel:Set(string.format("⚪ %d | 🟢 %d | 🔵 %d | 🟣 %d | 🟡 %d | 🔴 %d", 
                        counts["⚪ Common"], counts["🟢 Uncommon"], counts["🔵 Rare"], counts["🟣 Epic"], counts["🟡 Legendary"], counts["🔴 Mythic"]))
                    
                    task.wait(2)
                end
            end)
        else
            InfoLabel:Set("⚪ 0 | 🟢 0 | 🔵 0 | 🟣 0 | 🟡 0 | 🔴 0")
        end
    end,
})

local RangeDropdown = TabScan:CreateDropdown({
    Name = "Scan Range",
    Options = {"1000", "3000", "5000", "10000", "Infinite"},
    CurrentOption = {"5000"},
    MultipleOptions = false,
    Flag = "ScanRange",
    Callback = function(Option)
        if Option[1] == "Infinite" then
            scanRadius = 999999
        else
            scanRadius = tonumber(Option[1])
        end
    end,
})

TabScan:CreateSection("Teleportation")

local TpDropdown = TabScan:CreateDropdown({
    Name = "Teleport Target Rarity",
    Options = rarities,
    CurrentOption = {"⚪ Common"},
    MultipleOptions = false,
    Flag = "TpTarget",
    Callback = function(Option)
        tpRarityTarget = Option[1]
    end,
})

local TpButton = TabScan:CreateButton({
    Name = "🚀 Teleport Sekarang",
    Callback = function()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local found = false
        for _, carData in pairs(latestScanData) do
            if carData.rarity == tpRarityTarget and carData.part then
                char.HumanoidRootPart.CFrame = carData.part.CFrame + Vector3.new(0, 5, 0)
                found = true
                Rayfield:Notify({
                    Title = "Teleport Sukses",
                    Content = "Berhasil teleport ke " .. tpRarityTarget,
                    Duration = 3,
                    Image = 4483362458,
                })
                break
            end
        end

        if not found then
            Rayfield:Notify({
                Title = "Gagal",
                Content = "Mobil dengan rarity " .. tpRarityTarget .. " tidak ditemukan di range scan.",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- ==========================================
-- TAB: AUTO BUY
-- ==========================================
local BuyDropdown = TabBuy:CreateDropdown({
    Name = "Auto Buy Target Rarity",
    Options = rarities,
    CurrentOption = {"⚪ Common"},
    MultipleOptions = false,
    Flag = "BuyTarget",
    Callback = function(Option)
        abRarityTarget = Option[1]
    end,
})

local BuyToggle = TabBuy:CreateToggle({
    Name = "Auto Buy",
    CurrentValue = false,
    Flag = "AutoBuy",
    Callback = function(Value)
        autoBuy = Value
        if autoBuy then
            task.spawn(function()
                while autoBuy do
                    -- Logika klik/beli (sesuaikan dengan mekanisme game)
                    task.wait(1)
                end
            end)
        end
    end,
})

TabBuy:CreateSection("Auction")

local AuctionToggle = TabBuy:CreateToggle({
    Name = "Auto Auction Skip",
    CurrentValue = false,
    Flag = "AuctionSkip",
    Callback = function(Value)
        autoAuctionSkip = Value
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
    end,
})

-- ==========================================
-- TAB: MISC
-- ==========================================
local DestroyButton = TabMisc:CreateButton({
    Name = "❌ Hapus Script (Destroy UI)",
    Callback = function()
        autoScan = false
        autoBuy = false
        autoAuctionSkip = false
        Rayfield:Destroy()
    end,
})
