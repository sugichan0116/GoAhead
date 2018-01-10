class Fire extends Wave {
  float timeRate;
  color[] colorMap;
  
  Fire(float extendSpeed, float x, float y) {
    this(extendSpeed, x, y, 0f, 0f);
  }
  
  Fire(float extendSpeed, float x, float y, float vx, float vy) {
    colorMap = new color[]
      { color(#FFE7CE), color(#FF7A15), color(#FF8F17),
        color(#A01C05), color(#2E1800) };
    timeRate = 0;
    this.extendSpeed = extendSpeed;
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
  }
  
  void Draw() {
    //object
    blendMode(ADD);
    pushStyle();
    noStroke();
    fill(inColor, 255 * leftTime / maxTime);
    pushMatrix();
      translate(x - camera.x, y - camera.y);
      rotate(angle);
      //本体
      ellipseMode(CENTER);
      ellipse(0, 0, size, size);
    popMatrix();
    popStyle();
    blendMode(NORMAL);
  }
  
  void Update() {
    timeRate = float(maxTime - leftTime) / float(maxTime);
    for(int i = 0; i < colorMap.length - 1; i++) {
      float colorRate = float(1) / float(colorMap.length);
      if(float(i) * colorRate <= timeRate &&
        timeRate <= float(i + 1) * colorRate) {
          
        inColor = lerpColor(colorMap[i], colorMap[i + 1],
          timeRate / colorRate - float(i));
        break;
      }
    }
    size = extendSpeed * timeRate * (1f - timeRate);
    leftTime--;
  }
}