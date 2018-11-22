class Score {
  float score;
  boolean scoreUpdated = false;

  void update() {

    if (dead.status && !scoreUpdated) {
      score += (collectedCoins *10);
      scoreUpdated = true;
    }

    if (!dead.status) {
      score ++;
    }
  }

  void draw () {
    update();
    fill(0, 0, 0, 120);
    rect(0, 0, 180, 70);
    fill(255);
    textAlign(LEFT, TOP);
    textSize(20);
    text("Score: "+(int)score, 10, 10);
    text("Coins: "+(int)collectedCoins, 8, 40);
  }
}

void setupScore() {
  score = new Score();
}
