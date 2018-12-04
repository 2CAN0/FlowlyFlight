import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 
import ddf.minim.effects.*; 
import ddf.minim.signals.*; 
import ddf.minim.spi.*; 
import ddf.minim.ugens.*; 
import ddf.minim.*; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FowlyFlight_ConceptV1 extends PApplet {

// The Fowly Flight
// IG102-2







public void setup() {
  Sound = new Minim(this);
  menutheme = Sound.loadFile("menu1.mp3");
  jump = Sound.loadFile("jump.wav");
  bounce = Sound.loadFile("mJump.wav");
  hit = Sound.loadFile("Hit_Hurt.wav");
  coin_pickup = Sound.loadFile("Pickup_Coin.wav");
  gameOver = Sound.loadFile("gameOver1.mp3");
  explosion = Sound.loadFile("Explosion.wav");
  theme = Sound.loadFile("menu2.mp3");
  menutheme.play();
  
  noStroke();
  noCursor();
  
  frameRate(60);
  background(30);
  mainSetup();
}

public void draw() {
  if (inMenu && !playGame & !inShop) {  
    menu.update();
    menu.draw();
  } else if (playGame && !inShop) {
    if (!dead.status) {
      background(30);
      drawWall();
      drawBuilding();
      enemyUpdate();
      player.update();
      playerLauncherUpdate();
      if (player.launched)
        player.draw();
      collectableUpdate();
      score.update();      
      score.draw();
      stamina.update();
      stamina.draw();
    } else {
      dead.draw();
      dead.update();
    }
  } else if (inShop) {
    menuShop.update();
    menuShop.draw();
  }

  if (devMode) {
    textAlign(RIGHT, TOP);
    textSize(20);
    if (frameRate < 55) {
      fill(255, 0, 0);
    } else {
      fill(255);
    }
    println("fps: "+ frameRate);
    text("fps: "+ frameRate, width, 0); 
    fill(255);
  }
}

public void keyPressed() {  
  if (keyCode < KEY_LIMIT) 
    keysPressed[keyCode] = true;
}

public void keyReleased() {
  if (keyCode < KEY_LIMIT)
    keysPressed[keyCode] = false;

  enterPressed = false;
  hs.changedSelected = false;

  if (inMenu) {
    menu.changedSelected = false;
  } else if (inShop) {
    menuShop.changedSelected = false;
  }
  
  hs.nameC.changed = false;
}
//Luca Ruiters - 500796991
class Collectables {
  float x, 
    y, 
    vx, 
    radius;

  Collectables(float velocityX) {
    y = random(0, height/3*2 - radius);
    x = random(width, width + 100);
    vx = velocityX;
    radius = 50;
    timerStart();
  }

  public void update() {
    x += vx;
  }

  public void timerStart() {
    timer2.start();
  }

  public void timerStop() {
    timer2.stop();
  }

  public void draw() {
    if (hitDetected(player, coin)) {
      collectedCoins += 1;
      coin_pickup.rewind();
      coin_pickup.play();
      vx   = -10;
      x = 0 - radius;
      println("Coins: "+(int)collectedCoins);
    } else {
      fill(0xffFFF158);
      ellipse(x, y, radius*2, radius*2);
      //println("X: "+x+ " Y:"+ y+" xVelocity: "+vx +" TimeElapsed: "+timer2.second());
    }
  }

  public boolean hitDetected(Player pl, Collectables coin) {
    boolean x = (pl.x > coin.x - coin.radius && pl.x < coin.x + coin.radius) || (pl.x + pl.w > coin.x - coin.radius && pl.x + pl.w < coin.x + coin.radius);
    boolean y = (pl.y > coin.y - coin.radius && pl.y < coin.y + coin.radius) || (pl.y + pl.h > coin.y - coin.radius && pl.y + pl.h < coin.y + coin.radius);

    return (x && y);
  }
}

public void collectableUpdate() {
  if (timer2.second() >= 10) {
    timer2.stop();
    coin.x = width + 100;
    coin.y = random(0, height);
    timer2 = new StopWatchTimer();
    timer2.start();
  }

  coin.update();
  coin.draw();
}
class GameOver {
  float x, 
    y, 
    tekst, 
    goWidth, 
    goHeight = 75, 
    goSpacing =120, 
    fontSize = 80;

  String text;
  boolean hover = false;
  boolean status = false;

  GameOver (float goX, float goY, float gameOverWidth, float gameOverHeight, String goText, float gameOverSpacing) {
    x = goX;
    y = goY;
    goWidth = gameOverWidth;
    goHeight = gameOverHeight;
    text = goText;
    goSpacing = gameOverSpacing;
  }

  public void draw() {
    noStroke();
    image(wallpaper, 0, 0, width, height );
  }

  public void update() {
    if (status) {
      if (!gameOverPlayer) {
        gameOver.rewind();
        gameOver.play();
        theme.pause();
      }
      hs.update(score.score);
      hs.draw();
    }
  }
}

public void restart() {
  enemyReset();
  hsUpdated = false;
  hs.nameC.nameSet = false;
  gameOverPlayer = false;
  enemies.add(new Enemy(30, 30, player.vx, plane));
  Buildings.clear();
  setupBuilding();
  player = new Player();
  movingWalls.clear();
  setupWall(); 
  playerLauncher = new PlayerLauncher(canon);
  coin = new Collectables(player.vx);
  collectedCoins = 0;
  setupScore();
  setupStamina();
}
class HighScore {
  Table scores;
  String fileLocation;
  int maxScores;
  PVector size;
  boolean restart = false;
  boolean changedSelected = false;
  MiniMenu mm;
  NameCreater nameC;

  HighScore(String fL, int mS, float w, float h, NameCreater NC) {
    fileLocation = fL;
    maxScores = mS;
    try {
      scores = loadTable(fileLocation, "header"); 
      scores.getInt(0, 0);
      println("Table Loaded (HighScores)");
    } 
    catch (Exception ex) {
      println("!!!!!!Failed to load table we will create a new one!!!!!!!"); 
      println("Error: "+ex.getMessage());

      createTable();
    }
    size = new PVector(w, h);
    mm = new MiniMenu(opt);
    nameC = NC;
  }

  public void createTable() {
    scores = new Table();
    String[] devNames = {"2CAN0", "FSaurus", "Nino", "Mitchell", "Jay", "Luca", "Alex", "John", "AAA", "AAA"};
    int[] plScores = {7000, 6000, 5000, 4000, 3000, 2000, 1000, 500, 250, 0};
    scores.addColumn("id");
    scores.addColumn("name");
    scores.addColumn("score");
    for (int iData = 0; iData < maxScores; iData++) {
      TableRow newRow = scores.addRow();
      newRow.setInt(0, iData);
      newRow.setString(1, devNames[iData]);
      newRow.setInt(2, plScores[iData]);
    }

    println("Table Created");
  }

  public void update(double s) {
    if (s >= scores.getInt(scores.getRowCount() - 1, "score") && !nameC.nameSet) {
      nameC.update();
      nameC.draw();
    } else {
      nameC.nameSet = true;
    }

    if (!hsUpdated && nameC.nameSet) {
      sortTable(scores, s, name);
      hsUpdated = true;
      while (scores.getRowCount() > maxScores) {
        scores.removeRow(scores.getRowCount() - 1);
      }

      int iRow = 0;
      for (TableRow r : scores.rows()) {
        r.setInt(0, iRow);
        iRow++;
      }
      save();
    }
  }

  public void drawScores() {
    fill(0, 100);
    rect(width/2 - size.x/2, height/2 - size.y/1.5f, size.x, size.y);
    textAlign(CENTER, TOP);
    fill(255);
    textSize(30);
    text("Highscores", width/2, height/2 - size.y/1.5f + 15);
    int fontSize = 25;
    textSize(fontSize);
    float scoreY = height/2 - size.y/1.5f + fontSize*3.15f;
    for (int iScore = 0; iScore < scores.getRowCount(); iScore++) {
      textAlign(LEFT, CENTER);
      TableRow tr = scores.getRow(iScore);
      if (tr.getInt("score") == score.score && tr.getString("name") == name) {
        fill(255, 255, 0);
      } else {
        fill(255);
      }
      text((tr.getInt(0) + 1)+".", width/2 - size.x/2 + 10, scoreY);
      textAlign(CENTER, CENTER);
      text(tr.getString("name"), width/2, scoreY);
      textAlign(RIGHT, CENTER);
      text((int)Float.parseFloat(tr.getString("score")), width/2 + size.x/2 - 10, scoreY);

      scoreY += fontSize + fontSize/3;
    }
  }

  public void draw() {
    if (nameC.nameSet) {
      drawScores();
      mm.update();
      mm.draw();
    }
  }

  public void save() {
    try {
      saveTable(scores, fileLocation);
      println("Saved succesfully");
    } 
    catch (Exception ex) {
      println("Something went wrong while saving the table");
      println("Error: "+ex.getMessage());
    }
  }

  public void read() {
    for (TableRow r : scores.rows()) {
      println("ID: "+r.getInt(0)+"    Name: "+r.getString(1)+"    Score: "+ r.getDouble(2));
    }
  }

  public Table sortTable(Table t, double high, String nam) {
    TableRow previous;
    int hD = t.getInt(t.getRowCount() - 1, 0);
    String hN = nam;
    double hS = high;

    int d;
    String n;
    double s;

    for (int iRow = t.getRowCount() - 2; iRow >= 0; iRow--) {
      previous = t.getRow(iRow);
      d = previous.getInt(0);
      n = previous.getString(1);
      s = previous.getDouble(2);
      if (hS > s) {
        t.setInt(iRow, 0, hD);
        t.setString(iRow, 1, hN);
        t.setDouble(iRow, 2, hS);

        t.setInt(iRow + 1, 0, d);
        t.setString(iRow + 1, 1, n);
        t.setDouble(iRow + 1, 2, s);
      }
    }
    return t;
  }


  String[] opt = {"Play", "Main"};

  class MiniMenu {
    int AmountButtons;
    int selectedIndex = 0;
    int spacing = 30;

    String[] options;
    String gameName;
    ArrayList<Button> buttons = new ArrayList<Button>();

    MiniMenu(String[] text) {
      options = new String[text.length];
      options = text;

      AmountButtons = options.length;
      float tempW = 250;
      float tempH = 75;
      float tempX = width/2 - tempW * (AmountButtons/2);
      float tempY = height/2 + size.y/2;

      for (int iButton = 0; iButton < AmountButtons; iButton++) {
        if (iButton == 0) {
          buttons.add(new Button(tempX, tempY + tempH/2, tempW, tempH, options[iButton]));
          Button btn = buttons.get(0);
          btn.selected = true;
        } else {
          Button btn = buttons.get(iButton - 1);
          buttons.add(new Button(btn.location.x + tempW + spacing, tempY + tempH/2, tempW, tempH, options[iButton]));
        }
      }
    }

    public void update() {
      if (keysPressed[LEFT] && selectedIndex > 0 && !changedSelected) {
        selectedIndex--;
        Button btn1 = buttons.get(selectedIndex);
        btn1.selected = true;
        Button btn2 = buttons.get(selectedIndex + 1);
        btn2.selected = false;
        changedSelected = true;
      }

      if (keysPressed[RIGHT] && selectedIndex < options.length - 1 && !changedSelected) {
        selectedIndex++;
        Button btn1 = buttons.get(selectedIndex);
        btn1.selected = true;
        Button btn2 = buttons.get(selectedIndex - 1);
        btn2.selected = false;
        changedSelected = true;
      }

      if ((keysPressed[ENTER] || keysPressed[32]) && !enterPressed) {
        enterPressed = true;
        Button btn = buttons.get(selectedIndex);
        if (btn.text == options[0]) {
          restart();
          test.starts += 1;
          gameOver.pause();
          theme.rewind();
          theme.play();
        } else if (btn.text == options[1]) {
          restart();
          inMenu = true;
          playGame = false;
          gameOver.pause();
          menutheme.rewind();
          menutheme.play();
          if (testing) {
            test.stopTesting();
          }
        }
        dead.status = false;
      }
    }

    public void draw() {
      Button tBtn = buttons.get(0);
      for (int iButton = 0; iButton < AmountButtons; iButton++) {
        Button btn = buttons.get(iButton);
        btn.draw();
      }
    }

    class Button {
      PVector location, size;
      String text;
      boolean selected;

      Button(float x, float y, float w, float h, String info) {
        location = new PVector(x, y);
        size = new PVector(w, h);
        text = info;
      }

      public boolean mouseHover() {
        boolean x = (mouseX > location.x && mouseX < location.x + size.x);
        boolean y = (mouseY > location.y && mouseY < location.y + size.y);
        return (x && y);
      }

      public void draw() {
        if (selected) {
          fill(255, 50);
          stroke(255);
          strokeWeight(4);
          int mini = 4;
          //Left Upper
          line(location.x, location.y, location.x + size.y/mini, location.y);
          line(location.x, location.y, location.x, location.y + size.y/mini);

          //Left Lower
          line(location.x, location.y + size.y, location.x, location.y + size.y - size.y/mini);
          line(location.x, location.y + size.y, location.x + size.y/mini, location.y + size.y);

          //Right Upper
          line(location.x + size.x, location.y, location.x + size.x - size.y/mini, location.y);
          line(location.x + size.x, location.y, location.x + size.x, location.y + size.y/mini);

          //Right Lower
          line(location.x + size.x, location.y + size.y, location.x + size.x - size.y/mini, location.y+ size.y);
          line(location.x + size.x, location.y + size.y, location.x + size.x, location.y + size.y - size.y/mini);
        } else {
          fill(0, 100);
          noStroke();
        }

        noStroke();
        rect(location.x, location.y, size.x, size.y);
        fill(255);
        textSize(30);
        textAlign(CENTER, CENTER);
        text(text, location.x + size.x/2, location.y + size.y/2);
        noStroke();
      }
    }
  }
}
//Luca Ruiters - 500796991
ArrayList<PImage> wall = new ArrayList<PImage>();

class Menu {
  int AmountButtons;
  int selectedIndex = 0;
  int spacing = 30;

  String[] options;
  ArrayList<Button> buttons = new ArrayList<Button>();
  boolean changedSelected = false;
  String gameName;
  ArrayList<PImage> wallpaper;
  PImage fWall;

  Menu(String[] text, String GN, ArrayList<PImage> img) {
    options = new String[text.length];
    options = text;
    
    gameName = GN;
    
    AmountButtons = options.length;
    float tempW = 250;
    float tempH = 85;
    float tempX = width/2;
    float tempY = height / 2 - tempH *(AmountButtons/2);
    
    wallpaper = img;
    fWall = wallpaper.get((int)random(0,wallpaper.size()));
    
    for (int iButton = 0; iButton < AmountButtons; iButton++) {
      if (iButton == 0){
        buttons.add(new Button(tempX - tempW/2, tempY, tempW, tempH, options[iButton]));
        Button btn = buttons.get(0);
        btn.selected = true;
      } else {
        Button btn = buttons.get(iButton - 1);
        buttons.add(new Button(tempX - tempW/2, btn.location.y + tempH + spacing, tempW, tempH, options[iButton]));
      }
    }
  }

  public void update() {
    if (keysPressed[UP] && selectedIndex > 0 && !changedSelected) {
      selectedIndex--;
      Button btn1 = buttons.get(selectedIndex);
      btn1.selected = true;
      Button btn2 = buttons.get(selectedIndex + 1);
      btn2.selected = false;
      changedSelected = true;
    }

    if (keysPressed[DOWN] && selectedIndex < options.length - 1 && !changedSelected) {
      selectedIndex++;
      Button btn1 = buttons.get(selectedIndex);
      btn1.selected = true;
      Button btn2 = buttons.get(selectedIndex - 1);
      btn2.selected = false;
      changedSelected = true;
    }
    
    if (keysPressed[ENTER] || keysPressed[32] && !enterPressed) {
      enterPressed = true;
      Button btn = buttons.get(selectedIndex);
      if (btn.text == options[0]){
         inMenu = false;
         playGame = true;
         menutheme.pause();
         theme.rewind();
         theme.play();
         
         if(testing){
            test.startTesting(); 
            test.starts += 1;
         }
      } else if (btn.text == options[1]){
         inMenu = false;
         inShop = true;                                          
      } else if (btn.text == options[2]){
         exit(); 
      }
    }
  }

  public void draw() {
    image(fWall, 0,0, width, height);
    Button tBtn = buttons.get(0);
    textFont(font, 100);
    textAlign(CENTER, CENTER);
    text(gameName, width/2, tBtn.location.y/2 - spacing);
    textAlign(TOP, LEFT);
    for (int iButton = 0; iButton < AmountButtons; iButton++){
       Button btn = buttons.get(iButton);
       btn.draw();
    }
  }

  class Button {
    PVector location, size;
    String text;
    boolean selected;

    Button(float x, float y, float w, float h, String info) {
      location = new PVector(x, y);
      size = new PVector(w, h);
      text = info;
    }
    
    public boolean mouseHover() {
      boolean x = (mouseX > location.x && mouseX < location.x + size.x);
      boolean y = (mouseY > location.y && mouseY < location.y + size.y);
      return (x && y);
    }

    public void draw() {
      if (selected) {
        fill(255, 50);
        noStroke();
        rect(location.x, location.y, size.x, size.y);
        stroke(255);
        strokeWeight(4);
        int mini = 4;
        //Left Upper
        line(location.x, location.y, location.x + size.y/mini, location.y);
        line(location.x, location.y, location.x, location.y + size.y/mini);

        //Left Lower
        line(location.x, location.y + size.y, location.x, location.y + size.y - size.y/mini);
        line(location.x, location.y + size.y, location.x + size.y/mini, location.y + size.y);

        //Right Upper
        line(location.x + size.x, location.y, location.x + size.x - size.y/mini, location.y);
        line(location.x + size.x, location.y, location.x + size.x, location.y + size.y/mini);

        //Right Lower
        line(location.x + size.x, location.y + size.y, location.x + size.x - size.y/mini, location.y+ size.y);
        line(location.x + size.x, location.y + size.y, location.x + size.x, location.y + size.y - size.y/mini);
      } else {
        fill(0, 100);
        noStroke();
        rect(location.x, location.y, size.x, size.y);
      }
 
      fill(255);
      textFont(font, 30);
      textAlign(CENTER, CENTER);
      text(text, location.x + size.x/2, location.y + size.y/2);
    }
  }
}
class NameCreater {
  PVector position;
  float size;
  int fontSize;
  int selectedIndex = 0;
  boolean changed = false;
  boolean nameSet = false;

  ArrayList<character> chars = new ArrayList<character>();

  NameCreater(float amount) {
    position = new PVector(width/2, height/2);
    size = amount;
    fontSize = 40;
    for (int iChar = 0; iChar < size; iChar++) {
      if (iChar == 0) {
        try {
          chars.add(new character(width/2 - size/2*fontSize, height/2, name.charAt(iChar)));
        }
        catch (Exception ex) {
          chars.add(new character(width/2 - size/2*fontSize, height/2, PApplet.parseChar('a')));
        }
      } else {
        character prChar = chars.get(iChar - 1);
        try {
          chars.add(new character(prChar.position.x + 5 + fontSize, height/2, name.charAt(iChar)));
        } 
        catch (Exception ex) {
          chars.add(new character(prChar.position.x + 5 + fontSize, height/2, PApplet.parseChar(' ')));
        }
      }
    }
  }

  public void update() {
    if (keysPressed[LEFT] && selectedIndex > 0 && !changed) {
      selectedIndex--;
      changed = true;
      character prevC = chars.get(selectedIndex + 1);
      prevC.selected = false;
    }
    if (keysPressed[RIGHT] && selectedIndex < size - 1 && !changed) {
      selectedIndex++;
      changed = true;
      character prevC = chars.get(selectedIndex - 1);
      prevC.selected = false;
    }

    if (keysPressed[ENTER] || keysPressed[32] && !enterPressed) {
      enterPressed = true;
      nameSet = true;
      name = "";
      for (character t : chars) {
        name += PApplet.parseChar(t.charCode);
      }
      
    } else {   
      character c = chars.get(selectedIndex);
      c.selected = true;
      c.update();
    }
  }

  public void draw() {
    for (int iChar = 0; iChar < size; iChar++) {
      character c = chars.get(iChar);
      c.draw();
    }
    
    fill(255);
    stroke(255);
    textAlign(CENTER,CENTER);
    text("You got into the top 10", width/2, height/5);
    text("Press EnterENTER to continue", width/2, height/5*4);
    textAlign(TOP, LEFT);
  }

  class character {
    int charCode;
    PVector position;
    boolean selected = false;

    character(float x, float y, char d) {
      charCode = PApplet.parseChar(d);
      position = new PVector(x, y);
    }

    public void update() {
      if (selected) {
        if (keysPressed[DOWN] && !changed) {
          charCode++;
          changed = true;
        }
        if (keysPressed[UP] && !changed) {
          charCode--;
          changed = true;
        }

        if (keyPressed && !changed) {
          charCode = PApplet.parseChar(keyCode);
        }
      }
    }

    public void draw() {      
      if (selected) {
        fill(255, 100);
        rect(position.x, position.y - fontSize*1.5f, fontSize, fontSize*1.5f);
      }

      fill(255);
      stroke(255);
      line(position.x, position.y, position.x + fontSize, position.y);
      textSize(fontSize);
      textAlign(LEFT, BOTTOM);
      text(PApplet.parseChar(charCode), position.x, position.y);
    }
  }
}
// Alex

class Stamina {
  float staminaBarX, staminaBarY, staminaLevel, staminaMax, staminaHeight, staminaBarClr, staminaWidth;
  int staminaDrain, staminaRegen;

  Stamina(Score sc) {
    staminaBarX = sc.w;
    staminaBarY = 0;
    staminaLevel = 1420.0f;
    staminaMax = width - sc.w;
    staminaWidth = staminaLevel;
    staminaHeight = 30;
    staminaBarClr = color(0, 255, 0);
    staminaDrain = 6;
    staminaRegen = 1;
  }

  public void update() {
    if (keysPressed[32] && player.launched == true && staminaLevel > 0 || keysPressed[ENTER] && player.launched == true && staminaLevel > 0) {
      staminaLevel -= staminaDrain;
    } else {
      if (staminaLevel < staminaMax) {
        staminaLevel += staminaRegen;
      }
    }
  }

  public void draw() {
    stroke(255);
    fill(0, 0);
    rect(staminaBarX, staminaBarY, staminaMax, staminaHeight);
    fill(0, 255, 0);
    rect(staminaBarX, staminaBarY, staminaLevel, staminaHeight);
    
    textAlign(LEFT, CENTER);
    textSize(20);
    fill(0);
    text("stamina", staminaBarX + 3, staminaHeight / 2);
  }
}

public void setupStamina() {
  stamina = new Stamina(score);
}
class StopWatchTimer {
  int startTime = 0, stopTime = 0;
  boolean running = false;  


  public void start() {
    startTime = millis();
    running = true;
  }
  
  public void stop() {
    stopTime = millis();
    running = false;
  }
  
  public int getElapsedTime() {
    int elapsed;
    if (running) {
      elapsed = (millis() - startTime);
    } else {
      elapsed = (stopTime - startTime);
    }
    return elapsed;
  }
  
  public int second() {
    return (getElapsedTime() / 1000) % 60;
  }
  
  public int minute() {
    return (getElapsedTime() / (1000*60)) % 60;
  }
  
  public int hour() {
    return (getElapsedTime() / (1000*60*60)) % 24;
  }
}
// "Press SPACE to launch and gain altitude"
class Tutorial {
  PVector position, size;
  float ttlSpacing = 120;

  String text;
  boolean hover = false;
  boolean grow = false;
  float minSize;
  float maxSize;
  float xShrink;
  float yShrink;
  PImage button;

  Tutorial (float ttlX, float ttlY, String ttlTextTutorial, float titleSpacing, PImage btn, float ttlW, float ttlH) {
    position = new PVector(ttlX, ttlY);
    size = new PVector(ttlW, ttlH);
    text = ttlTextTutorial;
    ttlSpacing = titleSpacing;
    
    minSize = size.x - .12f;
    maxSize = size.x + .12f;
    xShrink = minSize/size.x;
    yShrink = size.y - 5/size.y;

    button = btn;
  }

  public void changeSize() {
    float dim = 120;
    if (!grow) {
      if (size.x > minSize) {
        size.y -= yShrink/dim;
        size.x -= xShrink/dim;
      } else
        grow = true;
    } else {
      if (size.x < maxSize) {
        size.y += yShrink/dim;
        size.x += xShrink/dim;
      } else
        grow = false;
    }
  }

  public void draw() {
    textAlign(CENTER, CENTER);
    textFont(tutText);
    textSize(50);
    fill(255); //RGB
    text(text, position.x, height/4 - 60);
    changeSize();
    image(button, position.x - ttlW/2, position.y, size.x, size.y);
    textFont(font);
  }
}

public void setupTutorial() {
  ttlTutorial = new Tutorial(width/2, height/4, "To Gain Altitutde", 40, spaceBar, ttlW, ttlH);
}

public void drawTutorial() {
  fill(255);
  ttlTutorial.draw();
}
class Testing {
  Table time;
  String fileLocation;
  int starts;
  StopWatchTimer playTime = new StopWatchTimer(); 
  
  Testing(String fLocation) {
    fileLocation = fLocation;
     try{
        time = loadTable(fileLocation, "header"); 
        time.getInt(0,0);
        println("Table Loaded");
     } catch (Exception ex){
        println("!!!!!!Failed to load table we will create a new one!!!!!!!"); 
        println("Error: "+ex.getMessage());
        
        createTable();
     }
  }
  
  public void createTable(){
     time = new Table();
     
     time.addColumn("id");
     time.addColumn("round time");
     time.addColumn("restarts");
     time.addColumn("average time");
     println("Table Created");
  }
  
  public void startTesting(){
    playTime.start();
  }
  
  public void stopTesting(){
      playTime.stop();
      TableRow newResults = time.addRow();
      newResults.setInt(0, time.getRowCount());
      newResults.setString(1, playTime.minute() + ":"+((float)playTime.getElapsedTime() / 1000 - (60 * (playTime.getElapsedTime() / (1000*60)) % 60))); //PlayTime in miliseconds
      newResults.setInt(2, starts);
      newResults.setString(3, ((playTime.getElapsedTime()/starts / (1000*60)) % 60) + ":" + ((float)playTime.getElapsedTime()/starts / 1000 - (60 * (playTime.getElapsedTime()/starts / (1000*60)) % 60)));
      try{
        saveTable(time, fileLocation);
        println("Table Saved");
      }catch (Exception ex){
         println("Failed to save table!!\nError: "+ex.getMessage()); 
      }      
      playTime = new StopWatchTimer();
      starts = 0;
  }
   
}
final int KEY_LIMIT = 1024;
final int MAX_SCORES = 10;
boolean[] keysPressed = new boolean[KEY_LIMIT];
boolean hsUpdated = false;
boolean enterPressed = false;
String hsLocation = "data/highScore.csv";
String name = "AAA";

Player player;
PlayerLauncher playerLauncher;
Collectables coin;
Tutorial ttlTutorial;
GameOver dead;
Stamina stamina;
HighScore hs;
Animation blueBird;
NameCreater nameCreater;


/////DEV-MODE BEVAT coole en rare mechanics xD//////
boolean devMode = false;
////////////////////////////////////////////////////

///////Testing/////////
String testFileLocation = "data/testData.csv";
boolean testing = true;
Testing test;
///////////////////////

PFont font;
float defaultOverallVX;
float playerTotalStam;
float totalPlayerVx;
PImage wallpaper;

//Audio
Minim Sound;
AudioPlayer menutheme;
AudioPlayer jump;
AudioPlayer bounce;
AudioPlayer hit;
AudioPlayer coin_pickup;
AudioPlayer gameOver;
AudioPlayer explosion;
AudioPlayer theme;
boolean gameOverPlayer = false;

//Menu
Menu menu;
String gameName = "Fowly Flight";
String[] options = {"Play", "Shop", "Exit"};
boolean inMenu = true;
boolean playGame = false;
boolean inShop = false;

//Player
PImage canon;

//Shop menu
ShopMenu menuShop;

//Collectables
float collectedCoins = 0;
StopWatchTimer timer2;

//Enemies
///Enemy Buildings
final int MAX_BUILDINGS = 2;
String[] buildingNames = {"Gebouw.png"};
PImage[] buildingImages = new PImage[buildingNames.length];

///Enemy Airplane
StopWatchTimer timer;
float enemiesCount = 1, 
  spawn = (random(5, 8));
PImage plane;
float planeWidth = 100;
float planeHeight = 50;

//Character Shop
String[] characterNames = {"ducky_", "gunther_","owliver_","wally_","monsieurMallard_"};
int[] characterFrames = {2, 4, 7, 3, 4};
Animation[] characters = new Animation[characterNames.length];
int selectedCharacter = 0;

//Score
Score score;
float scoreWidth = 200;

//Tutorial
PImage spaceBar;
PFont tutText;
float ttlH = 160;
float ttlW = 340;

public void mainSetup() {
  //Test
  test = new Testing(testFileLocation);
  
  //NameCreater
  nameCreater = new NameCreater(6);
  
  //Wallpaper
  wall.add(loadImage("Sprites/backGround.png"));
  wall.add(loadImage("Sprites/backGround2.png"));

  //Collectables
  timer2 = new StopWatchTimer();

  //Enemies
  timer = new StopWatchTimer();
  plane = loadImage("Sprites/plane.png");

  wallpaper = loadImage("Sprites/backgroundGrey.png");

  for (int iBuilding = 0; iBuilding < buildingNames.length; iBuilding++) {
    buildingImages[iBuilding] = loadImage("Sprites/"+buildingNames[iBuilding]);
  }
  
  //General
  player = new Player();
  hs = new HighScore(hsLocation, MAX_SCORES, 350, 400, nameCreater);
  canon = loadImage("Sprites/canon_0.png");
  playerLauncher = new PlayerLauncher(canon);
  coin = new Collectables(player.vx);
  playerTotalStam = player.vx;
  totalPlayerVx = player.vx;
  dead = new GameOver(width/2, height/2 - 40, 225, 100, "OMG You dieded!\n\n Press A to restart", 30);
  menu = new Menu(options, gameName, wall);
  
  for(int iChar = 0; iChar < characterNames.length; iChar++){
     characters[iChar] = new Animation(characterNames[iChar], characterFrames[iChar]); 
  }
  
  menuShop = new ShopMenu(wall, characters);

  //player
  blueBird = new Animation(characterNames[selectedCharacter], 2);

  //Tutorial
  spaceBar = loadImage("Sprites/spaceBar.png");
  tutText = loadFont("tutFont.vlw");

  enemies.add(new Enemy(planeHeight, planeWidth, 10, plane));
  font = loadFont("data/8BIT.vlw");
  setupBuilding();
  setupWall(); 
  setupScore();
  setupTutorial();
  setupStamina();
}
class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  int fps = 12;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = "Sprites/"+imagePrefix + i +".png";
      images[i] = loadImage(filename);
    }
  }

  public void display(float xpos, float ypos, float w, float h) {
    if(frameCount % fps == 0)
      frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos, w, h);
  }
  
  public int getWidth() {
    return images[0].width;
  }
}
class Background {
  float x1, 
    y1, 
    x2, 
    y2, 
    vx, 
    w, 
    h, 
    r1, r2, 
    g1, g2, 
    b1, b2;
    
