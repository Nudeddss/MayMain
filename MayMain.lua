--[[
    Hexyra V.0.2.0 — Full Upgraded + Silent Edition
    Fixes: ESP cleanup, Aimbot stability, Freecam smoothness, Dropdown refresh
    Upgrades: Drawing ESP, Charms, Skeleton, Health check, RemoteEvent Training
    New: Device Spoofer, Blatant Boomer, Check Player, Spam Donate
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local SCRIPT_VERSION = "V.0.2.0"
local Features = {}
local AllDropdowns = {}
_G.FriendColor = Color3.fromRGB(0, 255, 0)
_G.EnemyColor = Color3.fromRGB(255, 0, 0)
_G.HexyraRunning = true

local Colors = {
    Purple = Color3.fromHex("#7775F2"),
    Yellow = Color3.fromHex("#ECA201"),
    Green = Color3.fromHex("#10C550"),
    Grey = Color3.fromHex("#83889E"),
    Blue = Color3.fromHex("#257AF7"),
    Red = Color3.fromHex("#EF4F1D"),
    Maroon = Color3.fromHex("#900303"),
    Default = Color3.new(1, 1, 1),
    ModRed = Color3.new(1, 0, 0)
}

WindUI:AddTheme({
    Name = "Hexyra",
    Accent = Color3.fromHex("#18181b"),
    Background = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#08012E"), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromHex("#2E0101"), Transparency = 0.5 },
    }, { Rotation = 90 }),
    BackgroundTransparency = 0,
    Outline = Color3.fromHex("#072EF6"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa"),
    Hover = Color3.fromHex("#FFFFFF"),
    WindowBackground = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#08012E"), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromHex("#2E0101"), Transparency = 0.5 },
    }, { Rotation = 90 }),
    WindowShadow = Color3.fromHex("000000"),
    DialogBackground = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#08012E"), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromHex("#2E0101"), Transparency = 0.5 },
    }, { Rotation = 90 }),
    DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromHex("#FFFFFF"),
    DialogContent = Color3.fromHex("#FFFFFF"),
    DialogIcon = Color3.fromHex("#a1a1aa"),
    WindowTopbarButtonIcon = Color3.fromHex("a1a1aa"),
    WindowTopbarTitle = Color3.fromHex("FFFFFF"),
    WindowTopbarAuthor = Color3.fromHex("FFFFFF"),
    WindowTopbarIcon = Color3.fromHex("FFFFFF"),
    TabBackground = Color3.fromHex("#FFFFFF"),
    TabTitle = Color3.fromHex("#FFFFFF"),
    TabIcon = Color3.fromHex("a1a1aa"),
    ElementBackground = Color3.fromHex("#C3F4FF"),
    ElementTitle = Color3.fromHex("#FFFFFF"),
    ElementDesc = Color3.fromHex("#FFFFFF"),
    ElementIcon = Color3.fromHex("#a1a1aa"),
    PopupBackground = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#08012E"), Transparency = 0.5 },
        ["100"] = { Color = Color3.fromHex("#2E0101"), Transparency = 0.5 },
    }, { Rotation = 90 }),
    PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromHex("#FFFFFF"),
    PopupContent = Color3.fromHex("#FFFFFF"),
    PopupIcon = Color3.fromHex("#a1a1aa"),
    Toggle = Color3.fromHex("#52525b"),
    ToggleBar = Color3.fromHex("#FFFFFF"),
    Checkbox = Color3.fromHex("#52525b"),
    CheckboxIcon = Color3.fromHex("#FFFFFF"),
    Slider = Color3.fromHex("#01FBF7"),
    SliderThumb = Color3.fromHex("#FFFFFF"),
})

