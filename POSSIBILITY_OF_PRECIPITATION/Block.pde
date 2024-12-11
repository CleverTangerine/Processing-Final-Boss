class Block  {
  // blockW is the width, and blockH is the height
  // semiSolid changes th eproperties of block, like if the player can fall through it, and if they can walk through it
  PVector position = new PVector(0,0);
  int blockW;
  int blockH;
  boolean semiSolid;
  color colour;
  
  Block(float xPos, float yPos, int sizeW, int sizeH, boolean semiSolid, color colour)  {
    position.x = xPos;
    position.y = yPos;
    blockW = sizeW;
    blockH = sizeH;
    this.semiSolid = semiSolid;
    this.colour = colour;
  }
  
  void display()  {
    fill(colour);
    rect(position.x, position.y, blockW, blockH);
  }
}
