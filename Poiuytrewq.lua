-- ==========================================
-- SETUP KEY SYSTEM (STABLE MEMORY SAVE + MULTI-LANGUAGE)
-- ==========================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local LinkPastebinKey = "https://pastebin.com/raw/KyGfrsc7" 
local LinkDiscord = "https://discord.com/invite/zDKNWFhJa" 

if not getgenv().CarFlipperVerified then
    getgenv().CarFlipperVerified = false
end

-- Sistem Kamus Bahasa
local currentLang = "ID" -- Default Indonesia
local texts = {
    ID = {
        title = "CAR FLIPPER - KEY SYSTEM",
        placeholder = "Masukkan Key di sini...",
        submit = "SUBMIT",
        getkey = "GET KEY",
        discord = "Join Discord",
        wrong = "Key Salah!",
        fail = "Gagal memuat link key!",
        copiedKey = "Link Key disalin!",
        copiedDiscord = "Link Discord disalin!",
        openMenu = "Buka Menu",
        closeMenu = "Tutup Menu",
        scanOff = "Auto Scan: OFF",
        scanOn = "Auto Scan: ON",
        scanRange = "Jangkauan Scan: ",
        tpTarget = "Teleport Target: ",
        tpNow = "Teleport Sekarang",
        buyTarget = "Auto Buy Target: ",
        buyOff = "Auto Buy: OFF",
        buyOn = "Auto Buy: ON",
        auctionOff = "Auction Skip: OFF",
        auctionOn = "Auction Skip: ON",
        destroy = "Hapus Script & Reset Key",
        radarOff = "Radar mati. Klik tombol Auto Scan di atas."
    },
    EN = {
        title = "CAR FLIPPER - KEY SYSTEM",
        placeholder = "Enter Key here...",
        submit = "SUBMIT",
        getkey = "GET KEY",
        discord = "Join Discord",
        wrong = "Wrong Key!",
        fail = "Failed to load key link!",
        copiedKey = "Key Link Copied!",
        copiedDiscord = "Discord Link Copied!",
        openMenu = "Open Menu",
        closeMenu = "Close Menu",
        scanOff = "Auto Scan: OFF",
        scanOn = "Auto Scan: ON",
        scanRange = "Scan Range: ",
        tpTarget = "Teleport Target: ",
        tpNow = "Teleport Now",
        buyTarget = "Auto Buy Target: ",
        buyOff = "Auto Buy: OFF",
        buyOn = "Auto Buy: ON",
        auctionOff = "Auction Skip: OFF",
        auctionOn = "Auction Skip: ON",
        destroy = "Destroy Script & Reset Key",
        radarOff = "Radar is off. Click Auto Scan above."
    },
    TW = {
        title = "CAR FLIPPER - 密鑰系統",
        placeholder = "請在此輸入密鑰...",
        submit = "提交",
        getkey = "獲取密鑰",
        discord = "加入群組",
        wrong = "密鑰錯誤！",
        fail = "載入密鑰連結失敗！",
        copiedKey = "已複製密鑰連結！",
        copiedDiscord = "已複製Discord連結！",
        openMenu = "打開選單",
        closeMenu = "關閉選單",
        scanOff = "自動掃描: 關閉",
        scanOn = "自動掃描: 開啟",
        scanRange = "掃描範圍: ",
        tpTarget = "傳送目標: ",
        tpNow = "立即傳送",
        buyTarget = "自動購買目標: ",
        buyOff = "自動購買: 關閉",
        buyOn = "自動購買: 開啟",
        auctionOff = "拍賣跳過: 關閉",
        auctionOn = "拍賣跳過: 開啟",
        destroy = "刪除腳本並重置密鑰",
        radarOff = "雷達已關閉，請點擊上方按鈕。"
    }
}

for _, gui in pairs(CoreGui:GetChildren()) do
    if gui.Name == "CarFlipperKeyGUI" or gui.Name == "CarFlipperCustomGUI" then
        gui:Destroy()
    end
