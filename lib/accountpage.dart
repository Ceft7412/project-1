import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/modals/addresspage.dart';
import 'package:project/modals/agepage.dart';
import 'package:project/modals/contactnumberpage.dart';
import 'dart:ui';

import 'package:project/modals/emailpage.dart';
import 'package:project/modals/namepage.dart';
import 'package:project/modals/passwordpage.dart';
import 'package:project/utils.dart';

Widget labeledInputField(String label, VoidCallback? onTap) {
  return GestureDetector(
    onTap: onTap, // Calls the passed function when the row is tapped
    child: Card(
      elevation: 0.0, // Set elevation to 0 to remove shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0), // Set border radius if needed
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.black, size: 18),
          ],
        ),
      ),
    ),
  );
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final user = FirebaseAuth.instance.currentUser;
  final userid = FirebaseAuth.instance.currentUser!.uid;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String profilePicture = '';
  String firstname = '';
  String middlename = '';
  String lastname = '';
  int age = 0;
  int contact_number = 0;
  bool isLoading = true;
  Future<void> getUserInfo() async {
    try {
      // Reference to the Firestore collection (users)

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('User')
          .doc(userid) // Document ID is the user's UID
          .get();

      if (userDoc.exists) {
        // If the document exists, retrieve the data
        setState(() {
          profilePicture = userDoc.get('profilePicture') ?? '';
          firstname = userDoc.get('firstname') ?? '';
          middlename = userDoc.get('middlename') ?? '';
          lastname = userDoc.get('lastname') ?? '';
          age = userDoc.get('age') ?? 0;
          contact_number = userDoc.get('contact_number') ?? 0;
          isLoading = false;
        });
      } else {
        print("User document does not exist.");
        setState(() {
          isLoading = false; // Even if no data is found, stop loading
        });
      }
    } catch (e) {
      print("Error fetching user info: $e");
      setState(() {
        isLoading = false; // Stop loading if there is an error
      });
    }
  }

  // void navigateToEmailPage() {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => EmailPage()));
  // }

  Future<void> navigateToNamePage() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NamePage()),
    );

    // If result is true, that means the name was updated, so refresh the user info
    if (result == true) {
      getUserInfo();
    }
  }

  Future<void> navigateToAgePage() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AgePage()),
    );

    if (result == true) {
      getUserInfo();
    }
  }

  void navigateToContactNumberPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ContactNumberPage()));
  }

  void navigateToPasswordPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PasswordPage()));
  }

  void selectPicture() async {
    File? selectedImage = await getImageFromGallery(context);
    if (selectedImage != null) {
      setState(() {
        isLoading = true;
      });
      final downloadURL = await uploadFileForUser(selectedImage);
      if (downloadURL != null) {
        await storeImageURLForUser(downloadURL);
      } else {
        print('Failed to upload image and get download URL.');
      }
    }
    print(selectedImage);
  }

  Future<void> storeImageURLForUser(String downloadURL) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final userDocRef =
          FirebaseFirestore.instance.collection('User').doc(userId);
      await userDocRef.update({'profilePicture': downloadURL});
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      getUserInfo();
    } catch (e) {
      print(e);
    }
  }

  void navigateToAddressPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AddressPage()));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Fetch user info when the widget is initialized
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 252, 252),
                  Color.fromARGB(255, 245, 252, 255),
                  Color.fromARGB(255, 246, 252, 255),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.1), // Adjust opacity as needed
            ),
          ),
          Container(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Edit Profile',
                        //   style: TextStyle(
                        //     fontSize: 26,
                        //     fontWeight: FontWeight.bold,
                        //     color: Color.fromARGB(255, 8, 168, 231),
                        //   ),
                        // ),
                        // SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, left: 10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.black),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 255, 121, 121),
                                    Color.fromARGB(255, 8, 168, 231),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                  radius: 120,
                                  backgroundImage: NetworkImage(profilePicture),
                                  backgroundColor: Colors.grey[200],
                                ),
                              ),
                            ),

                            // Positioned(
                            //   bottom: 0,
                            //   right: 30,
                            //   child: GestureDetector(
                            //     onTap: () {},
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         color: Colors.white,
                            //       ),
                            //       padding: const EdgeInsets.all(4),
                            //       child: Icon(Icons.edit,
                            //           size: 20, color: Color.fromARGB(255, 8, 168, 231)),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(firstname + ' ' + lastname,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text(
                          'KiddyCare',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 107, 107, 107)),
                        ),
                        SizedBox(height: 20),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal:
                                      16.0), // Adjust the margin as needed
                              child: Text(
                                'Basic information',
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(16.0),
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  labeledInputField("Name", navigateToNamePage),
                                  SizedBox(height: 10),
                                  labeledInputField(
                                      "Profile Picture", selectPicture),
                                  SizedBox(height: 10),
                                  labeledInputField("Age", navigateToAgePage),
                                  SizedBox(height: 10),
                                  labeledInputField(
                                      "Password", navigateToPasswordPage),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal:
                                      16.0), // Adjust the margin as needed
                              child: Text(
                                'Contact information',
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(16.0),
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  labeledInputField(
                                      "Phone", navigateToContactNumberPage),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal:
                                      16.0), // Adjust the margin as needed
                              child: Text(
                                'Address',
                                style: const TextStyle(
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(16.0),
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  labeledInputField(
                                      "Home", navigateToAddressPage),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     await FirebaseAuth.instance.signOut();
                        //   },
                        //   child: const Text('Sign Out'),
                        // ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
