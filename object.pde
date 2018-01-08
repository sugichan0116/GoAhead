interface Object {
  void Draw();
  void Update();
  boolean isDestroyed();
  void collision(Object temp);
  boolean isCollision(Object temp);
  
}

interface Utility {
  float getLeftSide();
  float getRightSide();
  float getTop();
  float getBottom();
}

class Matrix implements Object, Utility{
  float x, y, vx, vy, size, angle;
  boolean isPhysic;
  Matrix (){
    x = y = angle = 0f;
    size = 16f;
    isPhysic = false;
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
  
  boolean isCollision(Object temp) {
    if(isPhysic == false || ((Matrix)temp).isPhysic == false) return false;
    
    return isOverlap(temp);
  }
  
  boolean isOverlap(Object temp) {
    boolean isInside = false;
    float[][][] corners = {{{getLeftSide(), getTop()}, {getRightSide(), getTop()},
      {getLeftSide(), getBottom()}, {getRightSide(), getBottom()}},
      {{((Matrix)temp).getLeftSide(), ((Matrix)temp).getTop()},
      {((Matrix)temp).getRightSide(), ((Matrix)temp).getTop()},
      {((Matrix)temp).getLeftSide(), ((Matrix)temp).getBottom()},
      {((Matrix)temp).getRightSide(), ((Matrix)temp).getBottom()}}};
    
    for(int m = 0; m < 2; m++) {
      for(int n = 0; n < 4; n++) {
        if((corners[1 - m][0][0] <= corners[m][n][0] && 
            corners[1 - m][1][0] >= corners[m][n][0]) &&
           (corners[1 - m][0][1] <= corners[m][n][1] && 
            corners[1 - m][2][1] >= corners[m][n][1])) {
           isInside = true;
           break;
        }
      }
    }
    
    return isInside;
  }
  
  void collision(Object temp) {
    
  }
  
  void Update() {
    x += Framed(vx);
    y += Framed(vy);
  }
  
  boolean isDestroyed() {
    return (CameraX - size * 2 - width * 0.6f > x);
  }
}