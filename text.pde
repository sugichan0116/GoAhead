
class Description extends Wave {
  private String text;
  
  Description() {
    this("* text *", 0f, 0f);
  }
  
  Description(String text, float x, float y) {
    this(text, 18f, x, y);
  }
  
  Description(String text, float size, float x, float y) {
    this(text, color(255), size, x, y);
  }
  
  Description(String text, color Color, float size, float x, float y) {
    this(text, 128, Color, size, x, y);
  }
  
  Description(String text, int time, color Color, float size, float x, float y) {
    leftTime = maxTime = time;
    outColor = color(0, 0);
    this.text = text;
    this.inColor = Color;
    this.size = size;
    this.x = x;
    this.y = y;
    vx = 0f;
    vy = -size * 2f;
    extendSpeed = 0f;
  }
  
  void Draw() {
    PGraphics pg = layers.get("UI");
    pg.beginDraw();
    pg.pushStyle();
      pg.fill(inColor, 255f * getTimeRate());
      pg.stroke(outColor);
      pg.textFont(font, size);
      pg.textAlign(CENTER, CENTER);
      pg.text(text, x, y);
    pg.popStyle();
    pg.endDraw();
  }
  
  void Update() {
    super.Update();
    x += Framed(vx);
    y += Framed(vy);
  }
}