import 'package:flutter/material.dart';
//
import '../widgets/profile.dart';
import '../widgets/greetings.dart';
import '../widgets/spending_title_and_chart.dart';
import '../widgets/spendings_list.dart';
import '../widgets/spend_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const name = '/home_screen';
  @override
  Widget build(BuildContext context) {
    // get the dimensions of the device
    var maxWidth = MediaQuery.of(context).size.width;
    var padding = MediaQuery.of(context).padding.top;
    var maxHeight = MediaQuery.of(context).size.height - padding;
    return Scaffold(
      body: Container(
        width: maxWidth,
        height: maxHeight,
        margin: EdgeInsets.only(top: padding),
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            //
            // profile pic
            //
            const Align(
              alignment: Alignment.centerLeft,
              child: Profile(),
            ),
            const SizedBox(height: 30.0),
            //
            //Greetings
            //
            Container(
              width: maxWidth,
              height: maxHeight * 0.1,
              alignment: Alignment.centerLeft,
              child: const Greetings(),
            ),
            //
            // Spendings title and Chart button
            //
            SizedBox(
              width: maxWidth,
              height: maxHeight * 0.1,
              child: const SpendingTitleAndChart(),
            ),
            //
            // Spendings List
            //
            const Expanded(child: SpendingsList()),
          ],
        ),
      ),
      //
      // add Spending button
      //
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (ctx) => const SpendForm(),
          );
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          size: 30.0,
        ),
      ),
    );
  }
}
