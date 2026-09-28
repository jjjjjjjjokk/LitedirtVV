local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Buat ScreenGui
local HubGui = Instance.new("ScreenGui")
HubGui.Name = "TopUpHubCustom"
HubGui.ResetOnSpawn = false
-- Simpan di CoreGui jika exploit mendukung, jika tidak di PlayerGui
pcall(function()
    HubGui.Parent = game:GetService("CoreGui")
end)
if not HubGui.Parent then
    HubGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
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
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "TopUp Hub | Custom UI"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Garis Pembatas
local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, 0, 0, 2)
Line.Position = UDim2.new(0, 0, 0, 30)
Line.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- Membuat Sistem Drag (Bisa digeser)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
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

-- Tab Container
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

-- Fungsi pembuat tombol tab
local function CreateTabButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Parent = TabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

local TabScan = CreateTabButton("Scan Layar", 5)
local TabClick = CreateTabButton("Auto Click", 40)
local TabSet = CreateTabButton("Settings", 75)

-- Halaman Content
local PageScan = Instance.new("Frame")
PageScan.Size = UDim2.new(1, 0, 1, 0)
PageScan.BackgroundTransparency = 1
PageScan.Parent = ContentContainer

local PageClick = Instance.new("Frame")
PageClick.Size = UDim2.new(1, 0, 1, 0)
PageClick.BackgroundTransparency = 1
PageClick.Visible = false
PageClick.Parent = ContentContainer

local PageSet = Instance.new("Frame")
PageSet.Size = UDim2.new(1, 0, 1, 0)
PageSet.BackgroundTransparency = 1
PageSet.Visible = false
PageSet.Parent = ContentContainer

-- Sistem Pindah Tab
TabScan.MouseButton1Click:Connect(function() PageScan.Visible = true; PageClick.Visible = false; PageSet.Visible = false end)
TabClick.MouseButton1Click:Connect(function() PageScan.Visible = false; PageClick.Visible = true; PageSet.Visible = false end)
TabSet.MouseButton1Click:Connect(function() PageScan.Visible = false; PageClick.Visible = false; PageSet.Visible = true end)

-- =======================================
-- KONTEN: SCAN LAYAR
-- =======================================
local ToggleScanBtn = Instance.new("TextButton")
ToggleScanBtn.Size = UDim2.new(1, 0, 0, 35)
ToggleScanBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
ToggleScanBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleScanBtn.Text = "🔴 Deteksi Layar OFF"
ToggleScanBtn.Font = Enum.Font.GothamBold
ToggleScanBtn.TextSize = 14
ToggleScanBtn.Parent = PageScan
Instance.new("UICorner", ToggleScanBtn)

local ScanResult = Instance.new("TextLabel")
ScanResult.Size = UDim2.new(1, 0, 1, -45)
ScanResult.Position = UDim2.new(0, 0, 0, 45)
ScanResult.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ScanResult.TextColor3 = Color3.fromRGB(200, 200, 200)
ScanResult.Text = "Menunggu interaksi...\n(Tekan 'Train' dll)"
ScanResult.TextWrapped = true
ScanResult.Font = Enum.Font.Gotham
ScanResult.TextSize = 12
ScanResult.Parent = PageScan
Instance.new("UICorner", ScanResult)

local activeScanner = false
ToggleScanBtn.MouseButton1Click:Connect(function()
    activeScanner = not activeScanner
    if activeScanner then
        ToggleScanBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
        ToggleScanBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        ToggleScanBtn.Text = "🟢 Deteksi Layar ON"
        ScanResult.Text = "Memantau layar...\nSilakan tap sesuatu."
    else
        ToggleScanBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        ToggleScanBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        ToggleScanBtn.Text = "🔴 Deteksi Layar OFF"
        ScanResult.Text = "Monitor dihentikan."
    end
end)

local function MonitorUI(guiElement)
    pcall(function()
        if guiElement:IsA("GuiObject") or guiElement:IsA("ScreenGui") then
            guiElement:GetPropertyChangedSignal("Visible"):Connect(function()
                if activeScanner and guiElement.Visible then
                    ScanResult.Text = "🔥 MENU MUNCUL 🔥\n\nNama: " .. guiElement.Name .. "\nLokasi: " .. (guiElement.Parent and guiElement.Parent.Name or "Unknown")
                end
            end)
        end
    end)
end

task.spawn(function()
    for _, gui in pairs(LocalPlayer:WaitForChild("PlayerGui"):GetDescendants()) do MonitorUI(gui) end
    LocalPlayer.PlayerGui.DescendantAdded:Connect(function(desc)
        MonitorUI(desc)
        pcall(function()
            if activeScanner and (desc:IsA("ScreenGui") or desc:IsA("Frame")) then
                task.wait(0.1)
                if desc.Visible then
                    ScanResult.Text = "⚡ LAYAR BARU 🔥\n\nNama: " .. desc.Name
                end
            end
        end)
    end)
end)

-- =======================================
-- KONTEN: AUTO CLICK
-- =======================================
local cpsValue = 10
local autoClicking = false

local CPSInput = Instance.new("TextBox")
CPSInput.Size = UDim2.new(1, 0, 0, 35)
CPSInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
CPSInput.TextColor3 = Color3.fromRGB(255, 255, 255)
CPSInput.Text = "Kecepatan CPS: 10"
CPSInput.Font = Enum.Font.Gotham
CPSInput.TextSize = 14
CPSInput.Parent = PageClick
Instance.new("UICorner", CPSInput)

CPSInput.FocusLost:Connect(function()
    local val = tonumber(string.match(CPSInput.Text, "%d+"))
    if val then
        cpsValue = val
    end
    CPSInput.Text = "Kecepatan CPS: " .. tostring(cpsValue)
end)

local ToggleClickBtn = Instance.new("TextButton")
ToggleClickBtn.Size = UDim2.new(1, 0, 0, 45)
ToggleClickBtn.Position = UDim2.new(0, 0, 0, 45)
ToggleClickBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
ToggleClickBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleClickBtn.Text = "🔴 Auto Click OFF"
ToggleClickBtn.Font = Enum.Font.GothamBold
ToggleClickBtn.TextSize = 16
ToggleClickBtn.Parent = PageClick
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
                    if mouse1click then
                        mouse1click()
                    else
                        VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 1)
                    end
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
local DestroyBtn = Instance.new("TextButton")
DestroyBtn.Size = UDim2.new(1, 0, 0, 45)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DestroyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DestroyBtn.Text = "❌ DESTROY GUI"
DestroyBtn.Font = Enum.Font.GothamBold
DestroyBtn.TextSize = 16
DestroyBtn.Parent = PageSet
Instance.new("UICorner", DestroyBtn)

DestroyBtn.MouseButton1Click:Connect(function()
    autoClicking = false
    activeScanner = false
    HubGui:Destroy()
end)
