public class Wave implements Drawable {
  float y;
  int nPts;
  float direction;
  float margin;
  float[] xpts;
  float[] ypts;

  Wave(float y_in, int nPts_in, float margin_in, float direction_in) {
    y = y_in;
    nPts = max(2, nPts_in);

    xpts = new float[nPts];
    ypts = new float[nPts];

    margin = margin_in;
    direction = direction_in;
  }

  float getLevel() {
    return y;
  }
  void draw() {
    stroke(colors.LIGHT,150);
    //noStroke();
    fill(colors.DARKER, margin/2. +5);
    beginShape();
    vertex(0, height);
    for (int i = 0; i < nPts; i++) {
      float xp = i*width/(nPts-1);
      float wave = (margin/5.+5)*sin(direction*frameCount*0.03 + i/2.); //
      float yp =  y + wave;
      if (yp < height*horizon) yp = height*horizon;
      xpts[i] = xp;
      ypts[i] = yp;
      vertex(xp, yp);
    }
    vertex(width, height);
    endShape();

    noStroke();
    fill(colors.LIGHT,max(10,255-sqrt(margin)*20));

    beginShape();
    for (int i = nPts/2-3; i < nPts/2 +3; i++) {
      vertex(xpts[i], ypts[i]);
    }
    vertex(width/2,ypts[nPts/2]+margin+10);
    vertex(xpts[nPts/2-3],ypts[nPts/2-3]);
    endShape();
  }
}
