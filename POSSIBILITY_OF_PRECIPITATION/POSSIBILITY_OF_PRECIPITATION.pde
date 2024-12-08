Player player;

ArrayList<Block> block = new ArrayList<Block>();

ArrayList<EnemyHurtBox> enemyHurtBox = new ArrayList<EnemyHurtBox>();

ArrayList<RedTitan> redTitan = new ArrayList<RedTitan>();
ArrayList<OrangeRam> orangeRam = new ArrayList<OrangeRam>();
ArrayList<GreenBlaster> greenBlaster = new ArrayList<GreenBlaster>();

boolean makeStage = true;

int gameState = 2;

int enemyWave = 0;
int enemyCredits = 5;
int enemyTimer = 500;
int enemyType = 0;
int enemySpawnArea;
float enemySpawnX;
float enemySpawnY;


void setup()  {
  size(1200, 800);
  player = new Player(width/2, 650, 0);
}

void draw()  {
  background(200);
    switch(gameState)  {
      case 2:
      spawnDirector();
      if(makeStage)  {
        
        block.add(new Block(0,700,1200,100,false));
        block.add(new Block(0,0,100,800,false));
        block.add(new Block(1100,0,100,800,false));
        block.add(new Block(100,600,1000,100,true));
        block.add(new Block(400,550,100,151,false));
        makeStage = false;
      }
      break;
    }
  
  for(int i = 0; i < block.size(); i++)  {
     block.get(i).update();
  }
  for(int i = redTitan.size() - 1; i >= 0; i--)  {
     redTitan.get(i).update();
  }
  for(int i = orangeRam.size() - 1; i >= 0; i--)  {
     orangeRam.get(i).update();
  }
  for(int i = greenBlaster.size() - 1; i >= 0; i--)  {
     greenBlaster.get(i).update();
  }
  for(int i = enemyHurtBox.size() - 1; i >= 0; i--)  {
     if(enemyHurtBox.get(i).update())  {
       enemyHurtBox.remove(i);
     }
  }
  player.update();
}


void spawnDirector()  {
  //println(enemyTimer + " " + orangeRam.size());
  enemyTimer++;
  if(enemyTimer > 1000)  {
    
    while(true)  {
      if(enemyCredits <= 0)  {
        enemyCredits += 5;
        enemyTimer = 0;
        break;
      }
      enemyType = int(random(0, enemyCredits)) + 1;
      enemySpawnArea = int(random(3, block.size()));
      enemySpawnX = random(-10, 10) + block.get(enemySpawnArea).blockX + block.get(enemySpawnArea).blockW / 2;
      enemySpawnY = block.get(enemySpawnArea).blockY;
      if(enemyType > 4)  {
        redTitan.add(new RedTitan(enemySpawnX, enemySpawnY));
        enemyCredits = 4;
        enemyCredits -= 4;
      } else if(enemyType > 2)  {
        greenBlaster.add(new GreenBlaster(enemySpawnX, enemySpawnY));
        enemyCredits = 2;
        enemyCredits -= 2;
      } else  {
        orangeRam.add(new OrangeRam(enemySpawnX, enemySpawnY));
        enemyCredits--;
      }
    }
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
