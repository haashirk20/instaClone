import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:insta_flutter/models/user.dart";
import "package:insta_flutter/providers/user_provider.dart";
import "package:insta_flutter/resources/firestore_methods.dart";
import "package:insta_flutter/screens/comment_screen.dart";
import "package:insta_flutter/utils/colors.dart";
import "package:insta_flutter/utils/utils.dart";
import "package:insta_flutter/widgets/like_animation.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  void initState(){
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
        QuerySnapshot snap = await FirebaseFirestore.instance.collection("posts").doc(widget.snap["postId"]).collection("comments").get();
        commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
              .copyWith(right: 0),
          child: Row(
            //HEADER
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.snap["profImage"]),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.snap["userName"],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                                child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: [
                                "Delete",
                              ]
                                  .map((e) => InkWell(
                                        onTap: () async {
                                          FirestoreMethods().deletePost(
                                              widget.snap["postId"]);
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ))
                                  .toList(),
                            )));
                  },
                  icon: const Icon(Icons.more_vert)),
            ],
          ),
        ),
        //IMAGE
        GestureDetector(
          onDoubleTap: () async {
            await FirestoreMethods().likePost(
              widget.snap["postId"],
              widget.snap["uid"],
              widget.snap["likes"],
            );
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap["postUrl"],
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  child: const Icon(Icons.favorite,
                      color: Colors.white, size: 120),
                  isAnimating: isLikeAnimating,
                  duration: const Duration(
                    milliseconds: 400,
                  ),
                  onEnd: () {
                    setState(() {
                      isLikeAnimating = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),

        //LIKE COMMENT SECTION
        Row(
          children: [
            LikeAnimation(
              isAnimating: widget.snap["likes"].contains(user.uid),
              smallLike: true,
              child: IconButton(
                onPressed: () async {
                  await FirestoreMethods().likePost(
                    widget.snap["postId"],
                    widget.snap["uid"],
                    widget.snap["likes"],
                  );
                },
                icon: widget.snap["likes"].contains(user.uid)
                    ? const Icon(Icons.favorite, color: Colors.red)
                    : const Icon(Icons.favorite_border),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CommentsScreen(
                        snap: widget.snap,
                      ))),
              icon: const Icon(Icons.comment_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send),
            ),
            //add space
            Expanded(
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_border))),
            ),
          ],
        ),

        //Description and # of comments
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w800),
                child: Text(
                  "${widget.snap["likes"].length} likes",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: widget.snap["userName"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: " ${widget.snap["description"]}",
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "View all $commentLen comments",
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMd()
                      .format(widget.snap["datePublished"].toDate()),
                  style: const TextStyle(fontSize: 16, color: secondaryColor),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
