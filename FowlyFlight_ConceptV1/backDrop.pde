class Background {
  PImage[] maps;
  PVector[] position;
  int selectedMap = 0;
  int selectedMapImg = 0;
  int wallWidth;

  Background(PImage[] tempMaps, int imgCount) {
    wallWidth = width + 10;     

    if (imgCount == 1) {
      maps = new PImage[3];
      maps[0] = (tempMaps[0]);
      maps[1] = (tempMaps[0]);
      maps[2] = (tempMaps[0]);
      imgCount = 3;
    } else {
      maps = tempMaps;
    }

    position = new PVector[imgCount];
    for (int iPos = 0; iPos < position.length; iPos++) {
        position[iPos] = new PVector(iPos * wallWidth, 0);
    }
  }

  void update(Player pl) {
    for (int iWall = 0; iWall < position.length; iWall++) {
      if (position[iWall].x + wallWidth < 0) {
        int prevPos = (iWall > 0)?iWall - 1: position.length - 1;
        position[iWall].x = position[prevPos].x + wallWidth;
      }

      position[iWall].x += pl.vx/3;
      println("Updating wall #"+iWall);
    }
  }

  void draw() {
    for (int iWall = 0; iWall < position.length; iWall++) {
      noStroke();
      image(maps[iWall], position[iWall].x, position[iWall].y, wallWidth, height);
    }
  }
}

void drawWall() {
  bg.update(player);
  bg.draw();
}
