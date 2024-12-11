class GreenBlaster  {
  // The position of the enemy, or rather, the sprite, is at the bottom middle
  // That's why some position based boolean expressions use enemyWidth / 2
  PVector position = new PVector(0,0);
  PVector velocity = new PVector(0,0);
  PVector acceleration = new PVector(0,0);

  // width and height refer to the hurtbox
  int enemyWidth = 80;
  int enemyHeight = 80;
  
  // The attack timer that determines what the enemy does while they're attacking
  int attackTimer = -200;
  
  // A timer used to determine when the enemy will update its pathfinding
  // this was done to reduce lag
  int pathFindTimer = 60;
  
  // If the enemy runs out health, they get removed from their list
  int health = 100;
  
  // 1 = facing right, -1 = facing left, this is used for spawn hitboxes and drawing the enemy
  float direction = 1;
  
  // A timer that ensures the enemy will stay away from the player so it can make use of its range and stay as a challenge
  int turnAroundTimer = 0;
  
  // The actual sprite it uses to draw itself
  PImage sprite = greenBlasterSprite[0];
  // The index in the sprite array  to determine what animation frame it's on
  int spriteNum = 0;
  // A timer used for movement to make the enemy look like it's moving
  int animationTimer = 0;
  
  GreenBlaster(float xPos, float yPos)  {
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
    if(abs(player.position.y - position.y) < 200 && attackTimer == 0)  {
      attackTimer++;
    }
    // Checks if the enemy is suppsoed to update its pathfinding
     if(pathFindTimer <= 0)  {
       pathFind(); 
     } else pathFindTimer--;
     
  } else {
    attacking();
  }
    
  // Checks if the enemy has moved enough to update its sprite
  animationTimer++;
  if(animationTimer > 10)  {
    animationTimer -= 10;
    spriteNum++;
    if(spriteNum > 3)  {
      spriteNum = 0;
    }
    sprite = greenBlasterSprite[spriteNum];
  }
  
  // prevents the enemy form going off screen
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
  
  // Determines whether the enemy should be backing away form the player or not
  if(turnAroundTimer > 0)  {
    position.x -= velocity.x;
    position.y -= velocity.y;
    turnAroundTimer--;
  } else  {
    position.x += velocity.x;
    position.y += velocity.y;
  }
  
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
    velocity.y = 0;
    
    attackTimer++;
    
    // Speeds up spinning animation while they're attacking
    animationTimer++;
    
    if(attackTimer == 30)  {
      enemyHitBox.add(new EnemyHitBox(position.x, position.y - enemyHeight / 2, 10 * direction, 0, 20, 20, 8, 100));
    } else if(attackTimer >= 100)  {
      // Attack cooldown
      attackTimer = -10;
    }
  }
  
  
  void pathFind()  {
    
    // This code makes the enemy chase after the player
     if (player.position.x > position.x)  {
       velocity.x = 1;
       direction = 1;
     } else  {
       velocity.x = -1;
       direction = -1;
     }
     
     // The boolean expression to check if the enemy is too close to the player
     if (abs(player.position.x - position.x) < 100 && abs(player.position.y - position.y) < 100 && turnAroundTimer == 0)  {
       turnAroundTimer += 60;
     }
    
     if(player.position.y > position.y + 50)  {
       velocity.y = 1;
     } else if(player.position.y < position.y - 50)  {
       velocity.y = -1;
     }
     
     // Cooldown for pathfinding
     pathFindTimer += 30;
  }
}
