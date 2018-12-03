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
    triangle (height / 2, width / 4, (height / 2) + 40, (width / 4) + 20, (height / 2) - 40, (width / 4) - 20);
    triangle (height / 2, width / 4 * 3, (height / 2) + 40, (width / 4) + 20, (height / 2) - 40, (width / 4) - 20);
    noFill();
    noStroke();
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
