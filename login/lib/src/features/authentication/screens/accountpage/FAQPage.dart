import 'package:flutter/material.dart';

class FAQsPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}
class _FAQPageState extends State<FAQsPage> {
  int _selectedIndex = -1; // Index of the currently selected question

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
        title: Text('FAQs', style: TextStyle(
          color: Colors.white, // Change the text color here
        ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: _questions.asMap().entries.map((entry) {
              int index = entry.key;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(
                    entry.value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedIndex == index ? Colors.black : Colors.white,
                    ),
                  ),
                  backgroundColor: _selectedIndex == index ? Colors.white : Colors.transparent,
                  collapsedBackgroundColor: Colors.green,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  collapsedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        _answers[index],
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: _selectedIndex == index ? Colors.black : Colors.white),
                      ),
                    ),
                  ],
                  onExpansionChanged: (isOpen) {
                    setState(() {
                      if (isOpen) {
                        _selectedIndex = index;
                      } else {
                        _selectedIndex = -1;
                      }
                    });
                  },
                  initiallyExpanded: _selectedIndex == index,
                  iconColor: Colors.black, // Expanded icon color
                  collapsedIconColor: Colors.white, // Collapsed icon color
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  List<String> _questions = [
    'How do I find the products I\'m looking for?',
    'How do I proceed to checkout?',
    'What payment methods are available?',
  ];

  List<String> _answers = [
    'You can browse through the app\'s listings categorized by product type or use the search bar to find specific items. Each product listing displays details like name, image, description, price, quantity available, and potentially reviews (if implemented).',
    'When you\'re satisfied with your cart contents, click the "Checkout" button. This will take you through the checkout process, where you\'ll provide your delivery address, contact information, and choose a preferred delivery method (if options exist).',
    'Currently, FarmFusion Exchange offers cash on delivery (COD) as the payment method for your purchases. This means you\'ll pay the total order amount in cash upon receiving your delivery from the courier.',
  ];
}
