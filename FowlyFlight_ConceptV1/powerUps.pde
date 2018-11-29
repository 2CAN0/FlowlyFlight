//Alexander (eigenlijk alleen maar Luca)

ArrayList<PowerUps> savedPowerUps = new ArrayList<PowerUps>();

class PowerUps {
  PVector location, velocity, size;
  PImage powerSprite;
  boolean inUse = false;

  PowerUps(float x, float y, float w, float h, float vx, float vy, PImage sprite) {  
    location = new PVector(x, y);
    size = new PVector(w, h);
    velocity = new PVector(vx, vy);
    powerSprite = sprite;
  }

  void update() {
    if (hitDetected(player, this))
      savedPowerUps.add(this);
    else
      location.add(velocity);
  }

  boolean hitDetected(Player pl, PowerUps power) {
    boolean x = ((pl.x > power.location.x && pl.x < power.location.x + power.size.x)&&(pl.x + pl.w > power.location.x && pl.x + pl.w< power.location.x + power.size.x));
    boolean y = ((pl.y > power.location.y && pl.y < power.location.y + power.size.y)&&(pl.y + pl.w > power.location.y && pl.y + pl.w< power.location.y + power.size.y));
    return(x && y);
  }

  void use() {
    //Nothing
  }

  void draw() {
    image(powerSprite, location.x, location.y, size.x, size.y);
  }
}

class Speed extends PowerUps {
  String naam = "Speed"; 

  Speed(float x, float y, float w, float h, float vx, float vy, PImage sprite) {
    super(x, y, w, h, vx, vy, sprite);
  }

  void use() {
    //Turbo
  }
}

class Snail extends PowerUps {
  String naam = "Snail" ; 

  Snail(float x, float y, float w, float h, float vx, float vy, PImage sprite) {
    super(x, y, w, h, vx, vy, sprite);
  }

  void use() {
    //Turtle
  }
}

void updatePower() {
  PowerUps power = savedPowerUps.get(0);
  if (keysPressed[ENTER] || power.inUse) {
    power.use();
  }
}
