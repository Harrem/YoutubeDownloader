import 'package:flutter/material.dart';

import '../util/downloader.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final urlController = TextEditingController();
  var percentage = 0.0;
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("YT Downloader"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                labelText: "Paste Url",
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final downloader = Downloader();
                var video = await downloader.getVideoInfo(urlController.text);
                var channel =
                    await downloader.getChannelInfo(video.channelId.value);
                var manifest =
                    await downloader.getVideoManifest(video.id.value);
                downloader.downloadVideo(manifest.video[6],
                    videoTitle: video.title, channelTitle: channel.title);
                // Downloader().downloadVideo(urlController.text);
                setState(() {
                  isLoading = false;
                });
              },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Download HD"),
            ),
            LinearProgressIndicator(
              value: percentage,
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
