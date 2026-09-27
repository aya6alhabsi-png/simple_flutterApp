import 'package:firebase2024/Welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'AdminLoginPage.dart';
import 'PetFormScreen.dart';
import 'PetListScreen.dart';
import 'UserPetListScreen.dart';
import 'UserRegister.dart';
import 'AddAdmin.dart';  // Assuming you have an AddAdmin screen.

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Firebase initialization
  await _initializeNotifications();  // Initialize notifications
  runApp(const MyApp());
}

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = const InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);  // Notification initialization
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Welcome(),  // Default welcome screen
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Create a GlobalKey to validate the form
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    // Validate the form
    if (_formKey.currentState?.validate() ?? false) {
      // If validation passes, proceed with login logic
      try {
        // Attempt to sign in
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Retrieve user data from Firebase Realtime Database
        User? user = userCredential.user;
        if (user != null) {
          final userId = user.uid;
          final userDataRef = FirebaseDatabase.instance.ref().child('users').child(userId);

          // Get user data
          userDataRef.get().then((snapshot) {
            if (snapshot.exists) {
              // Navigate to UserPetListScreen after successful login
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UserPetListScreen(title: 'Explore Your Favorite flowers')),
              );
            } else {
              // Handle the case if the user data is not found
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User data not found. Please try again.')),
              );
            }
          }).catchError((error) {
            // Handle error if the data fetching fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to fetch user data: $error')),
            );
          });
        }
      } on FirebaseAuthException catch (e) {
        // Handle sign in errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign in: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white70),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Attach the form key here
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Optionally, add more validation like email format check
                  if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[500],
                  minimumSize: const Size(400, 50),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserRegister()), // Navigate to UserRegister screen
                  );
                },
                child: Text(
                  "Regist New",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.brown[700],
                  ),
                ),
              ),
              const SizedBox(height: 20), // Space between buttons
              ElevatedButton(
                onPressed: () {
                  // Navigate to Admin Login Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLoginPage()), // Navigate to AdminLoginPage
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[700], // Color for Admin button
                  minimumSize: const Size(400, 50),
                ),
                child: const Text(
                  "Admin Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
