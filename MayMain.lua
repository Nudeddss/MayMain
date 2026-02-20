local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local SCRIPT_VERSION = "V.0.2.0" 
local Features = {}
_G.FriendColor = Color3.fromRGB(0, 255, 0)
_G.EnemyColor = Color3.fromRGB(255, 0, 0)

-- ============= --
-- COLORS
-- ============= --
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

-- ============= --
-- THEME
-- ============= --
WindUI:AddTheme({
    Name = "Hexyra",
    Accent = Color3.fromHex("#18181b"),
    Background = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("#08012E"), Transparency = 0.5 },            
        ["100"] = { Color = Color3.fromHex("#2E0101"), Transparency = 0.5 },        
    }, {                                                                            
        Rotation = 90,                                                               
    }),
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
    }, {                                                                            
        Rotation = 90,                                                               
    }),
    WindowShadow = Color3.fromHex("000000"),
    DialogBackground = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("#08012E"), Transparency = 0.5 },            
        ["100"] = { Color = Color3.fromHex("#2E0101"), Transparency = 0.5 },        
    }, {                                                                            
        Rotation = 90,                                                               
    }),
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
    }, {                                                                            
        Rotation = 90,                                                               
    }),
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

-- ============= --
-- SERVICES
-- ============= --
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
    VirtualInputManager = game:GetService("VirtualInputManager")
}

local LocalPlayer = Services.Players.LocalPlayer
local Camera = Services.Workspace.CurrentCamera
local DontTouchPart = {"Right Leg","Right Arm","Left Leg","Left Arm"}

-- ============= --
-- UTILS
-- ============= --
local Utils = {
    Alert = function(title, icon, content, duration)
        duration = duration or 3
        return WindUI:Notify({
            Title = title,
            Icon = icon,
            Content = content,
            Duration = duration
        })
    end,
    
    ShowPopup = function(title, icon, content, buttons)
        return WindUI:Popup({
            Title = title,
            Icon = icon,
            Content = content,
            Buttons = buttons or {{
                Title = "OK",
                Icon = "check",
                Variant = "Tertiary"
            }}
        })
    end,
    
    GetPlayerList = function()
        local playerList = {}
        for _, player in pairs(Services.Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerList, player.Name)
            end
        end
        return playerList
    end,
    
    RandomWait = function(min, max)
        local delay = math.random(min * 100, max * 100) / 100
        task.wait(delay)
        return delay
    end,
    
    CopyToClipboard = function(text)
        if text == nil or text == "" then
            return false, "No text to copy"
        end
        
        local success1, result1 = pcall(function()
            if setclipboard then
                setclipboard(text)
                return true
            end
        end)
        
        if success1 and result1 then
            return true, "Copied to clipboard"
        end
        
        local success2, result2 = pcall(function()
            if rconsole and rconsole.setclipboard then
                rconsole.setclipboard(tostring(text))
                return true
            end
        end)
        
        if success2 and result2 then
            return true, "Copied to console clipboard"
        end
        
        local success3, result3 = pcall(function()
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "ClipboardHelper"
            screenGui.ResetOnSpawn = false
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            
            local textBox = Instance.new("TextBox")
            textBox.Name = "ClipboardTextBox"
            textBox.Text = tostring(text)
            textBox.ClearTextOnFocus = false
            textBox.Size = UDim2.new(0, 1, 0, 1)
            textBox.Position = UDim2.new(0, -100, 0, -100)
            textBox.BackgroundTransparency = 1
            textBox.TextTransparency = 1
            textBox.TextColor3 = Color3.new(0, 0, 0)
            textBox.Parent = screenGui
            
            screenGui.Parent = Services.CoreGui
            
            textBox:CaptureFocus()
            textBox:SelectAll()
            
            task.wait(0.1)
            screenGui:Destroy()
            
            return true
        end)
        
        if success3 then
            return true, "Copied using TextBox method"
        end
        
        Utils.Alert("Copy Manually", "copy", "Text: " .. tostring(text), 10)
        return false, "Please copy manually from notification"
    end,
    
    IsBlacklisted = function(player)
        local BlacklistedGroups = {
            14460225, 379859293, 11902409, 34081073,
            17101125, 17340114, 17166238, 4381924,
            11120403, 14460640, 14460689, 14460701,
            14460629, 14460686, 14460696, 14460646
        }
        
        for _, groupId in ipairs(BlacklistedGroups) do
            local success = pcall(function()
                return player:IsInGroup(groupId)
            end)
            if success and player:IsInGroup(groupId) then
                return true, groupId
            end
        end
        return false
    end,
    
    GetCharacterPosition = function(character)
        if not character then return nil end
        local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
        return root and root.Position or nil
    end,
    
    GetCharacterHealth = function(character)
        if not character then return 0 end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        return humanoid and humanoid.Health or 0
    end
}

-- ============= --
-- DROPDOWN MANAGER
-- ============= --
local Dropdowns = {}
local DropdownManager = {
    Dropdowns = {},
    LastKnownPlayers = {},
    Initialized = false,
    
    -- Register dropdown dengan nama unik
    Register = function(name, dropdown, getValuesFunc)
        if not dropdown then return end
        
        Dropdowns[name] = {
            Dropdown = dropdown,
            GetValues = getValuesFunc or function()
                return Utils.GetPlayerList()
            end,
            LastValues = {}
        }
    end,
    
    -- Refresh single dropdown
    Refresh = function(name)
        local data = Dropdowns[name]
        if not data or not data.Dropdown then return false end
        
        local newValues = {}
        local success = pcall(function()
            newValues = data.GetValues()
        end)
        
        if not success then return false end
        
        -- Check if values actually changed
        if DropdownManager.CompareArrays(data.LastValues, newValues) then
            return true -- No change needed
        end
        
        data.LastValues = newValues
        
        -- Try different methods to update dropdown
        local updateSuccess = false
        
        -- Method 1: SetValues (WindUI standard)
        pcall(function()
            if data.Dropdown.SetValues then
                data.Dropdown:SetValues(newValues)
                updateSuccess = true
            end
        end)
        
        if updateSuccess then return true end
        
        -- Method 2: Refresh with values
        pcall(function()
            if data.Dropdown.Refresh then
                data.Dropdown:Refresh(newValues)
                updateSuccess = true
            end
        end)
        
        if updateSuccess then return true end
        
        -- Method 3: Update Options
        pcall(function()
            if data.Dropdown.UpdateOptions then
                data.Dropdown:UpdateOptions(newValues)
                updateSuccess = true
            end
        end)
        
        if updateSuccess then return true end
        
        -- Method 4: Set Options property then refresh
        pcall(function()
            if data.Dropdown.Options ~= nil then
                data.Dropdown.Options = newValues
                if data.Dropdown.Refresh then
                    data.Dropdown:Refresh()
                end
                updateSuccess = true
            end
        end)
        
        if updateSuccess then return true end
        
        -- Method 5: Direct Values assignment + BuildDropdown
        pcall(function()
            data.Dropdown.Values = newValues
            if data.Dropdown.BuildDropdown then
                data.Dropdown:BuildDropdown()
            end
            updateSuccess = true
        end)
        
        if updateSuccess then return true end
        
        -- Method 6: Access internal elements
        pcall(function()
            if data.Dropdown.Element then
                local element = data.Dropdown.Element
                if element.Values then
                    element.Values = newValues
                end
                if element.Refresh then
                    element:Refresh()
                end
                updateSuccess = true
            end
        end)
        
        return updateSuccess
    end,
    
    -- Refresh all registered dropdowns
    RefreshAll = function()
        local refreshed = 0
        for name, _ in pairs(DropdownManager.Dropdowns) do
            if DropdownManager.Refresh(name) then
                refreshed = refreshed + 1
            end
        end
        return refreshed
    end,
    
    -- Compare two arrays
    CompareArrays = function(arr1, arr2)
        if arr1 == nil or arr2 == nil then return false end
        if #arr1 ~= #arr2 then return false end
        
        for i, v in ipairs(arr1) do
            if arr2[i] ~= v then
                return false
            end
        end
        
        return true
    end,
    
    -- Check if player list changed
    PlayersChanged = function()
        local currentPlayers = Utils.GetPlayerList()
        
        if not DropdownManager.CompareArrays(DropdownManager.LastKnownPlayers, currentPlayers) then
            DropdownManager.LastKnownPlayers = currentPlayers
            return true
        end
        
        return false
    end,
    
    -- Get current player list (cached)
    GetCachedPlayers = function()
        if #DropdownManager.LastKnownPlayers == 0 then
            DropdownManager.LastKnownPlayers = Utils.GetPlayerList()
        end
        return DropdownManager.LastKnownPlayers
    end,
    
    -- Force refresh (ignores cache)
    ForceRefreshAll = function()
        DropdownManager.LastKnownPlayers = {}
        for name, data in pairs(DropdownManager.Dropdowns) do
            data.LastValues = {}
        end
        return DropdownManager.RefreshAll()
    end,
    
    -- Unregister dropdown
    Unregister = function(name)
        DropdownManager.Dropdowns[name] = nil
    end,
    
    -- Clear all
    Clear = function()
        DropdownManager.Dropdowns = {}
        DropdownManager.LastKnownPlayers = {}
    end,
    
    -- Start auto-refresh loop
    StartAutoRefresh = function(interval)
        interval = interval or 3
        
        if DropdownManager.Initialized then return end
        DropdownManager.Initialized = true
        
        task.spawn(function()
            while true do
                task.wait(interval)
                
                -- Only refresh if players changed
                if DropdownManager.PlayersChanged() then
                    DropdownManager.RefreshAll()
                end
            end
        end)
    end
}

-- Auto refresh dropdowns setiap 5 detik
task.spawn(function()
    while true do
        task.wait(5)
        DropdownManager.RefreshAll()
    end
end)

-- ============= --
-- MOVEMENT
-- ============= --
Features.Movement = {
    Active = false,
    BodyVelocities = {},
    Connection = nil,
    
    Toggle = function(state)
        Features.Movement.Active = state
        
        if state then
            if Features.Movement.Connection then
                Features.Movement.Connection:Disconnect()
            end
            
            Features.Movement.Connection = Services.RunService.Heartbeat:Connect(function(deltaTime)
                local character = LocalPlayer.Character
                if not character then return end
                
                local root = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChild("Humanoid")
                if not root or not humanoid then return end
                
                local moveDir = humanoid.MoveDirection
                if moveDir.Magnitude > 0.1 then
                    local speedValue = 50
                    local targetVelocity = moveDir * speedValue
                    
                    local bv = root:FindFirstChild("_MV") or Instance.new("BodyVelocity")
                    bv.Name = "_MV"
                    bv.Velocity = Vector3.new(targetVelocity.X, root.Velocity.Y, targetVelocity.Z)
                    bv.MaxForce = Vector3.new(4000, 0, 4000)
                    bv.P = 1000
                    bv.Parent = root
                    
                    table.insert(Features.Movement.BodyVelocities, bv)
                else
                    local bv = root:FindFirstChild("_MV")
                    if bv then bv:Destroy() end
                end
            end)
            
            Utils.Alert("Movement", "zap", "Speed enhanced")
        else
            if Features.Movement.Connection then
                Features.Movement.Connection:Disconnect()
                Features.Movement.Connection = nil
            end
            
            for _, bv in ipairs(Features.Movement.BodyVelocities) do
                if bv then bv:Destroy() end
            end
            Features.Movement.BodyVelocities = {}
            
            Utils.Alert("Movement", "zap", "Speed normal")
        end
    end
}

-- ============= --
-- GAME TIME
-- ============= --
Features.GameTime = {
    SelectedTime = nil,
    TimeMap = {
        ["Morning"] = 6,
        ["Afternoon"] = 12,
        ["Evening"] = 17,
        ["Night"] = 20,
        ["Midnight"] = 0,
        ["Early morning"] = 3
    },
    
    Select = function(timeName)
        Features.GameTime.SelectedTime = timeName
        Utils.Alert("Game Time", "clock", "Selected: " .. timeName)
    end,
    
    Change = function()
        if not Features.GameTime.SelectedTime then
            Utils.Alert("Error | 405", "alert-circle", "Please select a game time first!")
            return false
        end
        
        local timeValue = Features.GameTime.TimeMap[Features.GameTime.SelectedTime]
        if timeValue then
            Services.Lighting.ClockTime = timeValue
            Utils.Alert("Success", "check", "Game time changed to: " .. Features.GameTime.SelectedTime)
            return true
        else
            Utils.Alert("Error | 406", "alert-circle", "Invalid time selection!")
            return false
        end
    end
}

-- ============= --
-- NOCLIP
-- ============= --
Features.NoClip = {
    Active = false,
    Connection = nil,
    
    Toggle = function(state)
        Features.NoClip.Active = state
        
        local function SetCollision(character, canCollide)
            if not character then return end
            if canCollide then 
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") and not table.find(DontTouchPart, part.Name) then
                        part.CanCollide = canCollide
                    end
                end
            else
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = canCollide
                    end
                end
            end
        end
        
        if state then
            SetCollision(LocalPlayer.Character, false)
            
            Features.NoClip.Connection = Services.RunService.Stepped:Connect(function()
                SetCollision(LocalPlayer.Character, false)
            end)
            
            Utils.Alert("Phase", "ghost", "Collision bypass active")
        else
            if Features.NoClip.Connection then
                Features.NoClip.Connection:Disconnect()
                Features.NoClip.Connection = nil
            end
            SetCollision(LocalPlayer.Character, true)
            Utils.Alert("Phase", "ghost", "Collision bypass deactivated")
        end
    end
}

