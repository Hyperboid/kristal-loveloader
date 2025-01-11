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
    handlers = setmetatable({}, {__index = function (self, k)
        if GameEnv.love[k] then
            return GameEnv.love[k]
        elseif love.handlers[k] then
            -- return love.handlers[k]
        end
        return function() end
    end}),
    errhand = Kristal.errorHandler,
    run = function ()
        if GameEnv.love.load then GameEnv.love.load(GameEnv.love.arg.parseGameArguments(arg), arg) end
    
        -- We don't want the first frame's dt to include time taken by love.load.
        if GameEnv.love.timer then GameEnv.love.timer.step() end
    
        local dt = 0
    
        -- Main loop time.
        return function()
            -- Process events.
            if GameEnv.love.event then
                GameEnv.love.event.pump()
                for name, a,b,c,d,e,f in GameEnv.love.event.poll() do
                    if name == "quit" then
                        if not GameEnv.love.quit or not GameEnv.love.quit() then
                            return a or 0
                        end
                    end
                    GameEnv.love.handlers[name](a,b,c,d,e,f)
                end
            end
    
            -- Update dt, as we'll be passing it to update
            if GameEnv.love.timer then dt = GameEnv.love.timer.step() end
    
            -- Call update and draw
            if GameEnv.love.update then GameEnv.love.update(dt) end -- will pass 0 if love.timer is disabled
    
            if GameEnv.love.graphics and GameEnv.love.graphics.isActive() then
                GameEnv.love.graphics.origin()
                GameEnv.love.graphics.clear(GameEnv.love.graphics.getBackgroundColor())
    
                if GameEnv.love.draw then GameEnv.love.draw() end
    
                GameEnv.love.graphics.present()
            end
    
            if GameEnv.love.timer then GameEnv.love.timer.sleep(0.001) end
        end
    end
    
}, {__index = _G.love})

---@class GameEnv.love.filesystem : love.filesystem
GameEnv.love.filesystem = setmetatable({}, {__index = love.filesystem})
function GameEnv.love.filesystem.setIdentity(name)
    -- nope
end

setmetatable(GameEnv, {__index = _G})
GameEnv._G = GameEnv

return GameEnv