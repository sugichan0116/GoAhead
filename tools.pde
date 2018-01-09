
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
  print("* " + soundKey + "\n");
  if(sounds.get(soundKey) == null) return;
  sounds.get(soundKey).play();
  sounds.get(soundKey).cue(Cue);
}