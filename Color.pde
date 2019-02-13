public class PaletteManager 
{

  public int LIGHT = #ff96f1;
  public int MEDIUM = #6971d0;
  public int DARK = #1164b6;
  public int DARKER = #2e3192;
  public int BRIGHT = #ed145b;

  PImage palette;
  int totalFrames;
  int column; // 0-4
  float fade;

  public PaletteManager(PImage p_in) {
    palette = p_in;
    totalFrames = 0;
    column = 0;
    fade = 0;
  }

  public PaletteManager(PImage p_in, int f) {
    palette = p_in;
    totalFrames = f;
    column = 0;
    fade = 0;
  }


  public void evolve(int i) {
    palette.loadPixels();
    if (totalFrames > palette.width) {
      fade+= 0.005;
      if (fade > 1) {
        fade = 0;
        column += 1;
      }
      if (column > palette.width-1) {
        column = palette.width-1;
        fade = 1;
      }
      //println(i + " " + fade + " " + column);
      
      int thisLight = palette.pixels[column];
      int thisMed = palette.pixels[column + palette.width];
      int thisDark = palette.pixels[column + palette.width*2];
      int thisDarkr = palette.pixels[column + palette.width*3];
      
      int nextLight = thisLight;
      int nextMed = thisMed;
      int nextDark = thisDark;
      int nextDarkr = thisDarkr;
      
      if (column < palette.width-1) {
      nextLight = palette.pixels[column+1];
      nextMed =palette.pixels[column + 1 + palette.width];
      nextDark = palette.pixels[column + 1 + palette.width*2];
      nextDarkr = palette.pixels[column + 1 + palette.width*3];
      }
      
      LIGHT =  lerpColor(thisLight, nextLight, fade);
      MEDIUM = lerpColor(thisMed, nextMed , fade);
      DARK =   lerpColor(thisDark, nextDark, fade);
      DARKER = lerpColor(thisDarkr, nextDarkr, fade);
    } else {
      LIGHT = palette.pixels[column];
      MEDIUM = palette.pixels[column + palette.width];
      DARK = palette.pixels[column+ palette.width*2];
      DARKER = palette.pixels[column+ palette.width*3];
    }
  }
}


void setGradient(float x, float y, float w, float h, color c1, color c2, int axis ) {
  setGradient(int(x), int(y), w, h, c1, c2, axis);
}
void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  } else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}
