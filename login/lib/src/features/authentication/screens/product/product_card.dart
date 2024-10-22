import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../AddtoCart/add_to_cart.dart';

class ProductCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final double price;
  final double quantity;
  final Function onTap;
  final String quantityUnit;
  final String productId;
  final String farmerId;

  const ProductCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.onTap,
    required this.quantity,
    required this.quantityUnit,
    required this.productId, required this.farmerId,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  double averageRating = 0.0;
  int totalReviews = 0;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
    fetchRatingAndReviews();
  }

  Future<void> checkIfFavorite() async {
    var wishlistCollection = FirebaseFirestore.instance.collection('wishlist');
    var wishlistSnapshot = await wishlistCollection.where('name', isEqualTo: widget.name).get();

    if (wishlistSnapshot.docs.isNotEmpty) {
      setState(() {
        isFavorite = true;
      });
    }
  }

  Future<void> fetchRatingAndReviews() async {
    try {
      var reviewsSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('productId', isEqualTo: widget.productId)
          .get();

      if (reviewsSnapshot.docs.isNotEmpty) {
        List<double> ratings = reviewsSnapshot.docs
            .map((doc) => (doc['rating'] as num).toDouble())
            .toList();
        double totalRating = ratings.fold(0, (sum, rating) => sum + rating);
        setState(() {
          averageRating = totalRating / ratings.length;
          totalReviews = ratings.length;
        });
      }
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  Future<void> toggleFavorite(BuildContext context) async {
    var wishlistCollection = FirebaseFirestore.instance.collection('wishlist');

    if (isFavorite) {
      var wishlistSnapshot = await wishlistCollection.where('name', isEqualTo: widget.name).get();
      for (var doc in wishlistSnapshot.docs) {
        await doc.reference.delete();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed from wishlist'),
        ),
      );
    } else {
      await wishlistCollection.add({
        'name': widget.name,
        'imageUrl': widget.imageUrl,
        'price': widget.price,
        'quantity': widget.quantity,
        'quantityUnit': widget.quantityUnit,
        'productId': widget.productId,
        'farmerId': widget.farmerId,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to wishlist'),
        ),
      );
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  Future<void> addToCart(BuildContext context) async {
    var cartCollection = FirebaseFirestore.instance.collection('cart');
    var cartSnapshot = await cartCollection.where('name', isEqualTo: widget.name).get();

    if (cartSnapshot.docs.isEmpty) {
      await cartCollection.add({
        'name': widget.name,
        'imageUrl': widget.imageUrl,
        'price': widget.price,
        'quantity': widget.quantity,
        'quantityUnit': widget.quantityUnit,
        'farmerId': widget.farmerId, // Add farmerId to the cart item
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item already in cart'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: InkWell(
        onTap: () {
          widget.onTap();
        },
        child: Card(
          elevation: 2,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 120,
                      ),
                      Positioned(
                        top: 0.02,
                        right: 2,
                        child: IconButton(
                          onPressed: () async {
                            await toggleFavorite(context);
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              buildStarRating(averageRating),
                              SizedBox(width: 5),
                              Text(
                                '${averageRating.toStringAsFixed(1)} (${totalReviews.toString()})',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rs. ${widget.price}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                onPressed: () {
                                  addToCart(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddToCartScreen(),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.shopping_cart),
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStarRating(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(
        Icon(
          i <= rating ? Icons.star : i - rating <= 0.5 ? Icons.star_half : Icons.star_border,
          color: Colors.yellow,
          size: 14,
        ),
      );
    }
    return Row(children: stars);
  }
}
