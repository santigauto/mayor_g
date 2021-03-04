
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundMusic{

  
  static final AssetsAudioPlayer backgroundAssetsAudioPlayer = new AssetsAudioPlayer();

  SharedPreferences backgroundMusic;

  initPrefs() async{
    this.backgroundMusic = await SharedPreferences.getInstance();
  }


}