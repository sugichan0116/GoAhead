
void draw() {
  //refresh
  background(0);
  for(Map.Entry set : layers.entrySet()) {
    ((PGraphics)set.getValue()).beginDraw();
    ((PGraphics)set.getValue()).clear();
    ((PGraphics)set.getValue()).endDraw();
  }
  
  //update & draw
  if(objects == null) print("* objects null \n");
  else {
    if(stage.isPause() == false) Update();
    Draw();
  }
  
  //system
  isMousePressed = false;
}

void Update() {
  //remove & update
  for(int i = objects.size() - 1; i >= 0; i--) {
    if((objects.get(i)).isDestroyed()) objects.remove(i);
    else (objects.get(i)).Update();
  }
  
  //object produce
  int products = int((CameraX - preCameraX) / 100f);
  if(products > 1) {
    for(int i = 0; i < products; i++) {
      if(int(random(10f)) == 0) {
        //item生成
        objects.add(new Item(
          int(random(2f)), 16f, 
          CameraX + width * 1.6f,
          CameraY + stage.me.vy - height + random(height * 3),
          0f, 0f
          ));
      } else {
        //obst生成
        objects.add(new Obstacle(
          int(random(3f)),
          CameraX + width * 1.6f,
          CameraY + stage.me.vy - height + random(height * 3),
          abs(randomGaussian() * 10) + 20,
          random(TAU)
          ));
      }
      for(int k = 0; k < 4 * products; k++) {
        objects.add(new Background(
          .05f + random(.4f), #EEFF6F, 4f + abs(randomGaussian()),
          CameraX + width * (2.6f + random(0.4f)),
          CameraY + stage.me.vy - height * 2 + random(height * 5)
          ));
      }
    }
    preCameraX = CameraX;
    preCameraY = CameraY;
  }
  
  
}

void Draw() {
  //object draw
  stage.me.optifineCamera();
  for(Object obj: objects) {
    obj.Draw();
  }
  //layer flip
  imageMode(CORNER);
  for(Map.Entry set : layers.entrySet()) {
    image((PGraphics)set.getValue(), 0, 0);
  }
}

void mousePressed() {
  isMousePressed = true;
}