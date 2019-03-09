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
    float direction = random(0.1, 1);
    if (random(0, 1) > 0.5) direction*= -1;
    Wave thisWave = new Wave(height*horizon + margin, 40-i*2, margin, direction);
    waves.add( thisWave);
  }
}      

void draw() {

  colors.evolve(frameCount);
  println(frameRate);

  if (frameCount == 50) {
    //sm.play();  
    sm.playAll();
  }
  //if (frameCount > 50) sm.jumpAll( (frameCount-50)/30.);

  background(colors.DARK);
  setGradient(0, 0, width, 3*height*horizon/4, colors.DARKER, colors.DARK, Y_AXIS);
  setGradient(0, 3*height*horizon/4., width, height*horizon/4., colors.DARK, colors.MEDIUM, Y_AXIS);
  noFill();

  drawHeavens(height*horizon - 200);
  noStroke();
  fill(colors.DARK);
  rect(0, height*horizon, width, height);
  for (Wave w : waves) w.draw();
  stroke(colors.LIGHT);
  line (0, height*horizon, width, height*horizon);
  stroke(#ffffff, 10);
  for (int i = 0; i < 10; i++)
    line (i*10, height*horizon, width-i*10, height*horizon);

  //drawOverlay();
  //if (frameCount < 8000) saveFrame();
}

void drawHeavens(float y) {

  //sm.analyze();
  sm.analyzeAll();

  noFill();
  pushMatrix();
  translate(width/2, y);

  nightSky.draw();
  corona.draw();

  fill(colors.LIGHT);
  ellipse(0, 0, 160, 160);
  fill(#ffffff, 100);
  ellipse(0, 0, 150, 150);

  //artifact.draw();
  popMatrix();
}

void drawOverlay() {
  sm.drawAnalysis(width/2, height/2);
  textAlign(LEFT);
  text(frameCount, 60, 40);
  fill(colors.LIGHT);
  rect(20, 20, 20, 20);
  fill(colors.MEDIUM);
  rect(20, 40, 20, 20);
  fill(colors.DARK);
  rect(20, 60, 20, 20);
  fill(colors.DARKER);
  rect(20, 80, 20, 20);
}
