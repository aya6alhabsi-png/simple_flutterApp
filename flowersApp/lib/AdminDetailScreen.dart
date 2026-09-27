import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AdminDetailScreen extends StatelessWidget {
  final Map<String, dynamic> flowerData;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  const AdminDetailScreen({
    super.key,
    required this.flowerData,
    required this.flutterLocalNotificationsPlugin,
    required String userId,
  });

  @override
  Widget build(BuildContext context) {
    // Convert the 'quantity' to double and format it to two decimal places
    double pricePerPerson = flowerData['quantity'] != null
        ? flowerData['quantity'].toDouble() // Convert to double if it's not already
        : 0.0;
    String formattedPrice = pricePerPerson.toStringAsFixed(2); // Format as a float with two decimal places

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown[400], // Brown AppBar color
        title: Text(
          flowerData['name'],
          style: TextStyle(color: Colors.white70), // White text color for contrast
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('images/${flowerData['imageName']}'),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: ${flowerData['name']}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown, // Brown color for text
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Origin: ${flowerData['origin']}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.brown.shade600,
              ),
            ),
            Text(
              'Price per person: $formattedPrice OMR',
              style: TextStyle(
                fontSize: 20,
                color: Colors.brown.shade600,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[500], // Darker brown for the "Back to List" button
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Back to List',
                style: TextStyle(color: Colors.white, fontSize: 19),
              ), // White text
            ),
          ],
        ),
      ),
    );
  }
}
