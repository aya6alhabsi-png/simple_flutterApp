import 'package:flutter/material.dart';
import 'PetListScreen.dart';
import 'UserRegister.dart';
import 'main.dart';


class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Ensure the container fills the entire screen
        width: double.infinity, // Ensures the container takes up full width
        height: double.infinity, // Ensures the container takes up full height
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://e1.pxfuel.com/desktop-wallpaper/1/175/desktop-wallpaper-botanical-illustration-by-ryn-frank-www-rynfrank-co-uk-aesthetic-drawings-flowers.jpg'), // Background image URL
            fit: BoxFit.cover, // Ensures the image covers the whole screen
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Aligns the content to the top
          crossAxisAlignment: CrossAxisAlignment.center, // Centers the content horizontally
          children: <Widget>[
            // Add a small space from the top
            const SizedBox(height: 30), // Adjust this value as needed

            // Welcome Text (Positioned at the top)
            Text(
              'Flowers',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.brown[400],
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black.withOpacity(0.7),
                    offset: const Offset(2.0, 2.0),
                  ),
                ],
              ),
              textAlign: TextAlign.center, // Center-aligns the text
            ),
            const SizedBox(height: 15),
            const Text(
              'Welcome To Flowers',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Spacer(), // Pushes the content below to the bottom

            // Get Started Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  LoginPage(), // Navigating to RegistrationPage
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[700], // Button color
                padding: const EdgeInsets.symmetric(
                    horizontal: 70, vertical: 20), // Button padding
                textStyle: const TextStyle(
                  fontSize: 20, // Button text size
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(height: 80), // Space below the button
          ],
        ),
      ),
    );
  }
}
