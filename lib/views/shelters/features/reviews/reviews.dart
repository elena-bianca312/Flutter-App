import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/views/shelters/features/reviews/write_review_page.dart';

typedef Callback = void Function();

class ReviewStars extends StatefulWidget {

  final CloudShelterInfo shelter;
  const ReviewStars({
    super.key, required this.shelter,
  });

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
                  builder: (context) => WriteReviewPage(rating: _rating, shelter: widget.shelter,),
                ),
              );
            },
            icon: Icon(
              index < _rating ? Icons.star : Icons.star_border,
              color: kCustomBlue
            ),
          );
        },
      ),
    );
  }
}
