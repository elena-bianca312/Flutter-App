import 'package:flutter/material.dart';
import 'package:myproject/animation/write_review_page.dart';

class ReviewStars extends StatefulWidget {
  const ReviewStars({super.key});

  @override
  State<ReviewStars> createState() => _ReviewStarsState();
}

class _ReviewStarsState extends State<ReviewStars> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) {
          return IconButton(
            onPressed: () {
              setState(() {
                _rating = index + 1;
              });
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WriteReviewPage(rating: _rating),
                ),
              );
            },
            icon: Icon(
              index < _rating ? Icons.star : Icons.star_border,
              color: Colors.yellow,
            ),
          );
        },
      ),
    );
  }
}
