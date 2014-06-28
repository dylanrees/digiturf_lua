FINAL NAME

home.turf


BIG IDEA CACHE

There should be some variation in the ease with which you can capture territory.  Maybe the system should be redesigned
so that the player has a "points meter" that continually fills, so they can either continually grab territory or
do it in short sprees.  There should be some protection for small players to that having your territory isn't the end
of the world.

Types of hazard tiles: There are both "earth" tiles and "other" tiles.  (* means implemented)

EARTH TILES
	Grassland: Easy to claim or steal, fairly color-stable
       *Water: Impassable.
       *Forest: Moderate difficulty to claim or steal.  Fairly color-stable.
	Mountain: Difficult to claim or steal.  Moderate color stability.
	Desert: Difficult to claim or steal.  High color instability.  Depopulates moderately.
	Tundra: Difficult to claim or steal.  Moderate color stability.  Depopulates slightly.

SPACE TILES
       *Lava: Impassable.  Chance of depopulation nearby.
	Cave: Chance of depopulate.  Chance of spawning a new player.

OTHER TILES
       *Chaos Tiles: Impassable.  Greatly increase stability.
	Vanishing Land: Land that vanishes after a set period of time.
	Vanishing Water: The opposite of vanishing land.
 	Nuke Tiles: At either a fixed or random interval, they will explode and clear ownership of nearby tiles
       *Radioactive Tiles: Rapidly depopulate.
	Stronghold Tiles: Very hard to steal!

Possible Alternate Game Modes:
	Castle: Once a player's stronghold is captured, that's the end of them.
	Breeder:    Engineer an NPC for maximum success! Earn gene points that let you tweak it.
	Multiplayer: If enough folks like the game.
	Capture the Flag: Capture enemy "flag" territories!
	Strongholds: Basically Domination from Unreal Tournament.
	Alliances: Different countries have the ability to form and break partnerships.
	Serpent: You capture territory fast but you continually depopulate.
	

ONGOING DESIGN STUFF

When a territory "rebels" and declares independence, it shows up as a spreading
wave of random coloration within a territory, followed by a white flash, an
exploding sound, and the creation of new borders.

FITNESS FUNCTION

The way the AI works is that each NPC has a fitness function that computes
total fitness of the player based on a series of factors:

1.) Ratio of total surface area to volume of the player's territory
2.) Color variation in the player's territory
3.) Total number of squares the player controls
4.) Total number of squares the opponents control
5.) The relative time costs of stealing territory versus grabbing empty territory
6.) The proximity to other players's territory.  
	Some players are "fleeing" (proximity is costly) and others are "seeking" (proximity is valuable)
7.) Proximity to natural hazards, like chaos tiles. Some factor like "curiosity" should determine seeking/avoiding behavior
8.) Dealing with the player's non-contiguous territories. I'll have to think about this problem.

The player does a survey of the entire board, flags all spaces that, if claimed,
would increase the fitness of the player, picks one, and does it.

As players spawn other players, the new players inherit their fitness functions
from the old ones.  Small tweaks are made to the coefficients in front of each
of the factors in the fitness function.  The "intelligence" is also tweaked
up or down.

If intelligence is at 100%, that player will always choose the move that
maximizes its fitness function.  If it's at 0%, that player will choose
a random legal move.  If it's at X%, the player will from chose from a list of
all moves that have an effect on the fitness function that is more that X% of the way between
the worst move and the best move. 

CREDITS:

Design and programming by Dylan Rees

Sound effects created using as3sfxr 
	http://www.superflashbros.net/as3sfxr/
Coding done in Geany 
	http://www.geany.org/
Special thanks to the Lua and Love2D teams!  
	http://www.lua.org/ 
	https://love2d.org/
Also special thanks to GameJolt!
	http://www.gamejolt.com