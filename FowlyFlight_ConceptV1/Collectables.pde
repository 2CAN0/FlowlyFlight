//Luca Ruiters - 500796991

PImage coinImg;
boolean hitShit = false;
float prevX;
float prevY;

class Collectables {
  float x, 
    y, 
    vx, 
    radius, 
    angle;
  int pickupTimer;


  Collectables(float velocityX, PImage co) {
    y = random(0, height/3*2 - radius);
    x = random(width, width + 100);
    vx = velocityX;
    radius = 50;
    timerStart();
    coinImg = co;
    angle = 0;
    pickupTimer = 60;
  }

  void update() {
    x += vx;
    angle += 0.09;
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
      prevX = x;
      prevY = y;
      coin_pickup.rewind();
      coin_pickup.play();
      vx   = -10;
      x = 0 - radius;
      println("Coins: "+(int)collectedCoins);

      //Pickup feedback

      textAlign(CENTER, CENTER);
      textSize(15);
      fill(255);
      hitShit = true;
    } else {
      fill(#FFF158);
      image(coinImg, x-radius, y - radius, radius*2, radius*2);
      //println("X: "+x+ " Y:"+ y+" xVelocity: "+vx +" TimeElapsed: "+timer2.second());
    }
    
    if (hitShit && pickupTimer > 0) { 
      stroke(0);
        text("+ 10", prevX, prevY);
        noStroke();
        pickupTimer -= 1;
        println("snikkel");
      } else {
        pickupTimer = 60;
        hitShit = false;
      }
  }

  boolean hitDetected(Player pl, Collectables coin) {
    float closeX = coin.x;
    float closeY = coin.y;

    if (coin.x < pl.x) closeX = pl.x;

    if (coin.x > pl.x) closeX = pl.x + pl.w;

    if (coin.y < pl.y) closeY = pl.y;

    if (coin.y > pl.y) closeY = pl.y + pl.h;

    float dX = closeX - coin.x;
    float dY = closeY - coin.y;

    float distance = sqrt((dX*dX)+(dY*dY));

    return (distance < coin.radius);
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
