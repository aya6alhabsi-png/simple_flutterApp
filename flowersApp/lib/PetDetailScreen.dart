import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';

import 'ThanksPage.dart';

class PetDetailScreen extends StatefulWidget {
  final Map<String, dynamic> flowerData;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final String userId; // Assume userId is passed to the screen

  const PetDetailScreen({
    super.key,
    required this.flowerData,
    required this.flutterLocalNotificationsPlugin,
    required this.userId,
  });

  @override
  _PetDetailScreenState createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  int numberOfPersons = 1; // Default value for the number of persons
  double totalPrice = 0.0;

  // Declare numberOfFlowers as an int variable
  int numberOfFlowers = 1;  // Initialize with a default value of 1

  // Update the total price based on the number of persons
  void _updateTotalPrice() {
    setState(() {
      // Ensure flower['quantity'] is treated as a double
      double pricePerPerson = widget.flowerData['quantity'] is double
          ? widget.flowerData['quantity']
          : double.tryParse(widget.flowerData['quantity'].toString()) ?? 0.0;
      totalPrice = pricePerPerson * numberOfPersons;
    });
  }

  // Show notification
  void _showPetNotification(BuildContext context) async {
    final String flowerName = widget.flowerData['name'];
    final String flowerOrigin = widget.flowerData['origin'];

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'flower_channel_id',
      'Flower Notifications',
      channelDescription: 'Notification channel for flower details',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // Modified notification message to indicate packageflowers was added successfully
    await widget.flutterLocalNotificationsPlugin.show(
      0,
      'Flower added successfully :)',
      'You have successfully placed an order for $flowerName from $flowerOrigin. Total Price: ${totalPrice.toStringAsFixed(2)} OMR',
      platformChannelSpecifics,
      payload: 'Flower details payload',
    );
  }

  // Add the order to the Firebase database
  void _addOrderToFirebase() {
    final DatabaseReference ordersRef =
    FirebaseDatabase.instance.ref().child("orders"); // Updated to ref()

    String orderId = ordersRef.push().key ?? "order${DateTime.now().millisecondsSinceEpoch}";

    ordersRef.child(orderId).set({
      'orderId': orderId,
      'userId': widget.userId,
      'flowerId': widget.flowerData['id'],
      'numberOfFlowers': numberOfFlowers, // Use the correct numberOfFlowers
      'totalPrice': totalPrice,
      'orderDate': DateTime.now().toIso8601String(),
      'status': 'Pending',
    }).then((_) {
      // After order is added, show success notification
      _showPetNotification(context);

      // Navigate to the ThanksPage after placing the order
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThanksPage(
            flowerName: widget.flowerData['name'],
            totalPrice: totalPrice,
          ),
        ),
      );
    }).catchError((error) {
      // Handle error here (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error placing order: $error")),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTotalPrice(); // Initialize total price on screen load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flowerData['name'],style: const TextStyle(color: Colors.white70),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('images/${widget.flowerData['imageName']}'),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: ${widget.flowerData['name']}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Origin: ${widget.flowerData['origin']}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.brown.shade600,
              ),
            ),
            // Ensure price per person is displayed with two decimal places
            Text(
              'Price per quantity: ${widget.flowerData['quantity'].toStringAsFixed(2)} OMR',
              style: TextStyle(
                fontSize: 20,
                color: Colors.brown.shade600,
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              'Enter Number of Flowers quantity: ',
              style: TextStyle(
                fontSize: 22,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // Dropdown for selecting the number of persons
            Container(
              width: 150.0, // Set the width to your desired value
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.brown, // Border color
                  width: 2.0, // Border width
                ),
                borderRadius: BorderRadius.circular(10), // Optional: for rounded corners
              ),
              padding: EdgeInsets.symmetric(horizontal: 12), // Optional: to add some padding inside the container
              child: DropdownButton<int>(
                value: numberOfFlowers, // Use the correct value
                onChanged: (int? newValue) {
                  setState(() {
                    numberOfFlowers = newValue!; // Update the numberOfFlowers
                    _updateTotalPrice(); // Update the total price
                  });
                },
                items: List.generate(10, (index) => index + 1).map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
                isExpanded: true, // Optional: makes the dropdown fill the available width
                underline: SizedBox(), // Hides the default underline of the dropdown
              ),
            ),

            const SizedBox(height: 10),

            // Display the total price with two decimal places
            Text(
              'Total Price: ${totalPrice.toStringAsFixed(2)} OMR',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _addOrderToFirebase(); // Add order and show notification
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown[500], // White text color
              ),
              child: const Text(
                'Place Order',
                style: TextStyle(fontSize: 19),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Back to the list
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown[500], // White text color
              ),
              child: const Text(
                'Back to List',
                style: TextStyle(fontSize: 19),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
