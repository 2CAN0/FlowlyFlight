class ParticleSystem {

  ArrayList<Particle> particles;    // An arraylist for all the particles
  PVector origin, velocity, size;
  float wind, gravity, lifespan;// An origin point for where particles are birthed
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
        particles.add(new Particle(origin, lifespan, wind, gravity, new PVector(random(-1, 1), random(-1, 1)), size));    // Add "num" amount of particles to the arraylist
    }
  }

  ParticleSystem(int num, PVector l, PVector v, PVector s, float w, float g, float ls, String typo, PImage feat) {
    particles = new ArrayList<Particle>();   // Initialize the arraylist
    origin = l.copy();                        // Store the origin point
    size = s.copy();
    wind = w;
    gravity = g;
    lifespan = ls;
    type = typo;
    for (int i = 0; i < num; i++) {
      if (type.toLowerCase() == "feather")
        particles.add(new FeatherParticle(origin, lifespan, wind, gravity, new PVector(random(-1, 1), random(-1, 1)), size, feat));    // Add "num" amount of particles to the arraylist
    }
  }
  
  ParticleSystem(int num, PVector l, PVector v, PVector s, float w, float g, float ls, String typo, float angle) {
    particles = new ArrayList<Particle>();   // Initialize the arraylist
    origin = new PVector(random(0,width + height), l.y);                        // Store the origin point
    velocity = v.copy();
    size = s.copy();
    wind = w;
    gravity = g;
    lifespan = ls;
    type = typo;
    for (int i = 0; i < num; i++) {
      if (type.toLowerCase() == "feather")
        particles.add(new RainParticle(origin, lifespan, wind, gravity, velocity, size, angle));    // Add "num" amount of particles to the arraylist
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

  void addParticle() {
    Particle p;
    // Add either a Particle or CrazyParticle to the system
    p = new Particle(origin, lifespan, wind, gravity, velocity, size);
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
    println("D: "+(v.y/v.x));
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

void rainChange(){
  if(random(0,2) == 1)
     systems.add(new ParticleSystem(MAX_RAINPARTS, new PVector(width/2, -rainSize.y), rainVelo, rainSize, rainWind, rainGravity, rainSpan, "Rain", 0)); 
  else
    systems.clear();
}

class RainParticle extends Particle {
  float angle;

  RainParticle(PVector l, float span, float wind, float gravity, PVector v, PVector s, float a) {
    super(l, span, wind, gravity, v, s);
    position.x = random(0, width + height);
    angle = a;
    velocity.x *= player.vx/10;
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    angle += 0.05;
  }

  void display() {
    println("It's raining");
    pushMatrix(); 
    translate(position.x, position.y);
    rotate(angle);
    stroke(62, 203, 245, lifespan);
    line(0, 0, 25, 0);
    noStroke();
    popMatrix();
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
    velocity = v.copy();
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
