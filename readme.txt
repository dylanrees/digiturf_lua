home.turf design doc
last major revision 7/14/14 by dylan

==FINAL NAME OPTIONS==
*digiturf
*home.turf

==TILES==
*make the final game tiles black and white to that only the players' colors matter.
*make them nice and pixelly

==REBELLION==
When a territory is rebel-flagged, its rebel value increases by one.  When it gets high enough, REBELLION.

When a territory "rebels" and declares independence, it shows up as a spreading
wave of random coloration within a territory, followed by a white flash, an
exploding sound, and the creation of new borders.

The rebelling territories should be marked by "rebel flags" in green, yellow and red

==MERGING==
If two players gain enough territory by merging without sacrificing a lot of stability ranking,
they merge.

==TRENCHES AND EMBASSIES
Any player may sacrifice a piece of territory to make a Trench.  A Trench is a non-owned territory that is very 
hard to capture and prevents color-mixing.

Any player may also create an Embassy at a territory adjacent to another territory.  Embassies provide color-mixing for both
ENTIRE territories, so that both become more similar in color.

==MISC.==
*An "action point booster" item.

==GAME MODES==
	Castle: Once a player's stronghold is captured, that's the end of them.
	Breeder:    Engineer an NPC for maximum success! Earn gene points that let you tweak it.
	Multiplayer: If enough folks like the game.
	Capture the Flag: Capture enemy "flag" territories!
	Strongholds: Basically Domination from Unreal Tournament.
	Alliances: Different countries have the ability to form and break partnerships.
	Serpent: You capture territory fast but you continually depopulate.

==HAZARDS==

Types of hazard tiles: There are both "earth" tiles and "other" tiles.  (* means implemented, # means implementable with script)

EARTH TILES
       *Grassland: Easy to claim or steal, fairly color-stable
       *Water: Impassable.
       *Forest: Moderate difficulty to claim or steal.  Fairly color-stable.
       *Mountain: Difficult to claim or steal.  Moderate color stability.
       *Desert: Difficult to claim or steal.  High color instability.  Depopulates moderately.
	Tundra: Difficult to claim or steal.  Moderate color stability.  Depopulates slightly.

SPACE TILES
       *Lava: Impassable.  Chance of depopulation nearby.
	Cave: Chance of depopulate.  Chance of spawning a new player.

OTHER TILES
       *Chaos Tiles: Impassable.  Greatly increase stability.
       #Vanishing Land: Land that vanishes after a set period of time. 
       #Vanishing Water: The opposite of vanishing land.
 	Nuke Tiles: At either a fixed or random interval, they will explode and clear ownership of nearby tiles
       *Radioactive Tiles: Rapidly depopulate.
	Stronghold Tiles: Very hard to steal!
	Skull Territories: Depopulate so rapidly that they're effectively no-man's lands!
	Flags and Gates: Capture a flag and open the corresponding colored gate.
	Darkness Tiles: The dark version of Light Tiles.
       *Light Tiles: Tend to make all nearby territory black/white.


==FITNESS FUNCTION==

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

==LEVEL EDITOR==

The game has an in-game level editor that allows you to create maps quite easily.
The format used to save created levels is the same format used to save and load games.

The format consists of
* a title line
* a description line
* a tile value field that basically uses a specific ASCII character for each tile type.
	Each tile value is a string with one tile ID character, one player ID number, and a 9-digit number identifying color.
* A list of players and the "player ID" number for each one

* It may be possible to encrypt the levels as well.

==LEVEL SCRIPTING==

If possible, maybe invent some kind of basic scripting language for the game
that allows the player to create more event-based maps.  Try to implement all
of your game modes in the scripting language.

Going along with this, you have "event tiles" that use custom player-made images.
You can program what they do.


==FLAGS==

Every player flies a flag that they are assigned, made out of a handful of common attributes.  It takes up one
of their territory's squares and becomes transparent if the mouse hovers over it.  A child territory that breaks 
off of a mother territory will generally adopt the mother territory's flag, but with a couple of changes.
A merged territory will randomly combine attributes of the flags of the parent territories to make its flag.

==CREDITS==

Design and programming by Dylan Rees

Sound effects created using as3sfxr 
	http://www.superflashbros.net/as3sfxr/
Coding done in Geany 
	http://www.geany.org/
Special thanks to the Lua and Love2D teams!  
	http://www.lua.org/ 
	https://love2d.org/
Special thanks to OpenGameArt
	http://www.opengameart.org
Also special thanks to GameJolt!
	http://www.gamejolt.com
