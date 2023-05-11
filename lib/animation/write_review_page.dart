import 'package:flutter/material.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/views/pages/custom.dart';
import 'package:myproject/widgets/background_image.dart';

class WriteReviewPage extends StatefulWidget {
  final int rating;

  const WriteReviewPage({super.key, required this.rating});

  @override
  State<WriteReviewPage> createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  TextEditingController _reviewController = TextEditingController();

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
                        color: Colors.yellow,
                      ),
                    for (int i = widget.rating; i < 5; i++)
                      const Icon(
                        Icons.star_border,
                        color: Colors.yellow,
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
                    onPressed: () {
                      // Save review to database
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
