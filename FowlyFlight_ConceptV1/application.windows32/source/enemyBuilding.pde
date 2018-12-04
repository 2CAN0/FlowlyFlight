class EnemyBuilding {
  float x, 
    y, 
    h, 
    w, 
    vx;
    PImage img;

  EnemyBuilding(PImage[] imgList) {
    h = random(50, height/3);
    w = random(200, 300);
    x = random(width, width + 300);
    y = height - h;
    vx = random(-15, -5);
    img = imgList[(int)Math.floor(random(0, imgList.length))];
  }

  void Move() {
    if (x + w > 0) {
      x += vx;
    } else {
      h = random(75, height/5*2);
      w = random(200, 300);
      x = random(width, width + 300);
      y = height - h;
      vx = random(-15, -5);
    }
  }

  boolean hitDetected(Player p, EnemyBuilding e) {
  // Als y2Onder groter is dan y1onder en y2Onder kleiner is dan y1Boven licht de het linker onder hoek er tussen
  // Als y2Boven groter is dan y1Boven en kleinder is dan y1Onder licht de linker onder hoek in er tussen
  boolean x = ((p.x > e.x && p.x < e.x + e.w) ||(p.x + p.w > e.x && p.x + p.w < e.x + e.w));
    boolean y = ((p.y > e.y && p.y < e.y + e.h) || (p.y + p.h > e.y && p.y + p.h < e.y + e.h));
    return (x && y);
}

  void update() {
    if (hitDetected(player, this)) {
      println("You hit a flying enemy!!");
      if (!devMode)
        dead.status = true;
      else {
        //
      }
    } else {
      Move();
    }

    //if (hitDetection(x - player.radius, y - player.radius, x + player.radius, y + player.radius, player.x - player.radius, player.y - player.radius, player.x + player.radius, player.y + player.radius)) {
    //  println("You hit a building. What were you thinking!!");
    //  dead.status = true;
    //} else {
    //  Move();
    //}
  }

  void draw() {
    fill(255, 200);
    image(img,x, y, w, h);
    if (devMode) {
      fill(0, 0);
      stroke(255, 0, 0);
      rect(x, y, w, h);
      noStroke();
    }
  }
}

ArrayList<EnemyBuilding> Buildings = new ArrayList<EnemyBuilding>();

void drawBuilding() {
  if (player.vx != 0) {
    for (int iBuilding = 0; iBuilding < Buildings.size(); iBuilding++) {
      EnemyBuilding building = Buildings.get(iBuilding);
      building.update();
      building.draw();
    }
  }
}

void setupBuilding() {
  for (int iBuilding = 0; iBuilding < MAX_BUILDINGS; iBuilding++) {
    EnemyBuilding building = new EnemyBuilding(buildingImages);
    building.draw();
    Buildings.add(building);
  }
}
