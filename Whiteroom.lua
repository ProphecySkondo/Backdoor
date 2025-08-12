-- White Room Game - Xeon Game Script
-- Place ID: 13278749064
-- Auto-loaded by GameSupport - no manual setup needed

-- Load GUI Library
local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/ProphecySkondo/21ffde15b8ca1b5a058d328efceb7f47/raw/3cb39b75d65147a926d4fe02a7b3437e30209915/gistfile1.txt"))()

getgenv().namehub = "Xeon - White Room"

-- Service References
local __cloneref = cloneref or function(obj) return obj end
local __getclass = function(obj)
    if typeof(obj) == "string" then
        return __cloneref(game:GetService(tostring(obj)))
    end
end

local __services = {
    RbxAnalyticsService = __getclass("RbxAnalyticsService"),
    MarketplaceService = __getclass("MarketplaceService"),
    ReplicatedStorage = __getclass("ReplicatedStorage"),
    RunService = __getclass("RunService"),
    Workspace = __getclass("Workspace"),
    Players = __getclass("Players"),
    TeleportService = __getclass("TeleportService"),
    UserInputService = __getclass("UserInputService"),
    TweenService = __getclass("TweenService"),
    Lighting = __getclass("Lighting"),
    SoundService = __getclass("SoundService")
}

local __player = __services.Players.LocalPlayer
local __replicatedstorage = __services.ReplicatedStorage

-- Remote Events
local __remotes = {
    Bata = __replicatedstorage:FindFirstChild("Bata"),
    Knif = __replicatedstorage:FindFirstChild("Knif"),
    Whack = __replicatedstorage:FindFirstChild("Whack"),
    Room = __replicatedstorage:FindFirstChild("Room"),
    Bear = __replicatedstorage:FindFirstChild("Bear"),
    Cola = __replicatedstorage:FindFirstChild("Cola"),
    Cosmo = __replicatedstorage:FindFirstChild("Cosmo"),
    Donda = __replicatedstorage:FindFirstChild("Donda"),
}

-- Main API
local WhiteRoomAPI = {
    Player = {},
    Tools = {},
    Remotes = {},
    Teleport = {},
    Environment = {},
    Exploit = {},
    Utils = {}
}

-- Player Functions
function WhiteRoomAPI.Player:GetCharacter()
    return __player.Character or __player.CharacterAdded:Wait()
end

function WhiteRoomAPI.Player:GetHumanoid()
    local character = self:GetCharacter()
    return character:FindFirstChild("Humanoid")
end

function WhiteRoomAPI.Player:GetRootPart()
    local character = self:GetCharacter()
    return character:FindFirstChild("HumanoidRootPart")
end

function WhiteRoomAPI.Player:SetWalkSpeed(speed)
    local humanoid = self:GetHumanoid()
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

function WhiteRoomAPI.Player:SetJumpPower(power)
    local humanoid = self:GetHumanoid()
    if humanoid then
        humanoid.JumpPower = power
    end
end

function WhiteRoomAPI.Player:Fly(enabled)
    if enabled then
        if _G.WhiteRoomFlying then return end
        
        _G.WhiteRoomFlying = true
        local rootPart = self:GetRootPart()
        local humanoid = self:GetHumanoid()
        
        if not rootPart or not humanoid then return end
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        humanoid.PlatformStand = true
        
        spawn(function()
            local camera = __services.Workspace.CurrentCamera
            while _G.WhiteRoomFlying and rootPart and rootPart.Parent do
                local moveVector = Vector3.new(0, 0, 0)
                
                if __services.UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveVector = moveVector + camera.CoordinateFrame.LookVector
                end
                if __services.UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveVector = moveVector - camera.CoordinateFrame.LookVector
                end
                if __services.UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveVector = moveVector - camera.CoordinateFrame.RightVector
                end
                if __services.UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveVector = moveVector + camera.CoordinateFrame.RightVector
                end
                if __services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveVector = moveVector + Vector3.new(0, 1, 0)
                end
                if __services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveVector = moveVector + Vector3.new(0, -1, 0)
                end
                
                bodyVelocity.Velocity = moveVector * 50
                task.wait()
            end
        end)
        
        _G.WhiteRoomFlyCleanup = function()
            if bodyVelocity then bodyVelocity:Destroy() end
            if humanoid then humanoid.PlatformStand = false end
        end
    else
        _G.WhiteRoomFlying = false
        if _G.WhiteRoomFlyCleanup then
            _G.WhiteRoomFlyCleanup()
            _G.WhiteRoomFlyCleanup = nil
        end
    end
end

