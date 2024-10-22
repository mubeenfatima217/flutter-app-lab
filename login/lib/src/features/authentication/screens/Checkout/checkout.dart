import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/product/product.dart';
import '../../models/farmerorder/farmer.dart'; // Import your order model here

class CheckoutScreen extends StatelessWidget {
  final Product product;
  final int quantity;
  final double? totalPrice;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  CheckoutScreen({required this.product, required this.quantity, required this.totalPrice});
  String _paymentMethod = 'Cash on Delivery';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text('Checkout', style: TextStyle(
          color: Colors.white, // Change the text color here
        ),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            _buildProductDetails(),
            SizedBox(height: 20),
            _buildContactInfoSection(),
            SizedBox(height: 20),
            _buildBillingAddressSection(),
            SizedBox(height: 20),
            _buildPaymentMethodSection(),
            SizedBox(height: 20),
            _buildOrderSummary(),
          ],
        ),
      ),
      bottomNavigationBar: _placeOrderButton(context),
    );
  }

  Widget _buildProductDetails() {
    return ListTile(
      leading: Image.network(
        product.image ?? '',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
      title: Text(product.name ?? ''),
      subtitle: Text('Price: Rs. ${product.price ?? ""}'),
    );
  }

  Widget _buildContactInfoSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contact Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(height: 10),
          TextFormField(
            cursorColor:Colors.green,
            controller: _fullNameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              labelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green), // Set the border color to green when focused
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            cursorColor:Colors.green,
            controller: _contactNoController,
            decoration: InputDecoration(
              labelText: 'Contact Number',
              labelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green), // Set the border color to green when focused
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            cursorColor:Colors.green,
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email Address',
              labelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green), // Set the border color to green when focused
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingAddressSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Billing Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(height: 10),
          TextFormField(
            cursorColor:Colors.green,
            controller: _addressController,
            decoration: InputDecoration(
              labelText: 'Enter your address',
              labelStyle: TextStyle(color: Colors.green),
              hintText: '1234 Main St',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green), // Set the border color to green when focused
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return ListTile(
      title: Text('Payment Method'),
      subtitle: Text(_paymentMethod),
      trailing: Icon(Icons.payment),
      onTap: () {
        // Placeholder for changing payment method
      },
    );
  }

  Widget _buildOrderSummary() {
    double itemTotal = (product.price ?? 0.0) * quantity;
    double totalPayment = itemTotal + 200;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          SizedBox(height: 10),
          _buildOrderItem('Item Total', 'Rs. ${itemTotal.toStringAsFixed(2)}'),
          _buildOrderItem('Delivery Fee', 'Rs. 200.00'),
          Divider(),
          _buildOrderItem('Total Payment', 'Rs. ${totalPayment.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value),
      ],
    );
  }

  Widget _placeOrderButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              if (_validateForm(context)) {
                _placeOrder(context);
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.green, minimumSize: Size(100, 40)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Place Order',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateForm(BuildContext context) {
    if (_fullNameController.text.isEmpty ||
        _contactNoController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
      );
      return false;
    }
    return true;
  }

  Future<void> _placeOrder(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You need to be logged in to place an order")),
      );
      return;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    double itemTotal = (product.price ?? 0.0) * quantity;
    double totalPayment = itemTotal + 200; // Adding the delivery fee

    try {
      order newOrder = order(
        id: '',
        userId: user.uid,
        fullName: _fullNameController.text,
        contactNumber: _contactNoController.text,
        emailAddress: _emailController.text,
        billingAddress: _addressController.text,
        productId: product.id ?? '',
        productName: product.name ?? '',
        productPrice: product.price ?? 0.0,
        quantity: quantity,
        totalPrice: totalPayment,
        deliveryFee: 200,
        orderDate: DateTime.now(),
        farmerId: product.farmerId ?? '',
        status: 'Pending',
      );

      await firestore.collection('orders').add(newOrder.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order placed successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order: $e")),
      );
    }
  }
}
