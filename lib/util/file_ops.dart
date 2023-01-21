import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/foundation.dart';
import 'permissions.dart';
import 'dart:io';

Future<File?> createFile(
    {required String fileName, required String dirName}) async {
  await requestStoragePermission();
  final directory = await createDirectory(dirName);
  debugPrint(directory.path);
  return File('${directory.path}/$fileName.mp4');
}

Future<Directory> createDirectory(String dirName) async {
  final directory = await path_provider.getExternalStorageDirectory();

  // Create the directory in the desired path
  final dir = Directory('${directory!.path}/$dirName');

  // Creates a directory if it doesn't exist
  await dir.create(recursive: true);

  return dir;
}
