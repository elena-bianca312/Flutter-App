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
  const WriteReviewPage({
    super.key,
    required this.rating,
    required this.shelter
  });

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {

  late final CloudShelterInfo _shelter = widget.shelter;
  late final FirebaseShelterStorage _sheltersService;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    _sheltersService = FirebaseShelterStorage();
    super.initState();
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < widget.rating; i++)
                      const Icon(
                        Icons.star,
                        color: kCustomBlue,
                      ),
                    for (int i = widget.rating; i < 5; i++)
                      const Icon(
                        Icons.star_border,
                        color: kCustomBlue,
                      ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
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
                        review: _reviewController.text,
                        rating: widget.rating,
                      );
                      // TODO
                      // Eroare: momentan nu functioneaza adaugarea de review-uri
                      await _sheltersService.addReview(documentId: _shelter.documentId, review: review);

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
