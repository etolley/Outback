
public class SoundManager {
  public static final int BANDS = 128;
  public float[] spectrum = new float[BANDS];
  public static final String song_name = "Outback";
  public String[] element_names = { 
    "Atmospherics", "Lead_Synth", "Melody", 
    "Bass", "Snare", "Cymbals", "Starfalls", "Chords", 
    "Toms", "Hi_hats", "VOX", "Kick"};
  public static final int nElements = 12;
  int ATMOS, SYNTH, MELOD, BASS, SNARE, CYMB, STAR, CHORDS, TOMS, HIHATS, VOX, KICK;

  public SoundFile[] elements;
  public FFT[] elements_fft;
  public float[][] element_spectrum = new float[nElements][BANDS];
  SoundFile soundFile_all;
  FFT fft;

  SoundManager(PApplet p) {
    fft =  new FFT(p, BANDS);
    soundFile_all = new SoundFile(p, "Outback.aif");
    fft.input(soundFile_all);

    elements = new SoundFile[nElements];
    elements_fft = new FFT[nElements];
    for (int i = 0; i < nElements; i++) {
      elements[i] = new SoundFile(p, "channels/"+element_names[i]+".aif");
      elements_fft[i] = new FFT(p, BANDS);
      elements_fft[i].input(elements[i]);
    }
  }

  void Play(int e) {
    elements[e].play();
  }

  void PlayAll() {
    for (int i = 0; i < nElements; i++) 
      elements[i].play();
  }

  void Play() {
    soundFile_all.play();
  }


  void Analyze(int e) {
    elements_fft[e].analyze(element_spectrum[e]);
  }

  void AnalyzeAll() {
    for (int i = 0; i < nElements; i++) 
      elements_fft[i].analyze(element_spectrum[i]);
  }

  void Analyze() {
    fft.analyze(spectrum);
  }

  float[] GetFullSpectrum() {
    return spectrum;
  }
  
  float[] GetSpectrum(int e) {
    return element_spectrum[e];
  }

  int GetBands() {
    return BANDS;
  }
  
  int getNElements(){
    return nElements;
  }
}
