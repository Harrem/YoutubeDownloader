import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ytd/views/widgets/custom_widgets.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../util/downloader.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final _urlController = TextEditingController();
  double initialHeight = 0;
  double percentage = 0.0;
  bool isLoading = false;
  double vGap = 10.0;
  bool animate = false;
  Video? video;
  Channel? channel;
  StreamManifest? manifest;
  String format = "Format";
  bool hasData = false;
  @override
  void initState() {
    super.initState();
  }

  Future<bool> get() async {
    try {
      final downloader = Downloader();
      video = await downloader.getVideoInfo("vtNJMAyeP0s");
      channel = await downloader.getChannelInfo(video!.channelId.value);
      manifest = await downloader.getVideoManifest("vtNJMAyeP0s");
      // debugPrint(manifest!.audioOnly[2].toJson().toString());
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: "Paste Url",
                    prefixIcon: IconButton(
                        onPressed: () async {
                          // Clipboard.getData(Clipboard.kTextPlain).then((value) {
                          //   if(value == null) return;
                          //   debugPrint(value.text); //value is clipbarod data
                          //   _urlController.text = value.text!;
                          // });
                          hasData = await get();
                          setState(() {});
                        },
                        icon: const Icon(Icons.link)),
                    suffixIcon: const Icon(Icons.paste_rounded),
                  ),
                ),
              ),
              !hasData
                  ? const SizedBox()
                  : Expanded(
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
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
                                  child: Text(
                                      "Description: ${video!.description}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: vGap),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  ElevatedButton(
                                      onPressed: () {
                                        showMenu(
                                          context: context,
                                          position: const RelativeRect.fromLTRB(
                                              100, 100, 100, 100),
                                          items: [
                                            PopupMenuItem(
                                              value: "MP4",
                                              onTap: () => setState(() {
                                                format = "MP4";
                                              }),
                                              child: const Text("MP4"),
                                            ),
                                            PopupMenuItem(
                                              value: "MP3",
                                              onTap: () => setState(() {
                                                format = "MP3";
                                              }),
                                              child: const Text("MP3"),
                                            ),
                                          ],
                                        );
                                      },
                                      child: Text(format))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: vGap),
                          CardWithSideButtion(
                            titleText: "Choose Quality",
                            subtitleText: "some text goes here about ",
                            btnText: "Choose",
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 300,
                                      child: ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.only(top: 10),
                                        itemCount: manifest!.video.length,
                                        separatorBuilder: ((context, index) =>
                                            const Divider()),
                                        itemBuilder: (context, index) =>
                                            ListTile(
                                          title: Text(manifest!
                                              .video[index].qualityLabel),
                                          leading: const Icon(
                                              Icons.arrow_circle_down_outlined),
                                          trailing: Text(
                                            "${manifest!.video[index].size.totalMegaBytes.toStringAsFixed(2)} MB",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)));
                              // debugPrint("${manifest.videoOnly[5].fragments.isEmpty}");
                              // downloader.downloadVideo(manifest.video[6],
                              // videoTitle: video.title, channelTitle: channel.title);
                              setState(() {
                                isLoading = false;
                              });
                              // showMenu(
                              //   context: context,
                              //   position: const RelativeRect.fromLTRB(
                              //       100, 100, 100, 100),
                              //   items: List.generate(
                              //     manifest!.streams.length,
                              //     (index) => PopupMenuItem(
                              //       child: Text(
                              //           manifest!.streams[index].qualityLabel),
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                          // PopupMenuButton(
                          //   itemBuilder: (BuildContext context) =>
                          //       <PopupMenuEntry<SampleItem>>[
                          //     const PopupMenuItem<SampleItem>(
                          //       value: SampleItem.itemOne,
                          //       child: Text('Item 1'),
                          //     ),
                          //     const PopupMenuItem<SampleItem>(
                          //       value: SampleItem.itemTwo,
                          //       child: Text('Item 2'),
                          //     ),
                          //     const PopupMenuItem<SampleItem>(
                          //       value: SampleItem.itemThree,
                          //       child: Text('Item 3'),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: vGap),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            hasData = await get();
            setState(() {});
          },
          child: const Icon(Icons.download),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

enum SampleItem { itemOne, itemTwo, itemThree }