    PImage wall;

  Background(float playerVX, float layerHeight, float r, float g, float b, PImage wa) {
    w = width + 200;
    h = layerHeight;
    y1 = height - h;
    y2 = height - h;
    x1 = 0;
    x2 = x1 + w;
    vx = playerVX/2;
    wall = wa;

    r1 = r;
    if (r *2 < 256) {
      r2  = r *2;
    } else {
      r2 = r - 100;
    }

    g1 = g;
    if (g * 2 < 256) {
      g2 = g * 2;
    } else {
      g2 = g - 100;
    }

    b1 = b;
    if (b * 2 < 256) {
      b2 = b * 2;
    } else {
      b2 = b - 100;
    }
  }

  public void update() {
    vx = player.vx/1.5f;
    if (x1 < x2) {
      if (x2 > 0) {
        x1 += vx;
        x2 += vx;
      } else {
        x1 = x2 + w;
      }
    } else {
      if (x1 > 0) {
        x2 += vx;
        x1 += vx;
      } else {
        x2 = x1 + w;
      }
    }

    //println("#1 X: "+x1+"  Y: "+y1);
    //println("#2 X: "+x2+"  Y: "+y2);
  }

  public void draw() {
    noStroke();
    fill(r1, g1 , b1);
    image(wall, x1, y1, w, h);
    fill(r2, g2, b2);
    image(wall, x2, y2, w, h);
    if (!player.launched && playGame)
      drawTutorial();
  }
}

