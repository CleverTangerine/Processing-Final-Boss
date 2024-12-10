Player player;

Button button;

ArrayList<Block> block = new ArrayList<Block>();

ArrayList<PlayerHitBox> playerHitBox = new ArrayList<PlayerHitBox>();
ArrayList<EnemyHitBox> enemyHitBox = new ArrayList<EnemyHitBox>();

ArrayList<RedTitan> redTitan = new ArrayList<RedTitan>();
ArrayList<OrangeRam> orangeRam = new ArrayList<OrangeRam>();
ArrayList<GreenBlaster> greenBlaster = new ArrayList<GreenBlaster>();

boolean makeStage = true;

int gameState = 0;

int enemyWave = 0;
int enemyCredits = 5;
int enemyTimer = 300;
int enemyType = 0;
int enemySpawnArea;
float enemySpawnX;
float enemySpawnY;


void setup()  {
  size(1200, 800);
  player = new Player(width/2, 650);
  button = new Button(125, 300, 225, 100);
}

void draw()  {
  background(200);
    switch(gameState)  {
      case 0:
      if(makeStage)  {
        block.add(new Block(1100,0,100,800,false));
        block.add(new Block(0,0,100,800,false));
        block.add(new Block(0,700,1200,100,false));
        block.add(new Block(400,550,100,151,false));
        makeStage = false;
      }
      fill(230, 215, 155);
      rect(0, 0, width,  height);
      fill(75, 40, 100);
      rect(100, 100, 300, 200);
      button.display();
      
      break;
      case 1:
      spawnDirector();
      if(makeStage)  {
        block.add(new Block(700,300,300,300,true));
        block.add(new Block(150,200,200,300,true));
        block.add(new Block(150,400,200,300,true));
        block.add(new Block(600,400,300,300,true));
        block.add(new Block(600,550,500,150,true));
        makeStage = false;
      }
      break;
    }
  
  for(int i = 0; i < block.size(); i++)  {
     block.get(i).update();
  }
  for(int i = redTitan.size() - 1; i >= 0; i--)  {
     if(redTitan.get(i).update())  {
       redTitan.remove(i);
       continue;
     }
  }
  for(int i = orangeRam.size() - 1; i >= 0; i--)  {
     if(orangeRam.get(i).update())  {
       orangeRam.remove(i);
       continue;
     }
  }
  for(int i = greenBlaster.size() - 1; i >= 0; i--)  {
     if(greenBlaster.get(i).update())  {
       greenBlaster.remove(i);
       continue;
     }
  }
  for(int i = enemyHitBox.size() - 1; i >= 0; i--)  {
     if(enemyHitBox.get(i).update())  {
       enemyHitBox.remove(i);
       continue;
     }
  }
  for(int i = playerHitBox.size() - 1; i >= 0; i--)  {
     if(playerHitBox.get(i).update())  {
       playerHitBox.remove(i);
       continue;
     }
  }
  player.update();
}


void spawnDirector()  {
  enemyTimer++;
  //println(enemyTimer + " " + enemyCredits + " " + enemyWave);
  if(enemyTimer > 500)  {
    enemyWave++;
    while(true)  {
      if(enemyCredits <= 0)  {
        enemyCredits += 5 + enemyWave;
        enemyTimer = 0;
        break;
      }
      enemyType = int(random(0, enemyCredits)) + 1;
      enemySpawnArea = int(random(2, block.size()));
      enemySpawnX = random(-10, 10) + block.get(enemySpawnArea).blockX + block.get(enemySpawnArea).blockW / 2;
      enemySpawnY = block.get(enemySpawnArea).blockY;
      if(enemyType > 4)  {
        redTitan.add(new RedTitan(enemySpawnX, enemySpawnY));
        enemyCredits -= 4;
      } else if(enemyType > 2)  {
        greenBlaster.add(new GreenBlaster(enemySpawnX, enemySpawnY));
        enemyCredits -= 2;
      } else  {
        orangeRam.add(new OrangeRam(enemySpawnX, enemySpawnY));
        enemyCredits--;
      }
    }
  }
}

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
