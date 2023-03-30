import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadedFile {
  String url;
  String fileName;
  String savePath;
  bool isDownloaded;
  double progress;

  DownloadedFile({
    required this.url,
    required this.fileName,
    required this.savePath,
    required this.isDownloaded,
    required this.progress,
  });

  DownloadedFile.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        fileName = json['fileName'],
        savePath = json['savePath'],
        isDownloaded = json['isDownloaded'],
        progress = json['progress'];

  Map<String, dynamic> toJson() => {
        'url': url,
        'savePath': savePath,
        'fileName': fileName,
        'isDownloaded': isDownloaded,
        'progress': progress,
      };
}
