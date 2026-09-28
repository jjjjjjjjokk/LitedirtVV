local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local HubGui = Instance.new("ScreenGui")
HubGui.Name = "TopUpHubCustomV4"
HubGui.ResetOnSpawn = false
pcall(function() HubGui.Parent = game:GetService("CoreGui") end)
if not HubGui.Parent then HubGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- =======================================
-- BOLA TARGET AUTO CLICK (DRAGGABLE)
-- =======================================
local TargetBall = Instance.new("Frame")
TargetBall.Size = UDim2.new(0, 40, 0, 40)
TargetBall.Position = UDim2.new(0.5, -20, 0.5, -20)
TargetBall.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
TargetBall.BackgroundTransparency = 0.5
TargetBall.BorderSizePixel = 0
TargetBall.Visible = false
TargetBall.Parent = HubGui
Instance.new("UICorner", TargetBall).CornerRadius = UDim.new(1, 0)
local BallStroke = Instance.new("UIStroke", TargetBall)
BallStroke.Color = Color3.fromRGB(255, 255, 255)
BallStroke.Thickness = 2
local Crosshair = Instance.new("TextLabel", TargetBall)
Crosshair.Size = UDim2.new(1, 0, 1, 0)
Crosshair.BackgroundTransparency = 1
Crosshair.Text = "+"
Crosshair.TextColor3 = Color3.fromRGB(255, 255, 255)
Crosshair.TextSize = 25

local draggingBall, dragInputBall, dragStartBall, startPosBall
TargetBall.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBall = true
        dragStartBall = input.Position
        startPosBall = TargetBall.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then draggingBall = false end end)
    end
end)
TargetBall.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInputBall = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInputBall and draggingBall then
        local delta = input.Position - dragStartBall
        TargetBall.Position = UDim2.new(startPosBall.X.Scale, startPosBall.X.Offset + delta.X, startPosBall.Y.Scale, startPosBall.Y.Offset + delta.Y)
    end
end)

-- =======================================
-- FRAME UTAMA UI
-- =======================================
local MainFrame = Instance.new("Frame", HubGui)
MainFrame.Size = UDim2.new(0, 450, 0, 260)
MainFrame.Position = UDim2.new(0.5, -225, 0.6, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "TopUp Hub | V4 (Visual)"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

local CollapseBtn = Instance.new("TextButton", MainFrame)
CollapseBtn.Size = UDim2.new(0, 30, 0, 30)
CollapseBtn.Position = UDim2.new(1, -30, 0, 0)
CollapseBtn.BackgroundTransparency = 1
CollapseBtn.Text = "➖"
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.TextSize = 14

local isCollapsed = false
CollapseBtn.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        MainFrame:TweenSize(UDim2.new(0, 450, 0, 30), "Out", "Quad", 0.3, true)
        CollapseBtn.Text = "➕"
    else
        MainFrame:TweenSize(UDim2.new(0, 450, 0, 260), "Out", "Quad", 0.3, true)
        CollapseBtn.Text = "➖"
    end
end)

local Line = Instance.new("Frame", MainFrame)
Line.Size = UDim2.new(1, 0, 0, 2)
Line.Position = UDim2.new(0, 0, 0, 30)
Line.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Line.BorderSizePixel = 0

local dragging, dragInput, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- =======================================
-- TABS & KONTEN
-- =======================================
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(0, 110, 1, -32)
TabContainer.Position = UDim2.new(0, 0, 0, 32)
TabContainer.BackgroundTransparency = 1

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -115, 1, -40)
ContentContainer.Position = UDim2.new(0, 110, 0, 36)
ContentContainer.BackgroundTransparency = 1

local function CreateTabButton(name, posY)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local TabScan = CreateTabButton("Scan Layar", 5)
local TabHistory = CreateTabButton("Riwayat UI", 40)
local TabClick = CreateTabButton("Auto Click", 75)
local TabSet = CreateTabButton("Settings", 110)

