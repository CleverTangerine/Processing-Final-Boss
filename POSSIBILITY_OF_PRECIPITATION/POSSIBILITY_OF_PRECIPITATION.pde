// Player object
Player player;

// Start Button object
Button button;

// Object list for the Collision (i.e. walls, floors, and the platforms)
ArrayList<Block> block = new ArrayList<Block>();

// Object list for the player's projectiles
ArrayList<PlayerHitBox> playerHitBox = new ArrayList<PlayerHitBox>();

// Object list for the enemies hitboxes
ArrayList<EnemyHitBox> enemyHitBox = new ArrayList<EnemyHitBox>();

// Object list for each kind of enemy
ArrayList<RedTitan> redTitan = new ArrayList<RedTitan>();
ArrayList<OrangeRam> orangeRam = new ArrayList<OrangeRam>();
ArrayList<GreenBlaster> greenBlaster = new ArrayList<GreenBlaster>();

// PImage lists for all of the sprites each corresponding object will use
PImage playerSprite[] = new PImage[5];
PImage orangeRamSprite[] = new PImage[6];
PImage redTitanSprite[] = new PImage[5];
PImage greenBlasterSprite[] = new PImage[4];

// A boolean that makes sure a stage is only made once, preventing block objects from spawning every frame
boolean makeStage = true;

// 0 = Start Menu, 1 = Gameplay
int gameState = 0;

// A counter that tracks how many waves of enemies have been spawned. Every wave, enemy credits gets bigger, creating progression.
int enemyWave = 0;

// A currency that's used by the spawn director. Different enemies cost different prices, with stronger enemies costing less than weaker ones.
// This ensures the player can't get bombarded by strong enemies.
int enemyCredits = 5;

// A timer that counts down till a wave of enemies spawns
int enemyTimer = 300;

// A variable that determines what type of enemy will spawn
int enemyType = 0;

// This variable looks through the list of blocks and chooses one to spawn the enemies at
int enemySpawnArea;

// The X coordinate of the enemy's spawn location, determined by the x position of the block they spawn at
float enemySpawnX;

// The Y coordinate of the enemy's spawn location, determined by the y position of the block they spawn at
float enemySpawnY;


void setup()  {
  size(1200, 800);
  
  // Loading all of the sprites, they were named to accomodate these loops
  for(int i = 0; i < 4; i++)  {
    if(i == 3)  {
      // The exception is the arm, just so it would be easier for me to track
      playerSprite[i] = loadImage("Images/CommandontArm.png");
    } else playerSprite[i] = loadImage("Images/Commandont" + (i + 1) + ".png");
  }
  for(int i = 0; i < 5; i++)  {
    redTitanSprite[i] = loadImage("Images/RedTitan" + (i + 1) + ".png");
  }
  for(int i = 0; i < 5; i++)  {
    orangeRamSprite[i] = loadImage("Images/OrangeRam" + (i + 1) + ".png");
  }
  for(int i = 0; i < 4; i++)  {
    greenBlasterSprite[i] = loadImage("Images/GreenBlaster" + (i + 1) + ".png");
  }
  
  // The player and start button only need to be made once, so they're made in setup
  player = new Player(width/2, 650);
  button = new Button(125, 300, 225, 100);
}