local Services = {
    RunService = game:GetService("RunService"),
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    Debris = game:GetService("Debris"),
    HttpService = game:GetService("HttpService"),
    TeleportService = game:GetService("TeleportService"),
    TextChatService = game:GetService("TextChatService"),
    MarketplaceService = game:GetService("MarketplaceService"),
    Lighting = game:GetService("Lighting"),
    Workspace = game:GetService("Workspace"),
    CoreGui = game:GetService("CoreGui"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    StarterGui = game:GetService("StarterGui"),
    NetworkClient = game:GetService("NetworkClient"),
    Stats = game:GetService("Stats"),
}

local LocalPlayer = Services.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local DontTouchPart = {"Right Leg","Right Arm","Left Leg","Left Arm"}

-- ============= --
-- CLEANUP SYSTEM
-- ============= --
local CleanupList = {}
local function AddCleanup(fn) table.insert(CleanupList, fn) end
local function RunCleanup()
    _G.HexyraRunning = false
    for _, fn in ipairs(CleanupList) do pcall(fn) end
    CleanupList = {}
end

-- ============= --
-- UTILS
-- ============= --
local Utils = {
    Alert = function(title, icon, content, duration)
        duration = duration or 3
        return pcall(function()
            WindUI:Notify({ Title = title, Icon = icon, Content = content, Duration = duration })
        end)
    end,

    ShowPopup = function(title, icon, content, buttons)
        return pcall(function()
            WindUI:Popup({
                Title = title, Icon = icon, Content = content,
                Buttons = buttons or {{ Title = "OK", Icon = "check", Variant = "Tertiary" }}
            })
        end)
    end,

    GetPlayerList = function()
        local list = {}
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(list, p.Name) end
        end
        return list
    end,

    CopyToClipboard = function(text)
        if not text or text == "" then return false end
        local ok = pcall(function() if setclipboard then setclipboard(tostring(text)) end end)
        if not ok then
            pcall(function()
                if toclipboard then toclipboard(tostring(text)) end
            end)
        end
        return true
    end,

    RefreshAllDropdowns = function()
        local players = Utils.GetPlayerList()
        for name, dd in pairs(AllDropdowns) do
            pcall(function()
                if dd and dd.Refresh then dd:Refresh(players) end
            end)
            pcall(function()
                if dd and dd.SetValues then dd:SetValues(players) end
            end)
            pcall(function()
                if dd and dd.UpdateValues then dd:UpdateValues(players) end
            end)
        end
    end,

    GetRemoteEvents = function()
        local remotes = {}
        local function scan(parent, path)
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("RemoteEvent") then
                    table.insert(remotes, { Name = child.Name, Path = path .. "/" .. child.Name, Instance = child })
                end
                if child:IsA("Folder") or child:IsA("Model") or child:IsA("Configuration") then
                    pcall(function() scan(child, path .. "/" .. child.Name) end)
                end
            end
        end
        pcall(function() scan(Services.ReplicatedStorage, "ReplicatedStorage") end)
        pcall(function() scan(workspace, "Workspace") end)
        pcall(function()
            local ss = game:GetService("ServerStorage")
            scan(ss, "ServerStorage")
        end)
        return remotes
    end,

    GetRemoteFunctions = function()
        local remotes = {}
        local function scan(parent, path)
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("RemoteFunction") then
                    table.insert(remotes, { Name = child.Name, Path = path .. "/" .. child.Name, Instance = child })
                end
                if child:IsA("Folder") or child:IsA("Model") or child:IsA("Configuration") then
                    pcall(function() scan(child, path .. "/" .. child.Name) end)
                end
            end
        end
        pcall(function() scan(Services.ReplicatedStorage, "ReplicatedStorage") end)
        pcall(function() scan(workspace, "Workspace") end)
        return remotes
    end,

    GetAllRemoteNames = function()
        local names = {}
        local remotes = Utils.GetRemoteEvents()
        for _, r in ipairs(remotes) do table.insert(names, "[RE] " .. r.Path) end
        local funcs = Utils.GetRemoteFunctions()
        for _, r in ipairs(funcs) do table.insert(names, "[RF] " .. r.Path) end
        return names, remotes, funcs
    end,

    FindRemoteByPath = function(path)
        local parts = string.split(path, "/")
        local current = game
        for i, part in ipairs(parts) do
            if part ~= "" then
                local child = current:FindFirstChild(part)
                if child then current = child else return nil end
            end
        end
        return current
    end,

    GetGamepasses = function()
        local passes = {}
        pcall(function()
            local id = game.PlaceId
            -- Try to find gamepasses via MarketplaceService
            for i = 1, 50 do
                pcall(function()
                    local info = Services.MarketplaceService:GetProductInfo(i, Enum.InfoType.GamePass)
                    if info then table.insert(passes, { Id = i, Name = info.Name }) end
                end)
            end
        end)
        return passes
    end,

    GetDevProducts = function()
        local products = {}
        pcall(function()
            for i = 1, 50 do
                pcall(function()
                    local info = Services.MarketplaceService:GetProductInfo(i, Enum.InfoType.Product)
                    if info then table.insert(products, { Id = i, Name = info.Name }) end
                end)
            end
        end)
        return products
    end,
}

-- ============= --
-- MOVEMENT
-- ============= --
Features.Movement = {
    Active = false,
    Speed = 50,
    Connection = nil,

    Toggle = function(state)
        Features.Movement.Active = state
        if state then
            if Features.Movement.Connection then Features.Movement.Connection:Disconnect() end
            Features.Movement.Connection = Services.RunService.Heartbeat:Connect(function(dt)
                if not _G.HexyraRunning then return end
                local char = LocalPlayer.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChild("Humanoid")
                if not root or not hum then return end
                local dir = hum.MoveDirection
                if dir.Magnitude > 0.1 then
                    root.CFrame = root.CFrame + dir * Features.Movement.Speed * dt
                end
            end)
            Utils.Alert("Movement", "zap", "Speed enhanced (CFrame, silent)")
        else
            if Features.Movement.Connection then
                Features.Movement.Connection:Disconnect()
                Features.Movement.Connection = nil
            end
            Utils.Alert("Movement", "zap", "Speed normal")
        end
    end,

    SetSpeed = function(val)
        Features.Movement.Speed = val
    end
}
AddCleanup(function()
    if Features.Movement.Connection then Features.Movement.Connection:Disconnect() end
end)

-- ============= --
-- NOCLIP
-- ============= --
Features.NoClip = {
    Active = false,
    Connection = nil,
    Toggle = function(state)
        Features.NoClip.Active = state
        if state then
            if Features.NoClip.Connection then Features.NoClip.Connection:Disconnect() end
            Features.NoClip.Connection = Services.RunService.Stepped:Connect(function()
                if not _G.HexyraRunning then return end
                local char = LocalPlayer.Character
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
            Utils.Alert("Phase", "ghost", "NoClip active")
        else
            if Features.NoClip.Connection then
                Features.NoClip.Connection:Disconnect()
                Features.NoClip.Connection = nil
            end
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and not table.find(DontTouchPart, part.Name) then
                        part.CanCollide = true
                    end
                end
            end
            Utils.Alert("Phase", "ghost", "NoClip off")
        end
    end
}
AddCleanup(function()
    if Features.NoClip.Connection then Features.NoClip.Connection:Disconnect() end
end)

-- ============= --
-- INFINITE JUMP
-- ============= --
Features.Jump = {
    Active = false,
    Power = 50,
    Connection = nil,
    Toggle = function(state)
        Features.Jump.Active = state
        if state then
            Features.Jump.Connection = Services.UserInputService.JumpRequest:Connect(function()
                if not _G.HexyraRunning then return end
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
            Utils.Alert("Jump", "wind", "Infinite jump ON")
        else
            if Features.Jump.Connection then
                Features.Jump.Connection:Disconnect()
                Features.Jump.Connection = nil
            end
            Utils.Alert("Jump", "wind", "Infinite jump OFF")
        end
    end
}
AddCleanup(function()
    if Features.Jump.Connection then Features.Jump.Connection:Disconnect() end
end)

-- ============= --
-- FLY
-- ============= --
Features.Fly = {
    Active = false,
    Speed = 50,
    Connection = nil,
    BodyGyro = nil,
    BodyVelocity = nil,

    Toggle = function(state)
        Features.Fly.Active = state
        if state then
            local char = LocalPlayer.Character
            if not char then Utils.Alert("Error", "alert-circle", "No character") return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end

            local bg = Instance.new("BodyGyro")
            bg.P = 9e4
            bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
            bg.CFrame = root.CFrame
            bg.Parent = root
            Features.Fly.BodyGyro = bg

            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.zero
            bv.MaxForce = Vector3.new(9e9,9e9,9e9)
            bv.Parent = root
            Features.Fly.BodyVelocity = bv

            Features.Fly.Connection = Services.RunService.RenderStepped:Connect(function()
                if not Features.Fly.Active or not _G.HexyraRunning then return end
                local char2 = LocalPlayer.Character
                if not char2 then return end
                local root2 = char2:FindFirstChild("HumanoidRootPart")
                if not root2 then return end
                local cam = workspace.CurrentCamera
                local dir = Vector3.zero
                local spd = Features.Fly.Speed

                if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end

                if dir.Magnitude > 0 then dir = dir.Unit end
                if Features.Fly.BodyVelocity then Features.Fly.BodyVelocity.Velocity = dir * spd end
                if Features.Fly.BodyGyro then Features.Fly.BodyGyro.CFrame = cam.CFrame end
            end)
            Utils.Alert("Fly", "navigation", "Fly ON")
        else
            if Features.Fly.Connection then Features.Fly.Connection:Disconnect(); Features.Fly.Connection = nil end
            if Features.Fly.BodyGyro then Features.Fly.BodyGyro:Destroy(); Features.Fly.BodyGyro = nil end
            if Features.Fly.BodyVelocity then Features.Fly.BodyVelocity:Destroy(); Features.Fly.BodyVelocity = nil end
            Utils.Alert("Fly", "navigation", "Fly OFF")
        end
    end
}
AddCleanup(function()
    Features.Fly.Toggle(false)
end)

-- ============= --
-- FREECAM (FIXED)
-- ============= --
Features.Freecam = {
    Active = false,
    Speed = 10,
    FastSpeed = 25,
    MouseSensitivity = 0.3,
    CameraPosition = Vector3.zero,
    Yaw = 0,
    Pitch = 0,
    Connections = {},
    OriginalValues = {},

    Toggle = function(state)
        if state then
            if Features.Freecam.Active then return end
            Features.Freecam.Active = true

            local cam = workspace.CurrentCamera
            local char = LocalPlayer.Character

            Features.Freecam.OriginalValues.CameraType = cam.CameraType
            Features.Freecam.OriginalValues.CameraSubject = cam.CameraSubject

            Features.Freecam.CameraPosition = cam.CFrame.Position
            local look = cam.CFrame.LookVector
            Features.Freecam.Yaw = math.atan2(-look.X, -look.Z)
            Features.Freecam.Pitch = math.asin(look.Y)

            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum then
                    Features.Freecam.OriginalValues.WalkSpeed = hum.WalkSpeed
                    Features.Freecam.OriginalValues.JumpPower = hum.JumpPower
                    hum.WalkSpeed = 0
                    hum.JumpPower = 0
                end
                if root then root.Anchored = true end
            end

            cam.CameraType = Enum.CameraType.Scriptable
            Services.UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            Services.UserInputService.MouseIconEnabled = false

            Features.Freecam.Connections.Mouse = Services.UserInputService.InputChanged:Connect(function(input)
                if not Features.Freecam.Active then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    local sens = Features.Freecam.MouseSensitivity * 0.005
                    Features.Freecam.Yaw = Features.Freecam.Yaw - input.Delta.X * sens
                    Features.Freecam.Pitch = math.clamp(
                        Features.Freecam.Pitch - input.Delta.Y * sens,
                        -math.rad(89), math.rad(89)
                    )
                end
            end)

            Features.Freecam.Connections.Render = Services.RunService.RenderStepped:Connect(function(dt)
                if not Features.Freecam.Active then return end
                local cam2 = workspace.CurrentCamera

                local cy, sy = math.cos(Features.Freecam.Yaw), math.sin(Features.Freecam.Yaw)
                local cp, sp = math.cos(Features.Freecam.Pitch), math.sin(Features.Freecam.Pitch)

                local forward = Vector3.new(-sy * cp, sp, -cy * cp)
                local right = Vector3.new(cy, 0, -sy)
                local up = Vector3.new(0, 1, 0)

                local speed = Features.Freecam.Speed
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    speed = Features.Freecam.FastSpeed
                end

                local move = Vector3.zero
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + forward end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - forward end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + right end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - right end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.E) then move = move + up end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.Q) then move = move - up end

                if move.Magnitude > 0 then move = move.Unit end
                Features.Freecam.CameraPosition = Features.Freecam.CameraPosition + move * speed * dt

                local rotation = CFrame.fromEulerAnglesYXZ(Features.Freecam.Pitch, Features.Freecam.Yaw, 0)
                cam2.CFrame = CFrame.new(Features.Freecam.CameraPosition) * rotation
            end)

            Features.Freecam.Connections.Exit = Services.UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Escape and Features.Freecam.Active then
                    Features.Freecam.Toggle(false)
                end
            end)

            Utils.Alert("Freecam", "camera", "WASD Move | E/Q Up/Down | Shift Fast | ESC Exit")
        else
            Features.Freecam.Active = false
            for _, c in pairs(Features.Freecam.Connections) do if c then c:Disconnect() end end
            Features.Freecam.Connections = {}

            Services.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            Services.UserInputService.MouseIconEnabled = true

            local cam = workspace.CurrentCamera
            cam.CameraType = Features.Freecam.OriginalValues.CameraType or Enum.CameraType.Custom
            cam.CameraSubject = Features.Freecam.OriginalValues.CameraSubject

            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum then
                    hum.WalkSpeed = Features.Freecam.OriginalValues.WalkSpeed or 16
                    hum.JumpPower = Features.Freecam.OriginalValues.JumpPower or 50
                    cam.CameraSubject = hum
                end
                if root then root.Anchored = false end
            end
            Utils.Alert("Freecam", "camera-off", "Freecam OFF")
        end
    end
}
AddCleanup(function() if Features.Freecam.Active then Features.Freecam.Toggle(false) end end)

-- ============= --
-- GAME TIME
-- ============= --
Features.GameTime = {
    SelectedTime = nil,
    TimeMap = {
        ["Morning"] = 6, ["Afternoon"] = 12, ["Evening"] = 17,
        ["Night"] = 20, ["Midnight"] = 0, ["Early morning"] = 3
    },
    Select = function(t) Features.GameTime.SelectedTime = t end,
    Change = function()
        if not Features.GameTime.SelectedTime then
            Utils.Alert("Error", "alert-circle", "Select a time first!"); return false
        end
        local v = Features.GameTime.TimeMap[Features.GameTime.SelectedTime]
        if v then Services.Lighting.ClockTime = v; Utils.Alert("Time", "check", "Set to " .. Features.GameTime.SelectedTime); return true end
        return false
    end
}

-- ============= --
-- SPECTATE
-- ============= --
Features.Spectate = {
    Active = false, TargetPlayer = nil, OriginalSubject = nil, Connection = nil,
    Toggle = function(state, playerName)
        if state then
            local target
            for _, p in pairs(Services.Players:GetPlayers()) do
                if p.Name == playerName then target = p; break end
            end
            if not target or target == LocalPlayer then
                Utils.Alert("Error", "alert-circle", "Invalid player"); return false
            end
            Features.Spectate.Active = true
            Features.Spectate.TargetPlayer = target
            Features.Spectate.OriginalSubject = workspace.CurrentCamera.CameraSubject
            local function setcam()
                if not Features.Spectate.Active then return end
                local c = Features.Spectate.TargetPlayer and Features.Spectate.TargetPlayer.Character
                if c then
                    local h = c:FindFirstChildOfClass("Humanoid")
                    if h then workspace.CurrentCamera.CameraSubject = h end
                end
            end
            setcam()
            Features.Spectate.Connection = target.CharacterAdded:Connect(function() task.wait(0.5); setcam() end)
            Utils.Alert("Spectate", "eye", "Spectating: " .. target.Name)
        else
            Features.Spectate.Active = false
            if Features.Spectate.Connection then Features.Spectate.Connection:Disconnect(); Features.Spectate.Connection = nil end
            local c = LocalPlayer.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h then workspace.CurrentCamera.CameraSubject = h end
            end
            Features.Spectate.TargetPlayer = nil
            Utils.Alert("Spectate", "eye-off", "Spectate OFF")
        end
    end
}
AddCleanup(function() if Features.Spectate.Active then Features.Spectate.Toggle(false) end end)

