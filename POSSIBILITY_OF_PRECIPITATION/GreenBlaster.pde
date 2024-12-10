class GreenBlaster  {
  PVector position = new PVector(0,0);
  PVector velocity = new PVector(0,0);
  PVector acceleration = new PVector(0,0);
  PVector prevPos = new PVector(0,0);
  int enemyWidth = 80;
  int enemyHeight = 80;
  
  int attackTimer = -200;
  int pathFindTimer = 60;
  int health = 100;
  float direction = 1;
  int turnAroundTimer = 0;
  
  GreenBlaster(float xPos, float yPos)  {
    position.x = xPos;
    position.y = yPos;
    health *= 1 + (enemyWave / 10);
  }
  
boolean update()  {
    if(attackTimer <= 0)  {
      if(attackTimer < 0)  {
        attackTimer++;
      }
      
      if(abs(player.position.y - position.y) < 200 && attackTimer == 0)  {
        attackTimer++;
      }
      
       if(pathFindTimer <= 0)  {
         pathFind(); 
       } else pathFindTimer--;
       
    } else {
      attacking();
    }
     
    if(position.x < 0)  {
       position.x = 0;
     } else if(position.x > width)  {
       position.x = width;
     }
     
     if(position.y < 0)  {
       position.y = 0;
     } else if(position.y > height)  {
       position.y = height;
     }
    
    velocity.x += acceleration.x;
    velocity.y += acceleration.y;
    
    if(turnAroundTimer > 0)  {
      position.x -= velocity.x;
      position.y -= velocity.y;
      turnAroundTimer--;
    } else  {
      position.x += velocity.x;
      position.y += velocity.y;
    }
    
    
    fill(0,0,180);
    rect(position.x - enemyWidth / 2, position.y - enemyHeight, enemyWidth, enemyHeight);
    
    if(health <= 0)  {
      return true;
    } else return false;
  }
  
  
  void attacking()  {
    velocity.x = 0;
    velocity.y = 0;
    attackTimer++;
    
    if(attackTimer == 30)  {
      enemyHitBox.add(new EnemyHitBox(position.x, position.y - enemyHeight / 2, 10 * direction, 0, 20, 20, 8, 100));
    } else if(attackTimer >= 100)  {
      attackTimer = -10;
    }
  }
  
  
  void pathFind()  {
    if(abs(position.x - prevPos.x) < 2 && abs(position.y - prevPos.y) < 2)  {
      velocity.y = -15;
    }
    prevPos = position.copy();
    
     if (player.position.x > position.x)  {
       velocity.x = 1;
       direction = 1;
     } else  {
       velocity.x = -1;
       direction = -1;
     }
     
     if (abs(player.position.x - position.x) < 100 && abs(player.position.y - position.y) < 100 && turnAroundTimer == 0)  {
       turnAroundTimer += 60;
     }
    
     if(player.position.y > position.y + 50)  {
       velocity.y = 1;
     } else if(player.position.y < position.y - 50)  {
       velocity.y = -1;
     }
     
     pathFindTimer += 30;
  }
}
