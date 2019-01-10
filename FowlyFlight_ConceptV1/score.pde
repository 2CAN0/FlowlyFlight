class Score {
  int score;
  float w;
  boolean scoreUpdated = false;

  Score(float scoreW) {
    w = scoreW;
  }

  void update() {

    if (dead.status && !scoreUpdated) {
      score += (collectedCoins *10);
      scoreUpdated = true;
    }

    if (!dead.status && player.vy != 0) {
      score ++;
    }
  }

  void draw () {
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

void setupScore() {
  score = new Score(scoreWidth);
}
