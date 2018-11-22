// Alex

class Stamina {
  float staminaBarX, staminaBarY, staminaLevel, staminaMax, staminaDrain, staminaRegen, staminaHeight, staminaBarClr, staminaWidth;
  float w;

  Stamina() {
    staminaBarX = 180;
    staminaBarY = 0;
    staminaLevel = 1420.0;
    w = staminaLevel;
    staminaMax = 1420.0;
    staminaWidth = staminaLevel;
    staminaDrain = 6;
    staminaRegen = 2;
    staminaHeight = 30;
    staminaBarClr = color(0, 255, 0);
  }

  void update() {
    staminaLevel = ( staminaMax * (player.vx/totalPlayerVx));
    println((int)staminaLevel);
    staminaWidth = staminaLevel;

    //else {
    //  while (staminaLevel <= staminaMax) {                // TODO regen functie laten werken
    //    staminaLevel += staminaRegen;
    //  }
    //}
  }

  void draw() {
    stroke(255);
    fill(0, 0);
    rect(staminaBarX, staminaBarY, w, staminaHeight);
    noStroke();
    fill(0,255,0);
    rect(staminaBarX, staminaBarY, staminaWidth, staminaHeight);
  }
}

void setupStamina() {
  stamina = new Stamina();
}
