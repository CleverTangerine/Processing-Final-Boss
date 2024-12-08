class EnemyHurtBox  {
  PVector position = new PVector(0,0);
  PVector velocity = new PVector(0,0);
  PVector rotationVel = new PVector(0,0);
  int HBW;
  int HBH;
  int lifeSpan;
  int damage;
  
  EnemyHurtBox(float xPos, float yPos, float xVel, float yVel, int sizeW, int sizeH, int damage, int duration)  {
    position.x = xPos;
    position.y = yPos;
    velocity.x = xVel;
    velocity.y = yVel;
    HBW = sizeW;
    HBH = sizeH;
    this.damage = damage;
    lifeSpan = duration;
  }
  
  boolean update()  {
    
    position.x += velocity.x;
    position.y += velocity.y;
    
    fill(255, 200, 200);
    rect(position.x, position.y, HBW, HBH);
     lifeSpan--;
     if(lifeSpan <= 0)  {
       return true;
     } return false;
  }
}
