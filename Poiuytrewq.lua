local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Buat ScreenGui
local HubGui = Instance.new("ScreenGui")
HubGui.Name = "TopUpHubCustom"
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
TargetBall.Visible = false -- Disembunyikan sampai tab auto click dibuka
TargetBall.Parent = HubGui

local BallCorner = Instance.new("UICorner")
BallCorner.CornerRadius = UDim.new(1, 0)
BallCorner.Parent = TargetBall

local BallStroke = Instance.new("UIStroke")
BallStroke.Color = Color3.fromRGB(255, 255, 255)
BallStroke.Thickness = 2
BallStroke.Parent = TargetBall

local Crosshair = Instance.new("TextLabel")
Crosshair.Size = UDim2.new(1, 0, 1, 0)
Crosshair.BackgroundTransparency = 1
Crosshair.Text = "+"
Crosshair.TextColor3 = Color3.fromRGB(255, 255, 255)
Crosshair.TextSize = 25
Crosshair.Parent = TargetBall

-- Sistem Drag untuk Bola Target
local draggingBall, dragInputBall, dragStartBall, startPosBall
TargetBall.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBall = true
        dragStartBall = input.Position
        startPosBall = TargetBall.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingBall = false end
        end)
    end
end)
TargetBall.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputBall = input
    end
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
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, 0.6, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true -- Agar saat di-collapse isinya tersembunyi
MainFrame.Parent = HubGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "TopUp Hub | Custom UI"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Tombol Collapse (Minimize)
local CollapseBtn = Instance.new("TextButton")
CollapseBtn.Size = UDim2.new(0, 30, 0, 30)
CollapseBtn.Position = UDim2.new(1, -30, 0, 0)
CollapseBtn.BackgroundTransparency = 1
CollapseBtn.Text = "➖"
CollapseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CollapseBtn.TextSize = 14
CollapseBtn.Parent = MainFrame

local isCollapsed = false
CollapseBtn.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 30), "Out", "Quad", 0.3, true)
        CollapseBtn.Text = "➕"
    else
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 250), "Out", "Quad", 0.3, true)
        CollapseBtn.Text = "➖"
    end
end)

-- Garis Pembatas
local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, 0, 0, 2)
Line.Position = UDim2.new(0, 0, 0, 30)
Line.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- Sistem Drag Frame Utama
local dragging, dragInput, dragStart, startPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Kontainer Tab & Isi
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 100, 1, -32)
TabContainer.Position = UDim2.new(0, 0, 0, 32)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -105, 1, -40)
ContentContainer.Position = UDim2.new(0, 100, 0, 36)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local function CreateTabButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.Parent = TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local TabScan = CreateTabButton("Scan Layar", 5)
local TabClick = CreateTabButton("Auto Click", 40)
local TabSet = CreateTabButton("Settings", 75)

local PageScan = Instance.new("Frame", ContentContainer)
PageScan.Size = UDim2.new(1, 0, 1, 0); PageScan.BackgroundTransparency = 1

local PageClick = Instance.new("Frame", ContentContainer)
PageClick.Size = UDim2.new(1, 0, 1, 0); PageClick.BackgroundTransparency = 1; PageClick.Visible = false

local PageSet = Instance.new("Frame", ContentContainer)
PageSet.Size = UDim2.new(1, 0, 1, 0); PageSet.BackgroundTransparency = 1; PageSet.Visible = false

-- Logika Pindah Tab (Munculkan bola saat di tab Auto Click)
TabScan.MouseButton1Click:Connect(function() PageScan.Visible = true; PageClick.Visible = false; PageSet.Visible = false; TargetBall.Visible = false end)
TabClick.MouseButton1Click:Connect(function() PageScan.Visible = false; PageClick.Visible = true; PageSet.Visible = false; TargetBall.Visible = true end)
TabSet.MouseButton1Click:Connect(function() PageScan.Visible = false; PageClick.Visible = false; PageSet.Visible = true; TargetBall.Visible = false end)

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
ScanResult.Text = "Menunggu interaksi..."
ScanResult.Font = Enum.Font.Gotham
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

local function MonitorUI(guiElement)
    pcall(function()
        if guiElement:IsA("GuiObject") or guiElement:IsA("ScreenGui") then
            guiElement:GetPropertyChangedSignal("Visible"):Connect(function()
                if activeScanner and guiElement.Visible then
                    ScanResult.Text = "🔥 MENU MUNCUL 🔥\n\nNama: " .. guiElement.Name
                end
            end)
        end
    end)
end

task.spawn(function()
    for _, gui in pairs(LocalPlayer:WaitForChild("PlayerGui"):GetDescendants()) do MonitorUI(gui) end
    LocalPlayer.PlayerGui.DescendantAdded:Connect(function(desc) MonitorUI(desc) end)
end)

-- =======================================
-- KONTEN: AUTO CLICK BOLA
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
                    -- Ambil posisi tengah dari bola target
                    local targetX = TargetBall.AbsolutePosition.X + (TargetBall.AbsoluteSize.X / 2)
                    local targetY = TargetBall.AbsolutePosition.Y + (TargetBall.AbsoluteSize.Y / 2)
                    
                    -- Menyembunyikan bola sesaat agar tidak menghalangi klik ke layar/menu game
                    TargetBall.Visible = false 
                    
                    VirtualInputManager:SendMouseButtonEvent(targetX, targetY, 0, true, game, 1)
                    VirtualInputManager:SendMouseButtonEvent(targetX, targetY, 0, false, game, 1)
                    
                    TargetBall.Visible = true -- Munculkan kembali
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
