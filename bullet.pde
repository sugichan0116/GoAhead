class Bullet extends Obstacle {
  int rangeTime;
  int damage;
  float moveResist;
  
  Bullet(int id, int damage, int time, float size, float x, float y, float vx, float vy, float angle) {
    ID = id;
    this.damage = damage;
    iconKey = new String[] {"BULLET_RED", "BULLET_BLUE", "BULLET_GREEN"};
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
      translate(x - camera.x, y - camera.y);
      rotate(angle);
      imageMode(CENTER);
      if(isCollision == false || leftTime % 2 == 0) {
        image(icons.get(iconKey[ID]), 0, 0, size, size);
      }
    popMatrix();
    popStyle();
  }
  
  void collision(Object temp) {
    if(temp.getClass() != Obstacle.class || isCollision == true) return;
    
    Obstacle target = (Obstacle)temp;
    isCollision = true;
    
    if(target.isCollision == false) {
      
      target.HP = max(0, target.HP - damage);
      target.size = max(16f, sqrt(pow(target.size, 2f) - target.size * damage));
      
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
        temp.ID, size, angle,
        x,
        y,
        v.x, v.y));
  }
}