public void setupWall() {             
  movingWalls.add(new Background(player.vx, height, 0,0,random(128,256), wallpaper));
  //movingWalls.add(new Background(player.vx, height/3, 0, random(128,256),0, wallpaper));
}

public void drawWall() {
  for (int iWall = 0; iWall < movingWalls.size(); iWall++) {
    Background bg = movingWalls.get(iWall);
    bg.update();
    bg.draw();
  }
}
ArrayList<Background> movingWalls = new ArrayList<Background>();
// Alexander & Nino & Luca

class ShopMenu {
  PImage fWall;
  boolean changedSelected = false;
  Animation[] characters;

  int arrowLeftPosX, arrowLeftPosY, arrowRightPosX, arrowRightPosY, arrowWidth, arrowHeight;

  ShopMenu (ArrayList<PImage> wall, Animation[] skins) {
    fWall = wall.get((int)random(0, wall.size()));
    characters = skins;

    // Arrows
    arrowLeftPosX = 608;
    arrowLeftPosY = 561;
    arrowRightPosX = 1312;
    arrowRightPosY = 561;
    arrowWidth = 46;
    arrowHeight = 48;
  }

  public void buttons() {
    fill(255);
    triangle (arrowLeftPosX, arrowLeftPosY, arrowLeftPosX + arrowWidth, arrowLeftPosY - arrowHeight, arrowLeftPosX + arrowWidth, arrowLeftPosY + arrowHeight);                // TODO - geen magic numbers!
    triangle (arrowRightPosX, arrowRightPosY, arrowRightPosX - arrowWidth, arrowRightPosY - arrowHeight, arrowRightPosX - arrowWidth, arrowRightPosY + arrowHeight);             // TODO - geen magic numbers!

    fill(0, 120);
    rect(width / 4, height / 4 * 3, width / 2, 50);         // TODO - geen magic numbers!
    textAlign(CENTER, CENTER);
    textSize(30);
    fill(255);
    text("Press ENTER to purchase or select", width / 2, height / 4 * 3 + 25);    // TODO - geen magic numbers!
  }

