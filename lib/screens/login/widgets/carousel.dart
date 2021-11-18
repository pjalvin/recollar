import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:recollar/util/configuration.dart';

class Carousel extends StatelessWidget {
  Carousel({Key? key,required this.size,required this.images}) : super(key: key);
  Size size;
  List<ImageProvider> images;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: colorBlack,
        height: size.height,
        width: size.width,
        child: CarouselSlider(
          items: images.map((e) =>
              Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: e,
                        fit: BoxFit.cover
                    )
                ),
              )
          ).toList(),
          options: CarouselOptions(
            height: size.height,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: true,
            enableInfiniteScroll: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
        )
    );
  }
}
