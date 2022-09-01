function levelLoader()
    local colliders = world:queryCircleArea(flagX, flagY, 10, {'Player'})
    if #colliders > 0 then
        if saveData.currentLevel == "level1" then
            loadMap("level2")
        elseif saveData.currentLevel == "level2" then
            loadMap("level3")
        elseif saveData.currentLevel == "level3" then
            loadMap("level4")
        elseif saveData.currentLevel == "level4" then
            loadMap("level5")
        elseif saveData.currentLevel == "level5" then
            loadMap("level6")
        elseif saveData.currentLevel == "level6" then
            loadMap("level7")
        elseif saveData.currentLevel == "level7" then
            loadMap("level8")
        elseif saveData.currentLevel == "level8" then
            loadMap("level9")
        elseif saveData.currentLevel == "level9" then
            loadMap("level10")
        elseif saveData.currentLevel == "level10" then
            loadMap("level11")
        elseif saveData.currentLevel == "leve11" then
            loadMap("level12")
        elseif saveData.currentLevel == "level12" then
            loadMap("level13")
        elseif saveData.currentLevel == "level13" then
            loadMap("level14")
        elseif saveData.currentLevel == "level14" then
            loadMap("level15")
        elseif saveData.currentLevel == "level15" then
            loadMap("level1")
 
        end
    end
end