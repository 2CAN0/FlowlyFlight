// The Fowly Flight
// IG102-2
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

<<<<<<< HEAD
=======
Minim Sound;
AudioPlayer menutheme;
AudioPlayer jump;
AudioPlayer bounce;
AudioPlayer hit;
AudioPlayer coin_pickup;
AudioPlayer gameOver;
AudioPlayer explosion;
AudioPlayer theme;


>>>>>>> 289441648fc838bbd7e7054ea6de0452798a1c5d
void setup() {
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
  size(1920, 1080, P3D);
  noStroke();
  noCursor();
  smooth();
  frameRate(60);
  background(30);
  mainSetup();
}

void draw() {
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

void keyPressed() {  
  if (keyCode < KEY_LIMIT) 
    keysPressed[keyCode] = true;
}

void keyReleased() {
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
