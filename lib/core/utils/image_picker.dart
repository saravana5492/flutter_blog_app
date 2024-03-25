import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      final file = File(xFile.path);
      return file;
    }
    return null;
  } catch (err) {
    return null;
  }
}
