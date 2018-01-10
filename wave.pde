
class Wave extends Matrix {
  int leftTime, maxTime;
  float extendSpeed;
  color outColor, inColor;
  
  Wave() {
    this(30);
  }
  
  Wave(int time) {
    this(time, 20f, 0f, 0f, 0f, 0f);
  }
   
  Wave(int time, float speed, float x, float y, float vx, float vy) {
    this(#4662FF, time, speed, x, y, vx, vy);
  }
  
  Wave(color Color, int time, float speed, float x, float y, float vx, float vy) {
    this.outColor = Color;
    this.inColor = color(255, 0);
    leftTime = maxTime = time;
    extendSpeed = speed;
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
  }
  
  float getTimeRate() {
    return float(leftTime) / float(maxTime);
  }
  
  void Draw() {
    //object
    pushStyle();
    noFill();
    stroke(outColor, 255 * getTimeRate());
    pushMatrix();
      translate(x - camera.x, y - camera.y);
      rotate(angle);
      //本体
      ellipseMode(CENTER);
      ellipse(0, 0, size, size);
    popMatrix();
    popStyle();
  }
  
  void Update() {
    size += Framed(extendSpeed);
    leftTime--;
  }
  
  boolean isDestroyed() {
    return (leftTime <= 0);
  }
}