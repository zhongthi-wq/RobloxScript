-- ============================================================
-- vThai - Key System (standalone loader)
-- ============================================================
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")

local lp = Players.LocalPlayer

----------------- CONFIG -----------------
local KEY          = "vthai_871f92b"
local SCRIPT_URL   = "https://raw.githubusercontent.com/vthaime/SriptBlox/refs/heads/main/zombiearena.lua"
local MAX_ATTEMPTS = 3
local YT_URL       = "https://www.youtube.com/@littlepoorboy09"
local DC_URL       = "https://discord.gg/HJ34QyRzA8"
local WEB_URL      = "https://vthai.me"
------------------------------------------

----------------- gui parent (executor-safe) -----------------
local function getGuiParent()
    if gethui then return gethui() end
    if syn and syn.protect_gui then return CoreGui end
    return lp:WaitForChild("PlayerGui")
end

-- Cleanup old instance if rerun
local existing = getGuiParent():FindFirstChild("vThai_KeySystem")
if existing then existing:Destroy() end

----------------- build UI -----------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "vThai_KeySystem"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder   = 999999
if syn and syn.protect_gui then pcall(syn.protect_gui, screenGui) end
screenGui.Parent = getGuiParent()

local dimmer = Instance.new("Frame", screenGui)
dimmer.Size = UDim2.new(1, 0, 1, 0)
dimmer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dimmer.BackgroundTransparency = 0.5
dimmer.BorderSizePixel = 0

local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 420, 0, 360)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
main.BorderSizePixel = 0

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(220, 40, 40)
mainStroke.Thickness = 2

-- Title bar
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleFix = Instance.new("Frame", titleBar)
titleFix.Size = UDim2.new(1, 0, 0.5, 0)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
titleFix.BorderSizePixel = 0

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Text = "vThai - Key System"
title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = Instance.new("TextLabel", main)
subtitle.Size = UDim2.new(1, -40, 0, 22)
subtitle.Position = UDim2.new(0, 20, 0, 60)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.GothamBold
subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
subtitle.TextSize = 16
subtitle.Text = "Survival Zombie Arena"
subtitle.TextXAlignment = Enum.TextXAlignment.Left

local desc = Instance.new("TextLabel", main)
desc.Size = UDim2.new(1, -40, 0, 50)
desc.Position = UDim2.new(0, 20, 0, 88)
desc.BackgroundTransparency = 1
desc.Font = Enum.Font.Gotham
desc.TextColor3 = Color3.fromRGB(200, 200, 210)
desc.TextSize = 13
desc.Text = "Please watch the full video to find the key.\nThe key appears at a random timestamp."
desc.TextWrapped = true
desc.TextYAlignment = Enum.TextYAlignment.Top
desc.TextXAlignment = Enum.TextXAlignment.Left

-- Textbox
local textbox = Instance.new("TextBox", main)
textbox.Size = UDim2.new(1, -40, 0, 42)
textbox.Position = UDim2.new(0, 20, 0, 155)
textbox.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
textbox.BorderSizePixel = 0
textbox.Font = Enum.Font.Code
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.PlaceholderText = "Enter key here..."
textbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
textbox.Text = ""
textbox.TextSize = 16
textbox.ClearTextOnFocus = false
Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 6)
local tbStroke = Instance.new("UIStroke", textbox)
tbStroke.Color = Color3.fromRGB(60, 60, 70)
tbStroke.Thickness = 1

-- Submit
local submit = Instance.new("TextButton", main)
submit.Size = UDim2.new(1, -40, 0, 42)
submit.Position = UDim2.new(0, 20, 0, 210)
submit.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
submit.BorderSizePixel = 0
submit.Font = Enum.Font.GothamBold
submit.TextColor3 = Color3.fromRGB(255, 255, 255)
submit.TextSize = 16
submit.Text = "Submit Key"
submit.AutoButtonColor = false
Instance.new("UICorner", submit).CornerRadius = UDim.new(0, 6)

