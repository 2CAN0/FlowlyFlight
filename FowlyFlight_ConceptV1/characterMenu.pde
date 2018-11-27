// Alexander & Nino

ArrayList<PImage> characterSelector = new ArrayList<PImage>();
  
class ShopMenu {
  PImage fWall;
  PImage[] characters;
  int selectedCharacter = 0;
  
  ShopMenu (ArrayList<PImage> wall, PImage[] skins, int sCH) {
    fWall = wall.get((int)random(0, wall.size()));
    characters = skins;
    selectedCharacter = sCH;
    characters[0] = loadImage("wally_001.img");
    characters[1] = loadImage("owliver_001.img");
  }

  void update() {
    if (keysPressed[32]) {
      inShop = false;
      inMenu = true;
    }
    if (keysPressed[RIGHT]) {
    }
  }

  void draw() {
    image(fWall, 0,0, width, height);
    image(characters[0], height/2, width/2);
    
    
  }
}
