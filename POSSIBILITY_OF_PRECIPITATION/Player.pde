class Player  {
  PVector position = new PVector(0,0);
  PVector velocity = new PVector(0,0);
  PVector acceleration = new PVector(0,0);
  float angle = 0;
  int jumpTimer = 15;
  int health = 100;
  
  boolean left = false;
  boolean right = false;
  boolean up = false;
  boolean down = false;
  
  boolean jumping = false;
  boolean canJump = true;
  
  boolean LClick = false;
  boolean RClick = false;
  boolean MClick = false;
  
  int primaryCooldown = 0;
  int secondaryCooldown = 0;
  int specialCooldown = 0;
  
  Player(float xPos, float yPos)  {
    position.x = xPos;
    position.y = yPos;
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
    
    if (velocity.y > 15)  {
      velocity.y = 15;
    }
    
    if(down && velocity.y == 0)  {
      velocity.y = 0.1; 
    }
    
    for(int i = enemyHitBox.size() - 1; i >= 0; i--)  {
      if(enemyHitBox.get(i).position.x + enemyHitBox.get(i).HBW > position.x - 50 && enemyHitBox.get(i).position.x < position.x + 50 && enemyHitBox.get(i).position.y + enemyHitBox.get(i).HBH > position.y - 100 && enemyHitBox.get(i).position.y < position.y)  {
        health -= enemyHitBox.get(i).damage;
        enemyHitBox.remove(i);
        if(health <= 0)  {
          health = 100;
          gameState = 0;
          block.clear();
          orangeRam.clear();
          redTitan.clear();
          greenBlaster.clear();
          makeStage = true;
        }
      }
    }
    if(position.y < 700)  {
      println(velocity.y);
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
    
    pushMatrix();
    translate(position.x, position.y - 50);
    angle = atan2(mouseY - position.y + 50, mouseX - position.x);
    rotate(angle);
    fill(200,0,0);
    rect(0, -15, 60, 30);
    popMatrix();
    if (LClick && primaryCooldown <= 0)  {
      playerHitBox.add(new PlayerHitBox(position.x, position.y - 50, 20, 0, 10, 10, 5, 30, angle));
      primaryCooldown += 10;
    } else if(primaryCooldown > 0)  {
      primaryCooldown--;
    }
    
    if (RClick && secondaryCooldown <= 0)  {
      playerHitBox.add(new PlayerHitBox(position.x, position.y - 50, 40, 0, 20, 20, 20, 30, angle));
      secondaryCooldown += 120;
    } else if(secondaryCooldown > 0)  {
      secondaryCooldown--;
    }
    
    if (MClick && specialCooldown <= 0)  {
      playerHitBox.add(new PlayerHitBox(position.x, position.y - 50, 40, 0, 20, 20, 31, 20, angle));
      specialCooldown += 20;
      if((mouseX > position.x && velocity.x > 0) || (mouseX < position.x && velocity.x < 0))  {
        velocity.x *= -1;
      } else velocity.x *= 1.5;
      if((mouseY > position.y && velocity.y > 0) || (mouseY < position.y && velocity.y < 0))  {
        velocity.y *= -1;
      } else velocity.y *= 1.5;
    } else if(specialCooldown > 0)  {
      specialCooldown--;
    }
  }
}
