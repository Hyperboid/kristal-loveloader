---@class GameEnv: _G
local GameEnv = {
    scale = 2,
    OrigGlobal = _G,
}

GameEnv.require = function (modname)
    local path = modname:gsub("%.", "/")
    local items = love.filesystem.getDirectoryItems("/")
    local chunk = love.filesystem.load(path..".lua") or love.filesystem.load(path.."/init.lua")
    if chunk then
        
        setfenv(chunk, GameEnv)
        return chunk()
    else
        return require(modname)
    end
end

---@class GameEnv.love : love
GameEnv.love = setmetatable({
    load = function () end,
    update = function () end,
    draw = function () end,
    errorhandler = Kristal.errorHandler,
    keypressed = function () end,
    errhand = Kristal.errorHandler,
}, {__index = _G.love})

---@class GameEnv.love.filesystem : love.filesystem
GameEnv.love.filesystem = setmetatable({}, {__index = love.filesystem})
function GameEnv.love.filesystem.setIdentity(name)
    -- nope
end

setmetatable(GameEnv, {__index = _G})
GameEnv._G = GameEnv

return GameEnv