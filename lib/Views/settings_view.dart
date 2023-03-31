import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _autoDownload = true;
  bool _darkMode = true;
  int _maxDownloads = 3;
  double _downloadSpeed = 1.5;
  String _downloadPath = '/Downloads';

  void _onAutoDownloadChanged(bool value) {
    setState(() {
      _autoDownload = value;
    });
  }

  void _onDarkModeChanged(bool value) {
    setState(() {
      _darkMode = value;
    });
  }

  void _onMaxDownloadsChanged(int? value) {
    setState(() {
      _maxDownloads = value!;
    });
  }

  void _onDownloadSpeedChanged(double value) {
    setState(() {
      _downloadSpeed = value;
    });
  }

  void _onDownloadPathChanged(String value) {
    setState(() {
      _downloadPath = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _darkMode,
              onChanged: _onDarkModeChanged,
            ),
            Text(
              'Download Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SwitchListTile(
              title: const Text('Auto Download'),
              value: _autoDownload,
              onChanged: _onAutoDownloadChanged,
            ),
            ListTile(
              title: const Text('Max Downloads'),
              trailing: DropdownButton<int>(
                value: _maxDownloads,
                onChanged: _onMaxDownloadsChanged,
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text('1'),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('2'),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text('3'),
                  ),
                  DropdownMenuItem(
                    value: 4,
                    child: Text('4'),
                  ),
                  DropdownMenuItem(
                    value: 5,
                    child: Text('5'),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Download Speed'),
              // trailing: Slider(
              //   value: _downloadSpeed,
              //   min: 0.5,
              //   max: 2.0,
              //   divisions: 3,
              //   onChanged: _onDownloadSpeedChanged,
              // ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Download Path',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ListTile(
              title: const Text('Path'),
              subtitle: Text(_downloadPath),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                // TODO: Implement file picker to select download path
              },
            ),
          ],
        ),
      ),
    );
  }
}
