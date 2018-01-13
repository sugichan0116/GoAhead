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
  DESTROY = 8
  ;
}


class Stage implements Field {
  protected PVector r, s;
  protected int column;
  protected float fontSize;
  
  protected String name;
  
  protected float targetDistance;
  protected float targetTime;
  
  protected float spornRate = 1f;
  
  private float leftTime;
  
  protected int playerHP = 3;
  protected Player me;
  
  private int state,judge;
  private int mode;
  
  Stage(String name, int column, int mode, float distance, float time) {
    this.name = name;
    this.column = column;
    this.mode = mode;
    this.targetDistance = distance;
    this.targetTime = time;
    fontSize = 36f;
    r = new PVector();
    s = new PVector();
    setLocation();
    state = judge = State.NOTYET;
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
        pg.text("Time : " + String.format("%4.1f", leftTime) + " / " +
          String.format("%4.1f", targetTime), 0f, 0f);
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
      pg.text("* " + name + ((isPause()) ? "[Pause]" : ""), 0f, 0f);
    pg.popMatrix();
    pg.popStyle();
    pg.endDraw();
  }
  
  void Update() {
    print("* game : " + isOver() + "/" + isClear() + "/" + isFailed() + "\n");
    leftTime += 1f / frameRate;
    print("* " + int(leftTime) + "/" + targetTime + "@" + judge + "/" + mode + "\n");
    
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