-- ====================================== --
-- ESP (DRAWING API - FULL REWRITE)
-- ====================================== --
local ESPConfig = {
    Enabled = false,
    BoxEnabled = true,
    BoxColor = Color3.fromRGB(255, 255, 255),
    BoxThickness = 1,
    BoxOutline = true,

    NameEnabled = true,
    NameColor = Color3.fromRGB(255, 255, 255),
    NameSize = 14,

    HealthBarEnabled = true,
    HealthTextEnabled = true,
    MinHealthThreshold = 0,

    DistanceEnabled = true,
    DistanceColor = Color3.fromRGB(200, 200, 200),

    TracerEnabled = false,
    TracerColor = Color3.fromRGB(255, 255, 255),
    TracerOrigin = "Bottom",
    TracerThickness = 1,

    SkeletonEnabled = false,
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    SkeletonThickness = 1,

    CharmsEnabled = false,
    CharmsColor = Color3.fromRGB(100, 100, 255),
    CharmsFilled = false,
    CharmsTransparency = 0.5,

    ShowTeamColor = true,
    TeamCheck = false,
    MaxDistance = 1000,
    UseTeamColors = false,
}

local SkeletonJoints_R15 = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}
local SkeletonJoints_R6 = {
    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
    {"Torso","Left Leg"},{"Torso","Right Leg"},
}
local CharmParts_R15 = {"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}
local CharmParts_R6 = {"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}

local ESPObjects = {}

local function CreateESPObject()
    local obj = {
        BoxOutline = Drawing.new("Square"),
        Box = Drawing.new("Square"),
        NameText = Drawing.new("Text"),
        DistanceText = Drawing.new("Text"),
        HealthBar_BG = Drawing.new("Square"),
        HealthBar_Fill = Drawing.new("Square"),
        HealthBar_Outline = Drawing.new("Square"),
        HealthText = Drawing.new("Text"),
        Tracer = Drawing.new("Line"),
        TracerOutline = Drawing.new("Line"),
        SkeletonLines = {},
        CharmSquares = {},
    }
    -- Box
    obj.Box.Thickness = 1; obj.Box.Filled = false; obj.Box.Visible = false
    obj.BoxOutline.Thickness = 3; obj.BoxOutline.Filled = false; obj.BoxOutline.Color = Color3.new(0,0,0); obj.BoxOutline.Visible = false
    -- Name
    obj.NameText.Center = true; obj.NameText.Outline = true; obj.NameText.Visible = false; obj.NameText.Size = 14
    -- Distance
    obj.DistanceText.Center = true; obj.DistanceText.Outline = true; obj.DistanceText.Visible = false; obj.DistanceText.Size = 13
    -- Health bar
    obj.HealthBar_BG.Filled = true; obj.HealthBar_BG.Color = Color3.new(0,0,0); obj.HealthBar_BG.Transparency = 0.5; obj.HealthBar_BG.Visible = false
    obj.HealthBar_Fill.Filled = true; obj.HealthBar_Fill.Visible = false
    obj.HealthBar_Outline.Filled = false; obj.HealthBar_Outline.Color = Color3.new(0,0,0); obj.HealthBar_Outline.Thickness = 1; obj.HealthBar_Outline.Visible = false
    obj.HealthText.Center = true; obj.HealthText.Outline = true; obj.HealthText.Visible = false; obj.HealthText.Size = 11
    -- Tracer
    obj.Tracer.Visible = false; obj.Tracer.Thickness = 1
    obj.TracerOutline.Visible = false; obj.TracerOutline.Thickness = 3; obj.TracerOutline.Color = Color3.new(0,0,0)
    -- Skeleton (max 14)
    for i = 1, 14 do
        local l = Drawing.new("Line"); l.Visible = false; l.Thickness = 1
        table.insert(obj.SkeletonLines, l)
    end
    -- Charms (max 15)
    for i = 1, 15 do
        local s = Drawing.new("Square"); s.Visible = false; s.Filled = false; s.Thickness = 1
        table.insert(obj.CharmSquares, s)
    end
    return obj
end

local function DestroyESPObject(obj)
    if not obj then return end
    pcall(function() obj.Box:Remove() end)
    pcall(function() obj.BoxOutline:Remove() end)
    pcall(function() obj.NameText:Remove() end)
    pcall(function() obj.DistanceText:Remove() end)
    pcall(function() obj.HealthBar_BG:Remove() end)
    pcall(function() obj.HealthBar_Fill:Remove() end)
    pcall(function() obj.HealthBar_Outline:Remove() end)
    pcall(function() obj.HealthText:Remove() end)
    pcall(function() obj.Tracer:Remove() end)
    pcall(function() obj.TracerOutline:Remove() end)
    for _, l in ipairs(obj.SkeletonLines or {}) do pcall(function() l:Remove() end) end
    for _, s in ipairs(obj.CharmSquares or {}) do pcall(function() s:Remove() end) end
end

local function HideESPObject(obj)
    if not obj then return end
    pcall(function() obj.Box.Visible = false end)
    pcall(function() obj.BoxOutline.Visible = false end)
    pcall(function() obj.NameText.Visible = false end)
    pcall(function() obj.DistanceText.Visible = false end)
    pcall(function() obj.HealthBar_BG.Visible = false end)
    pcall(function() obj.HealthBar_Fill.Visible = false end)
    pcall(function() obj.HealthBar_Outline.Visible = false end)
    pcall(function() obj.HealthText.Visible = false end)
    pcall(function() obj.Tracer.Visible = false end)
    pcall(function() obj.TracerOutline.Visible = false end)
    for _, l in ipairs(obj.SkeletonLines or {}) do pcall(function() l.Visible = false end) end
    for _, s in ipairs(obj.CharmSquares or {}) do pcall(function() s.Visible = false end) end
end

local function GetPlayerColor(player)
    if ESPConfig.ShowTeamColor and player.Team then
        return player.TeamColor and player.TeamColor.Color or _G.EnemyColor
    end
    if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
        return _G.FriendColor
    end
    return _G.EnemyColor
end

local function GetBoundingBox2D(character)
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local hum = character:FindFirstChild("Humanoid")
    if not hum then return nil end

    local pos = root.Position
    local cam = workspace.CurrentCamera
    local hipH = hum.HipHeight
    local rigType = character:FindFirstChild("UpperTorso") and "R15" or "R6"
    local height = rigType == "R15" and (hipH + 3.5) or (hipH + 4)

    local top3D = pos + Vector3.new(0, height / 2 + 0.5, 0)
    local bot3D = pos - Vector3.new(0, height / 2, 0)

    local topScreen, topOn = cam:WorldToViewportPoint(top3D)
    local botScreen, botOn = cam:WorldToViewportPoint(bot3D)

    if not topOn and not botOn then return nil end
    if topScreen.Z < 0 then return nil end

    local boxH = math.abs(botScreen.Y - topScreen.Y)
    local boxW = boxH * 0.55
    local cx = (topScreen.X + botScreen.X) / 2

    return {
        TopLeft = Vector2.new(cx - boxW/2, topScreen.Y),
        Size = Vector2.new(boxW, boxH),
        Center = Vector2.new(cx, (topScreen.Y + botScreen.Y)/2),
        Bottom = Vector2.new(cx, botScreen.Y),
        Top = Vector2.new(cx, topScreen.Y),
        OnScreen = true,
        Width = boxW,
        Height = boxH
    }
end

local ESPUpdateConnection
local ESPPlayerConnections = {}

local function UpdateESP()
    if not ESPConfig.Enabled or not _G.HexyraRunning then
        for _, obj in pairs(ESPObjects) do HideESPObject(obj) end
        return
    end

    local cam = workspace.CurrentCamera
    if not cam then return end
    local localChar = LocalPlayer.Character
    local localRoot = localChar and (localChar:FindFirstChild("HumanoidRootPart") or localChar:FindFirstChild("Head"))
    if not localRoot then return end

    for _, player in pairs(Services.Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        if not ESPObjects[player] then
            ESPObjects[player] = CreateESPObject()
        end

        local obj = ESPObjects[player]
        local char = player.Character
        if not char then HideESPObject(obj); continue end

        local hum = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then HideESPObject(obj); continue end

        if hum.Health <= 0 then HideESPObject(obj); continue end

        local dist = (localRoot.Position - root.Position).Magnitude
        if dist > ESPConfig.MaxDistance then HideESPObject(obj); continue end

        -- Team check
        if ESPConfig.TeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
            HideESPObject(obj); continue
        end

        -- Health threshold
        if ESPConfig.MinHealthThreshold > 0 and hum.Health < ESPConfig.MinHealthThreshold then
            HideESPObject(obj); continue
        end

        local bounds = GetBoundingBox2D(char)
        if not bounds then HideESPObject(obj); continue end

        local color = GetPlayerColor(player)
        local healthPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)

        -- BOX
        if ESPConfig.BoxEnabled then
            obj.Box.Position = bounds.TopLeft
            obj.Box.Size = bounds.Size
            obj.Box.Color = ESPConfig.UseTeamColors and color or ESPConfig.BoxColor
            obj.Box.Thickness = ESPConfig.BoxThickness
            obj.Box.Visible = true

            if ESPConfig.BoxOutline then
                obj.BoxOutline.Position = bounds.TopLeft - Vector2.new(1,1)
                obj.BoxOutline.Size = bounds.Size + Vector2.new(2,2)
                obj.BoxOutline.Visible = true
            else
                obj.BoxOutline.Visible = false
            end
        else
            obj.Box.Visible = false; obj.BoxOutline.Visible = false
        end

        -- NAME
        if ESPConfig.NameEnabled then
            obj.NameText.Text = player.Name
            obj.NameText.Position = Vector2.new(bounds.Center.X, bounds.TopLeft.Y - 16)
            obj.NameText.Color = ESPConfig.UseTeamColors and color or ESPConfig.NameColor
            obj.NameText.Size = ESPConfig.NameSize
            obj.NameText.Visible = true
        else
            obj.NameText.Visible = false
        end

        -- DISTANCE
        if ESPConfig.DistanceEnabled then
            obj.DistanceText.Text = string.format("[%dm]", math.floor(dist))
            obj.DistanceText.Position = Vector2.new(bounds.Center.X, bounds.Bottom.Y + 2)
            obj.DistanceText.Color = ESPConfig.DistanceColor
            obj.DistanceText.Visible = true
        else
            obj.DistanceText.Visible = false
        end

        -- HEALTH BAR
        if ESPConfig.HealthBarEnabled then
            local barX = bounds.TopLeft.X - 6
            local barY = bounds.TopLeft.Y
            local barH = bounds.Height
            local barW = 3

            obj.HealthBar_Outline.Position = Vector2.new(barX - 1, barY - 1)
            obj.HealthBar_Outline.Size = Vector2.new(barW + 2, barH + 2)
            obj.HealthBar_Outline.Visible = true

            obj.HealthBar_BG.Position = Vector2.new(barX, barY)
            obj.HealthBar_BG.Size = Vector2.new(barW, barH)
            obj.HealthBar_BG.Visible = true

            local fillH = barH * healthPct
            obj.HealthBar_Fill.Position = Vector2.new(barX, barY + barH - fillH)
            obj.HealthBar_Fill.Size = Vector2.new(barW, fillH)
            obj.HealthBar_Fill.Color = Color3.fromRGB(255 * (1 - healthPct), 255 * healthPct, 0)
            obj.HealthBar_Fill.Visible = true

            if ESPConfig.HealthTextEnabled and healthPct < 1 then
                obj.HealthText.Text = tostring(math.floor(hum.Health))
                obj.HealthText.Position = Vector2.new(barX - 2, barY + barH - fillH - 6)
                obj.HealthText.Color = obj.HealthBar_Fill.Color
                obj.HealthText.Visible = true
            else
                obj.HealthText.Visible = false
            end
        else
            obj.HealthBar_BG.Visible = false; obj.HealthBar_Fill.Visible = false
            obj.HealthBar_Outline.Visible = false; obj.HealthText.Visible = false
        end

        -- TRACER
        if ESPConfig.TracerEnabled then
            local fromPos
            if ESPConfig.TracerOrigin == "Bottom" then
                fromPos = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
            elseif ESPConfig.TracerOrigin == "Top" then
                fromPos = Vector2.new(cam.ViewportSize.X / 2, 0)
            else
                fromPos = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
            end
            obj.TracerOutline.From = fromPos; obj.TracerOutline.To = bounds.Bottom
            obj.TracerOutline.Visible = true
            obj.Tracer.From = fromPos; obj.Tracer.To = bounds.Bottom
            obj.Tracer.Color = ESPConfig.UseTeamColors and color or ESPConfig.TracerColor
            obj.Tracer.Thickness = ESPConfig.TracerThickness
            obj.Tracer.Visible = true
        else
            obj.Tracer.Visible = false; obj.TracerOutline.Visible = false
        end

        -- SKELETON
        if ESPConfig.SkeletonEnabled then
            local isR15 = char:FindFirstChild("UpperTorso") ~= nil
            local joints = isR15 and SkeletonJoints_R15 or SkeletonJoints_R6
            for i, joint in ipairs(joints) do
                local line = obj.SkeletonLines[i]
                if not line then break end
                local p1 = char:FindFirstChild(joint[1])
                local p2 = char:FindFirstChild(joint[2])
                if p1 and p2 then
                    local s1, on1 = cam:WorldToViewportPoint(p1.Position)
                    local s2, on2 = cam:WorldToViewportPoint(p2.Position)
                    if on1 and on2 and s1.Z > 0 and s2.Z > 0 then
                        line.From = Vector2.new(s1.X, s1.Y)
                        line.To = Vector2.new(s2.X, s2.Y)
                        line.Color = ESPConfig.UseTeamColors and color or ESPConfig.SkeletonColor
                        line.Thickness = ESPConfig.SkeletonThickness
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
            for i = #joints + 1, #obj.SkeletonLines do
                obj.SkeletonLines[i].Visible = false
            end
        else
            for _, l in ipairs(obj.SkeletonLines) do l.Visible = false end
        end

        -- CHARMS (body part outlines)
        if ESPConfig.CharmsEnabled then
            local isR15 = char:FindFirstChild("UpperTorso") ~= nil
            local partNames = isR15 and CharmParts_R15 or CharmParts_R6
            for i, partName in ipairs(partNames) do
                local sq = obj.CharmSquares[i]
                if not sq then break end
                local part = char:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    local cf = part.CFrame
                    local sz = part.Size / 2
                    local corners = {
                        (cf * CFrame.new(sz.X, sz.Y, sz.Z)).Position,
                        (cf * CFrame.new(-sz.X, sz.Y, sz.Z)).Position,
                        (cf * CFrame.new(sz.X, -sz.Y, sz.Z)).Position,
                        (cf * CFrame.new(-sz.X, -sz.Y, sz.Z)).Position,
                        (cf * CFrame.new(sz.X, sz.Y, -sz.Z)).Position,
                        (cf * CFrame.new(-sz.X, sz.Y, -sz.Z)).Position,
                        (cf * CFrame.new(sz.X, -sz.Y, -sz.Z)).Position,
                        (cf * CFrame.new(-sz.X, -sz.Y, -sz.Z)).Position,
                    }
                    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
                    local anyOn = false
                    for _, corner in ipairs(corners) do
                        local sp, on = cam:WorldToViewportPoint(corner)
                        if on and sp.Z > 0 then
                            anyOn = true
                            minX = math.min(minX, sp.X); minY = math.min(minY, sp.Y)
                            maxX = math.max(maxX, sp.X); maxY = math.max(maxY, sp.Y)
                        end
                    end
                    if anyOn then
                        sq.Position = Vector2.new(minX, minY)
                        sq.Size = Vector2.new(maxX - minX, maxY - minY)
                        sq.Color = ESPConfig.UseTeamColors and color or ESPConfig.CharmsColor
                        sq.Filled = ESPConfig.CharmsFilled
                        sq.Transparency = ESPConfig.CharmsTransparency
                        sq.Visible = true
                    else
                        sq.Visible = false
                    end
                else
                    sq.Visible = false
                end
            end
            for i = #partNames + 1, #obj.CharmSquares do
                obj.CharmSquares[i].Visible = false
            end
        else
            for _, s in ipairs(obj.CharmSquares) do s.Visible = false end
        end
    end

    -- Clean up removed players
    for player, obj in pairs(ESPObjects) do
        if not player.Parent then
            HideESPObject(obj)
            DestroyESPObject(obj)
            ESPObjects[player] = nil
        end
    end
end

Features.ESP = {
    Config = ESPConfig,

    Toggle = function(state)
        ESPConfig.Enabled = state
        if state then
            if not ESPUpdateConnection then
                ESPUpdateConnection = Services.RunService.RenderStepped:Connect(UpdateESP)
            end
            Utils.Alert("ESP", "eye", "ESP activated (Drawing)")
        else
            for _, obj in pairs(ESPObjects) do HideESPObject(obj) end
            Utils.Alert("ESP", "eye-off", "ESP deactivated")
        end
    end,

    Cleanup = function()
        if ESPUpdateConnection then ESPUpdateConnection:Disconnect(); ESPUpdateConnection = nil end
        for _, obj in pairs(ESPObjects) do DestroyESPObject(obj) end
        ESPObjects = {}
    end
}

AddCleanup(function()
    ESPConfig.Enabled = false
    if ESPUpdateConnection then ESPUpdateConnection:Disconnect(); ESPUpdateConnection = nil end
    for _, obj in pairs(ESPObjects) do
        HideESPObject(obj)
        DestroyESPObject(obj)
    end
    ESPObjects = {}
end)

-- ============= --
-- AIMBOT (IMPROVED, SILENT)
-- ============= --
local AimbotConfig = {
    Enabled = false,
    SilentAim = false,
    FOVEnabled = false,
    FOVRadius = 90,
    TeamCheck = false,
    WallCheck = false,
    TargetPart = "Head",
    Smoothing = 5,
    LockMode = "MouseMove",
    TriggerKey = Enum.UserInputType.MouseButton2,
    Toggle = false,
    Prediction = 0,
    MaxDistance = 1000,
}

local AimbotState = {
    Running = false,
    Locked = nil,
    FOVCircleOutline = Drawing.new("Circle"),
    FOVCircle = Drawing.new("Circle"),
    Connections = {},
    SilentHook = nil,
}

AimbotState.FOVCircle.Visible = false
AimbotState.FOVCircle.Filled = false
AimbotState.FOVCircle.NumSides = 64
AimbotState.FOVCircle.Transparency = 1
AimbotState.FOVCircle.Color = Color3.fromRGB(255, 50, 50)
AimbotState.FOVCircle.Thickness = 1

AimbotState.FOVCircleOutline.Visible = false
AimbotState.FOVCircleOutline.Filled = false
AimbotState.FOVCircleOutline.NumSides = 64
AimbotState.FOVCircleOutline.Transparency = 1
AimbotState.FOVCircleOutline.Color = Color3.new(0,0,0)
AimbotState.FOVCircleOutline.Thickness = 3

local function GetClosestPlayerToMouse()
    local cam = workspace.CurrentCamera
    local mousePos = Services.UserInputService:GetMouseLocation()
    local closest, closestDist = nil, AimbotConfig.FOVEnabled and AimbotConfig.FOVRadius or 2000

    for _, player in pairs(Services.Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        if AimbotConfig.TeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then continue end

        local part = char:FindFirstChild(AimbotConfig.TargetPart)
        if not part then continue end

        local screenPos, onScreen = cam:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local dist2D = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
        local dist3D = (cam.CFrame.Position - part.Position).Magnitude

        if dist3D > AimbotConfig.MaxDistance then continue end

        if AimbotConfig.WallCheck then
            local ray = Ray.new(cam.CFrame.Position, (part.Position - cam.CFrame.Position).Unit * dist3D)
            local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, char})
            if hit then continue end
        end

        if dist2D < closestDist then
            closestDist = dist2D
            closest = player
        end
    end
    return closest
end

local function CancelAimbotLock()
    AimbotState.Locked = nil
    AimbotState.FOVCircle.Color = Color3.fromRGB(255, 50, 50)
end

local function StartAimbot()
    for _, c in pairs(AimbotState.Connections) do if c then c:Disconnect() end end
    AimbotState.Connections = {}

    AimbotState.Connections.Render = Services.RunService.RenderStepped:Connect(function(dt)
        if not _G.HexyraRunning then return end
        local cam = workspace.CurrentCamera
        local mousePos = Services.UserInputService:GetMouseLocation()

        -- FOV circle
        if AimbotConfig.FOVEnabled and AimbotConfig.Enabled then
            AimbotState.FOVCircle.Position = mousePos
            AimbotState.FOVCircle.Radius = AimbotConfig.FOVRadius
            AimbotState.FOVCircle.Visible = true
            AimbotState.FOVCircleOutline.Position = mousePos
            AimbotState.FOVCircleOutline.Radius = AimbotConfig.FOVRadius
            AimbotState.FOVCircleOutline.Visible = true
        else
            AimbotState.FOVCircle.Visible = false
            AimbotState.FOVCircleOutline.Visible = false
        end

        if AimbotState.Running and AimbotConfig.Enabled then
            if not AimbotState.Locked then
                AimbotState.Locked = GetClosestPlayerToMouse()
            end

            if AimbotState.Locked then
                local char = AimbotState.Locked.Character
                if not char then CancelAimbotLock(); return end
                local hum = char:FindFirstChild("Humanoid")
                if not hum or hum.Health <= 0 then CancelAimbotLock(); return end
                local part = char:FindFirstChild(AimbotConfig.TargetPart)
                if not part then CancelAimbotLock(); return end

                local targetPos = part.Position
                if AimbotConfig.Prediction > 0 then
                    local vel = part.Velocity or Vector3.zero
                    targetPos = targetPos + vel * (AimbotConfig.Prediction / 100)
                end

                AimbotState.FOVCircle.Color = Color3.fromRGB(50, 255, 50)

                if not AimbotConfig.SilentAim then
                    if AimbotConfig.LockMode == "MouseMove" then
                        local screenPos = cam:WorldToViewportPoint(targetPos)
                        local smoothing = math.max(AimbotConfig.Smoothing, 1)
                        local deltaX = (screenPos.X - mousePos.X) / smoothing
                        local deltaY = (screenPos.Y - mousePos.Y) / smoothing
                        -- Add tiny randomness for anti-detection
                        deltaX = deltaX + (math.random(-10, 10) / 100)
                        deltaY = deltaY + (math.random(-10, 10) / 100)
                        if mousemoverel then
                            mousemoverel(deltaX, deltaY)
                        elseif Input and Input.MouseMove then
                            Input.MouseMove(deltaX, deltaY)
                        end
                    else -- CFrame
                        local smoothing = math.max(AimbotConfig.Smoothing / 100, 0)
                        if smoothing > 0 then
                            cam.CFrame = cam.CFrame:Lerp(
                                CFrame.new(cam.CFrame.Position, targetPos),
                                math.clamp(dt / smoothing, 0, 1)
                            )
                        else
                            cam.CFrame = CFrame.new(cam.CFrame.Position, targetPos)
                        end
                    end
                end

                -- Check if target out of FOV
                if AimbotConfig.FOVEnabled then
                    local sp = cam:WorldToViewportPoint(part.Position)
                    if (mousePos - Vector2.new(sp.X, sp.Y)).Magnitude > AimbotConfig.FOVRadius * 1.5 then
                        CancelAimbotLock()
                    end
                end
            end
        end
    end)

    local typing = false
    AimbotState.Connections.FocusIn = Services.UserInputService.TextBoxFocused:Connect(function() typing = true end)
    AimbotState.Connections.FocusOut = Services.UserInputService.TextBoxFocusReleased:Connect(function() typing = false end)

    AimbotState.Connections.InputBegan = Services.UserInputService.InputBegan:Connect(function(input)
        if typing then return end
        local match = false
        if typeof(AimbotConfig.TriggerKey) == "EnumItem" then
            if input.UserInputType == AimbotConfig.TriggerKey or input.KeyCode == AimbotConfig.TriggerKey then
                match = true
            end
        end
        if match then
            if AimbotConfig.Toggle then
                AimbotState.Running = not AimbotState.Running
                if not AimbotState.Running then CancelAimbotLock() end
            else
                AimbotState.Running = true
            end
        end
    end)

    AimbotState.Connections.InputEnded = Services.UserInputService.InputEnded:Connect(function(input)
        if AimbotConfig.Toggle then return end
        local match = false
        if typeof(AimbotConfig.TriggerKey) == "EnumItem" then
            if input.UserInputType == AimbotConfig.TriggerKey or input.KeyCode == AimbotConfig.TriggerKey then
                match = true
            end
        end
        if match then
            AimbotState.Running = false
            CancelAimbotLock()
        end
    end)
end

-- Silent Aim hook
local function SetupSilentAim(state)
    if state then
        if hookmetamethod and not AimbotState.SilentHook then
            local oldIndex
            oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
                if AimbotConfig.SilentAim and AimbotConfig.Enabled and AimbotState.Locked then
                    local char = AimbotState.Locked.Character
                    if char then
                        local part = char:FindFirstChild(AimbotConfig.TargetPart)
                        if part then
                            if tostring(self) == "Mouse" or (typeof(self) == "Instance" and self:IsA("Mouse")) then
                                if key == "Hit" then return CFrame.new(part.Position) end
                                if key == "Target" then return part end
                            end
                        end
                    end
                end
                return oldIndex(self, key)
            end))
            AimbotState.SilentHook = true
        end
    end
