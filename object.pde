interface Object {
  void Draw();
  void Update();
  boolean isDestroyed();
}

class Matrix implements Object{
  float x, y, vx, vy, size, angle;
  Matrix (){
    x = y = angle = 0f;
    size = 16f;
  }
  
  void Draw() {
    pushMatrix();
      translate(x - CameraX, y - CameraY);
      rotate(angle);
      rectMode(CENTER);
      rect(0, 0, size, size);
    popMatrix();
  }
  
  float getLeftSide() {
    return x - size / 2f;
  }
  
  float getRightSide() {
    return x + size / 2f;
  }
  
  float getTop() {
    return y - size / 2f;
  }
  
  float getBottom() {
    return y + size / 2f;
  }
  
  void Update() {
    x += Framed(vx);
    y += Framed(vy);
  }
    
  boolean isDestroyed() {
    return (CameraX - size * 2 - width * 0.6f > x);
  }
}