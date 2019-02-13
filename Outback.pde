import java.util.*;
import processing.sound.*;

//Sound stuff
SoundManager sm;
SoundFile soundFile_all;
//FFT fft;

// Drawing stuff
PriorityQueue<Drawable> drawQueue;
Comparator<Drawable> comparator;
ArrayList<Wave> waves;
Corona corona;
Constellation nightSky;
PaletteManager colors;

PShader blur;

// Constants
int Y_AXIS = 1;
int X_AXIS = 2;
//static final int BANDS = 128;
static final float GR = 1.61803398875;
float horizon = 0.7;
//float[] spectrum = new float[BANDS];

void setup() {
  size(1280, 720);
  frameRate(30);
  randomSeed(3);

  blur = loadShader("blur.glsl");

  sm = new SoundManager(this);

  colors = new PaletteManager(loadImage("outback_palette.png"), sm.frames());
  comparator = new DrawableComparator();
  drawQueue = new PriorityQueue<Drawable>(10, comparator);
  waves = new ArrayList <Wave>();
  corona = new Corona(sm);
  nightSky = new Constellation(height*horizon);

  int nLines = 10;
  for (int i = 0; i < nLines; i++) {
    float margin = height*(1 - horizon)*i*i*i/(nLines - 1)/(nLines - 1)/(nLines - 1);
    Wave thisWave = new Wave(height*horizon + margin, 40-i*2, margin, random(-1, 1));
    //thisWave.setSpectrum(spectrum, BANDS);
    waves.add( thisWave);
  }

  //Color.setPink();
}      

void draw() {
  
  colors.evolve(frameCount);

  if (frameCount == 3) {
    sm.play();  
    sm.playAll();
  }

  background(colors.DARK);
  setGradient(0, 0, width, 3*height*horizon/4, colors.DARKER, colors.DARK, Y_AXIS);
  setGradient(0, 3*height*horizon/4., width, height*horizon/4., colors.DARK, colors.MEDIUM, Y_AXIS);
  noFill();


  drawHeavens(height*horizon - 200);
  



  for (Wave w : waves) w.draw();

  stroke(colors.LIGHT);
  line (0, height*horizon, width, height*horizon);
  
  drawOverlay();
}

void drawHeavens(float y) {

  sm.analyze();
  sm.analyzeAll();


  noFill();
  pushMatrix();
  translate(width/2, y);

  nightSky.draw();
  corona.draw();

  fill(colors.DARKER);
  ellipse(0, 0, 160, 160);

  for (int i = 0; i < 5; i++) {
    stroke(lerpColor(colors.LIGHT, colors.MEDIUM, i/4.));
    ellipse(0, 0, 159-i*1.5, 159-i*1.5);
  }
  popMatrix();
  

}

void drawOverlay(){
  sm.drawAnalysis(width/2, height/2);
  textAlign(LEFT);
  text(frameCount, 60,40);
  fill(colors.LIGHT);
  rect(20,20,20,20);
  fill(colors.MEDIUM);
  rect(20,40,20,20);
  fill(colors.DARK);
  rect(20,60,20,20);
  fill(colors.DARKER);
  rect(20,80,20,20);
}
