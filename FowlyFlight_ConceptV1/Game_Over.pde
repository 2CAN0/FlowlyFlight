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

void restart() {
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
  coin = new Collectables(player.vx, coinImg);
  collectedCoins = 0;
  setupScore();
  setupStamina();
}