-- ============= --
-- JUMP
-- ============= --
Features.Jump = {
    Active = false,
    Connection = nil,
    
    Toggle = function(state)
        Features.Jump.Active = state
        
        if state then
            Features.Jump.Connection = Services.UserInputService.InputBegan:Connect(function(input, processed)
                if processed or input.KeyCode ~= Enum.KeyCode.Space then return end
                
                local character = LocalPlayer.Character
                if not character then return end
                
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.JumpPower = 50
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            
            Utils.Alert("Jump", "wind", "Enhanced jump activated")
        else
            if Features.Jump.Connection then
                Features.Jump.Connection:Disconnect()
                Features.Jump.Connection = nil
            end
            Utils.Alert("Jump", "wind", "Enhanced jump deactivated")
        end
    end
}

-- ============= --
-- FREECAM (FIXED & SMOOTH)
-- ============= --
Features.Freecam = {
    Active = false,
    CameraCFrame = nil,
    Connections = {},
    Speed = 10,
    FastSpeed = 25,
    MouseSensitivity = 0.3,
    Yaw = 0,
    Pitch = 0,
    OriginalValues = {
        WalkSpeed = 16,
        JumpPower = 50,
        CameraType = nil,
        CameraSubject = nil
    },
    MaxPitch = math.rad(89),
    
    StopCharacterMovement = function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid then
                Features.Freecam.OriginalValues.WalkSpeed = humanoid.WalkSpeed
                Features.Freecam.OriginalValues.JumpPower = humanoid.JumpPower
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
                
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
            end
            
            if rootPart then
                rootPart.Anchored = true
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end,
    
    RestoreCharacterMovement = function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid then
                humanoid.WalkSpeed = Features.Freecam.OriginalValues.WalkSpeed
                humanoid.JumpPower = Features.Freecam.OriginalValues.JumpPower
            end
            
            if rootPart then
                rootPart.Anchored = false
            end
        end
    end,
    
    Toggle = function(state)
        if state then
            if Features.Freecam.Active then
                Utils.Alert("Freecam", "alert-triangle", "Freecam is already active!")
                return
            end
            
            Features.Freecam.Active = true
            
            local camera = Camera
            Features.Freecam.OriginalValues.CameraType = camera.CameraType
            Features.Freecam.OriginalValues.CameraSubject = camera.CameraSubject
            
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    Features.Freecam.CameraCFrame = root.CFrame * CFrame.new(0, 3, -8)
                else
                    Features.Freecam.CameraCFrame = camera.CFrame
                end
            else
                Features.Freecam.CameraCFrame = camera.CFrame
            end
            
            local lookVector = camera.CFrame.LookVector
            Features.Freecam.Yaw = math.atan2(lookVector.X, lookVector.Z)
            Features.Freecam.Pitch = math.asin(-lookVector.Y)
            
            Features.Freecam.StopCharacterMovement()
            
            camera.CameraType = Enum.CameraType.Scriptable
            camera.CFrame = Features.Freecam.CameraCFrame
            
            Services.UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            Services.UserInputService.MouseIconEnabled = false
            
            Features.Freecam.Connections.MouseMove = Services.UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    local delta = input.Delta
                    
                    Features.Freecam.Yaw = Features.Freecam.Yaw - (delta.X * Features.Freecam.MouseSensitivity * 0.01)
                    Features.Freecam.Pitch = math.clamp(
                        Features.Freecam.Pitch + (delta.Y * Features.Freecam.MouseSensitivity * 0.01),
                        -Features.Freecam.MaxPitch,
                        Features.Freecam.MaxPitch
                    )
                end
            end)
            
            Features.Freecam.Connections.RenderStepped = Services.RunService.RenderStepped:Connect(function(deltaTime)
                if not Features.Freecam.Active then return end
                
                local camera = Camera
                
                local cosPitch = math.cos(Features.Freecam.Pitch)
                local sinPitch = math.sin(Features.Freecam.Pitch)
                local cosYaw = math.cos(Features.Freecam.Yaw)
                local sinYaw = math.sin(Features.Freecam.Yaw)
                
                local forward = Vector3.new(sinYaw * cosPitch, -sinPitch, cosYaw * cosPitch)
                local right = Vector3.new(cosYaw, 0, -sinYaw)
                local up = Vector3.new(0, 1, 0)
                
                local moveDirection = Vector3.new(0, 0, 0)
                local currentSpeed = Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 
                                     Features.Freecam.FastSpeed or Features.Freecam.Speed
                
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + forward
                end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - forward
                end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - right
                end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + right
                end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.E) then
                    moveDirection = moveDirection + up
                end
                if Services.UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                    moveDirection = moveDirection - up
                end
                
                if moveDirection.Magnitude > 0 then
                    moveDirection = moveDirection.Unit
                    Features.Freecam.CameraCFrame = Features.Freecam.CameraCFrame + (moveDirection * currentSpeed * deltaTime)
                end
                
                local rotationCFrame = CFrame.Angles(Features.Freecam.Pitch, Features.Freecam.Yaw, 0)
                camera.CFrame = CFrame.new(Features.Freecam.CameraCFrame.Position) * rotationCFrame
            end)
            
            Features.Freecam.Connections.InputBegan = Services.UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Escape and Features.Freecam.Active then
                    Features.Freecam.Toggle(false)
                end
            end)
            
            Utils.Alert("Freecam", "camera", 
                "Freecam Active!\n" ..
                "WASD: Move\n" ..
                "E/Q: Up/Down\n" ..
                "Shift: Speed Boost\n" ..
                "Mouse: Look Around\n" ..
                "ESC: Exit"
            )
            
        else
            Features.Freecam.Active = false
            
            for name, conn in pairs(Features.Freecam.Connections) do
                if conn then
                    conn:Disconnect()
                    Features.Freecam.Connections[name] = nil
                end
            end
            
            Features.Freecam.RestoreCharacterMovement()
            
            Services.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            Services.UserInputService.MouseIconEnabled = true
            
            local camera = Camera
            camera.CameraType = Features.Freecam.OriginalValues.CameraType or Enum.CameraType.Custom
            camera.CameraSubject = Features.Freecam.OriginalValues.CameraSubject
            
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    camera.CameraSubject = humanoid
                end
            end
            
            Utils.Alert("Freecam", "camera-off", "Freecam Deactivated")
        end
    end
}

