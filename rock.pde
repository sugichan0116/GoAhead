

class Obstacle extends Matrix {
  int ID;
  String[] iconKey;
  boolean isCollision;
  int leftTime;
  String[] soundKey;
  int giveUnCollisionTime;
  color waveColor;
  
  Obstacle() {
    this(0, 0f, 0f, 16f, 0f);
  }
  
  Obstacle(int ID, float x, float y, float Size, float Angle) {
    this.ID = ID;
    iconKey = new String[] {"ROCK_1", "ROCK_2", "ROCK_3"};
    soundKey = new String[] {"BOMB_1", "BOMB_2", "BOMB_3", "BOMB_4", "BOMB_5", "BOMB_6"};
    waveColor = color(#DE610D);
    leftTime = giveUnCollisionTime = 30;
    isCollision = false;
    this.x = x;
    this.y = y;
    this.size = Size;
    this.angle = Angle;
  }
  
  void Update() {
    super.Update();
    
    if(isCollision == false && checkCollision()) {
      tryCollision();
    }
    
    if(isCollision && leftTime > 0) leftTime--;
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
  
  void tryCollision() {
    isCollision = true;
    
    if(stage.me.unCollisionTime <= 0) {
      stage.me.unCollisionTime = giveUnCollisionTime;
      
      stage.me.HP = max(0, stage.me.HP - 1);
      produceWave();
      
      playSound(soundKey[int(random(soundKey.length))], 0);
    }
  }
  
  boolean checkCollision() {
    boolean isInside = false;
    float[][][] corners = {{{getLeftSide(), getTop()}, {getRightSide(), getTop()},
      {getLeftSide(), getBottom()}, {getRightSide(), getBottom()}},
      {{stage.me.getLeftSide(), stage.me.getTop()},
      {stage.me.getRightSide(), stage.me.getTop()},
      {stage.me.getLeftSide(), stage.me.getBottom()},
      {stage.me.getRightSide(), stage.me.getBottom()}}};
    
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
  
  void produceWave() {
    objects.add(new Wave(
        waveColor, int(frameRate), 128f, x, y, vx, vy));
  }
  
  boolean isDestroyed() {
    return super.isDestroyed() || (leftTime <= 0);
  }
}