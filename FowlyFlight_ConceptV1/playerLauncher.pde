// Alexander

class PlayerLauncher {
  float x, y, w, h, vx, rotation, launchSpeed, speedVariable, angle;
  int gameState;
  PImage canon;

  PlayerLauncher (PImage ca) {
    x = width/3;
    w = 400;
    h = 400;
    y = height/2;
    vx = 0;
    rotation = (PI/2.5);
    launchSpeed = -20; // Negative to go 'forward'. Positive numbers will not work propperly.
    speedVariable = 2;
    gameState = 0;
    canon = ca;
    angle = 0;
  }

  void launcherAparatus() {
    if(!player.launched)
      angle += 0.02;
    else
      angle = 0;
    pushMatrix();
    fill (0);
    stroke(255);
    y += sin(angle *2) * 1.5;
    x += cos(angle*1.5) * 1;
    translate(x, y);
    rotate(PI/rotation);
    
    image(canon, 0,0 , w, h);
    popMatrix();
    noStroke();
  }

  void update() {
    if (keysPressed[32] && !player.launched && !enterPressed) {
      systems.add(new ParticleSystem(MAX_FEATPARTS, new PVector(x, y - h/2), featVelo, featSize, featWind, featGravity, featSpan, "feather", feather));
      player.vx = launchSpeed * speedVariable; // Player speed assign!
      coin.vx = player.vx;
      player.launched = true;
      explosion.rewind();
      explosion.play();
      for (Enemy en : enemies)
        en.vx = player.vx;
    }
  }

  void draw() {
    update();
    playerLauncher.launcherAparatus();
    if (player.launched) {
      x += player.vx * -1;
      y += player.vx * -1;
    }
  }
}

void playerLauncherUpdate() {
  playerLauncher.update();
  playerLauncher.draw();
}
