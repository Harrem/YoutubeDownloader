import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  void updatestate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FlutterDownloader.loadTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data == null) {
            return const Center(
              child: Text("No Downloads"),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.grey,
              );
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: DownloadProgressWidget(
                  url: snapshot.data![index].url,
                  fileName: snapshot.data![index].filename!,
                  taskId: snapshot.data![index].taskId,
                  status: snapshot.data![index].status,
                  progress: snapshot.data![index].progress,
                  updatestate: updatestate,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DownloadProgressWidget extends StatefulWidget {
  final String url;
  final String fileName;
  final String? image;
  final String taskId;
  final DownloadTaskStatus status;
  final int progress;
  final Function updatestate;

  const DownloadProgressWidget({
    super.key,
    required this.url,
    required this.fileName,
    required this.taskId,
    required this.status,
    required this.progress,
    required this.updatestate,
    this.image,
  });

  @override
  State<DownloadProgressWidget> createState() => _DownloadProgressWidgetState();
}

class _DownloadProgressWidgetState extends State<DownloadProgressWidget> {
  Future<void> refresh() async {
    await Future.doWhile(() {
      return Future.delayed(const Duration(seconds: 1), () {
        if (widget.status == DownloadTaskStatus.complete ||
            widget.status == DownloadTaskStatus.canceled ||
            widget.status == DownloadTaskStatus.paused ||
            widget.status == DownloadTaskStatus.failed) {
          debugPrint("stopped updating");
          return false;
        }
        debugPrint("updating progress");
        setState(() {});

        return true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  Future<void> removeTask(String taskId) async {
    await FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: true);
  }

  String _getStatusText() {
    if (widget.status == DownloadTaskStatus.undefined) {
      return 'Undefined';
    } else if (widget.status == DownloadTaskStatus.enqueued) {
      return 'Enqueued';
    } else if (widget.status == DownloadTaskStatus.running) {
      return 'Running';
    } else if (widget.status == DownloadTaskStatus.paused) {
      return 'Paused';
    } else if (widget.status == DownloadTaskStatus.canceled) {
      return 'Canceled';
    } else if (widget.status == DownloadTaskStatus.failed) {
      return 'Failed';
    } else if (widget.status == DownloadTaskStatus.complete) {
      return 'Completed';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.image != null)
          Image.network(
            widget.image!,
            height: 150.0,
            width: 150.0,
          ),
        const SizedBox(height: 10.0),
        Text(
            widget.fileName.length > 50
                ? "${widget.fileName.substring(0, 50)}..."
                : widget.fileName,
            style: const TextStyle(
              fontSize: 16.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 20.0),
        // if (widget.status != DownloadTaskStatus.complete)
        //   Text(
        //     'Download progress: ${widget.progress}%',
        //     style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        //   ),
        // if (widget.status == DownloadTaskStatus.complete)
        Text(
          _getStatusText(),
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.status == DownloadTaskStatus.running ||
                widget.status == DownloadTaskStatus.paused)
              ElevatedButton(
                onPressed: () async {
                  if (widget.status == DownloadTaskStatus.running) {
                    await FlutterDownloader.pause(taskId: widget.taskId);
                    setState(() {});
                  } else if (widget.status == DownloadTaskStatus.paused) {
                    await FlutterDownloader.resume(taskId: widget.taskId);
                    refresh();
                    setState(() {});
                  }
                },
                child: Text(
                  widget.status == DownloadTaskStatus.running
                      ? 'Pause'
                      : 'Resume',
                  style: const TextStyle(fontSize: 12.0),
                ),
              ),
            if (widget.status == DownloadTaskStatus.canceled ||
                widget.status == DownloadTaskStatus.failed)
              ElevatedButton(
                onPressed: () async {
                  // await _startDownload();
                },
                child: const Text(
                  'Restart',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            if (widget.status == DownloadTaskStatus.complete)
              ElevatedButton(
                onPressed: () async {
                  // await _startDownload();
                  FlutterDownloader.open(taskId: widget.taskId);
                },
                child: const Text(
                  'Open',
                  style: TextStyle(fontSize: 12.0),
                ),
              ),
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () async {
                    await removeTask(widget.taskId);
                    widget.updatestate();
                  },
                  child: Text(
                    widget.status != DownloadTaskStatus.complete
                        ? "Remove"
                        : 'Delete',
                  ),
                ),
              ];
            }),
          ],
        ),
        if (widget.status == DownloadTaskStatus.running)
          LinearProgressIndicator(
            value: widget.progress / 100,
            backgroundColor: Colors.grey,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
      ],
    );
  }
}
