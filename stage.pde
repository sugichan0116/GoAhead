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
  
  protected String name;
  
  protected float targetDistance = 8000f;
  protected float targetTime = 30f;
  
  protected float spornRate = 1f;
  
  private float leftTime = 0f;
  
  protected int playerHP = 3;
  protected Player me;
  
  protected int state,judge;
  protected int mode = Mode.TIME | Mode.LONG;
  
  Stage(String name, int column) {
    this.name = name;
    this.column = column;
    r = new PVector();
    s = new PVector();
    setLocation();
    state = judge = State.NOTYET;
  }
  
  void setLocation() {
    r.x = column * 36f + 96f;
    r.y = 64f + column * 48f;
    pushStyle();
    int fontSize = 24;
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
  
  void DrawUI() {
    if(isTIME()) {
      PGraphics pg = layers.get("UI");
      pg.beginDraw();
      pg.pushStyle();
      pg.pushMatrix();
        pg.translate(32f, height - 32f);
        pg.textAlign(LEFT, TOP);
        pg.fill(#A7A7A7);
        pg.textSize(24f);
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
      pg.fill((isOverlap()) ? #FF8243 : #A7A7A7);
      pg.textSize(s.y);
      pg.text("* " + name + ((isPause()) ? "[Pause]" : ""), 0f, 0f);
    pg.popMatrix();
    pg.popStyle();
    pg.endDraw();
  }
  
  void Update() {
    print("* game : " + isOver() + "/" + isClear() + "/" + isFailed() + "\n");
    leftTime += 1f / frameRate;
    print("* " + int(leftTime) + "/" + targetTime + "\n");
    
    setLocation();
    if(!isOver()) {
      if(isLONG()) {
        if(me.getDistance() >= targetDistance)
          judge = State.CLEAR;
      }
      if(isTIME()) {
        if(isTimeUp())
          judge = State.FAILED;
      }
      
      if(me.HP <= 0) judge = State.FAILED;
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
  
  //float nowTime() {
  //  return float(leftTime) / frameRate;
  //}
  
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