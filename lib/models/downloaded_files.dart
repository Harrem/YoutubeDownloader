class DownloadedFile {
  String url;
  String title;
  String savePath;
  bool isDownloaded;
  double progress;

  DownloadedFile({
    required this.url,
    required this.title,
    required this.savePath,
    required this.isDownloaded,
    required this.progress,
  });

  DownloadedFile.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        title = json['fileName'],
        savePath = json['savePath'],
        isDownloaded = json['isDownloaded'],
        progress = json['progress'];

  Map<String, dynamic> toJson() => {
        'url': url,
        'savePath': savePath,
        'fileName': title,
        'isDownloaded': isDownloaded,
        'progress': progress,
      };
}
