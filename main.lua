-- This will be a platformer game

-- The important libraries we use are as follows:
-- windfield which is a physics library to make love2d physics easier
-- anim8 which is used for animations
-- Simple-Tiled-implementation to import Tiled objects
-- Hump which is for a few things but in our case for the camera

------------------- SOME PHYSICS EXPLANATION --------------------------
-- Colliders track all physics stuff for an object
-- Colliders are not physical objects, rather hitboxes that define an area for an object
-- There are three types of colliders dynamic (meaning it falls with gravity, affected by forces, and collides)
-- Static colliders do not move due to physical interactions, like walls or floors
-- Kinematic colliders behave like dynamic colliders but they only interact with dynamic colliders
-- Colliders by default have their offset set to the center

-- When objects collide we want to make collision classes to make it do certain things

-- Querying for colliders returns a table of colliders in a specified area

-- Loads prelimary items and defines global variables
function love.load()
    -- Changes window size
    love.window.setMode(1000, 768)

    anim8 = require 'libraries/anim8/anim8'
    sti = require 'libraries/Simple-Tiled-Implementation/sti'
    cameraFile = require 'libraries/hump/camera'
    suit = require 'libraries/suit-master'
 

    -- Creates a camera object 
    cam = cameraFile()

    -- Creates audio table
    -- Stream means you stream it overtime and static means you load the entire file in memory
    -- Typically sound effects should be static
    -- Music should be stream
    sounds = {}
    sounds.jump = love.audio.newSource("audio/jump.wav", "static")
    sounds.music = love.audio.newSource("audio/music.mp3", "stream")
    -- Loops through music audio incase it ends
    sounds.music:setLooping(true)
    sounds.music:setVolume(0.25)

    -- Plays music
    sounds.music:play()

    -- Requires the player.lua file and makes it so the code can be used here

    -- Creating a sprite table for animations
    sprites = {}
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')
    -- Creating enemy graphic
    sprites.enemySheet = love.graphics.newImage('sprites/enemySheet.png')
    -- Creates backgroound
    sprites.background = love.graphics.newImage('sprites/background.png')

    -- The first two parameters are the dimensions of each individual image
    -- The second two parameters are the dimensions of the whole image
    -- To get the height of each individual image you do (width of whole image / columns) and (height of whole image / rows)
    local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
    -- Creates the enemy animation grid
    local enemyGrid = anim8.newGrid(100, 79, sprites.enemySheet:getWidth(), sprites.enemySheet:getHeight())

    -- Table of all animation states
    animations = {}
    -- This grabs all the animations from the first row
    -- The first paremeter is all the indivdual images we want, and the row we want
    -- The second parameter is for how long we want each frame of the animation to stay on screen
    animations.idle = anim8.newAnimation(grid('1-15',1), 0.05)
    animations.jump = anim8.newAnimation(grid('1-7',2), 0.05)
    animations.run = anim8.newAnimation(grid('1-15',3), 0.05)
    -- Enemy animations
    animations.enemy = anim8.newAnimation(enemyGrid('1-2',1),0.02)
    
    -- Includes windfield physics and creates a variable to reference it
    wf = require 'libraries/windfield/windfield'
    -- Includes the anim8 animation library
   
    -- The first step in using a physics engine is always to define a world for it to live in
    -- The first two parameters are for the gravity of the world
    -- The third parameter is to specify whether or not the object should sleep
    world = wf.newWorld(0, 800, false)

    world:setQueryDebugDrawing(true)

    -- Creating new collission class
    world:addCollisionClass('Platform')
    world:addCollisionClass('Player')
    world:addCollisionClass('Danger', {ignores = {'Danger'}})

    -- Requiring extra code files
    require('player')
    require('enemy')
    require('libraries/show')
    require('maps')

    -- The collission class assigns it to a colission class
    -- Creating dangerZone collider
    dangerZone = world:newRectangleCollider(-500, love.graphics.getHeight() + 20, 5000, 50, {collision_class = 'Danger'})
    dangerZone:setType('static')

    --GUI stuff
    ingameGUI = suit.new()
    ingameState = false
    level = suit.new()
    levelState = false


    -- GameState and Menu variables
    gameState = false
    escMenu = false
    

    platforms = {}

    -- Flag global variable positions
    flagX = 0
    flagY = 0

    -- FontSize 
    gameFont = love.graphics.newFont(40)

    -- Creates a table for everything we want to save
    -- To actually save things we need to seralize it and convert it into a more text friendly format in a file
    saveData = {}
    saveData.currentLevel = "level1"

    -- Gets info if there is currently a save file
    if love.filesystem.getInfo("data.lua") then
        -- Loads the save file if there was one
        local data = love.filesystem.load("data.lua")
        -- This then puts the data back into the appropriate table
        data()
    end

    loadMap(saveData.currentLevel)


    -- Spawns enemy
