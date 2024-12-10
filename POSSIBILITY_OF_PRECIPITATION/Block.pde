class Block  {
  float blockX;
  float blockY;
  int blockW;
  int blockH;
  boolean semiSolid;
  
  Block(float xPos, float yPos, int sizeW, int sizeH, boolean semiSolid)  {
    blockX = xPos;
    blockY = yPos;
    blockW = sizeW;
    blockH = sizeH;
    this.semiSolid = semiSolid;
  }
  
  void update()  {
    if(semiSolid)  {
      fill(200);
    } else fill(0, 150, 0);
    rect(blockX, blockY, blockW, blockH);
  }
}
