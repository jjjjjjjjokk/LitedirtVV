local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- SISTEM PENCARIAN TEMPAT UI AMAN
local function getSafeGuiParent()
    local success, parent = pcall(function() if gethui then return gethui() end end)
    if success and parent then return parent end
    
    success, parent = pcall(function() return game:GetService("CoreGui") end)
    if success and parent then return parent end
    
    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = getSafeGuiParent()

-- Hapus UI lama (Anti-Duplicate)
pcall(function()
    if GuiParent:FindFirstChild("LitedirtHubUI") then GuiParent.LitedirtHubUI:Destroy() end
    if GuiParent:FindFirstChild("DeltaModernUI") then GuiParent.DeltaModernUI:Destroy() end
end)

local function applyCorner(gui, radius)
    pcall(function()
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or 8)
        corner.Parent = gui
    end)
end

-- ==========================================
-- MEMBUAT TAMPILAN HUB LAUNCHER
-- ==========================================
local successStart, err = pcall(function()
    local HubGui = Instance.new("ScreenGui")
    HubGui.Name = "LitedirtHubUI"
    HubGui.ResetOnSpawn = false
    HubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    HubGui.Parent = GuiParent

    local HubFrame = Instance.new("Frame")
    HubFrame.Size = UDim2.new(0, 320, 0, 240) 
    HubFrame.Position = UDim2.new(0.5, -160, 0.5, -120)
    HubFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    HubFrame.Active = true
    HubFrame.Draggable = true
    HubFrame.Parent = HubGui
    applyCorner(HubFrame, 12)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.Text = "LITEDIRT | SCRIPT HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.Parent = HubFrame
    applyCorner(Title, 12)

    local InfoText = Instance.new("TextLabel")
    InfoText.Size = UDim2.new(1, -30, 0, 40)
    InfoText.Position = UDim2.new(0, 15, 0, 50)
    InfoText.Text = "Pilih script yang ingin kamu jalankan:"
    InfoText.TextColor3 = Color3.fromRGB(180, 180, 200)
    InfoText.BackgroundTransparency = 1
    InfoText.Font = Enum.Font.Gotham
    InfoText.TextSize = 12
    InfoText.TextWrapped = true
    InfoText.Parent = HubFrame

    local ScrollList = Instance.new("ScrollingFrame")
    ScrollList.Size = UDim2.new(1, -20, 1, -105)
    ScrollList.Position = UDim2.new(0, 10, 0, 95)
    ScrollList.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    ScrollList.BorderSizePixel = 0
    ScrollList.ScrollBarThickness = 4
    ScrollList.Parent = HubFrame
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = ScrollList
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- FUNGSI UNTUK MEMBUAT TOMBOL SCRIPT
    local function buatTombolScript(nama, urlRawGithub)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Text = "🚀 " .. nama
        btn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.Parent = ScrollList
        applyCorner(btn, 8)

        btn.MouseButton1Down:Connect(function()
            btn.Text = "Memuat..."
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
            task.wait(0.5) 
            pcall(function() HubGui:Destroy() end)
            
            -- Eksekusi script dari GitHub menggunakan link yang diberikan
            loadstring(game:HttpGet(urlRawGithub))()
        end)
    end

    -- ==========================================
    -- DAFTAR SCRIPT
    -- ==========================================
    
    -- Tombol 1: Panel Ride Storm (Link dari GitHub Lu)
    buatTombolScript(
        "⚡Ride Storm", 
        "https://raw.githubusercontent.com/litedirt67/LitedirtVV/refs/heads/Litedirt-scriptlua/WMWMWMWMWMWMWMWMWMWM.LUA"
    )

    -- Biar scroll-nya pas sama jumlah tombol
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
end)

if not successStart then
    print("Ada kegagalan memuat GUI: ", tostring(err))
end
