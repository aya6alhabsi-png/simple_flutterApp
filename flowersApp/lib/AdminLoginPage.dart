import 'package:firebase2024/PetListScreen.dart';
import 'package:flutter/material.dart';
import 'PetFormScreen.dart'; // Ensure you have this page in your project

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Hardcoded admin credentials
  final String adminEmail = "admin@gmail.com";
  final String adminPassword = "admin123";

  // Create a GlobalKey to validate the form
  final _formKey = GlobalKey<FormState>();

  void _login() {
    // Validate the form
    if (_formKey.currentState?.validate() ?? false) {
      // Get entered email and password
      String enteredEmail = emailController.text;
      String enteredPassword = passwordController.text;

      // Check if entered credentials match the hardcoded admin credentials
      if (enteredEmail == adminEmail && enteredPassword == adminPassword) {
        // Navigate to PetListScreen if credentials match
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PetListScreen(title: 'Explore Your Favorite flowers'),
          ),
        );
      } else {
        // Show an error message if credentials don't match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid admin credentials')),
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
          "Admin Login",
          style: TextStyle(color: Colors.white70),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Attach the form key here
          child: Column(
            children: <Widget>[
              // Email input
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

              // Password input
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

              // Login button
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
            ],
          ),
        ),
      ),
    );
  }
}