  public void update() {
    if (keysPressed[ENTER] || keysPressed[32] && !enterPressed) {
      inShop = false;
      inMenu = true;
      enterPressed = true;
    }

    if (keysPressed[RIGHT] && !changedSelected && selectedCharacter < characters.length - 1) {
      selectedCharacter++;
      changedSelected = true;
    } else if (keysPressed[LEFT] && !changedSelected && selectedCharacter > 0) {
      selectedCharacter--;
      changedSelected = true;
    }
  }

  public void draw() {
    image(fWall, 0, 0, width, height);
    float grow = 2;
    characters[selectedCharacter].display(width/2 - player.w/2*grow, height/2 - player.h/2*grow, player.w*grow, player.h*grow);  
    buttons();
  }
}
class EnemyBuilding {
  float x, 
    y, 
    h, 
    w, 
    vx;
    PImage img;

  EnemyBuilding(PImage[] imgList) {
    h = random(50, height/3);
    w = random(200, 300);
    x = random(width, width + 300);
    y = height - h;
    vx = random(-15, -5);
    img = imgList[(int)Math.floor(random(0, imgList.length))];
  }

  public void Move() {
    if (x + w > 0) {
      x += vx;
    } else {
      h = random(75, height/5*2);
      w = random(200, 300);
      x = random(width, width + 300);
      y = height - h;
      vx = random(-15, -5);
    }
  }

