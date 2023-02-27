import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'permissions.dart';
import 'dart:io';

Future<File?> createFile(
    {required String fileName, required String dirName}) async {
  await requestStoragePermission();
  var downloadPath = await getDownloadPath();
  final directory = await createDirectory(dirName, downloadPath);
  debugPrint(directory.path);
  return File('${directory.path}/$fileName.mp4');
}

Future<Directory> createDirectory(String dirName, String? dirPath) async {
  // final directory = await getExternalStorageDirectory();

  // Create the directory in the desired path
  // final dir = Directory('${directory!.path}/$dirName');
  final dir = Directory('$dirPath/$dirName');

  // Creates a directory if it doesn't exist
  await dir.create(recursive: true);

  return dir;
}

Future<String?> getDownloadPath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/ytd');
      // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
      // ignore: avoid_slow_async_io
      if (!await directory.exists())
        directory = await getExternalStorageDirectory();
    }
  } catch (err, stack) {
    print("Cannot get download folder path");
  }
  return directory?.path;
}
