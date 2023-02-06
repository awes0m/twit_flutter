import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twit_flutter/constants/appwrite_constants.dart';
import 'package:twit_flutter/core/core.dart';

final storageAPIProvider = Provider.autoDispose((ref) {
  return StorageAPI(storage: ref.read(appwriteStorageProvider));
});

class StorageAPI {
  final Storage _storage;

  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadimage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
          bucketId: AppwriteConstants.imagesBucket,
          fileId: ID.unique(),
          file: InputFile(
            path: file.path,
          ));
      imageLinks.add(AppwriteConstants.imageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }
}
