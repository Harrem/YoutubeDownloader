import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart' as dl;
import 'file_ops.dart';
import 'dart:io';

class Downloader {
  var ytExplode = YoutubeExplode();
  final StreamController<double> _downloaderStream =
      StreamController<double>.broadcast();

  Future<Video> getVideoInfo(String videoId) async {
    var video = await ytExplode.videos.get(videoId);
    return video;
  }

  Future<Channel> getChannelInfo(String channelId) async {
    var channel = await ytExplode.channels.get(channelId);
    return channel;
  }

  Future<StreamManifest> getVideoManifest(String videoId) async {
    var stream = await ytExplode.videos.streamsClient.getManifest(videoId);
    for (var element in stream.video) {
      debugPrint(
          "Resolution: ${element.videoResolution}, Quality: ${element.qualityLabel}, Size: ${element.size}");
    }
    return stream;
  }

  Future<String?> download(String url, String fileName, String saveDir) async {
    await dl.FlutterDownloader.registerCallback(downloadCallback);
    var taskId = await dl.FlutterDownloader.enqueue(
        url: url,
        fileName: fileName,
        savedDir: saveDir,
        showNotification: true);
    return taskId;
  }

  static void downloadCallback(
      String id, dl.DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<String?> downloadVideo(VideoStreamInfo video,
      {required String videoTitle, String? channelTitle}) async {
    var dir = await createDirectory(
        channelTitle ?? 'Unknown', '/storage/emulated/0/ytd/');
    var taskId = download(video.url.toString(), videoTitle, dir.path);
    return taskId;
    // final httpR = HttpClient().userAgent;
    // debugPrint(httpR);

    // var file = await createFile(
    //     fileName: videoTitle, dirName: channelTitle ?? "Unknown");

    // if (file == null) Stream.error("Process Canceled");

    // final sink = file!.openWrite();

    // debugPrint("video: ${video.url}");
    // debugPrint("requesting vido stream");

    // var request = await HttpClient().getUrl(Uri.parse(video.url.toString()));

    // debugPrint("downloading");

    // var response = await request.close();

    // var length = response.contentLength;
    // var received = 0;
    // var progress = 0.0;
    // response.listen(
    //   (data) async {
    //     if (_isPaused) {
    //       _pausedProgress = progress / length;
    //       await _saveDownloadStatus(
    //           videoTitle, _pausedSavePath, false, _pausedProgress);
    //       return;
    //     }
    //     received += data.length;
    //     sink.add(data);
    //     progress = (received / length);
    //     _downloadProgress.add(progress);
    //     await _saveDownloadStatus(videoTitle, file.path, true, progress);
    //   },
    //   onDone: () async {
    //     debugPrint("Video Downloaded Successfully");
    //     _downloadProgress.close();
    //     await sink.flush();
    //     sink.close();
    //     await _saveDownloadStatus(videoTitle, file.path, true, 1.0);
    //   },
    // );
  }

  Stream<double> get progressStream => _downloaderStream.stream;

  Future<void> downloadAudio(AudioStreamInfo audio,
      {String? videoTitle, String? channelTitle}) async {
    final httpR = HttpClient().userAgent;
    debugPrint(httpR);

    var file = await createFile(
        fileName: "${videoTitle ?? audio.tag}",
        dirName: channelTitle ?? "Unknown");

    if (file == null) return Future.error("Process Canceled");

    final sink = file.openWrite();

    debugPrint("video: ${audio.url}");
    debugPrint("requesting vido stream");

    var request = await HttpClient().getUrl(Uri.parse(audio.url.toString()));

    debugPrint("downloading");

    var response = await request.close();

    var total = response.contentLength;
    var received = 0;

    await for (var data in response) {
      received += data.length;
      final percentage = (received / total * 100).toStringAsFixed(0);
      print('Download progress: $percentage%');
      sink.add(data);
    }

    await sink.flush();
    sink.close();

    debugPrint("Video Downloaded Successfully");
  }

  Future<void> appendFile(String file1Path, String file2Path) async {
    final file1 = File(file1Path);
    final file2 = File(file2Path);

    final file1RandomAccess = await file1.open(mode: FileMode.append);
    final file2Content = await file2.readAsBytes();

    await file1RandomAccess.writeFrom(file2Content);
    await file1RandomAccess.close();
  }

  Future<void> pauseDownload(String taskId) async {
    await dl.FlutterDownloader.pause(taskId: taskId);
  }

  Future<void> resumeDownload(String taskId) async {
    await dl.FlutterDownloader.resume(taskId: taskId);
  }

  // Future<void> _saveDownloadStatus(
  //     String title, String savePath, bool isDownloaded, double progress) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final metadataJson = prefs.getString(savePath);
  //   if (metadataJson != null) {
  //     final metadata = DownloadedFile.fromJson(json.decode(metadataJson));
  //     metadata.isDownloaded = isDownloaded;
  //     metadata.progress = progress;
  //     final newMetadataJson = json.encode(metadata.toJson());
  //     await prefs.setString(savePath, newMetadataJson);
  //   } else {
  //     final metadata = DownloadedFile(
  //       url: '',
  //       title: title,
  //       savePath: savePath,
  //       isDownloaded: isDownloaded,
  //       progress: progress,
  //     );
  //     final metadataJson = json.encode(metadata.toJson());
  //     await prefs.setString(savePath, metadataJson);
  //   }
  // }
}
