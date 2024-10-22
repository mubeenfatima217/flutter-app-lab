import 'package:flutter/material.dart';

class PoliciesPage extends StatelessWidget {
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
        title: Text('FarmFusion Exchange Policies', style: TextStyle(
    color: Colors.white, // Change the text color here
    ),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PolicyItem(
              title: '1- Privacy Policy',
              description:
              'FarmFusion Exchange is committed to protecting the privacy of its users. We collect and process personal data in accordance with applicable laws and regulations. Our Privacy Policy outlines how we collect, use, and safeguard your information. By using our app, you agree to the terms outlined in our Privacy Policy.',
            ),
            PolicyItem(
              title: '2- Terms of Service',
              description:
              'Users of FarmFusion Exchange must adhere to our Terms of Service. These terms govern the use of our platform, including listing products, making purchases, and interacting with other users. By using our app, you agree to comply with our Terms of Service.',
            ),
            PolicyItem(
              title: '3- Listing Policies',
              description:
                'Farmers listing products on FarmFusion Exchange must ensure that their listings comply with our Listing Policies. This includes providing accurate descriptions, images, and pricing information for their products. Listings must not contain misleading or false information.',
            ),
            PolicyItem(
              title: '4- Payment and Transactions',
              description:
                'FarmFusion Exchange facilitates transactions between buyers and sellers. Users engaging in transactions through our platform must adhere to our Payment and Transaction Policies. This includes providing accurate payment information, honoring purchase agreements, and resolving disputes in a timely manner.',
            ),
            PolicyItem(
              title: '5- Community Guidelines',
              description:
                'We promote a respectful and inclusive community within FarmFusion Exchange. Users must follow our Community Guidelines when interacting with others on our platform. This includes refraining from abusive language, harassment, discrimination, or any other behavior that may be harmful or offensive.',
            ),
            PolicyItem(
              title: '6- Plant Disease Detection Feature',
              description:
                'Our AI-driven plant disease detection feature is provided for informational purposes only. While we strive to provide accurate and timely information, FarmFusion Exchange cannot guarantee the accuracy or effectiveness of the diagnosis. Users should consult with qualified professionals for any specific plant health concerns.',
            ),
            PolicyItem(
              title: '7- Intellectual Property Rights',
              description:
              'Users must respect the intellectual property rights of others when using FarmFusion Exchange. This includes refraining from copying, distributing, or using copyrighted material without proper authorization. Users are responsible for ensuring that their content does not infringe upon the rights of others.',
            ),
            PolicyItem(
              title: '8- Security Measures',
              description:
                'FarmFusion Exchange implements security measures to protect the integrity and confidentiality of user data. Users are responsible for maintaining the security of their accounts and should not share their login credentials with others.',
            ),
            // Add other PolicyItem widgets for each policy
          ],
        ),
      ),
    );
  }
}

class PolicyItem extends StatelessWidget {
  final String title;
  final String description;

  PolicyItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text(description,style: TextStyle(fontSize: 13),
        textAlign: TextAlign.justify,),
        SizedBox(height: 16.0),
      ],
    );
  }
}
