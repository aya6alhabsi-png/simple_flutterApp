import 'package:flutter/material.dart';

class ThanksPage extends StatelessWidget {
  final String flowerName;
  final double totalPrice;

  const ThanksPage({
    super.key,
    required this.flowerName,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thank You',style: TextStyle(color: Colors.white70),),
        backgroundColor: Colors.brown[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              'Thank you for your order!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You have successfully placed an order for $flowerName.',
              style: TextStyle(
                fontSize: 20,
                color: Colors.brown.shade600,
              ),
              textAlign: TextAlign.center, // Center-align the text
            ),
            const SizedBox(height: 10),
            Text(
              'Total Price: ${totalPrice.toStringAsFixed(2)} OMR',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst); // Navigate back to the main screen
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.brown[500],
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(fontSize: 19),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
