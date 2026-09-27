import 'package:flutter/material.dart';
import 'PetListScreen.dart';
import 'database.dart';

class PetFormScreen extends StatefulWidget {
  final Map<String, dynamic>? flowerData;  // Optional parameter for editing a pet

  const PetFormScreen({super.key, this.flowerData});

  @override
  PetFormScreenState createState() => PetFormScreenState();
}

class PetFormScreenState extends State<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _flowerNameController = TextEditingController();
  final TextEditingController _flowerOriginController = TextEditingController();
  final TextEditingController _flowerQuantityController = TextEditingController();
  final TextEditingController _flowerImageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If pet data is passed, pre-fill the fields
    if (widget.flowerData != null) {
      _flowerNameController.text = widget.flowerData!['name'];
      _flowerOriginController.text = widget.flowerData!['origin'];
      _flowerQuantityController.text = widget.flowerData!['quantity'].toString();
      _flowerImageController.text = widget.flowerData!['imageName'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flowerData == null ? 'Register Flower' : 'Update Flower'),
        backgroundColor: Colors.brown[700],  // AppBar brown color
       ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // Flower Name
            TextFormField(
              controller: _flowerNameController,
              decoration: const InputDecoration(
                labelText: 'Flower Name',
                labelStyle: TextStyle(color: Colors.brown),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please enter the flower name';
                } else if (val.length < 3) {
                  return 'Flower name should be at least 3 characters';
                } else if (RegExp(r'^[0-9]+$').hasMatch(val)) {
                  return 'Flower name cannot be numeric';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Origin (Origin)
            TextFormField(
              controller: _flowerOriginController,
              decoration: const InputDecoration(
                labelText: 'Origin',
                labelStyle: TextStyle(color: Colors.brown),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please enter the Origin';
                } else if (RegExp(r'^[0-9]+$').hasMatch(val)) {
                  return 'Origin name cannot be numeric';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Price per Quantity (Quantity)
            TextFormField(
              controller: _flowerQuantityController,
              decoration: const InputDecoration(
                labelText: 'Price per quantity',
                labelStyle: TextStyle(color: Colors.brown),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true), // Allow decimal input
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please enter price per quantity of flowers';
                }

                final parsedValue = double.tryParse(val);
                if (parsedValue == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Image Name (Flower Image)
            TextFormField(
              controller: _flowerImageController,
              decoration: const InputDecoration(
                labelText: 'Flower Image Name',
                labelStyle: TextStyle(color: Colors.brown),
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please enter an image name';
                } else if (RegExp(r'^[0-9]+$').hasMatch(val)) {
                  return 'Image name cannot be numeric';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Register or Update Button
            ElevatedButton(
              onPressed: _registerOrUpdateFlower,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[600],  // Button brown color
                minimumSize: const Size(double.infinity, 50),  // Full width button
              ),
              child: Text(
                widget.flowerData == null ? 'Register' : 'Update',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),

            // Return Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Return to flower list',
                style: TextStyle(
                  color: Colors.brown,  // TextButton brown color
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerOrUpdateFlower() async {
    if (_formKey.currentState!.validate()) {
      try {
        final flowerData = {
          'name': _flowerNameController.text,
          'origin': _flowerOriginController.text,
          'quantity': double.tryParse(_flowerQuantityController.text), // Parse as double
          'imageName': _flowerImageController.text,
        };

        if (widget.flowerData == null) {
          // Register a new pet
          await DatabaseServer().addFlower(flowerData);
        } else {
          // Update an existing pet
          await DatabaseServer().updateFlower(widget.flowerData!['id'], flowerData);
        }

        // Navigate to PetListScreen after successful registration or update
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PetListScreen(title: 'Explore Your Favorite Flowers')),
        );
      } catch (e) {
        // Show error message on failure
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  @override
  void dispose() {
    _flowerNameController.dispose();
    _flowerOriginController.dispose();
    _flowerQuantityController.dispose();
    _flowerImageController.dispose();
    super.dispose();
  }
}