void draw()  {
  background(110, 165, 220);
    switch(gameState)  {
      case 0:
      // These blocks only need to be made once, and not every frame, so makeStage makes these only get made once
      if(makeStage)  {
        // These blocks in particular are solid, and ensure the player can't fall out of the play screen
        block.add(new Block(1100,0,100,800,false, color(240, 185, 145)));
        block.add(new Block(0,0,100,800,false, color(240, 185, 145)));
        block.add(new Block(0,700,1200,100,false, color(240, 185, 145)));
        block.add(new Block(400,550,100,151,false, color(240, 185, 145)));
        // makeStage turns false to make it only run once
        makeStage = false;
      }
      // The button is only supposed to be pressable during the start menu, so it's only displayed at the Start Screen
      button.display();
      
      break;
      
      case 1:
      // spawnDirector is what spawns enemies, so it only starts running once the player has gotten to the play loop
      spawnDirector();
      // Additional platforms that help the player know they've entered the play loop
      if(makeStage)  {
        block.add(new Block(700,300,300,300,true, color(240, 120, 90)));
        block.add(new Block(150,300,200,300,true, color(175, 100, 180)));
        block.add(new Block(150,500,200,200,true, color(90, 225, 115)));
        block.add(new Block(600,400,300,300,true, color(235, 225, 80)));
        block.add(new Block(600,550,500,150,true, color(114, 120, 240)));
        makeStage = false;
      }
      break;
    }
  
  // This section updates all of the objects
  // The reason some of these go backwards is because of deleting objects.
  // When an enemy dies, the length of the array changes, and the indexes get moved around.
  // So, by making it tick backwards, the loop won't change; even if an enemy dies
  for(int i = 0; i < block.size(); i++)  {
     block.get(i).display();
  }
  
  // The update functions are actually booleans that return whether an object has expired yet
  for(int i = enemyHitBox.size() - 1; i >= 0; i--)  {
     if(enemyHitBox.get(i).update())  {
       enemyHitBox.remove(i);
     }
  }
  for(int i = playerHitBox.size() - 1; i >= 0; i--)  {
     if(playerHitBox.get(i).update())  {
       playerHitBox.remove(i);
     }
  }
  for(int i = redTitan.size() - 1; i >= 0; i--)  {
    redTitan.get(i).display(); 
    if(redTitan.get(i).update())  {
       redTitan.remove(i);
     }
  }
  for(int i = orangeRam.size() - 1; i >= 0; i--)  {
    orangeRam.get(i).display(); 
    if(orangeRam.get(i).update())  {
       orangeRam.remove(i);
     }
  }
  for(int i = greenBlaster.size() - 1; i >= 0; i--)  {
    greenBlaster.get(i).display(); 
    if(greenBlaster.get(i).update())  {
       greenBlaster.remove(i);
     }
  }
  player.display();
  player.update();
}

// Function that spawns enemies
void spawnDirector()  {
  enemyTimer++;
  if(enemyTimer > 500)  {
    enemyWave++;
    // The while(true) makes it so that this loops runs for as long as it needs to
    while(true)  {
      // The loop breaks when there's no more enemy credits
      if(enemyCredits <= 0)  {
        // enemyCredits gets restocked for the next wave, growing more and more to create progression
        enemyCredits += 5 + enemyWave;
        enemyTimer = 0;
        break;
      }
      // The game can only choose to spend credits on an enemy if it has enough credits
      // So, it pulls from a random number generator that chooses between the amount of credits and 1
      enemyType = int(random(0, enemyCredits)) + 1;
      // random() starts at 2 because the first 2 blocks are the walls, which enemies shouldn't spawn on
      enemySpawnArea = int(random(2, block.size()));
      // Grabs the spawn location from the lock it will spawn on; as determined by spawnArea
      enemySpawnX = random(-10, 10) + block.get(enemySpawnArea).position.x + block.get(enemySpawnArea).blockW / 2;
      enemySpawnY = block.get(enemySpawnArea).position.y;
      
      if(enemyType > 4)  {
        // Red Titan costs 4 credits
        redTitan.add(new RedTitan(enemySpawnX, enemySpawnY));
        enemyCredits -= 4;
      } else if(enemyType > 2)  {
        // Green Blaster costs 2 credits
        greenBlaster.add(new GreenBlaster(enemySpawnX, enemySpawnY));
        enemyCredits -= 2;
      } else  {
        // Orange Ram costs 1 credit
        orangeRam.add(new OrangeRam(enemySpawnX, enemySpawnY));
        enemyCredits--;
      }
    }
  }
}

// These functions that handle key/mouse pressing are designed in a way that allows for multiple keys to be pressed down at once
// key/mousePressed only checks the most recent key/mouse input. But if I just check whether these keys were just pressed or just released,
// I can have multiple keys/mouse buttons down at once
void mousePressed()  {
  if(mouseButton == LEFT)  {
    player.LClick = true;
  }
  if(mouseButton == RIGHT)  {
    player.RClick = true;
  } 
  if(mouseButton == CENTER)  {
    player.MClick = true;
  }
}

void mouseReleased()  {
  if(mouseButton == LEFT)  {
    player.LClick = false;
  }
  if(mouseButton == RIGHT)  {
    player.RClick = false;
  }
  if(mouseButton == CENTER)  {
    player.MClick = false;
  }
}

void keyPressed()  {
  if(key == 'w')  {
    player.up = true; 
  }
  if(key == 'a')  {
    player.left = true; 
  }
  if(key == 's')  {
    player.down = true; 
  }
  if(key == 'd')  {
    player.right = true; 
  }
}

void keyReleased()  {
   if(key == 'w')  {
    player.up = false; 
  }
  if(key == 'a')  {
    player.left = false; 
  }
  if(key == 's')  {
    player.down = false; 
  }
  if(key == 'd')  {
    player.right = false; 
  }
}
