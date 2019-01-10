/*
*@author: Luca Ruiters
*/

class NameCreater {
  PVector position;
  float size;
  int fontSize;
  int selectedIndex = 0;
  boolean changed = false;
  boolean nameSet = false;

  character[] chars;

  NameCreater(float amount) {
    position = new PVector(width/2, height/2);
    size = amount;
    chars = new character[(int)amount];
    fontSize = 40;
    for (int iChar = 0; iChar < size; iChar++) {
      if (iChar == 0) {
        try {
          chars[iChar] = new character(width/2 - size/2*fontSize, height/2, name.charAt(iChar));
        }
        catch (Exception ex) {
          chars[iChar] = new character(width/2 - size/2*fontSize, height/2, char('a'));
        }
      } else {
        character prChar = chars[iChar - 1];
        try {
          chars[iChar] = (new character(prChar.position.x + 5 + fontSize, height/2, name.charAt(iChar)));
        } 
        catch (Exception ex) {
          chars[iChar] = (new character(prChar.position.x + 5 + fontSize, height/2, char(' ')));
        }
      }
    }
  }

  void update() {
    if (keysPressed[LEFT] && selectedIndex > 0 && !changed) {
      selectedIndex--;
      changed = true;
      character prevC = chars[selectedIndex + 1];
      prevC.selected = false;
    }
    if (keysPressed[RIGHT] && selectedIndex < size - 1 && !changed) {
      selectedIndex++;
      changed = true;
      character prevC = chars[selectedIndex - 1];
      prevC.selected = false;
    }

    if (keysPressed[ENTER] || keysPressed[32] && !enterPressed) {
      enterPressed = true;
      nameSet = true;
      name = "";
      for (character t : chars) {
        name += char(t.charCode);
      }
      inNameCreator = false;
    } else {   
      character c = chars[selectedIndex];
      c.selected = true;
      c.update();
    }
  }

  void draw() {
    for (int iChar = 0; iChar < size; iChar++) {
      character c = chars[iChar];
      c.draw();
    }

    fill(255);
    stroke(255);
    textAlign(CENTER, CENTER);
    text("You got into the top 10", width/2, height/5);
    text("Press Enter to continue", width/2, height/5*4);
    textAlign(TOP, LEFT);
  }

  class character {
    int charCode;
    PVector position;
    boolean selected = false;

    character(float x, float y, char d) {
      charCode = char(d);
      position = new PVector(x, y);
    }

    void update() {
      if (selected) {
        if (keysPressed[DOWN] && charCode > 48 && !changed) {
          charCode++;
          changed = true;
        }
        if (keysPressed[UP] && charCode < 90 && !changed) {
          charCode--;
          changed = true;
        }
      }
    }

    void draw() {      
      if (selected) {
        fill(255, 100);
        rect(position.x, position.y - fontSize*1.5, fontSize, fontSize*1.5);
      }

      fill(255);
      stroke(255);
      line(position.x, position.y, position.x + fontSize, position.y);
      textSize(fontSize);
      textAlign(LEFT, BOTTOM);
      text(char(charCode), position.x, position.y);
    }
  }
}
