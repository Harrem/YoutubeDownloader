import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (status.isDenied) {
    var result = await Permission.storage.request();
    if (result != PermissionStatus.granted) {
      throw Exception("Storage permission not granted");
    }
  } else if (status.isDenied) {
    throw Exception("Storage permission denied");
  }
}

// Future<void> requestStoragePermission() async {
//   final status = await Permission.storage.status;
//   if (status != PermissionStatus.granted) {
//     final result = await Permission.storage.request();
//     if (result.isPermanentlyDenied) {
//       await openAppSettings();
//     } else if (result.isDenied) {
//       await requestStoragePermission();
//     }
//     // else (result != PermissionStatus.granted) {
//     //   throw Exception('Storage permission not granted');
//     // }
//   }
// }