function WhiteRoomAPI.Player:Noclip(enabled)
    if enabled then
        _G.WhiteRoomNoclip = true
        spawn(function()
            while _G.WhiteRoomNoclip do
                local character = self:GetCharacter()
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
    else
        _G.WhiteRoomNoclip = false
        local character = self:GetCharacter()
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Tools Functions
function WhiteRoomAPI.Tools:GetAllTools()
    local tools = {}
    for _, obj in pairs(__services.Workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            table.insert(tools, obj)
        end
    end
    return tools
end

function WhiteRoomAPI.Tools:GetPlayerTools(player)
    player = player or __player
    local tools = {}
    
    if player.Backpack then
        for _, tool in pairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(tools, tool)
            end
        end
    end
    
    if player.Character then
        for _, tool in pairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(tools, tool)
            end
        end
    end
    
    return tools
end

function WhiteRoomAPI.Tools:GrabAllTools()
    local character = WhiteRoomAPI.Player:GetCharacter()
    if not character then return end
    
    local tools = self:GetAllTools()
    for _, tool in pairs(tools) do
        if tool.Parent ~= __player.Backpack and tool.Parent ~= character then
            tool.Parent = __player.Backpack
        end
    end
end

function WhiteRoomAPI.Tools:DropAllTools()
    local tools = self:GetPlayerTools()
    for _, tool in pairs(tools) do
        if tool.Parent == __player.Character then
            tool.Parent = __services.Workspace
        elseif tool.Parent == __player.Backpack then
            tool.Parent = __services.Workspace
        end
    end
end

function WhiteRoomAPI.Tools:DeleteAllTools()
    local tools = self:GetPlayerTools()
    for _, tool in pairs(tools) do
        tool:Destroy()
    end
end

-- Remote Functions
function WhiteRoomAPI.Remotes:FireRemote(remoteName, ...)
    local remote = __remotes[remoteName]
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer(...)
        return true
    end
    return false
end

function WhiteRoomAPI.Remotes:InvokeRemote(remoteName, ...)
    local remote = __remotes[remoteName]
    if remote and remote:IsA("RemoteFunction") then
        return remote:InvokeServer(...)
    end
    return nil
end

function WhiteRoomAPI.Remotes:SpamRemote(remoteName, count, delay, ...)
    local args = {...}
    count = count or 10
    delay = delay or 0.1
    
    spawn(function()
        for i = 1, count do
            self:FireRemote(remoteName, unpack(args))
            task.wait(delay)
        end
    end)
end

-- Teleport Functions
function WhiteRoomAPI.Teleport:ToPosition(position)
    local rootPart = WhiteRoomAPI.Player:GetRootPart()
    if rootPart and typeof(position) == "Vector3" then
        rootPart.CFrame = CFrame.new(position)
        return true
    end
    return false
end

function WhiteRoomAPI.Teleport:ToPlayer(player)
    if typeof(player) == "string" then
        player = __services.Players:FindFirstChild(player)
    end
    
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        return self:ToPosition(player.Character.HumanoidRootPart.Position)
    end
    return false
end

function WhiteRoomAPI.Teleport:ToPart(partName)
    local part = __services.Workspace:FindFirstChild(partName, true)
    if part and part:IsA("BasePart") then
        return self:ToPosition(part.Position + Vector3.new(0, 5, 0))
    end
    return false
end

-- Environment Functions
function WhiteRoomAPI.Environment:SetTime(time)
    __services.Lighting.TimeOfDay = tostring(time) .. ":00:00"
end

function WhiteRoomAPI.Environment:SetBrightness(brightness)
    __services.Lighting.Brightness = brightness
end

function WhiteRoomAPI.Environment:SetFogEnd(distance)
    __services.Lighting.FogEnd = distance
end

function WhiteRoomAPI.Environment:FullBright(enabled)
    if enabled then
        __services.Lighting.Brightness = 2
        __services.Lighting.ClockTime = 12
        __services.Lighting.FogEnd = 100000
        __services.Lighting.GlobalShadows = false
        __services.Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    else
        __services.Lighting.Brightness = 1
        __services.Lighting.ClockTime = 14
        __services.Lighting.FogEnd = 100000
        __services.Lighting.GlobalShadows = true
        __services.Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    end
end

-- Exploit Functions
function WhiteRoomAPI.Exploit:KillAllPlayers()
    for _, player in pairs(__services.Players:GetPlayers()) do
        if player ~= __player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
end

function WhiteRoomAPI.Exploit:FlingPlayer(player, power)
    if typeof(player) == "string" then
        player = __services.Players:FindFirstChild(player)
    end
    
    power = power or 50
    
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(
            math.random(-power, power),
            math.random(power/2, power),
            math.random(-power, power)
        )
        bodyVelocity.Parent = player.Character.HumanoidRootPart
        
        spawn(function()
            task.wait(1)
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end)
        
        return true
    end
    return false
end

function WhiteRoomAPI.Exploit:CrashServer()
    -- Safe server crash method
    for i = 1, 1000 do
        spawn(function()
            while task.wait() do
                for _, remote in pairs(__remotes) do
                    if remote and remote:IsA("RemoteEvent") then
                        remote:FireServer(string.rep("A", 1000))
                    end
                end
            end
        end)
    end
end

-- Utility Functions
function WhiteRoomAPI.Utils:GetAllPlayers()
    return __services.Players:GetPlayers()
end

function WhiteRoomAPI.Utils:GetPlayerByName(name)
    for _, player in pairs(__services.Players:GetPlayers()) do
        if player.Name:lower():find(name:lower()) then
            return player
        end
    end
    return nil
end

function WhiteRoomAPI.Utils:GetExecutor()
    return identifyexecutor and identifyexecutor() or "Unknown"
end

function WhiteRoomAPI.Utils:Notify(title, text, duration)
    duration = duration or 5
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration;
    })
