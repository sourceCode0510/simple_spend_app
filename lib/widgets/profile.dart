import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//
import '../models/db_provider.dart';
import './profile_form.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    final provider = Provider.of<Dbprovider>(context, listen: false);
    provider.fetchAndSetUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const ProfileForm(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(4.0),
        width: 60.0,
        height: 60.0,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Consumer<Dbprovider>(
          builder: (context, value, child) => value.imagePath == ''
              ? const Icon(Icons.person)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: Image.file(
                    File(value.imagePath),
                    fit: BoxFit.cover,
                  )),
        ),
      ),
    );
  }
}