  public boolean hitDetected(Player p, EnemyBuilding e) {
  // Als y2Onder groter is dan y1onder en y2Onder kleiner is dan y1Boven licht de het linker onder hoek er tussen
  // Als y2Boven groter is dan y1Boven en kleinder is dan y1Onder licht de linker onder hoek in er tussen
  boolean x = ((p.x > e.x && p.x < e.x + e.w) ||(p.x + p.w > e.x && p.x + p.w < e.x + e.w));
    boolean y = ((p.y > e.y && p.y < e.y + e.h) || (p.y + p.h > e.y && p.y + p.h < e.y + e.h));
    return (x && y);
}

  public void update() {
    if (hitDetected(player, this)) {
      println("You hit a flying enemy!!");
      if (!devMode)
        dead.status = true;
      else {
        //
      }
    } else {
      Move();
    }

    //if (hitDetection(x - player.radius, y - player.radius, x + player.radius, y + player.radius, player.x - player.radius, player.y - player.radius, player.x + player.radius, player.y + player.radius)) {
    //  println("You hit a building. What were you thinking!!");
    //  dead.status = true;
    //} else {
    //  Move();
    //}
  }

  public void draw() {
    fill(255, 200);
    image(img,x, y, w, h);
    if (devMode) {
      fill(0, 0);
      stroke(255, 0, 0);
      rect(x, y, w, h);
      noStroke();
    }
  }
}

