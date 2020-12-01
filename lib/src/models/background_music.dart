import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundMusic{

  static final AudioPlayer backgroundAudioPlayer = new AudioPlayer();

  SharedPreferences backgroundMusic;

  initPrefs() async{
    this.backgroundMusic = await SharedPreferences.getInstance();
  }


}