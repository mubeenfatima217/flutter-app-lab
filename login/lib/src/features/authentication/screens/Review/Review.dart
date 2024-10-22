import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/product/product.dart';

class ReviewScreen extends StatefulWidget {
  final Product product;

  const ReviewScreen({required this.product});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double _rating = 0.0;
  TextEditingController _reviewController = TextEditingController();
  TextEditingController _customerNameController = TextEditingController();

  void _submitReview() {
    String reviewText = _reviewController.text;
    double rating = _rating;
    String customerName = _customerNameController.text;

    FirebaseFirestore.instance.collection('reviews').add({
      'productId': widget.product.id,
      'productName': widget.product.name,
      'customerName': customerName,
      'rating': rating,
      'reviewText': reviewText,
      'timestamp': Timestamp.now(),
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review submitted successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit review: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Write a Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              cursorColor:Colors.green,
              controller: _customerNameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
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
            SizedBox(height: 20),
            Text('Rating:'),
            Slider(
              value: _rating,
              min: 0,
              max: 5,
              divisions: 5,
              onChanged: (newValue) {
                setState(() {
                  _rating = newValue;
                });
              },
              label: 'Rating: $_rating',
              activeColor: Colors.green, // Set the active color to green

            ),
            SizedBox(height: 20),
            TextField(
              cursorColor:Colors.green,
              controller: _reviewController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your review here...',
                hintStyle: TextStyle(color: Colors.green),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green), // Set the border color to green when focused
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Green background color
                onPrimary: Colors.white, // White text color
              ),
              child: Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }
}
