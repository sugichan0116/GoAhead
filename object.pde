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
  
  PVector getVertex(int id) {
    PVector temp = new PVector(size / 2f, size / 2f);
    
    temp.rotate(angle + id * HALF_PI);
    temp.add(x, y);
    
    /*
    pushMatrix();
      translate(temp.x - CameraX, temp.y - CameraY);
      rectMode(CENTER);
      rect(0, 0, 4, 4);
    popMatrix();
    */
    
    return temp;
  }
  
  PVector[] getVertexs() {
    PVector[] temp = new PVector[4];
    
    for(int n = 0; n < temp.length; n++ ) {
      temp[n] = getVertex(n);
    }
    
    return temp;
  }
  
  boolean isCollision(Object temp) {
    if(isPhysic == false || ((Matrix)temp).isPhysic == false) return false;
    
    return isOverlap(temp);
  }
  
  boolean isOverlapRotate(Object temp) {
    if(dist(x, y, ((Matrix)temp).x, ((Matrix)temp).y)
      > size + ((Matrix)temp).size) return false;
    
    final PVector[][] vertexs = new PVector[2][] ;
    vertexs[0] = getVertexs();
    vertexs[1] = ((Matrix)temp).getVertexs();
    
    for(int m = 0, n = 1; m < 2; m++, n--) {
      for(int k = 0; k < 4; k++) {
        boolean isInside = true;
        for(int i = 0, j = 3; i < 4; j = ((++i) - 1) % 4) {
          if(vertexs[m][k].copy().sub(vertexs[n][j]).
            cross(vertexs[n][i].copy().sub(vertexs[n][j])).z > 0f)
            isInside = false;
        }
        if(isInside) return true;
      }
    }
    
    return false;
  }
  
  boolean isOverlap(Object temp) {
    switch(0) {
      case 0:
      //精密回転判定
        return isOverlapRotate(temp);
        
      case 1:
      //平行判定
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
    
    return false;
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