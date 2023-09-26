import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

pickImage(ImageSource source) async {
  // ignore: deprecated_member_use
  final ImagePicker picker = ImagePicker();

  XFile? file = await picker.pickImage(source: source);

  if (file != null){
    return await file.readAsBytes();
  }

  print("No image selected");
}

showSnackBar(String content, BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}
