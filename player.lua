-- Seperate file for all the player related code

-- Player Start variables
playerStartX = 360
playerStartY = 100

-- Creating player collider
player = world:newRectangleCollider(playerStartX, playerStartY, 45, 100, {collision_class = 'Player'})
player.speed = 280
-- Makes it so the player can not rotate
player:setFixedRotation(true)
player.animation = animations.idle
player.isMoving = false
-- 1 means facing right -1 means facing left
player.direction = 1
player.grounded = true


-- Player update function
function playerUpdate(dt)
    -- This if statement checks to make sure the player collider is still in play
    if player.body then
        local colliders = world:queryRectangleArea(player:getX() - 20, player:getY() + 50, 40, 5, {'Platform'})
        if #colliders > 0 then
            player.grounded = true
        else
            player.grounded = false
        end

        player.isMoving = false
        -- For player position of x and y
        local px, py = player:getPosition()

        -- Moves the player right
        if love.keyboard.isDown('right') then
            player:setX(px + player.speed * dt)
            player.isMoving = true
            player.direction = 1
        end
        -- Moves the player left
        if love.keyboard.isDown('left') then
            player:setX(px - player.speed * dt)
            player.isMoving = true
            player.direction = -1
        end
    end
    -- This if statement runs code if the player collider ever enters the danger collider
    if player:enter('Danger') then
        player:setPosition(playerStartX, playerStartY)
    end

    -- Changes the players animation based on a state
    if player.grounded then
        if player.isMoving then
            player.animation = animations.run
        else
            player.animation = animations.idle
        end
    else
        player.animation = animations.jump
    end
    -- This cycles the players animation every frame
    player.animation:update(dt)
end

-- Function for drawind player
function drawPlayer()
    -- Gets the players position to draw it to the rectangle collider
    local px, py = player:getPosition()
    -- Draws the players current animation
    -- The first parameter is the sprite we want to draw and the next two are the position where we draw it from
    player.animation:draw(sprites.playerSheet, px, py, nil, 0.25 * player.direction, 0.25, 130, 300)
end