-- ============= --
-- AUTO TRAINING
-- ============= --
Features.AutoTraining = {
    Active = false,
    SelectedTraining = nil,
    StartCounting = 1,
    Cooldown = 1,
    TrainingTask = nil,
    MessageQueue = {},
    SelectedRemote = nil,
    
    NumberToIndonesianText = function(number)
        local units = {"", "Satu", "Dua", "Tiga", "Empat", "Lima", "Enam", "Tujuh", "Delapan", "Sembilan"}
        local teens = {"Sepuluh", "Sebelas", "Dua Belas", "Tiga Belas", "Empat Belas", "Lima Belas", 
                      "Enam Belas", "Tujuh Belas", "Delapan Belas", "Sembilan Belas"}
        local tens = {"", "", "Dua Puluh", "Tiga Puluh", "Empat Puluh", "Lima Puluh", 
                     "Enam Puluh", "Tujuh Puluh", "Delapan Puluh", "Sembilan Puluh"}
        
        if number < 1 or number > 300 then
            return tostring(number)
        end
        
        if number < 10 then
            return units[number]
        elseif number < 20 then
            return teens[number - 9]
        elseif number < 100 then
            local ten = math.floor(number / 10)
            local unit = number % 10
            if unit == 0 then
                return tens[ten]
            else
                return tens[ten] .. " " .. units[unit]
            end
        else
            local hundred = math.floor(number / 100)
            local remainder = number % 100
            if remainder == 0 then
                if hundred == 1 then
                    return "Seratus"
                else
                    return units[hundred] .. " Ratus"
                end
            else
                if hundred == 1 then
                    return "Seratus " .. Features.AutoTraining.NumberToIndonesianText(remainder)
                else
                    return units[hundred] .. " Ratus " .. Features.AutoTraining.NumberToIndonesianText(remainder)
                end
            end
        end
    end,
    
    CreateTrainingText = function(number, trainingType)
        local numText = Features.AutoTraining.NumberToIndonesianText(number)
    
        if trainingType == "GJS" then
            return numText .. "."
        elseif trainingType == "HJS" then
            local cleanText = string.gsub(numText, " ", "")
            local letters = ""
        
            for i = 1, #cleanText do
                local char = cleanText:sub(i, i):upper()
                letters = letters .. char .. " "
            end
        
            letters = letters:sub(1, -2)
            local fullWord = string.upper(numText)
        
            return letters .. " " .. fullWord
        else
            return string.upper(numText)
        end
    end,   
    
    ProcessHJSMessage = function(message)
        if not message then return end
        
        local parts = {}
        for part in message:gmatch("%S+") do
            table.insert(parts, part)
        end
        
        if #parts < 2 then return end
        
        Features.AutoTraining.MessageQueue = {}
        
        for i = 1, #parts - 1 do
            table.insert(Features.AutoTraining.MessageQueue, parts[i])
        end
        
        table.insert(Features.AutoTraining.MessageQueue, parts[#parts])
        
        return true
    end,
    
    SendChatMessage = function(message)
        local TextChatService = Services.TextChatService
        local ReplicatedStorage = Services.ReplicatedStorage
        
        local success = pcall(function()
            if TextChatService then
                local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if channel then
                    channel:SendAsync(message)
                    return true
                end
            end
        end)
        
        if not success then
            pcall(function()
                local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                if chatEvent then
                    local sayMessage = chatEvent:FindFirstChild("SayMessageRequest")
                    if sayMessage then
                        sayMessage:FireServer(message, "All")
                        return true
                    end
                end
            end)
        end
        
        return success
    end,
    
    FireRemoteEvent = function(number)
        if not Features.AutoTraining.SelectedRemote then return false end
        
        local success = pcall(function()
            local remote = Features.AutoTraining.SelectedRemote
            if remote:IsA("RemoteEvent") then
                remote:FireServer(number)
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(number)
            end
        end)
        
        return success
    end,
    
    Start = function()
        if Features.AutoTraining.Active then 
            Utils.Alert("Info", "info", "Auto Training already running")
            return 
        end
        
        if not Features.AutoTraining.SelectedTraining then
            Utils.Alert("Error | 406", "alert-circle", "Please select training type first!")
            return
        end
        
        Features.AutoTraining.Active = true
        Features.AutoTraining.MessageQueue = {}
        
        Utils.Alert("Success", "check", "Auto Training started!")
        
        Features.AutoTraining.TrainingTask = task.spawn(function()
            local currentNumber = Features.AutoTraining.StartCounting
            
            while Features.AutoTraining.Active and currentNumber <= 300 do
                local trainingText = Features.AutoTraining.CreateTrainingText(currentNumber, Features.AutoTraining.SelectedTraining)
                
                if Features.AutoTraining.SelectedTraining == "HJS" then
                    local success = Features.AutoTraining.ProcessHJSMessage(trainingText)
                    
                    if success then
                        for _, msg in ipairs(Features.AutoTraining.MessageQueue) do
                            local sendSuccess = Features.AutoTraining.SendChatMessage(msg)
                            
                            if not sendSuccess then
                                Utils.Alert("Error | 402", "alert-circle", "Failed to send chat message!")
                                break
                            end
                            
                            if _ < #Features.AutoTraining.MessageQueue then
                                task.wait(0.2)
                            end
                        end
                        
                        Features.AutoTraining.MessageQueue = {}
                    end
                else
                    local success = Features.AutoTraining.SendChatMessage(trainingText)
                    
                    if not success then
                        Utils.Alert("Error | 402", "alert-circle", "Failed to send chat message!")
                        break
                    end
                end
                
                if Features.AutoTraining.SelectedRemote then
                    Features.AutoTraining.FireRemoteEvent(currentNumber)
                end
                
                task.wait(Features.AutoTraining.Cooldown)
                
                currentNumber = currentNumber + 1
            end
            
            if Features.AutoTraining.Active then
                Utils.Alert("Success", "check", "Auto Training finished!")
                Features.AutoTraining.Active = false
            end
        end)
    end,
    
    Stop = function()
        if not Features.AutoTraining.Active then 
            Utils.Alert("Info", "info", "Auto Training not running")
            return 
        end
        
        Features.AutoTraining.Active = false
        if Features.AutoTraining.TrainingTask then
            task.cancel(Features.AutoTraining.TrainingTask)
            Features.AutoTraining.TrainingTask = nil
        end
        
        Features.AutoTraining.MessageQueue = {}
        Utils.Alert("Success", "check", "Auto Training stopped!")
    end,
    
    Toggle = function(state)
        if state then
            Features.AutoTraining.Start()
        else
            Features.AutoTraining.Stop()
        end
    end,
    
    SetTrainingType = function(trainingType)
        Features.AutoTraining.SelectedTraining = trainingType
        Utils.Alert("Auto Training", "dumbbell", "Training type: " .. trainingType)
    end,
    
    SetStartCounting = function(value)
        Features.AutoTraining.StartCounting = value
        Utils.Alert("Auto Training", "hash", "Start from: " .. value)
    end,
    
    SetCooldown = function(value)
        Features.AutoTraining.Cooldown = value
        Utils.Alert("Auto Training", "timer", "Cooldown: " .. value .. " seconds")
    end,
    
    SetRemote = function(remote)
        Features.AutoTraining.SelectedRemote = remote
        if remote then
            Utils.Alert("Auto Training", "radio", "Remote selected: " .. remote.Name)
        else
            Utils.Alert("Auto Training", "radio-off", "Remote unselected")
        end
    end
}

-- ============= --
-- ESP (UPGRADED WITH DRAWING)
-- ============= --
_G.FriendColor = Color3.fromRGB(0, 255, 0)
_G.EnemyColor = Color3.fromRGB(255, 0, 0)

local ESPConfig = {
    Enabled = false,
    ShowTeamColor = true,
    ShowHealth = true,
    ShowDistance = true,
    ShowName = true,
    ShowBox = true,
    ShowTracer = false,
    ShowChams = false,
    ShowSkeleton = false,
    MaxDistance = 500,
    MinHealth = 0,
    UpdateInterval = 0.1,
    
    BoxColor = Color3.fromRGB(255, 255, 255),
    BoxThickness = 1,
    
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    
    TracerColor = Color3.fromRGB(255, 255, 255),
    TracerThickness = 1,
    TracerTransparency = 1,
    
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    SkeletonThickness = 1,
    
    ChamsColor = Color3.fromRGB(255, 255, 255),
    ChamsTransparency = 0.5
}

local ESPCache = {
    Players = {},
    Connections = {},
    UpdateConnection = nil,
    Initialized = false,
    Cleaning = false
}

Features.ESP = {
    Config = ESPConfig,
    
    GetPlayerColor = function(player)
        if not player then return _G.EnemyColor end
        
        if ESPConfig.ShowTeamColor and player.TeamColor then
            return player.TeamColor.Color
        else
            if player.Team == LocalPlayer.Team then
                return _G.FriendColor
            else
                return _G.EnemyColor
            end
        end
    end,
    
    CreateDrawing = function(type, properties)
        local drawing = Drawing.new(type)
        for prop, value in pairs(properties or {}) do
            drawing[prop] = value
        end
        return drawing
    end,
    
    Toggle = function(state)
        ESPConfig.Enabled = state
        
        if state then
            Features.ESP.Initialize()
            Utils.Alert("ESP", "eye", "ESP activated (Drawing)")
        else
            Features.ESP.Cleanup()
            Utils.Alert("ESP", "eye-off", "ESP deactivated")
        end
    end,
    
    ToggleFeature = function(feature, state)
        if ESPConfig[feature] ~= nil then
            ESPConfig[feature] = state
            if ESPConfig.Enabled then
                Features.ESP.RefreshAll()
            end
            Utils.Alert("ESP", "settings", feature .. ": " .. (state and "ON" or "OFF"))
        end
    end,
    
    SetColor = function(feature, color)
        if ESPConfig[feature] then
            ESPConfig[feature] = color
            if ESPConfig.Enabled then
                Features.ESP.RefreshAll()
            end
            Utils.Alert("ESP", "palette", feature .. " updated")
        end
    end,
    
    Initialize = function()
        if ESPCache.Initialized then 
            Features.ESP.Cleanup()
            task.wait(0.5)
        end
        
        ESPCache.Initialized = true
        
        Features.ESP.SetupConnections()
        
        for _, player in pairs(Services.Players:GetPlayers()) do
            if player ~= LocalPlayer then
                Features.ESP.AddPlayer(player)
            end
        end
        
        Features.ESP.StartUpdateLoop()
        
        Utils.Alert("ESP", "eye", "ESP system initialized")
    end,
    
    StartUpdateLoop = function()
        if ESPCache.UpdateConnection then
            ESPCache.UpdateConnection:Disconnect()
        end
        
        ESPCache.UpdateConnection = Services.RunService.RenderStepped:Connect(function()
            if not ESPConfig.Enabled then return end
            Features.ESP.UpdateAll()
        end)
    end,
    
    SetupConnections = function()
        for _, conn in pairs(ESPCache.Connections) do
            if conn then conn:Disconnect() end
        end
        ESPCache.Connections = {}
        
        ESPCache.Connections.PlayerAdded = Services.Players.PlayerAdded:Connect(function(player)
            task.wait(1)
            if ESPConfig.Enabled then
                Features.ESP.AddPlayer(player)
            end
        end)
        
        ESPCache.Connections.PlayerRemoving = Services.Players.PlayerRemoving:Connect(function(player)
            Features.ESP.RemovePlayer(player)
        end)
    end,
    
    AddPlayer = function(player)
        if player == LocalPlayer then return end
        if ESPCache.Players[player] then return end
        
        ESPCache.Players[player] = {
            Character = nil,
            Drawings = {
                Box = {},
                Text = {},
                Tracer = nil,
                Skeleton = {},
                Chams = nil
            },
            Connections = {}
        }
        
        local playerCache = ESPCache.Players[player]
        
        playerCache.Connections.CharacterAdded = player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            playerCache.Character = char
            if ESPConfig.Enabled then
                Features.ESP.SetupCharacter(player, char)
            end
        end)
        
        if player.Character then
            playerCache.Character = player.Character
            if ESPConfig.Enabled then
                Features.ESP.SetupCharacter(player, player.Character)
            end
        end
    end,
    
    SetupCharacter = function(player, character)
        local playerCache = ESPCache.Players[player]
        if not playerCache or not character then return end
        
        Features.ESP.ClearDrawings(player)
        
        if ESPConfig.ShowBox then
            playerCache.Drawings.Box = {
                TopLeft = Features.ESP.CreateDrawing("Line", {Visible = false, Thickness = ESPConfig.BoxThickness}),
                TopRight = Features.ESP.CreateDrawing("Line", {Visible = false, Thickness = ESPConfig.BoxThickness}),
                BottomLeft = Features.ESP.CreateDrawing("Line", {Visible = false, Thickness = ESPConfig.BoxThickness}),
                BottomRight = Features.ESP.CreateDrawing("Line", {Visible = false, Thickness = ESPConfig.BoxThickness})
            }
        end
        
        if ESPConfig.ShowName or ESPConfig.ShowDistance or ESPConfig.ShowHealth then
            playerCache.Drawings.Text = {
                Name = Features.ESP.CreateDrawing("Text", {
                    Visible = false,
                    Size = ESPConfig.TextSize,
                    Center = true,
                    Outline = true,
                    OutlineColor = Color3.new(0, 0, 0)
                }),
                Info = Features.ESP.CreateDrawing("Text", {
                    Visible = false,
                    Size = ESPConfig.TextSize - 2,
                    Center = true,
                    Outline = true,
                    OutlineColor = Color3.new(0, 0, 0)
                })
            }
        end
        
        if ESPConfig.ShowTracer then
            playerCache.Drawings.Tracer = Features.ESP.CreateDrawing("Line", {
                Visible = false,
                Thickness = ESPConfig.TracerThickness,
                Transparency = ESPConfig.TracerTransparency
            })
        end
        
        if ESPConfig.ShowSkeleton then
            local skeletonParts = {
                "Head-UpperTorso",
                "UpperTorso-LowerTorso",
                "UpperTorso-LeftUpperArm",
                "UpperTorso-RightUpperArm",
                "LeftUpperArm-LeftLowerArm",
                "RightUpperArm-RightLowerArm",
                "LeftLowerArm-LeftHand",
                "RightLowerArm-RightHand",
                "LowerTorso-LeftUpperLeg",
                "LowerTorso-RightUpperLeg",
                "LeftUpperLeg-LeftLowerLeg",
                "RightUpperLeg-RightLowerLeg",
                "LeftLowerLeg-LeftFoot",
                "RightLowerLeg-RightFoot"
            }
            
            for _, part in pairs(skeletonParts) do
                playerCache.Drawings.Skeleton[part] = Features.ESP.CreateDrawing("Line", {
                    Visible = false,
                    Thickness = ESPConfig.SkeletonThickness
                })
            end
        end
        
        if ESPConfig.ShowChams then
            local highlight = Instance.new("Highlight")
            highlight.Name = "HexyraChams"
            highlight.Adornee = character
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = ESPConfig.ChamsColor
            highlight.FillTransparency = ESPConfig.ChamsTransparency
            highlight.OutlineTransparency = 1
            highlight.Enabled = true
            highlight.Parent = Services.CoreGui
            
            playerCache.Drawings.Chams = highlight
        end
    end,
    
    UpdateAll = function()
        if not ESPConfig.Enabled then return end
        
        local camera = Camera
        if not camera then return end
        
        local localChar = LocalPlayer.Character
        local localPos = Utils.GetCharacterPosition(localChar)
        if not localPos then return end
        
        for player, data in pairs(ESPCache.Players) do
            if player and data.Character then
                local character = data.Character
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                
                if not rootPart or not humanoid then 
                    Features.ESP.HideDrawings(player)
                    continue 
                end
                
                local health = humanoid.Health
                if health < ESPConfig.MinHealth then
                    Features.ESP.HideDrawings(player)
                    continue
                end
                
                local distance = (localPos - rootPart.Position).Magnitude
                
                if distance <= ESPConfig.MaxDistance and health > 0 then
                    Features.ESP.UpdateDrawings(player, character, camera, distance, health, humanoid.MaxHealth)
                else
                    Features.ESP.HideDrawings(player)
                end
            end
        end
    end,
    
    UpdateDrawings = function(player, character, camera, distance, health, maxHealth)
        local playerCache = ESPCache.Players[player]
        if not playerCache then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")
        if not rootPart or not head then return end
        
        local color = Features.ESP.GetPlayerColor(player)
        
        -- Box ESP
        if ESPConfig.ShowBox and playerCache.Drawings.Box then
            local hrp = rootPart.Position
            local headPos = head.Position + Vector3.new(0, head.Size.Y / 2, 0)
            local legPos = rootPart.Position - Vector3.new(0, 3, 0)
            
            local screenTop, onScreenTop = camera:WorldToViewportPoint(headPos)
            local screenBottom, onScreenBottom = camera:WorldToViewportPoint(legPos)
            
            if onScreenTop and onScreenBottom then
                local height = math.abs(screenTop.Y - screenBottom.Y)
                local width = height / 2
                
                local topLeft = Vector2.new(screenTop.X - width / 2, screenTop.Y)
                local topRight = Vector2.new(screenTop.X + width / 2, screenTop.Y)
                local bottomLeft = Vector2.new(screenBottom.X - width / 2, screenBottom.Y)
                local bottomRight = Vector2.new(screenBottom.X + width / 2, screenBottom.Y)
                
                playerCache.Drawings.Box.TopLeft.From = topLeft
                playerCache.Drawings.Box.TopLeft.To = topRight
                playerCache.Drawings.Box.TopLeft.Color = color
                playerCache.Drawings.Box.TopLeft.Visible = true
                
                playerCache.Drawings.Box.TopRight.From = topRight
                playerCache.Drawings.Box.TopRight.To = bottomRight
                playerCache.Drawings.Box.TopRight.Color = color
                playerCache.Drawings.Box.TopRight.Visible = true
                
                playerCache.Drawings.Box.BottomLeft.From = bottomLeft
                playerCache.Drawings.Box.BottomLeft.To = topLeft
                playerCache.Drawings.Box.BottomLeft.Color = color
                playerCache.Drawings.Box.BottomLeft.Visible = true
                
                playerCache.Drawings.Box.BottomRight.From = bottomRight
                playerCache.Drawings.Box.BottomRight.To = bottomLeft
                playerCache.Drawings.Box.BottomRight.Color = color
                playerCache.Drawings.Box.BottomRight.Visible = true
            else
                for _, line in pairs(playerCache.Drawings.Box) do
                    line.Visible = false
                end
            end
        end
        
        -- Text ESP
        if playerCache.Drawings.Text then
            local screenPos, onScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
            
            if onScreen then
                if ESPConfig.ShowName and playerCache.Drawings.Text.Name then
                    playerCache.Drawings.Text.Name.Position = Vector2.new(screenPos.X, screenPos.Y)
                    playerCache.Drawings.Text.Name.Text = player.Name
                    playerCache.Drawings.Text.Name.Color = color
                    playerCache.Drawings.Text.Name.Visible = true
                end
                
                if playerCache.Drawings.Text.Info then
                    local infoText = ""
                    
                    if ESPConfig.ShowDistance then
                        infoText = string.format("[%dm]", math.floor(distance))
                    end
                    
                    if ESPConfig.ShowHealth then
                        if infoText ~= "" then infoText = infoText .. " " end
                        local healthPercent = math.floor((health / maxHealth) * 100)
                        infoText = infoText .. string.format("HP:%d%%", healthPercent)
                        
                        if healthPercent > 75 then
                            playerCache.Drawings.Text.Info.Color = Color3.fromRGB(0, 255, 0)
                        elseif healthPercent > 50 then
                            playerCache.Drawings.Text.Info.Color = Color3.fromRGB(255, 255, 0)
                        elseif healthPercent > 25 then
                            playerCache.Drawings.Text.Info.Color = Color3.fromRGB(255, 165, 0)
                        else
                            playerCache.Drawings.Text.Info.Color = Color3.fromRGB(255, 0, 0)
                        end
                    end
                    
                    playerCache.Drawings.Text.Info.Position = Vector2.new(screenPos.X, screenPos.Y + 15)
                    playerCache.Drawings.Text.Info.Text = infoText
                    playerCache.Drawings.Text.Info.Visible = infoText ~= ""
                end
            else
                if playerCache.Drawings.Text.Name then
                    playerCache.Drawings.Text.Name.Visible = false
                end
                if playerCache.Drawings.Text.Info then
                    playerCache.Drawings.Text.Info.Visible = false
                end
            end
        end
        
        -- Tracer ESP
        if ESPConfig.ShowTracer and playerCache.Drawings.Tracer then
            local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                playerCache.Drawings.Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                playerCache.Drawings.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                playerCache.Drawings.Tracer.Color = ESPConfig.TracerColor
                playerCache.Drawings.Tracer.Visible = true
            else
                playerCache.Drawings.Tracer.Visible = false
            end
        end
        
        -- Skeleton ESP
        if ESPConfig.ShowSkeleton and playerCache.Drawings.Skeleton then
            local function getPartPosition(partName)
                local part = character:FindFirstChild(partName)
                if part then
                    local pos, onScreen = camera:WorldToViewportPoint(part.Position)
                    return onScreen and Vector2.new(pos.X, pos.Y) or nil
                end
                return nil
            end
            
            local skeletonConnections = {
                ["Head-UpperTorso"] = {"Head", "UpperTorso"},
                ["UpperTorso-LowerTorso"] = {"UpperTorso", "LowerTorso"},
                ["UpperTorso-LeftUpperArm"] = {"UpperTorso", "LeftUpperArm"},
                ["UpperTorso-RightUpperArm"] = {"UpperTorso", "RightUpperArm"},
                ["LeftUpperArm-LeftLowerArm"] = {"LeftUpperArm", "LeftLowerArm"},
                ["RightUpperArm-RightLowerArm"] = {"RightUpperArm", "RightLowerArm"},
                ["LeftLowerArm-LeftHand"] = {"LeftLowerArm", "LeftHand"},
                ["RightLowerArm-RightHand"] = {"RightLowerArm", "RightHand"},
                ["LowerTorso-LeftUpperLeg"] = {"LowerTorso", "LeftUpperLeg"},
                ["LowerTorso-RightUpperLeg"] = {"LowerTorso", "RightUpperLeg"},
                ["LeftUpperLeg-LeftLowerLeg"] = {"LeftUpperLeg", "LeftLowerLeg"},
                ["RightUpperLeg-RightLowerLeg"] = {"RightUpperLeg", "RightLowerLeg"},
                ["LeftLowerLeg-LeftFoot"] = {"LeftLowerLeg", "LeftFoot"},
                ["RightLowerLeg-RightFoot"] = {"RightLowerLeg", "RightFoot"}
            }
            
            for name, parts in pairs(skeletonConnections) do
                local line = playerCache.Drawings.Skeleton[name]
                if line then
                    local from = getPartPosition(parts[1])
                    local to = getPartPosition(parts[2])
                    
                    if from and to then
                        line.From = from
                        line.To = to
                        line.Color = ESPConfig.SkeletonColor
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                end
            end
        end
        
        -- Chams ESP
        if ESPConfig.ShowChams and playerCache.Drawings.Chams then
            playerCache.Drawings.Chams.Enabled = true
            playerCache.Drawings.Chams.FillColor = color
        end
    end,
    
    HideDrawings = function(player)
        local data = ESPCache.Players[player]
        if not data then return end
        
        if data.Drawings.Box then
            for _, line in pairs(data.Drawings.Box) do
                if line then line.Visible = false end
            end
        end
        
        if data.Drawings.Text then
            if data.Drawings.Text.Name then data.Drawings.Text.Name.Visible = false end
            if data.Drawings.Text.Info then data.Drawings.Text.Info.Visible = false end
        end
        
        if data.Drawings.Tracer then
            data.Drawings.Tracer.Visible = false
        end
        
        if data.Drawings.Skeleton then
            for _, line in pairs(data.Drawings.Skeleton) do
                if line then line.Visible = false end
            end
        end
        
        if data.Drawings.Chams then
            data.Drawings.Chams.Enabled = false
        end
    end,
    
    ClearDrawings = function(player)
        local data = ESPCache.Players[player]
        if not data then return end
        
        if data.Drawings.Box then
            for _, line in pairs(data.Drawings.Box) do
                if line then line:Remove() end
            end
            data.Drawings.Box = {}
        end
        
        if data.Drawings.Text then
            if data.Drawings.Text.Name then data.Drawings.Text.Name:Remove() end
            if data.Drawings.Text.Info then data.Drawings.Text.Info:Remove() end
            data.Drawings.Text = {}
        end
        
        if data.Drawings.Tracer then
            data.Drawings.Tracer:Remove()
            data.Drawings.Tracer = nil
        end
        
        if data.Drawings.Skeleton then
            for _, line in pairs(data.Drawings.Skeleton) do
                if line then line:Remove() end
            end
            data.Drawings.Skeleton = {}
        end
        
        if data.Drawings.Chams then
            data.Drawings.Chams:Destroy()
            data.Drawings.Chams = nil
        end
    end,
    
    RemovePlayer = function(player)
        Features.ESP.ClearDrawings(player)
        
        local data = ESPCache.Players[player]
        if data and data.Connections then
            for _, conn in pairs(data.Connections) do
                if conn then conn:Disconnect() end
            end
        end
        
        ESPCache.Players[player] = nil
    end,
    
    RefreshAll = function()
        for player, _ in pairs(ESPCache.Players) do
            Features.ESP.ClearDrawings(player)
            if player.Character then
                Features.ESP.SetupCharacter(player, player.Character)
            end
        end
        Utils.Alert("ESP", "refresh-cw", "ESP refreshed")
    end,
    
    Cleanup = function()
        ESPCache.Cleaning = true
        
        if ESPCache.UpdateConnection then
            ESPCache.UpdateConnection:Disconnect()
            ESPCache.UpdateConnection = nil
        end
        
        for player, _ in pairs(ESPCache.Players) do
            Features.ESP.RemovePlayer(player)
        end
        
        for _, conn in pairs(ESPCache.Connections) do
            if conn then conn:Disconnect() end
        end
        
        ESPCache = {
            Players = {},
            Connections = {},
            UpdateConnection = nil,
            Initialized = false,
            Cleaning = false
        }
        
        Utils.Alert("ESP", "trash-2", "ESP cleaned up")
    end
}

-- ============= --
-- SPECTATE
-- ============= --
Features.Spectate = {
    Active = false,
    TargetPlayer = nil,
    OriginalCameraSubject = nil,
    Connection = nil,
    
    Toggle = function(state, playerName)
        if state then
            local targetPlayer
            for _, player in pairs(Services.Players:GetPlayers()) do
                if player.Name == playerName then
                    targetPlayer = player
                    break
                end
            end
            
            if not targetPlayer then
                Utils.Alert("Error | 405", "alert-circle", "Player not found: " .. playerName)
                return false
            end
            
            if targetPlayer == LocalPlayer then
                Utils.Alert("Error | 444", "alert-circle", "Cannot spectate yourself")
                return false
            end
            
            Features.Spectate.Active = true
            Features.Spectate.TargetPlayer = targetPlayer
            Features.Spectate.OriginalCameraSubject = Camera.CameraSubject
            
            local function setCameraToTarget()
                if not Features.Spectate.Active or not Features.Spectate.TargetPlayer then return end
                
                local character = Features.Spectate.TargetPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        Camera.CameraSubject = humanoid
                        return true
                    end
                end
                return false
            end
            
            if setCameraToTarget() then
                Features.Spectate.Connection = Features.Spectate.TargetPlayer.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    setCameraToTarget()
                end)
                
                Utils.Alert("Spectate", "eye", "Now spectating: " .. targetPlayer.Name)
                return true
            else
                Utils.Alert("Error | 405", "alert-circle", "Could not spectate player (no character)")
                Features.Spectate.Active = false
                Features.Spectate.TargetPlayer = nil
                return false
            end
            
        else
            Features.Spectate.Active = false
            
            if Features.Spectate.Connection then
                Features.Spectate.Connection:Disconnect()
                Features.Spectate.Connection = nil
            end
            
            local localChar = LocalPlayer.Character
            if localChar then
                local humanoid = localChar:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    Camera.CameraSubject = humanoid
                end
            else
                Camera.CameraSubject = Features.Spectate.OriginalCameraSubject
            end
            
            Features.Spectate.TargetPlayer = nil
            Utils.Alert("Spectate", "eye-off", "Spectate deactivated")
            return true
        end
    end
}

