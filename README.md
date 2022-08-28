# Flag Runner
A platforming game.
DEMO: https://youtu.be/GSKnfhv64gA

## About the game and what I learned

My game is simple, yet it allowed me to learn lots of useful skills for future development. It was made in the love2d game engine for lua. 
The basis of the game is to be a simple platformer, 
where you dodge enemies and try to get to the next level. It has taught me skills about physics, how to set up a project, how to use github more effectively and much more.

## Main.lua
Main.lua is a very important file and contains the basis of my code and important functions. it is heavily documented with notes so I can refer back to what I did incase
I forgot. The first function I have is love.load which loads all the prelimnary items and specifies global variables. It is where I included my libraries, and required the other files.
In here I also created the sound effects, animations, collision classes, and created part of the system to save and load the data.

The next function is love.update which is where the code is updated via the fps, it also introduced me to dt. DT is incredibly important for games as it is a timer for FPS in sorts.
DT is the amount of time from one frame to the next, so if the fps is 60 it is 1/60th, if it is 30 then 1/30th. This allowed me to account for frame rate drops as 
variables such as speed are multiplied by it so that if the fps is lower it will still move the same amount of pixels as if it was higher. I also call many other functions
from the other files in here. This allows me to update them via the FPS. It is also how I change the camera to scroll along with the player.

Another function is love.draw which is similiar to love.update except that it draws objects to the screen. It draws the items that don't need to be moved before the camera.
The camera then draws everything that is being moved along with the player. There is not much else except for the items defined above.

Now for my own functions not needed for love2d games to run but for mine to run. First I have love.keypressed which detects when the key is pressed, in this case it is
the 'up' key to jump the player. It also makes sure the player is alive and that they are grounded, as I do not want them jumping in the air.
The next one is spawnPlatform, which is very important. It taught me how to spawn the colliders for all of my platforms. The next one is destroyAll, which destroys things in the game.
It is called in the next function and is used to reset the level. The next and one of the most important is loadMap. It taught me how to load the actual levels from tiled.
It also looped through the enemy table and loaded them in order to spawn them. Along with that it also saved the data for the current map whenever it was called. 

That is all for the functions.


###### Player.lua

Player.lua is the file in which I coded most of the player related features. One of the features which I commonly used was to query for colliders in this case platforms.
This is so that as long as the query is able to find a platform it allows the player to jump. Another feature that was developed was animations for the player, and
eventually the enemies. I learned how to make animation states and have them run. These animations also introduced me to anim8 which is a library to make setting up
and creating animations with ease. It also taught me about how to use collision classes to detect if the player entered a certain area to then kill them. Overall, the player
file was the basis of knowledge for a lot of my project.

###### Enemy.lua

The enemy.lua file was where all the enemies code was made. I used lots of things that I used in player.lua such as querying. It also made me solve the problem of having to
determine how to keep enemies from falling off the platform, which was solved by querying under them to make sure there was a platform, but then flipping its direction if so.
There is not much else to this file but it was useful to me in reinforcing my knowledge. 

###### Maps.lua

Maps.lua is a file where I decide what level to load. It is very simple and is just a bunch of if and elseif statements to switch the level if the flag query finds the player.

## Credits
- There are many important items I used in my game.
- Windfield - Physics Library
- Tiled - Level Creator
- Kennys assets - Assets [https://kenney.nl/]
- Simple Tiled Implementation - Easily use tiles in my game from tiled
- anim8 - Animate things with ease
- hump - Camera features








