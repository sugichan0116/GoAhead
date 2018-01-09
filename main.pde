
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
  
  /*
  print("* " + objects.size());
  int n = 0, m = 0, k = 0;
  for(Object temp : objects) {
    if(temp instanceof Bullet) n++;
    else if(temp instanceof Item) m++;
    else if(temp instanceof Obstacle) k++;
  }
  print(" @ [" + n + "] [" + m + "] [" + k + "]\n");
  */
}

void Update() {
  //remove & update
  for(int i = objects.size() - 1; i >= 0; i--) {
    if((objects.get(i)).isDestroyed()) objects.remove(i);
    else (objects.get(i)).Update();
  }
  
  //collision
  for(int m = 0; m < objects.size() - 1; m++) {
    for(int n = m + 1; n < objects.size(); n++) {
      if((objects.get(m)).isCollision((Matrix)objects.get(n))) {
        (objects.get(m)).collision(objects.get(n));
        (objects.get(n)).collision(objects.get(m));
      }
    }
  }
  
  //object produce
  int products = int((CameraX - preCameraX) / 64f);
  if(products > 1) {
    for(int i = 0; i < products; i++) {
      if(int(random(8f)) == 0) {
        //item生成
        objects.add(new Item(
          int(random(4f)), 16f, 
          CameraX + width * 1.6f,
          CameraY + stage.me.vy - height + random(height * 3),
          0f, 0f
          ));
      } else {
        PVector v = new PVector(-pulse(abs(randomGaussian() * 32f), 64f), 0f);
        if(v.x < 0f) v.y = randomGaussian() * 64;
        //obst生成
        objects.add(new Obstacle(
          int(random(3f)),
          pulse(abs(randomGaussian() * 64f), 128f) + abs(randomGaussian() * 16) + 16,
          random(TAU),
          CameraX + width * 1.6f,
          CameraY + stage.me.vy - height + random(height * 3),
          v.x,
          v.y
          ));
      }
      for(int k = 0; k < 4 * products; k++) {
        objects.add(new Background(
          .15f + random(.4f), #EEFF6F, 4f + abs(randomGaussian()),
          CameraX + width * (2.6f + random(0.4f)),
          CameraY + stage.me.vy - height * 2 + random(height * 5)
          ));
      }
    }
    preCameraX = CameraX;
    preCameraY = CameraY;
  }
  
  stage.Update();
}

void Draw() {
  //object draw
  stage.me.optifineCamera();
  for(Object obj: objects) {
    obj.Draw();
  }
  
  if(stage.isPause()) {
    PGraphics pg = layers.get("MENU");
    pg.beginDraw();
    pg.pushStyle();
    pg.pushMatrix();
      pg.textAlign(RIGHT, TOP);
      pg.noStroke();
      pg.fill(128, 196);
      pg.textSize(48);
      pg.text("GoAhead", width - 16f, 32f);
      pg.quad(
        32f, 32f,
        32f + width * .4f, 32f,
        32f + 32f / 48f * ( height - 32f ) + width * .4f, height - 32f,
        32f + 32f / 48f * ( height - 32f ), height - 32f );
    pg.popMatrix();
    pg.popStyle();
    pg.endDraw();
    for(Field temp: fields) {
      temp.Draw();
    }
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