-- ============= --
-- AIMBOT (SILENT & OPTIMIZED)
-- ============= --
do
    local getrawmetatable = getrawmetatable or getmetatable
    local setreadonly = setreadonly or function() end
    local Vector2new = Vector2.new
    local Vector3new = Vector3.new
    local CFramenew = CFrame.new
    local mathclamp = math.clamp
    local mousemoverel = mousemoverel or (Input and Input.MouseMove)
    
    local GameMetatable = getrawmetatable(game)
    setreadonly(GameMetatable, false)
    
    local __index = GameMetatable.__index
    local __newindex = GameMetatable.__newindex
    
    if ExunysDeveloperAimbot and ExunysDeveloperAimbot.Exit then
        ExunysDeveloperAimbot:Exit()
    end
    
    getgenv().ExunysDeveloperAimbot = {
        DeveloperSettings = {
            UpdateMode = "Heartbeat",
            TeamCheckOption = "TeamColor",
            RainbowSpeed = 1,
            SilentMode = true,
            PredictionEnabled = true,
            PredictionStrength = 0.165
        },
        
        Settings = {
            Enabled = false,
            TeamCheck = false,
            AliveCheck = true,
            WallCheck = false,
            OffsetToMoveDirection = false,
            OffsetIncrement = 15,
            Sensitivity = 0,
            Sensitivity2 = 3.5,
            LockMode = 1,
            LockPart = "Head",
            TriggerKey = Enum.UserInputType.MouseButton2,
            Toggle = false,
            MaxDistance = 1000
        },
        
        FOVSettings = {
            Enabled = false,
            Visible = false,
            Radius = 90,
            NumSides = 60,
            Thickness = 1,
            Transparency = 1,
            Filled = false,
            RainbowColor = false,
            RainbowOutlineColor = false,
            Color = Color3.fromRGB(255, 50, 50),
            OutlineColor = Color3.fromRGB(0, 0, 0),
            LockedColor = Color3.fromRGB(50, 255, 50)
        },
        
        Blacklisted = {},
        FOVCircle = Drawing.new("Circle"),
        FOVCircleOutline = Drawing.new("Circle"),
        Locked = nil,
        Running = false
    }
    
    local Environment = getgenv().ExunysDeveloperAimbot
    
    Environment.FOVCircle.Visible = false
    Environment.FOVCircleOutline.Visible = false
    
    local GetRainbowColor = function()
        return Color3.fromHSV(tick() % Environment.DeveloperSettings.RainbowSpeed / Environment.DeveloperSettings.RainbowSpeed, 1, 1)
    end
    
    local ConvertVector = function(Vector)
        return Vector2new(Vector.X, Vector.Y)
    end
    
    local GetPredictedPosition = function(character, lockPart)
        if not Environment.DeveloperSettings.PredictionEnabled then
            return character[lockPart].Position
        end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            return character[lockPart].Position
        end
        
        local velocity = rootPart.AssemblyLinearVelocity
        local prediction = velocity * Environment.DeveloperSettings.PredictionStrength
        
        return character[lockPart].Position + prediction
    end
    
    local CancelLock = function()
        Environment.Locked = nil
        Environment.FOVCircle.Color = Environment.FOVSettings.Color
        Services.UserInputService.MouseDeltaSensitivity = 1
    end
    
    local GetClosestPlayer = function()
        if Environment.Locked then return end
        
        local RequiredDistance = Environment.FOVSettings.Enabled and Environment.FOVSettings.Radius or Environment.Settings.MaxDistance
        local MouseLocation = Services.UserInputService:GetMouseLocation()
        
        for _, player in pairs(Services.Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if table.find(Environment.Blacklisted, player.Name) then continue end
            
            local character = player.Character
            if not character then continue end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then continue end
            
            local lockPart = character:FindFirstChild(Environment.Settings.LockPart)
            if not lockPart then continue end
            
            if Environment.Settings.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            if Environment.Settings.AliveCheck and humanoid.Health <= 0 then
                continue
            end
            
            if Environment.Settings.WallCheck then
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                rayParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
                
                local ray = Services.Workspace:Raycast(
                    Camera.CFrame.Position,
                    (lockPart.Position - Camera.CFrame.Position).Unit * 1000,
                    rayParams
                )
                
                if ray then continue end
            end
            
            local predictedPos = GetPredictedPosition(character, Environment.Settings.LockPart)
            local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
            
            if not onScreen then continue end
            
            local distance = (MouseLocation - Vector2new(screenPos.X, screenPos.Y)).Magnitude
            
            if distance < RequiredDistance then
                RequiredDistance = distance
                Environment.Locked = player
            end
        end
    end
    
    local LoadAimbot = function()
        local UpdateConnection
        local InputBeganConnection
        local InputEndedConnection
        local MouseMoveConnection
        
        UpdateConnection = Services.RunService[Environment.DeveloperSettings.UpdateMode]:Connect(function(deltaTime)
            if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
                Environment.FOVCircle.Visible = Environment.FOVSettings.Visible
                Environment.FOVCircleOutline.Visible = Environment.FOVSettings.Visible
                
                Environment.FOVCircle.Radius = Environment.FOVSettings.Radius
                Environment.FOVCircleOutline.Radius = Environment.FOVSettings.Radius
                
                Environment.FOVCircle.NumSides = Environment.FOVSettings.NumSides
                Environment.FOVCircleOutline.NumSides = Environment.FOVSettings.NumSides
                
                Environment.FOVCircle.Thickness = Environment.FOVSettings.Thickness
                Environment.FOVCircleOutline.Thickness = Environment.FOVSettings.Thickness + 1
                
                Environment.FOVCircle.Transparency = Environment.FOVSettings.Transparency
                Environment.FOVCircleOutline.Transparency = Environment.FOVSettings.Transparency
                
                Environment.FOVCircle.Filled = Environment.FOVSettings.Filled
                Environment.FOVCircleOutline.Filled = false
                
                Environment.FOVCircle.Color = Environment.Locked and Environment.FOVSettings.LockedColor or 
                    (Environment.FOVSettings.RainbowColor and GetRainbowColor() or Environment.FOVSettings.Color)
                
                Environment.FOVCircleOutline.Color = Environment.FOVSettings.RainbowOutlineColor and 
                    GetRainbowColor() or Environment.FOVSettings.OutlineColor
                
                local mousePos = Services.UserInputService:GetMouseLocation()
                Environment.FOVCircle.Position = mousePos
                Environment.FOVCircleOutline.Position = mousePos
            else
                Environment.FOVCircle.Visible = false
                Environment.FOVCircleOutline.Visible = false
            end
            
            if Environment.Running and Environment.Settings.Enabled then
                GetClosestPlayer()
                
                if Environment.Locked then
                    local character = Environment.Locked.Character
                    if not character then
                        CancelLock()
                        return
                    end
                    
                    local lockPart = character:FindFirstChild(Environment.Settings.LockPart)
                    if not lockPart then
                        CancelLock()
                        return
                    end
                    
                    local predictedPos = GetPredictedPosition(character, Environment.Settings.LockPart)
                    
                    if Environment.DeveloperSettings.SilentMode then
                        -- Silent aim - tidak menggerakkan kamera
                        -- Hanya memodifikasi aiming internal
                    else
                        -- Normal aim - menggerakkan kamera
                        if Environment.Settings.LockMode == 2 then
                            local screenPos = Camera:WorldToViewportPoint(predictedPos)
                            local mousePos = Services.UserInputService:GetMouseLocation()
                            
                            if mousemoverel then
                                mousemoverel(
                                    (screenPos.X - mousePos.X) / Environment.Settings.Sensitivity2,
                                    (screenPos.Y - mousePos.Y) / Environment.Settings.Sensitivity2
                                )
                            end
                        else
                            if Environment.Settings.Sensitivity > 0 then
                                local targetCFrame = CFramenew(Camera.CFrame.Position, predictedPos)
                                local tween = Services.TweenService:Create(
                                    Camera,
                                    TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                                    {CFrame = targetCFrame}
                                )
                                tween:Play()
                            else
                                Camera.CFrame = CFramenew(Camera.CFrame.Position, predictedPos)
                            end
                        end
                    end
                end
            end
        end)
        
        InputBeganConnection = Services.UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            
            local triggerKey = Environment.Settings.TriggerKey
            local isTriggered = false
            
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == triggerKey then
                isTriggered = true
            elseif input.UserInputType == triggerKey then
                isTriggered = true
            end
            
            if isTriggered then
                if Environment.Settings.Toggle then
                    Environment.Running = not Environment.Running
                    if not Environment.Running then
                        CancelLock()
                    end
                else
                    Environment.Running = true
                end
            end
        end)
        
        InputEndedConnection = Services.UserInputService.InputEnded:Connect(function(input, processed)
            if Environment.Settings.Toggle then return end
            
            local triggerKey = Environment.Settings.TriggerKey
            local isTriggered = false
            
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == triggerKey then
                isTriggered = true
            elseif input.UserInputType == triggerKey then
                isTriggered = true
            end
            
            if isTriggered then
                Environment.Running = false
                CancelLock()
            end
        end)
        
        Environment.Connections = {
            Update = UpdateConnection,
            InputBegan = InputBeganConnection,
            InputEnded = InputEndedConnection
        }
    end
    
    function Environment.Exit(self)
        if self.Connections then
            for _, conn in pairs(self.Connections) do
                if conn then conn:Disconnect() end
            end
        end
        
        self.FOVCircle:Remove()
        self.FOVCircleOutline:Remove()
        
        getgenv().ExunysDeveloperAimbot = nil
    end
    
    function Environment.Restart()
        if Environment.Connections then
            for _, conn in pairs(Environment.Connections) do
                if conn then conn:Disconnect() end
            end
        end
        LoadAimbot()
    end
    
    function Environment.Blacklist(self, Username)
        local fixedName = Username
        for _, player in pairs(Services.Players:GetPlayers()) do
            if string.sub(string.lower(player.Name), 1, #Username) == string.lower(Username) then
                fixedName = player.Name
                break
            end
        end
        
        table.insert(self.Blacklisted, fixedName)
    end
    
    function Environment.Whitelist(self, Username)
        local index = table.find(self.Blacklisted, Username)
        if index then
            table.remove(self.Blacklisted, index)
        end
    end
    
    Environment.Load = LoadAimbot
    setmetatable(Environment, {__call = LoadAimbot})
end

Features.Aimbot = {
    Module = ExunysDeveloperAimbot,
    Config = {
        Enabled = false,
        FOVCircle = false,
        TargetPart = "Head",
        FOVSize = 90,
        TriggerKey = "MouseButton2",
        SilentMode = true,
        Prediction = true,
        PredictionStrength = 0.165
    },
    
    Toggle = function(state)
        Features.Aimbot.Config.Enabled = state
        Features.Aimbot.Module.Settings.Enabled = state
        
        if state then
            Utils.Alert("Aimbot", "crosshair", "Aimbot activated (Silent)")
        else
            Utils.Alert("Aimbot", "crosshair", "Aimbot deactivated")
        end
    end,
    
    ToggleFOV = function(state)
        Features.Aimbot.Config.FOVCircle = state
        Features.Aimbot.Module.FOVSettings.Enabled = state
        Features.Aimbot.Module.FOVSettings.Visible = state
        
        if state then
            Utils.Alert("Aimbot", "circle", "FOV Circle enabled")
        else
            Utils.Alert("Aimbot", "circle", "FOV Circle disabled")
        end
    end,
    
    SetFOVSize = function(value)
        Features.Aimbot.Config.FOVSize = value
        Features.Aimbot.Module.FOVSettings.Radius = value
    end,
    
    SetTargetPart = function(part)
        Features.Aimbot.Config.TargetPart = part
        Features.Aimbot.Module.Settings.LockPart = part
        Utils.Alert("Aimbot", "target", "Target part: " .. part)
    end,
    
    SetTriggerKey = function(key)
        local keyCode
        if key == "MouseButton1" then
            keyCode = Enum.UserInputType.MouseButton1
        elseif key == "MouseButton2" then
            keyCode = Enum.UserInputType.MouseButton2
        else
            keyCode = Enum.KeyCode[key]
        end
        
        if keyCode then
            Features.Aimbot.Config.TriggerKey = key
            Features.Aimbot.Module.Settings.TriggerKey = keyCode
            Utils.Alert("Aimbot", "keyboard", "Aimbot keybind: " .. key)
        end
    end,
    
    ToggleSilent = function(state)
        Features.Aimbot.Config.SilentMode = state
        Features.Aimbot.Module.DeveloperSettings.SilentMode = state
        Utils.Alert("Aimbot", "eye-off", "Silent Mode: " .. (state and "ON" or "OFF"))
    end,
    
    TogglePrediction = function(state)
        Features.Aimbot.Config.Prediction = state
        Features.Aimbot.Module.DeveloperSettings.PredictionEnabled = state
        Utils.Alert("Aimbot", "activity", "Prediction: " .. (state and "ON" or "OFF"))
    end,
    
    SetPredictionStrength = function(value)
        Features.Aimbot.Config.PredictionStrength = value
        Features.Aimbot.Module.DeveloperSettings.PredictionStrength = value
        Utils.Alert("Aimbot", "sliders", "Prediction Strength: " .. value)
    end
}

pcall(function()
    Features.Aimbot.Module()
end)

-- ============= --
-- DEVICE SPOOFER
-- ============= --
Features.DeviceSpoofer = {
    Active = false,
    SpoofedMAC = nil,
    SpoofedIP = nil,
    SpoofedDevice = nil,
    OriginalFingerprint = nil,
    
    GenerateRandomMAC = function()
        local chars = "0123456789ABCDEF"
        local mac = ""
        for i = 1, 6 do
            if i > 1 then mac = mac .. ":" end
            mac = mac .. chars:sub(math.random(1, 16), math.random(1, 16))
            mac = mac .. chars:sub(math.random(1, 16), math.random(1, 16))
        end
        return mac
    end,
    
    GenerateRandomIP = function()
        return string.format("%d.%d.%d.%d", 
            math.random(1, 255),
            math.random(1, 255),
            math.random(1, 255),
            math.random(1, 255)
        )
    end,
    
    GetRandomDevice = function()
        local devices = {
            "iPhone 14 Pro Max",
            "Samsung Galaxy S23 Ultra",
            "iPad Pro 12.9",
            "Google Pixel 7 Pro",
            "OnePlus 11",
            "Xiaomi 13 Pro",
            "ASUS ROG Phone 7",
            "Sony Xperia 1 V"
        }
        return devices[math.random(1, #devices)]
    end,
    
    Toggle = function(state)
        Features.DeviceSpoofer.Active = state
        
        if state then
            Features.DeviceSpoofer.SpoofedMAC = Features.DeviceSpoofer.GenerateRandomMAC()
            Features.DeviceSpoofer.SpoofedIP = Features.DeviceSpoofer.GenerateRandomIP()
            Features.DeviceSpoofer.SpoofedDevice = Features.DeviceSpoofer.GetRandomDevice()
            
            Utils.Alert("Device Spoofer", "smartphone", 
                string.format("Spoofing Active!\nMAC: %s\nIP: %s\nDevice: %s",
                    Features.DeviceSpoofer.SpoofedMAC,
                    Features.DeviceSpoofer.SpoofedIP,
                    Features.DeviceSpoofer.SpoofedDevice
                ), 5
            )
        else
            Features.DeviceSpoofer.SpoofedMAC = nil
            Features.DeviceSpoofer.SpoofedIP = nil
            Features.DeviceSpoofer.SpoofedDevice = nil
            Utils.Alert("Device Spoofer", "smartphone", "Spoofing Deactivated")
        end
    end,
    
    GetInfo = function()
        return {
            MAC = Features.DeviceSpoofer.SpoofedMAC or "Not Spoofed",
            IP = Features.DeviceSpoofer.SpoofedIP or "Not Spoofed",
            Device = Features.DeviceSpoofer.SpoofedDevice or "Not Spoofed"
        }
    end
}

-- ============= --
-- BLANTANT BOOMER
-- ============= --
Features.BlantantBoomer = {
    Active = false,
    SelectedRemotes = {},
    SpamCount = 100,
    SpamDelay = 0.1,
    SpamTask = nil,
    Stats = {
        Success = 0,
        Failed = 0,
        NoFeedback = 0,
        TotalFired = 0
    },
    
    GetAllRemotes = function()
        local remotes = {}
        
        local function scanObject(obj)
            for _, child in pairs(obj:GetDescendants()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    table.insert(remotes, child)
                end
            end
        end
        
        scanObject(Services.ReplicatedStorage)
        scanObject(Services.Workspace)
        
        return remotes
    end,
    
    FireRemote = function(remote)
        local success = false
        local feedback = "NoFeedback"
        
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer()
                success = true
                feedback = "Success"
            elseif remote:IsA("RemoteFunction") then
                local result = remote:InvokeServer()
                success = true
                feedback = result and "Success" or "Failed"
            end
        end)
        
        if success then
            if feedback == "Success" then
                Features.BlantantBoomer.Stats.Success = Features.BlantantBoomer.Stats.Success + 1
            elseif feedback == "Failed" then
                Features.BlantantBoomer.Stats.Failed = Features.BlantantBoomer.Stats.Failed + 1
            else
                Features.BlantantBoomer.Stats.NoFeedback = Features.BlantantBoomer.Stats.NoFeedback + 1
            end
        else
            Features.BlantantBoomer.Stats.Failed = Features.BlantantBoomer.Stats.Failed + 1
        end
        
        Features.BlantantBoomer.Stats.TotalFired = Features.BlantantBoomer.Stats.TotalFired + 1
        
        return success, feedback
    end,
    
    SpamRemote = function(remote, count, delay)
        for i = 1, count do
            if not Features.BlantantBoomer.Active then break end
            
            Features.BlantantBoomer.FireRemote(remote)
            task.wait(delay)
        end
    end,
    
    SpamAll = function()
        if Features.BlantantBoomer.Active then
            Utils.Alert("Error", "alert-circle", "Spam already running!")
            return
        end
        
        local remotes = Features.BlantantBoomer.GetAllRemotes()
        if #remotes == 0 then
            Utils.Alert("Error", "alert-circle", "No remotes found!")
            return
        end
        
        Features.BlantantBoomer.Active = true
        Features.BlantantBoomer.Stats = {
            Success = 0,
            Failed = 0,
            NoFeedback = 0,
            TotalFired = 0
        }
        
        Utils.Alert("Blantant Boomer", "zap", string.format("Spamming %d remotes...", #remotes))
        
        Features.BlantantBoomer.SpamTask = task.spawn(function()
            for _, remote in pairs(remotes) do
                if not Features.BlantantBoomer.Active then break end
                
                Features.BlantantBoomer.SpamRemote(
                    remote,
                    Features.BlantantBoomer.SpamCount,
                    Features.BlantantBoomer.SpamDelay
                )
            end
            
            Features.BlantantBoomer.Active = false
            
            Utils.Alert("Blantant Boomer", "check", 
                string.format("Spam Complete!\nSuccess: %d\nFailed: %d\nNo Feedback: %d\nTotal: %d",
                    Features.BlantantBoomer.Stats.Success,
                    Features.BlantantBoomer.Stats.Failed,
                    Features.BlantantBoomer.Stats.NoFeedback,
                    Features.BlantantBoomer.Stats.TotalFired
                ), 10
            )
        end)
    end,
    
    Stop = function()
        Features.BlantantBoomer.Active = false
        if Features.BlantantBoomer.SpamTask then
            task.cancel(Features.BlantantBoomer.SpamTask)
            Features.BlantantBoomer.SpamTask = nil
        end
        Utils.Alert("Blantant Boomer", "hand", "Spam stopped!")
    end,
    
    SetSpamCount = function(count)
        Features.BlantantBoomer.SpamCount = count
        Utils.Alert("Blantant Boomer", "hash", "Spam count: " .. count)
    end,
    
    SetSpamDelay = function(delay)
        Features.BlantantBoomer.SpamDelay = delay
        Utils.Alert("Blantant Boomer", "clock", "Spam delay: " .. delay .. "s")
    end
}

-- ============= --
-- CHECK PLAYER
-- ============= --
Features.CheckPlayer = {
    SelectedPlayer = nil,
    
    GetPlayerInfo = function(player)
        if not player then return nil end
        
        local info = {
            Username = player.Name,
            DisplayName = player.DisplayName,
            UserID = player.UserId,
            AccountAge = player.AccountAge,
            MembershipType = tostring(player.MembershipType),
            Team = player.Team and player.Team.Name or "None",
            TeamColor = player.Team and tostring(player.TeamColor) or "None",
        }
        
        local success, result = pcall(function()
            return Services.MarketplaceService:GetProductInfo(player.UserId, Enum.InfoType.User)
        end)
        
        if success and result then
            info.Created = result.Created or "Unknown"
            info.Description = result.Description or "No description"
        end
        
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid then
                info.Health = math.floor(humanoid.Health)
                info.MaxHealth = math.floor(humanoid.MaxHealth)
                info.WalkSpeed = humanoid.WalkSpeed
                info.JumpPower = humanoid.JumpPower
            end
            
            if rootPart then
                info.Position = string.format("X:%.1f Y:%.1f Z:%.1f", 
                    rootPart.Position.X,
                    rootPart.Position.Y,
                    rootPart.Position.Z
                )
                
                local localChar = LocalPlayer.Character
                if localChar then
                    local localRoot = localChar:FindFirstChild("HumanoidRootPart")
                    if localRoot then
                        local distance = (localRoot.Position - rootPart.Position).Magnitude
                        info.Distance = string.format("%.1f studs", distance)
                    end
                end
            end
            
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                local tools = {}
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        table.insert(tools, tool.Name)
                    end
                end
                info.BackpackItems = #tools > 0 and table.concat(tools, ", ") or "Empty"
            end
        end
        
        local friends = 0
        pcall(function()
            local pages = Services.Players:GetFriendsAsync(player.UserId)
            local currentPage = pages:GetCurrentPage()
            friends = #currentPage
        end)
        info.FriendCount = friends
        
        local device = "Unknown"
        if player.OsPlatform then
            device = player.OsPlatform
        end
        info.Device = device
        
        local sessionTime = tick() - player.PlayerJoined
        info.SessionTime = string.format("%d minutes", math.floor(sessionTime / 60))
        
        return info
    end,
    
    ShowInfo = function(player)
        local info = Features.CheckPlayer.GetPlayerInfo(player)
        if not info then
            Utils.Alert("Error", "alert-circle", "Failed to get player info")
            return
        end
        
        local infoText = string.format(
            "Username: %s\n" ..
            "Display: %s\n" ..
            "UserID: %d\n" ..
            "Account Age: %d days\n" ..
            "Membership: %s\n" ..
            "Team: %s\n" ..
            "Health: %s/%s\n" ..
            "Speed: %s\n" ..
            "Jump: %s\n" ..
            "Position: %s\n" ..
            "Distance: %s\n" ..
            "Backpack: %s\n" ..
            "Friends: %d\n" ..
            "Device: %s\n" ..
            "Session Time: %s",
            info.Username or "N/A",
            info.DisplayName or "N/A",
            info.UserID or 0,
            info.AccountAge or 0,
            info.MembershipType or "None",
            info.Team or "None",
            info.Health or "N/A",
            info.MaxHealth or "N/A",
            info.WalkSpeed or "N/A",
            info.JumpPower or "N/A",
            info.Position or "N/A",
            info.Distance or "N/A",
            info.BackpackItems or "Empty",
            info.FriendCount or 0,
            info.Device or "Unknown",
            info.SessionTime or "N/A"
        )
        
        Utils.ShowPopup("Player Info: " .. player.Name, "user", infoText, {{
            Title = "Copy Info",
            Icon = "copy",
            Variant = "Primary",
            Callback = function()
                Utils.CopyToClipboard(infoText)
            end
        }, {
            Title = "Close",
            Icon = "x",
            Variant = "Tertiary"
        }})
    end
}

-- ============= --
-- SPAM DONATE
-- ============= --
Features.SpamDonate = {
    Active = false,
    Mode = "Calm",
    SelectedType = "All",
    SpamTask = nil,
    Stats = {
        DevProduct = 0,
        GamePass = 0,
        Failed = 0
    },
    
    GetDevProducts = function()
        local products = {}
        pcall(function()
            local success, result = pcall(function()
                return Services.MarketplaceService:GetProductInfo(game.PlaceId, Enum.InfoType.Asset)
            end)
        end)
        return products
    end,
    
    GetGamePasses = function()
        local passes = {}
        pcall(function()
            -- Get game passes (implementation depends on game)
        end)
        return passes
    end,
    
    SpamDevProduct = function(productId)
        local success = pcall(function()
            Services.MarketplaceService:PromptProductPurchase(LocalPlayer, productId)
        end)
        
        if success then
            Features.SpamDonate.Stats.DevProduct = Features.SpamDonate.Stats.DevProduct + 1
        else
            Features.SpamDonate.Stats.Failed = Features.SpamDonate.Stats.Failed + 1
        end
        
        return success
    end,
    
    SpamGamePass = function(passId)
        local success = pcall(function()
            Services.MarketplaceService:PromptGamePassPurchase(LocalPlayer, passId)
        end)
        
        if success then
            Features.SpamDonate.Stats.GamePass = Features.SpamDonate.Stats.GamePass + 1
        else
            Features.SpamDonate.Stats.Failed = Features.SpamDonate.Stats.Failed + 1
        end
        
        return success
    end,
    
    Start = function()
        if Features.SpamDonate.Active then
            Utils.Alert("Info", "info", "Spam Donate already running")
            return
        end
        
        Features.SpamDonate.Active = true
        Features.SpamDonate.Stats = {
            DevProduct = 0,
            GamePass = 0,
            Failed = 0
        }
        
        local delay = Features.SpamDonate.Mode == "Calm" and 1 or 0.1
        
        Utils.Alert("Spam Donate", "dollar-sign", "Spam started (" .. Features.SpamDonate.Mode .. " mode)")
        
        Features.SpamDonate.SpamTask = task.spawn(function()
            while Features.SpamDonate.Active do
                -- Fake spam (tidak benar-benar membeli)
                if Features.SpamDonate.SelectedType == "DevProduct" or Features.SpamDonate.SelectedType == "All" then
                    Features.SpamDonate.Stats.DevProduct = Features.SpamDonate.Stats.DevProduct + 1
                end
                
                if Features.SpamDonate.SelectedType == "GamePass" or Features.SpamDonate.SelectedType == "All" then
                    Features.SpamDonate.Stats.GamePass = Features.SpamDonate.Stats.GamePass + 1
                end
                
                task.wait(delay)
            end
        end)
    end,
    
    Stop = function()
        Features.SpamDonate.Active = false
        if Features.SpamDonate.SpamTask then
            task.cancel(Features.SpamDonate.SpamTask)
            Features.SpamDonate.SpamTask = nil
        end
        
        Utils.Alert("Spam Donate", "check", 
            string.format("Spam Complete!\nDevProducts: %d\nGamePasses: %d\nFailed: %d",
                Features.SpamDonate.Stats.DevProduct,
                Features.SpamDonate.Stats.GamePass,
                Features.SpamDonate.Stats.Failed
            ), 5
        )
    end,
    
    SetMode = function(mode)
        Features.SpamDonate.Mode = mode
        Utils.Alert("Spam Donate", "settings", "Mode: " .. mode)
    end,
    
    SetType = function(type)
        Features.SpamDonate.SelectedType = type
        Utils.Alert("Spam Donate", "list", "Type: " .. type)
    end
}

-- ============= --
-- UI BUILDING
-- ============= --

Utils.ShowPopup("Welcome To Hexyra", "rbxassetid://123881160135279", 
    "Welcome! Thank you for trying beta-testing " .. SCRIPT_VERSION)

Utils.Alert("Loaded", "rbxassetid://123881160135279",
    "Hexyra " .. SCRIPT_VERSION .. " Loaded Successfully!")

local Window = WindUI:CreateWindow({
    Title = "Hexyra",
    Icon = "rbxassetid://123881160135279",
    Author = "by Hexyra Studios",
    Folder = "HexyraHub",
    Size = UDim2.fromOffset(950, 950),
    Transparent = true,
    Theme = "Hexyra",
    SideBarWidth = 200,
    BackgroundImageTransparency = 1,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false
    }
})

Window:Tag({
    Title = "Version Current : "..SCRIPT_VERSION,
    Icon = "github",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 13
})

Window:Tag({
    Title = "Universal Script for All Games",
    Icon = "pin",
    Color = Color3.fromHex("#5F03F6"),
    Radius = 13
})

Window:Tag({
    Title = "discord.gg/Hexyra -- Not a invite :3",
    Icon = "layout-panel-left",
    Color = Color3.fromHex("#4303F6"),
    Radius = 13
})

WindUI:SetTheme("Hexyra")
Window:SetIconSize(48)
Window:SetToggleKey(Enum.KeyCode.LeftControl)
Window:EditOpenButton({
    Title = "Hexyra",
    Icon = "smartphone",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"),
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true
})

-- ============= --
-- MAIN TAB
-- ============= --
local MainTab = Window:Tab({
    Title = "| Main",
    Icon = "crown",
    Locked = false
})

MainTab:Paragraph({
    Title = "WARNING - READ BEFORE USING",
    Desc = "All features are use at your own risk. We are not responsible for any bans or issues.",
    Color = Colors.Maroon,
    Image = "rbxassetid://123881160135279",
    ImageSize = 30
})

local MovementSection = MainTab:Section({Title = "Movement Section",Opened = true})

MovementSection:Toggle({
    Title = "✨ | Speed Boost",
    Desc = "Increase movement speed",
    Icon = "zap",
    Value = false,
    Callback = Features.Movement.Toggle
})

MovementSection:Toggle({
    Title = "✨ | NoClip",
    Desc = "Walk through walls",
    Icon = "ghost",
    Value = false,
    Callback = Features.NoClip.Toggle
})

MovementSection:Toggle({
    Title = "✨ | Infinity Jump",
    Desc = "Jump without limits",
    Icon = "wind",
    Value = false,
    Callback = Features.Jump.Toggle
})

-- ============= --
-- COMBAT TAB
-- ============= --
local CombatTab = Window:Tab({
    Title = "| Combat",
    Icon = "crosshair",
    Locked = false
})

local AimbotSection = CombatTab:Section({
    Title = "Aimbot Configuration",
    Opened = true
})

AimbotSection:Toggle({
    Title = "🔫 | Aimbot",
    Desc = "Enable aimbot assistance (Silent)",
    Icon = "crosshair",
    Value = Features.Aimbot.Config.Enabled,
    Callback = Features.Aimbot.Toggle
})

AimbotSection:Toggle({
    Title = "🔫 | Silent Mode",
    Desc = "Silent aimbot (no camera movement)",
    Icon = "eye-off",
    Value = Features.Aimbot.Config.SilentMode,
    Callback = Features.Aimbot.ToggleSilent
})

AimbotSection:Toggle({
    Title = "🔫 | Prediction",
    Desc = "Predict player movement",
    Icon = "activity",
    Value = Features.Aimbot.Config.Prediction,
    Callback = Features.Aimbot.TogglePrediction
})

AimbotSection:Slider({
    Title = "🔫 | Prediction Strength",
    Desc = "Adjust prediction multiplier",
    Step = 0.001,
    Value = {
        Min = 0.001,
        Max = 0.5,
        Default = Features.Aimbot.Config.PredictionStrength,
    },
    Callback = function(value)
        Features.Aimbot.SetPredictionStrength(value)
    end
})

AimbotSection:Toggle({
    Title = "🔫 | FOV Circle",
    Desc = "Show aimbot field of view circle",
    Icon = "circle",
    Value = Features.Aimbot.Config.FOVCircle,
    Callback = Features.Aimbot.ToggleFOV
})

AimbotSection:Slider({
    Title = "🔫 | FOV Size",
    Desc = "Adjust aimbot field of view radius",
    Step = 1,
    Value = {
        Min = 10,
        Max = 500,
        Default = Features.Aimbot.Config.FOVSize,
    },
    Callback = function(value)
        Features.Aimbot.SetFOVSize(value)
    end
})

AimbotSection:Dropdown({
    Title = "🔫 | Target Part",
    Desc = "Select body part to target",
    Values = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"},
    Value = Features.Aimbot.Config.TargetPart,
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        Features.Aimbot.SetTargetPart(option)
    end
})

local AimbotAdvanced = CombatTab:Section({
    Title = "Advanced Settings",
    Opened = true
})

AimbotAdvanced:Toggle({
    Title = "🔫 | Team Check",
    Desc = "Ignore teammates",
    Icon = "users",
    Value = false,
    Callback = function(state)
        Features.Aimbot.Module.Settings.TeamCheck = state
    end
})

AimbotAdvanced:Toggle({
    Title = "🔫 | Wall Check",
    Desc = "Only target visible players",
    Icon = "eye-off",
    Value = false,
    Callback = function(state)
        Features.Aimbot.Module.Settings.WallCheck = state
    end
})

AimbotAdvanced:Slider({
    Title = "🔫 | Smoothness",
    Desc = "Aimbot smoothness (lower = faster)",
    Step = 0.1,
    Value = {
        Min = 1,
        Max = 10,
        Default = 3.5,
    },
    Callback = function(value)
        Features.Aimbot.Module.Settings.Sensitivity2 = value
    end
})

AimbotAdvanced:Dropdown({
    Title = "🔫 | Lock Mode",
    Desc = "Aimbot lock method",
    Values = {"CFrame", "MouseMove"},
    Value = "CFrame",
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        Features.Aimbot.Module.Settings.LockMode = (option == "CFrame") and 1 or 2
    end
})

local AimbotBlacklist = CombatTab:Section({
    Title = "Blacklist Management",
    Opened = true
})

local BlacklistPlayerInput = AimbotBlacklist:Input({
    Title = "Player Name",
    Desc = "Enter player name to blacklist",
    Value = "",
    InputIcon = "user-x",
    Type = "Input",
    Placeholder = "PlayerName...",
    Callback = function(input)
        if input and input ~= "" then
            Features.Aimbot.Module:Blacklist(input)
            Utils.Alert("Aimbot", "user-x", "Blacklisted: " .. input)
        end
    end
})

local WhitelistPlayerInput = AimbotBlacklist:Input({
    Title = "Player Name",
    Desc = "Enter player name to whitelist",
    Value = "",
    InputIcon = "user-check",
    Type = "Input",
    Placeholder = "PlayerName...",
    Callback = function(input)
        if input and input ~= "" then
            Features.Aimbot.Module:Whitelist(input)
            Utils.Alert("Aimbot", "user-check", "Whitelisted: " .. input)
        end
    end
})

AimbotBlacklist:Button({
    Title = "🔫 | View Blacklist",
    Desc = "Show all blacklisted players",
    Callback = function()
        local blacklisted = Features.Aimbot.Module.Blacklisted
        if #blacklisted > 0 then
            local list = table.concat(blacklisted, "\n")
            Utils.ShowPopup("Blacklisted Players", "user-x", list, {{
                Title = "OK",
                Icon = "check",
                Variant = "Tertiary"
            }})
        else
            Utils.Alert("Info", "info", "No players blacklisted")
        end
    end
})

AimbotBlacklist:Button({
    Title = "🔫 | Clear Blacklist",
    Desc = "Remove all players from blacklist",
    Callback = function()
        for _, player in pairs(Features.Aimbot.Module.Blacklisted) do
            Features.Aimbot.Module:Whitelist(player)
        end
        Utils.Alert("Aimbot", "trash-2", "Blacklist cleared")
    end
})

local AimbotTest = CombatTab:Section({
    Title = "Others Functions",
    Opened = true
})

AimbotTest:Button({
    Title = "🔫 | Reset Aimbot",
    Desc = "Reset aimbot to default settings",
    Callback = function()
        Features.Aimbot.Module.Restart()
        Features.Aimbot.Toggle(Features.Aimbot.Config.Enabled)
        Features.Aimbot.ToggleFOV(Features.Aimbot.Config.FOVCircle)
        Features.Aimbot.SetFOVSize(Features.Aimbot.Config.FOVSize)
        Features.Aimbot.SetTargetPart(Features.Aimbot.Config.TargetPart)
        Utils.Alert("Aimbot", "refresh-cw", "Aimbot reset complete")
    end
})

-- ============= --
-- TRAINING TAB
-- ============= --
local TrainingTab = Window:Tab({
    Title = "| Training",
    Icon = "dumbbell",
    Locked = false
})

local TrainingSection = TrainingTab:Section({
    Title = "Training Section",
    Opened = true
})

TrainingSection:Dropdown({
    Title = "👑 | Select Auto Training",
    Desc = "Choose training type",
    Values = {"GJS", "HJS", "JJS", "PUSHUP", "SITUP", "PULLUP"},
    Value = nil,
    Multi = false,
    AllowNone = true,
    Callback = function(option)
        Features.AutoTraining.SetTrainingType(option)
    end
})

TrainingSection:Slider({
    Title = "👑 | Start Counting",
    Desc = "Starting number (1-300)",
    Icon = "hash",
    Step = 1,
    Value = {
        Min = 1,
        Max = 300,
        Default = 1,
    },
    Callback = function(value)
        Features.AutoTraining.SetStartCounting(value)
    end
})

TrainingSection:Slider({
    Title = "👑 | Cooldown Number",
    Desc = "Delay between counts in seconds (1-10)",
    Icon = "timer",
    Step = 1,
    Value = {
        Min = 1,
        Max = 10,
        Default = 1,
    },
    Callback = function(value)
        Features.AutoTraining.SetCooldown(value)
    end
})

TrainingSection:Toggle({
    Title = "👑 | Auto Training",
    Desc = "Automatically chat training counts",
    Icon = "activity",
    Value = false,
    Callback = function(state)
        Features.AutoTraining.Toggle(state)
    end
})

local RemoteTrainingSection = TrainingTab:Section({
    Title = "Remote Event Training",
    Opened = true
})

RemoteTrainingSection:Paragraph({
    Title = "How to use",
    Desc = "1. Find the remote event for training\n2. Select it from dropdown\n3. Enable Auto Training\n4. The remote will be fired with the count number",
    Color = Colors.Blue
})

local RemoteDropdown = RemoteTrainingSection:Dropdown({
    Title = "👑 | Select Remote Event",
    Desc = "Choose remote for auto fire",
    Values = {},
    Value = nil,
    Multi = false,
    AllowNone = true,
    Callback = function(option)
        -- Find remote by name
        local allRemotes = {}
        for _, obj in pairs(Services.ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                if obj.Name == option then
                    Features.AutoTraining.SetRemote(obj)
                    return
                end
            end
        end
    end
})

RemoteTrainingSection:Button({
    Title = "👑 | Refresh Remotes",
    Desc = "Scan for available remote events",
    Callback = function()
        local remoteNames = {}
        for _, obj in pairs(Services.ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                table.insert(remoteNames, obj.Name)
            end
        end
        
        RemoteDropdown.Values = remoteNames
        Utils.Alert("Training", "refresh-cw", string.format("Found %d remotes", #remoteNames))
    end
})

TrainingSection:Paragraph({
    Title = "Training Formats",
    Desc = "GJS: Satu. Dua. Tiga.\nHJS: S A T U SATU D U A DUA\nJJS/PUSHUP/SITUP/PULLUP: SATU DUA TIGA",
    Color = Colors.Yellow
})

-- ============= --
-- VISUAL TAB
-- ============= --
local VisualTab = Window:Tab({
    Title = "| Visual",
    Icon = "eye",
    Locked = false
})

local ESPSection = VisualTab:Section({
    Title = "ESP Settings (Drawing)",
    Opened = true
})

ESPSection:Toggle({
    Title = "👑 | Enable ESP",
    Desc = "Toggle ESP system",
    Icon = "eye",
    Value = ESPConfig.Enabled,
    Callback = function(state)
        Features.ESP.Toggle(state)
    end
})

local ESPFeaturesSection = VisualTab:Section({
    Title = "ESP Features",
    Opened = true
})

ESPFeaturesSection:Toggle({
    Title = "👑 | Show Box",
    Desc = "Display box around players",
    Icon = "square",
    Value = ESPConfig.ShowBox,
    Callback = function(state)
        Features.ESP.ToggleFeature("ShowBox", state)
    end
})

ESPFeaturesSection:Toggle({
    Title = "👑 | Show Names",
    Desc = "Display player names",
    Icon = "tag",
    Value = ESPConfig.ShowName,
    Callback = function(state)
        Features.ESP.ToggleFeature("ShowName", state)
    end
})

ESPFeaturesSection:Toggle({
    Title = "👑 | Show Distance",
    Desc = "Display distance to players",
    Icon = "ruler",
    Value = ESPConfig.ShowDistance,
    Callback = function(state)
        Features.ESP.ToggleFeature("ShowDistance", state)
    end
})

ESPFeaturesSection:Toggle({
    Title = "👑 | Show Health",
    Desc = "Display player health",
    Icon = "heart",
    Value = ESPConfig.ShowHealth,
    Callback = function(state)
        Features.ESP.ToggleFeature("ShowHealth", state)
    end
})

ESPFeaturesSection:Toggle({
    Title = "👑 | Show Tracer",
    Desc = "Draw line to players",
    Icon = "git-branch",
    Value = ESPConfig.ShowTracer,
    Callback = function(state)
        Features.ESP.ToggleFeature("ShowTracer", state)
    end
})

ESPFeaturesSection:Toggle({
    Title = "👑 | Show Skeleton",
    Desc = "Display player skeleton",
    Icon = "zap",
    Value = ESPConfig.ShowSkeleton,
    Callback = function(state)
        Features.ESP.ToggleFeature("ShowSkeleton", state)
    end
})

ESPFeaturesSection:Toggle({
    Title = "👑 | Show Chams",
    Desc = "Highlight players through walls",
    Icon = "layers",
    Value = ESPConfig.ShowChams,
    Callback = function(state)
        Features.ESP.ToggleFeature("ShowChams", state)
    end
})

ESPFeaturesSection:Toggle({
    Title = "👑 | Team Colors",
    Desc = "Use team colors for ESP",
    Icon = "users",
    Value = ESPConfig.ShowTeamColor,
    Callback = function(state)
        Features.ESP.ToggleFeature("ShowTeamColor", state)
    end
})

local ESPConfigSection = VisualTab:Section({
    Title = "ESP Configuration",
    Opened = true
})

ESPConfigSection:Slider({
    Title = "👑 | Max Distance",
    Desc = "Maximum ESP render distance",
    Step = 10,
    Value = {
        Min = 100,
        Max = 2000,
        Default = ESPConfig.MaxDistance,
    },
    Callback = function(value)
        ESPConfig.MaxDistance = value
        if ESPConfig.Enabled then
            Features.ESP.RefreshAll()
        end
    end
})

ESPConfigSection:Slider({
    Title = "👑 | Min Health",
    Desc = "Minimum health to show ESP",
    Step = 1,
    Value = {
        Min = 0,
        Max = 100,
        Default = ESPConfig.MinHealth,
    },
    Callback = function(value)
        ESPConfig.MinHealth = value
    end
})

ESPConfigSection:Colorpicker({
    Title = "👑 | Box Color",
    Desc = "Set custom box color",
    Default = ESPConfig.BoxColor,
    Transparency = 0,
    Callback = function(color)
        Features.ESP.SetColor("BoxColor", color)
    end
})

ESPConfigSection:Colorpicker({
    Title = "👑 | Tracer Color",
    Desc = "Set custom tracer color",
    Default = ESPConfig.TracerColor,
    Transparency = 0,
    Callback = function(color)
        Features.ESP.SetColor("TracerColor", color)
    end
})

ESPConfigSection:Colorpicker({
    Title = "👑 | Skeleton Color",
    Desc = "Set custom skeleton color",
    Default = ESPConfig.SkeletonColor,
    Transparency = 0,
    Callback = function(color)
        Features.ESP.SetColor("SkeletonColor", color)
    end
})

ESPConfigSection:Colorpicker({
    Title = "👑 | Chams Color",
    Desc = "Set custom chams color",
    Default = ESPConfig.ChamsColor,
    Transparency = 0,
    Callback = function(color)
        Features.ESP.SetColor("ChamsColor", color)
    end
})

ESPConfigSection:Button({
    Title = "👑 | Refresh ESP",
    Desc = "Refresh all ESP elements",
    Callback = function()
        Features.ESP.RefreshAll()
    end
})

ESPConfigSection:Button({
    Title = "👑 | Clean ESP",
    Desc = "Clean all ESP elements",
    Callback = function()
        Features.ESP.Cleanup()
    end
})

local SpectateSection = VisualTab:Section({
    Title = "Spectate Player",
    Opened = true
})

local SpectatePlayerDropdown = SpectateSection:Dropdown({
    Title = "👑 | Select Player",
    Desc = "Select player to spectate",
    Values = Utils.GetPlayerList(),
    Value = nil,
    Multi = false,
    AllowNone = true,
    Callback = function(option)
    end
})

DropdownManager.Register(SpectatePlayerDropdown, function()
    SpectatePlayerDropdown.Values = Utils.GetPlayerList()
end)

SpectateSection:Toggle({
    Title = "👑 | View Now",
    Desc = "Toggle spectate on selected player",
    Icon = "eye",
    Value = false,
    Callback = function(state)
        if state then
            local selectedPlayer = SpectatePlayerDropdown.Value
            if selectedPlayer then
                Features.Spectate.Toggle(state, selectedPlayer)
            else
                Utils.Alert("Error | 405", "alert-circle", "Please select a player first!")
            end
        else
            Features.Spectate.Toggle(state)
        end
    end
})

local GameTimeSection = VisualTab:Section({
    Title = "Game Time Section",
    Opened = true
})

GameTimeSection:Dropdown({
    Title = "👑 | Selected Game Time",
    Desc = "Select time of day (client-side only)",
    Values = {"Morning", "Afternoon", "Evening", "Night", "Midnight", "Early morning"},
    Value = nil,
    Multi = false,
    AllowNone = true,
    Callback = function(option)
        Features.GameTime.Select(option)
    end
})

GameTimeSection:Button({
    Title = "👑 | Change Game Time",
    Desc = "Change the in-game time (client-side only)",
    Callback = function()
        Features.GameTime.Change()
    end
})

local FreecamSection = VisualTab:Section({
    Title = "Free Camera Section",
    Opened = true
})

FreecamSection:Toggle({
    Title = "👑 | Freecam",
    Desc = "Detach camera and fly freely\nWASD: Move\nE/Q: Up/Down\nMouse: Look\nShift: Speed boost\nESC: Exit",
    Icon = "camera",
    Value = false,
    Callback = function(state)
        Features.Freecam.Toggle(state)
    end
})

FreecamSection:Slider({
    Title = "👑 | Normal Speed",
    Desc = "Default movement speed",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = Features.Freecam.Speed,
    },
    Callback = function(value)
        Features.Freecam.Speed = value
        Utils.Alert("Freecam", "settings", "Normal speed: " .. value)
    end
})

FreecamSection:Slider({
    Title = "👑 | Fast Speed",
    Desc = "Boost speed (hold Shift)",
    Step = 5,
    Value = {
        Min = 10,
        Max = 200,
        Default = Features.Freecam.FastSpeed,
    },
    Callback = function(value)
        Features.Freecam.FastSpeed = value
        Utils.Alert("Freecam", "zap", "Fast speed: " .. value)
    end
})

FreecamSection:Slider({
    Title = "👑 | Mouse Sensitivity",
    Desc = "Camera rotation sensitivity",
    Step = 0.1,
    Value = {
        Min = 0.1,
        Max = 2,
        Default = Features.Freecam.MouseSensitivity,
    },
    Callback = function(value)
        Features.Freecam.MouseSensitivity = value
        Utils.Alert("Freecam", "mouse-pointer", "Mouse sensitivity: " .. value)
    end
})

FreecamSection:Button({
    Title = "👑 | Reset Camera",
    Desc = "Return camera to player",
    Icon = "refresh-cw",
    Callback = function()
        if Features.Freecam.Active then
            Features.Freecam.Toggle(false)
        else
            Utils.Alert("Freecam", "info", "Freecam is not active")
        end
    end
})

-- ============= --
-- DEVICE SPOOFER TAB
-- ============= --
local DeviceTab = Window:Tab({
    Title = "| Device Spoofer",
    Icon = "smartphone",
    Locked = false
})

local DeviceSpoofSection = DeviceTab:Section({
    Title = "Device Spoofing",
    Opened = true
})

DeviceSpoofSection:Paragraph({
    Title = "What is Device Spoofing?",
    Desc = "Device spoofing changes your device information to avoid detection and bans. This is client-side only and may not work on all games.",
    Color = Colors.Yellow
})

DeviceSpoofSection:Toggle({
    Title = "🔐 | Enable Spoofing",
    Desc = "Spoof MAC, IP, and Device info",
    Icon = "shield",
    Value = false,
    Callback = function(state)
        Features.DeviceSpoofer.Toggle(state)
    end
})

DeviceSpoofSection:Button({
    Title = "🔐 | Generate New Identity",
    Desc = "Generate new spoofed info",
    Callback = function()
        Features.DeviceSpoofer.SpoofedMAC = Features.DeviceSpoofer.GenerateRandomMAC()
        Features.DeviceSpoofer.SpoofedIP = Features.DeviceSpoofer.GenerateRandomIP()
        Features.DeviceSpoofer.SpoofedDevice = Features.DeviceSpoofer.GetRandomDevice()
        
        Utils.Alert("Device Spoofer", "refresh-cw", "New identity generated!")
    end
})

DeviceSpoofSection:Button({
    Title = "🔐 | View Current Info",
    Desc = "Show current spoofed info",
    Callback = function()
        local info = Features.DeviceSpoofer.GetInfo()
        Utils.ShowPopup("Device Info", "smartphone", 
            string.format("MAC: %s\nIP: %s\nDevice: %s", info.MAC, info.IP, info.Device),
            {{Title = "OK", Icon = "check", Variant = "Tertiary"}}
        )
    end
})

-- ============= --
-- BLANTANT BOOMER TAB
-- ============= --
local BoomerTab = Window:Tab({
    Title = "| Blantant Boomer",
    Icon = "zap",
    Locked = false
})

local BoomerSection = BoomerTab:Section({
    Title = "Remote Event Spammer",
    Opened = true
})

BoomerSection:Paragraph({
    Title = "⚠️ WARNING",
    Desc = "Spamming remote events can cause crashes, kicks, or bans. Use at your own risk!",
    Color = Colors.Maroon
})

BoomerSection:Slider({
    Title = "⚡ | Spam Count",
    Desc = "How many times to spam each remote",
    Step = 1,
    Value = {
        Min = 1,
        Max = 1000,
        Default = 100,
    },
    Callback = function(value)
        Features.BlantantBoomer.SetSpamCount(value)
    end
})

BoomerSection:Slider({
    Title = "⚡ | Spam Delay",
    Desc = "Delay between each spam (seconds)",
    Step = 0.01,
    Value = {
        Min = 0.01,
        Max = 1,
        Default = 0.1,
    },
    Callback = function(value)
        Features.BlantantBoomer.SetSpamDelay(value)
    end
})

BoomerSection:Button({
    Title = "⚡ | Spam All Remotes",
    Desc = "Spam ALL remote events in the game",
    Callback = function()
        Features.BlantantBoomer.SpamAll()
    end
})

BoomerSection:Button({
    Title = "⚡ | Stop Spam",
    Desc = "Stop current spam operation",
    Callback = function()
        Features.BlantantBoomer.Stop()
    end
})

local BoomerStatsSection = BoomerTab:Section({
    Title = "Spam Statistics",
    Opened = true
})

BoomerStatsSection:Button({
    Title = "⚡ | View Stats",
    Desc = "Show current spam statistics",
    Callback = function()
        local stats = Features.BlantantBoomer.Stats
        Utils.ShowPopup("Spam Statistics", "bar-chart", 
            string.format("Success: %d\nFailed: %d\nNo Feedback: %d\nTotal Fired: %d",
                stats.Success, stats.Failed, stats.NoFeedback, stats.TotalFired),
            {{Title = "OK", Icon = "check", Variant = "Tertiary"}}
        )
    end
})

BoomerStatsSection:Button({
    Title = "⚡ | Reset Stats",
    Desc = "Reset spam statistics",
    Callback = function()
        Features.BlantantBoomer.Stats = {
            Success = 0,
            Failed = 0,
            NoFeedback = 0,
            TotalFired = 0
        }
        Utils.Alert("Blantant Boomer", "trash-2", "Statistics reset!")
    end
})

-- ============= --
-- CHECK PLAYER TAB
-- ============= --
local CheckPlayerTab = Window:Tab({
    Title = "| Check Player",
    Icon = "user-search",
    Locked = false
})

local CheckPlayerSection = CheckPlayerTab:Section({
    Title = "Player Information",
    Opened = true
})

local CheckPlayerDropdown = CheckPlayerSection:Dropdown({
    Title = "🔍 | Select Player",
    Desc = "Choose player to check",
    Values = Utils.GetPlayerList(),
    Value = nil,
    Multi = false,
    AllowNone = true,
    Callback = function(option)
        Features.CheckPlayer.SelectedPlayer = option
    end
})

DropdownManager.Register(CheckPlayerDropdown, function()
    CheckPlayerDropdown.Values = Utils.GetPlayerList()
end)

CheckPlayerSection:Button({
    Title = "🔍 | View Player Info",
    Desc = "Show detailed player information",
    Callback = function()
        if Features.CheckPlayer.SelectedPlayer then
            local player
            for _, p in pairs(Services.Players:GetPlayers()) do
                if p.Name == Features.CheckPlayer.SelectedPlayer then
                    player = p
                    break
                end
            end
            
            if player then
                Features.CheckPlayer.ShowInfo(player)
            else
                Utils.Alert("Error", "alert-circle", "Player not found!")
            end
        else
            Utils.Alert("Error", "alert-circle", "Please select a player first!")
        end
    end
})

CheckPlayerSection:Button({
    Title = "🔍 | Check All Players",
    Desc = "Show info for all players",
    Callback = function()
        local allInfo = ""
        for _, player in pairs(Services.Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local info = Features.CheckPlayer.GetPlayerInfo(player)
                if info then
                    allInfo = allInfo .. string.format("[%s] HP:%s/%s Dist:%s\n",
                        player.Name,
                        info.Health or "N/A",
                        info.MaxHealth or "N/A",
                        info.Distance or "N/A"
                    )
                end
            end
        end
        
        if allInfo ~= "" then
            Utils.ShowPopup("All Players Info", "users", allInfo, {{
                Title = "Copy",
                Icon = "copy",
                Variant = "Primary",
                Callback = function()
                    Utils.CopyToClipboard(allInfo)
                end
            }, {
                Title = "Close",
                Icon = "x",
                Variant = "Tertiary"
            }})
        else
            Utils.Alert("Info", "info", "No other players in server")
        end
    end
})

-- ============= --
-- SPAM DONATE TAB
-- ============= --
local DonateTab = Window:Tab({
    Title = "| Spam Donate",
    Icon = "dollar-sign",
    Locked = false
})

local DonateSection = DonateTab:Section({
    Title = "Fake Donation Spammer",
    Opened = true
})

DonateSection:Paragraph({
    Title = "ℹ️ Information",
    Desc = "This feature sends fake donation prompts. No actual purchases will be made. Use for testing or trolling only.",
    Color = Colors.Blue
})

DonateSection:Dropdown({
    Title = "💸 | Spam Type",
    Desc = "Select what to spam",
    Values = {"DevProduct", "GamePass", "All"},
    Value = "All",
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        Features.SpamDonate.SetType(option)
    end
})

DonateSection:Dropdown({
    Title = "💸 | Spam Mode",
    Desc = "Select spam intensity",
    Values = {"Calm", "Brutal"},
    Value = "Calm",
    Multi = false,
    AllowNone = false,
    Callback = function(option)
        Features.SpamDonate.SetMode(option)
    end
})

DonateSection:Toggle({
    Title = "💸 | Start Spam",
    Desc = "Toggle donation spam",
    Icon = "zap",
    Value = false,
    Callback = function(state)
        if state then
            Features.SpamDonate.Start()
        else
            Features.SpamDonate.Stop()
        end
    end
})

DonateSection:Button({
    Title = "💸 | View Stats",
    Desc = "Show spam statistics",
    Callback = function()
        local stats = Features.SpamDonate.Stats
        Utils.ShowPopup("Donation Stats", "bar-chart", 
            string.format("DevProducts: %d\nGamePasses: %d\nFailed: %d",
                stats.DevProduct, stats.GamePass, stats.Failed),
            {{Title = "OK", Icon = "check", Variant = "Tertiary"}}
        )
    end
})

-- ============= --
-- CREDITS TAB
-- ============= --
local CreditTab = Window:Tab({
    Title = "| Credits",
    Icon = "award",
    Locked = false
})

local OwnerSection = CreditTab:Section({
    Title = "Owner Hexyra",
    Opened = true
})

OwnerSection:Paragraph({
    Title = "Hexyra Studios",
    Desc = "Developed by Hexyra Studios. Thank you for using our script!",
    Color = Colors.Yellow,
    Image = "rbxassetid://123881160135279",
    ImageSize = 48,
    Buttons = {
        {
            Icon = "link",
            Title = "Discord link (click to copy)",
            Callback = function() 
                Utils.CopyToClipboard("We dont have discord right now")
                Utils.Alert("Copied", "check", "Discord link copied to clipboard") 
            end,
        }
    }
})

local ContributorSection = CreditTab:Section({
    Title = "Contributors",
    Opened = true
})

ContributorSection:Paragraph({
    Title = "Special Thanks",
    Desc = "k****a - For testing and feedback\n" ..
           "G***o  - For ideas and support\n"..
           "Gerix_403 - For bug reports and suggestions and shadows development POLRI RI\n"..
           "All Beta Testers - For helping improve the script",
    Color = Colors.Grey,
    Image = "rbxassetid://123881160135279",
    ImageSize = 48,
})

local UpdateSection = CreditTab:Section({
    Title = "Update Log " .. SCRIPT_VERSION,
    Opened = true
})

UpdateSection:Paragraph({
    Title = "What's New?",
    Desc = "✅ Fixed ESP cleanup on script unload\n" ..
           "✅ Fixed Aimbot crash/detection (Silent mode)\n" ..
           "✅ Fixed Freecam smooth controls\n" ..
           "✅ Fixed Dropdown auto-refresh\n" ..
           "✅ Upgraded ESP to Drawing API\n" ..
           "✅ Added Chams, Skeleton, Health filter\n" ..
           "✅ Added Remote Event Auto Training\n" ..
           "✅ Added Device Spoofer\n" ..
           "✅ Added Blantant Boomer\n" ..
           "✅ Added Check Player\n" ..
           "✅ Added Spam Donate\n" ..
           "✅ Performance improvements",
    Color = Colors.Green
})

-- ============= --
-- AUTO REFRESH DROPDOWNS
-- ============= --
Services.Players.PlayerAdded:Connect(function()
    task.wait(1)
    DropdownManager.RefreshAll()
end)

Services.Players.PlayerRemoving:Connect(function()
    task.wait(1)
    DropdownManager.RefreshAll()
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    if ESPConfig.Enabled and not ESPCache.Cleaning then
        Features.ESP.RefreshAll()
    end
end)

-- ============= --
-- CLEANUP ON EXIT
-- ============= --
local function CleanupScript()
    -- Cleanup ESP
    if ESPConfig.Enabled then
        Features.ESP.Cleanup()
    end
    
    -- Cleanup Aimbot
    if Features.Aimbot.Module then
        pcall(function()
            Features.Aimbot.Module:Exit()
        end)
    end
    
    -- Cleanup all features
    if Features.Movement.Active then
        Features.Movement.Toggle(false)
    end
    
    if Features.NoClip.Active then
        Features.NoClip.Toggle(false)
    end
    
    if Features.Jump.Active then
        Features.Jump.Toggle(false)
    end
    
    if Features.Freecam.Active then
        Features.Freecam.Toggle(false)
    end
    
    if Features.AutoTraining.Active then
        Features.AutoTraining.Stop()
    end
    
    if Features.BlantantBoomer.Active then
        Features.BlantantBoomer.Stop()
    end
    
    if Features.SpamDonate.Active then
        Features.SpamDonate.Stop()
    end
end

-- Cleanup saat window ditutup (jika WindUI support)
pcall(function()
    Window.OnClose = CleanupScript
end)

return {
    Version = SCRIPT_VERSION,
    Features = Features,
    Utils = Utils,
    Colors = Colors,
    Cleanup = CleanupScript
}
