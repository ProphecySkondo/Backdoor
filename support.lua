local GameSupport = {}

local supportedGames = {
    [5373028495] = {
        name = "LGBTQ+ Hangout",
        alias = "LGBTQHANGOUT",
        features = {"decal_spam", "fling", "radio"},
        special_config = {
            decal_limit = 50,
            fling_power = 16
        }
    },
    [142823291] = {
        name = "MeepCity",
        alias = "MEEPCITY",
        features = {"decal_spam", "radio"},
        special_config = {
            decal_limit = 30
        }
    },
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
    local currentPlaceId = game.PlaceId
    
    if not self:isSupported() then
        if (type(messagebox) == 'function') then
            protectedMessagebox(`This Game is Unsupported!\n\nPlace ID: {currentPlaceId}\n\nOnly supported games can use this script.`, `GameSupport [{executor}]`, 48)
        end
        return false, "Unsupported game"
    end
    
    local gameData = self:getCurrentGame()
    return true, gameData
end

return GameSupport
