interface Field {
  void Init();
  void Pause();
  void Play();
  boolean isPause();
  boolean isClear();
  boolean isFailed();
}

class Stage implements Field {
  String name = "PIONIOR";
  float targetDistance = 3000f;
  float targetTime = 30f;
  float spornRate = 1f;
  int playerHP = 3;
  Player me;
  int state = 0;
  
  void Init() {
    objects = new ArrayList();
    me = new Player();
    objects.add(me);
  }
  
  void Play() {
    
  }
  
  void Pause() {
    
  }
  
  boolean isPause() {
    return false;
  }
  
  boolean isClear() {
    return (me.getDistance() >= targetDistance);
  }
  
  boolean isFailed() {
    return (me.HP <= 0);
  }
}