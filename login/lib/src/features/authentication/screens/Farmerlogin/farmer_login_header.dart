import 'package:flutter/material.dart';
import 'package:login/src/constants/sizes.dart';

class FarmerFormHeaderWidget extends StatelessWidget {
  const FarmerFormHeaderWidget({
    Key? key,
    this.imageColor,
    this.heightBetween,
    required this.image,
    required this.title,
    required this.subTitle,
    this.imageHeight = 0.15,
    this.textAlign,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  //Variables -- Declared in Constructor
  final Color? imageColor;
  final double imageHeight;
  final double? heightBetween;
  final String image, title, subTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: crossAxisAlignment,

      children: [
        const SizedBox(height: 50),
         Center(child: Image(image: AssetImage(image), color: imageColor, height: size.height * imageHeight,),),
        //SizedBox(height: 20),
        //Text(title,
           // style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold,
            //    fontSize: 22),
            //textAlign: TextAlign.start),
        //Text(subTitle, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}