local function CreatePage()
    local page = Instance.new("Frame", ContentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    return page
end

local PageScan = CreatePage(); PageScan.Visible = true
local PageHistory = CreatePage()
local PageClick = CreatePage()
local PageSet = CreatePage()

local function SwitchTab(pageToShow, showBall)
    PageScan.Visible = (pageToShow == PageScan)
    PageHistory.Visible = (pageToShow == PageHistory)
    PageClick.Visible = (pageToShow == PageClick)
    PageSet.Visible = (pageToShow == PageSet)
    TargetBall.Visible = showBall
end

TabScan.MouseButton1Click:Connect(function() SwitchTab(PageScan, false) end)
TabHistory.MouseButton1Click:Connect(function() SwitchTab(PageHistory, false) end)
TabClick.MouseButton1Click:Connect(function() SwitchTab(PageClick, true) end)
TabSet.MouseButton1Click:Connect(function() SwitchTab(PageSet, false) end)

-- =======================================
-- KONTEN: RIWAYAT UI
-- =======================================
local HistoryScroll = Instance.new("ScrollingFrame", PageHistory)
HistoryScroll.Size = UDim2.new(1, 0, 1, 0)
HistoryScroll.BackgroundTransparency = 1
HistoryScroll.ScrollBarThickness = 4
HistoryScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local HistoryLayout = Instance.new("UIListLayout", HistoryScroll)
HistoryLayout.Padding = UDim.new(0, 5)

local savedUIs = {}

-- =======================================
-- KONTEN: SCAN LAYAR
-- =======================================
local ToggleScanBtn = Instance.new("TextButton", PageScan)
ToggleScanBtn.Size = UDim2.new(1, 0, 0, 35)
ToggleScanBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
ToggleScanBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleScanBtn.Text = "🔴 Deteksi Layar OFF"
ToggleScanBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleScanBtn)

local ScanResult = Instance.new("TextLabel", PageScan)
ScanResult.Size = UDim2.new(1, 0, 1, -45)
ScanResult.Position = UDim2.new(0, 0, 0, 45)
ScanResult.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ScanResult.TextColor3 = Color3.fromRGB(200, 200, 200)
ScanResult.Text = "Menunggu interaksi popup..."
ScanResult.Font = Enum.Font.Gotham
ScanResult.TextWrapped = true
ScanResult.TextSize = 12
Instance.new("UICorner", ScanResult)

local activeScanner = false
ToggleScanBtn.MouseButton1Click:Connect(function()
    activeScanner = not activeScanner
    if activeScanner then
        ToggleScanBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
        ToggleScanBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        ToggleScanBtn.Text = "🟢 Deteksi Layar ON"
    else
        ToggleScanBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        ToggleScanBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        ToggleScanBtn.Text = "🔴 Deteksi Layar OFF"
    end
end)

local function GetFullPath(obj)
    local path = obj.Name
    local curr = obj.Parent
    while curr and curr.Name ~= "PlayerGui" and curr ~= game do
        path = curr.Name .. "." .. path
        curr = curr.Parent
    end
    return "PlayerGui." .. path
end

-- Fungsi memunculkan Teks di layar pas di tengah/bawah menu
local function TampilkanLabelDiLayar(guiElement)
    pcall(function()
        local labelMarker = Instance.new("TextLabel")
        labelMarker.Parent = HubGui
        labelMarker.Size = UDim2.new(0, 250, 0, 40)
        labelMarker.BackgroundTransparency = 0.3
        labelMarker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        labelMarker.TextColor3 = Color3.fromRGB(0, 255, 255)
        labelMarker.TextStrokeTransparency = 0
        labelMarker.Font = Enum.Font.GothamBlack
        labelMarker.TextSize = 16
        labelMarker.Text = "NAMA UI: " .. guiElement.Name
        labelMarker.ZIndex = 100
        Instance.new("UICorner", labelMarker).CornerRadius = UDim.new(0, 8)
        
        -- Cari posisi dari menu popup-nya
        if guiElement:IsA("GuiObject") then
            local absPos = guiElement.AbsolutePosition
            local absSize = guiElement.AbsoluteSize
            -- Letakkan agak ke bawah tengah dari menu itu
            labelMarker.Position = UDim2.new(0, absPos.X + (absSize.X / 2) - 125, 0, absPos.Y + (absSize.Y / 2) + (absSize.Y / 3))
        else
            -- Kalau tidak dapat posisinya, taruh di bawah tengah layar
            labelMarker.Position = UDim2.new(0.5, -125, 0.8, 0)
        end

        -- Hancurkan tulisan setelah 4 detik
        task.delay(4, function()
            if labelMarker then labelMarker:Destroy() end
        end)
    end)
end

