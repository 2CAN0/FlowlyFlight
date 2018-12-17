import ddf.minim.*;
import java.util.*;

// A reference to the processing sound engine
Minim minim = new Minim(this);

// SampleBank loads all samples in the data directory of your project
// so they can be triggered at any time in your game
class soundBank {

  HashMap<String, AudioSample> samples;
  AudioPlayer musicPlayer;

  // Constructor
  soundBank() {
    samples = new HashMap<String, AudioSample>();
    loadAllSamples();
  }

  // load the background music
  void loadMusic(String musicFileName) {
    musicPlayer = minim.loadFile(musicFileName);
  }

  // play the background music
  void playMusic() {
    musicPlayer.play();
  }

  // Add a new sample to the sound bank
  void add(String sampleFileName) {
    AudioSample sample = minim.loadSample(sampleFileName);
    samples.put(sampleFileName, sample);    
    println(sampleFileName);
  }

  // trigger a loaded sample by fileName
  void trigger(String sampleFileName) {
    //    if (!sampleFileName.endsWith(".wav") &&  samples.containsKey(sampleFileName + ".wav"))
    //      sampleFileName += ".wav";
    if (samples.containsKey(sampleFileName)) 
      samples.get(sampleFileName).trigger();
  }

  // trigger a loaded sample by index
  void trigger(int sampleIndex) {
    Object [] keys = samples.keySet().toArray();
    if ((sampleIndex >= 0) && (sampleIndex < keys.length))
      trigger((String) keys[sampleIndex]);
  }

  // load all .wav files in the processing data directory
  void loadAllSamples() {
    File dataFolder = new File(dataPath(""));
    File [] files = dataFolder.listFiles();

    for (File file : files)
      if (file.getName().toLowerCase().endsWith(".wav"))
        add(file.getName());
  }
}