end

local function LoadMainScript(lang)
    local t = texts[lang or "ID"]
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CarFlipperCustomGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui

    local ToggleMenuBtn = Instance.new("TextButton")
    ToggleMenuBtn.Size = UDim2.new(0, 100, 0, 40)
    ToggleMenuBtn.Position = UDim2.new(0, 20, 0, 20)
    ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleMenuBtn.Font = Enum.Font.GothamBold
    ToggleMenuBtn.TextSize = 14
    ToggleMenuBtn.Text = t.openMenu
    ToggleMenuBtn.Parent = ScreenGui

    local UICornerBtn = Instance.new("UICorner")
    UICornerBtn.CornerRadius = UDim.new(0, 8)
    UICornerBtn.Parent = ToggleMenuBtn

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 560)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -280)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui

    local UICornerMain = Instance.new("UICorner")
    UICornerMain.CornerRadius = UDim.new(0, 10)
    UICornerMain.Parent = MainFrame

    local Topbar = Instance.new("TextLabel")
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Topbar.TextColor3 = Color3.fromRGB(255, 255, 255)
    Topbar.Font = Enum.Font.GothamBold
    Topbar.TextSize = 16
    Topbar.Text = "CAR FLIPPER LITEDIRT"
    Topbar.Parent = MainFrame

    local UICornerTop = Instance.new("UICorner")
    UICornerTop.CornerRadius = UDim.new(0, 10)
    UICornerTop.Parent = Topbar

    local TopbarPatch = Instance.new("Frame")
    TopbarPatch.Size = UDim2.new(1, 0, 0, 10)
    TopbarPatch.Position = UDim2.new(0, 0, 1, -10)
    TopbarPatch.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TopbarPatch.BorderSizePixel = 0
    TopbarPatch.Parent = Topbar

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
    ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.ScrollBarThickness = 5
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y 
    ScrollFrame.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = ScrollFrame

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.Parent = ScrollFrame

    -- Drag Menu
    local dragging, dragInput, dragStart, startPos
    Topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    ToggleMenuBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        ToggleMenuBtn.Text = MainFrame.Visible and t.closeMenu or t.openMenu
    end)

    local function CreateButton(text, yOrder)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Text = text
        btn.LayoutOrder = yOrder
        btn.Parent = ScrollFrame
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn
        return btn
    end

    local autoScan = false
    local autoBuy = false
    local autoAuctionSkip = false
    local scanRadius = 5000 
    local latestScanData = {} 
    local rarities = {"⚪ Common", "🟢 Uncommon", "🔵 Rare", "🟣 Epic", "🟡 Legendary", "🔴 Mythic"}
    local tpRarityIdx = 1
    local abRarityIdx = 1

    local carMemory = {} 
    local buyCooldown = {} 

    local ScanBtn = CreateButton(t.scanOff, 1)

    local ScanRangeBtn = CreateButton(t.scanRange .. scanRadius, 2)
    ScanRangeBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 120)
    ScanRangeBtn.MouseButton1Click:Connect(function()
        if scanRadius == 1000 then scanRadius = 3000
        elseif scanRadius == 3000 then scanRadius = 5000
        elseif scanRadius == 5000 then scanRadius = 10000
        elseif scanRadius == 10000 then scanRadius = 99999 
        else scanRadius = 1000
        end
        ScanRangeBtn.Text = t.scanRange .. (scanRadius == 99999 and "Infinite (Map)" or scanRadius)
    end)

    local CountLabel = Instance.new("TextLabel")
    CountLabel.Size = UDim2.new(0.9, 0, 0, 25)
    CountLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    CountLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    CountLabel.Font = Enum.Font.GothamBold
    CountLabel.TextSize = 11
    CountLabel.Text = "⚪:0 | 🟢:0 | 🔵:0 | 🟣:0 | 🟡:0 | 🔴:0"
    CountLabel.LayoutOrder = 3
    CountLabel.Parent = ScrollFrame
    local CountCorner = Instance.new("UICorner")
    CountCorner.CornerRadius = UDim.new(0, 6)
    CountCorner.Parent = CountLabel

    local RadarContainer = Instance.new("Frame")
    RadarContainer.Size = UDim2.new(0.9, 0, 0, 0)
    RadarContainer.AutomaticSize = Enum.AutomaticSize.Y
    RadarContainer.BackgroundTransparency = 1
    RadarContainer.LayoutOrder = 4
    RadarContainer.Parent = ScrollFrame

    local RadarLayout = Instance.new("UIListLayout")
    RadarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RadarLayout.Padding = UDim.new(0, 5)
    RadarLayout.Parent = RadarContainer

    local ModelListLabel = Instance.new("TextLabel")
    ModelListLabel.Size = UDim2.new(0.9, 0, 0, 0)
    ModelListLabel.AutomaticSize = Enum.AutomaticSize.Y
    ModelListLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ModelListLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    ModelListLabel.Font = Enum.Font.Gotham
    ModelListLabel.TextSize = 11
    ModelListLabel.TextWrapped = true
    ModelListLabel.TextXAlignment = Enum.TextXAlignment.Left
    ModelListLabel.TextYAlignment = Enum.TextYAlignment.Top
    ModelListLabel.Text = "Model: -"
    ModelListLabel.LayoutOrder = 5
    ModelListLabel.Parent = ScrollFrame
    local MLCorner = Instance.new("UICorner")
    MLCorner.CornerRadius = UDim.new(0, 6)
    MLCorner.Parent = ModelListLabel
    local MLPadding = Instance.new("UIPadding")
    MLPadding.PaddingTop = UDim.new(0, 8)
    MLPadding.PaddingBottom = UDim.new(0, 8)
    MLPadding.PaddingLeft = UDim.new(0, 8)
    MLPadding.PaddingRight = UDim.new(0, 8)
    MLPadding.Parent = ModelListLabel

    local TpRarityBtn = CreateButton(t.tpTarget .. rarities[tpRarityIdx], 6)
    TpRarityBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 150)
    TpRarityBtn.MouseButton1Click:Connect(function()
        tpRarityIdx = (tpRarityIdx % #rarities) + 1
        TpRarityBtn.Text = t.tpTarget .. rarities[tpRarityIdx]
    end)

    local TpBtn = CreateButton(t.tpNow, 7)

    local AbRarityBtn = CreateButton(t.buyTarget .. rarities[abRarityIdx], 8)
    AbRarityBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 40)
    AbRarityBtn.MouseButton1Click:Connect(function()
        abRarityIdx = (abRarityIdx % #rarities) + 1
        AbRarityBtn.Text = t.buyTarget .. rarities[abRarityIdx]
    end)

    local BuyBtn = CreateButton(t.buyOff, 9)

    -- Tombol Auto Auction Skip
    local AuctionBtn = CreateButton(t.auctionOff, 10)
    AuctionBtn.BackgroundColor3 = Color3.fromRGB(100, 40, 120)
    AuctionBtn.MouseButton1Click:Connect(function()
        autoAuctionSkip = not autoAuctionSkip
        AuctionBtn.Text = autoAuctionSkip and t.auctionOn or t.auctionOff
        AuctionBtn.BackgroundColor3 = autoAuctionSkip and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(100, 40, 120)

        if autoAuctionSkip then
            task.spawn(function()
                local function autoClickUI(p, keywords)
                    local pGui = p:WaitForChild("PlayerGui")
                    for _, gui in pairs(pGui:GetDescendants()) do
                        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) then
                            local text = (gui:IsA("TextButton") and gui.Text:lower() or "")
                            if gui:FindFirstChildWhichIsA("TextLabel") then text = text .. " " .. gui:FindFirstChildWhichIsA("TextLabel").Text:lower() end
                            local name = gui.Name:lower()

                            for _, kw in pairs(keywords) do
                                if text:match(kw) or name:match(kw) then
                                    pcall(function()
                                        if getconnections then
                                            for _, conn in pairs(getconnections(gui.MouseButton1Click)) do conn:Fire() end
                                            for _, conn in pairs(getconnections(gui.Activated)) do conn:Fire() end
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end

                while autoAuctionSkip do
                    local targetAb = rarities[abRarityIdx]
                    local foundAuctionCar = false

                    for _, car in pairs(latestScanData) do
                        if car.rarity == targetAb then
                            foundAuctionCar = true
                            break
                        end
                    end

                    if not foundAuctionCar and #latestScanData > 0 then
                        -- Jika tidak ada mobil yang sesuai dengan target, cari tombol skip auction / next / leave
                        autoClickUI(player, {"skip", "next", "leave", "exit", "lelang", "tutup"})
                    end

                    task.wait(2)
                end
            end)
        end
    end)

    local DestroyBtn = CreateButton(t.destroy, 11)
    DestroyBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)

    ScanBtn.MouseButton1Click:Connect(function()
        autoScan = not autoScan
        ScanBtn.Text = autoScan and t.scanOn or t.scanOff
        ScanBtn.BackgroundColor3 = autoScan and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(50, 50, 50)
        
        if autoScan then
            ModelListLabel.Text = "Model: Memproses..."
            task.spawn(function()
                while autoScan do
                    local char = player.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then 
                        task.wait(1.5) continue
                    end
                    
                    local root = char.HumanoidRootPart
                    local foundCars = {}
                    local processedCars = {}
                    
                    local rarityCounts = {
                        ["⚪ Common"] = 0, ["🟢 Uncommon"] = 0, ["🔵 Rare"] = 0,
                        ["🟣 Epic"] = 0, ["🟡 Legendary"] = 0, ["🔴 Mythic"] = 0
                    }

                    for _, obj in pairs(workspace:GetDescendants()) do
                        local isCar = false
                        if obj:IsA("VehicleSeat") or (obj:IsA("Seat") and (obj.Name:lower():match("drive") or obj.Name:lower():match("pilot"))) then
                            isCar = true
                        elseif obj:IsA("BasePart") and (obj.Name:lower():match("wheel") or obj.Name:lower():match("tire") or obj.Name:lower():match("ban")) then
                            isCar = true
                        end

                        if isCar then
                            local current = obj
                            local carModel = nil
                            while current and current ~= workspace do
                                if current:IsA("Model") then carModel = current end
                                current = current.Parent
                            end

                            if carModel and not processedCars[carModel] then
                                processedCars[carModel] = true
                                local mName = carModel.Name:lower()
                                
                                local skipOwner = false
                                if mName:match("owner") then skipOwner = true end
                                
                                for _, desc in pairs(carModel:GetDescendants()) do
                                    if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                                        if desc.Text:lower():match("owner") then
                                            skipOwner = true
                                            break
                                        end
                                    end
                                end

                                if not skipOwner and not (mName:match("base") or mName:match("house") or mName:match("home") or mName:match("plot")) then
                                    local isPlayer = false
                                    for _, plr in pairs(Players:GetPlayers()) do
                                        if plr.Character == carModel then isPlayer = true break end
                                    end

                                    if not isPlayer then
                                        local refPart = carModel.PrimaryPart or carModel:FindFirstChildWhichIsA("BasePart", true)
                                        if refPart and (root.Position - refPart.Position).Magnitude <= scanRadius then
                                            if not carMemory[carModel] then
                                                local priceText = "$0"
                                                local numericPrice = 0
                                                local rawRarity = "Common"
                                                local detectedName = carModel.Name

                                                for _, desc in pairs(carModel:GetDescendants()) do
                                                    if desc:IsA("BillboardGui") or desc:IsA("SurfaceGui") then
                                                        for _, gui in pairs(desc:GetDescendants()) do
                                                            if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                                                                local txt = gui.Text
                                                                local txtLower = txt:lower()
                                                                
                                                                if txtLower:match("%$") or txtLower:match("rp") or txtLower:match("price") or txtLower:match("harga") or txt:match("%d+") then
                                                                    if txt ~= carModel.Name and txt ~= "" then
                                                                        local numOnly = string.match(txt, "[%d%.,]+")
                                                                        if numOnly then
                                                                            priceText = "$" .. numOnly
                                                                            numericPrice = tonumber((string.gsub(numOnly, "[,%.]", ""))) or 0
                                                                        end
                                                                    end
                                                                end
                                                                
                                                                if txtLower:match("common") then rawRarity = "Common"
                                                                elseif txtLower:match("uncommon") then rawRarity = "Uncommon"
                                                                elseif txtLower:match("rare") then rawRarity = "Rare"
                                                                elseif txtLower:match("epic") then rawRarity = "Epic"
                                                                elseif txtLower:match("legendary") then rawRarity = "Legendary"
                                                                elseif txtLower:match("mythic") or txtLower:match("exclusive") then rawRarity = "Mythic"
                                                                end

                                                                if txt ~= "" and not txt:match("%$") and not txtLower:match("price") and not txtLower:match("harga") and #txt < 20 and txt ~= carModel.Name then
                                                                    if not txtLower:match("common") and not txtLower:match("rare") and not txtLower:match("epic") and not txtLower:match("legendary") then
                                                                        detectedName = txt
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                                
                                                if rawRarity == "Common" and numericPrice > 0 then
                                                    if numericPrice >= 100000 then rawRarity = "Legendary"
                                                    elseif numericPrice >= 50000 then rawRarity = "Epic"
                                                    elseif numericPrice >= 10000 then rawRarity = "Rare"
                                                    elseif numericPrice >= 5000 then rawRarity = "Uncommon"
                                                    end
                                                end

                                                local rarityWithEmoji = "⚪ Common"
                                                if rawRarity == "Uncommon" then rarityWithEmoji = "🟢 Uncommon"
                                                elseif rawRarity == "Rare" then rarityWithEmoji = "🔵 Rare"
                                                elseif rawRarity == "Epic" then rarityWithEmoji = "🟣 Epic"
                                                elseif rawRarity == "Legendary" then rarityWithEmoji = "🟡 Legendary"
                                                elseif rawRarity == "Mythic" then rarityWithEmoji = "🔴 Mythic"
                                                end

                                                carMemory[carModel] = { name = detectedName, price = priceText, rarity = rarityWithEmoji, raw = rawRarity }
                                            end

                                            local mem = carMemory[carModel]
                                            local carData = {
                                                name = mem.name,
                                                dist = (root.Position - refPart.Position).Magnitude,
                                                price = mem.price,
                                                rarity = mem.rarity,
                                                rawRarity = mem.raw,
                                                cframe = refPart.CFrame,
                                                model = carModel 
                                            }
                                            table.insert(foundCars, carData)
                                            
                                            if rarityCounts[carData.rarity] then
                                                rarityCounts[carData.rarity] = rarityCounts[carData.rarity] + 1
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    latestScanData = foundCars
                    if autoScan then
                        CountLabel.Text = string.format("⚪:%d | 🟢:%d | 🔵:%d | 🟣:%d | 🟡:%d | 🔴:%d",
                            rarityCounts["⚪ Common"], rarityCounts["🟢 Uncommon"], rarityCounts["🔵 Rare"],
                            rarityCounts["🟣 Epic"], rarityCounts["🟡 Legendary"], rarityCounts["🔴 Mythic"])

                        for _, child in pairs(RadarContainer:GetChildren()) do
                            if child:IsA("Frame") then child:Destroy() end
                        end

                        if #foundCars > 0 then
                            table.sort(foundCars, function(a, b) return a.dist < b.dist end)
                            local nameList = {}
                            
                            for i = 1, #foundCars do
                                local c = foundCars[i]
                                local dName = (c.name == "Model" or c.name == "Car") and "Mobil" or c.name
                                
                                local row = Instance.new("Frame")
                                row.Size = UDim2.new(1, 0, 0, 30)
                                row.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                                row.BorderSizePixel = 0
                                row.Parent = RadarContainer
                                
                                local rCorner = Instance.new("UICorner")
                                rCorner.CornerRadius = UDim.new(0, 5)
                                rCorner.Parent = row
                                
                                local infoLbl = Instance.new("TextLabel")
                                infoLbl.Size = UDim2.new(1, -40, 1, 0)
                                infoLbl.Position = UDim2.new(0, 8, 0, 0)
                                infoLbl.BackgroundTransparency = 1
                                infoLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
                                infoLbl.Font = Enum.Font.Gotham
                                infoLbl.TextSize = 11
                                infoLbl.TextXAlignment = Enum.TextXAlignment.Left
                                infoLbl.Text = dName .. " [" .. c.rarity .. "] " .. c.price
                                infoLbl.Parent = row
                                
                                local tpBtn = Instance.new("TextButton")
                                tpBtn.Size = UDim2.new(0, 30, 0, 24)
                                tpBtn.Position = UDim2.new(1, -34, 0.5, -12)
                                tpBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 150)
                                tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                                tpBtn.Font = Enum.Font.GothamBold
                                tpBtn.TextSize = 14
                                tpBtn.Text = ">"
                                tpBtn.Parent = row
                                
                                local tCorner = Instance.new("UICorner")
                                tCorner.CornerRadius = UDim.new(0, 4)
                                tCorner.Parent = tpBtn
                                
                                tpBtn.MouseButton1Click:Connect(function()
                                    local char = player.Character
                                    if char and char:FindFirstChild("HumanoidRootPart") then
                                        char:PivotTo(c.cframe * CFrame.new(0, 5, 0))
                                    end
                                end)
                                
                                table.insert(nameList, dName)
                            end
                            ModelListLabel.Text = table.concat(nameList, ", ")
                        else
                            ModelListLabel.Text = "Model: -"
                        end
                    end
                    task.wait(1.5) 
                end
            end)
        else
            latestScanData = {}
            for _, child in pairs(RadarContainer:GetChildren()) do
                if child:IsA("Frame") then child:Destroy() end
            end
            CountLabel.Text = "⚪:0 | 🟢:0 | 🔵:0 | 🟣:0 | 🟡:0 | 🔴:0"
            ModelListLabel.Text = "Model: -"
        end
    end)

    TpBtn.MouseButton1Click:Connect(function()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local targetTp = rarities[tpRarityIdx]
        local bestCarCFrame = nil
        local minDist = math.huge

        for _, car in pairs(latestScanData) do
            if car.rarity == targetTp and car.dist < minDist then
                minDist = car.dist
                bestCarCFrame = car.cframe
            end
        end

        if bestCarCFrame then
            char:PivotTo(bestCarCFrame * CFrame.new(0, 5, 0))
        end
    end)

    BuyBtn.MouseButton1Click:Connect(function()
        autoBuy = not autoBuy
        BuyBtn.Text = autoBuy and t.buyOn or t.buyOff
        BuyBtn.BackgroundColor3 = autoBuy and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(50, 50, 50)
        
        if autoBuy then
            task.spawn(function()
                local function autoClickUI(p, keywords)
                    local pGui = p:WaitForChild("PlayerGui")
                    for _, gui in pairs(pGui:GetDescendants()) do
                        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) then
                            local text = (gui:IsA("TextButton") and gui.Text:lower() or "")
                            if gui:FindFirstChildWhichIsA("TextLabel") then text = text .. " " .. gui:FindFirstChildWhichIsA("TextLabel").Text:lower() end
                            local name = gui.Name:lower()

                            for _, kw in pairs(keywords) do
                                if text:match(kw) or name:match(kw) then
                                    pcall(function()
                                        if getconnections then
                                            for _, conn in pairs(getconnections(gui.MouseButton1Click)) do conn:Fire() end
                                            for _, conn in pairs(getconnections(gui.Activated)) do conn:Fire() end
                                        end
                                    end)
                                end
                            end
                        end
                    end
                end

                while autoBuy do
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and #latestScanData > 0 then
                        local targetAb = rarities[abRarityIdx]
                        local targetCarModel, targetCarCFrame = nil, nil
                        local minDist = math.huge

                        for _, car in pairs(latestScanData) do
                            if car.rarity == targetAb then
                                local onCooldown = buyCooldown[car.model] and (tick() - buyCooldown[car.model]) < 60
                                if not onCooldown and car.dist < minDist then
                                    minDist = car.dist
                                    targetCarModel = car.model
                                    targetCarCFrame = car.cframe
                                end
                            end
                        end

                        if targetCarModel and targetCarCFrame then
                            buyCooldown[targetCarModel] = tick() 
                            char:PivotTo(targetCarCFrame * CFrame.new(0, 3, 0))
                            task.wait(0.5) 
                            
                            for _, desc in pairs(targetCarModel:GetDescendants()) do
                                if desc:IsA("ProximityPrompt") then fireproximityprompt(desc)
                                elseif desc:IsA("ClickDetector") then fireclickdetector(desc) end
                            end
                            
                            task.wait(1.5) 
                            autoClickUI(player, {"purchase", "buy", "confirm", "yes", "beli"})
                            task.wait(2) 
                        else
                            task.wait(1.5)
                        end
                    else
                        task.wait(1.5)
                    end
                end
            end)
        end
    end)

    DestroyBtn.MouseButton1Click:Connect(function()
        autoScan = false
        autoBuy = false
        autoAuctionSkip = false
        getgenv().CarFlipperVerified = false 
        ScreenGui:Destroy()
    end)
