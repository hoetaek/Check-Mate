import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class ProfileFirestorageProvider {
  static Future<String> uploadFile(File data) async {
    final StorageReference storageReference =
        FirebaseStorage().ref().child('profile/${Path.basename(data.path)}');
    final StorageUploadTask uploadTask = storageReference.putFile(data);

    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      // You can use this to notify yourself or your user in any kind of way.
      // For example: you could use the uploadTask.events stream in a StreamBuilder instead
      // to show your user what the current status is. In that case, you would not need to cancel any
      // subscription as StreamBuilder handles this automatically.

      // Here, every StorageTaskEvent concerning the upload is printed to the logs.
      print('EVENT ${event.type}');
    });

// Cancel your subscription when done.
    await uploadTask.onComplete;
    streamSubscription.cancel();
    return await storageReference.getDownloadURL();
  }
}