ArrayList<EnemyBuilding> Buildings = new ArrayList<EnemyBuilding>();

public void drawBuilding() {
  if (player.vx != 0) {
    for (int iBuilding = 0; iBuilding < Buildings.size(); iBuilding++) {
      EnemyBuilding building = Buildings.get(iBuilding);
      building.update();
      building.draw();
    }
  }
}

public void setupBuilding() {
  for (int iBuilding = 0; iBuilding < MAX_BUILDINGS; iBuilding++) {
    EnemyBuilding building = new EnemyBuilding(buildingImages);
    building.draw();
    Buildings.add(building);
  }
}
//mitchell

// Enemy vliegtuig class
class Enemy {
  float x, 
    y, 
    vx, 
    w, 
    h, 
    x2, 
    y2;

  int r, 
    g, 
    b;

  boolean timerRunning = false;
  boolean hitDetected;
  PImage plane;

  Enemy(float enemyHeight, float enemyWidth, float xVelocity, PImage pImg) {
    h = enemyHeight;
    w = enemyWidth;
    x = random(width, width + 100); 
    y = random(0, height/3 - h);
    x2 = x + enemyWidth;
    y2 = y + enemyHeight;
    vx = xVelocity;

    r = (int)random(0, 256);
    g = (int)random(0, 256);
    b = (int)random(0, 256);

    startTimer();
    plane = pImg;
  }

