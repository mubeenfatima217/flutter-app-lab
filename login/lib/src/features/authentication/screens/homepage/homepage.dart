import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/screens/AddtoCart/add_to_cart.dart';
import 'package:login/src/features/authentication/screens/homepage/searchscreen.dart';
import 'package:login/src/features/authentication/screens/homepage/seed.dart';
import 'package:login/src/features/authentication/screens/homepage/vegetable.dart';
import 'package:login/src/features/authentication/screens/homepage/fruit.dart';
import '../../../../../account.dart';
import '../../controllers/dashboard_controller.dart';
import '../../models/product/product.dart';
import '../accountpage/Accountpage.dart';
import '../dashboard/all_product.dart';
import '../product/product_card.dart';
import '../product/product_description.dart';
import 'package:http/http.dart';
import 'package:login/src/features/authentication/screens/wishlist/wishlist.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String imageUrl;
  late String imageUrl1;
  late String imageUrl2 = ''; // Initialize with an empty string
  late String imageUrl3 = ''; // Initialize with an empty string
  late String imageUrl4 = ''; // Initialize with an empty string

  final Storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    imageUrl = '';
    imageUrl1 = '';
    ///coursel images
    imageUrl2= '';
    imageUrl3= '';
    imageUrl4= '';
    getImageUrl();
  }

  Future<void> getImageUrl() async {
    final ref = Storage.ref().child('banner.png');
    final refs = Storage.ref().child('logo.png');
    ///coursel images
    final refz = Storage.ref().child('banner1.png');
    final refa = Storage.ref().child('banner2.png');
    final refm = Storage.ref().child('banner3.png');

    final url = await ref.getDownloadURL();
    final url1 = await refs.getDownloadURL();
    ///coursel images
    final url2 = await refz.getDownloadURL();
    final url3 = await refa.getDownloadURL();
    final url4 = await refm.getDownloadURL();
    setState(() {
      imageUrl = url;
      imageUrl1 = url1;
      imageUrl2 = url2;
      imageUrl3 = url3;
      imageUrl4 = url4;
    });
  }

  int _currentPage = 0;
  int _selectedIndex = 0;
  CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return RefreshIndicator(
          onRefresh: () async {
            ctrl.fetchProducts();
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white70,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Padding(
                padding: const EdgeInsets.only(right: 50.0),
                child: Expanded(

                  child: Image.network(
                    imageUrl1,
                    height: 60,
                    width: 290,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 3),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    cursorColor:Colors.green,
                                    decoration: InputDecoration(
                                      hintText: 'What Would you like to have?',
                                      prefixIcon: Icon(Icons.search,color: Colors.green,),
                                      border: InputBorder.none,
                                    ),
                                    onTap: () {
                                      // Navigate to the Search Screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => SearchScreen()),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.filter_list, color: Colors.green),
                                  onPressed: () {
                                    // Add onPressed functionality for filter icon
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 170,
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            image: NetworkImage(
                                imageUrl), // Correct the path to your banner image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FarmFusion Exchange',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Fresh food. Direct connection.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => allproduct()),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green),
                              ),
                              child: Text(
                                'Shop Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => allproduct()),
                            );
                            // Add onPressed functionality for "View All"
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Iterate over the home categories and create GestureDetector widgets for each
                        // First, find the index of each category and then render them accordingly
                        for (var category in ctrl.homecategory)
                          if (category.name == 'Fruits')
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Fruitspage()),
                                );
                              },
                              child: _buildCategory(
                                context,
                                category.name ?? '',
                                category.image ?? '',
                              ),
                            ),
                        for (var category in ctrl.homecategory)
                          if (category.name == 'Vegetables')
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => VegetablePage()),
                                );
                              },
                              child: _buildCategory(
                                context,
                                category.name ?? '',
                                category.image ?? '',
                              ),
                            ),
                        for (var category in ctrl.homecategory)
                          if (category.name == 'Seeds')
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SeedsPage()),
                                );
                              },
                              child: _buildCategory(
                                context,
                                category.name ?? '',
                                category.image ?? '',
                              ),
                            ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Carousel Slider
                  CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: 170.0,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.9,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                    items: [
                      imageUrl2,
                      imageUrl3,
                      imageUrl4,
                    ].map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 2.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(item), // Use NetworkImage for URLs
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return Text(
                        '-',
                        style: TextStyle(
                          fontSize: 43.0,
                          color: _currentPage == index ? Colors.green : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Featured Product',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => allproduct(),));
                            // Add onPressed functionality for "See All"
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6, // Set a fixed height or adjust as needed
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          name: ctrl.productsshowinUI[index].name ?? 'No Name',
                          imageUrl: ctrl.productsshowinUI[index].image ?? 'Url',
                          price: ctrl.productsshowinUI[index].price ?? 00,
                          quantity: ctrl.productsshowinUI[index].quantity ?? 00,
                          quantityUnit: ctrl.productsshowinUI[index].quantityUnit ?? 'Unit',
                          onTap: () {
                            Get.to(ProductDescriptionPage(), arguments: {'data': ctrl.productsshowinUI[index]});
                          }, productId: ctrl.productsshowinUI[index].id ??'',
                          farmerId: ctrl.productsshowinUI[index].farmerId ?? '', // Pass the farmerId here

                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.green,
              selectedItemColor: Color(0xFF013220),
              unselectedItemColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Wishlist',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Account',
                ),
              ],
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                switch (index) {
                  case 0:
                  // Navigate to Home page
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                    break;
                  case 1:
                  // Navigate to Add to Cart page
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        // Replace this with the actual page you want to navigate to
                        builder: (context) => AddToCartScreen(),
                      ),
                    );
                    break;
                  case 2:
                  // Navigate to Message page
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        // Replace this with the actual page you want to navigate to
                        builder: (context) => Wishlistscreen(),
                      ),
                    );
                    break;
                  case 3:
                  // Navigate to Account page
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        // Replace this with the actual page you want to navigate to
                        builder: (context) => AccountPage(),
                      ),
                    );
                    break;
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategory(BuildContext context, String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 3),
            blurRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(imagePath),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
