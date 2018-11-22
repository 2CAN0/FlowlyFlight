// The Fowly Flight
// IG102-2

void setup() {
  size(1600, 900, P3D);
  noStroke();
  noCursor();
  smooth();
  frameRate(60);
  background(30);
  mainSetup();
}

void draw() {
  if (inMenu || !playGame) {
    menu.update();
    menu.draw();
  } else if (playGame) {
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
  if (keyCode >= KEY_LIMIT) return; 
  keysPressed[keyCode] = true;
}

void keyReleased() {
  if (keyCode >= KEY_LIMIT) return;
  keysPressed[keyCode] = false;

  enterPressed = false;
  hs.changedSelected = false;

  if (inMenu) {
    menu.changedSelected = false;
  }
}
