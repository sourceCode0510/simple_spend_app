import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/db_provider.dart';
import './home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  static const name = '/Onboarding_screen';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  String _imagePath = '';

  // for selecting image from gallery
  // to select image from camera,
  // just change the source to "ImageSource.camera"
  _getImageFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 200.0,
      maxWidth: 200.0,
      imageQuality: 10,
    );
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  // for saving registered data
  _saveData() async {
    // get the instance of shared preferences
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // set the login to 1
    await preferences.setInt('loggedIn', 1);
  }

  _addUser() async {
    final provider = Provider.of<Dbprovider>(context, listen: false);

    provider.addUser(_nameController.text, _imagePath);
    // save the userdata,
    // so next time the onboarding screen will not appear.
    await _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30.0),
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Let\'s set up your profile.',
              textScaleFactor: 2.0,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40.0),
            //
            // Profile photo selected by the user
            //
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 100.0,
                height: 100.0,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blueGrey.shade50,
                ),
                child: _imagePath == ''
                    ? const Icon(Icons.person)
                    : Image.file(
                        File(_imagePath),
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
              ),
            ),
            const SizedBox(height: 10.0),
            //
            // photo selection button
            //
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: _getImageFromGallery,
                child: const Text(
                  'Add Image',
                  textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            //
            // username input
            //
            const Text(
              'What should we call you ?',
              textScaleFactor: 1.2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _nameController,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            const Text('ex. - source code. etc.')
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 150.0,
        height: 50.0,
        child: FloatingActionButton(
          onPressed: () {
            if (_nameController.text != '' && _imagePath != '') {
              // if the name and image are not empty then,
              // add the user to database
              _addUser();
              // switch to the homescreen.
              Navigator.of(context).pushReplacementNamed(HomeScreen.name);
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          child: const Text(
            'Finish',
            textScaleFactor: 1.2,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
