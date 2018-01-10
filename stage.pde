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
  PVector r;
  int column;
  
  String name;
  
  float targetDistance = 3000f;
  float targetTime = 30f;
  
  float spornRate = 1f;
  
  int playerHP = 3;
  Player me;
  
  int state = State.PLAY, judge = State.NOTYET;
  int mode = Mode.LONG;
  
  Stage(String name, int column) {
    this.name = name;
    this.column = column;
    r = new PVector();
    r.x = column * 32f + 128f;
    r.y = 128f + column * 48f;
  }
  
  void Init() {
    objects = new ArrayList();
    me = new Player();
    objects.add(me);
  }
  
  void Play() {
    state = State.PLAY;
  }
  
  void Pause() {
    state = State.PAUSE;
  }
  
  void Draw() {
    PGraphics pg = layers.get("MENU");
    pg.beginDraw();
    pg.pushStyle();
    pg.pushMatrix();
      pg.translate(r.x, r.y);
      pg.textAlign(LEFT, TOP);
      pg.fill(16f);
      pg.textSize(24);
      pg.text("* " + name, 0f, 0f);
    pg.popMatrix();
    pg.popStyle();
    pg.endDraw();
  }
  
  void Update() {
    print("* game : " + judge + "\n");
    if(judge == State.NOTYET) {
      if(me.HP <= 0) judge = State.FAILED;
      else if(me.getDistance() >= targetDistance) judge = State.CLEAR;
      state = State.PAUSE;
    }
  }
  
  boolean isPause() {
    return state == State.PAUSE;
  }
  
  boolean isClear() {
    return judge == State.CLEAR;
  }
  
  boolean isFailed() {
    return judge == State.FAILED;
  }
}