end

Features.Aimbot = {
    Config = AimbotConfig,
    State = AimbotState,

    Toggle = function(state)
        AimbotConfig.Enabled = state
        if state then
            StartAimbot()
            Utils.Alert("Aimbot", "crosshair", "Aimbot ON")
        else
            AimbotState.Running = false
            CancelAimbotLock()
            AimbotState.FOVCircle.Visible = false
            AimbotState.FOVCircleOutline.Visible = false
            Utils.Alert("Aimbot", "crosshair", "Aimbot OFF")
        end
    end,

    ToggleFOV = function(state) AimbotConfig.FOVEnabled = state end,
    SetFOVSize = function(v) AimbotConfig.FOVRadius = v end,
    SetTargetPart = function(p) AimbotConfig.TargetPart = p end,
    SetSmoothing = function(v) AimbotConfig.Smoothing = v end,
    SetPrediction = function(v) AimbotConfig.Prediction = v end,

    ToggleSilent = function(state)
        AimbotConfig.SilentAim = state
        if state then
            SetupSilentAim(true)
            Utils.Alert("Aimbot", "eye-off", "Silent Aim ON")
        else
            Utils.Alert("Aimbot", "eye", "Silent Aim OFF")
        end
    end,

    SetTriggerKey = function(key)
        if key == "MouseButton1" then AimbotConfig.TriggerKey = Enum.UserInputType.MouseButton1
        elseif key == "MouseButton2" then AimbotConfig.TriggerKey = Enum.UserInputType.MouseButton2
        else pcall(function() AimbotConfig.TriggerKey = Enum.KeyCode[key] end) end
    end
}

