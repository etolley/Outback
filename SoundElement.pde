public class SoundElement {
  private ArrayList<SoundFile> soundFiles;
  private ArrayList<FFT> ffts;
  private ArrayList<float[]> spectra;
  private int bands;
  private String name;

  SoundElement(PApplet p, int bands_in, String in_name, String[] soundFileNames) {
    bands= bands_in;
    name = in_name;
    init();
    for (String name : soundFileNames) {
      FFT fft =  new FFT(p, bands);
      SoundFile f = new SoundFile(p, name);
      fft.input(f);
      soundFiles.add(f);
      ffts.add(fft);
      spectra.add(new float[bands]);
    }
  }

  SoundElement(PApplet p, int bands_in, String in_name, String fileName) {
    bands= bands_in;
    name = in_name;
    init();
    FFT fft =  new FFT(p, bands);
    SoundFile f = new SoundFile(p, fileName);
    fft.input(f);
    soundFiles.add(f);
    ffts.add(fft);
    spectra.add(new float[bands]);
  }
  
  void init(){
    soundFiles = new ArrayList<SoundFile>();
    ffts = new ArrayList<FFT>();
    spectra = new ArrayList<float[]>();
  }

  void play() { 
    for (SoundFile f : soundFiles) f.play();
  }

  void analyze() {
    for (int i = 0; i < ffts.size(); i++)
      ffts.get(i).analyze(spectra.get(i));
  }
  
  float[] spectrum(){
    float[] spectrum = new float[bands];
    
    for (int b = 0; b < bands; b++){
      spectrum[b] = 0;
      for (int i = 0; i < spectra.size(); i++){
        spectrum[b] += spectra.get(i)[b];
      }
    }
     
    return spectrum;
  }

  String name() {
    return name;
  }
  int bands() {
    return bands;
  }
}
