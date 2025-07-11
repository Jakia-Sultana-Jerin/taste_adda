import 'dart:io';
import 'package:image_picker/image_picker.dart';





/// Function to pick an image from the gallery.

 Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }


