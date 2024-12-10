class PlayerHitBox  {
  PVector position = new PVector(0,0);
  PVector rotatePos = new PVector(0,0);
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
    realPos.x += velocity.x * cos(angle);
    realPos.y += velocity.x * sin(angle);
    for(int i = redTitan.size() - 1; i >= 0; i--)  {
     if(realPos.x + HBW > redTitan.get(i).position.x - (redTitan.get(i).enemyWidth / 2) && realPos.x < redTitan.get(i).position.x + (redTitan.get(i).enemyWidth / 2) && realPos.y + HBH > redTitan.get(i).position.y - redTitan.get(i).enemyHeight && realPos.y < redTitan.get(i).position.y)  {
       redTitan.get(i).health -= damage;
       if(damage != 20)  {
         println(redTitan.get(i).health);
         return true;
       }
     }
  }
  for(int i = orangeRam.size() - 1; i >= 0; i--)  {
     if(realPos.x + HBW > orangeRam.get(i).position.x - (orangeRam.get(i).enemyWidth / 2) && realPos.x < orangeRam.get(i).position.x + (orangeRam.get(i).enemyWidth / 2) && realPos.y + HBH > orangeRam.get(i).position.y - orangeRam.get(i).enemyHeight && realPos.y < orangeRam.get(i).position.y)  {
       orangeRam.get(i).health -= damage;
       if(damage != 20)  {
         println(orangeRam.get(i).health);
         return true;
       }
     }
  }
  for(int i = greenBlaster.size() - 1; i >= 0; i--)  {
     if(realPos.x + HBW > greenBlaster.get(i).position.x - (greenBlaster.get(i).enemyWidth / 2) && realPos.x < greenBlaster.get(i).position.x + (greenBlaster.get(i).enemyWidth / 2) && realPos.y + HBH > greenBlaster.get(i).position.y - greenBlaster.get(i).enemyHeight && realPos.y < greenBlaster.get(i).position.y)  {
       greenBlaster.get(i).health -= damage;
       if(damage != 20)  {
         println(greenBlaster.get(i).health);
         return true;
       }
     }
  }
  if(realPos.x + HBW > button.position.x && realPos.x < button.position.x + button.buttonW && realPos.y + HBH > button.position.y && realPos.y < button.position.y + button.buttonH && gameState == 0)  {
    gameState++;
    makeStage = true;
    return true;
  }
    
    fill(210, 200, 200);
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
    
     lifeSpan--;
     if(lifeSpan <= 0)  {
       return true;
     } return false;
  }
}
