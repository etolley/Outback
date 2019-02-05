import processing.sound.*;
SoundFile soundFile;
AudioIn audioIn;
Amplitude amp;
FFT fft;




// Constants
int Y_AXIS = 1;
int X_AXIS = 2;
int bands = 512;
float gr = 1.61803398875;
float horizon = 1/gr;
float[] spectrum = new float[bands];

void setup() {
  size(1280, 720);
  frameRate(30);

  // Load a soundfile from the /data folder of the sketch and play it back
  soundFile = new SoundFile(this, "Outback.aif");
  println("Frames= " + soundFile.frames() + " frames");
  soundFile.play();

  fft = new FFT(this, bands);
  amp = new Amplitude(this);
  amp.input(soundFile);
  fft.input(soundFile);
}      

void draw() {
  background(200);
  setGradient(0, 0, width, height*horizon, 20, 100, Y_AXIS);
  setGradient(0, height*horizon, width, height, 100, 20, Y_AXIS);
  
  println("Sound amp = "+amp.analyze());
  
  drawFFT();
  drawShore();

}

void drawFFT(){
  fft.analyze(spectrum);
  stroke(255);
  noFill();
  float maxheight = height/5.;
  for (int i = 0; i < bands; i++) {
    float linex = width*1.0/bands*i;
    line( linex, height, linex, height - spectrum[i]*maxheight*5 );
  }
}

void drawWaveLine(float y, int nPts, float margin){
   beginShape();
  for (int i = 0; i < nPts; i++){
    float xp = i*width/(nPts-1);
    float jitter = (margin/5.+1)*sin(frameCount*0.04 + xp/0.5);
    float wave = (margin/2.+5)*sin(frameCount*0.03 + xp/500.);
    vertex(xp, y + jitter + wave);    
  }
  endShape();
}

void drawShore(){
  
  noFill();
  stroke(250);
  
  line (0, height*horizon, width, height*horizon);
  
  float yStart = height*horizon;
  float yEnd = height;
  int nLines = 5;
  for (int i = 0; i < nLines; i++){
    float margin = height*(1 - horizon)*i/(nLines - 1);
    drawWaveLine(height*horizon + margin, 10, margin );
  }
  
  //drawWaveLine(height*horizon, 20);
  //drawWaveLine(height*horizon, 10);
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
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}
