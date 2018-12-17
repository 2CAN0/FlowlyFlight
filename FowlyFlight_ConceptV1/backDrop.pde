class Background {
  float x1, 
    y1, 
    x2, 
    y2, 
    vx, 
    w, 
    h, 
    r1, r2, 
    g1, g2, 
    b1, b2;

  PImage wall;

  Background(float playerVX, float layerHeight, float r, float g, float b, PImage wa) {
    w = width + 200;
    h = layerHeight;
    y1 = height - h;
    y2 = height - h;
    x1 = 0;
    x2 = x1 + w;
    vx = playerVX/2;
    wall = wa;

    r1 = r;
    if (r *2 < 256) {
      r2  = r *2;
    } else {
      r2 = r - 100;
    }

    g1 = g;
    if (g * 2 < 256) {
      g2 = g * 2;
    } else {
      g2 = g - 100;
    }

    b1 = b;
    if (b * 2 < 256) {
      b2 = b * 2;
    } else {
      b2 = b - 100;
    }
  }

  void update() {
    vx = player.vx/1.5;
    if (x1 < x2) {
      if (x2 > 0) {
        x1 += vx;
        x2 += vx;
      } else {
        x1 = x2 + w;
      }
    } else {
      if (x1 > 0) {
        x2 += vx;
        x1 += vx;
      } else {
        x2 = x1 + w;
      }
    }

    //println("#1 X: "+x1+"  Y: "+y1);
    //println("#2 X: "+x2+"  Y: "+y2);
  }

  void draw() {
    noStroke();
    fill(r1, g1, b1);
    image(wall, x1, y1, w, h);
    fill(r2, g2, b2);
    image(wall, x2, y2, w, h);
    if (!player.launched && playGame)
      drawTutorial();
  }
}

void setupWall() {             
  movingWalls.add(new Background(player.vx, height, 0, 0, random(128, 256), wallpaper));
  //movingWalls.add(new Background(player.vx, height/3, 0, random(128,256),0, wallpaper));
}

void drawWall() {
  for (int iWall = 0; iWall < movingWalls.size(); iWall++) {
    Background bg = movingWalls.get(iWall);
    bg.update();
    bg.draw();
  }
}
ArrayList<Background> movingWalls = new ArrayList<Background>();
