class LvlSelector {
  PVector location, size;
  PImage[] mapPreviews;
  String[] names;
  float margin;
  float btnSize;
  int selectedMap = 0;
  boolean selectedChanged = false;

  LvlSelector(PVector tempLocation, PVector tempSize, PImage[] tempPreviews, String[] tempNames, float tempMargin, float tempBtnSize) {
    location = tempLocation.copy();
    size = tempSize.copy();
    mapPreviews = tempPreviews;
    names = tempNames;
    margin = tempMargin;
    btnSize = tempBtnSize;
  }

  void update() {
    if (keysPressed[RIGHT] && !selectedChanged) {
      if (selectedMap == mapPreviews.length - 1)
        selectedMap = 0;
      else 
      selectedMap++;

      selectedChanged = true;
    } else if (keysPressed[LEFT] && !selectedChanged) {
      if (selectedMap == 0)
        selectedMap = mapPreviews.length - 1;
      else
        selectedMap--;

      selectedChanged = true;
    }
    
    if((keysPressed[ENTER] || keysPressed[32]) && !enterPressed){
       enterPressed = true;
       bgSelected = true;
       drawLoading();
       bg = new Background(maps[selectedMap], mapImages[selectedMap]);
    }
  }

  void draw() {
    //Map Name
    textSize(30);
    textAlign(CENTER);
    text(names[selectedMap], location.x + size.x/2, location.y - margin);
    text("Press Enter to select", location.x + size.x/2, location.y + size.y + ((height - (location.y + size.y))/2));
    textAlign(LEFT, TOP);

    //Buttons
    ////Left Button
    triangle(location.x - margin - btnSize, location.y + size.y/2, 
      location.x - margin, location.y + size.y/2 - btnSize/2, 
      location.x - margin, location.y + size.y/2 + btnSize/2);
    ////Right Button
    triangle(location.x + size.x + margin + btnSize, location.y + size.y/2, 
      location.x + size.x + margin, location.y + size.y/2 - btnSize/2, 
      location.x + size.x + margin, location.y + size.y/2 + btnSize/2);

    //Map Preview
    stroke(255);
    rect(location.x, location.y, size.x, size.y);
    image(mapPreviews[selectedMap], location.x, location.y, size.x, size.y);
    noStroke();
  }
}