  public void startTimer() {
    timer.start();
    timerRunning = true;
  }

  public void stopTimer() {
    timer.stop();
    enemiesCount++;
    timerRunning = false;
  }

  public void update() {    
    if (x + w > 0) {
      x -= vx;
    } else {
      x = random(width, width + 100); 
      y = random(0, height/3 + height/3 - h);
      hitDetected = false;
    }


    if (hitDetection(player, this)) {
      println("You hit a flying enemy!!");
      if (!devMode)
        dead.status = true;
      else {
        hitDetected = true;
      }
    }

    //if (hitDetection(x, y, player.x, player.y, x + w, y + h, player.x + player.radius*2, player.y + player.radius*2 )) {
    //  println("You hit a flying enemy!!");
    //  if (!devMode)
    //    dead.status = false;
    //  else {
    //    hitDetected = true;
    //  }
    //} 

    if (devMode) {
      fill(0, 0);
      stroke(255, 0, 0);
      rect(x, y, w, h);
      noStroke();
    }
  }


  public boolean hitDetection(Player p, Enemy e) {
    // Als y2Onder groter is dan y1onder en y2Onder kleiner is dan y1Boven licht de het linker onder hoek er tussen
    // Als y2Boven groter is dan y1Boven en kleinder is dan y1Onder licht de linker onder hoek in er tussen
    boolean x = ((p.x > e.x && p.x < e.x + e.w) ||(p.x + p.w > e.x && p.x + p.w < e.x + e.w));
    boolean y = ((p.y > e.y && p.y < e.y + e.h) || (p.y + p.h > e.y && p.y + p.h < e.y + e.h));
    return (x && y);
  }

  public void draw() {
    if (hitDetected)
      fill(0xff25A599);
    else
      fill(255);

    image(plane, x, y, w, h);
  }
}

public void enemyReset() {
  enemies.clear();
  enemiesCount = 1;
}

public void enemyUpdate() {
  if (player.vx != 0) {
    if (timer.second() >= spawn) {
      timer.stop();
      enemiesCount++;
      enemies.add(new Enemy(planeHeight, planeWidth, random(5, 15), plane));
      spawn = random(5, 8);
      timer = new StopWatchTimer();
      timer.start();
    }

    for (int iEnemy = 0; iEnemy <  enemiesCount; iEnemy++) {
      Enemy en = enemies.get(iEnemy);
      en.update(); 
      en.draw();
    }
  }
}

ArrayList<Enemy> enemies = new ArrayList<Enemy>();
// Alexander

class Player {
  float x, y;
  float vx, vy, gravity;
  float w, h;
  int clr;
  float bounceFriction, airFriction, flappingPower, bounceFrictionModifier, airFrictionModifier;
  boolean hitGround, launched;

  Player() {
    x = width/4;
    y = height/2;
    vx = 0;
    vy = 0;
    gravity = 1.2f;
    w = 140;
    h = 80;
    clr = color(255, 0, 0);
    bounceFriction = 0.8f;
    airFriction = 0.01f;
    flappingPower = 2.5f;
    bounceFrictionModifier = 2;
    airFrictionModifier = 0.05f;
    hitGround = false;
    launched = false;
    x -= w;
    y -= h;
  }

  public void update() {
    // Velocity
    y += vy;


    // Fligth enabler
    if (y >= height / 4 * 3) {
      hitGround = true;
    } else {
      hitGround = false;
    }

    // "Stop sinking please" function
    if (y + h > height) {
      jump.rewind();
      jump.play();
      y = height - h;
    }

    // Gravity & Air Friction funtion
    if (y + h <= height && launched) { 
      vy += 0.5f * gravity;
      vx += airFriction * airFrictionModifier;
    }

    if (vy > 0 && vx < 0) { // When losing altitude
      vx -= (0.6f * airFrictionModifier);
    }

    if (vy < 0 && vx < 0) { // When gaining altitude
      vx += airFrictionModifier;
    }

    // Bouncing function
    // Floor
    if (vx < 0) {
      if (y >= height - h) {
        vy -= bounceFriction;
        vy *= -1;
        vx += (bounceFriction * bounceFrictionModifier);
      }
    } else {
      vx = 0; 
      coin.vx = 0;
    }

    // Ceiling
    if (y <= 0) {
      y = 0;
      vy = 0.5f;
    }

    // "Flapping" function
    if (keysPressed[32] && stamina.staminaLevel > 0 && !hitGround && vx < 0 || keysPressed[ENTER] && stamina.staminaLevel > 0 && !hitGround && vx < 0) {
      vy -= flappingPower;
    }

    //vx == 0 functie [DEATHSCREEN]
    if (vx == 0 && launched == true) {
      stamina.staminaLevel = 0;
      if (y == height - h) {
        dead.status = true;
      }
    }
  }

