class EnemyHitBox  {
  // HBW is the width, and HBH is the height
  // lifeSpan is how long the projectile will be alive for until it gets removed
  // damage is the damage it will deal to the player
  PVector position = new PVector(0,0);
  PVector velocity = new PVector(0,0);
  int HBW;
  int HBH;
  int lifeSpan;
  int damage;
  
  EnemyHitBox(float xPos, float yPos, float xVel, float yVel, int sizeW, int sizeH, int damage, int duration)  {
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
    
    noStroke();
    fill(255, 100, 100);
    rect(position.x, position.y, HBW, HBH);
    stroke(1);
    
    // returning true kills the hitbox, returning false keeps it alive
     lifeSpan--;
     if(lifeSpan <= 0)  {
       return true;
     } return false;
  }
}
