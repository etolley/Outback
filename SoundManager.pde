
public class SoundManager {
  public static final int BANDS = 128;
  
  ArrayList<SoundElement> soundElements;

  SoundManager(PApplet p) {
    soundElements = new ArrayList<SoundElement>();
    soundElements.add(new SoundElement(p,BANDS,"Outback","Outback.aif" ));
    
    String[] chords = {"channels/Chords.aif", "channels/Melody.aif", "channels/Bass.aif"};
    soundElements.add(new SoundElement(p,BANDS,"Chords+Melody+Bass",chords ));
    
    //2
    String[] drums = {"channels/Kick.aif", "channels/Snare.aif", "channels/Cymbals.aif", "channels/Hi_hats.aif"};
    soundElements.add(new SoundElement(p,BANDS,"Kick+Snare+Cymbals+HiHats",drums ));
    
    soundElements.add(new SoundElement(p,BANDS,"Starfalls","channels/Starfalls.aif" ));
    
    soundElements.add(new SoundElement(p,BANDS,"Toms","channels/Toms.aif" ));
    
    soundElements.add(new SoundElement(p,BANDS,"VOX","channels/VOX.aif" ));
    
    
    soundElements.add(new SoundElement(p,BANDS,"Lead_Synth","channels/Lead_Synth.aif" ));
    soundElements.add(new SoundElement(p,BANDS,"Atmospherics","channels/Atmospherics.aif" ));
    
  }
  
  int frames(){
    return soundElements.get(0).frames();
  }

  void play(int e) {
    soundElements.get(e).play();
  }

  void playAll() {
    for (int i = 1; i < soundElements.size(); i++) 
      soundElements.get(i).play();
  }

  void play() {
    soundElements.get(0).play();
  }

  void analyze(int e) {
    soundElements.get(e).analyze();
  }

  void analyzeAll() {
    for (int i = 1; i < soundElements.size(); i++) 
      soundElements.get(i).analyze();
  }

  void analyze() {
    soundElements.get(0).analyze();
  }

  float[] spectrum() {
    return soundElements.get(0).spectrum();
  }
  
  float[] spectrum(int e) {
    return soundElements.get(e).spectrum();
  }

  int GetBands() {
    return BANDS;
  }
  
  SoundElement getElement(int e){
    return soundElements.get(e);
  }
  
  int getNElements(){
    return soundElements.size();
  }
  
  String name(int e){
    return soundElements.get(e).name();
  }
  
  void drawAnalysis(float x, float y){
    
    pushMatrix();
    translate(x,y);
    textAlign(RIGHT);
    
    stroke(#ffffff);
    fill(255);
    for (int e = 1; e < getNElements(); e++){
      text(name(e),width/4-10, -e*20);
      for (int i = 0; i < GetBands(); i++){
        line(width/4+i*2,-e*20,width/4+i*2,-e*20-50*sm.spectrum(e)[i]);

      }
    }
    
    popMatrix();
  }
}
