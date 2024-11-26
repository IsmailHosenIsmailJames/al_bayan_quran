import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../api/apis.dart';
import '../recitation_info/ayah_counts.dart';
import '../recitation_info/recitation_info_model.dart';
import 'controller/audio_controller.dart';

class ManageQuranAudio {
  static AudioPlayer audioPlayer = AudioPlayer();
  static AudioController audioControllerGetx = Get.put(AudioController());

  /// Plays a single ayah audio using the specified ayah and surah numbers.
  ///
  /// This function stops any currently playing audio, constructs the audio URL
  /// for the specified ayah and surah, and then plays the ayah audio using the
  /// audio player. If a reciter is not provided, it defaults to the currently
  /// selected recitation model. Optionally, a media item can be provided to
  /// set additional metadata for the audio.
  ///
  /// [ayahNumber] - The verse number within the surah to play.
  /// [surahNumber] - The chapter number in the Quran.
  /// [reciter] - (Optional) A specific reciter's information; defaults to the current recitation model if not provided.
  /// [mediaItem] - (Optional) A media item to set as the tag for the audio.
  static Future<void> startListening() async {
    audioPlayer.durationStream.listen((event) {
      if (event != null) {
        audioControllerGetx.duration.value = event.inMilliseconds;
      }
    });

    audioPlayer.positionStream.listen((event) {
      audioControllerGetx.progress.value = event.inMilliseconds;
    });

    audioPlayer.speedStream.listen((event) {
      audioControllerGetx.speed.value = event;
    });

    audioPlayer.playerStateStream.listen((event) {
      if (audioControllerGetx.currentIndex.value != -1) {
        audioControllerGetx.isPlaying.value = event.playing;
      }
    });

    audioPlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        audioControllerGetx.isPlaying.value = false;
        audioControllerGetx.currentIndex.value = -1;
      }
    });

    audioControllerGetx.isStreamRegistered.value = true;
  }

  static Future<void> playSingleAyah({
    required int ayahNumber,
    required int surahNumber,
    RecitationInfoModel? reciter,
    MediaItem? mediaItem,
  }) async {
    if (audioControllerGetx.isStreamRegistered.value == false) {
      startListening();
    }
    reciter ??= findRecitationModel();
    String ayahID = ayahIDFromNumber(ayahNumber, surahNumber);
    audioPlayer.stop();
    String audioUrl = makeAudioUrl(
      reciter,
      ayahIDFromNumber(ayahNumber, surahNumber),
    );
    await audioPlayer.setAudioSource(
      LockCachingAudioSource(
        Uri.parse(audioUrl),
        tag: findMediaItem(ayahID: ayahID, reciter: reciter),
      ),
    );
    await audioPlayer.play();
  }

  static Future<void> playMultipleAyahOfSurah({
    required int surahNumber,
    RecitationInfoModel? reciter,
    MediaItem? mediaItem,
  }) async {
    if (audioControllerGetx.isStreamRegistered.value == false) {
      startListening();
    }
    audioPlayer.stop();
    int ayahCount = ayahCountOfAllSurah[surahNumber - 1];
    List<AudioSource> audioResourceSource = [];
    reciter ??= findRecitationModel();
    for (int i = 0; i < ayahCount; i++) {
      audioResourceSource.add(
        LockCachingAudioSource(
          Uri.parse(
            makeAudioUrl(
              reciter,
              ayahIDFromNumber(i + 1, surahNumber),
            ),
          ),
          tag: findMediaItem(
              ayahID: ayahIDFromNumber(i + 1, surahNumber), reciter: reciter),
        ),
      );
    }

    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
      shuffleOrder: DefaultShuffleOrder(),
      children: audioResourceSource,
    );
    await audioPlayer.setAudioSource(playlist,
        initialIndex: 0, initialPosition: Duration.zero);
    await audioPlayer.play();
  }

  /// Generates a URL pointing to a specific ayah's audio on everyayah.com.
  ///
  /// The URL is constructed by concatenating the base API URL with the
  /// subfolder of the currently selected reciter and the ayah number. The
  /// ayah number is zero-padded with three digits. For example, if the
  /// currently selected reciter has subfolder "Abdul_Basit_Murattal_64kbps"
  /// and the ayah number is 1, the generated URL will be:
  ///
  /// https://everyayah.com/data/Abdul_Basit_Murattal_64kbps/001.mp3
  static String makeAudioUrl(RecitationInfoModel reciter, String ayahID) {
    return "${audioBaseAPI}data/${reciter.subfolder}/$ayahID.mp3";
  }

  /// Retrieves the currently selected reciter from the 'info' box in hive.
  ///
  /// The currently selected reciter is stored as a JSON string in the
  /// 'reciter' key of the 'info' box in hive. When this function is called,
  /// it reads the JSON string from that key and parses it into a
  /// [RecitationInfoModel] using the [RecitationInfoModel.fromJson] method.
  /// The resulting [RecitationInfoModel] is then returned.
  static RecitationInfoModel findRecitationModel() {
    final jsonReciter = Hive.box('info').get('reciter');
    return RecitationInfoModel.fromJson(jsonReciter);
  }

  /// Returns a [MediaItem] with the given [ayahID] and [reciter].
  ///
  /// The [MediaItem] will have:
  /// - [id] and [title] set to [ayahID].
  /// - [displayTitle] set to [ayahID].
  /// - [album] set to [reciter]'s name.
  /// - [artist] set to [reciter]'s subfolder.
  /// - [artUri] set to the given [artUri] if not null, or null if null.
  static MediaItem findMediaItem(
      {required String ayahID,
      required RecitationInfoModel reciter,
      Uri? artUri}) {
    return MediaItem(
      id: ayahID,
      title: ayahID,
      displayTitle: ayahID,
      album: reciter.name,
      artist: reciter.subfolder,
      artUri: artUri,
    );
  }

  /// Generates a formatted ayah ID string by combining the surah number
  /// and ayah number. Both numbers are zero-padded to three digits.
  ///
  /// [ayahNumber] - The verse number within the surah.
  /// [surahNumber] - The chapter number in the Quran.
  ///
  /// Returns a string representation of the ayah ID in the format 'SSSAAA'
  /// where 'SSS' is the zero-padded surah number and 'AAA' is the zero-padded ayah number.
  static String ayahIDFromNumber(int ayahNumber, int surahNumber) {
    return '${surahNumber.toString().padLeft(3, '0')}${ayahNumber.toString().padLeft(3, '0')}';
  }
}
