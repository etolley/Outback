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
    stroke(colors.LIGHT);
    for (int i = 0; i < sm.GetBands(); i++) {
      float linetheta = i*TWO_PI/sm.GetBands();
      float length = max(0, sm.spectrum()[i]*height/5.);
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
      float r =  spectrum[i]*height/5.*max(1, sqrt(i));
      if (i < sm.GetBands()/2)
        r +=  spectrum[sm.GetBands()/2+i]*height/5.*max(1, sqrt(sm.GetBands()/2+i));
      if (i >= sm.GetBands()/2)
        r += spectrum[i-sm.GetBands()/2]*height/5.*max(1, sqrt(i-sm.GetBands()/2));
      if (r < 1) r = 0;
      raypts[i] = r;
      thetapts[i] = linetheta;
    }
    raypts[sm.GetBands()] = raypts[0];
    thetapts[sm.GetBands()] = thetapts[0];
    return raypts;
  }

  void drawHalo() {
    textAlign(RIGHT);
    
    stroke(#ffffff);
    fill(255);
    for (int e = 1; e < sm.getNElements(); e++){
      text(sm.name(e),width/4-10, -e*20);
      for (int i = 0; i < sm.GetBands(); i++){
        line(width/4+i*2,-e*20,width/4+i*2,-e*20-50*sm.spectrum(e)[i]);
        
        //sm.GetSpectrum(e)
      }
    }

    for (int e = 1; e < 4/*sm.getNElements()*/; e++){
      rvec[e] = getRays(sm.spectrum(e));
    }

    fill(colors.LIGHT,40);
    for (int ir = 1; ir < 4/*sm.getNElements()*/; ir ++) {
      stroke(colors.LIGHT);
      beginShape();
      for (int i = 0; i < sm.GetBands()+1; i++) {
        //float rp =80 + rvec[ir][i] + ir*5;
        float rp = 70;
        for (int j = ir; j < 4/*sm.getNElements()*/; j++) {
          rp += 10+ rvec[j][i];
        }
        vertex(rp*cos(thetapts[i]), rp*sin(thetapts[i]));
      }
      endShape();
    }
  }
}
