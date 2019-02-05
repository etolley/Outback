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

  comparator = new DrawableComparator();
  drawQueue = new PriorityQueue<Drawable>(10, comparator);
  waves = new ArrayList <Wave>();

  float yStart = height*horizon;
  float yEnd = height;
  int nLines = 10;
  for (int i = 0; i < nLines; i++) {
    float margin = height*(1 - horizon)*i*i*i/(nLines - 1)/(nLines - 1)/(nLines - 1);
    waves.add( new Wave(height*horizon + margin, 65-i*6, margin) );
  }
}      

void draw() {
  background(0);
  setGradient(0, 0, width, height*horizon, Color.BLUE2, Color.BLUE1, Y_AXIS);
  setGradient(0, height*horizon, width, height, Color.BLUE1, Color.BLUE2, Y_AXIS);
  noFill();
  stroke(250);

  line (0, height*horizon, width, height*horizon);
  
  /*while (drawQueue.size () > 0) {
   Drawable d = drawQueue.poll();
   d.draw();
   }
   drawQueue.clear();*/

  for (Wave w : waves) w.draw();

  drawFFT();
}

void drawFFT() {
  fft.analyze(spectrum);
  stroke(255);
  noFill();
  float maxheight = height/5.;
  for (int i = 0; i < bands; i++) {
    float linex = width*1.0/bands*i;
    line( linex, height, linex, height - spectrum[i]*maxheight*5 );
  }
}
