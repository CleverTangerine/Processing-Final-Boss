class Button  {
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
    fill(200, 100, 100);
    rect(position.x, position.y, buttonW, buttonH);
  }
}
