import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (status.isRestricted || status.isDenied) {
    var result = await Permission.storage.request();
    if (result != PermissionStatus.granted) {
      throw Exception("Storage permission not granted");
    }
  } else if (status.isDenied) {
    throw Exception("Storage permission denied");
  }
}
