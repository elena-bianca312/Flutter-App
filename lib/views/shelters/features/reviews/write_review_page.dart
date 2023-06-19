import 'package:flutter/material.dart';
import 'package:myproject/styles/styles.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/views/pages/custom.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/services/shelter_cloud/firebase_shelter_storage.dart';

class WriteReviewPage extends StatefulWidget {

  final CloudShelterInfo shelter;
  final int rating;
  final Review? oldReview;

  const WriteReviewPage({
    super.key,
    required this.rating,
    required this.shelter,
    this.oldReview
  });

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {

  late final CloudShelterInfo _shelter = widget.shelter;
  late final FirebaseShelterStorage _sheltersService;
  late final TextEditingController _reviewController = widget.oldReview != null ? TextEditingController(text: widget.oldReview!.review) : TextEditingController();
  late int _rating;

  @override
  void initState() {
    _sheltersService = FirebaseShelterStorage();
    super.initState();
    _rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Write a Review'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Rate this Shelter',
                  style: header
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: kCustomBlue
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: TextField(
                    controller: _reviewController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Write a review...',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                     ),
                    ),
                    maxLines: null,
                    expands: true,
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                GlassBox(
                  height: 40,
                  width: 80,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Save review to database
                      Review review = Review(
                        userId: AuthService.firebase().currentUser!.id,
                        email: AuthService.firebase().currentUser!.email,
                        review: _reviewController.text,
                        rating: _rating,
                        date: DateTime.now(),
                      );
                      if (widget.oldReview != null) {
                        await _sheltersService.updateReview(documentId: _shelter.documentId, oldReview: widget.oldReview!, updatedReview: review);
                      } else {
                        await _sheltersService.addReview(documentId: _shelter.documentId, review: review);
                      }

                      // Return to previous page
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: const Text('Submit')
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
