import 'package:flutter/material.dart';
import 'package:myproject/constants/routes.dart';
import 'package:myproject/styles/glass_box.dart';
import 'package:myproject/views/pages/custom.dart';
import 'package:myproject/views/notes/notes_view.dart';
import 'package:myproject/widgets/background_image.dart';
import 'package:myproject/views/shelters/choose_action_view.dart';

class UsefulInformationView extends StatelessWidget {

  const UsefulInformationView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Useful Information'),
            backgroundColor: Colors.transparent,
          ),
          body: Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                GlassBox(
                  height: 50,
                  width: 300,
                  addedOpacity: 0.1,
                  child: TextButton(
                    child: Text('First-Aid Kit', style: labelPrimary,),
                    onPressed: () {
                      Navigator.of(context).pushNamed(firstAidKitRoute);
                    },
                  ),
                ),
                const SizedBox(height: 50),
                GlassBox(
                  height: 50,
                  width: 300,
                  addedOpacity: 0.1,
                  child: TextButton(
                    child: Text('Earthquake Plan', style: labelPrimary,),
                    onPressed: () {
                      Navigator.of(context).pushNamed(earthquakePlanRoute);
                    },
                  ),
                ),
                const SizedBox(height: 50),
                GlassBox(
                  height: 50,
                  width: 300,
                  addedOpacity: 0.1,
                  child: TextButton(
                    child: Text('My Notes', style: labelPrimary,),
                    onPressed: () {
                      Navigator.of(context).pushNamed(notesRoute);
                    },
                  ),
                ),
                const SizedBox(height: 50),
                GlassBox(
                  height: 50,
                  width: 300,
                  addedOpacity: 0.1,
                  child: TextButton(
                    child: Text('Emergency Contacts', style: labelPrimary,),
                    onPressed: () {
                      Navigator.of(context).pushNamed(emergencyContactsRoute);
                    },
                  ),
                ),
              ]),
          ),
        )
      ],
    );
  }
}