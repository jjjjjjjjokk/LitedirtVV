local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local HubGui = Instance.new("ScreenGui")
HubGui.Name = "LitedirtLiftACubeMathBold"
HubGui.ResetOnSpawn = false
HubGui.IgnoreGuiInset = true
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
Crosshair.Font = Enum.Font.GothamBold

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
-- FRAME UTAMA UI (Litedirt | lift a cube)
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
Title.Text = "𝗟𝗶𝘁𝗲𝗱𝗶𝗿𝘁 | 𝗹𝗶𝗳𝘁 𝗮 𝗰𝘂𝗯𝗲" -- Math Sans Bold
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
CollapseBtn.Font = Enum.Font.GothamBold

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
    btn.Size = UDim2.new(1, -10, 0, 26)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local TabHome = CreateTabButton("𝟭. 𝗛𝗼𝗺𝗲", 5)
local TabAutoClick = CreateTabButton("𝟮. 𝗔𝘂𝘁𝗼 𝗖𝗹𝗶𝗰𝗸", 35)
local TabAutoTrain = CreateTabButton("𝟯. 𝗔𝘂𝘁𝗼 𝗧𝗿𝗮𝗶𝗻", 65)
local TabSet = CreateTabButton("𝟰. 𝗦𝗲𝘁𝘁𝗶𝗻𝗴𝘀", 95)

