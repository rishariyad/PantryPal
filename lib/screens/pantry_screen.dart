import 'package:flutter/material.dart';
import '/services/pantry_service.dart';

class PantryScreen extends StatefulWidget {
  @override
  _PantryScreenState createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pantry'),
      ),
      body: Container(
        color: Colors.black, // Dark background color
        child: Column(
          children: [
            // Form to add a new item
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Add New Item',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text color
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(_itemNameController, 'Item Name'),
                  SizedBox(height: 10),
                  _buildTextField(
                    _quantityController,
                    'Quantity',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      String itemName = _itemNameController.text.trim();
                      int quantity =
                          int.tryParse(_quantityController.text.trim()) ?? 0;
                      if (itemName.isNotEmpty && quantity > 0) {
                        await PantryService()
                            .addPantryItem('user-id-here', itemName, quantity);
                        _itemNameController.clear();
                        _quantityController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[800], // Button color
                      foregroundColor: Colors.white, // Text color
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600), // Text style
                    ),
                    child: Text('Add Item'),
                  ),
                ],
              ),
            ),

            // Display the list of pantry items
            Expanded(
              child: StreamBuilder<List<PantryItem>>(
                stream: PantryService().getUserPantryItems(
                    'user-id-here'), // Replace with actual user ID
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('No items in your pantry',
                            style: TextStyle(color: Colors.white)));
                  }

                  List<PantryItem> pantryItems = snapshot.data!;
                  return ListView.builder(
                    itemCount: pantryItems.length,
                    itemBuilder: (context, index) {
                      PantryItem item = pantryItems[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        color: Colors.grey[850], // Darker card background
                        child: ListTile(
                          title: Text(
                            item.itemName,
                            style: TextStyle(
                                color: Colors
                                    .white), // White text color for item name
                          ),
                          subtitle: Text(
                            'Quantity: ${item.quantity}',
                            style: TextStyle(
                                color: Colors.grey[
                                    400]), // Lighter text color for quantity
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit,
                                color: Colors.blue), // Edit icon color
                            onPressed: () {
                              // Update quantity logic (optional)
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create styled text fields
  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[800], // Dark background for text field
        labelStyle: TextStyle(color: Colors.white), // White label text
      ),
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white), // White text color for input
    );
  }
}
