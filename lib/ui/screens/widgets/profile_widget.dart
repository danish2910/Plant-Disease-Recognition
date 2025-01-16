import 'package:flutter/material.dart';
import 'package:fypapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import FirebaseAuth
import 'package:fypapp/ui/signin_page.dart';  // Import your Sign-In page

class ProfileWidget extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileWidget({
    super.key, required this.icon, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Log Out') {  // Check if the title is 'Log Out'
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm Log Out"),
                content: const Text("Are you sure you want to log out?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((_) {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignIn()),
                        );
                      }).catchError((e) {
                        print("Error signing out: $e");
                      });
                    },
                    child: const Text("Log Out"),
                  ),
                ],
              );
            },
          );
        } else {
          // You can handle other taps here if needed
          print('Tapped on: $title');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Constants.blackColor.withOpacity(.5),
                  size: 24.0,
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: Constants.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Constants.blackColor.withOpacity(.4),
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}