-- Status
local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, -40, 0, 22)
status.Position = UDim2.new(0, 20, 0, 262)
status.BackgroundTransparency = 1
status.Font = Enum.Font.GothamMedium
status.TextColor3 = Color3.fromRGB(150, 150, 160)
status.TextSize = 13
status.Text = ("Attempts left: %d"):format(MAX_ATTEMPTS)
status.TextXAlignment = Enum.TextXAlignment.Left

-- Links
local linksFrame = Instance.new("Frame", main)
linksFrame.Size = UDim2.new(1, -40, 0, 36)
linksFrame.Position = UDim2.new(0, 20, 1, -50)
linksFrame.BackgroundTransparency = 1

local linksLayout = Instance.new("UIListLayout", linksFrame)
linksLayout.FillDirection = Enum.FillDirection.Horizontal
linksLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
linksLayout.VerticalAlignment = Enum.VerticalAlignment.Center
linksLayout.Padding = UDim.new(0, 8)

local function makeLinkBtn(text, url, color)
    local btn = Instance.new("TextButton", linksFrame)
    btn.Size = UDim2.new(0, 115, 1, 0)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Text = text
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        if setclipboard then
            pcall(setclipboard, url)
            local oldText = btn.Text
            btn.Text = "Copied!"
            task.wait(1)
            btn.Text = oldText
        end
    end)
    btn.MouseEnter:Connect(function() btn.BackgroundTransparency = 0.2 end)
    btn.MouseLeave:Connect(function() btn.BackgroundTransparency = 0   end)
    return btn
end

makeLinkBtn("▶ YouTube",  YT_URL, Color3.fromRGB(200, 40, 40))
makeLinkBtn("● Discord",  DC_URL, Color3.fromRGB(88, 101, 242))
makeLinkBtn("🌐 Website", WEB_URL, Color3.fromRGB(50, 50, 60))

----------------- logic -----------------
local attempts  = MAX_ATTEMPTS
local processing = false

local function shake()
    local origin = main.Position
    for i = 1, 5 do
        main.Position = origin + UDim2.new(0, (i % 2 == 0) and -10 or 10, 0, 0)
        task.wait(0.04)
    end
    main.Position = origin
end

local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

local function submitKey()
    if processing then return end
    processing = true

    local input = trim(textbox.Text)

    if input == KEY then
        status.TextColor3 = Color3.fromRGB(40, 220, 80)
        status.Text       = "✓ Correct! Loading script..."
        submit.Text       = "Loading..."
        submit.BackgroundColor3 = Color3.fromRGB(40, 180, 60)
        textbox.TextEditable    = false

        task.wait(0.6)

        -- Fade out
        TweenService:Create(main, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(dimmer, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
        task.wait(0.25)
        screenGui:Destroy()

        -- Load main script
        local ok, err = pcall(function()
            loadstring(game:HttpGet(SCRIPT_URL))()
        end)
        if not ok then
            warn("[vThai] Failed to load script:", err)
        end
        return
    end

    attempts -= 1

    if attempts <= 0 then
        status.TextColor3 = Color3.fromRGB(255, 60, 60)
        status.Text       = "✗ Too many wrong attempts. Kicking..."
        submit.Text       = "REJECTED"
        submit.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        textbox.TextEditable    = false
        task.wait(2)
        lp:Kick("[vThai] Too many incorrect key attempts. Watch the video for the key: " .. YT_URL)
        return
    end

    status.TextColor3 = Color3.fromRGB(255, 80, 80)
    status.Text       = ("✗ Wrong key! Attempts left: %d"):format(attempts)
    shake()
    textbox.Text = ""
    processing = false
end

submit.MouseButton1Click:Connect(submitKey)
submit.MouseEnter:Connect(function()
    if not processing then submit.BackgroundColor3 = Color3.fromRGB(240, 60, 60) end
end)
submit.MouseLeave:Connect(function()
    if not processing then submit.BackgroundColor3 = Color3.fromRGB(220, 40, 40) end
end)
textbox.FocusLost:Connect(function(enter)
    if enter then submitKey() end
end)

-- Open animation
main.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 420, 0, 360)
}):Play()