---@param cutscene WorldCutscene
---@param game string
return function (cutscene, game)
    cutscene:text("* It's an arcade cabinet for \""..game:upper()..".\"\n* Play it?")
    if cutscene:choicer({"Play", "Don't"}) == 1 then
        cutscene:wait(cutscene:fadeOut(2))
        Mod:runGame(game, function()end)
        cutscene:wait(cutscene:fadeIn(2))
    else
        cutscene:text("* You decide not to.")
    end
end