

//here are de global variables
int screenwidth = 800;
int screenheight = 608;
//ColorArray contains the color in each play cell.  1st and 2nd indices are for position.  3rd is for red, green or blue.
int [][][] colorArray = new int[screenwidth/16+2][screenheight/16+2][3];
//ownerArray tells you what player owns each square
String [][] ownerArray = new String[screenwidth/16+2][screenheight/16+2];
//hazardArray tells you where non-turf objects are located
String [][] hazardArray = new String[screenwidth/16+2][screenheight/16+2];
//CleaveArray keeps track of which spaces are about to cleave in two
int [][] cleaveArray = new int[screenwidth/16+2][screenheight/16+2];
Player[] players = new Player[1000];
int playernum = 3;
       
//used for timing the player's square placement
int putblockdelaymax = 15;
int putblockstealmax = 60;

//create the game instance
Game maingame;
Title maintitle;
       
       
void setup() {
     size(screenwidth, screenheight);
     Game maingame = new Game();
     Title maintitle = new Title(1);
 
     }
     
class Title {
     int visible;
      
     Title(int set_visible) {
          visible = set_visible;
          }
            
     }
     
class Game {  
     Game() {
          //make sure that non-owned squares belong to "nobody"
          for (int i = 0; i < floor(screenwidth/16)+2; i++) {
               for (int j = 0; j < floor(screenheight/16)+2; j++) {
                    ownerArray[i][j] = "nobody";
                    }
               }
        
          //make the expanse of un-owned squares gray   
          for (int i = 1; i < floor(screenwidth/16)-1; i++) {
               for (int j = 1; j < floor(screenheight/16)-1; j++) {
                    colorArray[i][j][0] = 155;
                    colorArray[i][j][1] = 155;
                    colorArray[i][j][2] = 155;
               }
          }
            
         //make sure that non-hazard squares contain "nothing"
         for (int i = 0; i < floor(screenwidth/16)+2; i++) {
              for (int j = 0; j < floor(screenheight/16)+2; j++) {
              hazardArray[i][j] = "nothing";
              }
         }

         //make some random water.  
         for (int i = 1; i < floor(screenwidth/16)-1; i++) {
              for (int j = 1; j < floor(screenheight/16)-1; j++) {
                   if (round(random(16))==1) {ownerArray[i][j]="nobody"; hazardArray[i][j]="water";}
                   }
              }
        
         //create a few players
         players[0] = new Player("Dylan",floor(random(screenwidth/16)-1)+1,floor(random(screenheight/16)-1)+1,floor(random(255)),floor(random(255)),floor(random(255)));
         players[1] = new Player("Joad",floor(random(screenwidth/16)-1)+1,floor(random(screenheight/16)-1)+1,floor(random(255)),floor(random(255)),floor(random(255)));
         players[2] = new Player("Bob",floor(random(screenwidth/16)-1)+1,floor(random(screenheight/16)-1)+1,floor(random(255)),floor(random(255)),floor(random(255)));
         }    
    }
     
class Player {
     //sets the player's flag colors, zeroes out their action counter, and gives them a name
     int red;
     int green;
     int blue;
     String name;
     int putblockdelay;
       
     //The "cursor" is what NPCs use for exploring.  It denotes the current place to be putting down blocks.
     int cursorX;
     int cursorY;
     int gox;
     int goy;
       
     Player(String called,int x, int y, int givered, int givegreen, int giveblue) {
          putblockdelay = 0;
          name = called;
          int startx = x;
          int starty = y;
          cursorX=startx;
          cursorY=starty;
          gox=0;
          goy=0;
          red = givered;
          green = givegreen;
          blue = giveblue;
          ownerArray[startx][starty] = name;
          colorArray[startx][starty][0] = red;
          colorArray[startx][starty][1] = green;
          colorArray[startx][starty][2] = blue;
          }
       
