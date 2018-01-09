
float Framed(float num) {
  return num / frameRate;
}

float pulse(float num, float filter) {
  return (abs(num) >= filter) ? num : 0f;
}

float Beat(float interval) {
  return ((float)frameCount % (frameRate * interval)) / (frameRate * interval);
}

void playSound(String soundKey, int Cue) {
  if(sounds.get(soundKey) == null) { 
    print("* error : " + soundKey + "\n");
    return;
  }
  sounds.get(soundKey).play();
  sounds.get(soundKey).cue(Cue);
}