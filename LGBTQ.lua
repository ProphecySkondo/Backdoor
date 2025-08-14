-- LGBTQ+ Hangout - Xeon Game Script
-- Auto-loaded by GameSupport - no manual setup needed

local api = {
    ["BackdoorApi"] = "https://gist.githubusercontent.com/ProphecySkondo/d07fac96cfdb75b41665ef3c003cea5b/raw/cfacc964ef4f012b024d0b00d5ee33f504264ae8/gistfile1.txt";
    ["Libary"] = "https://gist.githubusercontent.com/ProphecySkondo/21ffde15b8ca1b5a058d328efceb7f47/raw/3cb39b75d65147a926d4fe02a7b3437e30209915/gistfile1.txt";
}

local assets = {
    ['liljeff'] = 81995147887584;
    ['synapse'] = 105023401515788;
    ['syn'] = 139762261503275;
	["palestine"] = 120356544;
	["something"] = 123456789;
	["killua"] = 109027422827277;
	["jayboo"] = 110575473381369;
}

-- Load APIs
local backdoorapi = loadstring(game:HttpGet(tostring(api["BackdoorApi"])))()
local Library = loadstring(game:HttpGet(tostring(api["Libary"])))()

getgenv().namehub = "Xeon"

local function radioFling()
    local radio = workspace.Radio.R6.ServerStorage.Radio:FindFirstChild("RadioMesh")
    local inf = math.huge
    if radio then
        game.Players.LocalPlayer.SimulationRadius = 10000
        local radioAtt = Instance.new("Attachment", radio)
        radio.CanCollide = false
        radio.LocalTransparencyModifier = .5
        local AP = Instance.new("AlignPosition", radio)
        AP.MaxAxesForce = Vector3.new(inf,inf,inf)
        AP.MaxForce = inf
        AP.Responsiveness = 200
        AP.ApplyAtCenterOfMass = true
        AP.Attachment0 = radioAtt
        AP.Attachment1 = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.RootAttachment
        local oldPos = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = radio.CFrame
        task.wait(1)
        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
        _G.__RadioFlingLoop = true
        spawn(function()
            while _G.__RadioFlingLoop and radio and radio.Parent do
                radio.AssemblyAngularVelocity = Vector3.new(99999, 99999, 99999)
                task.wait(.5)
            end
        end)
        return true
    else
        return false
    end
end

local function parseAssetId(input)
    if not input or input == "" then return nil end
    local num = tonumber(input)
    if num and num > 0 then
        return num
    end
    return assets[input:lower()]
end

-- Initialize GUI
local main = Library.new()

-- Main Tab
local mainTab = main.create_tab('Main')

mainTab.create_title({
    name = 'Teleports',
    section = 'left'
})

mainTab.create_dropdown({
    name = 'Location',
    flag = 'teleport_location',
    section = 'left',
    
    option = 'Spawn',
    options = {'Spawn', 'Hidden Area', 'Minigame', 'Lesbian', 'Gay', 'Bisexual', 'Transgender', 'Asexual', 'Pansexual'},
    
    callback = function(value)
        if value == "Spawn" then
            backdoorapi.Teleport:Spawn()
        elseif value == "Hidden Area" then
            backdoorapi.Teleport:HiddenArea()
        elseif value == "Minigame" then
            backdoorapi.Teleport:Minigame()
        elseif value == "Lesbian" then
            backdoorapi.Teleport:Lesbian()
        elseif value == "Gay" then
            backdoorapi.Teleport:Gay()
        elseif value == "Bisexual" then
            backdoorapi.Teleport:Bisexual()
        elseif value == "Transgender" then
            backdoorapi.Teleport:Transgender()
        elseif value == "Asexual" then
            backdoorapi.Teleport:Asexual()
        elseif value == "Pansexual" then
            backdoorapi.Teleport:Pansexual()
        end
    end
})

mainTab.create_title({
    name = 'Decals',
    section = 'left'
})

mainTab.create_dropdown({
    name = 'Asset',
    flag = 'decal_asset',
    section = 'left',
    
    option = 'liljeff',
    options = {'liljeff', 'synapse', 'syn', 'palestine', 'something', 'killua', 'jayboo'},
    
    callback = function(value)
        -- Just store the selection
    end
})

mainTab.create_toggle({
    name = 'Map Decals',
    flag = 'map_decals',
    section = 'left',
    enabled = false,
    
    callback = function(state)
        if state then
            local selectedAsset = Library.Flags['decal_asset'] or 'liljeff'
            backdoorapi.Server:ChangeMapDecals(assets[selectedAsset])
        end
    end
})

mainTab.create_toggle({
    name = 'Decal Spam',
    flag = 'decal_spam',
    section = 'left',
    enabled = false,
    
    callback = function(state)
        local selectedAsset = Library.Flags['decal_asset'] or 'liljeff'
        local assetId = parseAssetId(Library.Flags['custom_asset_id']) or assets[selectedAsset]
        backdoorapi.Server:DecalSpam(assetId, state)
    end
})

