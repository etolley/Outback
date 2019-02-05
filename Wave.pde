public class Wave implements Drawable {
  float y;
  int nPts;
  float margin;

  /*void drawWaveLine(float y, int nPts, float margin) {
    beginShape();
    for (int i = 0; i < nPts; i++) {
      float xp = i*width/(nPts-1);
      float jitter = (margin/5.+1)*sin(frameCount*0.04 + xp/0.5);
      float wave = (margin/2.+5)*sin(frameCount*0.03 + xp/500.);
      vertex(xp, y + jitter + wave);
    }
    endShape();*/
    
    Wave(float y_in, int nPts_in, float margin_in){
      y = y_in;
      nPts = max(2,nPts_in);
      margin = margin_in;
    }
   

    float getLevel() {
      return y;
    }
    void draw() {
      stroke(255);
      fill(Color.BLUE2,50);
      beginShape();
      vertex(0, height);
      for (int i = 0; i < nPts; i++) {
        float xp = i*width/(nPts-1);
        float jitter = (margin/5.+1)*sin(frameCount*0.04 + xp/0.5);
        float wave = (margin/2.+5)*sin(frameCount*0.03 + xp/500.);
        vertex(xp, y + jitter + wave);
      }
      vertex(width, height);
      endShape();
    }
  }
