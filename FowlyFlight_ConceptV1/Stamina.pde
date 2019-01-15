// Alex

class Stamina {
  float staminaBarX, staminaBarY, staminaLevel, staminaMax, staminaHeight, staminaBarClr, staminaWidth;
  int staminaDrain, staminaRegen;

  Stamina(Score sc) {
    staminaBarX = sc.w;
    staminaBarY = 0;
    staminaMax = width - sc.w;
    staminaWidth = staminaLevel;
    staminaHeight = 30;
    staminaBarClr = color(0, 255, 0);
    staminaDrain = 5;
    staminaRegen = 1;
    staminaLevel = staminaMax;
  }

  void update() {
    if (keysPressed[32] && player.launched == true && staminaLevel > 0 || keysPressed[ENTER] && player.launched == true && staminaLevel > 0) {
      staminaLevel -= staminaDrain;
    } else {
      if (staminaLevel < staminaMax) {
        staminaLevel += staminaRegen;
      }
    }
  }

  void draw() {
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

void setupStamina() {
  stamina = new Stamina(score);
}
