// Alex

class Stamina {
  float staminaBarX, staminaBarY, staminaLevel, staminaMax, staminaHeight, staminaBarClr, staminaWidth;
  int staminaDrain, staminaRegen;

  Stamina() {
    staminaBarX = 180;
    staminaBarY = 0;
    staminaLevel = 1420.0;
    staminaMax = 1420.0;
    staminaWidth = staminaLevel;
    staminaHeight = 30;
    staminaBarClr = color(0, 255, 0);
    staminaDrain = 6;
    staminaRegen = 2;
  }

  void update() {
    if (keysPressed[32] && player.launched == true && staminaLevel > 0) {
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
    noStroke();
    fill(0, 255, 0);
    rect(staminaBarX, staminaBarY, staminaLevel, staminaHeight);
  }
}

void setupStamina() {
  stamina = new Stamina();
}