local function ProcessDetectedUI(guiElement)
    if not activeScanner then return end
    if guiElement:IsA("GuiObject") or guiElement:IsA("ScreenGui") then
        if guiElement.Name == "TopUpHubCustomV4" then return end 
        
        local path = GetFullPath(guiElement)
        
        if not savedUIs[path] then
            savedUIs[path] = true
            ScanResult.Text = "🔥 POPUP TERDETEKSI!\nNama: " .. guiElement.Name .. "\nBuka tab 'Riwayat UI' untuk melihat/copy."
            
            -- Memunculkan Label Nama Visual di layar
            TampilkanLabelDiLayar(guiElement)
            
            -- Buat tombol di tab riwayat
            local btn = Instance.new("TextButton", HistoryScroll)
            btn.Size = UDim2.new(1, -10, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            btn.TextColor3 = Color3.fromRGB(0, 255, 255)
            btn.Text = "  " .. guiElement.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            btn.MouseButton1Click:Connect(function()
                ScanResult.Text = "Path Dipilih (Siap di copy):\n" .. path
                SwitchTab(PageScan, false)
                pcall(function() setclipboard(path) end) 
            end)
        end
    end
end

LocalPlayer.PlayerGui.DescendantAdded:Connect(function(desc)
    pcall(function()
        task.wait(0.1)
        if desc:IsA("GuiObject") or desc:IsA("ScreenGui") then
            if desc.Visible or desc:IsA("ScreenGui") then
                ProcessDetectedUI(desc)
            end
        end
    end)
end)

local function MonitorExisting(guiElement)
    pcall(function()
        if guiElement:IsA("GuiObject") or guiElement:IsA("ScreenGui") then
            guiElement:GetPropertyChangedSignal("Visible"):Connect(function()
                if guiElement.Visible then ProcessDetectedUI(guiElement) end
            end)
        end
    end)
end

task.spawn(function()
    for _, gui in pairs(LocalPlayer:WaitForChild("PlayerGui"):GetDescendants()) do MonitorExisting(gui) end
end)

-- =======================================
-- KONTEN: AUTO CLICK
-- =======================================
local cpsValue = 10
local autoClicking = false

local CPSInput = Instance.new("TextBox", PageClick)
CPSInput.Size = UDim2.new(1, 0, 0, 35)
CPSInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
CPSInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CPSInput.Text = "Kecepatan CPS: 10"
CPSInput.Font = Enum.Font.Gotham
Instance.new("UICorner", CPSInput)
CPSInput.FocusLost:Connect(function()
    local val = tonumber(string.match(CPSInput.Text, "%d+"))
    if val then cpsValue = val end
    CPSInput.Text = "Kecepatan CPS: " .. tostring(cpsValue)
end)

local ToggleClickBtn = Instance.new("TextButton", PageClick)
ToggleClickBtn.Size = UDim2.new(1, 0, 0, 45)
ToggleClickBtn.Position = UDim2.new(0, 0, 0, 45)
ToggleClickBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
ToggleClickBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleClickBtn.Text = "🔴 Auto Click OFF"
ToggleClickBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleClickBtn)

ToggleClickBtn.MouseButton1Click:Connect(function()
    autoClicking = not autoClicking
    if autoClicking then
        ToggleClickBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
        ToggleClickBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        ToggleClickBtn.Text = "🟢 Auto Click ON"
        
        task.spawn(function()
            while autoClicking do
                pcall(function()
                    local targetX = TargetBall.AbsolutePosition.X + (TargetBall.AbsoluteSize.X / 2)
                    local targetY = TargetBall.AbsolutePosition.Y + (TargetBall.AbsoluteSize.Y / 2) + 36
                    TargetBall.Visible = false 
                    VirtualInputManager:SendMouseButtonEvent(targetX, targetY, 0, true, game, 1)
                    VirtualInputManager:SendMouseButtonEvent(targetX, targetY, 0, false, game, 1)
                    TargetBall.Visible = true
                end)
                task.wait(1 / cpsValue)
            end
        end)
    else
        ToggleClickBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        ToggleClickBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        ToggleClickBtn.Text = "🔴 Auto Click OFF"
    end
end)

-- =======================================
-- KONTEN: SETTINGS / DESTROY
-- =======================================
local DestroyBtn = Instance.new("TextButton", PageSet)
DestroyBtn.Size = UDim2.new(1, 0, 0, 45)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DestroyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DestroyBtn.Text = "❌ DESTROY GUI"
DestroyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", DestroyBtn)

DestroyBtn.MouseButton1Click:Connect(function()
    autoClicking = false
    activeScanner = false
    HubGui:Destroy()
end)
