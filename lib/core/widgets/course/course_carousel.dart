import 'package:carousel_slider/carousel_slider.dart';
import 'package:praxis/core/widgets/course/course_card.dart';
import 'package:flutter/material.dart';

class CourseCarousel extends StatelessWidget {
  const CourseCarousel({required this.courseCards, super.key});

  final List<CourseCard> courseCards;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: courseCards,
      options: CarouselOptions(
        height: 130,
        viewportFraction: 0.9,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        onPageChanged: (index, reason) => null,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
