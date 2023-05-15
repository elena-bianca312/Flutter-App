import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/services/shelter_cloud/firebase_shelter_storage.dart';
import 'package:myproject/views/shelters/features/reviews/review_details_page.dart';


class ReviewList extends StatefulWidget {
  final List<Review> reviews;
  final CloudShelterInfo shelter;

  const ReviewList({
    super.key,
    required this.reviews,
    required this.shelter
  });

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  late final FirebaseShelterStorage _sheltersService;

  @override
  void initState() {
    _sheltersService = FirebaseShelterStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.reviews.map((review) {
          final formattedDate = DateFormat.yMd().format(review.date);
          return Container(
            width: 300,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewDetailsPage(review: review),
                  ),
                );
              },
              child: Card(
                color: Colors.transparent,
                child: GlassBox(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    AuthService.firebase().currentUser!.email == review.email ? "Posted by you" : "Posted by ${review.email}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
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
                              ],
                            ),
                            const Expanded(child: SizedBox()),
                            AuthService.firebase().currentUser!.email == review.email ?
                              IconButton(
                                onPressed: () {
                                  _sheltersService.deleteReview(documentId: widget.shelter.documentId, review: review);
                                },
                                icon: const Icon(Icons.delete, color: Colors.white,),
                                iconSize: 20,
                              ) :
                              const SizedBox(),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          review.review.length > 100 ? '${review.review.substring(0, 100)}...' : review.review,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
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
          );
        }).toList(),
      ),
    );
  }
}