mainTab.create_textbox({
    name = 'Custom Asset ID',
    flag = 'custom_asset_id',
    section = 'left',
    value = "",
    
    callback = function(value) end
})

mainTab.create_toggle({
    name = 'MakeMapCustomDecal',
    flag = 'make_map_custom_decal',
    section = 'left',
    enabled = false,
    
    callback = function(state)
        if state then
            local customAssetId = parseAssetId(Library.Flags['custom_asset_id'])
            if customAssetId then
                backdoorapi.Server:ChangeMapDecals(customAssetId)
            else
                -- Fallback to selected asset if no custom ID is provided
                local selectedAsset = Library.Flags['decal_asset'] or 'liljeff'
                backdoorapi.Server:ChangeMapDecals(assets[selectedAsset])
            end
            
            -- Auto-turn off the toggle after execution
            spawn(function()
                wait(0.5)
                Library.Flags['make_map_custom_decal'] = false
            end)
        end
    end
})

mainTab.create_title({
    name = 'Two Decal Spam',
    section = 'right'
})

mainTab.create_dropdown({
    name = 'Asset 1',
    flag = 'asset_1',
    section = 'right',
    
    option = 'liljeff',
    options = {'liljeff', 'synapse', 'syn', 'palestine', 'something', 'killua', 'jayboo'},
    
    callback = function(value) end
})

mainTab.create_dropdown({
    name = 'Asset 2',
    flag = 'asset_2',
    section = 'right',
    
    option = 'syn',
    options = {'liljeff', 'synapse', 'syn', 'palestine', 'something', 'killua', 'jayboo'},
    
    callback = function(value) end
})

mainTab.create_slider({
    name = 'Spam Delay',
    flag = 'spam_delay',
    section = 'right',
    
    value = 1,
    minimum_value = 0.1,
    maximum_value = 10,
    
    callback = function(value) end
})

mainTab.create_toggle({
    name = 'Two Spam Active',
    flag = 'two_spam',
    section = 'right',
    enabled = false,
    
    callback = function(state)
        if state then
            local asset1 = Library.Flags['asset_1'] or 'liljeff'
            local asset2 = Library.Flags['asset_2'] or 'syn'
            local delay = Library.Flags['spam_delay'] or 1
            
            local assetId1 = parseAssetId(Library.Flags['custom_asset_id']) or assets[asset1]
            local assetId2 = parseAssetId(Library.Flags['custom_asset_id']) or assets[asset2]
            
            _G.__TwoSpamLoop = true
            spawn(function()
                local currentAsset = 1
                while _G.__TwoSpamLoop do
                    if currentAsset == 1 then
                        backdoorapi.Server:ChangeMapDecals(assetId1)
                        currentAsset = 2
                    else
                        backdoorapi.Server:ChangeMapDecals(assetId2)
                        currentAsset = 1
                    end
                    wait(delay)
                end
            end)
        else
            _G.__TwoSpamLoop = false
        end
    end
})

-- Flags Tab
local flagsTab = main.create_tab('Flags')

flagsTab.create_title({
    name = 'Flag Control',
    section = 'left'
})

flagsTab.create_toggle({
    name = 'Equip All Flags',
    flag = 'equip_flags',
    section = 'left',
    enabled = false,
    
    callback = function(state)
        if state then
            backdoorapi.Flags:EquipAllFlags()
        end
    end
})

flagsTab.create_dropdown({
    name = 'Flag Formation',
    flag = 'flag_formation',
    section = 'left',
    
    option = 'Reset',
    options = {'Reset', 'X Formation', 'Monitor Formation', 'Line Formation'},
    
    callback = function(value)
        if value == "Reset" then
            backdoorapi.Flags:ResetFlagGrips()
        elseif value == "X Formation" then
            backdoorapi.Flags:XFlags()
        elseif value == "Monitor Formation" then
            backdoorapi.Flags:MonitorFlags()
        elseif value == "Line Formation" then
            backdoorapi.Flags:LineFlags()
        end
    end
})

flagsTab.create_title({
    name = 'Player Flags',
    section = 'left'
})

flagsTab.create_dropdown({
    name = 'Target Players',
    flag = 'target_players',
    section = 'left',
    
    option = 'others',
    options = {'me', 'others', 'all'},
    
    callback = function(value) end
})

flagsTab.create_dropdown({
    name = 'Flag Asset',
    flag = 'flag_asset',
    section = 'left',
    
    option = 'liljeff',
    options = {'liljeff', 'synapse', 'syn', 'palestine', 'something', 'killua', 'jayboo'},
    
    callback = function(value) end
})

flagsTab.create_toggle({
    name = 'Change Player Flags',
    flag = 'change_player_flags',
    section = 'left',
    enabled = false,
    
    callback = function(state)
        if state then
            local targetPlayers = Library.Flags['target_players'] or 'others'
            local flagAsset = Library.Flags['flag_asset'] or 'liljeff'
            backdoorapi.Flags:ChangePlayerFlags(targetPlayers, assets[flagAsset])
        end
    end
})

