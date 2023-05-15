import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';

class ReviewDetailsPage extends StatelessWidget {
  final Review review;

  const ReviewDetailsPage({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy').format(review.date);

    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Review Details'),
          ),
          body: Center(
            child: Card(
              color: Colors.transparent,
              child: GlassBox(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AuthService.firebase().currentUser!.email == review.email ? "Posted by you" : "Posted by ${review.email}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        review.review,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RatingBar.builder(
                          wrapAlignment: WrapAlignment.start,
                          initialRating: review.rating.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 15,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: kCustomBlue,
                          ),
                          onRatingUpdate: (double value) {null;},
                          ignoreGestures: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Date: $formattedDate',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
