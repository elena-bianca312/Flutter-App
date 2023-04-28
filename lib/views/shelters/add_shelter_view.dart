import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/utilities/generics/get_arguments.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/services/shelter_cloud/firebase_shelter_storage.dart';
import 'package:myproject/utilities/dialogs/cannot_share_empty_note_dialog.dart';

class AddShelterView extends StatefulWidget {
  const AddShelterView({super.key});

  @override
  State<AddShelterView> createState() => _AddShelterViewState();
}

class _AddShelterViewState extends State<AddShelterView> {

  CloudShelterInfo? _shelter;
  late final FirebaseCloudStorage _sheltersService;
  late final TextEditingController _titleController;
  late final TextEditingController _addressController;
  late final TextEditingController _photoURLController;
  late final TextEditingController _textController;

  Future<CloudShelterInfo> createOrGetExistingShelter(BuildContext context) async {

    // final widgetShelter = context.getArgument<CloudShelterInfo>();
    // // If we have a shelter passed in from the widget, use it. Otherwise, create a new one.
    // if (widgetShelter != null) {
    //   _shelter = widgetShelter;
    //   _titleController.text = widgetShelter.title;
    //   _addressController.text = widgetShelter.address!;
    //   _photoURLController.text = widgetShelter.photoURL!;
    //   _textController.text = widgetShelter.text!;
    //   return widgetShelter;
    // }

    // final existingShelter = _shelter;
    // if (existingShelter != null) {
    //   return existingShelter;
    // }

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newShelter = await _sheltersService.createNewShelter(ownerUserId: userId);
    _shelter = newShelter;
    return newShelter;
  }

  void _deleteShelterIfIncomplete() {
    final shelter = _shelter;
    if (_titleController.text.isEmpty && shelter != null) {
      _sheltersService.deleteShelter(documentId: shelter.documentId);
    }
  }

  void _saveShelterIfNotEmpty() async {
    final shelter = _shelter;
    final title = _titleController.text;
    if (shelter != null && title.isNotEmpty) {
      await _sheltersService.updateShelter(
        documentId: shelter.documentId,
        title: title,
      );
    }
  }

  @override
  void initState() {
    _sheltersService = FirebaseCloudStorage();
    _titleController = TextEditingController();
    _addressController = TextEditingController();
    _photoURLController = TextEditingController();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteShelterIfIncomplete();
    _saveShelterIfNotEmpty();
    _titleController.dispose();
    _addressController.dispose();
    _photoURLController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _controllerListener() async {
    final shelter = _shelter;
    if (shelter == null) {
      return;
    }
    final title = _titleController.text;
    final address = _addressController.text;
    final photoURL = _photoURLController.text;
    final text = _textController.text;
    await _sheltersService.updateShelter(
      documentId: shelter.documentId,
      title: title,
      address: address,
      photoURL: photoURL,
      text: text,
    );
  }

  void _setupControllerListener() {
    _textController.removeListener(_controllerListener);
    _textController.addListener(_controllerListener);
  }

  // void _textControllerListener() async {
  //   final shelter = _shelter;
  //   if (shelter == null) {
  //     return;
  //   }
  //   final text = _textController.text;
  //   await _sheltersService.updateShelter(
  //     documentId: shelter.documentId,
  //     text: text,
  //   );
  // }

  // void _setupTextControllerListener() {
  //   _textController.removeListener(_textControllerListener);
  //   _textController.addListener(_textControllerListener);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Please fill in shelter info...'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final text = _textController.text;
              if (_shelter == null || text.isEmpty) {
                await showCannotShareEmptyNoteDialog(context);
              } else {
                Share.share(text);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingShelter(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // _setupControllerListener();
              _setupControllerListener();
              return Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                    ),
                  ),
                  TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Type text...',
                    ),
                  ),
                ],
              );
            default:
              return const Center(child: CircularProgressIndicator());
        }
      },)
    );
  }
}