flagsTab.create_title({
    name = 'Player Faces',
    section = 'right'
})

flagsTab.create_dropdown({
    name = 'Face Target',
    flag = 'face_target',
    section = 'right',
    
    option = 'others',
    options = {'me', 'others', 'all'},
    
    callback = function(value) end
})

flagsTab.create_dropdown({
    name = 'Face Asset',
    flag = 'face_asset',
    section = 'right',
    
    option = 'liljeff',
    options = {'liljeff', 'synapse', 'syn', 'palestine', 'something', 'killua', 'jayboo'},
    
    callback = function(value) end
})

flagsTab.create_toggle({
    name = 'Change Faces',
    flag = 'change_faces',
    section = 'right',
    enabled = false,
    
    callback = function(state)
        if state then
            local faceTarget = Library.Flags['face_target'] or 'others'
            local faceAsset = Library.Flags['face_asset'] or 'liljeff'
            backdoorapi.Server:ChangePlayersFace(faceTarget, assets[faceAsset])
        end
    end
})

-- Server Tab
local serverTab = main.create_tab('Server')

serverTab.create_title({
    name = 'Server Control',
    section = 'left'
})

serverTab.create_toggle({
    name = 'Anti Fling',
    flag = 'anti_fling',
    section = 'left',
    enabled = false,
    
    callback = function(state)
        backdoorapi.Utils:AntiFling(state)
    end
})

serverTab.create_toggle({
    name = 'Lag Server',
    flag = 'lag_server',
    section = 'left',
    enabled = false,
    
    callback = function(state)
        backdoorapi.Server:LagServer(state)
    end
})

serverTab.create_toggle({
    name = 'Fix GUI Glitches',
    flag = 'fix_gui',
    section = 'left',
    enabled = false,
    
    callback = function(state)
        if state then
            backdoorapi.Server:FixGuiGlitches()
        end
    end
})

serverTab.create_toggle({
    name = 'Radio Fling',
    flag = 'radio_fling',
    section = 'left',
    enabled = false,
    
    callback = function(state)
        if state then
            if not radioFling() then
                Library.Flags['radio_fling'] = false
            end
        else
            _G.__RadioFlingLoop = false
        end
    end
})

serverTab.create_title({
    name = 'Information',
    section = 'right'
})

-- Add info labels (using textbox as display)
local hwid = backdoorapi.Utils:GetHWID()
local executor = backdoorapi.Utils:GetExecutor()

-- We'll use dropdowns to display info since the library doesn't have labels
serverTab.create_dropdown({
    name = 'Executor Info',
    flag = 'executor_info',
    section = 'right',
    
    option = executor,
    options = {executor},
    
    callback = function(value) end
})

serverTab.create_title({
    name = 'Game Passes',
    section = 'right'
})

local hdAdminOwned = backdoorapi.Utils:IsGamepassOwned("HD Admin") and "Owned" or "Not Owned"
local vipOwned = backdoorapi.Utils:IsGamepassOwned("VIP") and "Owned" or "Not Owned"

serverTab.create_dropdown({
    name = 'HD Admin',
    flag = 'hd_admin_status',
    section = 'right',
    
    option = hdAdminOwned,
    options = {hdAdminOwned},
    
    callback = function(value) end
})

serverTab.create_dropdown({
    name = 'VIP Status',
    flag = 'vip_status',
    section = 'right',
    
    option = vipOwned,
    options = {vipOwned},
    
    callback = function(value) end
})

-- Admin Tab (only if HD Admin is owned)
if backdoorapi.Utils:IsGamepassOwned("HD Admin") then
    local adminTab = main.create_tab('Admin')
    
    adminTab.create_title({
        name = 'HD Admin Commands',
        section = 'left'
    })
    
    -- Common admin commands as quick buttons
    adminTab.create_dropdown({
        name = 'Quick Commands',
        flag = 'quick_commands',
        section = 'left',
        
        option = 'Select Command',
        options = {'Select Command', ':fly me', ':invisible me', ':speed me 50', ':jump me 100', ':god me', ':ungod me'},
        
        callback = function(value)
            if value ~= "Select Command" then
                backdoorapi.Admin:ExecuteCommand(value:sub(2)) -- Remove the : prefix
            end
        end
    })
    
    adminTab.create_title({
        name = 'Bubble Chat',
        section = 'right'
    })
    
    -- Quick bubble chat messages
    adminTab.create_dropdown({
        name = 'Quick Messages',
        flag = 'quick_messages',
        section = 'right',
        
        option = 'Select Message',
        options = {'Select Message', 'Hello everyone!', 'Welcome to the server!', 'Having fun?', 'Check out this script!'},
        
        callback = function(value)
            if value ~= "Select Message" then
                backdoorapi.Admin:BubbleChat(value)
            end
        end
    })
end

return main
