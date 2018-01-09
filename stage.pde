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
  CLEAR = 2,
  FAILED = 3
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
  int state = 1;
  
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
    //print("* game : " + state + "\n");
    if(state != State.FAILED && state != State.CLEAR) {
      if(me.HP <= 0) state = State.FAILED;
      else if(me.getDistance() >= targetDistance) state = State.CLEAR;
    }
  }
  
  boolean isPause() {
    return state == State.PAUSE;
  }
  
  boolean isClear() {
    return state == State.CLEAR;
  }
  
  boolean isFailed() {
    return state == State.FAILED;
  }
}