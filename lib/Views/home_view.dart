import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ytd/util/file_ops.dart';
import '../util/downloader.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final _urlController = TextEditingController();
  double initialHeight = 0;
  double percentage = 0.0;
  bool isLoading = false;
  double vGap = 10.0;
  bool animate = false;
  Video? video;
  List<VideoStreamInfo?> streams = [];
  Channel? channel;
  StreamManifest? manifest;
  String format = "Format";
  String quality = "Quality";
  bool isAudio = true;
  int selectedIndex = 0;
  int tabIndex = 0;
  int qIndex = 0;
  bool hasData = false;
  Downloader downloader = Downloader();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    downloader.progressStream.drain();
    super.dispose();
  }

  Future<bool> get(String vidId) async {
    try {
      final downloader = Downloader();
      video = await downloader.getVideoInfo(vidId);
      channel = await downloader.getChannelInfo(video!.channelId.value);
      manifest = await downloader.getVideoManifest(vidId);
      streams = manifest!.video
          .where((e) =>
              e.container.name == 'mp4' && e.runtimeType == VideoOnlyStreamInfo)
          .toList();
      debugPrint(streams.toString());

      // debugPrint(manifest!.audioOnly[2].toJson().toString());
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            // height: 50,
            child: TextField(
              controller: _urlController,
              // clipBehavior: Clip.antiAlias,
              autocorrect: false,
              onChanged: (value) async {
                hasData = await get(value);
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Paste Url",
                suffixIcon: IconButton(
                    onPressed: () async {
                      var val = await Clipboard.getData(Clipboard.kTextPlain);
                      if (val == null) return;
                      _urlController.text = val.text!;
                      setState(() {
                        isLoading = true;
                      });
                      hasData = await get(_urlController.text);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    icon: const Icon(Icons.paste_rounded)),
                prefixIcon: const Icon(Icons.link),
              ),
            ),
          ),
          isLoading
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox(),
          !hasData
              ? const SizedBox()
              : Expanded(
                  child: ListView(
                    // physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      SizedBox(height: vGap),
                      Card(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(10),
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 130,
                                  height: 130,
                                  child: Card(
                                    color: Colors.black,
                                    child: Image.network(
                                        video!.thumbnails.mediumResUrl),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 160,
                                        child: Text(
                                          video!.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text("channel: ${channel!.title}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                      const SizedBox(height: 10),
                                      Text(
                                          "Duration: ${video!.duration!.inMinutes} mins",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Text("Description: ${video!.engagement}",
                                  style: Theme.of(context).textTheme.bodySmall),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: vGap),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Choose Format",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  Text("some data would appear hear",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ],
                              ),
                              PopupMenuButton(itemBuilder: (context) {
                                return [
                                  const PopupMenuItem(
                                    value: 0,
                                    child: Text("Audio"),
                                  ),
                                  const PopupMenuItem(
                                    value: 1,
                                    child: Text("Video"),
                                  ),
                                ];
                              }, onSelected: (value) {
                                setState(() {
                                  value == 0 ? isAudio = true : isAudio = false;
                                });
                              })
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: vGap),
                      ExpansionTile(
                        title: const Text("Choose Quality"),
                        children: [
                          Wrap(
                            children: List.generate(
                                isAudio
                                    ? manifest!.audioOnly.length
                                    : streams.length, (index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: ChoiceChip(
                                  // selectedColor: Colors.blue[900],
                                  label: Text(isAudio
                                      ? "${manifest!.audioOnly[index].bitrate.kiloBitsPerSecond.ceil()}Kb/s | ${manifest!.audioOnly[index].size}"
                                      : "${streams[index]!.qualityLabel} | ${manifest!.video[index].size}"),
                                  selected: selectedIndex == index,
                                  onSelected: (selected) {
                                    setState(() {
                                      selectedIndex = index;
                                      // isAudio = true;
                                    });
                                  },
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // var dir = await getLibraryDirectory();
                          // debugPrint(dir.path);
                          await downloader.downloadVideo(
                              manifest!.video[selectedIndex],
                              videoTitle: video!.title);
                          setState(() {});
                        },
                        child: const Text("Download"),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

enum SampleItem { itemOne, itemTwo, itemThree }


// floatingActionButton: FloatingActionButton(
//           onPressed: () async {
//             if (isAudio) {
//               await Downloader()
//                   .downloadAudio(manifest!.audioOnly[selectedIndex]);
//             } else {
//               var selectedVideo = manifest!.video[selectedIndex];
//               downloader.downloadVideo(selectedVideo,
//                   videoTitle: video!.title, channelTitle: channel!.title);
//               downloader.progressStream.listen((event) {
//                 // showDialog(
//                 //     context: context,
//                 //     builder: (builder) => AlertDialog(
//                 //           title: Text("Downloading $event"),
//                 //           // content: const Text("Downloaded Successfully"),
//                 //         ));
//                 debugPrint("Downloaded: $event");
//               });
//             }
//           },
//           child: const Icon(Icons.download),
//         ),