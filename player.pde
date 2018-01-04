import java.text.MessageFormat;

//プレイヤーメインクラス
class Player extends Matrix{
  int HP, maxHP, upperLimitHP;
  int soundOrder;
  String[] soundKey;
  int moveCoolTime, unCollisionTime, moveMaxCoolTime;
  float moveResist, moveMaxVelocity;
  float moveDirection, moveDirectionVelocity;
  final float shiftCameraRate = 0.15f;
  
  Player() {
    HP = maxHP = 3; upperLimitHP = 8;
    soundOrder = 0;
    soundKey = new String[]{"ECHO_1", "ECHO_1", "ECHO_2", "ECHO_3"};
    unCollisionTime = 0;
    moveMaxCoolTime = 6;
    moveResist = 0.3f;
    moveCoolTime = 0;
    moveDirection = 0f;
    moveDirectionVelocity = 80f / 60f * TAU; //80 BPM
    moveMaxVelocity = 4196f;
  }
  
  boolean isDestroyed() {
    return !((HP >= 0) && (HP <= maxHP));
  }
  
  float getDistance() {
    return x;
  }
  
  void Draw() {
    //HP show
    PGraphics pg = layers.get("UI");
    pg.beginDraw();
    pg.pushStyle();
    pg.pushMatrix();
    pg.translate(32, 16);
    //pg.rectMode(CENTER);
    //pg.stroke(255);
    for(int n = 0; n < maxHP; n++) {
      pg.image(
        icons.get(((n + 1 <= HP) ? "HEART_FILL" : "HEART_EMPTY")),
        n * 48, 0, 32f + 1f * cos(Beat(2f) * TAU), 32f + 1f * cos(Beat(2f) * TAU)
        );
      //pg.rect(n * 30, 0, 15f + 1f * cos(Beat(2f) * TAU), 15f + 1f * cos(Beat(2f) * TAU));
    }
    pg.popMatrix();
    pg.fill(255);
    pg.textFont(font, 48);
    pg.textSize(12);
    pg.text("HP : " + HP + " / " + maxHP, 32, 16);
    pg.textAlign(RIGHT, BOTTOM);
    pg.textSize(28);
    pg.text("" + String.format("%,3.1f m", getDistance()), width - 32, height - 32);
    pg.popStyle();
    pg.endDraw();
    
    if(unCollisionTime % 2 == 0) {
      //object
      pushMatrix();
        translate(x - CameraX, y - CameraY);
        rotate(angle);
        //本体
        imageMode(CENTER);
        image(icons.get("PLAYER"), 0, 0, size * 2, size * 2);
        rotate(-angle);
        translate(moonX(), moonY());
        //衛星
        blendMode(SCREEN);
        image(icons.get("MOON"), 0, 0, size * .7f, size * .7f);
        blendMode(NORMAL);
      popMatrix();
    }
  }
  
  float moonX() {
    return size * 2 * cos(moveDirection);
  }
  
  float moonY() {
    return size * 2 * sin(moveDirection);
  }
  
  void Update() {
    optifineCamera();
    
    super.Update();
    vx *= 1f - Framed(moveResist);
    vy *= 1f - Framed(moveResist);
    angle += Framed((new PVector(vx, vy)).heading() - angle) / moveResist;
    
    moveDirection += Framed(moveDirectionVelocity);
    if(moveCoolTime > 0) moveCoolTime--;
    else tryMove();
    
    if(unCollisionTime > 0) unCollisionTime--;
    
    produceFire();
    
  }
    
  void optifineCamera() {
    if(x - CameraX <= width * shiftCameraRate)
      CameraX = min(x - width * shiftCameraRate, CameraX + Framed(vx) - 1);
    else if(x - CameraX >= width * (.6f - shiftCameraRate))
      CameraX = max(x - width * (.6f - shiftCameraRate),CameraX + Framed(vx) + 1);
    if(y - CameraY <= height * shiftCameraRate)
      CameraY = min(y - height * shiftCameraRate, CameraY + Framed(vy) - 1);
    else if(y - CameraY >= height * (1f - shiftCameraRate))
      CameraY = max(y - height * (1f - shiftCameraRate), CameraY + Framed(vy) + 1);;
    
  }
  
  void tryMove() {
    if(mousePressed && isMousePressed) {
      vx += Framed(moveMaxVelocity) * cos(moveDirection);
      vy += Framed(moveMaxVelocity) * sin(moveDirection);
      moveCoolTime = moveMaxCoolTime;
      moveDirectionVelocity = -moveDirectionVelocity;
      produceWave();
      playSound(soundKey[soundOrder], 0);
      soundOrder = ++soundOrder % soundKey.length;
    }
  }
  
  void produceFire() {
    objects.add(new Fire(
      dist(0, 0, vx, vy) * 0.6f,
      x - size * cos(angle) + randomGaussian() * dist(0, 0, vx, vy) / 128f,
      y - size * sin(angle) + randomGaussian() * dist(0, 0, vx, vy) / 128f,
      0f, 0f
      ));
  }
  
  void produceWave() {
    objects.add(new Wave(
        int(frameRate), dist(0, 0, vx, vy), x + moonX(), y + moonY(), vx, vy));
  }
}