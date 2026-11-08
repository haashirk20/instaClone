import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:insta_flutter/models/user.dart";
import "package:insta_flutter/providers/user_provider.dart";
import "package:insta_flutter/resources/firestore_methods.dart";
import "package:insta_flutter/utils/colors.dart";
import "package:insta_flutter/widgets/comment_card.dart";
import "package:provider/provider.dart";

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final TextEditingController _commentController = TextEditingController();


    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap["postId"])
            .collection("comments")
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        }
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  radius: 16,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: "Comment as ${user.userName}",
                          border: InputBorder.none,
                        )),
                  ),
                ),
                InkWell(
                    onTap: () async {
                      await FirestoreMethods().postComment(
                        widget.snap["postId"],
                        _commentController.text,
                        user.uid,
                        user.userName,
                        user.photoUrl,
                      );
                      setState(() {
                        _commentController.clear();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: const Text("Post",
                          style: TextStyle(
                            color: Colors.blueAccent,
                          )),
                    )),
              ],
            )),
      ),
    );
  }
}
