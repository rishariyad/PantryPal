import 'package:cloud_firestore/cloud_firestore.dart';

class PantryService {
  final CollectionReference pantryCollection =
      FirebaseFirestore.instance.collection('pantry');

  // Add new pantry item
  Future addPantryItem(String userId, String itemName, int quantity) async {
    return await pantryCollection.add({
      'userId': userId,
      'itemName': itemName,
      'quantity': quantity,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  // Update pantry item quantity
  Future updatePantryItem(String documentId, int quantity) async {
    return await pantryCollection.doc(documentId).update({
      'quantity': quantity,
    });
  }

  // Get user's pantry items
  Stream<List<PantryItem>> getUserPantryItems(String userId) {
    return pantryCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data()
                  as Map<String, dynamic>?; // Cast to Map<String, dynamic>?
              if (data != null) {
                return PantryItem.fromFirestore(data, doc.id);
              } else {
                throw Exception("Document data is null");
              }
            }).toList());
  }
}

class PantryItem {
  final String itemName;
  final int quantity;
  final String documentId;

  PantryItem(
      {required this.itemName,
      required this.quantity,
      required this.documentId});

  factory PantryItem.fromFirestore(
      Map<String, dynamic> data, String documentId) {
    return PantryItem(
      itemName: data['itemName'],
      quantity: data['quantity'],
      documentId: documentId,
    );
  }
}
