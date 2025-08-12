local GameSupport = {}

-- Console configuration
local ConsoleAPI = {
    create = rconsolecreate or create_console or createconsole,
    print = rconsoleprint or console_print or printconsole,
    settitle = rconsolesettitle or consolesettitle or setconsoletitle,
    clear = rconsoleclear or console_clear or clearconsole
}

-- Red theme colors (ANSI escape codes)
local Colors = {
    RED = "\27[91m",
    DARK_RED = "\27[31m",
    LIGHT_RED = "\27[38;5;203m",
    BRIGHT_RED = "\27[38;5;196m",
    WHITE = "\27[97m",
    RESET = "\27[0m",
    BOLD = "\27[1m"
}

-- Auto-initialize console with Xeon branding
local function initializeConsole()
    if ConsoleAPI.create then
        ConsoleAPI.create()
    end
    
    if ConsoleAPI.settitle then
        ConsoleAPI.settitle("Xeon Executor Console")
    end
    
    if ConsoleAPI.clear then
        ConsoleAPI.clear()
    end
    
    if ConsoleAPI.print then
        ConsoleAPI.print(Colors.BRIGHT_RED .. Colors.BOLD .. 
            "========================================\n" ..
            "           XEON EXECUTOR v1.0          \n" ..
            "========================================\n" .. Colors.RESET)
        ConsoleAPI.print(Colors.WHITE .. "Initializing game detection...\n" .. Colors.RESET)
    end
end

-- Console logging function
local function logConsole(message, color)
    if ConsoleAPI.print then
        ConsoleAPI.print((color or Colors.WHITE) .. message .. Colors.RESET)
    end
end

-- Progress bar function
local function showProgress(message, progress)
    if not ConsoleAPI.print then return end
    
    local barLength = 30
    local filled = math.floor((progress / 100) * barLength)
    local empty = barLength - filled
    
    local bar = Colors.RED .. "[" .. 
               Colors.BRIGHT_RED .. string.rep("#", filled) .. 
               Colors.DARK_RED .. string.rep("-", empty) .. 
               Colors.RED .. "]" .. Colors.WHITE
    
    ConsoleAPI.print(string.format("%s %s %d%%\n", bar, message, progress))
end

local supportedGames = {
    [5373028495] = {
        name = "LGBTQ+ Hangout",
        alias = "LGBTQHANGOUT",
        features = {"decal_spam", "fling", "radio"},
        script_path = "LGBTQ.lua",
        special_config = {
            decal_limit = 50,
            fling_power = 16
        }
    },
    [142823291] = {
        name = "MeepCity",
        alias = "MEEPCITY",
        features = {"decal_spam", "radio"},
        script_path = "universal.lua",
        special_config = {
            decal_limit = 30
        }
    },
    [13278749064] = {
        name = "White Room Game",
        alias = "WHITEROOMGAME",
        features = {"tools", "fly", "noclip", "teleport", "remotes", "exploits"},
        script_path = "Whiteroom.lua",
        special_config = {
            auto_grab_tools = true,
            fly_speed = 50,
            remote_spam_enabled = true
        }
    },
}

local universalFallback = {
    name = "Universal",
    alias = "UNIVERSAL",
    features = {"fly", "noclip", "speed", "jump", "health", "stamina"},
    script_path = "universal.lua",
    special_config = {}
}

local messagebox = messagebox
local executor = identifyexecutor and identifyexecutor() or 'Unknown'

local protectedMessagebox = function(body, title, id)
    local success, output = pcall(messagebox, body, title, id)
    if (not success) then
        return
    end
    return output
end

function GameSupport:isSupported()
    local currentPlaceId = game.PlaceId
    return supportedGames[currentPlaceId] ~= nil
end

function GameSupport:getCurrentGame()
    local currentPlaceId = game.PlaceId
    return supportedGames[currentPlaceId]
end

function GameSupport:getGameName()
    local gameData = self:getCurrentGame()
    return gameData and gameData.name or "Unknown Game"
end

function GameSupport:hasFeature(feature)
    local gameData = self:getCurrentGame()
    if not gameData then return false end
    return table.find(gameData.features, feature) ~= nil
end

function GameSupport:getConfig(key)
    local gameData = self:getCurrentGame()
    if not gameData or not gameData.special_config then return nil end
    return gameData.special_config[key]
end

function GameSupport:getAllSupportedIds()
    local ids = {}
    for placeId, _ in pairs(supportedGames) do
        table.insert(ids, placeId)
    end
    return ids
