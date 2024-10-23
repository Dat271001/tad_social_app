import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tad_social_media_app/components/my_drawer.dart';
import 'package:tad_social_media_app/components/my_list_tile.dart';
import 'package:tad_social_media_app/components/my_post_button.dart';
import 'package:tad_social_media_app/components/my_textfield.dart';
import 'package:tad_social_media_app/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TextEditingController newPostController = TextEditingController();
  final FirestoreDatabase database = FirestoreDatabase();
  void postMessage(){
    if (newPostController.text.isNotEmpty){
      String message = newPostController.text;
      database.addPost(message);
    }
    newPostController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("S O C I A L"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
        drawer: MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(child: MyTextfield(hintText: "Today, how are you?", obscureText: false, controller: newPostController )),
                MyPostButton(onTap: postMessage),
              ],
            ),
          ),
          StreamBuilder(
              stream: database.getPostsStream(),
              builder: (context,snapshot){
                if (snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final posts = snapshot.data!.docs;
                if (snapshot.data == null || posts.isEmpty){
                  return const Center(
                    child: Padding(
                        padding: EdgeInsets.all(25),
                      child: Text("No posts.. Post something"),
                    ),
                  );
                }
                return Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context,index){
                        final post = posts[index];
                        String message = post['PostMessage'];
                        String userEmail = post['UserEmail'];
                        Timestamp timestamp = post['TimeStamp'];
                        return MyListTile(title: message,subtitle: userEmail, timestamp: timestamp,);
                      }
                    ),
                );
              }
          ),
        ],
      ),
    );
  }
}