AddCleanup(function()
    AimbotConfig.Enabled = false
    AimbotState.Running = false
    CancelAimbotLock()
    for _, c in pairs(AimbotState.Connections) do if c then c:Disconnect() end end
    AimbotState.FOVCircle:Remove()
    AimbotState.FOVCircleOutline:Remove()
end)

pcall(StartAimbot)

-- ============= --
-- AUTO TRAINING
-- ============= --
Features.AutoTraining = {
    Active = false, SelectedTraining = nil, StartCounting = 1, Cooldown = 1,
    TrainingTask = nil, UseRemoteEvent = false, SelectedRemote = nil,

    NumberToIndonesianText = function(number)
        local u = {"","Satu","Dua","Tiga","Empat","Lima","Enam","Tujuh","Delapan","Sembilan"}
        local t = {"Sepuluh","Sebelas","Dua Belas","Tiga Belas","Empat Belas","Lima Belas","Enam Belas","Tujuh Belas","Delapan Belas","Sembilan Belas"}
        local d = {"","","Dua Puluh","Tiga Puluh","Empat Puluh","Lima Puluh","Enam Puluh","Tujuh Puluh","Delapan Puluh","Sembilan Puluh"}
        if number < 1 or number > 300 then return tostring(number) end
        if number < 10 then return u[number]
        elseif number < 20 then return t[number-9]
        elseif number < 100 then
            local ten = math.floor(number/10); local unit = number % 10
            return unit == 0 and d[ten] or d[ten].." "..u[unit]
        else
            local h = math.floor(number/100); local r = number % 100
            local prefix = h == 1 and "Seratus" or u[h].." Ratus"
            return r == 0 and prefix or prefix.." "..Features.AutoTraining.NumberToIndonesianText(r)
        end
    end,

    CreateTrainingText = function(number, trainingType)
        local numText = Features.AutoTraining.NumberToIndonesianText(number)
        if trainingType == "GJS" then return numText .. "."
        elseif trainingType == "HJS" then
            local clean = string.gsub(numText, " ", "")
            local letters = ""
            for i = 1, #clean do letters = letters .. clean:sub(i,i):upper() .. " " end
            return letters:sub(1,-2) .. " " .. numText:upper()
        else return numText:upper() end
    end,

    SendChatMessage = function(message)
        local ok = pcall(function()
            local channel = Services.TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if channel then channel:SendAsync(message) end
        end)
        if not ok then
            pcall(function()
                local ce = Services.ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                if ce then local sm = ce:FindFirstChild("SayMessageRequest"); if sm then sm:FireServer(message, "All") end end
            end)
        end
    end,

    Toggle = function(state)
        if state then
            if Features.AutoTraining.Active then return end
            if not Features.AutoTraining.SelectedTraining then
                Utils.Alert("Error", "alert-circle", "Select training type first!"); return
            end
            Features.AutoTraining.Active = true
            Utils.Alert("Training", "check", "Auto Training started!")

            Features.AutoTraining.TrainingTask = task.spawn(function()
                local num = Features.AutoTraining.StartCounting
                while Features.AutoTraining.Active and num <= 300 and _G.HexyraRunning do
                    local text = Features.AutoTraining.CreateTrainingText(num, Features.AutoTraining.SelectedTraining)

                    if Features.AutoTraining.UseRemoteEvent and Features.AutoTraining.SelectedRemote then
                        local remote = Utils.FindRemoteByPath(Features.AutoTraining.SelectedRemote)
                        if remote and remote:IsA("RemoteEvent") then
                            pcall(function() remote:FireServer(text) end)
                        end
                    else
                        if Features.AutoTraining.SelectedTraining == "HJS" then
                            local parts = string.split(text, " ")
                            for i, part in ipairs(parts) do
                                Features.AutoTraining.SendChatMessage(part)
                                if i < #parts then task.wait(0.3) end
                            end
                        else
                            Features.AutoTraining.SendChatMessage(text)
                        end
                    end

                    task.wait(Features.AutoTraining.Cooldown)
                    num = num + 1
                end
                if Features.AutoTraining.Active then
                    Utils.Alert("Training", "check", "Training finished!")
                    Features.AutoTraining.Active = false
                end
            end)
        else
            Features.AutoTraining.Active = false
            if Features.AutoTraining.TrainingTask then
                pcall(function() task.cancel(Features.AutoTraining.TrainingTask) end)
                Features.AutoTraining.TrainingTask = nil
            end
            Utils.Alert("Training", "check", "Training stopped!")
        end
    end
}
AddCleanup(function() Features.AutoTraining.Active = false end)

