//Luca Ruiters - 500796991
ArrayList<PImage> wall = new ArrayList<PImage>();

class Menu {
  int AmountButtons;
  int selectedIndex = 0;
  int spacing = 30;

  String[] options;
  ArrayList<Button> buttons = new ArrayList<Button>();
  boolean changedSelected = false;
  String gameName;
  ArrayList<PImage> wallpaper;
  PImage fWall;

  Menu(String[] text, String GN, ArrayList<PImage> img) {
    options = new String[text.length];
    options = text;
    
    gameName = GN;
    
    AmountButtons = options.length;
    float tempW = 250;
    float tempH = 85;
    float tempX = width/2;
    float tempY = height / 2 - tempH *(AmountButtons/2);
    
    wallpaper = img;
    fWall = wallpaper.get((int)random(0,wallpaper.size()));
    
    for (int iButton = 0; iButton < AmountButtons; iButton++) {
      if (iButton == 0){
        buttons.add(new Button(tempX - tempW/2, tempY, tempW, tempH, options[iButton]));
        Button btn = buttons.get(0);
        btn.selected = true;
      } else {
        Button btn = buttons.get(iButton - 1);
        buttons.add(new Button(tempX - tempW/2, btn.location.y + tempH + spacing, tempW, tempH, options[iButton]));
      }
    }
  }

  void update() {
    if (keysPressed[UP] && selectedIndex > 0 && !changedSelected) {
      selectedIndex--;
      Button btn1 = buttons.get(selectedIndex);
      btn1.selected = true;
      Button btn2 = buttons.get(selectedIndex + 1);
      btn2.selected = false;
      changedSelected = true;
    }

    if (keysPressed[DOWN] && selectedIndex < options.length - 1 && !changedSelected) {
      selectedIndex++;
      Button btn1 = buttons.get(selectedIndex);
      btn1.selected = true;
      Button btn2 = buttons.get(selectedIndex - 1);
      btn2.selected = false;
      changedSelected = true;
    }
    
    if (keysPressed[ENTER] && !enterPressed) {
      enterPressed = true;
      Button btn = buttons.get(selectedIndex);
      if (btn.text == options[0]){
         inMenu = false;
         playGame = true;
         if(testing){
            test.startTesting(); 
            test.starts += 1;
         }
      } else if (btn.text == options[1]){
         inMenu = false;
         inShop = true;                                          
      } else if (btn.text == options[2]){
         exit(); 
      }
    }
  }

  void draw() {
    image(fWall, 0,0, width, height);
    Button tBtn = buttons.get(0);
    textFont(font, 100);
    textAlign(CENTER, CENTER);
    text(gameName, width/2, tBtn.location.y/2 - spacing);
    textAlign(TOP, LEFT);
    for (int iButton = 0; iButton < AmountButtons; iButton++){
       Button btn = buttons.get(iButton);
       btn.draw();
    }
  }

  class Button {
    PVector location, size;
    String text;
    boolean selected;

    Button(float x, float y, float w, float h, String info) {
      location = new PVector(x, y);
      size = new PVector(w, h);
      text = info;
    }
    
    boolean mouseHover() {
      boolean x = (mouseX > location.x && mouseX < location.x + size.x);
      boolean y = (mouseY > location.y && mouseY < location.y + size.y);
      return (x && y);
    }

    void draw() {
      if (selected) {
        fill(255, 50);
        noStroke();
        rect(location.x, location.y, size.x, size.y);
        stroke(255);
        strokeWeight(4);
        int mini = 4;
        //Left Upper
        line(location.x, location.y, location.x + size.y/mini, location.y);
        line(location.x, location.y, location.x, location.y + size.y/mini);

        //Left Lower
        line(location.x, location.y + size.y, location.x, location.y + size.y - size.y/mini);
        line(location.x, location.y + size.y, location.x + size.y/mini, location.y + size.y);

        //Right Upper
        line(location.x + size.x, location.y, location.x + size.x - size.y/mini, location.y);
        line(location.x + size.x, location.y, location.x + size.x, location.y + size.y/mini);

        //Right Lower
        line(location.x + size.x, location.y + size.y, location.x + size.x - size.y/mini, location.y+ size.y);
        line(location.x + size.x, location.y + size.y, location.x + size.x, location.y + size.y - size.y/mini);
      } else {
        fill(0, 100);
        noStroke();
        rect(location.x, location.y, size.x, size.y);
      }
 
      fill(255);
      textFont(font, 30);
      textAlign(CENTER, CENTER);
      text(text, location.x + size.x/2, location.y + size.y/2);
    }
  }
}
