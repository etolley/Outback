public class Corona implements Drawable {
  //float[] spectrum;
  //int bands = 0;
  //float[] xpts;
  //float[] ypts;
  float[] rpts;
  float[] thetapts;
  float[][] rvec;
  int maxhalos = 11;
  SoundManager sm;

  Corona(SoundManager sm_in) {
    sm = sm_in;
    rpts = new float[sm.GetBands()+1];
    thetapts = new float[sm.GetBands()+1];
    rvec = new float[sm.getNElements()][sm.GetBands()+1];
  }

  float getLevel() {
    return 0;
  }
  void draw() {
    //drawLines();
    drawHalo();
  }

  void drawLines() {
    stroke(Color.PINK);
    for (int i = 0; i < sm.GetBands(); i++) {
      float linetheta = i*TWO_PI/sm.GetBands();
      float length = max(0, sm.GetFullSpectrum()[i]*height/5.);
      if (length > 1) {
        line(80*cos(linetheta), 80*sin(linetheta), (80+length)*cos(linetheta), (80+length)*sin(linetheta));
        line(-80*cos(linetheta), -80*sin(linetheta), -(80+length)*cos(linetheta), -(80+length)*sin(linetheta));
      }
    }
  }

  float[] getRays(float[] spectrum) {
    float[] raypts = new float[sm.GetBands()+1];
    for (int i = 0; i < sm.GetBands(); i++) {
      float linetheta = i*TWO_PI/sm.GetBands();
      float length =  spectrum[i]*height/5.*max(1, sqrt(i));
      if (i < sm.GetBands()/2)
        length +=  spectrum[sm.GetBands()/2+i]*height/5.*max(1, sqrt(sm.GetBands()/2+i));
      if (i >= sm.GetBands()/2)
        length += spectrum[i-sm.GetBands()/2]*height/5.*max(1, sqrt(i-sm.GetBands()/2));
      if (length < 1) length = 0;
      raypts[i] = length;
      thetapts[i] = linetheta;
    }
    rpts[sm.GetBands()] = raypts[0];
    thetapts[sm.GetBands()] = thetapts[0];
    return raypts;
  }

  void drawHalo() {

    for (int e = 0; e < sm.getNElements(); e++){
      //rvec[e] = sm.GetSpectrum(e);
      rvec[e] = getRays(sm.GetSpectrum(e));
    }

    fill(Color.PINK,40);
    for (int ir = 0; ir < sm.getNElements(); ir ++) {
      stroke(Color.PINK);
      beginShape();
      for (int i = 0; i < sm.GetBands()+1; i++) {
        //float rp =80 + rvec[ir][i] + ir*5;
        float rp = 80;
        for (int j = ir; j < sm.getNElements(); j++) {
          rp += 5+ rvec[j][i];
        }
        vertex(rp*cos(thetapts[i]), rp*sin(thetapts[i]));
      }
      endShape();
    }
  }
}