end

-- Initialize GUI
local main = Library.new()

-- Movement Tab
local movementTab = main.create_tab('Movement')

movementTab.create_title({
    name = 'Player Movement',
    section = 'left'
})

movementTab.create_slider({
    name = 'Walk Speed',
    flag = 'walkspeed',
    section = 'left',
    value = 16,
    minimum_value = 16,
    maximum_value = 500,
    callback = function(value)
        WhiteRoomAPI.Player:SetWalkSpeed(value)
    end
})

movementTab.create_slider({
    name = 'Jump Power',
    flag = 'jumppower',
    section = 'left',
    value = 50,
    minimum_value = 50,
    maximum_value = 500,
    callback = function(value)
        WhiteRoomAPI.Player:SetJumpPower(value)
    end
})

movementTab.create_toggle({
    name = 'Fly',
    flag = 'fly',
    section = 'left',
    enabled = false,
    callback = function(state)
        WhiteRoomAPI.Player:Fly(state)
    end
})

movementTab.create_toggle({
    name = 'Noclip',
    flag = 'noclip',
    section = 'left',
    enabled = false,
    callback = function(state)
        WhiteRoomAPI.Player:Noclip(state)
    end
})

movementTab.create_title({
    name = 'Teleportation',
    section = 'right'
})

movementTab.create_dropdown({
    name = 'Teleport to Player',
    flag = 'tp_player',
    section = 'right',
    option = 'Select Player',
    options = {'Select Player'},
    callback = function(value)
        if value ~= 'Select Player' then
            WhiteRoomAPI.Teleport:ToPlayer(value)
        end
    end
})

-- Update player list
spawn(function()
    while task.wait(2) do
        local playerNames = {'Select Player'}
        for _, player in pairs(__services.Players:GetPlayers()) do
            if player ~= __player then
                table.insert(playerNames, player.Name)
            end
        end
        Library.Flags['tp_player'] = playerNames[1]
        -- Note: This would need library support to update dropdown options
    end
end)

movementTab.create_textbox({
    name = 'Custom Position (X,Y,Z)',
    flag = 'custom_pos',
    section = 'right',
    value = "0,50,0",
    callback = function(value)
        local coords = string.split(value, ",")
        if #coords == 3 then
            local x, y, z = tonumber(coords[1]), tonumber(coords[2]), tonumber(coords[3])
            if x and y and z then
                WhiteRoomAPI.Teleport:ToPosition(Vector3.new(x, y, z))
            end
        end
    end
})

-- Tools Tab
local toolsTab = main.create_tab('Tools')

toolsTab.create_title({
    name = 'Tool Management',
    section = 'left'
})

toolsTab.create_toggle({
    name = 'Auto Grab Tools',
    flag = 'auto_grab',
    section = 'left',
    enabled = false,
    callback = function(state)
        if state then
            _G.AutoGrabTools = true
            spawn(function()
                while _G.AutoGrabTools do
                    WhiteRoomAPI.Tools:GrabAllTools()
                    task.wait(0.5)
                end
            end)
        else
            _G.AutoGrabTools = false
        end
    end
})

toolsTab.create_toggle({
    name = 'Grab All Tools',
    flag = 'grab_tools',
    section = 'left',
    enabled = false,
    callback = function(state)
        if state then
            WhiteRoomAPI.Tools:GrabAllTools()
            Library.Flags['grab_tools'] = false
        end
    end
})

toolsTab.create_toggle({
    name = 'Drop All Tools',
    flag = 'drop_tools',
    section = 'left',
    enabled = false,
    callback = function(state)
        if state then
            WhiteRoomAPI.Tools:DropAllTools()
            Library.Flags['drop_tools'] = false
        end
    end
})

toolsTab.create_toggle({
    name = 'Delete All Tools',
    flag = 'delete_tools',
    section = 'left',
    enabled = false,
    callback = function(state)
        if state then
            WhiteRoomAPI.Tools:DeleteAllTools()
            Library.Flags['delete_tools'] = false
        end
    end
})

