import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final user = FirebaseAuth.instance.currentUser;
  final userid = FirebaseAuth.instance.currentUser!.uid;

  // Controllers for each TextField
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  // When the page is first opened, it is loading
  bool isLoading = true;

  // This is called when the screen is first initialized
  @override
  void initState() {
    super.initState();
    getUserInfo(); // Fetch user info when the screen is initialized
  }

  // Fetch user info and set the initial values of TextEditingControllers
  Future<void> getUserInfo() async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('User').doc(userid).get();

      if (userDoc.exists) {
        setState(() {
          // Set the initial value of the TextFields
          firstNameController.text = userDoc.get('firstname') ?? '';
          middleNameController.text = userDoc.get('middlename') ?? '';
          lastNameController.text = userDoc.get('lastname') ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to update user info in Firestore
  Future<void> updateUserInfo() async {
    if (firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('First name is required')),
      );
      return; // Exit if validation fails
    }
    if (lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Surname is required')),
      );
      return; // Exit if validation fails
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Update Firestore with the new name data
      await FirebaseFirestore.instance.collection('User').doc(userid).update({
        'firstname': firstNameController.text,
        'middlename': middleNameController.text,
        'lastname': lastNameController.text,
      });

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
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
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 10),
                      child: Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text Fields Container
                            Container(
                              margin: EdgeInsets.all(16.0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
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
                                  // First name TextField
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: firstNameController,
                                      decoration: InputDecoration(
                                        labelText: 'First name',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 116, 116, 116),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 211, 211, 211),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Middle name TextField
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: middleNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Middle name',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 116, 116, 116),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 211, 211, 211),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Last name TextField
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: lastNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Surname',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 116, 116, 116),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 211, 211, 211),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                            // Additional Text Below Text Fields
                            Container(
                              margin: EdgeInsets.only(left: 16.0),
                              child: Text(
                                'If you change your name, it will be updated on your profile.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Button at the Bottom
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          updateUserInfo();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 8, 168, 231),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text('Save Changes',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
