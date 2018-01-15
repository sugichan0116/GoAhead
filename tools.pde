
float Framed(float num) {
  return num / frameRate;
}

String timeToString(float time) {
  return floatToString(time) + " s";
}

String timesToString(float time, float maxTime) {
  return floatToString(time) + " / " +
    floatToString(maxTime) + " s";
}

String distanceToString(float distance) {
  return floatToString(distance) + " km";
}

String distancesToString(float distance, float maxDistance) {
  return floatToString(distance) + " / " +
    floatToString(maxDistance) + " km";
}

String distancesToStringNormal(boolean flag, float distance, float maxDistance) {
  return (flag) ? distancesToString(distance, maxDistance)
    : distanceToString(distance) ;
}

String floatToString(float num) {
  return String.format("%,3.1f", num);
}

boolean checkBit(int target, int filter) {
  return (target & filter) == filter;
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