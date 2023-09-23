import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_flutter/providers/user_provider.dart';
import 'package:insta_flutter/resources/firestore_methods.dart';
import 'package:insta_flutter/utils/colors.dart';
import 'package:insta_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  void postImage(String uid, String username, String profileImage) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profileImage,
      );

      if (res == "success") {
          setState(() {
            _isLoading = true;
          });
        showSnackBar("Posted!", context);
        clearImage();
      } else {
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(title: const Text("Create a Post"), children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a Photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.camera,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Choose from Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.gallery,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ]);
        });
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => clearImage(),
              ),
              title: const Text("Post to"),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () => postImage(userProvider.getUser.uid, userProvider.getUser.userName, userProvider.getUser.photoUrl),
                    child: const Text("Post to ",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)))
              ],
            ),
            body: Column(children: [
              _isLoading? const LinearProgressIndicator(): Padding(padding: EdgeInsets.only(top: 0)),
              const Divider(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(userProvider.getUser.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                        height: 45,
                        width: 45,
                        child: AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ))))),
                    const Divider(),
                  ])
            ]),
          );
  }
}
