import 'package:flutter/material.dart';
import 'package:ytd/main.dart';

import '../util/downloader.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final _urlController = TextEditingController();
  AnimationController? _animationCrtl;
  double initialHeight = 0;
  double percentage = 0.0;
  bool isLoading = false;
  double vGap = 10.0;
  bool animate = false;

  @override
  void initState() {
    super.initState();
    _animationCrtl = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: 50,
                child: TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    hintText: "Paste Url",
                    prefixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.light_mode_rounded)),
                    suffixIcon: const Icon(Icons.paste_rounded),
                  ),
                ),
              ),
              const Divider(),
              SizedBox(height: vGap),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: initialHeight,
                // transform: Matrix4.identity()..scale(_animationCrtl!.value),
                child: Card(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 130,
                            height: 130,
                            child: Card(color: Colors.black),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 160,
                                  child: Text(
                                    "Title Text Goes Here and we are so happy to see it ",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text("Channel: GrowBTV",
                                    style: Theme.of(context).textTheme.caption),
                                const SizedBox(height: 10),
                                Text("Duration: 10 minutes",
                                    style: Theme.of(context).textTheme.caption),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat... More",
                            style: Theme.of(context).textTheme.caption),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: vGap),
              AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                height: initialHeight / 3,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Choose Format",
                                style: Theme.of(context).textTheme.titleMedium),
                            Text("some data would appear hear",
                                style: Theme.of(context).textTheme.caption),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {}, child: const Text("MP4"))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: vGap),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                height: initialHeight / 3,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Choose Quality",
                                style: Theme.of(context).textTheme.titleMedium),
                            Text("some data would appear hear",
                                style: Theme.of(context).textTheme.caption),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("1080p"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: vGap),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Future.delayed(const Duration(seconds: 5));
                    final downloader = Downloader();
                    var video = await downloader.getVideoInfo("vtNJMAyeP0s");
                    var channel =
                        await downloader.getChannelInfo(video.channelId.value);
                    var manifest =
                        await downloader.getVideoManifest("vtNJMAyeP0s");
                    debugPrint(manifest.audioOnly[2].toJson().toString());
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: isLoading
                      ? const SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator())
                      : const Icon(Icons.arrow_forward_rounded),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (animate) {
              // _animationCrtl!.value = 1;
              // _animationCrtl!.forward();
              setState(() {
                initialHeight = 300;
              });
            } else {
              // _animationCrtl!.value = 0;
              // _animationCrtl!.reverse();
              setState(() {
                initialHeight = 0;
              });
            }
            animate = !animate;
          },
          child: const Icon(Icons.settings),
        ),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}


// showModalBottomSheet(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return SizedBox(
//                             height: 300,
//                             child: ListView.separated(
//                               physics: const BouncingScrollPhysics(),
//                               padding: const EdgeInsets.only(top: 10),
//                               itemCount: manifest.video.length,
//                               separatorBuilder: ((context, index) =>
//                                   const Divider()),
//                               itemBuilder: (context, index) => ListTile(
//                                 title: Text(manifest.video[index].qualityLabel),
//                                 leading: const Icon(
//                                     Icons.arrow_circle_down_outlined),
//                                 trailing: Text(
//                                   "${manifest.video[index].size.totalMegaBytes.toStringAsFixed(2)} MB",
//                                   style: Theme.of(context).textTheme.subtitle1,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(15)));
//                     // debugPrint("${manifest.videoOnly[5].fragments.isEmpty}");
//                     // downloader.downloadVideo(manifest.video[6],
//                     // videoTitle: video.title, channelTitle: channel.title);
//                     setState(() {
//                       isLoading = false;
//                     });