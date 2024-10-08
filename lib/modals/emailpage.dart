// import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/login.dart';

// class EmailPage extends StatefulWidget {
//   const EmailPage({super.key});

//   @override
//   State<EmailPage> createState() => _EmailPageState();
// }

// class _EmailPageState extends State<EmailPage> {
//   final user = FirebaseAuth.instance.currentUser;
//   final userid = FirebaseAuth.instance.currentUser!.uid;
//   TextEditingController emailController = TextEditingController();

//   // When the page is first opened, it is loading
//   bool isLoading = true;

//   // This is called when the screen is first initialized
//   @override
//   void initState() {
//     super.initState();
//     getUserInfo(); // Fetch user info when the screen is initialized
//   }

//   // Fetch user info and set the initial values of TextEditingControllers
//   Future<void> getUserInfo() async {
//     try {
//       DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance.collection('User').doc(userid).get();

//       if (userDoc.exists) {
//         setState(() {
//           // Set the initial value of the TextFields
//           emailController.text = userDoc.get('email') ?? '';

//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> updateEmail() async {
//     if (emailController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Email is required')),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       // Reload the user to get the most up-to-date information
//       await user!.reload();
//       User? updatedUser =
//           FirebaseAuth.instance.currentUser; // Get the updated user

//       // Check if the email is verified
//       if (!updatedUser!.emailVerified) {
//         // Send verification email
//         await updatedUser.sendEmailVerification();
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content:
//                   Text('Verification email sent! Please check your inbox.')),
//         );
//         setState(() {
//           isLoading = false; // Stop loading as we sent the email
//         });
//         return; // Exit since we can't update the email yet
//       }

//       // Proceed to update the email if it is verified
//       await updatedUser.updateEmail(emailController.text);

//       // Update the email in Firestore (if you're storing it there)
//       await FirebaseFirestore.instance.collection('User').doc(userid).update({
//         'email': emailController.text, // Storing the updated email in Firestore
//       });

//       setState(() {
//         isLoading = false;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Email updated successfully!')),
//       );

//       // Sign out the user and navigate to login page
//       await FirebaseAuth.instance.signOut();
//       signOutAndNavigate(context);
//     } catch (e) {
//       setState(() {
//         isLoading = false; // Stop loading in case of error
//       });

//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update email: $e')),
//       );
//     }
//   }

//   void signOutAndNavigate(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => Login()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Color.fromARGB(255, 255, 252, 252),
//                   Color.fromARGB(255, 245, 252, 255),
//                   Color.fromARGB(255, 246, 252, 255),
//                 ],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//             ),
//           ),
//           BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//             child: Container(
//               color: Colors.black.withOpacity(0.1),
//             ),
//           ),
//           isLoading
//               ? Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20, left: 10.0),
//                       child: Align(
//                         alignment: Alignment.topLeft,
//                         child: IconButton(
//                           icon:
//                               const Icon(Icons.arrow_back, color: Colors.black),
//                           onPressed: () {
//                             Navigator.of(context).pop(true);
//                           },
//                         ),
//                       ),
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.only(top: 15, left: 10),
//                       child: Text(
//                         'Email',
//                         style: TextStyle(
//                           fontSize: 30.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Expanded(
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   margin: const EdgeInsets.all(16.0),
//                                   padding: const EdgeInsets.all(12.0),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.5),
//                                       ),
//                                     ],
//                                   ),
//                                   child: TextField(
//                                     controller: emailController,
//                                     decoration: const InputDecoration(
//                                       labelText: 'Email',
//                                       labelStyle: TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         color:
//                                             Color.fromARGB(255, 116, 116, 116),
//                                       ),
//                                       focusedBorder: InputBorder.none,
//                                       enabledBorder: InputBorder.none,
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   margin: EdgeInsets.only(left: 16.0),
//                                   child: Text(
//                                     'If you change your age, it will be updated on your profile.',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           updateEmail(); // Update user info in Firestore
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromARGB(255, 8, 168, 231),
//                           minimumSize: Size(double.infinity, 50),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(
//                                 14), // Adjust the value for more/less circular shape
//                           ),
//                         ),
//                         child: Text('Save Changes',
//                             style:
//                                 TextStyle(fontSize: 20, color: Colors.white)),
//                       ),
//                     ),
//                   ],
//                 )
//         ],
//       ),
//     );
//   }
// }
