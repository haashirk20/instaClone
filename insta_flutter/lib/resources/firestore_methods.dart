import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_flutter/models/post.dart';
import 'package:insta_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error occured";
    try{
      String photoUrl = await StorageMethods().uploadImagetoStorage("posts", file, true);
      String postID = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        userName: username,
        postId: postID,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage, 
        likes: []
      );

      _firestore.collection("posts").doc(postID).set(post.toJson());
      res = "success";
    }catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async{
    try {
      if(likes.contains(uid)){
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}