-- Environment Tab
local envTab = main.create_tab('Environment')

envTab.create_title({
    name = 'Lighting',
    section = 'left'
})

envTab.create_slider({
    name = 'Time of Day',
    flag = 'time',
    section = 'left',
    value = 12,
    minimum_value = 0,
    maximum_value = 24,
    callback = function(value)
        WhiteRoomAPI.Environment:SetTime(value)
    end
})

envTab.create_slider({
    name = 'Brightness',
    flag = 'brightness',
    section = 'left',
    value = 1,
    minimum_value = 0,
    maximum_value = 10,
    callback = function(value)
        WhiteRoomAPI.Environment:SetBrightness(value)
    end
})

envTab.create_toggle({
    name = 'Full Bright',
    flag = 'fullbright',
    section = 'left',
    enabled = false,
    callback = function(state)
        WhiteRoomAPI.Environment:FullBright(state)
    end
})

-- Exploits Tab
local exploitTab = main.create_tab('Exploits')

exploitTab.create_title({
    name = 'Player Exploits',
    section = 'left'
})

exploitTab.create_dropdown({
    name = 'Fling Player',
    flag = 'fling_player',
    section = 'left',
    option = 'Select Player',
    options = {'Select Player'},
    callback = function(value)
        if value ~= 'Select Player' then
            WhiteRoomAPI.Exploit:FlingPlayer(value, 50)
        end
    end
})

exploitTab.create_slider({
    name = 'Fling Power',
    flag = 'fling_power',
    section = 'left',
    value = 50,
    minimum_value = 10,
    maximum_value = 200,
    callback = function(value) end
})

exploitTab.create_title({
    name = 'Server Exploits',
    section = 'right'
})

exploitTab.create_toggle({
    name = 'Crash Server',
    flag = 'crash_server',
    section = 'right',
    enabled = false,
    callback = function(state)
        if state then
            WhiteRoomAPI.Utils:Notify("Warning", "Crashing server in 3 seconds!", 3)
            task.wait(3)
            WhiteRoomAPI.Exploit:CrashServer()
            Library.Flags['crash_server'] = false
        end
    end
})

-- Remote Spam Tab
local remoteTab = main.create_tab('Remotes')

remoteTab.create_title({
    name = 'Remote Spam',
    section = 'left'
})

local remoteNames = {}
for name, remote in pairs(__remotes) do
    if remote then
        table.insert(remoteNames, name)
    end
end

if #remoteNames > 0 then
    remoteTab.create_dropdown({
        name = 'Select Remote',
        flag = 'remote_select',
        section = 'left',
        option = remoteNames[1],
        options = remoteNames,
        callback = function(value) end
    })

    remoteTab.create_slider({
        name = 'Spam Count',
        flag = 'spam_count',
        section = 'left',
        value = 10,
        minimum_value = 1,
        maximum_value = 100,
        callback = function(value) end
    })

    remoteTab.create_slider({
        name = 'Spam Delay',
        flag = 'spam_delay',
        section = 'left',
        value = 0.1,
        minimum_value = 0.01,
        maximum_value = 1,
        callback = function(value) end
    })

    remoteTab.create_toggle({
        name = 'Start Remote Spam',
        flag = 'start_spam',
        section = 'left',
        enabled = false,
        callback = function(state)
            if state then
                local remoteName = Library.Flags['remote_select'] or remoteNames[1]
                local count = Library.Flags['spam_count'] or 10
                local delay = Library.Flags['spam_delay'] or 0.1
                
                WhiteRoomAPI.Remotes:SpamRemote(remoteName, count, delay)
                Library.Flags['start_spam'] = false
            end
        end
    })
end

-- Info Tab
local infoTab = main.create_tab('Info')

infoTab.create_title({
    name = 'Game Information',
    section = 'left'
})

infoTab.create_dropdown({
    name = 'Place ID',
    flag = 'place_id',
    section = 'left',
    option = tostring(game.PlaceId),
    options = {tostring(game.PlaceId)},
    callback = function(value) end
})

infoTab.create_dropdown({
    name = 'Players Online',
    flag = 'players_online',
    section = 'left',
    option = tostring(#__services.Players:GetPlayers()),
    options = {tostring(#__services.Players:GetPlayers())},
    callback = function(value) end
})

infoTab.create_dropdown({
    name = 'Executor',
    flag = 'executor',
    section = 'left',
    option = WhiteRoomAPI.Utils:GetExecutor(),
    options = {WhiteRoomAPI.Utils:GetExecutor()},
    callback = function(value) end
})

-- Global API Access
getgenv().WhiteRoomAPI = WhiteRoomAPI

return main
