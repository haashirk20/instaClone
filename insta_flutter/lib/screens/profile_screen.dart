import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:insta_flutter/utils/colors.dart";
import "package:insta_flutter/utils/utils.dart";
import "package:insta_flutter/widgets/follow_button.dart";

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      //get post length
      var postSnap = await FirebaseFirestore.instance.collection("posts").where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
      postLen = postSnap.docs.length;
      followers = userSnap.data()!["followers"].length;
      following = userSnap.data()!["following"].length;
      userData = userSnap.data()!;
      isFollowing = userSnap.data()!["followers"].contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?  const Center(child: CircularProgressIndicator()) :Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Text(
          userData["userName"],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          NetworkImage(userData["photoUrl"]),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postLen, "posts"),
                              buildStatColumn(followers, "followers"),
                              buildStatColumn(following, "following"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid == widget.uid? FollowButton(
                                text: "Edit Profile",
                                backgroundColor: mobileBackgroundColor,
                                textColor: primaryColor,
                                borderColor: Colors.grey,
                                function: () {},
                              ): isFollowing ? FollowButton(
                                text: "Unfollow",
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                borderColor: Colors.grey,
                                function: () {},
                              ): FollowButton(
                                text: "Follow",
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                borderColor: Colors.blue,
                                function: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    userData["userName"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    userData["bio"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder(
            future: FirebaseFirestore.instance.collection("posts").where("uid", isEqualTo: widget.uid).get(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator());
              }

              return GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 1.5, childAspectRatio: 1),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                  return Container(
                    child: Image(
                      image: NetworkImage(
                        snap["postUrl"]),
                        fit: BoxFit.cover,));
                });
            }
          ),
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: const EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            )),
      ],
    );
  }
}
