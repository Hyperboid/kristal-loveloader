function Mod:init()
    print("Loaded "..self.info.name.."!")
    self.game = "mari0"
    self.fs_identity = love.filesystem.getIdentity()

    -- Don't kill threads
    Utils.hook(love, "quit", function() end)
    Utils.hook(Kristal, "errorHandler", function (orig, msg,...)
        pcall(self.unload,self)
        return orig(msg,...)
    end)
end

function Mod:hasGame(game)
    assert(type(game) == "string", "bad argument #1 to 'gameExists' (string expected, got "..type(game)..")")
    return love.filesystem.getInfo(self:getGamePath(game)) ~= nil
end

function Mod:getGamePath(game)
    game = game or self.game
    if love.filesystem.getInfo(self.info.path .. "/games/"..game..".love") then
        return self.info.path .. "/games/"..game .. ".love"
    end
    return self.info.path .. "/games/"..game
end

function Mod:startGame(game, quit_callback)
    Kristal.Console:close()
    Game.stage.timer:after(0, function ()
        self:runGame(game, quit_callback or function () end)
    end)
end

function Mod:runGame(game, quit_callback)
    self.game = game or self.game
    quit_callback = quit_callback or Kristal.returnToMenu
    love.filesystem.mount(self:getGamePath(), "/")
    local conf_chunk = love.filesystem.load("conf.lua")
    local conf = {}
    do
        local conf_mt_val
        local conf_mt = {__index = function() return conf_mt_val end}
        conf_mt_val = setmetatable({}, conf_mt)
        setmetatable(conf, conf_mt)
    end
    if conf_chunk then
        setfenv(conf_chunk, GameEnv)
        conf_chunk()
        GameEnv.love.conf(conf)
    end
    local main_chunk = love.filesystem.load("main.lua")
    assert(main_chunk, "Missing main.lua ("..self:getGamePath()..")")
    setfenv(main_chunk, GameEnv)
    love.graphics.scale(1/Kristal.Config["windowScale"])
    love.mouse.setVisible(true)
    if conf.identity then
        GameEnv.love.filesystem.setIdentity(conf.identity)
    end
    main_chunk()
    local mainLoop = GameEnv.love.run() or function() return 0 end
    love.graphics.scale(Kristal.Config["windowScale"])
    DT = 1/60
    while true do
        GameEnv._can_present = GameEnv.Kristal ~= nil
        local result = mainLoop()
        if not GameEnv.Kristal then
            Kristal.Stage:update()
            love.graphics.push()
            local w, h = love.window.getMode()
            love.graphics.translate(w/2, 0)
            love.graphics.scale(h / SCREEN_HEIGHT)
            love.graphics.translate(-SCREEN_WIDTH/2, 0)
            local canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
            Kristal.Stage:draw()
            Draw.popCanvas()
            Draw.draw(canvas)
            love.graphics.pop()
            _G.GameEnv._can_present = true
            love.graphics.present()
        end
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


function Mod:unload()
    self:cleanup()
end

function Mod:cleanup()
    love.audio.stop()
    if GameEnv ~= nil then
        GameEnv = modRequire("scripts.globals.GameEnv")
    end
    love.filesystem.setIdentity(self.fs_identity)
    love.filesystem.unmount(self:getGamePath())
    Kristal.setDesiredWindowTitleAndIcon()
    Kristal.resetWindow()
    Kristal.setVolume(Kristal.Config["masterVolume"] or 0.6)
    Input.clear(nil, true)
    love.graphics.setBackgroundColor(COLORS.black)
end
