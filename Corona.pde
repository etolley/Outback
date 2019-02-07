public class Corona implements Drawable {
  float[] spectrum;
  int bands = 0;
  float[] xpts;
  float[] ypts;

  Corona(float[] spectrum_in, int bands_in) {
    spectrum = spectrum_in;
    bands = bands_in;
  }

  float getLevel() {
    return 0;
  }
  void draw() {
    
  }
}