end

function GameSupport:init()
    -- Auto-initialize console
    initializeConsole()
    
    local currentPlaceId = game.PlaceId
    
    -- Show progress steps
    showProgress("Checking game compatibility...", 25)
    wait(0.1)
    
    if not self:isSupported() then
        logConsole("[INFO] Game not specifically supported (Place ID: " .. currentPlaceId .. ")", Colors.LIGHT_RED)
        showProgress("Loading Universal Mode...", 75)
        wait(0.1)
        
        if (type(messagebox) == 'function') then
            protectedMessagebox("Game Not Specifically Supported!\n\nPlace ID: " .. currentPlaceId .. "\n\nLoading Universal Mode with basic features...", "Xeon [" .. executor .. "]", 64)
        end
        
        showProgress("Universal Mode Ready!", 100)
        logConsole("[SUCCESS] Universal Mode loaded with basic features", Colors.BRIGHT_RED)
        logConsole("Features: " .. table.concat(universalFallback.features, ", "), Colors.WHITE)
        
        return true, universalFallback
    end
    
    local gameData = self:getCurrentGame()
    showProgress("Game detected: " .. gameData.name, 50)
    wait(0.1)
    
    showProgress("Loading game-specific features...", 75)
    wait(0.1)
    
    showProgress("Game support ready!", 100)
    logConsole("[SUCCESS] " .. gameData.name .. " detected and supported!", Colors.BRIGHT_RED)
    logConsole("Features: " .. table.concat(gameData.features, ", "), Colors.WHITE)
    logConsole("Script: " .. gameData.script_path, Colors.RED)
    
    return true, gameData
end

function GameSupport:getScriptPath()
    local gameData = self:getCurrentGame()
    if gameData and gameData.script_path then
        return gameData.script_path
    end
    return universalFallback.script_path
end

-- Advanced loader function
function GameSupport:loadScript(baseURL)
    if not baseURL then
        logConsole("[ERROR] No base URL provided for script loading", Colors.BRIGHT_RED)
        return nil
    end
    
    local scriptPath = self:getScriptPath()
    local fullURL = baseURL .. "/" .. scriptPath
    
    showProgress("Downloading script: " .. scriptPath, 30)
    
    local success, response = pcall(function()
        return game:HttpGet(fullURL)
    end)
    
    if not success or not response then
        logConsole("[ERROR] Failed to download script from: " .. fullURL, Colors.BRIGHT_RED)
        
        -- Fallback to universal if not already using it
        if scriptPath ~= universalFallback.script_path then
            logConsole("[INFO] Attempting fallback to Universal Mode...", Colors.LIGHT_RED)
            local universalURL = baseURL .. "/" .. universalFallback.script_path
            
            local fallbackSuccess, fallbackResponse = pcall(function()
                return game:HttpGet(universalURL)
            end)
            
            if fallbackSuccess and fallbackResponse then
                showProgress("Fallback script loaded", 100)
                logConsole("[SUCCESS] Universal fallback script loaded", Colors.BRIGHT_RED)
                return fallbackResponse
            end
        end
        
        return nil
    end
    
    showProgress("Script downloaded successfully", 60)
    logConsole("[SUCCESS] Script loaded from: " .. scriptPath, Colors.BRIGHT_RED)
    return response
end

-- Complete auto-loader
function GameSupport:autoLoad(baseURL)
    local success, gameData = self:init()
    if not success then
        logConsole("[ERROR] Failed to initialize GameSupport", Colors.BRIGHT_RED)
        return nil
    end
    
    local scriptCode = self:loadScript(baseURL)
    if not scriptCode then
        logConsole("[ERROR] Failed to load script", Colors.BRIGHT_RED)
        return nil
    end
    
    showProgress("Executing script...", 90)
    
    local executeSuccess, result = pcall(function()
        return loadstring(scriptCode)()
    end)
    
    if not executeSuccess then
        logConsole("[ERROR] Failed to execute script: " .. tostring(result), Colors.BRIGHT_RED)
        return nil
    end
    
    showProgress("Script execution complete!", 100)
    logConsole("[SUCCESS] " .. gameData.name .. " script executed successfully!", Colors.BRIGHT_RED)
    logConsole("\n" .. Colors.RED .. "========================================\n" ..
              Colors.BRIGHT_RED .. "    XEON READY - ENJOY YOUR SCRIPT!    \n" ..
              Colors.RED .. "========================================" .. Colors.RESET)
    
    return result
end

return GameSupport
