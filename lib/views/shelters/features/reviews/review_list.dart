import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';


class ReviewList extends StatelessWidget {
  final List<Review> reviews;

  const ReviewList({
    super.key,
    required this.reviews
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: reviews.map((review) {
          final formattedDate = DateFormat.yMd().format(review.date);
          return Container(
            width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userId),
                    Text(review.review),
                    const SizedBox(height: 10),
                    Text('Rating: ${review.rating} - Date: $formattedDate'),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
