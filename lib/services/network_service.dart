import 'dart:async';
import 'package:dio/dio.dart';
import 'package:evince_test/model/audio.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';

class NetworkService {
  NetworkService();
  final dioClient = Dio();
  Future<List<Audio>> getAudios() async {
    try {
      final response = await dioClient
          .get("https://media.abeti.xyz/api/v1/media-list")
          .timeout(const Duration(seconds: 3));

      final responseData = response.data as List;
      return responseData.map((audio) => Audio.fromMap(audio)).toList();
    } on DioError catch (error) {
      if (error.type == DioErrorType.other) {
        throw Exception("Kindly Check Your Internet Access and Try Again");
      } else {
        throw Exception(error.message);
      }
    } on TimeoutException {
      throw Exception("Low Internet Access Discovered, Try Again");
    }
  }

  void downloadAudio(String url, String audioTitle, onProgress) async {
    try {
      final appPath = await getTemporaryDirectory();
      await dioClient.download(url, "${appPath.path}/$audioTitle.mp3",
          onReceiveProgress: onProgress);

      final params = SaveFileDialogParams(
          sourceFilePath: "${appPath.path}/$audioTitle.mp3");
      await FlutterFileDialog.saveFile(params: params);
    } catch (e) {
      throw Exception(e);
    }
  }
}
