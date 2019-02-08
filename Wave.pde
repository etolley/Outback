public class Wave implements Drawable {
  float y;
  int nPts;
  float direction;
  float margin;
  float[] spectrum;
  int bands = 0;
  float[] xpts;
  float[] ypts;

  Wave(float y_in, int nPts_in, float margin_in, float direction_in) {
    y = y_in;
    nPts = max(2, nPts_in);
    //nPts = 100;

    xpts = new float[nPts];
    ypts = new float[nPts];

    margin = margin_in;
    direction = direction_in;
  }

  void setSpectrum( float[] spectrum_in, int bands_in) {
    spectrum = spectrum_in;
    bands = bands_in;
  }

  float getLevel() {
    return y;
  }
  void draw() {
    stroke(Color.LILAC);
    //noStroke();
    fill(Color.BLUE2, margin/2. +5);
    beginShape();
    vertex(0, height);
    for (int i = 0; i < nPts; i++) {
      float xp = i*width/(nPts-1);
      float jitter_amp = 0;
      if (bands > 0) {
        println(margin);
        float total_amp = 0;
        for (int j = 10; j < bands; j++) {
          total_amp += spectrum[j];
        }
        jitter_amp = total_amp + (margin/100.+1);
      }
      float jitter =jitter_amp*sin(frameCount*0.04 + xp/0.5); //xp/0.5
      float wave = (margin/5.+5)*sin(direction*frameCount*0.03 + i/2.); //
      float yp =  y + wave + jitter;
      if (yp < height*horizon) yp = height*horizon;
      xpts[i] = xp;
      ypts[i] = yp;
      vertex(xp, yp);
    }
    vertex(width, height);
    endShape();

    //noFill();
    //stroke(Color.PINK);
    noStroke();
    fill(Color.PINK,max(10,255-sqrt(margin)*20));

    beginShape();
    for (int i = nPts/2-3; i < nPts/2 +3; i++) {
      vertex(xpts[i], ypts[i]);
    }
    vertex(width/2,ypts[nPts/2]+margin+10);
    vertex(xpts[nPts/2-3],ypts[nPts/2-3]);
    endShape();
  }
}