          //an NPC action to expand territory
          //left, right, top and bottom are direction indices.  choice shows which way the cursor is going to move.
          void explore() {
               float left;
               float right;
               float top;
               float bottom;
               float choice;
               if (putblockdelay >= putblockdelaymax) {
                    putblockdelay=0;
                    if (((ownerArray[cursorX-1][cursorY]== "nobody") || (ownerArray[cursorX-1][cursorY]== name)) && (hazardArray[cursorX-1][cursorY]== "nothing") && (cursorX>1)) {left = 0.5;} else {left = 0;}
                    if (((ownerArray[cursorX+1][cursorY]== "nobody") || (ownerArray[cursorX+1][cursorY]== name)) && (hazardArray[cursorX+1][cursorY]== "nothing") && (cursorX<floor(screenwidth/16)-2)) {right = 0.5;} else {right = 0;}
                    if (((ownerArray[cursorX][cursorY-1]== "nobody") || (ownerArray[cursorX][cursorY-1]== name)) && (hazardArray[cursorX][cursorY-1]== "nothing") && (cursorY>1)) {top = 0.5;} else {top = 0;}
                    if (((ownerArray[cursorX][cursorY+1]== "nobody") || (ownerArray[cursorX][cursorY+1]== name)) && (hazardArray[cursorX][cursorY+1]== "nothing") && (cursorY<floor(screenheight/16)-2)) {bottom = 0.5;} else {bottom = 0;}
                    left = left*random(2);
                    right = right*random(2);
                    top = top*random(2);
                    bottom = bottom*random(2);
                    choice = 0;
                    if (left>choice) choice=left;
                    if (right>choice) choice=right;
                    if (top>choice) choice=top;
                    if (bottom>choice) choice=bottom;
                    if (choice==left) {gox=-1; goy=0;}
                    if (choice==right) {gox=1; goy=0;}
                    if (choice==top) {gox=0; goy=-1;}
                    if (choice==bottom) {gox=0; goy=1;}
                    while (ownerArray[cursorX][cursorY] == name || hazardArray[cursorX][cursorY]!= "nothing") {
                         cursorX+=gox;
                         cursorY+=goy;
                         }
                    if ((ownerArray[cursorX][cursorY]== "nobody") && (hazardArray[cursorX][cursorY]== "nothing")) {
                         ownerArray[cursorX][cursorY] = name;
                         colorArray[cursorX][cursorY][0] = red;
                         colorArray[cursorX][cursorY][1] = green;
                         colorArray[cursorX][cursorY][2] = blue;
                         }
                    }
               }
          }
     
     //note that we're still inside the player instance definition

     void draw() { 
       
        if (players[0].putblockdelay<=putblockstealmax) players[0].putblockdelay++;
        
        for (int i=1; i<playernum-1; i++) {
        if (players[i].putblockdelay<=putblockstealmax) players[i].putblockdelay++;
        players[i].explore();
        }
        
       
       background(50, 100, 200);    
        if (mousePressed) {
          int pressX = floor(mouseX/16);
          int pressY = floor(mouseY/16);
          
          if (pressX<=floor(screenwidth/16)-2 && pressY<=floor(screenheight/16)-2 && pressX>=1 && pressY>=1) {
          //place a block on new territory
          if (((ownerArray[pressX-1][pressY] == players[0].name) || (ownerArray[pressX+1][pressY] == players[0].name) || (ownerArray[pressX][pressY-1] == players[0].name) || (ownerArray[pressX][pressY+1] == players[0].name)) && players[0].putblockdelay>=putblockdelaymax && hazardArray[pressX][pressY]=="nothing" && ownerArray[pressX][pressY] == "nobody") {  
          players[0].putblockdelay=0;
          colorArray[pressX][pressY][0] = players[0].red;
          colorArray[pressX][pressY][1] = players[0].green;
          colorArray[pressX][pressY][2] = players[0].blue;
          ownerArray[pressX][pressY] = players[0].name;
          }
          //steal a block
          if (((ownerArray[pressX-1][pressY] == players[0].name) || (ownerArray[pressX+1][pressY] == players[0].name) || (ownerArray[pressX][pressY-1] == players[0].name) || (ownerArray[pressX][pressY+1] == players[0].name)) && players[0].putblockdelay>=putblockstealmax && ownerArray[pressX][pressY] != players[0].name && ownerArray[pressX][pressY] != "nobody") {  
          players[0].putblockdelay=0;
          colorArray[pressX][pressY][0] = players[0].red;
          colorArray[pressX][pressY][1] = players[0].green;
          colorArray[pressX][pressY][2] = players[0].blue;
          ownerArray[pressX][pressY] = players[0].name;
          }
          
        }
        }
        
        //random color-jump routine
         for (int i = 1; i < floor(screenwidth/16)-1; i++) {
              for (int j = 1; j < floor(screenheight/16)-1; j++) {
             if (ownerArray[i][j] != "nobody") {
             colorArray[i][j][0] += round(random(6))-3;
             colorArray[i][j][1] += round(random(6))-3;
             colorArray[i][j][2] += round(random(6))-3;
             }
          }
         }
         
        //random territory-cleaving routine part 1: identifying the cleaved spaces
             for (int i = 1; i < floor(screenwidth/16)-1; i++) {
              for (int j = 1; j < floor(screenheight/16)-1; j++) {
               int cleave = 0;
               for (int k=0; k<2; k++) {
                 if ((abs(colorArray[i-1][j][k]-colorArray[i][j][k])>90+floor(random(80))) && (ownerArray[i][j] !="nobody") && (ownerArray[i-1][j] == ownerArray[i][j])) {cleave=1;}
                 if ((abs(colorArray[i+1][j][k]-colorArray[i][j][k])>90+floor(random(80))) && (ownerArray[i][j] !="nobody") && (ownerArray[i+1][j] == ownerArray[i][j])) {cleave=1;}
                 if ((abs(colorArray[i][j-1][k]-colorArray[i][j][k])>90+floor(random(80))) && (ownerArray[i][j] !="nobody") && (ownerArray[i][j-1] == ownerArray[i][j])) {cleave=1;}
                 if ((abs(colorArray[i][j+1][k]-colorArray[i][j][k])>90+floor(random(80))) && (ownerArray[i][j] !="nobody") && (ownerArray[i-1][j+1] == ownerArray[i][j])) {cleave=1;}
                 if (cleave==1) {cleaveArray[i][j]=1;}
             }
          }
         }
         
        //random territory-cleaving routine part 2: cleaving.  
            for (int i = 1; i < floor(screenwidth/16)-1; i++) {
              for (int j = 1; j < floor(screenheight/16)-1; j++) {
                if (cleaveArray[i][j]==1) {
                int redhold = colorArray[i][j][0];
                int greenhold = colorArray[i][j][1];
                int bluehold = colorArray[i][j][2];
                String newPlayerName;
                playernum++;
                newPlayerName = "Player"+Integer.toString(playernum);
                players[playernum-1] = new Player(newPlayerName,i,j,redhold,greenhold,bluehold);
              }
            }
         }
         
         //random territory-cleaving routine part 3: removing all cleavers. 
              for (int i = 1; i < floor(screenwidth/16)-1; i++) {
                for (int j = 1; j < floor(screenheight/16)-1; j++) {
                     cleaveArray[i][j]=0;
                }
              }
        
          
         
        // random color-mixing routine
         for (int i = 1; i < floor(screenwidth/16)-1; i++) {
              for (int j = 1; j < floor(screenheight/16)-1; j++) {
             if ((ownerArray[i][j] != "nobody") && (floor(random(16)) == 1)) {
             int[] left = new int[3];
             int[] right = new int[3];
             int[] top = new int[3];
             int[] bottom = new int[3];
             if (ownerArray[i-1][j] != "nobody") {left[0] = colorArray[i-1][j][0]; left[1] = colorArray[i-1][j][1]; left[2] = colorArray[i-1][j][2];} else {left[0] = colorArray[i][j][0]; left[1] = colorArray[i][j][1]; left[2] = colorArray[i][j][2];}
             if (ownerArray[i+1][j] != "nobody") {right[0] = colorArray[i+1][j][0]; right[1] = colorArray[i+1][j][1]; right[2] = colorArray[i+1][j][2];} else {right[0] = colorArray[i][j][0]; right[1] = colorArray[i][j][1]; right[2] = colorArray[i][j][2];}
             if (ownerArray[i][j-1] != "nobody") {top[0] = colorArray[i][j-1][0]; top[1] = colorArray[i][j-1][1]; top[2] = colorArray[i][j-1][2];} else {top[0] = colorArray[i][j][0]; top[1] = colorArray[i][j][1]; top[2] = colorArray[i][j][2];}
             if (ownerArray[i][j+1] != "nobody") {bottom[0] = colorArray[i][j+1][0]; bottom[1] = colorArray[i][j+1][1]; bottom[2] = colorArray[i][j+1][2];} else {bottom[0] = colorArray[i][j][0]; bottom[1] = colorArray[i][j][1]; bottom[2] = colorArray[i][j][2];}
             colorArray[i][j][0] = round((colorArray[i][j][0] + left[0] + right[0] + top[0] + bottom[0])/5);
             colorArray[i][j][1] = round((colorArray[i][j][1] + left[1] + right[1] + top[1] + bottom[1])/5);
             colorArray[i][j][2]= round((colorArray[i][j][2] + left[2] + right[2] + top[2] + bottom[2])/5);
             }
          }
         }
        
        
        
        //draw the whole colorArray matrix on the screen
        for (int i = 0; i < floor(screenwidth/16); i++) {
          for (int j = 0; j < floor(screenheight/16); j++) {
            fill(colorArray[i][j][0],colorArray[i][j][1],colorArray[i][j][2]);
            rect(i*16,j*16,16,16);
            }
          }
        
                  //hazard-drawing routine
          for (int i = 1; i < floor(screenwidth/16)-1; i++) {
            for (int j = 1; j < floor(screenheight/16)-1; j++) {
              if (hazardArray[i][j]=="water") {
                fill(20,40,150);
                rect(i*16,j*16,16,16);
              }
            }
          }
        
        
                //border-drawing routine
          for (int i = 1; i < floor(screenwidth/16)-1; i++) {
             for (int j = 1; j < floor(screenheight/16)-1; j++) {
               int drawleft = 1;
               int drawright = 1;
               int drawtop = 1;
               int drawbottom = 1;
               if ((ownerArray[i-1][j] == ownerArray[i][j]) && (ownerArray[i][j] != "nobody")) {
                  drawleft=0;
               }
               
               if ((ownerArray[i+1][j] == ownerArray[i][j]) && (ownerArray[i][j] != "nobody")) {
                  drawright=0;
               }
               
               if ((ownerArray[i][j-1] == ownerArray[i][j]) && (ownerArray[i][j] != "nobody")) {
                  drawtop=0;
               }
               
               if ((ownerArray[i][j+1] == ownerArray[i][j]) && (ownerArray[i][j] != "nobody")) {
                  drawbottom=0;
               }
               
               stroke(255);
               strokeWeight(3);
               
               if (drawleft==1 && ownerArray[i][j] != "nobody") line(i*16,j*16,i*16,j*16+16);
               if (drawright==1 && ownerArray[i][j] != "nobody") line(i*16+16,j*16,i*16+16,j*16+16);
               if (drawtop==1 && ownerArray[i][j] != "nobody") line(i*16,j*16,i*16+16,j*16);
               if (drawbottom==1 && ownerArray[i][j] != "nobody") line(i*16,j*16+16,i*16+16,j*16+16);
               
               strokeWeight(1);
               stroke(0);
             }
          }
          
          //player cursor-drawing routine
          
                    for (int i = 1; i < floor(screenwidth/16)-1; i++) {
             for (int j = 1; j < floor(screenheight/16)-1; j++) {
                      if ((players[1].cursorX==i) && (players[1].cursorY==j)) {
            fill(255,255,255);
            rect(i*16,j*16,16,16);
                      }
             }
                    }
     
           //if (maintitle.visible==1) {
           //PImage title_image = loadImage("title.png");
           //image(title_image,200,200);
          // }
          
     }
        
        