end

-- Updates via the fps
function love.update(dt)
    if gameState then
        -- Updates the physics world
        world:update(dt)
        -- Updates the map
        gameMap:update(dt)
        playerUpdate(dt)
        updateEnemies(dt)

        -- Makes the camera look at a specific point, in our game the player and the middle of the screen
        local px = player:getPosition()
        cam:lookAt(px, love.graphics.getHeight() / 2)

        -- Querys for flag
        levelLoader()
    
    elseif not gameState then
        local bsx = 400
        local bsy = 100
        if suit.Button("Start", {font = gameFont}, love.graphics.getWidth() / 2 - (bsx / 2), love.graphics.getHeight() / 2 - bsy / 2, bsx, bsy).hit then
            gameState = true
        end
    end
    
end

-- Draws objects to window
function love.draw()
    if gameState then
        love.graphics.draw(sprites.background, 0, 0)
        love.graphics.setFont(gameFont)
        love.graphics.printf("Level is: " .. saveData.currentLevel, 0, 20, love.graphics.getWidth(), "center")
    
        -- Draws everything to the screen in reference to the cameras viewpoint that is within its indentation
        cam:attach()
            -- Draws the map
            gameMap:drawLayer(gameMap.layers["Tile Layer 1"])

            drawPlayer()
            drawEnemies()
        cam:detach()
    -- Draws the GUIs
    elseif not gameState then
        love.graphics.draw(sprites.background, 0, 0)
        suit.draw()
    end

    

end

-- Jumps the player
function love.keypressed(key)

    if key == 'up' and player.body and gameState then
        -- Applys jump as long as player is grounded
        if player.grounded then
            player:applyLinearImpulse(0, -4500) 
            sounds.jump:play()
        end
    end
   
    --[[ Development test function
    if key == 'r' then
        loadMap("level3")
    end]]
end



-- Spawns platform objects
-- The parameters are to create unique platform colliders for whatever objects we pass in
function spawnPlatform(x, y, width, height)
    -- If statement protects code from non-real platform objects
    if width > 0 and height > 0 then
        -- Creating platform collider
        local platform = world:newRectangleCollider(x, y, width, height, {collision_class = 'Platform'})
        -- Setting the platform to static
        platform:setType('static')
        table.insert(platforms, platform)
    end
end

-- Destroys all previous level
-- It iterates through every platform and enemy in the game and if there is said object it removes it from the table
function destroyAll()
    local i = #platforms
    -- Destroys platforms
    while i > -1 do
        if platforms[i] ~= nil then
            platforms[i]:destroy()
        end
        table.remove(platforms, i)
        i = i -1
    end
    
    -- Destroys enemies
    local i = #enemies
    while i > -1 do
        if enemies[i] ~= nil then
            enemies[i]:destroy()
        end
        table.remove(enemies, i)
        i = i -1
    end
end

-- Loading tiled levels
function loadMap(mapName)
    saveData.currentLevel = mapName
    -- Saves the actual data
    love.filesystem.write("data.lua", table.show(saveData, "saveData"))
    destroyAll()
    
    gameMap = sti("maps/" .. mapName .. ".lua")
    -- Starts the player on a specified position
    for i, obj in pairs(gameMap.layers["Start"].objects) do
        playerStartX = obj.x 
        playerStartY = obj.y
    end
    player:setPosition(playerStartX, playerStartY)
    -- Loops through all the platforms in the game and spawns a collider
    for i, obj in pairs(gameMap.layers["Platforms"].objects) do
        spawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end
    -- Loops through all the enemies and spawns them
    for i, obj in pairs(gameMap.layers["Enemies"].objects) do
        spawnEnemy(obj.x, obj.y)
    end
    -- Sets the flags x and y
    for i, obj in pairs(gameMap.layers["Flag"].objects) do
        flagX = obj.x
        flagY = obj.y
    end
end

