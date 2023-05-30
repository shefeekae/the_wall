import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_wall/components/like_button.dart';
import 'package:the_wall/provider/toggle_like.dart';

class WallPost extends StatelessWidget {
  WallPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  });
  final String postId;
  final String message;
  final String user;
  final List<String> likes;

  final currentUser = FirebaseAuth.instance.currentUser;

  //toggle like
  void toggleLike(BuildContext context) {
    Provider.of<ToggleLike>(context, listen: false).toggleLike();

    // setState(() {
    //   isLiked = !isLiked;
    // });

    //Access the document in Firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(postId);

    if (Provider.of<ToggleLike>(context, listen: false).isLiked) {
      //if the post is now liked, add user user's email to 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser!.email])
      });
    } else {
      //if the post is now unliked, remove the user's email from the 'Likes' field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser!.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLiked = Provider.of<ToggleLike>(context, listen: false).isLiked;
    isLiked = likes.contains(currentUser!.email);

    return Consumer<ToggleLike>(builder: (context, provider, child) {
      return Container(
        margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Column(
              children: [
                //like button

                LikeButton(
                  isLiked: isLiked,
                  onTap: () => toggleLike(context),
                ),

                //like count
                Text(
                  likes.length.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),

            //message and user
            Column(
              children: [
                Text(
                  user,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(message),
              ],
            )
          ],
        ),
      );
    });
  }
}
