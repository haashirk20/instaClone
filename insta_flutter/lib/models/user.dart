import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String userName;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;

  const User({
    required this.uid,
    required this.email,
    required this.userName,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  Map<String,dynamic> toJson() =>{
    "uid": uid,
    "email": email,
    "userName": userName,
    "bio": bio,
    "photoUrl": photoUrl,
    "followers": followers,
    "following": following,
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      userName: snapshot["userName"],
      email: snapshot["email"],
      bio: snapshot["bio"],
      photoUrl: snapshot["photoUrl"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      uid: snapshot["uid"],
    );
  }
}