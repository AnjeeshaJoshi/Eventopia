import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadEventImage(File file, String eventId) async {
    final ref = _storage.ref().child('events').child('$eventId.jpg');
    await _uploadImageBytes(ref, file);
    // Fetching metadata first verifies that Storage has committed the object
    // before its URL is saved to Firestore.
    await ref.getMetadata();
    return ref.getDownloadURL();
  }

  Future<String> uploadProfileImage(File file, String uid) async {
    final ref = _storage.ref().child('profiles').child('$uid.jpg');
    final uploadTask = await _uploadImageBytes(ref, file);
    return await uploadTask.ref.getDownloadURL();
  }

  /// Upload bytes instead of a platform file reference. Image Picker can
  /// return cache/content-backed paths on Android that Firebase's `putFile`
  /// rejects even though the image is readable by the app.
  Future<TaskSnapshot> _uploadImageBytes(Reference ref, File file) async {
    final localFile = file.isAbsolute ? file : file.absolute;
    if (!await localFile.exists()) {
      throw StateError('The selected image is no longer available. Please choose it again.');
    }
    final bytes = await localFile.readAsBytes();
    final snapshot = await ref.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    if (snapshot.state != TaskState.success) {
      throw StateError('The image upload did not complete. Please try again.');
    }
    return snapshot;
  }

  Future<void> deleteImage(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (e) {
      // Handle error or ignore if not found
    }
  }
}
