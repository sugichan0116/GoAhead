/*

ロケットの大きさ　拡大と縮小
カメラワークの拡大と縮小
まわってるやつの速度UP
スピード上がるエリアリング


*/

/* library */
import java.util.HashMap;
import java.util.Map;
import java.util.Arrays;
import ddf.minim.*;

/* game arrays */
//オブジェクト管理
ArrayList<Object> objects;
//playeradress
ArrayList<Field> fields; 
Stage stage;

/* system */
//pressflag
boolean isMousePressed;
//cameras
float CameraX = 0, CameraY = 0;
float preCameraX, preCameraY;

/* materials */
//icon配列
HashMap<String, PImage> icons;
//layer
HashMap<String, PGraphics> layers;
//font
PFont font;
//sound
Minim minim;
HashMap<String, AudioPlayer> sounds;

void setup() {
  size(480, 360);
  
  String path = "data/";
  
  icons = new HashMap<String, PImage>();
  icons.put("PLAYER", loadImage(path + "rocket.png"));
  icons.put("MOON", loadImage(path + "moon.png"));
  icons.put("HEART_FILL", loadImage(path + "heart.png"));
  icons.put("HEART_EMPTY", loadImage(path + "heart2.png"));
  icons.put("ITEM_REPAIR", loadImage(path + "item.png"));
  icons.put("ROCK_1", loadImage(path + "rock.png"));
  icons.put("ROCK_2", loadImage(path + "rock2.png"));
  icons.put("ROCK_3", loadImage(path + "rock3.png"));
  
  minim = new Minim(this);
  sounds = new HashMap<String, AudioPlayer>();
  sounds.put("ECHO_1", minim.loadFile(path + "echo.mp3"));
  sounds.put("ECHO_2", minim.loadFile(path + "echo2.mp3"));
  sounds.put("ECHO_3", minim.loadFile(path + "echo3.mp3"));
  sounds.put("ITEM", minim.loadFile(path + "pick.mp3"));
  sounds.put("BOMB_1", minim.loadFile(path + "001.mp3"));
  sounds.put("BOMB_2", minim.loadFile(path + "002.mp3"));
  sounds.put("BOMB_3", minim.loadFile(path + "003.mp3"));
  sounds.put("BOMB_4", minim.loadFile(path + "004.mp3"));
  sounds.put("BOMB_5", minim.loadFile(path + "005.mp3"));
  sounds.put("BOMB_6", minim.loadFile(path + "006.mp3"));
  
  layers = new HashMap<String, PGraphics>();
  layers.put("UI", createGraphics(width, height));
  
  font = loadFont(path + "Molot-48.vlw");
  
  
  fields = new ArrayList<Field>();
  stage = new Stage();
  fields.add(stage);
  stage.Init();
}