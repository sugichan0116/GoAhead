

class Item extends Obstacle {
  private int ID;
  private String name;
  private float approachRangeRate, moveResist;
  //private String[] iconName, description;
  private HashMap<String, String> iconName, description;
  private String title, explain;
  private float fontSize_NORMAL, fontSize_TITLE;
  private final float timeRepair = 4f;
  
  Item(HashMap<String, Integer> temp, float size, float x, float y, float vx, float vy) {
    iconName = new HashMap<String, String> ();
    iconName.put("REPAIR", "ITEM_REPAIR");
    iconName.put("HEART", "HEART_EMPTY");
    iconName.put("BULLET_RED", "ITEM_BULLET_RED");
    iconName.put("BULLET_BLUE", "ITEM_BULLET_BLUE");
    iconName.put("BULLET_GREEN", "ITEM_BULLET_GREEN");
    iconName.put("STAR", "ITEM_STAR");
    iconName.put("TIME", "ITEM_FOOD");
    iconName.put("BEAT_UP", "ITEM_BEAT_UP");
    iconName.put("SCALE_SMALL", "ITEM_SCALE_SMALL");
    
    title = "Item get !";
    description = new HashMap<String, String> ();
    description.put("REPAIR", "Repair +1 HP");
    description.put("HEART", "IMPROVE +1 max HP");
    description.put("BULLET_RED", "The RED bullet, Larger Range");
    description.put("BULLET_BLUE", "The BLUE bullet, More Bullet");
    description.put("BULLET_GREEN", "The GREEN bullet, Higher Power");
    description.put("STAR", "You Are * Invincible *");
    description.put("TIME", "The Food, +" + int(timeRepair) + " seconds");
    description.put("BEAT_UP", "Faster HeartBeat, Tempo Up");
    description.put("SCALE_SMALL", "You shrunk, very Small !");
    explain = "Press *ANY KEY*";
    
    fontSize_NORMAL = 24f;
    fontSize_TITLE = 36f;
    waveColor = color(#50FF36);
    
    getID(temp);
    approachRangeRate = 8.0f;
    moveResist = 0.6f;
    this.size = size;
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    leftTime = 8;
  }
  
  void getID(HashMap<String, Integer> temp) {
    float random = random(1f);
    int entry = 0;
    int order = 0;
    ID = -1;
    name = "";
    
    for(String Key: temp.keySet()) {
      entry += temp.get(Key);
    }
    for(String Key: temp.keySet()) {
      //if(temp.get(Key)) {
        //println("* " + Key + " ," + random + "/" + order + "[" + (float(order) / float(entry)) + "/" + (float(order + 1) / float(entry)) + "]");
        if(float(order) / float(entry) <= random && 
          random <= float(order + temp.get(Key)) / float(entry)) {
          //ID = order;
          println("* " + Key + " ," + random + "[" + (float(order) / float(entry)) + "/" + float(order + temp.get(Key)) / float(entry) + "]");
          name = Key;
          break;
        }
        order += temp.get(Key);
      //}
    }
  }
  
  void Draw() {
    pushStyle();
    pushMatrix();
      translate(x - camera.x, y - camera.y);
      imageMode(CENTER);
      if(isCollision == false || leftTime % 2 == 0) {
        DrawLights(TAU * Beat(11.3f), 24f);
        DrawLights(TAU * -Beat(7.3f), 20f);
        DrawLights(TAU * Beat(5.3f), 16f);
        image(icons.get(iconName.get(name)), 0, 0, size, size);
      }
    popMatrix();
    popStyle();
  }
  
  void DrawLights(float angle, float scale) {
    pushStyle();
    pushMatrix();
      int wings = 4;
      PImage icon = icons.get("LIGHTS");
      blendMode(ADD);
      tint(64);
      rotate(angle);
      for(int n = 0; n < wings; n++) {
        //float angle = TAU * (float(n) / float(wings) + Beat(8f));
        rotate(TAU * float(n) / float(wings));
        image(icon,
          scale / 2f,
          0f,
          scale, scale * 0.6f);
      }
      blendMode(NORMAL);
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
    produceText(description.get(name), fontSize_NORMAL, width / 2f, height / 2f + 36f);
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
  
  boolean isDestroyed() {
    return super.isDestroyed() || (name == "");
  }
  
  void itemEffects(Player temp) {
    if(name == "REPAIR") {
        temp.addHP(1);
    }
    else
    if(name == "HEART") {
        temp.addMaxHP(1);
    }
    else
    if(name == "BULLET_RED") {
        temp.addBullet(1);
        temp.setBulletColor(0);
    }
    else
    if(name == "BULLET_BLUE") {
        temp.addBullet(1);
        temp.setBulletColor(1);
    }
    else
    if(name == "BULLET_GREEN") {
        temp.addBullet(1);
        temp.setBulletColor(2);
    }
    else
    if(name == "STAR") {
        temp.setInvincibleTime(8.0f);
    }
    else
    if(name == "TIME") {
        stage.repairTime(timeRepair);
    }
    else
    if(name == "BEAT_UP") {
        temp.beatUp();
    }
    else
    if(name == "SCALE_SMALL") {
        temp.scaleDown();
    }
    
  }
}