import 'package:cloud_firestore/cloud_firestore.dart';

class order {
  final String id;
  final String userId;
  final String fullName;
  final String contactNumber;
  final String emailAddress;
  final String billingAddress;
  final String productId;
  final String productName;
  final double productPrice;
  final int quantity;
  final double totalPrice;
  final double deliveryFee;
  final DateTime orderDate;
  final String farmerId;
  final String status;

  order({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.contactNumber,
    required this.emailAddress,
    required this.billingAddress,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.totalPrice,
    required this.deliveryFee,
    required this.orderDate,
    required this.farmerId,
    required this.status,
  });

  // Convert a Firestore document to an Order
  factory order.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return order(
      id: doc.id,
      userId: data['userId'],
      fullName: data['full_name'],
      contactNumber: data['contact_number'],
      emailAddress: data['email_address'],
      billingAddress: data['billing_address'],
      productId: data['product_id'],
      productName: data['product_name'],
      productPrice: data['product_price'].toDouble(),
      quantity: data['quantity'],
      totalPrice: data['total_price'].toDouble(),
      deliveryFee: data['delivery_fee'].toDouble(),
      orderDate: (data['order_date'] as Timestamp).toDate(),
      farmerId: data['farmer_id'],
      status: data['status'],
    );
  }

  // Convert an Order to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'full_name': fullName,
      'contact_number': contactNumber,
      'email_address': emailAddress,
      'billing_address': billingAddress,
      'product_id': productId,
      'product_name': productName,
      'product_price': productPrice,
      'quantity': quantity,
      'total_price': totalPrice,
      'delivery_fee': deliveryFee,
      'order_date': orderDate,
      'farmer_id': farmerId,
      'status': status,
    };
  }
}
