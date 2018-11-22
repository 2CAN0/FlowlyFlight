// "Press SPACE to launch and gain altitude"
class Tutorial {
  PVector position, size;
  float ttlSpacing = 120;

  String text;
  boolean hover = false;
  PImage button;

  Tutorial (float ttlX, float ttlY, String ttlTextTutorial, float titleSpacing, PImage btn, float ttlW, float ttlH) {
    position = new PVector(ttlX, ttlY);
    size = new PVector(ttlW, ttlH);
    text = ttlTextTutorial;
    ttlSpacing = titleSpacing;
    button = btn;
  }

  void draw() {
      textAlign(CENTER, CENTER);
      textFont(tutText);
      textSize(50);
      fill(255); //RGB
      text(text, position.x, height/4 - 60);
      
      image(button, position.x - ttlW/2, position.y, size.x, size.y);
      textFont(font);
  }
}

void setupTutorial() {
  ttlTutorial = new Tutorial(width/2, height/4, "To Gain Altitutde", 40, spaceBar, ttlW, ttlH);
}

void drawTutorial() {
  fill(255);
  ttlTutorial.draw();
}
