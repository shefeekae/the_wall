import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_wall/components/my_textbox.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

//current user
  final currentUser = FirebaseAuth.instance.currentUser;

  final usersCollection = FirebaseFirestore.instance.collection("Users");

  void editField(String field, BuildContext context) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Enter new $field',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: const TextStyle(color: Colors.grey)),
          onChanged: (value) => newValue = value,
        ),
        actions: [
          //Cancel button
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel')),

          //Save button
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(newValue);
              },
              child: const Text('Save')),
        ],
      ),
    );

    //update in Firestore
    if (newValue.trim().length > 0) {
      //only update if something is there in the textfield
      await usersCollection.doc(currentUser!.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          title: const Text("Profile Page"),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;

              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  //profile pic
                  const Icon(
                    Icons.person,
                    size: 75,
                  ),
                  //user mail
                  Text(
                    currentUser!.email!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //user details
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //username
                  MyTextBox(
                    onPressed: () => editField('username', context),
                    text: userData['username'],
                    sectionName: 'User Name',
                  ),
                  //bio
                  MyTextBox(
                    onPressed: () => editField('bio', context),
                    text: userData['bio'],
                    sectionName: 'Bio',
                  ),

                  //user posts
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error ${snapshot.error}"),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
