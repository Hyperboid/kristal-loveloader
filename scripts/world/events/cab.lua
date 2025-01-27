local cab, super = Class(Event)

function cab:init(data, ...)
    super.init(self, data, ...)
    self.game = data.properties.game or (data.type and data.name)
    if not self.game then return end
    if Assets.getTexture("events/cab/"..self.game) then
        self:setSprite("events/cab/"..self.game)
    else
        self:setSprite("events/cab/generic")
    end
    self:scanForIcon("icon.png")
    self:scanForIcon("graphics/icon.png")
    self:setHitbox(0,0,self:getSize())
    self.solid = true
    if not Mod:hasGame(self.game) then
        self:addFX(ShaderFX("monotone", {amount = 0.8}))
    end
end

function cab:scanForIcon(path)
    if self.icon then return end
    if love.filesystem.getInfo(Mod:getGamePath(self.game).."/"..path) then
        local icon = love.graphics.newImage(Mod:getGamePath(self.game).."/"..path)
        local prev_canvas = love.graphics.getCanvas()
        local canvas = Draw.pushCanvas(16,16)
        Draw.draw(icon, 0,0, 0, 16/icon:getWidth(), 16/icon:getWidth())
        Draw.popCanvas()
        self.icon = love.graphics.newImage(canvas:newImageData())
        love.graphics.setCanvas(prev_canvas)
    end
end

function cab:onAdd(parent)
    if not self.game then self:remove() end
    super.onAdd(self,parent)
end

function cab:draw()
    super.draw(self)
    if self.icon then
        Draw.draw(self.icon, 30,27, 0, 2,2)
    end
end

function cab:onInteract()
    Game.world:startCutscene("gaming", self.game)
    return true
end

return cab