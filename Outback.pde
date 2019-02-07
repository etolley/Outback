import java.util.*;
import processing.sound.*;

//Sound stuff
SoundManager sm;
SoundFile soundFile_all;
//AudioIn audioIn;
//Amplitude amp;
FFT fft;

// Drawing stuff
PriorityQueue<Drawable> drawQueue;
Comparator<Drawable> comparator;
ArrayList<Wave> waves;
Corona corona;

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

  // Load a soundFile_all from the /data folder of the sketch and play it back
  //soundFile_all = new SoundFile(this, "Outback" + ".aif");
  //soundFile_all.play();
  
  sm = new SoundManager(this);
  sm.Play();  
  sm.PlayAll();

  comparator = new DrawableComparator();
  drawQueue = new PriorityQueue<Drawable>(10, comparator);
  waves = new ArrayList <Wave>();
  corona = new Corona(sm);

  int nLines = 10;
  for (int i = 0; i < nLines; i++) {
    float margin = height*(1 - horizon)*i*i*i/(nLines - 1)/(nLines - 1)/(nLines - 1);
    Wave thisWave = new Wave(height*horizon + margin, 40-i*2, margin, random(-1, 1));
    //thisWave.setSpectrum(spectrum, BANDS);
    waves.add( thisWave);
  }
}      

void draw() {
  background(Color.BLUE1);
  setGradient(0, 0, width, 3*height*horizon/4, Color.BLUE2, Color.BLUE1, Y_AXIS);
  setGradient(0, 3*height*horizon/4., width, height*horizon/4., Color.BLUE1, Color.LILAC, Y_AXIS);
  noFill();


  drawFFT(height*horizon - 200);



  for (Wave w : waves) w.draw();

  stroke(Color.PINK);
  line (0, height*horizon, width, height*horizon);
}

void drawFFT(float y) {

  sm.Analyze();
  sm.AnalyzeAll();


  noFill();
  pushMatrix();
  translate(width/2, y);
 
  corona.draw();

  fill(Color.BLUE2);
  ellipse(0, 0, 160, 160);
  
  for (int i = 0; i < 5; i++){
  stroke(lerpColor(Color.PINK, Color.LILAC, i/4.));
  ellipse(0, 0, 159-i*1.5, 159-i*1.5);
  }
  popMatrix();
}
