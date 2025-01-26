function Mod:init()
    print("Loaded "..self.info.name.."!")
    self.game = "mari0"
    self.fs_identity = love.filesystem.getIdentity()

    -- Don't kill threads
    Utils.hook(love, "quit", function() end)
    Utils.hook(Kristal, "errorHandler", function (orig, msg,...)
        self:unload()
        return orig(msg,...)
    end)
end

function Mod:getGamePath()
    return self.info.path .. "/games/"..self.game
end

function Mod:postInit()
    -- self:runGame()
end

function Mod:runGame(game, quit_callback)
    self.game = game or self.game
    quit_callback = quit_callback or Kristal.returnToMenu
    local main_chunk = love.filesystem.load(self:getGamePath().."/main.lua")
    assert(main_chunk, "Missing main.lua ("..self:getGamePath()..")")
    setfenv(main_chunk, GameEnv)
    -- love.filesystem.setIdentity("kristal/"..self:getGamePath())
    love.filesystem.mount(self:getGamePath(), "/")
    love.graphics.push()
    love.graphics.scale(0.5)
    love.mouse.setVisible(true)
    main_chunk()
    love.graphics.pop()
    local mainLoop = GameEnv.love.run()
    while true do
        GameEnv._can_present = false
        local result = mainLoop()
        Kristal.Stage:update()
        Kristal.Stage:draw()
        _G.GameEnv._can_present = true
        love.graphics.present()
        if result ~= nil then
            if result == 0 or result == "restart" then
                break
            else
                error("Game exited abnormally! Status code "..result)
            end
        end
    end
    Kristal.updateCursor()
    quit_callback()
    self:cleanup()
end

-- function Mod:postUpdate()
--     GameEnv.love.update(DT)
-- end

-- function Mod:postDraw()
--     GameEnv.love.draw()
-- end

function Mod:unload()
    self:cleanup()
end

function Mod:cleanup()
    if GameEnv ~= nil then
        GameEnv = modRequire("scripts.globals.GameEnv")
    end
    love.filesystem.unmount(self:getGamePath())
    love.filesystem.setIdentity(self.fs_identity)
    Kristal.resetWindow()
    Kristal.setVolume(Kristal.Config["masterVolume"] or 0.6)
end

-- function Mod:onKeyPressed(key, is_repeat)
--     if not is_repeat then
--         GameEnv.love.keypressed(key)
--     end
-- end