// import 'package:flutter/material.dart';
// import '../authentication/authentication.dart';
// import '../constants/custom_color.dart';
// import '../widgets/google_signin.dart';

// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.firebaseNavy,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: 16.0,
//             right: 16.0,
//             bottom: 20.0,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Row(),
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: 20),
//                     Text(
//                       'FlutterFire',
//                       style: TextStyle(
//                         color: AppColors.firebaseYellow,
//                         fontSize: 40,
//                       ),
//                     ),
//                     Text(
//                       'Authentication',
//                       style: TextStyle(
//                         color: AppColors.firebaseOrange,
//                         fontSize: 40,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               FutureBuilder(
//                 future: Authentication.initializeFirebase(context: context),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Text('Error initializing Firebase');
//                   } else if (snapshot.connectionState == ConnectionState.done) {
//                     return GoogleSignInButton();
//                   }
//                   return CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       AppColors.firebaseOrange,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }