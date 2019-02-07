import java.util.*;
import processing.sound.*;

//Sound stuff
SoundFile soundFile;
AudioIn audioIn;
Amplitude amp;
FFT fft;

// Drawing stuff
PriorityQueue<Drawable> drawQueue;
Comparator<Drawable> comparator;
ArrayList<Wave> waves;

// Constants
int Y_AXIS = 1;
int X_AXIS = 2;
static final int BANDS = 128;
static final float GR = 1.61803398875;
float horizon = 0.7;
float[] spectrum = new float[BANDS];

void setup() {
  size(1280, 720);
  frameRate(30);
  randomSeed(3);

  // Load a soundfile from the /data folder of the sketch and play it back
  soundFile = new SoundFile(this, "Outback.aif");
  println("Frames= " + soundFile.frames() + " frames");
  soundFile.play();

  fft = new FFT(this, BANDS);
  amp = new Amplitude(this);
  amp.input(soundFile);
  fft.input(soundFile);

  comparator = new DrawableComparator();
  drawQueue = new PriorityQueue<Drawable>(10, comparator);
  waves = new ArrayList <Wave>();

  float yStart = height*horizon;
  float yEnd = height;
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
  //setGradient(0, height*horizon, width, height, Color.LILA, Color.LILAC, Y_AXIS);
  noFill();


  drawFFT(height*horizon - 200);



  for (Wave w : waves) w.draw();

  stroke(Color.PINK);
  line (0, height*horizon, width, height*horizon);
}

void drawFFT(float y) {

  fft.analyze(spectrum);

  noFill();
  pushMatrix();
  translate(width/2, y);
  //rotate(-PI/2);
  stroke(Color.PINK);
  for (int i = 0; i < BANDS; i++) {
    //float linex = width*1.0/BANDS*i;
    //line( linex, y, linex, y - spectrum[i]*height/5. );
    float linetheta = i*TWO_PI/BANDS;
    float length = max(0, spectrum[i]*height/5.);
    if (length > 1) {
      line(80*cos(linetheta), 80*sin(linetheta), (80+length)*cos(linetheta), (80+length)*sin(linetheta));
      line(-80*cos(linetheta), -80*sin(linetheta), -(80+length)*cos(linetheta), -(80+length)*sin(linetheta));
    }
  }

  beginShape();
  for (int i = 0; i < BANDS; i++) {
    float linetheta = i*TWO_PI/BANDS;
    float length = max(0, sqrt(spectrum[i])*height/5.);
    vertex((80+length)*cos(linetheta), (80+length)*sin(linetheta));
    vertex(-(80+length)*cos(linetheta), -(80+length)*sin(linetheta));
      //line(80*cos(linetheta), 80*sin(linetheta), (80+length)*cos(linetheta), (80+length)*sin(linetheta));
      //line(-80*cos(linetheta), -80*sin(linetheta), -(80+length)*cos(linetheta), -(80+length)*sin(linetheta));
    
  }
  endShape();

  fill(255);
  ellipse(0, 0, 160, 160);
  popMatrix();
}
