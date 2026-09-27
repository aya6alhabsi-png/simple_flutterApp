import 'package:firebase2024/main.dart';
import 'package:flutter/material.dart';
import 'AdminDetailScreen.dart';
import 'PetFormScreen.dart';
import 'PetDetailScreen.dart';
import 'database.dart';
import 'main.dart';

class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key, required this.title});

  final String title;

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown[400],
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
              // Make sure the 'quantity' is treated as a double
              double pricePerQuantity = flower['quantity'] is double
                  ? flower['quantity']
                  : double.tryParse(flower['quantity'].toString()) ?? 0.0;
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
                    'Origin: ${flower['origin']} -\n Price Per quantity: ${pricePerQuantity.toStringAsFixed(2)} OMR',
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.brown.shade700,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PetFormScreen(flowerData: flower),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          DatabaseServer().deleteFlower(flower['id']).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Flower deleted successfully'),
                                backgroundColor: Colors.brown,
                              ),
                            );
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to delete flower: $error'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // When the card is tapped, navigate to PetDetailScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminDetailScreen(
                          flowerData: flower,
                          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
                          userId: '',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PetFormScreen()),
          );
        },
        tooltip: 'Register New Flower',
        child: const Icon(Icons.add),
      ),
    );
  }
}
