public class Color 
{
    public static final int LILAC = #6971d0;
    public static final int BLUE1 = #1164b6;
    public static final int BLUE2 = #2e3192;
    public static final int MAGENTA = #ed145b;
    public static final int PINK = #ff96f1;
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
