import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tad_social_media_app/components/my_back_button.dart';

class ProfilePage extends StatelessWidget {
   ProfilePage({super.key});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String,dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance.collection("Users").doc(currentUser!.email).get();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
          future: getUserDetails(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (snapshot.hasError){
              return Text("Error: ${snapshot.error}");
            }
            else if (snapshot.hasData){
              Map<String,dynamic>? user = snapshot.data!.data();

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 25,),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(24)
                      ),
                      padding: const EdgeInsets.all(25),
                      child: Icon(Icons.person,size: 64),
                    ),
                    const SizedBox(height: 25,),
                    Text(
                      user!['username'],
                      style:  TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10,),

                    Text(
                      user['email'],
                      style:  TextStyle(
                        color: Colors.grey[600],

                      ),
                    ),
                  ],
                ),
              );
            }
            else {
              return const Text("No data");
            }
          },
      ),
    );
  }
}
