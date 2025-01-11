function Mod:init()
    print("Loaded "..self.info.name.."!")
    self.game = "mari0"
    Utils.hook(Kristal, "errorHandler", function (orig, msg,...)
        self:unload()
        return orig(msg,...)
    end)
end

function Mod:getGamePath()
    return Mod.info.path .. "/games/"..self.game
end

function Mod:postInit()
    local main_chunk = love.filesystem.load(self:getGamePath().."/main.lua")
    setfenv(main_chunk, GameEnv)
    -- love.filesystem.setIdentity("kristal/"..self:getGamePath())
    love.filesystem.mount(self:getGamePath(), "/")
    main_chunk()
    GameEnv.love.load()
end

function Mod:postUpdate()
    GameEnv.love.update(DT)
end

function Mod:postDraw()
    GameEnv.love.draw()
end

function Mod:unload()
    love.filesystem.unmount(self:getGamePath())
    Kristal.resetWindow()
    Kristal.setVolume(Kristal.Config["masterVolume"] or 0.6)
end

function Mod:onKeyPressed(key)
    
end