-- ============= --
-- DEVICE SPOOFER
-- ============= --
Features.DeviceSpoofer = {
    OriginalValues = {},
    Spoofed = false,

    GetDeviceInfo = function()
        local info = {}
        pcall(function() info.Platform = Services.UserInputService:GetPlatform().Name end)
        pcall(function() info.DeviceType = (Services.UserInputService.TouchEnabled and "Mobile" or Services.UserInputService.KeyboardEnabled and "PC" or "Console") end)
        pcall(function() info.ScreenSize = tostring(workspace.CurrentCamera.ViewportSize) end)
        pcall(function()
            if gethwid then info.HWID = gethwid()
            elseif getexecutorname then info.Executor = getexecutorname()
            end
        end)
        pcall(function() info.PlaceId = tostring(game.PlaceId) end)
        pcall(function() info.JobId = game.JobId end)
        pcall(function() info.UserId = tostring(LocalPlayer.UserId) end)
        pcall(function()
            if getconnections then info.Connections = "Available" else info.Connections = "N/A" end
        end)
        return info
    end,

    SpoofHWID = function()
        local ok = pcall(function()
            if sethwid then
                local fakeID = ""
                for i = 1, 32 do
                    fakeID = fakeID .. string.char(math.random(65, 90))
                end
                sethwid(fakeID)
                Utils.Alert("Spoofer", "shield", "HWID spoofed!")
            else
                Utils.Alert("Spoofer", "alert-circle", "sethwid not supported by your executor")
            end
        end)
        if not ok then Utils.Alert("Spoofer", "alert-circle", "HWID spoof failed") end
    end,

    SpoofIdentity = function()
        pcall(function()
            if setidentity then setidentity(8); Utils.Alert("Spoofer", "shield", "Identity set to 8")
            elseif setthreadidentity then setthreadidentity(8); Utils.Alert("Spoofer", "shield", "Thread identity set to 8")
            else Utils.Alert("Spoofer", "alert-circle", "Identity spoof not supported") end
        end)
    end,

    GenerateFingerprint = function()
        local fp = {}
        for i = 1, 64 do fp[i] = string.format("%02X", math.random(0, 255)) end
        local result = table.concat(fp, "")
        Utils.CopyToClipboard(result)
        Utils.Alert("Spoofer", "fingerprint", "Fingerprint generated & copied!")
        return result
    end
}

