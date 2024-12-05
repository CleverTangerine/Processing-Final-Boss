Player player;
ArrayList<Block> block = new ArrayList<Block>();
int gameState = 2;
boolean makeStage = true;

void setup()  {
  size(1200, 800);
  player = new Player(width/2, 650, 0);
}

void draw()  {
  background(200);
    switch(gameState)  {
      case 2:
      if(makeStage)  {
        //block.add(new Block(0,600,1200,200,true));
        block.add(new Block(0,700,1200,100,false));
        block.add(new Block(0,0,100,800,false));
        block.add(new Block(1100,0,100,800,false));
        block.add(new Block(400,550,100,151,false));
        makeStage = false;
      }
      break;
    }
  
  for(int i = 0; i < block.size(); i++)  {
     block.get(i).update();
  }
  player.update();
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
