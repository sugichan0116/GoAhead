

class Item extends Obstacle {
  int ID;
  float approachRangeRate, moveResist;
  String iconName[];
  
  Item(int id, float size, float x, float y, float vx, float vy) {
    iconName = new String[] {"ITEM_REPAIR", "HEART_EMPTY", "ITEM_BULLET"};
    waveColor = color(#50FF36);
    ID = id;
    approachRangeRate = 8.0f;
    moveResist = 0.6f;
    this.size = size;
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
  }
  
  void Draw() {
    pushStyle();
    pushMatrix();
      translate(x - CameraX, y - CameraY);
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
    if(!(temp instanceof Player) || isCollision == true) return;
    isCollision = true;
    
    itemEffects((Player)temp);
    produceWave();
    playSound("ITEM", 0);
  }
  
  void itemEffects(Player temp) {
    switch(ID) {
      case 0:
        temp.HP = min(temp.maxHP, temp.HP + 1);
        break;
      case 1:
        temp.maxHP = min(temp.upperLimitHP, temp.maxHP + 1);
        break;
      case 2:
        temp.shootBulletDirection += 1;
        break;
    }
  }
}