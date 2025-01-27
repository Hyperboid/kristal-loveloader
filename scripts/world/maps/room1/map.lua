---@class Map.room1:Map
local room1, super = Class(Map)

function room1:onEnter()
    super.onEnter(self)
    local existing_cabs = {}
    do
        local existing_cabs_objects = Game.world.stage:getObjects(Registry.getEvent("cab"))
        for k,v in pairs(existing_cabs_objects) do
            table.insert(existing_cabs, v.game)
        end
    end
    local x,y = 60, 40
    for k,game in Utils.orderedPairs(love.filesystem.getDirectoryItems(Mod.info.path .. "/games")) do
        if Utils.containsValue(existing_cabs, game) then goto continue end
        local cab = Game.world:spawnObject(Registry.createEvent("cab", {x=x,y=y, properties={game=game}}))
        x = x + cab.width
        ::continue::
    end
end

return room1