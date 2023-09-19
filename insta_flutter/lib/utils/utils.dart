import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

pickImage(ImageSource source) async {
  // ignore: deprecated_member_use
  final ImagePicker _picker = ImagePicker();

  XFile? _file = await _picker.pickImage(source: source);

  if (_file != null){
    return await _file.readAsBytes();
  }

  print("No image selected");
}

showSnackBar(String content, BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
