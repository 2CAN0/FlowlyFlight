// "Press SPACE to launch and gain altitude"
class Tutorial {
  PVector position, size;
  float ttlSpacing = 120;

  String text;
  boolean hover = false;
  boolean grow = false;
  float minSize;
  float maxSize;
  float xShrink;
  float yShrink;
  PImage button;

  Tutorial (float ttlX, float ttlY, String ttlTextTutorial, float titleSpacing, PImage btn, float ttlW, float ttlH) {
    position = new PVector(ttlX, ttlY);
    size = new PVector(ttlW, ttlH);
    text = ttlTextTutorial;
    ttlSpacing = titleSpacing;

    minSize = size.x - .12;
    maxSize = size.x + .12;
    xShrink = minSize/size.x;
    yShrink = size.y - 5/size.y;

    button = btn;
  }

  void changeSize() {
    float dim = 120;
    if (!grow) {
      if (size.x > minSize) {
        size.y -= yShrink/dim;
        size.x -= xShrink/dim;
      } else
        grow = true;
    } else {
      if (size.x < maxSize) {
        size.y += yShrink/dim;
        size.x += xShrink/dim;
      } else
        grow = false;
    }
  }

  void draw() {
    textAlign(CENTER, CENTER);
    textFont(tutText);
    textSize(50);
    fill(255); //RGB
    text(text, position.x, height/4 - 60);
    changeSize();
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
