class Bullet extends Obstacle {
  int rangeTime;
  float moveResist;
  
  Bullet(int time, float size, float x, float y, float vx, float vy, float angle) {
    ID = 0;
    iconKey = new String[] {"BULLET"};
    isPhysic = true;
    rangeTime = time;
    leftTime = 4;
    moveResist = .3f;
    this.angle = angle;
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.size = size;
  }
  
  void Update() {
    super.Update();
    
    if(rangeTime > 0) rangeTime--;
    else if(rangeTime <= 0) isCollision = true;
    angle += Framed((new PVector(vx, vy)).heading() - angle) / moveResist;
  }
  
  void Draw() {
    pushStyle();
    pushMatrix();
      translate(x - CameraX, y - CameraY);
      rotate(angle);
      imageMode(CENTER);
      if(isCollision == false || leftTime % 2 == 0) {
        image(icons.get(iconKey[ID]), 0, 0, size, size);
      }
    popMatrix();
    popStyle();
  }
  
  void collision(Object temp) {
    if(temp instanceof Item || temp instanceof Bullet ||
      !(temp instanceof Obstacle) || isCollision == true) return;
    
    Obstacle target = (Obstacle)temp;
    isCollision = true;
    
    if(target.isCollision == false) {
      
      target.HP = max(0, target.HP - 1);
      target.size = max(4f, target.size - 4f);
      
      if(target.size > 64f) {
        produceRock(target, 16f + randomGaussian());
      }
      produceWave();
      playSound(soundKey[int(random(soundKey.length))], 0);
    }
  }
  
  
  void produceRock(Obstacle temp, float size) {
    PVector v = new PVector(temp.vx + vx / 4f, temp.vy + vy / 4f);
    v.rotate(random(TAU)).sub(v.mag(), 0f);
    objects.add(new Obstacle(
        temp.ID, size, angle, temp.x, temp.y, v.x, v.y));
  }
}