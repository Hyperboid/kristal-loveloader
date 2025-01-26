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
    self:setHitbox(0,0,self:getSize())
    self.solid = true
end

function cab:onAdd(parent)
    if not self.game then self:remove() end
    super.onAdd(self,parent)
end

function cab:onInteract()
    Game.world:startCutscene("gaming", self.game)
end

return cab