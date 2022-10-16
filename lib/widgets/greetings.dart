import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//
import '../models/db_provider.dart';

class Greetings extends StatelessWidget {
  const Greetings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<Dbprovider>(
          builder: (context, value, child) => value.userName == ''
              ? const Text(
                  'Hello User',
                  textScaleFactor: 2.0,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  'Hello ${value.userName}',
                  textScaleFactor: 2.0,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const Text(
          'Welcome back !',
          textScaleFactor: 1.1,
        ),
      ],
    );
  }
}
