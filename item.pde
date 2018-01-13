

class Item extends Obstacle {
  private int ID;
  private float approachRangeRate, moveResist;
  private String[] iconName, description;
  private String title, explain;
  private float fontSize_NORMAL, fontSize_TITLE;
  private final float timeRepair = 4f;
  
  Item(int id, float size, float x, float y, float vx, float vy) {
    iconName = new String[] {
      "ITEM_REPAIR", "HEART_EMPTY",
      "ITEM_BULLET_RED", "ITEM_BULLET_BLUE", "ITEM_BULLET_GREEN",
      "ITEM_STAR", "ITEM_FOOD"};
    title = "Item get !";
    description = new String[] {
      "Repair +1 HP",
      "IMPROVE +1 max HP",
      "The RED bullet, Larger Range",
      "The BLUE bullet, More Bullet",
      "The GREEN bullet, Higher Power",
      "You Are * Invincible *",
      "The Food, +" + int(timeRepair) + " seconds"};
    explain = "Press *ANY KEY*";
    fontSize_NORMAL = 24f;
    fontSize_TITLE = 36f;
    waveColor = color(#50FF36);
    ID = id;
    approachRangeRate = 8.0f;
    moveResist = 0.6f;
    this.size = size;
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    leftTime = 8;
  }
  
  void Draw() {
    pushStyle();
    pushMatrix();
      translate(x - camera.x, y - camera.y);
      imageMode(CENTER);
      if(isCollision == false || leftTime % 2 == 0) {
        image(icons.get(iconName[ID]), 0, 0, size, size);
      }
    popMatrix();
    popStyle();
  }
  
  void Update() {
    super.Update();
    if(isCollision == false && dist(stage.me.x, stage.me.y, x, y) < stage.me.size * approachRangeRate) {
      vx += Framed(stage.me.vx + stage.me.x - x);
      vy += Framed(stage.me.vy + stage.me.y - y);
    } else {
      vx *= 1f - Framed(moveResist);
      vy *= 1f - Framed(moveResist);
    }
  }
  
  void collision(Object temp) {
    if(!(temp.getClass() == Player.class || temp.getClass() == Bullet.class) || isCollision == true) return;
    isCollision = true;
    
    itemEffects(stage.me);
    produceText(title, fontSize_TITLE, width / 2f, height / 2f);
    produceText(description[ID], fontSize_NORMAL, width / 2f, height / 2f + 36f);
    if(isBullet()) produceText(explain, fontSize_NORMAL, width / 2f, height - 36f);
    produceWave();
    playSound("ITEM", 0);
  }
  
  boolean isBullet() {
    return (ID == 2 || ID == 3 || ID == 4);
  }
  
  void produceText(String text, float size, float x, float y) {
    objects.add(new Description(
        text, size, x, y));
  }
  
  void itemEffects(Player temp) {
    switch(ID) {
      case 0:
        temp.addHP(1);
        break;
      case 1:
        temp.addMaxHP(1);
        break;
      case 2:
        temp.addBullet(1);
        temp.setBulletColor(0);
        break;
      case 3:
        temp.addBullet(1);
        temp.setBulletColor(1);
        break;
      case 4:
        temp.addBullet(1);
        temp.setBulletColor(2);
        break;
      case 5:
        temp.setInvincibleTime(16.0f);
        break;
      case 6:
        stage.repairTime(timeRepair);
        break;
    }
  }
}