-- ============= --
-- BLATANT BOOMER (REMOTE SPAM)
-- ============= --
Features.BlatantBoomer = {
    Active = false,
    SelectedRemotes = {},
    SpamCount = 100,
    Delay = 0.1,
    Stats = { Success = 0, Failed = 0, NoFeedback = 0, Total = 0 },
    Task = nil,
    AllRemotes = {},

    ScanRemotes = function()
        Features.BlatantBoomer.AllRemotes = {}
        local function scan(parent, path)
            pcall(function()
                for _, child in ipairs(parent:GetChildren()) do
                    if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                        table.insert(Features.BlatantBoomer.AllRemotes, {
                            Name = child.Name,
                            Path = path .. "/" .. child.Name,
                            Type = child:IsA("RemoteEvent") and "RE" or "RF",
                            Instance = child
                        })
                    end
                    if #child:GetChildren() > 0 then
                        pcall(function() scan(child, path .. "/" .. child.Name) end)
                    end
                end
            end)
        end
        pcall(function() scan(Services.ReplicatedStorage, "ReplicatedStorage") end)
        pcall(function() scan(workspace, "Workspace") end)
        pcall(function() scan(game:GetService("Players"), "Players") end)

        local names = {}
        for _, r in ipairs(Features.BlatantBoomer.AllRemotes) do
            table.insert(names, "[" .. r.Type .. "] " .. r.Path)
        end
        Utils.Alert("Boomer", "radio", "Found " .. #names .. " remotes")
        return names
    end,

    SpamSelected = function()
        if Features.BlatantBoomer.Active then Utils.Alert("Boomer", "info", "Already running"); return end
        if #Features.BlatantBoomer.SelectedRemotes == 0 then
            Utils.Alert("Boomer", "alert-circle", "No remotes selected!"); return
        end
        Features.BlatantBoomer.Active = true
        Features.BlatantBoomer.Stats = { Success = 0, Failed = 0, NoFeedback = 0, Total = 0 }

        Features.BlatantBoomer.Task = task.spawn(function()
            for i = 1, Features.BlatantBoomer.SpamCount do
                if not Features.BlatantBoomer.Active or not _G.HexyraRunning then break end
                for _, remotePath in ipairs(Features.BlatantBoomer.SelectedRemotes) do
                    if not Features.BlatantBoomer.Active then break end
                    local remote = nil
                    for _, r in ipairs(Features.BlatantBoomer.AllRemotes) do
                        if ("[" .. r.Type .. "] " .. r.Path) == remotePath then
                            remote = r; break
                        end
                    end
                    if remote and remote.Instance then
                        Features.BlatantBoomer.Stats.Total = Features.BlatantBoomer.Stats.Total + 1
                        local ok, result = pcall(function()
                            if remote.Type == "RE" then
                                remote.Instance:FireServer()
                                return "fired"
                            else
                                return remote.Instance:InvokeServer()
                            end
                        end)
                        if ok then
                            if result then
                                Features.BlatantBoomer.Stats.Success = Features.BlatantBoomer.Stats.Success + 1
                            else
                                Features.BlatantBoomer.Stats.NoFeedback = Features.BlatantBoomer.Stats.NoFeedback + 1
                            end
                        else
                            Features.BlatantBoomer.Stats.Failed = Features.BlatantBoomer.Stats.Failed + 1
                        end
                    end
                    task.wait(Features.BlatantBoomer.Delay)
                end
            end
            Features.BlatantBoomer.Active = false
            local s = Features.BlatantBoomer.Stats
            Utils.Alert("Boomer", "check", string.format("Done! S:%d F:%d NF:%d T:%d", s.Success, s.Failed, s.NoFeedback, s.Total))
        end)
    end,

    SpamAll = function()
        if Features.BlatantBoomer.Active then Utils.Alert("Boomer", "info", "Already running"); return end
        if #Features.BlatantBoomer.AllRemotes == 0 then
            Features.BlatantBoomer.ScanRemotes()
        end
        local allNames = {}
        for _, r in ipairs(Features.BlatantBoomer.AllRemotes) do
            table.insert(allNames, "[" .. r.Type .. "] " .. r.Path)
        end
        Features.BlatantBoomer.SelectedRemotes = allNames
        Features.BlatantBoomer.SpamSelected()
    end,

    Stop = function()
        Features.BlatantBoomer.Active = false
        if Features.BlatantBoomer.Task then
            pcall(function() task.cancel(Features.BlatantBoomer.Task) end)
        end
        Utils.Alert("Boomer", "octagon", "Spam stopped")
    end,

    GetStats = function()
        local s = Features.BlatantBoomer.Stats
        return string.format("Success: %d\nFailed: %d\nNo Feedback: %d\nTotal: %d", s.Success, s.Failed, s.NoFeedback, s.Total)
    end
}
AddCleanup(function() Features.BlatantBoomer.Active = false end)

-- ============= --
-- CHECK PLAYER
-- ============= --
Features.CheckPlayer = {
    GetInfo = function(playerName)
        local target
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p.Name == playerName then target = p; break end
        end
        if not target then return "Player not found" end

        local info = {}
        table.insert(info, "=== PLAYER INFO ===")
        table.insert(info, "Username: " .. target.Name)
        table.insert(info, "DisplayName: " .. target.DisplayName)
        table.insert(info, "UserId: " .. tostring(target.UserId))

        pcall(function() table.insert(info, "Account Age: " .. tostring(target.AccountAge) .. " days") end)
        pcall(function()
            local created = os.date("%Y-%m-%d", os.time() - (target.AccountAge * 86400))
            table.insert(info, "Created: ~" .. created)
        end)
        pcall(function() table.insert(info, "Team: " .. tostring(target.Team and target.Team.Name or "None")) end)
        pcall(function() table.insert(info, "TeamColor: " .. tostring(target.TeamColor)) end)

        pcall(function()
            if target:IsFriendsWith(LocalPlayer.UserId) then
                table.insert(info, "Friends: YES (with you)")
            else
                table.insert(info, "Friends: NO")
            end
        end)

        pcall(function()
            local premium = target.MembershipType == Enum.MembershipType.Premium
            table.insert(info, "Premium: " .. (premium and "YES" or "NO"))
        end)

        table.insert(info, "")
        table.insert(info, "=== CHARACTER INFO ===")

        local char = target.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                table.insert(info, "Health: " .. string.format("%.1f / %.1f", hum.Health, hum.MaxHealth))
                table.insert(info, "WalkSpeed: " .. tostring(hum.WalkSpeed))
                table.insert(info, "JumpPower: " .. tostring(hum.JumpPower))
                table.insert(info, "JumpHeight: " .. tostring(hum.JumpHeight))
                table.insert(info, "HipHeight: " .. tostring(hum.HipHeight))
                local rigType = char:FindFirstChild("UpperTorso") and "R15" or "R6"
                table.insert(info, "Rig Type: " .. rigType)
            end

            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                table.insert(info, "Position: " .. string.format("%.1f, %.1f, %.1f", root.Position.X, root.Position.Y, root.Position.Z))
                local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if localRoot then
                    table.insert(info, "Distance: " .. string.format("%.1f studs", (localRoot.Position - root.Position).Magnitude))
                end
                table.insert(info, "Velocity: " .. string.format("%.1f", root.Velocity.Magnitude))
            end

            -- Device detection
            pcall(function()
                local head = char:FindFirstChild("Head")
                if head then
                    local camCF = workspace.CurrentCamera.CFrame
                    table.insert(info, "Camera Distance: " .. string.format("%.1f", (camCF.Position - head.Position).Magnitude))
                end
            end)
        else
            table.insert(info, "Character: NOT LOADED")
        end

        table.insert(info, "")
        table.insert(info, "=== BACKPACK ===")
        pcall(function()
            local bp = target:FindFirstChild("Backpack")
            if bp then
                local tools = bp:GetChildren()
                if #tools > 0 then
                    for _, tool in ipairs(tools) do
                        table.insert(info, "  [BP] " .. tool.Name)
                    end
                else
                    table.insert(info, "  Backpack: Empty")
                end
            end
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        table.insert(info, "  [HELD] " .. tool.Name)
                    end
                end
            end
        end)

        -- Session time estimate
        pcall(function()
            table.insert(info, "")
            table.insert(info, "=== SESSION ===")
            table.insert(info, "Server Time: " .. string.format("%.0f seconds", workspace.DistributedGameTime))
        end)

        return table.concat(info, "\n")
    end
}

-- ============= --
-- SPAM DONATE
-- ============= --
Features.SpamDonate = {
    Active = false,
    Mode = "Calm",
    Task = nil,
    TargetPlayer = nil,
    SpamGamepass = true,
    SpamDevProduct = true,

    ScanDonationRemotes = function()
        local results = {}
        local function scan(parent, path)
            pcall(function()
                for _, child in ipairs(parent:GetChildren()) do
                    local n = child.Name:lower()
                    if child:IsA("RemoteEvent") and (n:find("donat") or n:find("purchase") or n:find("buy") or n:find("gamepass") or n:find("product") or n:find("pay") or n:find("robux")) then
                        table.insert(results, { Name = child.Name, Path = path.."/"..child.Name, Instance = child })
                    end
                    if #child:GetChildren() > 0 then pcall(function() scan(child, path.."/"..child.Name) end) end
                end
            end)
        end
        pcall(function() scan(Services.ReplicatedStorage, "ReplicatedStorage") end)
        pcall(function() scan(workspace, "Workspace") end)
        return results
    end,

    PromptSelf = function(productId, productType)
        pcall(function()
            if productType == "GamePass" then
                Services.MarketplaceService:PromptGamePassPurchase(LocalPlayer, productId)
            else
                Services.MarketplaceService:PromptProductPurchase(LocalPlayer, productId)
            end
        end)
    end,

    SpamDonationRemotes = function()
        if Features.SpamDonate.Active then return end
        Features.SpamDonate.Active = true
        local remotes = Features.SpamDonate.ScanDonationRemotes()

        if #remotes == 0 then
            Utils.Alert("Donate", "alert-circle", "No donation remotes found")
            Features.SpamDonate.Active = false
            return
        end

        Utils.Alert("Donate", "dollar-sign", "Found " .. #remotes .. " donation remotes, spamming...")

        Features.SpamDonate.Task = task.spawn(function()
            local delay = Features.SpamDonate.Mode == "Calm" and 1 or 0.1
            local count = Features.SpamDonate.Mode == "Calm" and 10 or 100

            for i = 1, count do
                if not Features.SpamDonate.Active or not _G.HexyraRunning then break end
                for _, remote in ipairs(remotes) do
                    pcall(function()
                        remote.Instance:FireServer(Features.SpamDonate.TargetPlayer or LocalPlayer.Name, math.random(1, 999999))
                    end)
                    pcall(function()
                        remote.Instance:FireServer()
                    end)
                end
                task.wait(delay)
            end
            Features.SpamDonate.Active = false
            Utils.Alert("Donate", "check", "Donation spam finished")
        end)
    end,

    Stop = function()
        Features.SpamDonate.Active = false
        if Features.SpamDonate.Task then pcall(function() task.cancel(Features.SpamDonate.Task) end) end
        Utils.Alert("Donate", "octagon", "Donation spam stopped")
    end
}
AddCleanup(function() Features.SpamDonate.Active = false end)

-- ============= --
-- ANTI DETECTION
-- ============= --
Features.AntiDetect = {
    AntiAFK = false,
    Connection = nil,

    ToggleAntiAFK = function(state)
        Features.AntiDetect.AntiAFK = state
        if state then
            local vu = game:GetService("VirtualUser")
            Features.AntiDetect.Connection = LocalPlayer.Idled:Connect(function()
                vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
            Utils.Alert("Anti-AFK", "shield", "Anti-AFK ON")
        else
            if Features.AntiDetect.Connection then Features.AntiDetect.Connection:Disconnect() end
            Utils.Alert("Anti-AFK", "shield-off", "Anti-AFK OFF")
        end
    end
}
AddCleanup(function()
    if Features.AntiDetect.Connection then Features.AntiDetect.Connection:Disconnect() end
end)

-- ============= --
-- FULLBRIGHT
-- ============= --
Features.Fullbright = {
    Active = false,
    OriginalValues = {},

    Toggle = function(state)
        Features.Fullbright.Active = state
        if state then
            Features.Fullbright.OriginalValues.Ambient = Services.Lighting.Ambient
            Features.Fullbright.OriginalValues.OutdoorAmbient = Services.Lighting.OutdoorAmbient
            Features.Fullbright.OriginalValues.Brightness = Services.Lighting.Brightness
            Features.Fullbright.OriginalValues.FogEnd = Services.Lighting.FogEnd
            Services.Lighting.Ambient = Color3.new(1,1,1)
            Services.Lighting.OutdoorAmbient = Color3.new(1,1,1)
            Services.Lighting.Brightness = 2
            Services.Lighting.FogEnd = 1e9
            for _, v in ipairs(Services.Lighting:GetDescendants()) do
                if v:IsA("Atmosphere") then v.Density = 0
                elseif v:IsA("BloomEffect") then v.Enabled = false
                elseif v:IsA("BlurEffect") then v.Enabled = false
                end
            end
            Utils.Alert("Fullbright", "sun", "Fullbright ON")
        else
            local o = Features.Fullbright.OriginalValues
            if o.Ambient then Services.Lighting.Ambient = o.Ambient end
            if o.OutdoorAmbient then Services.Lighting.OutdoorAmbient = o.OutdoorAmbient end
            if o.Brightness then Services.Lighting.Brightness = o.Brightness end
            if o.FogEnd then Services.Lighting.FogEnd = o.FogEnd end
            Utils.Alert("Fullbright", "moon", "Fullbright OFF")
        end
    end
}

-- ===================== --
-- UI BUILDING
-- ===================== --
Utils.ShowPopup("Welcome To Hexyra", "rbxassetid://123881160135279",
    "Selamat datang! Terimakasih telah mencoba " .. SCRIPT_VERSION .. "\nNow with Drawing ESP, Silent Aim & more!")

Utils.Alert("Loaded", "rbxassetid://123881160135279",
    "Hexyra " .. SCRIPT_VERSION .. " Loaded Successfully!")

local Window = WindUI:CreateWindow({
    Title = "Hexyra",
    Icon = "rbxassetid://123881160135279",
    Author = "by Hexyra Studios",
    Folder = "MySuperHub",
    Size = UDim2.fromOffset(950, 950),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    BackgroundImageTransparency = 1,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    User = { Enabled = true, Anonymous = false }
})
Window:Tag({ Title = "Version: "..SCRIPT_VERSION, Icon = "github", Color = Color3.fromHex("#30ff6a"), Radius = 13 })
Window:Tag({ Title = "Universal Script for All Games", Icon = "pin", Color = Color3.fromHex("#5F03F6"), Radius = 13 })
Window:Tag({ Title = "discord.gg/Hexyra -- Not a invite :3", Icon = "layout-panel-left", Color = Color3.fromHex("#4303F6"), Radius = 13 })
WindUI:SetTheme("Hexyra")
Window:SetIconSize(48)
Window:SetToggleKey(Enum.KeyCode.LeftControl)
Window:EditOpenButton({
    Title = "Hexyra", Icon = "handphone", CornerRadius = UDim.new(0,16), StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    OnlyMobile = true, Enabled = true, Draggable = true
})

-- ============ MAIN TAB ============ --
local MainTab = Window:Tab({ Title = "| Main", Icon = "crown", Locked = false })

MainTab:Paragraph({
    Title = "WARNING - READ BEFORE USING",
    Desc = "All features are use at your own risk. We are not responsible for any bans or issues.",
    Color = Colors.Maroon, Image = "rbxassetid://123881160135279", ImageSize = 30
})

local MovementSection = MainTab:Section({ Title = "Movement Section", Opened = true })

MovementSection:Toggle({
    Title = "✨ | Speed Boost", Desc = "CFrame speed (silent, less detectable)", Icon = "zap",
    Value = false, Callback = Features.Movement.Toggle
})

MovementSection:Slider({
    Title = "✨ | Speed Value", Desc = "Movement speed multiplier", Step = 1,
    Value = { Min = 10, Max = 200, Default = 50 },
    Callback = function(v) Features.Movement.SetSpeed(v) end
})

MovementSection:Toggle({
    Title = "✨ | NoClip", Desc = "Walk through walls", Icon = "ghost",
    Value = false, Callback = Features.NoClip.Toggle
})

MovementSection:Toggle({
    Title = "✨ | Infinite Jump", Desc = "Jump without limits", Icon = "wind",
    Value = false, Callback = Features.Jump.Toggle
})

MovementSection:Toggle({
    Title = "✨ | Fly", Desc = "WASD to fly, Space up, Shift down", Icon = "navigation",
    Value = false, Callback = Features.Fly.Toggle
})

MovementSection:Slider({
    Title = "✨ | Fly Speed", Desc = "Flying speed", Step = 1,
    Value = { Min = 10, Max = 300, Default = 50 },
    Callback = function(v) Features.Fly.Speed = v end
})

local MiscSection = MainTab:Section({ Title = "Miscellaneous", Opened = true })

MiscSection:Toggle({
    Title = "✨ | Anti-AFK", Desc = "Prevent being kicked for inactivity", Icon = "shield",
    Value = false, Callback = Features.AntiDetect.ToggleAntiAFK
})

MiscSection:Toggle({
    Title = "✨ | Fullbright", Desc = "Remove all darkness", Icon = "sun",
    Value = false, Callback = Features.Fullbright.Toggle
})

-- ============ COMBAT TAB ============ --
local CombatTab = Window:Tab({ Title = "| Combat", Icon = "crosshair", Locked = false })

local AimbotSection = CombatTab:Section({ Title = "Aimbot Configuration", Opened = true })

AimbotSection:Toggle({
    Title = "🔫 | Aimbot", Desc = "Enable aimbot", Icon = "crosshair",
    Value = false, Callback = Features.Aimbot.Toggle
})

AimbotSection:Toggle({
    Title = "🔫 | Silent Aim", Desc = "Aim redirects without camera movement (requires executor support)", Icon = "eye-off",
    Value = false, Callback = Features.Aimbot.ToggleSilent
})

AimbotSection:Toggle({
    Title = "🔫 | FOV Circle", Desc = "Show FOV circle", Icon = "circle",
    Value = false, Callback = function(s) Features.Aimbot.ToggleFOV(s) end
})

AimbotSection:Slider({
    Title = "🔫 | FOV Size", Step = 1,
    Value = { Min = 10, Max = 500, Default = 90 },
    Callback = function(v) Features.Aimbot.SetFOVSize(v) end
})

AimbotSection:Dropdown({
    Title = "🔫 | Target Part", Values = {"Head", "Torso", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
    Value = "Head", Multi = false, AllowNone = false,
    Callback = function(o) Features.Aimbot.SetTargetPart(o) end
})

AimbotSection:Slider({
    Title = "🔫 | Smoothing", Desc = "Lower = Faster snap (more detectable)", Step = 0.5,
    Value = { Min = 1, Max = 20, Default = 5 },
    Callback = function(v) Features.Aimbot.SetSmoothing(v) end
})

AimbotSection:Slider({
    Title = "🔫 | Prediction", Desc = "Predict target movement (0 = off)", Step = 1,
    Value = { Min = 0, Max = 50, Default = 0 },
    Callback = function(v) Features.Aimbot.SetPrediction(v) end
})

local AimbotAdvanced = CombatTab:Section({ Title = "Advanced Settings", Opened = true })

AimbotAdvanced:Toggle({
    Title = "🔫 | Team Check", Desc = "Ignore teammates", Icon = "users",
    Value = false, Callback = function(s) AimbotConfig.TeamCheck = s end
})

AimbotAdvanced:Toggle({
    Title = "🔫 | Wall Check", Desc = "Only target visible players", Icon = "eye-off",
    Value = false, Callback = function(s) AimbotConfig.WallCheck = s end
})

AimbotAdvanced:Toggle({
    Title = "🔫 | Toggle Mode", Desc = "Click to toggle lock instead of hold", Icon = "toggle-right",
    Value = false, Callback = function(s) AimbotConfig.Toggle = s end
})

AimbotAdvanced:Dropdown({
    Title = "🔫 | Lock Mode", Values = {"MouseMove", "CFrame"},
    Value = "MouseMove", Multi = false, AllowNone = false,
    Callback = function(o) AimbotConfig.LockMode = o end
})

AimbotAdvanced:Slider({
    Title = "🔫 | Max Distance", Step = 50,
    Value = { Min = 100, Max = 3000, Default = 1000 },
    Callback = function(v) AimbotConfig.MaxDistance = v end
})

-- ============ VISUAL TAB ============ --
local VisualTab = Window:Tab({ Title = "| Visual", Icon = "eye", Locked = false })

local ESPSection = VisualTab:Section({ Title = "ESP (Drawing API)", Opened = true })

ESPSection:Toggle({
    Title = "👑 | Enable ESP", Desc = "Drawing-based ESP (auto cleanup on close)", Icon = "eye",
    Value = false, Callback = function(s) Features.ESP.Toggle(s) end
})

ESPSection:Toggle({
    Title = "👑 | Box ESP", Icon = "square",
    Value = ESPConfig.BoxEnabled, Callback = function(s) ESPConfig.BoxEnabled = s end
})

ESPSection:Toggle({
    Title = "👑 | Box Outline", Icon = "square",
    Value = ESPConfig.BoxOutline, Callback = function(s) ESPConfig.BoxOutline = s end
})

ESPSection:Toggle({
    Title = "👑 | Name ESP", Icon = "tag",
    Value = ESPConfig.NameEnabled, Callback = function(s) ESPConfig.NameEnabled = s end
})

ESPSection:Toggle({
    Title = "👑 | Health Bar", Icon = "heart",
    Value = ESPConfig.HealthBarEnabled, Callback = function(s) ESPConfig.HealthBarEnabled = s end
})

ESPSection:Toggle({
    Title = "👑 | Health Text", Icon = "heart",
    Value = ESPConfig.HealthTextEnabled, Callback = function(s) ESPConfig.HealthTextEnabled = s end
})

ESPSection:Toggle({
    Title = "👑 | Distance", Icon = "ruler",
    Value = ESPConfig.DistanceEnabled, Callback = function(s) ESPConfig.DistanceEnabled = s end
})

ESPSection:Toggle({
    Title = "👑 | Tracers", Icon = "minus",
    Value = ESPConfig.TracerEnabled, Callback = function(s) ESPConfig.TracerEnabled = s end
})

ESPSection:Dropdown({
    Title = "👑 | Tracer Origin", Values = {"Bottom", "Top", "Center"},
    Value = "Bottom", Callback = function(o) ESPConfig.TracerOrigin = o end
})

ESPSection:Toggle({
    Title = "👑 | Skeleton", Desc = "Draw bone connections", Icon = "activity",
    Value = ESPConfig.SkeletonEnabled, Callback = function(s) ESPConfig.SkeletonEnabled = s end
})

ESPSection:Toggle({
    Title = "👑 | Charms", Desc = "Body part outlines", Icon = "box",
    Value = ESPConfig.CharmsEnabled, Callback = function(s) ESPConfig.CharmsEnabled = s end
})

ESPSection:Toggle({
    Title = "👑 | Charms Filled", Desc = "Fill charms squares",
    Value = ESPConfig.CharmsFilled, Callback = function(s) ESPConfig.CharmsFilled = s end
})

ESPSection:Toggle({
    Title = "👑 | Team Check", Desc = "Hide teammates",
    Value = ESPConfig.TeamCheck, Callback = function(s) ESPConfig.TeamCheck = s end
})

ESPSection:Toggle({
    Title = "👑 | Use Team Colors", Desc = "Color by team",
    Value = ESPConfig.UseTeamColors, Callback = function(s) ESPConfig.UseTeamColors = s end
})

local ESPColorSection = VisualTab:Section({ Title = "ESP Colors & Values", Opened = true })

ESPColorSection:Colorpicker({
    Title = "👑 | Box Color", Default = ESPConfig.BoxColor,
    Callback = function(c) ESPConfig.BoxColor = c end
})

ESPColorSection:Colorpicker({
    Title = "👑 | Name Color", Default = ESPConfig.NameColor,
    Callback = function(c) ESPConfig.NameColor = c end
})

ESPColorSection:Colorpicker({
    Title = "👑 | Tracer Color", Default = ESPConfig.TracerColor,
    Callback = function(c) ESPConfig.TracerColor = c end
})

ESPColorSection:Colorpicker({
    Title = "👑 | Skeleton Color", Default = ESPConfig.SkeletonColor,
    Callback = function(c) ESPConfig.SkeletonColor = c end
})

ESPColorSection:Colorpicker({
    Title = "👑 | Charms Color", Default = ESPConfig.CharmsColor,
    Callback = function(c) ESPConfig.CharmsColor = c end
})

ESPColorSection:Colorpicker({
    Title = "👑 | Friend Color", Default = _G.FriendColor,
    Callback = function(c) _G.FriendColor = c end
})

ESPColorSection:Colorpicker({
    Title = "👑 | Enemy Color", Default = _G.EnemyColor,
    Callback = function(c) _G.EnemyColor = c end
})

ESPColorSection:Slider({
    Title = "👑 | Max Distance", Step = 50,
    Value = { Min = 100, Max = 5000, Default = 1000 },
    Callback = function(v) ESPConfig.MaxDistance = v end
})

ESPColorSection:Slider({
    Title = "👑 | Min Health Threshold", Desc = "Hide players below this HP (0=show all)", Step = 1,
    Value = { Min = 0, Max = 100, Default = 0 },
    Callback = function(v) ESPConfig.MinHealthThreshold = v end
})

ESPColorSection:Slider({
    Title = "👑 | Name Size", Step = 1,
    Value = { Min = 10, Max = 24, Default = 14 },
    Callback = function(v) ESPConfig.NameSize = v end
})

ESPColorSection:Slider({
    Title = "👑 | Box Thickness", Step = 1,
    Value = { Min = 1, Max = 5, Default = 1 },
    Callback = function(v) ESPConfig.BoxThickness = v end
})

ESPColorSection:Slider({
    Title = "👑 | Skeleton Thickness", Step = 1,
    Value = { Min = 1, Max = 5, Default = 1 },
    Callback = function(v) ESPConfig.SkeletonThickness = v end
})

ESPColorSection:Slider({
    Title = "👑 | Tracer Thickness", Step = 1,
    Value = { Min = 1, Max = 5, Default = 1 },
    Callback = function(v) ESPConfig.TracerThickness = v end
})

ESPColorSection:Slider({
    Title = "👑 | Charms Transparency", Step = 0.1,
    Value = { Min = 0, Max = 1, Default = 0.5 },
    Callback = function(v) ESPConfig.CharmsTransparency = v end
})

ESPColorSection:Button({
    Title = "👑 | Clean ESP", Desc = "Remove all ESP objects",
    Callback = function() Features.ESP.Cleanup(); Features.ESP.Toggle(ESPConfig.Enabled) end
})

-- Spectate
local SpectateSection = VisualTab:Section({ Title = "Spectate Player", Opened = true })

AllDropdowns.SpectatePlayer = SpectateSection:Dropdown({
    Title = "👑 | Select Player", Values = Utils.GetPlayerList(),
    Value = nil, Multi = false, AllowNone = true,
    Callback = function(o) end
})

SpectateSection:Toggle({
    Title = "👑 | Spectate", Icon = "eye", Value = false,
    Callback = function(state)
        if state then
            local sel = AllDropdowns.SpectatePlayer and AllDropdowns.SpectatePlayer.Value
            if sel then Features.Spectate.Toggle(true, sel)
            else Utils.Alert("Error", "alert-circle", "Select a player first!") end
        else Features.Spectate.Toggle(false) end
    end
})

-- Game Time
local GameTimeSection = VisualTab:Section({ Title = "Game Time", Opened = true })

GameTimeSection:Dropdown({
    Title = "👑 | Time", Values = {"Morning","Afternoon","Evening","Night","Midnight","Early morning"},
    Value = nil, Callback = function(o) Features.GameTime.Select(o) end
})

GameTimeSection:Button({
    Title = "👑 | Set Time", Callback = function() Features.GameTime.Change() end
})

-- Freecam (Fixed)
local FreecamSection = VisualTab:Section({ Title = "Freecam (Fixed)", Opened = true })

FreecamSection:Toggle({
    Title = "👑 | Freecam", Desc = "WASD Move | E/Q Up/Down | Shift Speed | ESC Exit", Icon = "camera",
    Value = false, Callback = function(s) Features.Freecam.Toggle(s) end
})

FreecamSection:Slider({
    Title = "👑 | Normal Speed", Step = 1,
    Value = { Min = 1, Max = 100, Default = 10 },
    Callback = function(v) Features.Freecam.Speed = v end
})

FreecamSection:Slider({
    Title = "👑 | Fast Speed", Step = 5,
    Value = { Min = 10, Max = 500, Default = 25 },
    Callback = function(v) 
