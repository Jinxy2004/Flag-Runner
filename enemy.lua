-- File for all the enemy related objects

-- Creates enemies table for a table of all enemies

enemies = {}

-- Spawns an enemy object collider
function spawnEnemy(x, y)
    local enemy = world:newRectangleCollider(x, y, 70, 90, {collision_class = "Danger"})
    enemy.direction = 1
    enemy.speed = 200
    enemy.animation = animations.enemy
    table.insert(enemies, enemy)
end

-- Updates enemies to move on their platforms
function updateEnemies(dt)
    for i, e in ipairs(enemies) do
        e.animation:update(dt)
        local ex, ey = e:getPosition()

        -- Querys for all platforms below the enemy
        local colliders = world:queryRectangleArea(ex + (40 * e.direction), ey + 40, 10, 10, {'Platform'})

        if #colliders == 0 then
            e.direction = e.direction * -1
        end
        -- Sets the enemies speed to move in its current direction
        e:setX(ex + e.speed * dt * e.direction)
    end 
end

-- Draws each enemy to the screen

function drawEnemies()
    for i, e in ipairs(enemies) do
        local ex, ey = e:getPosition()
        e.animation:draw(sprites.enemySheet, ex, ey, nil, e.direction, 1, 50, 65)
    end
end