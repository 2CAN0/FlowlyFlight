class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      // Use nf() to number format 'i' into four digits
      String filename = imagePrefix + i +".png";
      images[i] = loadImage(filename);
    }
  }

  void display(float xpos, float ypos, float w, float h) {
    frame = (frame+1) % imageCount;
    image(images[frame], xpos, ypos, w, h);
  }
  
  int getWidth() {
    return images[0].width;
  }
}
