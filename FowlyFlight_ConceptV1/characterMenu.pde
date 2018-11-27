// Alexander & Nino & Luca
  
class ShopMenu {
  PImage fWall;
  boolean changedSelected = false;
  Animation[] characters;
  
  ShopMenu (ArrayList<PImage> wall, Animation[] skins) {
    fWall = wall.get((int)random(0, wall.size()));
    characters = skins;
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
    } else if (keysPressed[LEFT] && !changedSelected && selectedCharacter > 0){
       selectedCharacter--;
       changedSelected = true;
    }
  }

  void draw() {
    image(fWall, 0,0, width, height);
    characters[selectedCharacter].display(width/2, height/2, player.w, player.h);      
  }
}
