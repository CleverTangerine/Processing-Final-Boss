class RedTitan  {
  // The position of the enemy, or rather, the sprite, is at the bottom middle
  // That's why some position based boolean expressions use enemyWidth / 2
  PVector position = new PVector(0,0);
  PVector velocity = new PVector(0,-10);
  PVector acceleration = new PVector(0,0);
  
  // The position of the enemy since the last time they tried pathfinding
  // Used to determine if they are stuck
  PVector prevPos = new PVector(0,0);
  
  // width and height refer to the hurtbox
  int enemyWidth = 100;
  int enemyHeight = 140;
  
  // A boolean that checks if the enemy wants to fall through a semi-solid platform to reach the player
  boolean tryingToFall = false;
  
  // The attack timer that determines what the enemy does while they're attacking
  int attackTimer = -100;
  
  // A timer used to determine when the enemy will update its pathfinding
  // this was done to reduce lag
  int pathFindTimer = 60;
  
  // If the enemy runs out health, they get removed from their list
  int health = 150;
  
  // 1 = facing right, -1 = facing left, this is used for spawn hitboxes and drawing the enemy
  int direction = 1;
  
  // The actual sprite it uses to draw itself
  PImage sprite = redTitanSprite[0];
  // The index in the sprite array  to determine what animation frame it's on
  int spriteNum = 0;
  // A timer used for movement to make the enemy look like it's moving
  int animationTimer = 0;
  
  RedTitan(float xPos, float yPos)  {
    position.x = xPos;
    position.y = yPos;
    // health increases every wave
    health *= 1 + (enemyWave / 10);
  }
  
boolean update()  {
  // Checks if the enemy is attacking. If the timer is higher than 0, that means it's attacking
    // A negative value means they're on cooldown
    if(attackTimer <= 0)  {
      if(attackTimer < 0)  {
        attackTimer++;
      }
      
      // Checks if the player is in their sights to start attacking
      if(abs(position.x - player.position.x) < 80 && abs(position.y - player.position.y) < 80)  {
         attackTimer++;
         pathFindTimer = 0;
       }
       
       // Checks if the enemy is suppsoed to update its pathfinding
       if(pathFindTimer <= 0)  {
         pathFind(); 
       } else pathFindTimer--;
       
       // A cap on the enemy's gravity that also tells the game that they're not trying to fall anymore
       if(velocity.y < 5)  {
         acceleration.y = 0.5;
       } else tryingToFall = false;
       
       // Checks if the enemy has moved enough to update its sprite
       animationTimer += abs(velocity.x);
       if(animationTimer > 20)  {
         animationTimer -= 20;
         spriteNum++;
         if(spriteNum > 2)  {
           spriteNum = 1;
         }          
         sprite = redTitanSprite[spriteNum];
       }
       
       // A sprite that's used when they enemy is standing still
      if(velocity.x == 0)  {
        animationTimer = 0;
        spriteNum = 0;
        sprite = redTitanSprite[spriteNum];
      }
       
    } else {
      attacking();
    }
     
     // Collision detection, checks every block for it
     for(int i = 0; i < block.size(); i++)  {
      // This is to make sure they can't fall through floors
      if(position.x + 20 > block.get(i).position.x && position.x - 20 < block.get(i).position.x + block.get(i).blockW && position.y + (velocity.y / 2) > block.get(i).position.y - 7 && position.y < block.get(i).position.y + 7 && velocity.y > 0)  {
        // They can only fall through if they're trying to, and the platform is a semi-solid
        if(!(tryingToFall && block.get(i).semiSolid))  {
        position.y = block.get(i).position.y; 
        velocity.y = 0;
        acceleration.y = 0;
        } else tryingToFall = false;
      // This is to make sure they can't walk through walls, approaching from the right
      } else if(position.x + velocity.x + 1 > block.get(i).position.x && position.x <= block.get(i).position.x && position.y > block.get(i).position.y && position.y < block.get(i).position.y + block.get(i).blockH && !block.get(i).semiSolid)  {
        position.x = block.get(i).position.x - 1 - velocity.x;
        acceleration.x = 0;
        // This is to make sure they can't walk through walls, approaching from the left
      } else if(position.x + velocity.x - 1 < block.get(i).position.x + block.get(i).blockW && position.x >= block.get(i).position.x + block.get(i).blockW && position.y > block.get(i).position.y && position.y < block.get(i).position.y + block.get(i).blockH && !block.get(i).semiSolid)  {
        position.x = block.get(i).position.x + block.get(i).blockW + 1 - velocity.x;
        acceleration.x = 0;
      }
    }
    
    velocity.x += acceleration.x;
    velocity.y += acceleration.y;
    
    position.x += velocity.x;
    position.y += velocity.y;
    
    // returning true kills the object, returning false keeps it alive
    if(health <= 0)  {
      return true;
    } else return false;
  }
  
  
  void display()  {
    // Creates a matrix to flip sprites when the enemy turns around
    // Also places sprite on screen
    pushMatrix();
    translate(position.x, position.y);
    scale(direction, 1);
    image(sprite, -enemyWidth / 2, -enemyHeight);
    popMatrix();
  }
  
  
  void attacking()  {
    // Stops all movement before attacking to let the player escape
    velocity.x = 0;
    attackTimer++;
    
    // Animations change while they're attacking
    if(attackTimer == 20)  {
      spriteNum = 3;
    }
    if(attackTimer == 45)  {
      enemyHitBox.add(new EnemyHitBox(position.x - 70 + 70 * direction, position.y - enemyHeight * 1.2, 0, 0, 140, 160, 20, 10));
      spriteNum = 4;
    }
    if(attackTimer == 50)  {
      spriteNum = 3;
    }
    if(attackTimer == 15)  {
      spriteNum = 0;
    }
    // Attack cooldwom
    if(attackTimer >= 120)  {
      attackTimer = -20;
    }
    sprite = redTitanSprite[spriteNum];
  }
  
  
  void pathFind()  {
    // Checks if the player is stuck by comparing their current position to the position they last were when they were pathfinding
    // Makes them jump up high to escape
    if(abs(position.x - prevPos.x) < 2 && abs(position.y - prevPos.y) < 2)  {
      velocity.y = -15;
    }
    prevPos = position.copy();
    
    // This code makes the enemy chase after the player
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
     
     // Cooldown for pathfinding
     pathFindTimer += 60;
  }
}
