class OrangeRam  {
  PVector position = new PVector(0,0);
  PVector velocity = new PVector(0,-10);
  PVector acceleration = new PVector(0,0);
  PVector prevPos = new PVector(0,0);
  int enemyWidth = 80;
  int enemyHeight = 40;
  
  boolean tryingToFall = false;
  
  int attackTimer = 0;
  int pathFindTimer = 60;
  int health = 100;
  int direction = 1;
  
  OrangeRam(float xPos, float yPos)  {
    position.x = xPos;
    position.y = yPos;
  }
  
  void update()  {
    if(attackTimer == 0)  {
      if(abs(position.x - player.position.x) < 80 && abs(position.y - player.position.y) < 40)  {
         attackTimer++;
         pathFindTimer = 0;
       }
       if(pathFindTimer <= 0)  {
         pathFind(); 
       } else pathFindTimer--;
       
       if(velocity.y < 5)  {
         acceleration.y = 0.5;
       } else tryingToFall = false;
    } else {
      attacking();
    }
     
     for(int i = 0; i < block.size(); i++)  {
      
      if(position.x + 20 > block.get(i).blockX && position.x - 20 < block.get(i).blockX + block.get(i).blockW && position.y + (velocity.y / 2) > block.get(i).blockY - 7 && position.y < block.get(i).blockY + 7 && velocity.y > 0)  {
        if(!(tryingToFall && block.get(i).semiSolid))  {
        position.y = block.get(i).blockY; 
        velocity.y = 0;
        acceleration.y = 0;
        } 
      } else if(position.x + velocity.x + 1 > block.get(i).blockX && position.x <= block.get(i).blockX && position.y > block.get(i).blockY && position.y < block.get(i).blockY + block.get(i).blockH && !block.get(i).semiSolid)  {
        position.x = block.get(i).blockX - 1 - velocity.x;
        acceleration.x = 0;
      } else if(position.x + velocity.x - 1 < block.get(i).blockX + block.get(i).blockW && position.x >= block.get(i).blockX + block.get(i).blockW && position.y > block.get(i).blockY && position.y < block.get(i).blockY + block.get(i).blockH && !block.get(i).semiSolid)  {
        position.x = block.get(i).blockX + block.get(i).blockW + 1 - velocity.x;
        acceleration.x = 0;
      }
    }
    
    velocity.x += acceleration.x;
    velocity.y += acceleration.y;
    
    position.x += velocity.x;
    position.y += velocity.y;
    
    
    fill(240,135,0);
    rect(position.x - enemyWidth / 2, position.y - enemyHeight, enemyWidth, enemyHeight);
  }
  
  void attacking()  {
    velocity.x = 0;
    attackTimer++;
    if(attackTimer == 30)  {
      enemyHurtBox.add(new EnemyHurtBox(position.x - 30 + 30 * direction, position.y - enemyHeight * 1.2, 0, 0, 60, 50, 10, 10));
    } else if(attackTimer >= 100)  {
      attackTimer = 0;
    }
  }
  
  void pathFind()  {
    if(abs(position.x - prevPos.x) < 2 && abs(position.y - prevPos.y) < 2)  {
      velocity.y = -15;
    }
    prevPos = position.copy();
    
     if (player.position.x > position.x)  {
       velocity.x = 2;
       direction = 1;
     } else  {
       velocity.x = -2;
       direction = -1;
     }
     
     if(player.position.y > position.y)  {
       tryingToFall = true;
     } else if(player.position.y < position.y && velocity.y == 0 && acceleration.y == 0)  {
       velocity.y = -13;
       pathFindTimer -= 30;
     }
     
     pathFindTimer += 60;
  }
}
