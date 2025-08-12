-- Universal Script - Xeon Game Script
-- Auto-loaded by GameSupport - no manual setup needed

-- Load GUI Library
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/ProphecySkondo/21ffde15b8ca1b5a058d328efceb7f47/raw/3cb39b75d65147a926d4fe02a7b3437e30209915/gistfile1.txt"))()

getgenv().namehub = "Xeon Universal"

-- Universal Functions
local function universalFly()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    if _G.UniversalFlying then
        _G.UniversalFlying = false
        if _G.FlyBodyVelocity then
            _G.FlyBodyVelocity:Destroy()
            _G.FlyBodyVelocity = nil
        end
        humanoid.PlatformStand = false
        return
    end
    
    _G.UniversalFlying = true
    _G.FlyBodyVelocity = Instance.new("BodyVelocity")
    _G.FlyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    _G.FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    _G.FlyBodyVelocity.Parent = rootPart
    humanoid.PlatformStand = true
    
    spawn(function()
        local camera = workspace.CurrentCamera
        local UserInputService = game:GetService("UserInputService")
        
        while _G.UniversalFlying do
            local moveVector = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + camera.CoordinateFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - camera.CoordinateFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - camera.CoordinateFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + camera.CoordinateFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVector = moveVector + Vector3.new(0, -1, 0)
            end
            
            _G.FlyBodyVelocity.Velocity = moveVector * 50
            task.wait()
        end
    end)
end

local function universalNoclip()
    if _G.UniversalNoclip then
        _G.UniversalNoclip = false
        return
    end
    
    _G.UniversalNoclip = true
    spawn(function()
        while _G.UniversalNoclip do
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
            task.wait()
        end
    end)
end

local function universalSpeed(speed)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end

local function universalJumpPower(power)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = power
        end
    end
end

-- Initialize GUI
local main = Library.new()

-- Main Tab
local mainTab = main.create_tab('Universal')

mainTab.create_title({
    name = 'Movement',
    section = 'left'
})

mainTab.create_toggle({
    name = 'Fly',
    flag = 'universal_fly',
    section = 'left',
    enabled = false,
    
    callback = function(state)
        universalFly()
    end
})

mainTab.create_toggle({
    name = 'Noclip',
    flag = 'universal_noclip',
    section = 'left',
    enabled = false,
    
    callback = function(state)
        universalNoclip()
    end
})

mainTab.create_slider({
    name = 'Walk Speed',
    flag = 'walk_speed',
    section = 'left',
    
    value = 16,
    minimum_value = 16,
    maximum_value = 500,
    
    callback = function(value)
        universalSpeed(value)
    end
})

mainTab.create_slider({
    name = 'Jump Power',
    flag = 'jump_power',
    section = 'left',
    
    value = 50,
    minimum_value = 50,
    maximum_value = 500,
    
    callback = function(value)
        universalJumpPower(value)
    end
})

mainTab.create_title({
    name = 'Player',
    section = 'right'
})

mainTab.create_toggle({
    name = 'Infinite Health',
    flag = 'infinite_health',
    section = 'right',
    enabled = false,
    
    callback = function(state)
        local player = game.Players.LocalPlayer
        if state then
            _G.InfiniteHealth = true
            spawn(function()
                while _G.InfiniteHealth do
                    local character = player.Character
                    if character then
                        local humanoid = character:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.Health = humanoid.MaxHealth
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            _G.InfiniteHealth = false
        end
    end
})

mainTab.create_toggle({
    name = 'Infinite Stamina',
    flag = 'infinite_stamina',
    section = 'right',
    enabled = false,
    
    callback = function(state)
        local player = game.Players.LocalPlayer
        if state then
            _G.InfiniteStamina = true
            spawn(function()
                while _G.InfiniteStamina do
                    local character = player.Character
                    if character then
                        local humanoid = character:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid:SetAttribute("Stamina", 100)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            _G.InfiniteStamina = false
        end
    end
})

-- Utility Tab
local utilityTab = main.create_tab('Utility')

utilityTab.create_title({
    name = 'Game Info',
    section = 'left'
})

local gameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
local executor = identifyexecutor and identifyexecutor() or 'Unknown'

utilityTab.create_dropdown({
    name = 'Game Name',
    flag = 'game_name',
    section = 'left',
    
    option = gameInfo.Name:sub(1, 20),
    options = {gameInfo.Name:sub(1, 20)},
    
    callback = function(value) end
})

utilityTab.create_dropdown({
    name = 'Place ID',
    flag = 'place_id',
    section = 'left',
    
    option = tostring(game.PlaceId),
    options = {tostring(game.PlaceId)},
    
    callback = function(value) end
})

utilityTab.create_dropdown({
    name = 'Executor',
    flag = 'executor_info',
    section = 'left',
    
    option = executor,
    options = {executor},
    
    callback = function(value) end
})

utilityTab.create_title({
    name = 'Reset Functions',
    section = 'right'
})

utilityTab.create_toggle({
    name = 'Reset All Toggles',
    flag = 'reset_toggles',
    section = 'right',
    enabled = false,
    
    callback = function(state)
        if state then
            _G.UniversalFlying = false
            _G.UniversalNoclip = false
            _G.InfiniteHealth = false
            _G.InfiniteStamina = false
            
            if _G.FlyBodyVelocity then
                _G.FlyBodyVelocity:Destroy()
                _G.FlyBodyVelocity = nil
            end
            
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                    humanoid.PlatformStand = false
                end
                
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            
            Library.Flags['reset_toggles'] = false
        end
    end
})

return main
