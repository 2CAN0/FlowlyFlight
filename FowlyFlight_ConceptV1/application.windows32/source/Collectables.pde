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
    if (hitDetected(player, coin)) {
      collectedCoins += 1;
      coin_pickup.rewind();
      coin_pickup.play();
      vx   = -10;
      x = 0 - radius;
      println("Coins: "+(int)collectedCoins);
    } else {
      fill(#FFF158);
      ellipse(x, y, radius*2, radius*2);
      //println("X: "+x+ " Y:"+ y+" xVelocity: "+vx +" TimeElapsed: "+timer2.second());
    }
  }

  boolean hitDetected(Player pl, Collectables coin) {
    boolean x = (pl.x > coin.x - coin.radius && pl.x < coin.x + coin.radius) || (pl.x + pl.w > coin.x - coin.radius && pl.x + pl.w < coin.x + coin.radius);
    boolean y = (pl.y > coin.y - coin.radius && pl.y < coin.y + coin.radius) || (pl.y + pl.h > coin.y - coin.radius && pl.y + pl.h < coin.y + coin.radius);

    return (x && y);
  }
}

void collectableUpdate() {
  if (timer2.second() >= 10) {
    timer2.stop();
    coin.x = width + 100;
    coin.y = random(0, height);
    timer2 = new StopWatchTimer();
    timer2.start();
  }

  coin.update();
  coin.draw();
}
