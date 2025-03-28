import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:myproject/widgets/text_input.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myproject/animation/fade_animation.dart';
import 'package:myproject/services/auth/auth_service.dart';
import 'package:myproject/utilities/generics/get_arguments.dart';
import 'package:myproject/services/shelter_cloud/cloud_shelter_info.dart';
import 'package:myproject/utilities/dialogs/photo_invalid_format_dialog.dart';
import 'package:myproject/services/shelter_cloud/firebase_shelter_storage.dart';
import 'package:myproject/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:myproject/utilities/dialogs/cannot_save_incomplete_shelter_info_dialog.dart';


class AddShelterView extends StatefulWidget {
  const AddShelterView({super.key});

  @override
  State<AddShelterView> createState() => _AddShelterViewState();
}

class _AddShelterViewState extends State<AddShelterView> {

  CloudShelterInfo? _shelter;
  late final FirebaseShelterStorage _sheltersService;
  late final TextEditingController _titleController;
  late final TextEditingController _addressController;
  late final TextEditingController _photoURLController;
  late final TextEditingController _textController;
  PlatformFile? _pickedFile;
  UploadTask? uploadTask;
  String? uploadedPhotoURL;

  Future<CloudShelterInfo> createOrGetExistingShelter(BuildContext context) async {

    final widgetShelter = context.getArgument<CloudShelterInfo>();
    // If we have a shelter passed in from the widget, use it. Otherwise, create a new one.
    if (widgetShelter != null) {
      _shelter = widgetShelter;
      _titleController.text = widgetShelter.title;
      _addressController.text = widgetShelter.address;
      _photoURLController.text = widgetShelter.photoURL ?? '';
      // uploadedPhotoURL = widgetShelter.photoURL ?? '';
      _textController.text = widgetShelter.text ?? '';
      return widgetShelter;
    }

    final existingShelter = _shelter;
    if (existingShelter != null) {
      return existingShelter;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final newShelter = await _sheltersService.createNewShelter(ownerUserId: currentUser.id, userName: currentUser.email);
    _shelter = newShelter;
    return newShelter;
  }

  void _deleteShelterIfIncomplete() {
    final shelter = _shelter;
    if ((_titleController.text.isEmpty || _addressController.text.isEmpty) && shelter != null) {
      _sheltersService.deleteShelter(documentId: shelter.documentId);
    }
  }

  void _saveShelterIfNotEmpty() async {
    final shelter = _shelter;
    final title = _titleController.text;
    final address = _addressController.text;
    final photoURL = _photoURLController.text;
    final text = _textController.text;
    if (shelter != null && title.isNotEmpty && address.isNotEmpty) {
      await _sheltersService.updateShelter(
        documentId: shelter.documentId,
        title: title,
        address: address,
        photoURL: photoURL,
        text: text,
      );
    }
  }

  @override
  void initState() {
    _sheltersService = FirebaseShelterStorage();
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result == null) return;

    setState(() {
      _pickedFile = result.files.first;
    });
  }

 Future<void> uploadFile() async {
    if (_pickedFile == null) return;

    final path = 'files/${_pickedFile!.name}';
    final file = File(_pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    await uploadTask!.whenComplete(() {});

    final downloadURL = await ref.getDownloadURL();

    setState(() {
      uploadedPhotoURL = downloadURL;
      uploadTask = null;
    });
  }

  Widget buildProgress() {
    if (uploadTask != null) {
      return StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final progress =
                snapshot.data!.bytesTransferred / snapshot.data!.totalBytes;
            return SizedBox(
              height: 50,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.green,
                  ),
                  Center(
                    child: Text(
                      '${(progress * 100).roundToDouble()} %',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const LinearProgressIndicator(
              value: 100,
              backgroundColor: Colors.grey,
              color: Colors.green,
            );
          }
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const FadeAnimation(1, Axis.vertical,
          Text('Please fill in shelter info...')),
        // backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            if (uploadedPhotoURL != null && uploadedPhotoURL != '') {
              _photoURLController.text = uploadedPhotoURL!;
            }
            if (_shelter == null || _titleController.text.isEmpty || _addressController.text.isEmpty) {
              final continueEditing = await showCannotSaveIncompleteShelterInfoDialog(context);
              if (!continueEditing) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }
            }
            else if (_shelter == null || _photoURLController.text.isEmpty) {
              // ignore: use_build_context_synchronously
              final continueWithoutPhoto = await showPhotoInvalidFormatDialog(context);
              if (continueWithoutPhoto) {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              }
            } else {
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            }
          }
        ),
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
          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: createOrGetExistingShelter(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupControllerListener();
                return Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        TextInput(
                          controller: _titleController,
                          hint: 'Title...',
                          icon: Icons.title,
                          inputAction: TextInputAction.none,
                          width: 350,
                        ),
                        TextInput(
                          controller: _addressController,
                          hint: 'Address...',
                          icon: Icons.location_city,
                          inputAction: TextInputAction.none,
                          width: 350,
                        ),
                        TextInput(
                          controller: _textController,
                          keyboardType: TextInputType.multiline,
                          hint: 'Type text...',
                          icon: Icons.text_fields,
                          width: 350,
                          maxLines: 100,
                        ),
                        const SizedBox(height: 30,),
                        ElevatedButton(
                          onPressed: selectFile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Background color
                          ),
                          child: const Text("Select file", style: TextStyle(color: Colors.black)),
                        ),
                        if (_pickedFile != null)
                          const Text("File is selected"),
                        const SizedBox(height: 20,),
                        ElevatedButton(
                          onPressed: uploadFile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Background color
                          ),
                          child: const Text("Upload file", style: TextStyle(color: Colors.black))
                        ),
                        uploadTask != null ? buildProgress() : Container(),
                        const SizedBox(height: 70,),
                        if (uploadedPhotoURL != null && uploadedPhotoURL != '')
                          Image.network(
                            uploadedPhotoURL!,
                            height: 200.0,
                            width: 200.0,
                            fit: BoxFit.cover,
                          ),
                        const SizedBox(height: 70,),
                      ],
                    ),
                  );
                // );
              default:
                return const Center(child: CircularProgressIndicator());
          }
        },),
      )
    );
  }
}