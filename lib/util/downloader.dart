import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter/foundation.dart';
import 'file_ops.dart';
import 'dart:io';

class Downloader {
  var ytExplode = YoutubeExplode();

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
    stream.video.forEach((element) {
      debugPrint(
          "Resolution: ${element.videoResolution}, Quality: ${element.qualityLabel}, Size: ${element.size}");
    });
    return stream;
  }

  Future<void> downloadVideo(VideoStreamInfo video,
      {String? videoTitle, String? channelTitle}) async {
    final httpR = HttpClient().userAgent;
    debugPrint(httpR);

    var file = await createFile(
        fileName: "${videoTitle ?? video.tag}",
        dirName: channelTitle ?? "Unknown");

    if (file == null) return Future.error("Process Canceled");

    final sink = file.openWrite();

    debugPrint("video: ${video.url}");
    debugPrint("requesting vido stream");

    var request = await HttpClient().getUrl(Uri.parse(video.url.toString()));

    debugPrint("downloading");

    var response = await request.close();

    var total = response.contentLength;
    var received = 0;

    await for (var data in response) {
      received += data.length;
      final percentage = ((received / total) * 100).toStringAsFixed(0);
      print('Download progress: $percentage%');
      sink.add(data);
    }

    await sink.flush();
    sink.close();

    debugPrint("Video Downloaded Successfully");
  }

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
}
