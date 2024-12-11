class Player  {
  // The position of the enemy, or rather, the sprite, is at the bottom middle
  // That's why some position based boolean expressions use playerW
  // playerW is the width, and playerH is the height
  PVector position = new PVector(0,0);
  PVector velocity = new PVector(0,0);
  PVector acceleration = new PVector(0,0);
  int playerW = 50;
  int playerH = 100;
  
  // angle refers to the angle between the mouse and the player
  // This is used for the arm
  float angle = 0;
  
  // jumpTimer checks how long the jump button(up) can be held for to increase the jump height
  int jumpTimer = 15;
  
  // If the player runs out of health, the game returns back to the start screen 
  int health = 100;
  
  // booleans to checks when buttons are being pressed
  boolean left = false;
  boolean right = false;
  boolean up = false;
  boolean down = false;
  
  // boolean to determine whether the player is jumping or not
  boolean jumping = false;
  // boolean that stops the player from holding the jump button, and keep jumping
  boolean canJump = true;
  // 1 = facing right, -1 = facing left, this is used for spawn hitboxes and drawing the player
  int direction = 1;
  
  // Mouse input. LClick = left mouse button, RClick = right mouse button, MClick = mouse wheel
  boolean LClick = false;
  boolean RClick = false;
  boolean MClick = false;
  
  // Cooldown for each kind of attack
  // LClick controls primary, RClick controls secondary, MClick controls special
  int primaryCooldown = 0;
  int secondaryCooldown = 0;
  int specialCooldown = 0;
  
  // The actual sprite it uses to draw itself
  PImage sprite = playerSprite[0];
  // The index in the sprite array  to determine what animation frame it's on
  int spriteNum = 0;
  // A timer used for movement to make the enemy look like it's moving
  int animationTimer = 0;
  
  Player(float xPos, float yPos)  {
    position.x = xPos;
    position.y = yPos;
  }
  
  
  void update()  {
    // Movement code
    // Caps are in place to make sure the player doens't move too fast and clip through collision
    // The player moves faster in the opposite direction they're going to make turning around faster
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
    
    // Code that makes decelerating faster
    if(!right && !left)  {
      acceleration.x = 0;
      
      if(abs(velocity.x) < 0.2)  {
        velocity.x = 0;
        acceleration.x = 0;
      }
      // Makes the player stop if they're moving too slow AND if they're not trying to move
      if (abs(velocity.x) > 0 && velocity.y == 0)  {
        if(velocity.x < 0)  {
          acceleration.x = 0.4;
        } else acceleration.x = -0.4;
      }
    }
    
    // Initates jumping
    if(up && velocity.y == 0 && acceleration.y == 0 && canJump)  {
      jumping = true;
    }
    
    // Lets the player keep ascending if they hold the jump button down
    // Lets them tap jump too
    if(up && jumping && jumpTimer > 0)  {
      velocity.y = -12;
      jumpTimer--;
    } else jumping = false;
    
    // Stops the player from holding the jump button and continuously jump
    if(jumping)  {
      canJump = false; 
    } else if(!up)  {
      canJump = true; 
    }
    
    // Cap's on the player's gravity
    if(velocity.y < 6)  {
      acceleration.y = 1;
    }
    
    if (velocity.y > 15)  {
      velocity.y = 15;
    }
    
    // Makes the player move down so they can test the block collision
    if(down && velocity.y == 0)  {
      velocity.y = 0.1; 
    }
    
    // Collision detection for enemy hitboxes
    for(int i = enemyHitBox.size() - 1; i >= 0; i--)  {
      if(enemyHitBox.get(i).position.x + enemyHitBox.get(i).HBW > position.x - playerW / 2 && enemyHitBox.get(i).position.x < position.x + playerW / 2 && enemyHitBox.get(i).position.y + enemyHitBox.get(i).HBH > position.y - playerH && enemyHitBox.get(i).position.y < position.y)  {
        // Code that makes the player take damage
        health -= enemyHitBox.get(i).damage;
        enemyHitBox.remove(i);
        // When the player dies, everything gets reset back to the start screen
        if(health <= 0)  {
          health = 100;
          gameState = 0;
          block.clear();
          orangeRam.clear();
          redTitan.clear();
          greenBlaster.clear();
          playerHitBox.clear();
          enemyWave = 0;
          enemyTimer = 300;
          enemyCredits = 5;
          makeStage = true;
        }
      }
    }
    
    // Collision detection, checks every block for it
    for(int i = 0; i < block.size(); i++)  {
      // This is to make sure they can't fall through floors
      if(position.x + 20 > block.get(i).position.x && position.x - 20 < block.get(i).position.x + block.get(i).blockW && position.y + (velocity.y / 2) > block.get(i).position.y - 7 && position.y < block.get(i).position.y + 7 && velocity.y > 0)  {
        // They can only fall through if they're trying to, and the platform is a semi-solid
        if(!(down && block.get(i).semiSolid))  {
        position.y = block.get(i).position.y; 
        velocity.y = 0;
        acceleration.y = 0;
        jumpTimer = 15;
        }
        // This is to make sure they can't walk through walls, approaching from the right
      } else if(position.x + velocity.x + 1 > block.get(i).position.x && position.x <= block.get(i).position.x && position.y > block.get(i).position.y && position.y < block.get(i).position.y + block.get(i).blockH && !block.get(i).semiSolid)  {
        position.x = block.get(i).position.x - 1; 
        velocity.x = 0;
        acceleration.x = 0;
        // This is to make sure they can't walk through walls, approaching from the left
      } else if(position.x + velocity.x - 1 < block.get(i).position.x + block.get(i).blockW && position.x >= block.get(i).position.x + block.get(i).blockW && position.y > block.get(i).position.y && position.y < block.get(i).position.y + block.get(i).blockH && !block.get(i).semiSolid)  {
        position.x = block.get(i).position.x + block.get(i).blockW + 1;
        velocity.x = 0;
        acceleration.x = 0;
      }
    }
    
    // Code that determines which way the player is facing
    if(velocity.x > 0)  {
      direction = 1;
    } else if(velocity.x < 0)  {
      direction = -1;
    }
    
    // Sprites update when the player moves
    animationTimer += abs(velocity.x);
    if(animationTimer > 60)  {
      animationTimer -= 60;
      spriteNum++;
      if(spriteNum > 1)  {
        spriteNum = 0;
      }
      sprite = playerSprite[spriteNum];
    }
    
    // Uses a different sprite for when the player is airborne
    if(velocity.y != 0)  {
      spriteNum = 2;
      sprite = playerSprite[spriteNum];
    }
    
    // Sprite that's used when the player is standing still
    if(velocity.x == 0)  {
      animationTimer = 0;
      spriteNum = 0;
      sprite = playerSprite[spriteNum];
    }
    
    velocity.x += acceleration.x;
    velocity.y += acceleration.y;
    
    position.x += velocity.x;
    position.y += velocity.y;
    
    // Code used to draw the arm and detrmine the angle they're looking at
    // atan2 actually gets the angle I'm looking for, not angleBetween()
    pushMatrix();
    translate(position.x, position.y - 60);
    angle = atan2(mouseY - position.y + 50, mouseX - position.x);
    rotate(angle);
    fill(200,0,0);
    scale(1, direction);
    image(playerSprite[3], 0, -15);
    popMatrix();
    
    // Primary shot
    // Consistent damage with limited range
    if (LClick && primaryCooldown <= 0)  {
      playerHitBox.add(new PlayerHitBox(position.x, position.y - 60, 20, 0, 10, 10, 5, 18, angle));
      // Cooldown for primary
      primaryCooldown += 10;
    } else if(primaryCooldown > 0)  {
      primaryCooldown--;
    }
    
    // Secondary shot
    // Pierces enemies
    if (RClick && secondaryCooldown <= 0)  {
      playerHitBox.add(new PlayerHitBox(position.x, position.y - 50, 40, 0, 30, 20, 20, 30, angle));
      // Cooldown for secondary
      secondaryCooldown += 120;
    } else if(secondaryCooldown > 0)  {
      secondaryCooldown--;
    }
    
    // Special shot
    // High damage and knocks back player
    if (MClick && specialCooldown <= 0)  {
      playerHitBox.add(new PlayerHitBox(position.x, position.y - 50, 40, 0, 40, 40, 31, 20, angle));
      // Cooldown for special
      specialCooldown += 20;
      // Looks at the difference between the player's position and the mouse's position to determine
      // what direction the knockback should go
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
  
  void display()  {
    // Creates a matrix to flip sprites when the enemy turns around
    // Places player sprite on screen
    // Also places healthbar that shows how much health the player has left
    pushMatrix();
    translate(position.x, position.y);
    scale(direction, 1);
    image(sprite, -playerW / 2, -playerH);
    popMatrix();
    fill(200, 0, 0);
    rect(1125, 400, 50, 200);
    // When the player's health decreases, the rect shrinks and moves down
    fill(0, 200, 0);
    rect(1125, 400 + (200 - 2 * health), 50, 200 - (200 - 2 * health));
  }
}
