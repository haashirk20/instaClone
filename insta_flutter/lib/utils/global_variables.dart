import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:insta_flutter/screens/add_post_screen.dart";
import "package:insta_flutter/screens/feed_screen.dart";
import "package:insta_flutter/screens/profile_screen.dart";
import "package:insta_flutter/screens/search_screen.dart";

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text("favourite"),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];