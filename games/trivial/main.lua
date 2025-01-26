function love.draw()
    love.graphics.setColor(1,0,1)
    love.graphics.circle("fill", 50, 50, 100)
    love.graphics.setColor(1,1,1)
    love.graphics.print("Press ESC to quit.")
    if OrigGlobal and OrigGlobal.Kristal then
        love.graphics.print("...and return to Kristal.", 0, 32)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
