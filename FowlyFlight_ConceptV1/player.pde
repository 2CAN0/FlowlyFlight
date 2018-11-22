// Alexander

class Player {
  float x, y;
  float vx, vy, gravity;
  float w, h;
  int clr;
  float bounceFriction, airFriction, flappingPower, bounceFrictionModifier, airFrictionModifier;
  boolean hitGround, launched;

  Player() {
    x = width/4;
    y = height/2;
    vx = 0;
    vy = 0;
    gravity = 1.2;
    w = 140;
    h = 80;
    clr = color(255, 0, 0);
    bounceFriction = 1.5;
    airFriction = 0.01;
    flappingPower = 2.5;
    bounceFrictionModifier = 2;
    airFrictionModifier = 0.1;
    hitGround = false;
    launched = false;
    x -= w;
    y -= h;
  }

  void update() {
    // Velocity
    y += vy;


    // Fligth enabler
    if (y >= height / 4 * 3) {
      hitGround = true;
    } else {
      hitGround = false;
    }

    // "Stop sinking please" function
    if (y + h > height) {
      y = height - h;
    }

    // Gravity & Air Friction funtion
    if (y + h <= height && launched) { 
      vy += 0.5 * gravity;
      vx += airFriction * airFrictionModifier;
    }
    
    if (vy > 0 && vx < 0){ // When losing altitude
      vx -= (0.6 * airFrictionModifier);
    }
    
    if (vy < 0 && vx < 0){ // When gaining altitude
      vx += airFrictionModifier;
    }

    // Bouncing function
    // Floor
    if (vx < 0) {
      if (y >= height - h) {
        vy -= bounceFriction;
        vy *= -1;
        vx += (bounceFriction * bounceFrictionModifier);
      }
    } else {
     vx = 0; 
     coin.vx = 0;
    }

    // Ceiling
    if (y <= 0) {
      y = 0;
      vy = 0.5;
    }

    // "Flapping" function
    if (keysPressed[32] && y >= stamina.staminaHeight && !hitGround && vx < 0) {
      vy -= flappingPower;
    }
    
    //vx == 0 functie [DEATHSCREEN]
    if (vx == 0 && launched == true){
        dead.status = true;
    }
  }

  void draw() {
    fill(clr);
    blueBird.display(x, y, w, h);
    if (devMode){
     fill(0,0);
     stroke(255,0,0);
     rect(x,y,w, h);
    }
  }
}
