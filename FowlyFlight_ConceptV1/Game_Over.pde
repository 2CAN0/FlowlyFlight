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

  void draw() {
    noStroke();
    image(wallpaper, 0, 0, width, height );
  }

  void update() {
    if (status) 
      if (!hsUpdated) {
        gameOver.rewind();
        gameOver.play();
        theme.pause();
        hs.update(score.score, playerName);
        hsUpdated = true;
      }
  }
}   

void drawGameOver() {
  fill(255);
}

void restart() {
  enemyReset();
  hsUpdated = false;
  enemies.add(new Enemy(30, 30, player.vx, plane));
  Buildings.clear();
  setupBuilding();
  player = new Player();
  movingWalls.clear();
  setupWall(); 
  playerLauncher = new PlayerLauncher();
  coin = new Collectables(player.vx);
  collectedCoins = 0;
  setupScore();
  setupStamina();
}
