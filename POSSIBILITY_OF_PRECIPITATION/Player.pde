class Player  {
  PVector position = new PVector(0,0);
  PVector velocity = new PVector(0,0);
  PVector acceleration = new PVector(0,0);
  int character;
  int jumpTimer = 15;
  
  boolean left = false;
  boolean right = false;
  boolean up = false;
  boolean down = false;
  
  boolean jumping = false;
  boolean canJump = true;
  
  Player(float xPos, float yPos, int character)  {
    position.x = xPos;
    position.y = yPos;
    this.character = character;
  }
  
  void update()  {
    if(left && velocity.x > -3)  {
      acceleration.x = -0.15;
      if(velocity.x > 0 && velocity.y == 0)  {
         acceleration.x = -0.6;
      }
    }
    
    if(right && velocity.x < 3)  {
      acceleration.x = 0.15;
      if(velocity.x < 0 && velocity.y == 0)  {
         acceleration.x = 0.6;
      }
    }
    
    if(!right && !left)  {
      acceleration.x = 0;
      
      if(abs(velocity.x) < 0.2)  {
        velocity.x = 0;
        acceleration.x = 0;
      }
      if (abs(velocity.x) > 0 && velocity.y == 0)  {
        if(velocity.x < 0)  {
          acceleration.x = 0.4;
        } else acceleration.x = -0.4;
      }
    }
    
    if(up && velocity.y == 0 && acceleration.y == 0 && canJump)  {
      jumping = true;
    }
    
    if(up && jumping && jumpTimer > 0)  {
      velocity.y = -12;
      jumpTimer--;
    } else jumping = false;
    
    if(jumping)  {
      canJump = false; 
    } else if(!up)  {
      canJump = true; 
    }
    
    if(velocity.y < 6)  {
      acceleration.y = 1;
    }
    
    if(down && velocity.y == 0)  {
      velocity.y = 0.1; 
    }
    
    for(int i = 0; i < block.size(); i++)  {
      
      if(position.x + 20 > block.get(i).blockX && position.x - 20 < block.get(i).blockX + block.get(i).blockW && position.y + (velocity.y / 2) > block.get(i).blockY - 7 && position.y < block.get(i).blockY + 7 && velocity.y > 0)  {
        if(!(down && block.get(i).semiSolid))  {
        position.y = block.get(i).blockY; 
        velocity.y = 0;
        acceleration.y = 0;
        jumpTimer = 15;
        }
      } else if(position.x + velocity.x + 1 > block.get(i).blockX && position.x <= block.get(i).blockX && position.y > block.get(i).blockY && position.y < block.get(i).blockY + block.get(i).blockH && !block.get(i).semiSolid)  {
        position.x = block.get(i).blockX - 1; 
        velocity.x = 0;
        acceleration.x = 0;
      } else if(position.x + velocity.x - 1 < block.get(i).blockX + block.get(i).blockW && position.x >= block.get(i).blockX + block.get(i).blockW && position.y > block.get(i).blockY && position.y < block.get(i).blockY + block.get(i).blockH && !block.get(i).semiSolid)  {
        position.x = block.get(i).blockX + block.get(i).blockW + 1;
        velocity.x = 0;
        acceleration.x = 0;
      }
    }
    
    velocity.x += acceleration.x;
    velocity.y += acceleration.y;
    
    position.x += velocity.x;
    position.y += velocity.y;
    
    
    fill(255,0,0);
    rect(position.x - 25, position.y - 100, 50, 100);
  }
}
