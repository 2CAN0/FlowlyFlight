class ParticleSystem {

  ArrayList<Particle> particles;    // An arraylist for all the particles
  PVector origin, velocity, size;
  float wind, gravity, lifespan;// An origin point for where particles are birthed
  float factor;
  String type;

  ParticleSystem(int num, PVector l, PVector v, PVector s, float w, float g, float ls, String typo) {
    particles = new ArrayList<Particle>();   // Initialize the arraylist
    origin = l.copy();                        // Store the origin point
    size = s.copy();
    wind = w;
    gravity = g;
    lifespan = ls;
    type = typo;
    for (int i = 0; i < num; i++) {
      if (type.toLowerCase() == "simple")
        particles.add(new Particle(origin, lifespan, wind, gravity, new PVector(random(-1, 1), random(-1, 1)), size));    // location, lifespan, wind, gravity, velocity, size
    }
  }

  //Constructer for the Feather PS
  ParticleSystem(int num, PVector l, PVector v, PVector s, float w, float g, float ls, String typo, PImage feat) {
    particles = new ArrayList<Particle>();   // Initialize the arraylist
    origin = l.copy();                        // Store the origin point
    size = s.copy();
    wind = w;
    gravity = g;
    lifespan = ls;
    type = typo;
    for (int i = 0; i < num; i++) {
      particles.add(new FeatherParticle(origin, lifespan, wind, gravity, new PVector(random(-1, 1), random(-1, 1)), size, feat));    // location, lifespan, wind, gravity, velocity, size, image
    }
  }


  //Constructer for the rain PS
  ParticleSystem(int num, PVector l, PVector v, PVector s, float w, float g, float ls, String typo, float angle) {
    particles = new ArrayList<Particle>();   // Initialize the arraylist
    origin = new PVector(random(0, width + height), l.y);                        // Store the origin point
    velocity = v.copy();
    size = s.copy();
    wind = w;
    gravity = g;
    lifespan = ls;
    type = typo;
    factor = 100f;
    for (int i = 0; i < num; i++) {
      particles.add(new RainParticle(origin, lifespan, random(player.vx)/factor, gravity, velocity, size, angle));    // location, lifespan, wind, gravity, velocity, size
    }
  }

  void run() {
    // Cycle through the ArrayList backwards, because we are deleting while iterating
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }

  void addRainDrop() {
    particles.add(new RainParticle(origin, lifespan, random(player.vx)/factor, gravity, velocity, size, 0));
  }

  void addParticle() {
    Particle p;
    // Add either a Particle or CrazyParticle to the system
    if (extremeWeather) {
      p = new RainParticle(origin, lifespan, wind, gravity, velocity, size, 0);
    } else
      p = new Particle(origin, lifespan, wind, gravity, new PVector(random(-1, 1), random(-1, 1)), size);
    particles.add(p);
  }

  void addParticle(Particle p) {
    particles.add(p);
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    return particles.isEmpty();
  }
}

class FeatherParticle extends Particle {
  PImage feather;
  float angle;

  FeatherParticle(PVector l, float span, float wind, float gravity, PVector v, PVector s, PImage f) {
    super(l, span, wind, gravity, v, s);
    feather = f;
    angle =  atan(v.y/v.x);
  }

  void update() {
    super.update();
    lifespan -= 0.02;
    angle += 0.02;
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y);
    tint(255, lifespan);
    rotate(angle);
    //fill(255, lifespan);
    image(feather, 0, 0, size.x, size.y);
    popMatrix();
  }
}

//Systeem om te kiezen of regent of niet.
void rainChange() {
  int wrmWerktNiet = (int)Math.floor(random(0, 5) % 2);
  if ( wrmWerktNiet == 0) {
    systems.add(new ParticleSystem(MAX_RAINPARTS, new PVector(width/2, -rainSize.y), rainVelo, rainSize, rainWind, rainGravity, rainSpan, "Rain", 0));
    extremeWeather = true;
    println("it should rain now");
  } else {
    systems.clear();
    extremeWeather = false;
    println("The weather forecast is sunny atm");
  }
}

class RainParticle extends Particle {
  float angle;
  RainParticle(PVector l, float span, float wind, float gravity, PVector v, PVector s, float r) {
    super(l, span, wind, gravity, v, s); //l - location; v - velocity; s - size;
    position = new PVector(random(-10, width + height), random(-10, 0));
    lifespan = 600;
    angle = r;
    //velocity.x = -5;
  }

  void update() {
    super.update(); 
    angle += random(0.01);
  }

  void display() {
    if (weatherOn) {
      pushMatrix();
      translate(position.x, position.y);
      stroke(39, 171, 240, lifespan);
      rotate(angle);
      line(0, 0, 25, 0);
      popMatrix();
    }
  }
}

class Particle {
  PVector position, 
    velocity, 
    acceleration, 
    size;
  float lifespan;

  Particle(PVector l, float span, float wind, float gravity, PVector v, PVector s) {
    acceleration = new PVector(wind, gravity);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    position = l.copy();
    lifespan = span;
    size = s.copy();
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 2.0;
  }

  // Method to display
  void display() {
    noStroke();
    fill(255, lifespan);
    ellipse(position.x, position.y, size.x, size.y);
  }

  // Is the particle still useful?
  boolean isDead() {
    return (lifespan < 0.0);
  }
}
