

class Obstacle extends Matrix {
  int ID;
  String[] iconKey;
  boolean isCollision;
  int leftTime;
  String[] soundKey;
  int giveUnCollisionTime;
  color waveColor;
  int HP;
  
  Obstacle() {
    this(0, 16f, 0f, 0f, 0f);
  }
  
  Obstacle(int ID, float Size, float Angle, float x, float y) {
    this(ID, Size, Angle, x, y, 0f, 0f);
  }
  
  Obstacle(int ID, float Size, float Angle, float x, float y, float vx, float vy) {
    isPhysic = true;
    this.ID = ID;
    iconKey = new String[] {"ROCK_1", "ROCK_2", "ROCK_3"};
    soundKey = new String[] {"BOMB_1", "BOMB_2", "BOMB_3", "BOMB_4", "BOMB_5", "BOMB_6"};
    waveColor = color(#DE610D);
    leftTime = giveUnCollisionTime = 30;
    isCollision = false;
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    this.size = Size;
    this.angle = Angle;
    HP = 1 + int(Size / 16f);
  }
  
  void Update() {
    super.Update();
    
    if(HP <= 0) isCollision = true;
    
    if(isCollision && leftTime > 0) leftTime--;
  }
  
  void Draw() {
    pushStyle();
    pushMatrix();
      translate(x - CameraX, y - CameraY);
      textAlign(CENTER, BOTTOM);
      text("* HP *  " + HP, 0f, - size);
      rotate(angle);
      imageMode(CENTER);
      if(isCollision == false || leftTime % 2 == 0) {
        image(icons.get(iconKey[ID]), size * .05f, -size * .05f, size * 1.15f, size * 1.15f);
      }
    popMatrix();
    popStyle();
  }
  
  boolean isCollision(Object temp) {
    if(isCollision) return false;
    return super.isCollision(temp);
  }
  
  void collision(Object temp) {
    if(!(temp instanceof Player) || isCollision == true) return;
    
    Player target = (Player)temp;
    isCollision = true;
    
    if(target.unCollisionTime <= 0) {
      target.unCollisionTime = giveUnCollisionTime;
      
      target.HP = max(0, target.HP - 1);
      produceWave();
      
      playSound(soundKey[int(random(soundKey.length))], 0);
    }
  }
    
  void produceWave() {
    objects.add(new Wave(
        waveColor, int(frameRate), 128f, x, y, vx, vy));
  }
  
  boolean isDestroyed() {
    return super.isDestroyed() || (leftTime <= 0);
  }
}