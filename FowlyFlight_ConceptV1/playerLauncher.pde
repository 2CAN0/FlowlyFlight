// Alexander

class PlayerLauncher {
  float x, y, w, h, vx, rotation, launchSpeed, speedVariable;
  int gameState;

  PlayerLauncher () {
    x = -100;
    w = 300;
    h = 100;
    y = -650;
    vx = 0;
    rotation = PI/2.5;
    launchSpeed = -20; // Negative to go 'forward'. Positive numbers will not work propperly.
    speedVariable = 2;
    gameState = 0;
  }

  void launcherAparatus() {
    fill (0);
    stroke(255);
    rotate(PI/rotation);
    rect(x, y, w, h);
    noStroke();
  }

  void update() {
    if (keysPressed[32] && !player.launched) {
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
      rotate(PI/-rotation);
      x += player.vx * -1;
      y += player.vx * -1;
    }
  }
}

void playerLauncherUpdate() {
  playerLauncher.update();
  playerLauncher.draw();
}