  public void draw() {
    fill(clr);
    characters[selectedCharacter].display(x, y, w, h);
    if (devMode) {
      fill(0, 0);
      stroke(255, 0, 0);
      rect(x, y, w, h);
    }
  }
}
// Alexander

class PlayerLauncher {
  float x, y, w, h, vx, rotation, launchSpeed, speedVariable;
  int gameState;
  PImage canon;

  PlayerLauncher (PImage ca) {
    x = -100;
    w = 300;
    h = 200;
    y = -950;
    vx = 0;
    rotation = PI/2.5f;
    launchSpeed = -20; // Negative to go 'forward'. Positive numbers will not work propperly.
    speedVariable = 2;
    gameState = 0;
    canon = ca;
  }

  public void launcherAparatus() {
    fill (0);
    stroke(255);
    rotate(PI/rotation);
    image(canon, x, y, w, h);
    noStroke();
  }

  public void update() {
    if (keysPressed[32] && !player.launched && !enterPressed) {
      player.vx = launchSpeed * speedVariable; // Player speed assign!
      coin.vx = player.vx;
      player.launched = true;
      explosion.rewind();
      explosion.play();
      for (Enemy en : enemies)
        en.vx = player.vx;
    }
  }

  public void draw() {
    update();
    playerLauncher.launcherAparatus();
    if (player.launched) {
      rotate(PI/-rotation);
      x += player.vx * -1;
      y += player.vx * -1;
    }
  }
}

public void playerLauncherUpdate() {
  playerLauncher.update();
  playerLauncher.draw();
}
//Alexander (eigenlijk alleen maar Luca)

ArrayList<PowerUps> savedPowerUps = new ArrayList<PowerUps>();

class PowerUps {
  PVector location, velocity, size;
  PImage powerSprite;
  boolean inUse = false;

  PowerUps(float x, float y, float w, float h, float vx, float vy, PImage sprite) {  
    location = new PVector(x, y);
    size = new PVector(w, h);
    velocity = new PVector(vx, vy);
    powerSprite = sprite;
  }

  public void update() {
    if (hitDetected(player, this))
      savedPowerUps.add(this);
    else
      location.add(velocity);
  }

  public boolean hitDetected(Player pl, PowerUps power) {
    boolean x = ((pl.x > power.location.x && pl.x < power.location.x + power.size.x)&&(pl.x + pl.w > power.location.x && pl.x + pl.w< power.location.x + power.size.x));
    boolean y = ((pl.y > power.location.y && pl.y < power.location.y + power.size.y)&&(pl.y + pl.w > power.location.y && pl.y + pl.w< power.location.y + power.size.y));
    return(x && y);
  }

  public void use() {
    //Nothing
  }

  public void draw() {
    image(powerSprite, location.x, location.y, size.x, size.y);
  }
}

class Speed extends PowerUps {
  String naam = "Speed"; 

  Speed(float x, float y, float w, float h, float vx, float vy, PImage sprite) {
    super(x, y, w, h, vx, vy, sprite);
  }

  public void use() {
    //Turbo
  }
}

class Snail extends PowerUps {
  String naam = "Snail" ; 

  Snail(float x, float y, float w, float h, float vx, float vy, PImage sprite) {
    super(x, y, w, h, vx, vy, sprite);
  }

  public void use() {
    //Turtle
  }
}

public void updatePower() {
  PowerUps power = savedPowerUps.get(0);
  if (keysPressed[ENTER] || power.inUse) {
    power.use();
  }
}
class Score {
  float score;
  float w;
  boolean scoreUpdated = false;

  Score(float scoreW){
     w = scoreW; 
  }

  public void update() {

    if (dead.status && !scoreUpdated) {
      score += (collectedCoins *10);
      scoreUpdated = true;
    }

    if (!dead.status && player.vy != 0) {
      score ++;
    }
  }

  public void draw () {
    update();
    fill(0, 0, 0, 120);
    rect(0, 0, w, 70);
    fill(255);
    textAlign(LEFT, TOP);
    textSize(20);
    text("Score: "+(int)score, 10, 10);
    text("Coins: "+(int)collectedCoins, 8, 40);
  }
}

public void setupScore() {
  score = new Score(scoreWidth);
}



// A reference to the processing sound engine
Minim minim = new Minim(this);

// SampleBank loads all samples in the data directory of your project
// so they can be triggered at any time in your game
class soundBank {

  HashMap<String, AudioSample> samples;
  AudioPlayer musicPlayer;

  // Constructor
  soundBank() {
    samples = new HashMap<String, AudioSample>();
    loadAllSamples();
  }

  // load the background music
  public void loadMusic(String musicFileName) {
    musicPlayer = minim.loadFile(musicFileName);
  }

  // play the background music
  public void playMusic() {
    musicPlayer.play();
  }

  // Add a new sample to the sound bank
  public void add(String sampleFileName) {
    AudioSample sample = minim.loadSample(sampleFileName);
    samples.put(sampleFileName, sample);    
    println(sampleFileName);
  }

  // trigger a loaded sample by fileName
  public void trigger(String sampleFileName) {
//    if (!sampleFileName.endsWith(".wav") &&  samples.containsKey(sampleFileName + ".wav"))
//      sampleFileName += ".wav";
    if (samples.containsKey(sampleFileName)) 
      samples.get(sampleFileName).trigger();
  }

  // trigger a loaded sample by index
  public void trigger(int sampleIndex) {
    Object [] keys = samples.keySet().toArray();
    if ((sampleIndex >= 0) && (sampleIndex < keys.length))
      trigger((String) keys[sampleIndex]);
  }

  // load all .wav files in the processing data directory
  public void loadAllSamples() {
    File dataFolder = new File(dataPath(""));
    File [] files = dataFolder.listFiles();

    for (File file : files)
      if (file.getName().toLowerCase().endsWith(".wav"))
        add(file.getName());
  }
}
  public void settings() {  size(1920, 1080, P3D);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "FowlyFlight_ConceptV1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
