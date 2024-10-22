import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/screens/Review/ReviewUI.dart';
import '../../models/product/product.dart';
import '../AddtoCart/add_to_cart.dart';
import '../Checkout/checkout.dart';
import '../Review/Review.dart';
import 'package:share_plus/share_plus.dart';

class ProductDescriptionPage extends StatefulWidget {
  @override
  _ProductDescriptionPageState createState() => _ProductDescriptionPageState();
}

class _ProductDescriptionPageState extends State<ProductDescriptionPage> {
  int _quantity = 1;
  double _totalPrice = 0.0;
  late Product product;

  // Function to share the product
  void _shareProduct(Product product) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share(
      'Check out this product: ${product.name}\nPrice: Rs. ${product.price}',
      subject: product.name,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }

  void _cart(Product product) {
    // Add product to the cart (replace with your cart management logic)
    // Here's an example for an in-memory cart (replace with a proper solution)
    List<Product> cart = []; // Replace with your cart data structure
    cart.add(product);

    // Show a snackbar to indicate successful addition
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Function to increase quantity
  void _increaseQuantity() {
    setState(() {
      _quantity++;
      _updateQuantityInFirestore(); // Update quantity in Firestore
      _updateTotalPrice(); // Recalculate total price
    });
  }

  // Function to decrease quantity
  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _updateQuantityInFirestore(); // Update quantity in Firestore
        _updateTotalPrice(); // Recalculate total price
      });
    }
  }

  // Function to update quantity in Firestore
  void _updateQuantityInFirestore() {
    FirebaseFirestore.instance.collection('products').doc(product.id).update({
      'quantity': _quantity,
    });
  }

  // Function to update total price
  void _updateTotalPrice() {
    _totalPrice = (product.price ?? 0.0) * _quantity;
  }

  @override
  void initState() {
    super.initState();
    product = Get.arguments['data'];
  }

  // Function to navigate to the "Add to Cart" screen
  void _addToCart(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddToCartScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Navigate back to the previous page
                      },
                      child: Icon(Icons.arrow_back_ios, size: 30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            _shareProduct(product);
                          },
                          icon: Icon(Icons.share, size: 26),
                        ),
                        IconButton(
                          onPressed: () {
                            _cart(product);
                          },
                          icon: Badge(
                            child: Icon(Icons.shopping_bag_outlined, size: 30),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Image.network(
                product.image ?? '',
                fit: BoxFit.contain,
                width: double.infinity,
                height: 200,
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.on_device_training_sharp, color: Colors.grey),
                  Text(
                    product.category ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                product.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff1a1a1a),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('reviews')
                        .where('productId', isEqualTo: product.id)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Loading...');
                      }
                      List<double> ratings = snapshot.data!.docs
                          .map((doc) => (doc['rating'] as num).toDouble())
                          .toList();
                      double averageRating = ratings.isNotEmpty
                          ? ratings.reduce((a, b) => a + b) / ratings.length
                          : 0.0;
                      int totalReviews = ratings.length;
                      return Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          SizedBox(width: 5),
                          Text(
                            '${averageRating.toStringAsFixed(1)}($totalReviews)',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 14),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RS. ${product.price ?? ""}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Services",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '14 days free and easy return',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Change of mind is not acceptable',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewUI(productId: product.id ?? ''),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.chevron_left),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 200.0),
                      child: TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewScreen(product: product),
                            ),
                          );
                        },
                        child: Text('Write a Review'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.withOpacity(0.02),
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _decreaseQuantity, // Decrease quantity logic
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Icon(Icons.remove),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '$_quantity',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: _increaseQuantity, // Increase quantity logic
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        product: product,
                        quantity: _quantity, totalPrice: _totalPrice, // Pass the quantity here
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text(
                      'Buy Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}