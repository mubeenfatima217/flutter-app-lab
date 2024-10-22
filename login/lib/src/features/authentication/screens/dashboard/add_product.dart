import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../common_widgets/drop_down_button.dart';
import '../../controllers/dashboard_controller.dart';

class Addproductpage extends StatefulWidget {
  const Addproductpage({Key? key});
  @override
  _AddproductpageState createState() => _AddproductpageState();
}

class _AddproductpageState extends State<Addproductpage> {
  String Imageurl = 'image';
  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
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
          title: Text('Product Page',
            style: TextStyle(
            color: Colors.white,
          ),),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            width: double.maxFinite,
            child: Theme(
              data: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Colors.green, // Set text cursor color
                  selectionColor: Colors.green, // Set text selection color
                  selectionHandleColor: Colors.green, // Set text selection handle color
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Show selected image here
                      selectedImage != null
                          ? Image.file(
                        File(selectedImage!.path),
                        height: 60,
                        width: 90,
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.image,color: Colors.grey.withOpacity(0.4), size: 90),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          try {
                            final picker = ImagePicker();
                            XFile? image = await picker.pickImage(source: ImageSource.gallery); // Change source to ImageSource.camera
                            if (image != null) {
                              // Upload image
                              setState(() {
                                selectedImage = image;
                              });
                              FirebaseStorage storage = FirebaseStorage.instance;
                              String imagePath = 'product_images/';
                              Reference ref = storage.ref().child('product_images').child('${DateTime.now().millisecondsSinceEpoch}');

                              // Upload the image file to Firebase Storage
                              TaskSnapshot uploadTask = await ref.putFile(File(image.path));

                              // Get the download URL of the uploaded image
                              String imageUrl = await uploadTask.ref.getDownloadURL();
                              ctrl.productImageCtrl.text = imageUrl;

                              // Provide feedback to the user
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Image uploaded successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            print("Error uploading image: $e");
                            // Provide feedback to the user if upload fails
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to upload image. Please try again.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Text('Add Image'),
                      ),

                    ],
                  ),
                  SizedBox(height: 40,),

                  TextField(
                    cursorColor: Colors.green,
                    controller: ctrl.productNameCtrl,
                    style: TextStyle(color: Colors.black), // Set default text color
                    onTap: () {
                      setState(() {
                        // Change text color to green when clicked
                        ctrl.productNameCtrl.selection = TextSelection.fromPosition(
                          TextPosition(offset: ctrl.productNameCtrl.text.length),
                        );
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelText: 'Product Name',
                      hintText: 'Enter Your Product Name',
                      labelStyle: TextStyle(color: Colors.green), // Set label color
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),
                  TextField(
                    cursorColor: Colors.green,
                    controller: ctrl.productPriceCtrl,
                    style: TextStyle(color: Colors.black), // Set default text color
                    onTap: () {
                      setState(() {
                        // Change text color to green when clicked
                        ctrl.productPriceCtrl.selection = TextSelection.fromPosition(
                          TextPosition(offset: ctrl.productPriceCtrl.text.length),
                        );
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelText: 'Product Price',
                      hintText: 'Enter Your Product Price',
                      labelStyle: TextStyle(color: Colors.green), // Set label color
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(right: 210),
                    child: Text('Choose Quantity:',style:TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          child: TextField(
                            cursorColor: Colors.green,
                            controller: ctrl.productquantityCtrl,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black), // Set default text color
                            onTap: () {
                              setState(() {
                                // Change text color to green when clicked
                                ctrl.productquantityCtrl.selection = TextSelection.fromPosition(
                                  TextPosition(offset: ctrl.productquantityCtrl.text.length),
                                );
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: 'Enter Quantity',
                              hintText: 'Quantity',
                              labelStyle: TextStyle(color: Colors.green), // Set label color
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),

                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.8)), // Add border
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: DropdownButton<String>(
                          value: ctrl.selectedQuantityUnit,
                          onChanged: (String? newValue) {
                            setState(() {
                              ctrl.selectedQuantityUnit = newValue!;
                            });
                          },
                          items: ['Kilogram', 'Dozen', 'Gram']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                padding:EdgeInsets.symmetric(horizontal: 10,vertical: 9),
                                child: Text(value),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0,right: 30),
                        child: Text(
                          'Choose Category:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Dropdownbtn(
                          items: ['Fruits', 'Vegetables', 'Seeds'],
                          selectedItemText: ctrl.category,
                          onSelected: (selectedValue) {
                            ctrl.category = selectedValue ?? 'general';
                            ctrl.update();
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      ctrl.addProduct();
                    },
                    child: Text('Add Product'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
