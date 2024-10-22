import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/farmerorder/farmer.dart'; // Import your order model here

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  String? farmerId;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        farmerId = user.uid; // Assuming farmerId is the same as userId for this example
      });
    }
  }

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
        title: Text('Order Management', style: TextStyle(
          color: Colors.white,
        ),),
      ),
      body: farmerId == null ? Center(child: CircularProgressIndicator()) : _buildOrderList(),
    );
  }

  Widget _buildOrderList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('farmer_id', isEqualTo: farmerId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No orders found'));
        }

        var orders = snapshot.data!.docs.map((doc) => order.fromDocument(doc)).toList();

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var order = orders[index];
            return Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(order.productName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Price: ${order.productPrice}'),
                    Text('Quantity: ${order.quantity}'),
                    Text('Total Price: Rs. ${order.totalPrice}'),
                    Text('Ordered by: ${order.fullName}'),
                    Text('Status: ${order.status}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStatusDropdown(order),
                    _buildPopupMenu(order),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusDropdown(order Ord) {
    return DropdownButton<String>(
      value: Ord.status,
      items: ['Pending', 'Processing', 'Shipped', 'Delivered']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          _updateOrderStatus(Ord.id, newValue);
        }
      },
    );
  }

  Widget _buildPopupMenu(order ord) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        if (result == 'delete') {
          _deleteOrder(ord.id);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete Order'),
        ),
      ],
      icon: Icon(Icons.more_vert),
    );
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order status: $e')),
      );
    }
  }

  Future<void> _deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete order: $e')),
      );
    }
  }
}
