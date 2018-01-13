
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
    Update();
    Draw();
  }
  
  //system
  isMousePressed = false;
  
}

void Update() {
  if(stage.isPlay() == true) {
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
    int products = int((camera.x - defCamera.x) / 64f);
    if(products > 1) {
      for(int i = 0; i < products; i++) {
        if(int(random(8f)) == 0) {
          //item生成
          objects.add(new Item(
            int(random(7f)), 16f, 
            camera.x + width * 1.6f,
            camera.y + stage.me.vy - height + random(height * 3),
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
            camera.x + width * 1.6f,
            camera.y + stage.me.vy - height + random(height * 3),
            v.x,
            v.y
            ));
        }
        for(int k = 0; k < 4 * products; k++) {
          objects.add(new Background(
            .15f + random(.4f), #EEFF6F, 4f + abs(randomGaussian()),
            camera.x + width * (2.6f + random(0.4f)),
            camera.y + stage.me.vy - height * 2 + random(height * 5)
            ));
        }
      }
      defCamera.set(camera);
    }
    
    stage.Update();
  } else if(stage.isPlay() == false) {
    Stage buf = null;
    for(Field temp: fields) {
      //temp.Draw();
      if(isMousePressed && ((Stage)temp).isOverlap()) buf = (Stage)temp;
    }
    if(buf != null) {
      //print("* " + stage.state + "\n");
      if(!buf.isOver() && buf.isPause()) {
        stage.Play();
      } else {
        stage.Reset();
        stage = buf;
        stage.Init();
        stage.Reset();
        stage.Play();
      }
    }
  }
  
}

void Draw() {
  //object draw
  stage.me.optifineCamera();
  for(Object obj: objects) {
    obj.Draw();
  }
  
  if(stage.isPlay()) stage.Draw();
  else {
    DrawMenu();
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

void DrawMenu() {
  PGraphics pg = layers.get("MENU");
  pg.beginDraw();
  pg.pushStyle();
  pg.pushMatrix();
    pg.textAlign(RIGHT, TOP);
    pg.noStroke();
    pg.fill(255, 196);
    pg.textFont(font_Title);
    pg.textSize(64);
    pg.text("Go AHEAD", width - 16f, 32f);
    pg.fill(196, 196);
    pg.quad(
      32f, 32f,
      32f + width * .4f, 32f,
      32f + 32f / 48f * ( height - 32f ) + width * .4f, height - 32f,
      32f + 32f / 48f * ( height - 32f ), height - 32f );
  pg.popMatrix();
  pg.popStyle();
  pg.endDraw();
}

void mousePressed() {
  isMousePressed = true;
}