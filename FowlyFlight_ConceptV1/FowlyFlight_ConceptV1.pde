// The Fowly Flight
// IG102-2
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim Sound;
AudioPlayer menutheme;
AudioPlayer jump;
AudioPlayer bounce;
AudioPlayer hit;
AudioPlayer coin_pickup;
AudioPlayer gameOver;
AudioPlayer explosion;


void setup() {
  Sound = new Minim(this);
  menutheme = Sound.loadFile("ShootingStars.mp3");
  jump = Sound.loadFile("jump.wav");
  bounce = Sound.loadFile("mJump.wav");
  hit = Sound.loadFile("Hit_Hurt.wav");
  coin_pickup = Sound.loadFile("Pickup_Coin.wav");
  gameOver = Sound.loadFile("gameOver.mp3");
  explosion = Sound.loadFile("Explosion.wav");
  menutheme.play();
  size(1600, 900, P3D);
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
      if(player.launched)
        player.draw();
      collectableUpdate();
      score.update();      
      score.draw();
      stamina.update();
      stamina.draw();
    } else {
      dead.update();
      dead.draw(); 
      hs.draw();
    }
  } else if (inShop) {
    menuShop.update();          //TODO NullPointerException!
    menuShop.draw();
  }

  if (devMode) {
    textAlign(RIGHT, TOP);
    textSize(20);
    if(frameRate < 55){
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
  } else if (inShop){
     menuShop.changedSelected = false; 
  }
}
