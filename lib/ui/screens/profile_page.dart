// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fypapp/constants.dart';
import 'package:fypapp/ui/screens/widgets/profile_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  /// Fetch the user's name from Firestore
  Future<String?> _fetchUserName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        return snapshot['name'] as String?;
      } catch (e) {
        debugPrint('Error fetching user name: $e');
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        width: size.width,
        child: FutureBuilder<String?>(
          future: _fetchUserName(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            String userName = snapshot.data ?? 'Unknown User';

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundImage: ExactAssetImage('assets/images/chaewon.jpg'),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Constants.primaryColor.withOpacity(.5),
                      width: 5.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  userName,
                  style: TextStyle(
                    color: Constants.blackColor,
                    fontSize: 20,
                  ),
                ),
                Text(
                  user?.email ?? 'No Email Available',
                  style: TextStyle(
                    color: Constants.blackColor.withOpacity(.3),
                  ),
                ),
                const Spacer(),
                ProfileWidget(
                  icon: Icons.logout,
                  title: 'Log Out',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
