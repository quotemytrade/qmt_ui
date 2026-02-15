// // Example Usage of Firebase Authentication in Your App

// // 1. BASIC USAGE IN WIDGETS

// // Example 1: Show Login Dialog from any button
// import 'package:quotemytrade/widgets/auth/login_dialog.dart';

// onPressed: () {
//   showDialog(
//     context: context,
//     builder: (context) => const LoginDialog(),
//   );
// }

// // Example 2: Check if user is logged in
// final currentUser = ref.watch(currentUserProvider);
// currentUser.when(
//   data: (user) {
//     if (user != null) {
//       print('User is logged in: ${user.email}');
//     } else {
//       print('User is not logged in');
//     }
//   },
//   loading: () => CircularProgressIndicator(),
//   error: (error, stack) => Text('Error: $error'),
// );

// // Example 3: Sign Out User
// ElevatedButton(
//   onPressed: () async {
//     await ref.read(signOutProvider(null).future);
//     // User will be signed out
//   },
//   child: Text('Sign Out'),
// );

// // 2. AUTHENTICATION SERVICE DIRECT USAGE

// import 'package:quotemytrade/core/services/auth_service.dart';

// final authService = AuthService();

// // Sign in with Google
// try {
//   final userCredential = await authService.signInWithGoogle();
//   print('Successfully signed in: ${userCredential?.user?.email}');
// } catch (e) {
//   print('Google sign-in failed: $e');
// }

// // Sign in with Apple
// try {
//   final userCredential = await authService.signInWithApple();
//   print('Successfully signed in: ${userCredential?.user?.email}');
// } catch (e) {
//   print('Apple sign-in failed: $e');
// }

// // Sign in with Email
// try {
//   final userCredential = await authService.signInWithEmail(
//     'user@example.com',
//     'password123',
//   );
//   print('Email sign-in successful');
// } catch (e) {
//   print('Email sign-in failed: $e');
// }

// // Sign up with Email
// try {
//   final userCredential = await authService.signUpWithEmail(
//     'newuser@example.com',
//     'password123',
//     'John Doe',
//   );
//   print('Account created successfully');
// } catch (e) {
//   print('Sign-up failed: $e');
// }

// // Sign out
// await authService.signOut();

// // Reset password
// await authService.resetPassword('user@example.com');

// // 3. RIVERPOD PROVIDER USAGE

// // Watch authentication state
// final user = ref.watch(currentUserProvider);

// // Use Riverpod providers for signing in
// ref.read(signInWithGoogleProvider(null).future).then((_) {
//   // Successfully signed in
// });

// // 4. MONITORING AUTH STATE CHANGES

// // Listen to auth state changes
// ref.listen(currentUserProvider, (previous, next) {
//   next.whenData((user) {
//     if (user != null) {
//       print('User logged in: ${user.email}');
//     } else {
//       print('User logged out');
//     }
//   });
// });

// // 5. ERROR HANDLING

// try {
//   await ref.read(signInWithEmailProvider({
//     'email': email,
//     'password': password,
//   }).future);
// } on FirebaseAuthException catch (e) {
//   switch (e.code) {
//     case 'user-not-found':
//       print('No user found with this email');
//       break;
//     case 'wrong-password':
//       print('Wrong password provided');
//       break;
//     case 'weak-password':
//       print('Password is too weak');
//       break;
//     case 'email-already-in-use':
//       print('Email already exists');
//       break;
//     default:
//       print('Authentication error: ${e.message}');
//   }
// }

// // 6. CUSTOM LOGIN WIDGET

// class MyLoginButton extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return ElevatedButton(
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (context) => const LoginDialog(),
//         );
//       },
//       child: const Text('Sign In'),
//     );
//   }
// }

// // 7. PROTECTING ROUTES BASED ON AUTH STATE

// // In your router configuration:
// GoRoute(
//   path: '/protected-page',
//   builder: (context, state) {
//     return Consumer(
//       builder: (context, ref, child) {
//         final user = ref.watch(currentUserProvider);
//         return user.when(
//           data: (user) {
//             if (user != null) {
//               return const ProtectedPage();
//             } else {
//               return const Scaffold(
//                 body: Center(
//                   child: Text('Please log in'),
//                 ),
//               );
//             }
//           },
//           loading: () => const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           ),
//           error: (error, stack) => Scaffold(
//             body: Center(
//               child: Text('Error: $error'),
//             ),
//           ),
//         );
//       },
//     );
//   },
// );
