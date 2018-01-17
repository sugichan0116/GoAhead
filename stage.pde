interface Field {
  void Init();
  void Pause();
  void Play();
  void Draw();
  void Update();
  boolean isPause();
  boolean isClear();
  boolean isFailed();
}

interface State {
  int
  PLAY = 0,
  PAUSE = 1,
  NOTYET = 2,
  CLEAR = 3,
  FAILED = 4
  ;
}

interface Mode {
  int
  FREE = 1,
  LONG = 2,
  TIME = 4,
  CHASE = 8,
  DESTROY = 16
  ;
}


class Stage implements Field {
  protected PVector r, s;
  protected int column;
  protected float fontSize;
  private boolean isIntroduced;
  
  protected String name;
  private String description;
  
  protected float targetDistance;
  protected float targetTime;
  
  //protected float spornRate = 1f;
  
  private float leftTime;
  
  protected int playerHP = 3;
  private float bpm;
  protected Player me;
  
  private int state,judge;
  private int mode;
  
  private HashMap<String, Integer> items;
  private HashMap<String, Float> sporns;
  
  Stage(String name, String description, int column,
    int mode, float bpm, float distance, float time,
    JSONObject itemList, JSONObject spornList) {
    this.name = name;
    this.description = "";
    this.description = description;
    this.column = column;
    this.mode = mode;
    this.bpm = bpm;
    this.targetDistance = distance;
    this.targetTime = time;
    isIntroduced = false;
    fontSize = 42f;
    r = new PVector();
    s = new PVector();
    setLocation();
    state = judge = State.NOTYET;
    items = new HashMap<String, Integer> ();
    getItems(itemList);
    sporns = new HashMap<String, Float> ();
    getSporns(spornList);
  }
  
  void getItems(JSONObject temp) {
    String key[] = {"REPAIR", "HEART",
        "BULLET_RED", "BULLET_BLUE", "BULLET_GREEN",
        "STAR", "TIME", "BEAT_UP", "SCALE_SMALL"};
    for(int n = 0; n < key.length; n++) {
      items.put(key[n], temp.getInt(key[n]));
    }
  }
  
  void getSporns(JSONObject temp) {
    String key[] = {"ROCK", "PLANET",
        "SCALE", "ITEM", "DISTANCE", "SHOOTING"};
    for(int n = 0; n < key.length; n++) {
      sporns.put(key[n], temp.getFloat(key[n]));
    }
  }
  
  void setLocation() {
    r.x = column * 36f + 96f;
    r.y = 64f + column * 48f;
    pushStyle();
    textFont(font_Menu);
    textSize(fontSize);
    s.set(textWidth("* " + name), fontSize);
    popStyle();
  }
  
  void Init() {
    objects = new ArrayList();
    me = new Player();
    objects.add(me);
    camera.set(0f, 0f);
    defCamera.set(0f, 0f);
    leftTime = 0f;
    isIntroduced = false;
  }
  
  void produceText(String text, float size, float x, float y) {
    objects.add(new Description(
        text, size, x, y));
  }
  
  void Reset() {
    state = judge = State.NOTYET;
  }
  
  void Play() {
    state = State.PLAY;
  }
  
  void Pause() {
    state = State.PAUSE;
  }
  
  void Draw() {
    if(isPlay()) DrawUI();
    else DrawMenu();
  }
  
  void repairTime(float time) {
    leftTime = max(0f, leftTime - time);
  }
  
  void DrawUI() {
    if(isTIME()) {
      PGraphics pg = layers.get("UI");
      pg.beginDraw();
      pg.pushStyle();
      pg.pushMatrix();
        pg.translate(32f, height - 32f);
        pg.textAlign(LEFT, TOP);
        pg.fill(#A7A7A7);
        pg.textFont(font);
        pg.textSize(fontSize);
        pg.text("Time : " + 
          timesToString(leftTime, targetTime), 0f, 0f);
      pg.popMatrix();
      pg.popStyle();
      pg.endDraw();
    }
  }
  
  void DrawMenu() {
    PGraphics pg = layers.get("MENU");
    pg.beginDraw();
    pg.pushStyle();
    pg.pushMatrix();
      pg.translate(r.x, r.y);
      pg.textAlign(LEFT, TOP);
      pg.fill((isOverlap()) ? #FFA962 : #2C2C2C);
      pg.textFont(font_Menu);
      pg.textSize(s.y);
      pg.text("" + name + ((isClear()) ? "[Clear]" : ""), 0f, 0f);
    pg.popMatrix();
    pg.popStyle();
    if(isOverlap()) {
      String target = "";
      if(isLONG()) target += "目標距離 : " + distanceToString(targetDistance) + "\n";
      if(isTIME()) target += "目標時間 : " + timeToString(targetTime) + "\n";
      pg.pushStyle();
      pg.pushMatrix();
        pg.textAlign(RIGHT, CENTER);
        pg.textFont(font_Desc, 14);
        pg.text(description, width - 256, height * .3f, 256, 128);
        pg.textFont(font_Desc, 16);
        pg.text(target, width - 196, height * .5f, 196, 128);
      pg.popMatrix();
      pg.popStyle();
      
    }
    pg.endDraw();
  }
  
  void Update() {
    leftTime += 1f / frameRate;
    
    
    if(isIntroduced == false && leftTime > 1f) {
      isIntroduced = true;
      produceText("Click to Move Right !", s.y, width / 2f, height / 2f);
    }
    setLocation();
    if(!isOver()) {                
      if(isLONG()) {
        if(me.getDistance() >= targetDistance) {
          judge = State.CLEAR;
        }
      }
      if(isTIME()) {
        if(isTimeUp()) {
          print("* time up" + mode + "\n");
          judge = State.FAILED;
        }
      }
      
      if(me.HP <= 0) {
          print("* you die" + mode + "\n");
        judge = State.FAILED;
      }
    } 
    else state = State.PAUSE;
    
  }
  
  float getDistance() {
    return targetDistance;
  }
  
  float getTime() {
    return leftTime;
  }
  
  boolean isLONG() {
    //print("* @" + mode + "/" + Mode.LONG + "/" + checkBit(mode,Mode.LONG) + "\n");
    return checkBit(mode, Mode.LONG);
  }
  
  boolean isTIME() {
    return checkBit(mode, Mode.TIME);
  }
  
  boolean isFREE() {
    return checkBit(mode, Mode.FREE);
  }
  
  boolean isDESTROY() {
    return checkBit(mode, Mode.DESTROY);
  }
  
  boolean isCHASE() {
    return checkBit(mode, Mode.CHASE);
  }
  
  boolean isTimeUp() {
    return targetTime <= leftTime;
  }
  
  boolean isOverlap() {
    return (r.x <= mouseX && mouseX <= r.x + s.x) && (r.y <= mouseY && mouseY <= r.y + s.y);
  }
  
  boolean isPlay() {
    return state == State.PLAY;
  }
  
  boolean isPause() {
    return state == State.PAUSE;
  }
  
  boolean isOver() {
    return judge != State.NOTYET;
  }
  
  boolean isClear() {
    return judge == State.CLEAR;
  }
  
  boolean isFailed() {
    return judge == State.FAILED;
  }
}