class PlayerHitBox  {
  // HBW is the width, and HBH is the height
  // lifeSpan is how long the projectile will be alive for until it gets removed
  // damage is the damage it will deal to the player
  // angle is the angle the projectile is being shot at
  PVector position = new PVector(0,0);
  // rotatePos is used after transformations to properly display the hitbox
  PVector rotatePos = new PVector(0,0);
  // realPos is used for collision, and not display, since the display rotates the projectile
  PVector realPos = new PVector(0,0);
  PVector velocity = new PVector(0,0);
  int HBW;
  int HBH;
  int lifeSpan;
  int damage;
  float angle;
  
  PlayerHitBox(float xPos, float yPos, float xVel, float yVel, int sizeW, int sizeH, int damage, int duration, float angle)  {
    position.x = xPos;
    position.y = yPos;
    realPos.x = xPos;
    realPos.y = yPos;
    velocity.x = xVel;
    velocity.y = yVel;
    HBW = sizeW;
    HBH = sizeH;
    this.damage = damage;
    lifeSpan = duration;
    this.angle = angle;
    
  }
  
  boolean update()  {
    // A formula used to determine the real position of the projectile on screen
    // velocity.x is the hypoteneuse, angle is theta
    realPos.x += velocity.x * cos(angle);
    realPos.y += velocity.x * sin(angle);
    
    // Collision detection for enemies
    // I chose to handle it all in this class since otherwise I'd need to copy this code for each enemy
    for(int i = redTitan.size() - 1; i >= 0; i--)  {
     if(realPos.x + HBW > redTitan.get(i).position.x - (redTitan.get(i).enemyWidth / 2) && realPos.x < redTitan.get(i).position.x + (redTitan.get(i).enemyWidth / 2) && realPos.y + HBH > redTitan.get(i).position.y - redTitan.get(i).enemyHeight && realPos.y < redTitan.get(i).position.y)  {
       // dealing damage to enemies
       redTitan.get(i).health -= damage;
       // returning true kills the hitbox, returning false keeps it alive
       // The secondary shot does 20 damage
       // Since the secondary is meant to pierce, it doesn't go away when colliding with an enemy
       if(damage != 20)  {
         println(redTitan.get(i).health);
         return true;
       }
     }
  }
  for(int i = orangeRam.size() - 1; i >= 0; i--)  {
     if(realPos.x + HBW > orangeRam.get(i).position.x - (orangeRam.get(i).enemyWidth / 2) && realPos.x < orangeRam.get(i).position.x + (orangeRam.get(i).enemyWidth / 2) && realPos.y + HBH > orangeRam.get(i).position.y - orangeRam.get(i).enemyHeight && realPos.y < orangeRam.get(i).position.y)  {
       // dealing damage to enemies
       orangeRam.get(i).health -= damage;
       // returning true kills the hitbox, returning false keeps it alive
       // The secondary shot does 20 damage
       // Since the secondary is meant to pierce, it doesn't go away when colliding with an enemy
       if(damage != 20)  {
         println(orangeRam.get(i).health);
         return true;
       }
     }
  }
  for(int i = greenBlaster.size() - 1; i >= 0; i--)  {
     if(realPos.x + HBW > greenBlaster.get(i).position.x - (greenBlaster.get(i).enemyWidth / 2) && realPos.x < greenBlaster.get(i).position.x + (greenBlaster.get(i).enemyWidth / 2) && realPos.y + HBH > greenBlaster.get(i).position.y - greenBlaster.get(i).enemyHeight && realPos.y < greenBlaster.get(i).position.y)  {
       // dealing damage to enemies
       greenBlaster.get(i).health -= damage;
       // returning true kills the hitbox, returning false keeps it alive
       // The secondary shot does 20 damage
       // Since the secondary is meant to pierce, it doesn't go away when colliding with an enemy
       if(damage != 20)  {
         println(greenBlaster.get(i).health);
         return true;
       }
     }
  }
  // Collision for the button used to start the game
  // Only checks when the game is on the start screen
  if(realPos.x + HBW > button.position.x && realPos.x < button.position.x + button.buttonW && realPos.y + HBH > button.position.y && realPos.y < button.position.y + button.buttonH && gameState == 0)  {
    gameState++;
    makeStage = true;
    return true;
  }
     // Drawing the bullet
    stroke(255);
    strokeWeight(5);
    fill(20, 10, 10);
    if(angle != 0)  {
      pushMatrix();
      translate(position.x, position.y);
      rotate(angle);
      rotatePos.x += velocity.x;
      rotatePos.y += velocity.y;
      rect(rotatePos.x, rotatePos.y, HBW, HBH);
      popMatrix();
    } else  {
      position.x += velocity.x;
      position.y += velocity.y;
      rect(position.x, position.y, HBW, HBH);
    }
    stroke(0);
    strokeWeight(1);
    // returning true kills the hitbox, returning false keeps it alive
     lifeSpan--;
     if(lifeSpan <= 0)  {
       return true;
     } return false;
  }
}
