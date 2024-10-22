import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewUI extends StatelessWidget {
  final String productId;

  const ReviewUI({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Review and Rating'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reviews and ratings are verified and from people who use the same type of device that you used.',
              ),
              SizedBox(height: 15),
              UserReviewList(productId: productId),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class UserReviewList extends StatelessWidget {
  final String productId;

  const UserReviewList({required this.productId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<double> ratings = [];

        snapshot.data!.docs.forEach((DocumentSnapshot document) {
          double rating = document['rating'] ?? 0.0;
          ratings.add(rating);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OverallProgressIndicator(ratings: ratings),
            SizedBox(height: 15),
            ...snapshot.data!.docs.map((DocumentSnapshot document) {
              final String customerName = document['customerName'] ?? 'N/A';
              final double rating = document['rating'] ?? 0.0;
              final String reviewText = document['reviewText'] ?? 'N/A';
              final Timestamp? timestamp = document['timestamp'];

              DateTime reviewDate = DateTime.now();
              if (timestamp != null) {
                reviewDate = timestamp.toDate();
              }

              return UserReviewCard(
                customerName: customerName,
                rating: rating,
                reviewDate: reviewDate,
                reviewText: reviewText,
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

class UserReviewCard extends StatelessWidget {
  final String customerName;
  final double rating;
  final DateTime reviewDate;
  final String reviewText;

  const UserReviewCard({
    required this.customerName,
    required this.rating,
    required this.reviewDate,
    required this.reviewText,
  });

  @override
  Widget build(BuildContext context) {
    String firstLetter = customerName.isNotEmpty ? customerName[0].toUpperCase() : '';

    // Format the reviewDate time part to include only hours and minutes
    String timePart = '${reviewDate.hour}:${reviewDate.minute}';

    // Format the reviewDate date part to your desired format
    String datePart = '${reviewDate.day}/${reviewDate.month}/${reviewDate.year}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          child: Text(
            firstLetter,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.green,
        ),
        SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customerName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Ratingbarindicator(rating: rating),
                  SizedBox(width: 10),
                  Text(
                    '$datePart $timePart', // Combine date and time parts
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(reviewText),
              Divider(),
            ],
          ),
        ),
      ],
    );
  }
}

class Ratingbarindicator extends StatelessWidget {
  final double rating;

  const Ratingbarindicator({required this.rating});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: rating,
      itemSize: 20,
      unratedColor: Colors.grey,
      itemBuilder: (context, _) => Icon(Icons.star, color: Colors.yellow.withOpacity(0.9)),
    );
  }
}

class OverallProgressIndicator extends StatelessWidget {
  final List<double> ratings;

  const OverallProgressIndicator({required this.ratings});

  @override
  Widget build(BuildContext context) {
    double totalRating = 0.0;
    int totalReviews = ratings.length;

    for (double rating in ratings) {
      totalRating += rating;
    }

    double overallRating = totalReviews > 0 ? totalRating / totalReviews : 0.0;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            overallRating.toStringAsFixed(1),
            style: TextStyle(color: Colors.black, fontSize: 50),
          ),
        ),
        Expanded(
          flex: 6,
          child: Column(
            children: [
              ProgressIndicatorItem(text: '5', value: _calculatePercentage(5)),
              ProgressIndicatorItem(text: '4', value: _calculatePercentage(4)),
              ProgressIndicatorItem(text: '3', value: _calculatePercentage(3)),
              ProgressIndicatorItem(text: '2', value: _calculatePercentage(2)),
              ProgressIndicatorItem(text: '1', value: _calculatePercentage(1)),
            ],
          ),
        ),
      ],
    );
  }

  double _calculatePercentage(double rating) {
    int count = ratings.where((r) => r == rating).length;
    int totalReviews = ratings.length;
    return totalReviews > 0 ? count / totalReviews : 0.0;
  }
}

class ProgressIndicatorItem extends StatelessWidget {
  final String text;
  final double value;

  const ProgressIndicatorItem({
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.08,
            child: LinearProgressIndicator(
              value: value,
              minHeight: 11,
              backgroundColor: Colors.grey,
              borderRadius: BorderRadius.circular(7),
              valueColor: AlwaysStoppedAnimation(Colors.yellow),
            ),
          ),
        ),
      ],
    );
  }
}
