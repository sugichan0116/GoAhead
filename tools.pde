
float Framed(float num) {
  return num / frameRate;
}

float Beat(float interval) {
  return ((float)frameCount % (frameRate * interval)) / (frameRate * interval);
}

void playSound(String soundKey, int Cue) {
  sounds.get(soundKey).play();
  sounds.get(soundKey).cue(Cue);
}