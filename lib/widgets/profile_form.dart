import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/db_provider.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    Key? key,
  }) : super(key: key);
  static const name = '/profile_form';

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  var _nameController = TextEditingController();
  String _imagePath = '';
  _getImageFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 200.0,
      maxWidth: 200.0,
    );
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  @override
  void initState() {
    final provider = Provider.of<Dbprovider>(context, listen: false);
    _imagePath = provider.imagePath;
    _nameController = TextEditingController(text: provider.userName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Dbprovider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.only(top: 80.0, left: 30.0, right: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.pink.shade50,
                ),
                clipBehavior: Clip.hardEdge,
                child: _imagePath == ''
                    ? const Icon(
                        Icons.person,
                        size: 40.0,
                      )
                    : Image.file(
                        File(_imagePath),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          //
          Align(
            alignment: Alignment.center,
            child: TextButton(
                onPressed: _getImageFromGallery,
                child: const Text(
                  'Add Image',
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
          //
          const SizedBox(height: 40.0),
          //
          const Text(
            'What should we call you ?',
            textScaleFactor: 1.2,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: _nameController,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: 'ex. - source code...',
              hintStyle: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 40.0),
          //
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text != '' && _imagePath != '') {
                  provider.addUser(_nameController.text, _imagePath);
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Save',
                textScaleFactor: 1.2,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
