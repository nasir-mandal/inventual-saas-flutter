import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadByIdController extends GetxController {
  var selectedFiles = <int, File>{}.obs;

  Future<void> pickFile(int productID, {bool fromCamera = false}) async {
    final picker = ImagePicker();
    late File pickedFile;

    try {
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        pickedFile = File(pickedImage.path);
        selectedFiles[productID] = pickedFile;
      }
    } finally {}
  }

  void clearFile(int productId) {
    selectedFiles.remove(productId);
  }
}
