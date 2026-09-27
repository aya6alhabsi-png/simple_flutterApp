import 'package:firebase2024/main.dart';
import 'package:flutter/material.dart';
import 'PetDetailScreen.dart';
import 'database.dart';

class UserPetListScreen extends StatefulWidget {
  const UserPetListScreen({super.key, required this.title});

  final String title;

  @override
  State<UserPetListScreen> createState() => _UserPetListScreenState();
}

class _UserPetListScreenState extends State<UserPetListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown[700],
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(  // Assuming you're using Firebase or Firestore
        stream: DatabaseServer().getFlower(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.brown.shade600, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var flower = snapshot.data![index];

              // Parse and format the price per person (ensure it's treated as a float)
              double pricePerQuantity = flower['quantity'] != null
                  ? flower['quantity'].toDouble() // Convert to double if it's not already
                  : 0.0;
              String formattedPrice = pricePerQuantity.toStringAsFixed(2); // Format as a float with two decimal places

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  title: Text(
                    flower['name'],
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                  subtitle: Text(
                    'Origin: ${flower['origin']} -\n price Per Quantity: $formattedPrice OMR',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.brown.shade600,
                    ),
                  ),
                  leading: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('images/${flower['imageName']}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    // When the card is tapped, navigate to PetDetailScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetDetailScreen(
                          flowerData: flower,
                          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
                          userId: '', // Pass userId if needed
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