end

if getgenv().CarFlipperVerified then
    LoadMainScript(currentLang)
else
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "CarFlipperKeyGUI"
    KeyGui.ResetOnSpawn = false
    KeyGui.Parent = pcall(function() return CoreGui end) and CoreGui or player.PlayerGui

    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 320, 0, 225)
    KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -112)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Parent = KeyGui

    local KFCorner = Instance.new("UICorner")
    KFCorner.CornerRadius = UDim.new(0, 10)
    KFCorner.Parent = KeyFrame

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, 0, 0, 40)
    KeyTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyTitle.Font = Enum.Font.GothamBold
    KeyTitle.TextSize = 14
    KeyTitle.Text = texts[currentLang].title
    KeyTitle.Parent = KeyFrame

    local KTCorner = Instance.new("UICorner")
    KTCorner.CornerRadius = UDim.new(0, 10)
    KTCorner.Parent = KeyTitle

    local LangBtn = Instance.new("TextButton")
    LangBtn.Size = UDim2.new(0, 45, 0, 30)
    LangBtn.Position = UDim2.new(0, 5, 0, 5)
    LangBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    LangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    LangBtn.Font = Enum.Font.GothamBold
    LangBtn.TextSize = 12
    LangBtn.Text = "🇮🇩 ID"
    LangBtn.Parent = KeyFrame

    local LCorner = Instance.new("UICorner")
    LCorner.CornerRadius = UDim.new(0, 6)
    LCorner.Parent = LangBtn

    local CloseKeyBtn = Instance.new("TextButton")
    CloseKeyBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseKeyBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseKeyBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    CloseKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseKeyBtn.Font = Enum.Font.GothamBold
    CloseKeyBtn.TextSize = 14
    CloseKeyBtn.Text = "X"
    CloseKeyBtn.Parent = KeyFrame
    
    local CKCorner = Instance.new("UICorner")
    CKCorner.CornerRadius = UDim.new(0, 6)
    CKCorner.Parent = CloseKeyBtn

    CloseKeyBtn.MouseButton1Click:Connect(function()
        KeyGui:Destroy()
    end)

    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(0.85, 0, 0, 35)
    KeyBox.Position = UDim2.new(0.075, 0, 0, 55)
    KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 13
    KeyBox.PlaceholderText = texts[currentLang].placeholder
    KeyBox.Text = ""
    KeyBox.Parent = KeyFrame

    local KBCorner = Instance.new("UICorner")
    KBCorner.CornerRadius = UDim.new(0, 6)
    KBCorner.Parent = KeyBox

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0.4, 0, 0, 35)
    SubmitBtn.Position = UDim2.new(0.075, 0, 0, 105)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 13
    SubmitBtn.Text = texts[currentLang].submit
    SubmitBtn.Parent = KeyFrame
    local SBCorner = Instance.new("UICorner")
    SBCorner.CornerRadius = UDim.new(0, 6)
    SBCorner.Parent = SubmitBtn

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(0.4, 0, 0, 35)
    GetKeyBtn.Position = UDim2.new(0.525, 0, 0, 105)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 150)
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.TextSize = 13
    GetKeyBtn.Text = texts[currentLang].getkey
    GetKeyBtn.Parent = KeyFrame
    local GKCorner = Instance.new("UICorner")
    GKCorner.CornerRadius = UDim.new(0, 6)
    GKCorner.Parent = GetKeyBtn

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Size = UDim2.new(0.85, 0, 0, 35)
    DiscordBtn.Position = UDim2.new(0.075, 0, 0, 155)
    DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DiscordBtn.Font = Enum.Font.GothamBold
    DiscordBtn.TextSize = 13
    DiscordBtn.Text = texts[currentLang].discord
    DiscordBtn.Parent = KeyFrame
    local DBoring = Instance.new("UICorner")
    DBoring.CornerRadius = UDim.new(0, 6)
    DBoring.Parent = DiscordBtn

    LangBtn.MouseButton1Click:Connect(function()
        if currentLang == "ID" then
            currentLang = "EN"
            LangBtn.Text = "🇺🇲 US"
        elseif currentLang == "EN" then
            currentLang = "TW"
            LangBtn.Text = "🇹🇼 繁中"
        else
            currentLang = "ID"
            LangBtn.Text = "🇮🇩 ID"
        end
        
        local t = texts[currentLang]
        KeyTitle.Text = t.title
        KeyBox.PlaceholderText = t.placeholder
        SubmitBtn.Text = t.submit
        GetKeyBtn.Text = t.getkey
        DiscordBtn.Text = t.discord
    end)

    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(LinkPastebinKey)
            KeyTitle.Text = texts[currentLang].copiedKey
            task.wait(2)
            KeyTitle.Text = texts[currentLang].title
        end
    end)

    DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(LinkDiscord)
            KeyTitle.Text = texts[currentLang].copiedDiscord
            task.wait(2)
            KeyTitle.Text = texts[currentLang].title
        end
    end)

    SubmitBtn.MouseButton1Click:Connect(function()
        local success, response = pcall(function()
            return game:HttpGet(LinkPastebinKey)
        end)
        
        if success then
            local validKey = string.gsub(response, "%s+", "")
            local inputKey = string.gsub(KeyBox.Text, "%s+", "")
            
            if inputKey == validKey and inputKey ~= "" then
                getgenv().CarFlipperVerified = true
                KeyGui:Destroy()
                LoadMainScript(currentLang) 
            else
                KeyTitle.Text = texts[currentLang].wrong
                task.wait(2)
                KeyTitle.Text = texts[currentLang].title
            end
        else
            KeyTitle.Text = texts[currentLang].fail
            task.wait(2)
            KeyTitle.Text = texts[currentLang].title
        end
    end)
end
