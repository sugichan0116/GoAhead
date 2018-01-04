class Background extends Matrix {
  color Color;
  float coodinateScale;
  
  Background(float scale, color Color, float size, float x, float y) {
    coodinateScale = scale;
    this.Color = Color;
    this.size = size;
    this.x = x;
    this.y = y;
  }
  
  void Draw() {
    blendMode(ADD);
    pushStyle();
    pushMatrix();
      translate(width / 2f, height / 2f);
      scale(coodinateScale);
      translate(x - CameraX - width / 2f, y - CameraY - height / 2f);
      ellipseMode(CENTER);
      ellipse(0, 0, size, size);
    popMatrix();
    popStyle();
    blendMode(NORMAL);
  }
  
  boolean isDestroyed() {
    return ((CameraX - x) * coodinateScale > size * 2 + width * 0.6f);
  }
}