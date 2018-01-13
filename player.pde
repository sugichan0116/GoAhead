import java.text.MessageFormat;

//プレイヤーメインクラス
class Player extends Matrix{
  private int HP, maxHP, upperLimitHP;
  
  private int ID;
  private String[] iconKey;
  private int soundOrder;
  private String[] soundKey;
  
  private int moveCoolTime, unCollisionTime, moveMaxCoolTime;
  private float moveResist, moveMaxVelocity;
  private float moveDirection, moveDirectionVelocity;
  
  private int shootCoolTime, shootMaxCoolTime, shootBulletDamage;
  private int shootBulletDirection, shootBulletTime, bulletID;
  private float shootVelocity, shootBulletSize, shootAngleRange;
  
  private int invincibleTime;
  private final float invincibleVelocityRate = 2.0f;
  private HashMap<String, Float> bulletData;
  final float shiftCameraRate = 0.3f;
  
  Player() {
    isPhysic = true;
    HP = maxHP = 3; upperLimitHP = 8;
    this.ID = 0;
    iconKey = new String[] {"ROCKET", "ROCKET_GOLD"};
    soundOrder = 0;
    soundKey = new String[]{"ECHO_1", "ECHO_1", "ECHO_2", "ECHO_3"};
    unCollisionTime = 0;
    
    bulletData = new HashMap<String, Float>();
    for(int n = 0; n < 3; n++) {
      bulletData.put("VELOCITY" + n, 256f);
      bulletData.put("TIME" + n, 30f);
      bulletData.put("SIZE" + n, 8f);
      bulletData.put("COOL" + n, 12f);
      bulletData.put("DAMAGE" + n, 1f);
      bulletData.put("ACCURACY" + n, 1f);
    }
    bulletData.put("VELOCITY" + 0, 512f);
    bulletData.put("ACCURACY" + 0, .3f);
    bulletData.put("COOL" + 1, 4f);
    bulletData.put("COOL" + 2, 24f);
    bulletData.put("SIZE" + 2, 16f);
    bulletData.put("DAMAGE" + 2, 4f);
    
    moveMaxCoolTime = 6;
    moveResist = 0.3f;
    moveCoolTime = 0;
    moveDirection = 0f;
    moveDirectionVelocity = 80f / 60f * TAU; //80 BPM
    moveMaxVelocity = 4196f;
    
    bulletID = 0;
    shootCoolTime = 0;
    shootBulletDirection = 0;
    setBulletData();
    invincibleTime = 0;
    
  }
  
  void setBulletData() {
    shootVelocity = getBulletData("VELOCITY");
    shootMaxCoolTime = int(getBulletData("COOL"));
    shootBulletTime = int(getBulletData("TIME"));
    shootBulletSize = getBulletData("SIZE");
    shootBulletDamage = int(getBulletData("DAMAGE"));
    shootAngleRange = 
      radians(getBulletData("ACCURACY") * min(120, 20 + shootBulletDirection * 5));
  }
  
  void addHP(int add) {
    HP = min(maxHP, HP + add);
  }
  
  void subHP(int sub) {
    HP = max(0, HP - sub);
  }
  
  void addMaxHP(int add) {
    maxHP = max(upperLimitHP, maxHP + add);
  }
  
  void addBullet(int add) {
    shootBulletDirection += add;
  }
  
  void setBulletColor(int ID) {
    bulletID = ID;
  }
  
  void setInvincibleTime(float time) {
    invincibleTime = int(time * frameRate);
  }
  
  float getBulletData(String temp) {
    return bulletData.get(temp + bulletID);
  }
  
  boolean isDestroyed() {
    return !((HP >= 0) && (HP <= maxHP));
  }
  
  boolean isInvincible() {
    return invincibleTime > 0;
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
    if(invincibleTime > 0) {
      pg.fill(#FFED24, min(32f, 0.5f * invincibleTime));
      pg.rect(0, 0, width, height);
    }
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
    pg.text(String.format("%,3.1f ", getDistance())
      + ((stage.isLONG()) ? ("/ " + String.format("%,3.1f m", stage.getDistance())) : "m"),
      width - 32, height - 32);
    pg.popStyle();
    pg.endDraw();
    
    if(invincibleTime > 0 || unCollisionTime % 2 == 0) {
      //object
      pushMatrix();
        translate(x - camera.x, y - camera.y);
        rotate(angle);
        //本体
        imageMode(CENTER);
        image(icons.get(iconKey[ID]), 0, 0, size * 2, size * 2);
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
    
    setBulletData();
    if(shootCoolTime > 0) shootCoolTime--;
    else tryShoot();
    
    if(unCollisionTime > 0) unCollisionTime--;
    
    if(invincibleTime > 0) {
      invincibleTime--;
      unCollisionTime++;
      ID = 1;
    } else ID = 0;
    
    produceFire();
    
  }
    
  void optifineCamera() {
    if(x - camera.x <= width * shiftCameraRate)
      camera.x = min(x - width * shiftCameraRate, camera.x + Framed(vx) - 1);
    else if(x - camera.x >= width * (.6f - shiftCameraRate))
      camera.x = max(x - width * (.6f - shiftCameraRate),camera.x + Framed(vx) + 1);
    if(y - camera.y <= height * shiftCameraRate)
      camera.y = min(y - height * shiftCameraRate, camera.y + Framed(vy) - 1);
    else if(y - camera.y >= height * (1f - shiftCameraRate))
      camera.y = max(y - height * (1f - shiftCameraRate), camera.y + Framed(vy) + 1);;
    
  }
  
  void tryShoot() {
    if(keyPressed) {
      shootCoolTime = shootMaxCoolTime;
      
      produceBullet();
    }
  }
  
  void tryMove() {
    if(mousePressed && isMousePressed) {
      float velocity = Framed(moveMaxVelocity) * 
        ((isInvincible()) ? invincibleVelocityRate : 1f);
      vx += velocity * cos(moveDirection);
      vy += velocity * sin(moveDirection);
      moveCoolTime = moveMaxCoolTime;
      moveDirectionVelocity = -moveDirectionVelocity;
      produceWave();
      playSound(soundKey[soundOrder], 0);
      soundOrder = ++soundOrder % soundKey.length;
    }
  }
  
  void produceBullet() {
    for(int n = 0; n < shootBulletDirection; n++) {
      float direction = angle + 
        (float(n) - float(shootBulletDirection - 1) / 2f) / shootBulletDirection
        * shootAngleRange;
      objects.add(new Bullet(
        bulletID,
        shootBulletDamage,
        shootBulletTime,
        shootBulletSize,
        x + size * cos(direction),
        y + size * sin(direction),
        vx + shootVelocity * cos(direction),
        vy + shootVelocity * sin(direction),
        direction
        ));
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