import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final user = FirebaseAuth.instance.currentUser;
  final userid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController addressController = TextEditingController();

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
          addressController.text = userDoc.get('address') ?? '';

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

  Future<void> updateUserInfo() async {
    if (addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Home address is required')),
      );
      return; // Exit if validation fails
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Update Firestore with the new name data
      await FirebaseFirestore.instance.collection('User').doc(userid).update({
        'address': addressController.text,
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
            decoration: const BoxDecoration(
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
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15, left: 10),
                      child: Text(
                        'Address',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(16.0),
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: addressController,
                                    decoration: const InputDecoration(
                                      labelText: 'Home Address',
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color.fromARGB(255, 116, 116, 116),
                                      ),
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'If you change your address, it will be updated on your profile.',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          updateUserInfo(); // Update user info in Firestore
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 8, 168, 231),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                14), // Adjust the value for more/less circular shape
                          ),
                        ),
                        child: Text('Save Changes',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