local function CreatePage()
    local page = Instance.new("Frame", ContentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    return page
end

local PageHome = CreatePage(); PageHome.Visible = true
local PageAutoClick = CreatePage()
local PageAutoTrain = CreatePage()
local PageSet = CreatePage()

TabHome.MouseButton1Click:Connect(function() PageHome.Visible = true; PageAutoClick.Visible = false; PageAutoTrain.Visible = false; PageSet.Visible = false; TargetBall.Visible = false end)
TabAutoClick.MouseButton1Click:Connect(function() PageHome.Visible = false; PageAutoClick.Visible = true; PageAutoTrain.Visible = false; PageSet.Visible = false end)
TabAutoTrain.MouseButton1Click:Connect(function() PageHome.Visible = false; PageAutoClick.Visible = false; PageAutoTrain.Visible = true; PageSet.Visible = false; TargetBall.Visible = false end)
TabSet.MouseButton1Click:Connect(function() PageHome.Visible = false; PageAutoClick.Visible = false; PageAutoTrain.Visible = false; PageSet.Visible = true; TargetBall.Visible = false end)

-- =======================================
-- TAB 1: HOME (INFO LISENSI & AKUN - MATH BOLD)
-- =======================================
local InfoLabel = Instance.new("TextLabel", PageHome)
InfoLabel.Size = UDim2.new(1, 0, 1, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 11
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.TextWrapped = true

local executorName = "𝗨𝗻𝗸𝗻𝗼𝘄𝗻 𝗘𝘅𝗲𝗰𝘂𝘁𝗼𝗿"
pcall(function()
    if identifyexecutor then executorName = identifyexecutor()
    elseif getexecutorname then executorName = getexecutorname() end
end)

local accountAgeDays = LocalPlayer.AccountAge
local creationTimestamp = os.time() - (accountAgeDays * 86400)
local creationDate = os.date("%d-%m-%Y", creationTimestamp)

task.spawn(function()
    while task.wait(1) do
        local currentTime = os.date("%H:%M:%S")
        InfoLabel.Text = string.format(
            "📋 𝗟𝗜𝗦𝗘𝗡𝗦𝗜 𝗦𝗧𝗔𝗧𝗨𝗦: 𝗙𝗥𝗘𝗘 (𝗨𝗡𝗟𝗢𝗖𝗞𝗘𝗗)\n\n" ..
            "👤 𝗡𝗮𝗺𝗮 𝗔𝗸𝘂𝗻 : %s\n" ..
            "📅 𝗔𝗸𝘂𝗻 𝗗𝗶𝗯𝘂𝗮𝘁: %s (%d 𝗛𝗮𝗿𝗶)\n" ..
            "⚡ 𝗖𝗹𝗶𝗲𝗻𝘁 𝗧𝗼𝗼𝗹 : %s\n" ..
            "⏰ 𝗪𝗮𝗸𝘁𝘂 𝗦𝗲𝗿𝘃𝗲𝗿: %s",
            LocalPlayer.Name,
            creationDate,
            accountAgeDays,
            executorName,
            currentTime
        )
    end
end)

-- =======================================
-- TAB 2: AUTO CLICK (MATH BOLD)
-- =======================================
local ShowBallBtn = Instance.new("TextButton", PageAutoClick)
ShowBallBtn.Size = UDim2.new(1, 0, 0, 35)
ShowBallBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ShowBallBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ShowBallBtn.Text = "👁️ 𝗧𝗮𝗺𝗽𝗶𝗹𝗸𝗮𝗻/𝗦𝗲𝗺𝗯𝘂𝗻𝘆𝗶𝗸𝗮𝗻 𝗕𝗼𝗹𝗮"
ShowBallBtn.Font = Enum.Font.GothamBold
ShowBallBtn.TextSize = 12
Instance.new("UICorner", ShowBallBtn)

ShowBallBtn.MouseButton1Click:Connect(function()
    TargetBall.Visible = not TargetBall.Visible
end)

local ToggleBallBtn = Instance.new("TextButton", PageAutoClick)
ToggleBallBtn.Size = UDim2.new(1, 0, 0, 45)
ToggleBallBtn.Position = UDim2.new(0, 0, 0, 45)
ToggleBallBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
ToggleBallBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleBallBtn.Text = "🔴 𝗔𝘂𝘁𝗼 𝗖𝗹𝗶𝗰𝗸 𝗢𝗙𝗙"
ToggleBallBtn.Font = Enum.Font.GothamBold
ToggleBallBtn.TextSize = 13
Instance.new("UICorner", ToggleBallBtn)

local cpsBall = 10
local autoBallRunning = false
ToggleBallBtn.MouseButton1Click:Connect(function()
    autoBallRunning = not autoBallRunning
    if autoBallRunning then
        ToggleBallBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
        ToggleBallBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        ToggleBallBtn.Text = "🟢 𝗔𝘂𝘁𝗼 𝗖𝗹𝗶𝗰𝗸 𝗢𝗡"
        
        task.spawn(function()
            while autoBallRunning do
                pcall(function()
                    local targetX = TargetBall.AbsolutePosition.X + (TargetBall.AbsoluteSize.X / 2)
                    local targetY = TargetBall.AbsolutePosition.Y + (TargetBall.AbsoluteSize.Y / 2)
                    
                    TargetBall.Visible = false 
                    VirtualInputManager:SendMouseButtonEvent(targetX, targetY, 0, true, game, 1)
                    VirtualInputManager:SendMouseButtonEvent(targetX, targetY, 0, false, game, 1)
                    TargetBall.Visible = true
                end)
                task.wait(1 / cpsBall)
            end
        end)
    else
        ToggleBallBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        ToggleBallBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        ToggleBallBtn.Text = "🔴 𝗔𝘂𝘁𝗼 𝗖𝗹𝗶𝗰𝗸 𝗢𝗙𝗙"
    end
end)

-- =======================================
-- TAB 3: AUTO TRAIN (MATH BOLD)
-- =======================================
local ToggleTrainBtn = Instance.new("TextButton", PageAutoTrain)
ToggleTrainBtn.Size = UDim2.new(1, 0, 0, 45)
ToggleTrainBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
ToggleTrainBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleTrainBtn.Text = "🔴 𝗔𝘂𝘁𝗼 𝗧𝗿𝗮𝗶𝗻 𝗢𝗙𝗙"
ToggleTrainBtn.Font = Enum.Font.GothamBold
ToggleTrainBtn.TextSize = 13
Instance.new("UICorner", ToggleTrainBtn)

local autoTrainRunning = false
local trainOffsetX = 50 
local trainOffsetY = 50 

ToggleTrainBtn.MouseButton1Click:Connect(function()
    autoTrainRunning = not autoTrainRunning
    if autoTrainRunning then
        ToggleTrainBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
        ToggleTrainBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        ToggleTrainBtn.Text = "🟢 𝗔𝘂𝘁𝗼 𝗧𝗿𝗮𝗶𝗻 𝗢𝗡"
        
        task.spawn(function()
            while autoTrainRunning do
                pcall(function()
                    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                    if pGui then
                        -- Proteksi Robux: Auto klik X jika muncul menu pembelian
                        local robuxPopup = pGui:FindFirstChild("PurchasePrompt") or pGui:FindFirstChild("RobuxPrompt") or pGui:FindFirstChild("Shop")
                        if robuxPopup then
                            local closeBtn = robuxPopup:FindFirstChild("Close") or robuxPopup:FindFirstChild("X") or robuxPopup:FindFirstChild("Exit")
                            if closeBtn and closeBtn.Visible then
                                local cX = closeBtn.AbsolutePosition.X + (closeBtn.AbsoluteSize.X / 2)
                                local cY = closeBtn.AbsolutePosition.Y + (closeBtn.AbsoluteSize.Y / 2)
                                VirtualInputManager:SendMouseButtonEvent(cX, cY, 0, true, game, 1)
                                VirtualInputManager:SendMouseButtonEvent(cX, cY, 0, false, game, 1)
                                task.wait(0.5)
                            end
                        end

                        -- Auto Train dengan Jeda Spawn
                        local overlay = pGui:FindFirstChild("Overlay")
                        if overlay then
                            local popup = overlay:FindFirstChild("POPUP")
                            if popup then
                                local hint = popup:FindFirstChild("Hint")
                                if hint then
                                    local glyph = hint:FindFirstChild("Glyph")
                                    if glyph and glyph.AbsoluteSize.X > 0 and glyph.Visible then
                                        local gX = glyph.AbsolutePosition.X + (glyph.AbsoluteSize.X / 2) + trainOffsetX
                                        local gY = glyph.AbsolutePosition.Y + (glyph.AbsoluteSize.Y / 2) + trainOffsetY
                                        
                                        VirtualInputManager:SendMouseButtonEvent(gX, gY, 0, true, game, 1)
                                        VirtualInputManager:SendMouseButtonEvent(gX, gY, 0, false, game, 1)
                                        
                                        task.wait(1.5) 
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    else
        ToggleTrainBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        ToggleTrainBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        ToggleTrainBtn.Text = "🔴 𝗔𝘂𝘁𝗼 𝗧𝗿𝗮𝗶𝗻 𝗢𝗙𝗙"
    end
end)

-- =======================================
-- TAB 4: SETTINGS (MATH BOLD)
-- =======================================
local DestroyBtn = Instance.new("TextButton", PageSet)
DestroyBtn.Size = UDim2.new(1, 0, 0, 45)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DestroyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DestroyBtn.Text = "❌ 𝗗𝗘𝗦𝗧𝗥𝗢𝗬 𝗚𝗨𝗜"
DestroyBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", DestroyBtn)

DestroyBtn.MouseButton1Click:Connect(function()
    autoBallRunning = false
    autoTrainRunning = false
    TargetBall:Destroy()
    HubGui:Destroy()
end)
