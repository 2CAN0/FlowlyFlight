//Luca Ruiters - 500796991
class Collectables {
  float x, 
    y, 
    vx, 
    radius;

  Collectables(float velocityX) {
    y = random(0, height/3*2 - radius);
    x = random(width, width + 100);
    vx = velocityX;
    radius = 50;
    timerStart();
  }

  void update() {
    x += vx;
  }

  void timerStart() {
    timer2.start();
  }

  void timerStop() {
    timer2.stop();
  }

  void draw() {
    if (hitDetected(x, y, player.x+ player.w, player.y + player.h/2)) {
      collectedCoins += 1;
      vx = -10;
      x = 0 - radius;
      println("Coins: "+(int)collectedCoins);
    } else {
      fill(#FFF158);
      ellipse(x, y, radius*2, radius*2);
      //println("X: "+x+ " Y:"+ y+" xVelocity: "+vx +" TimeElapsed: "+timer2.second());
    }
  }

  boolean hitDetected(float x1, float y1, float x2, float y2) {
    float a = x1  - x2;
    float b = y1- y2;
    float c = sqrt(a*a +b*b);
    float distance = c - radius *2;

    return (distance <= 0);
  }
}

void collectableUpdate() {
  if (timer2.second() >= 10) {
    timer2.stop();
    coin.x = width + 100;
    coin.y = random(0,height);
    timer2 = new StopWatchTimer();
    timer2.start();
  }

  coin.update();
  coin.draw();
}
