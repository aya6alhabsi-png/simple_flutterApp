import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'main.dart'; // Ensure this import points to your `main.dart` file.

class UserRegister extends StatefulWidget {
  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();

  bool isLoading = false;

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Create the user in Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Store additional user details in Firebase Realtime Database
        final userReference = FirebaseDatabase.instance.ref().child('users').child(userCredential.user!.uid);
        await userReference.set({
          'fullName': fullNameController.text.trim(),
          'email': emailController.text.trim(),
          'address': addressController.text.trim(),
          'contactNo': contactNoController.text.trim(),
          'role': 'user', // Default role for newly registered users
        });

        // Navigate to LoginPage after successful registration
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: ${e.message}')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text(
          "Register New User",
          style: TextStyle(color: Colors.white70),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Please enter your full name" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                validator: (value) =>
                value!.isEmpty || !value.contains('@') ? "Enter a valid email" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                obscureText: true,
                validator: (value) =>
                value!.isEmpty || value.length < 6 ? "Password must be at least 6 characters" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: "Address", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? "Please enter your address" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: contactNoController,
                decoration: const InputDecoration(labelText: "Contact No", border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Please enter your contact number" : null,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator() // Show loading indicator during registration
                  : ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[500],
                  minimumSize: const Size(400, 50), // Button dimensions
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 19, // Text size
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
