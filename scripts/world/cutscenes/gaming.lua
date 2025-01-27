---@param cutscene WorldCutscene
---@param game string
return function (cutscene, game)
    if not Mod:hasGame(game) then
        cutscene:text("* It's an arcade cabinet for \""..game..".\"[wait:10]\n* It's out of order.")
        return
    end
    cutscene:text("* It's an arcade cabinet for \""..game:upper()..".\"[wait:10]\n* Play it?")
    if cutscene:choicer({"Play", "Don't"}) == 1 then
        cutscene:wait(cutscene:fadeOut(1))
        cutscene:after(function()
            Mod:runGame(game, function()end)
        end)
        cutscene:fadeIn(.5)
    else
        cutscene:text("* You decide not to.")
    end
end