// Alexander & Nino & Luca

class ShopMenu {
  PImage fWall;
  boolean changedSelected = false;
  Animation[] characters;

  int arrowLeftPosX, arrowLeftPosY, arrowRightPosX, arrowRightPosY, arrowWidth, arrowHeight;

  ShopMenu (ArrayList<PImage> wall, Animation[] skins) {
    fWall = wall.get((int)random(0, wall.size()));
    characters = skins;

    // Arrows
    arrowLeftPosX = 608;
    arrowLeftPosY = 561;
    arrowRightPosX = 1312;
    arrowRightPosY = 561;
    arrowWidth = 46;
    arrowHeight = 48;
  }

  void buttons() {
    fill(255);
    triangle (arrowLeftPosX, arrowLeftPosY, arrowLeftPosX + arrowWidth, arrowLeftPosY - arrowHeight, arrowLeftPosX + arrowWidth, arrowLeftPosY + arrowHeight);                // TODO - geen magic numbers!
    triangle (arrowRightPosX, arrowRightPosY, arrowRightPosX - arrowWidth, arrowRightPosY - arrowHeight, arrowRightPosX - arrowWidth, arrowRightPosY + arrowHeight);             // TODO - geen magic numbers!

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
