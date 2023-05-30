import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_wall/components/my_drawer.dart';
import 'package:the_wall/components/my_textfield.dart';
import 'package:the_wall/components/wall_post.dart';
import 'package:the_wall/pages/profile_page.dart';
import 'package:the_wall/provider/textfield_provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textController = TextEditingController();

  //sign out user
  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //navigate to profile page
  goToProfilePage(BuildContext context) {
    //pop menu drawer
    Navigator.pop(context);

    //go to profile page
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
  }

  //post message
  void postMessage(BuildContext context) {
    //only post if there is something in the text field
    if (textController.text.isNotEmpty) {
      //store in firebase
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserMail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }
    Provider.of<TextFieldProvider>(context, listen: false)
        .clearTextField(textController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text("The Wall"),
      ),
      body: Center(
        child: Column(
          children: [
            //the wall
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy('TimeStamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      //get the message
                      final posts = snapshot.data!.docs[index];
                      return WallPost(
                        message: posts['Message'],
                        user: posts['UserMail'],
                        postId: posts.id,
                        likes: List<String>.from(posts['Likes'] ?? []),
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error:${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )),
            //post message
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  //text field
                  Expanded(
                      child: MyTextField(
                          controller: textController,
                          obscureText: false,
                          hintText: "Write something on the wall")),
                  //post button
                  IconButton(
                      onPressed: () => postMessage(context),
                      icon: const Icon(Icons.arrow_circle_up))
                ],
              ),
            ),

            //signed in as
            Text("Logged in as: ${currentUser.email}")
          ],
        ),
      ),
      drawer: MyDrawer(
        onSignOutTap: signOut,
        onProfileTap: () => goToProfilePage(context),
      ),
    );
  }
}
