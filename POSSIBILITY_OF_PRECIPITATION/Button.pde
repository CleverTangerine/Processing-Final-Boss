class Button  {
  // buttonW is the width, and buttonH is the height
  PVector position = new PVector(0,0);
  int buttonW = 200;
  int buttonH = 80;
  
  Button(int posX, int posY, int shapeW, int shapeH)  {
    position.x = posX;
    position.y = posY;
    buttonW = shapeW;
    buttonH = shapeH;
  }
  
  void display()  {
    fill(240, 50, 50);
    rect(position.x, position.y, buttonW, buttonH);
    fill(20, 200, 20);
    triangle(230, 330, 230, 370, 260, 350);
  }
}
