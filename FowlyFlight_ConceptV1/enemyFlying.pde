//mitchell

// Enemy vliegtuig class
class Enemy {
  float x, 
    y, 
    vx, 
    w, 
    h, 
    x2, 
    y2;

  int r, 
    g, 
    b;

  boolean timerRunning = false;
  boolean hitDetected;
  PImage plane;

  Enemy(float enemyHeight, float enemyWidth, float xVelocity, PImage pImg) {
    h = enemyHeight;
    w = enemyWidth;
    x = random(width, width + 100); 
    y = random(0, height/3 - h);
    x2 = x + enemyWidth;
    y2 = y + enemyHeight;
    vx = xVelocity;

    r = (int)random(0, 256);
    g = (int)random(0, 256);
    b = (int)random(0, 256);

    startTimer();
    plane = pImg;
  }

  void startTimer() {
    timer.start();
    timerRunning = true;
  }

  void stopTimer() {
    timer.stop();
    enemiesCount++;
    timerRunning = false;
  }

  void update() {    
    if (x + w > 0) {
      x -= vx;
    } else {
      x = random(width, width + 100); 
      y = random(0, height/3 + height/3 - h);
      hitDetected = false;
    }


    if (hitDetection(player, this)) {
      println("You hit a flying enemy!!");
      if (!devMode)
        dead.status = true;
      else {
        hitDetected = true;
      }
    }

    //if (hitDetection(x, y, player.x, player.y, x + w, y + h, player.x + player.radius*2, player.y + player.radius*2 )) {
    //  println("You hit a flying enemy!!");
    //  if (!devMode)
    //    dead.status = false;
    //  else {
    //    hitDetected = true;
    //  }
    //} 

    if (devMode) {
      fill(0, 0);
      stroke(255, 0, 0);
      rect(x, y, w, h);
      noStroke();
    }
  }


  boolean hitDetection(Player p, Enemy e) {
    // Als y2Onder groter is dan y1onder en y2Onder kleiner is dan y1Boven licht de het linker onder hoek er tussen
    // Als y2Boven groter is dan y1Boven en kleinder is dan y1Onder licht de linker onder hoek in er tussen
    boolean x = ((p.x > e.x && p.x < e.x + e.w) ||(p.x + p.w > e.x && p.x + p.w < e.x + e.w));
    boolean y = ((p.y > e.y && p.y < e.y + e.h) || (p.y + p.h > e.y && p.y + p.h < e.y + e.h));
    return (x && y);
  }

  void draw() {
    if (hitDetected)
      fill(#25A599);
    else
      fill(255);

    image(plane, x, y, w, h);
  }
}

void enemyReset() {
  enemies.clear();
  enemiesCount = 1;
}

void enemyUpdate() {
  if (player.vx != 0) {
    if (timer.second() >= spawn) {
      timer.stop();
      enemiesCount++;
      enemies.add(new Enemy(planeHeight, planeWidth, random(5, 15), plane));
      spawn = random(5, 8);
      timer = new StopWatchTimer();
      timer.start();
    }

    for (int iEnemy = 0; iEnemy <  enemiesCount; iEnemy++) {
      Enemy en = enemies.get(iEnemy);
      en.update(); 
      en.draw();
    }
  }
}

ArrayList<Enemy> enemies = new ArrayList<Enemy>();
