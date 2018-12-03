// Alexander & Nino & Luca

class ShopMenu {
  PImage fWall;
  boolean changedSelected = false;
  Animation[] characters;

  ShopMenu (ArrayList<PImage> wall, Animation[] skins) {
    fWall = wall.get((int)random(0, wall.size()));
    characters = skins;
  }

  void buttons() {
    fill(255);
    stroke(0);
    strokeWeight(1);
    triangle (608, 561, 654, 519, 654 ,603);                // TODO - geen magic numbers!
    triangle (1312, 561, 1266, 519, 1266 ,603);             // TODO - geen magic numbers!
    noStroke();
    
    fill(0, 120);
    rect(width / 4, height / 4 * 3, width / 2, 50);         // TODO - geen magic numbers!
    textAlign(CENTER, CENTER);
    textSize(30);
    fill(255);
    text("Press ENTER to purchase or select", width / 2, height / 4 * 3 + 25);    // TODO - geen magic numbers!
  }

  void update() {
    if (keysPressed[ENTER] && !enterPressed) {
      inShop = false;
      inMenu = true;
      enterPressed = true;
    }

    if (keysPressed[RIGHT] && !changedSelected && selectedCharacter < characters.length - 1) {
      selectedCharacter++;
      changedSelected = true;
    } else if (keysPressed[LEFT] && !changedSelected && selectedCharacter > 0) {
      selectedCharacter--;
      changedSelected = true;
    }
  }

  void draw() {
    image(fWall, 0, 0, width, height);
    float grow = 2;
    characters[selectedCharacter].display(width/2 - player.w/2*grow, height/2 - player.h/2*grow, player.w*grow, player.h*grow);  
    buttons();
  }
}
