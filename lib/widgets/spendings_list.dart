import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
//
import '../models/db_provider.dart';
import './spend_card.dart';

class SpendingsList extends StatefulWidget {
  const SpendingsList({
    Key? key,
  }) : super(key: key);

  @override
  State<SpendingsList> createState() => _SpendingsListState();
}

class _SpendingsListState extends State<SpendingsList> {
  late Future _list;

  // get the spending list using provider
  _getList() async {
    Provider.of<Dbprovider>(context, listen: false).fetchAndSetSpendingData();
    return Provider.of<Dbprovider>(context, listen: false).spendings;
  }

  @override
  void initState() {
    _list = _getList();
    super.initState();
  }

  // to generate random colors for spend cards
  Color get rdmColor {
    var random = Random();
    return Colors
        .primaries[random.nextInt(Colors.primaries.length - 1)].shade100;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _list,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Consumer<Dbprovider>(
              builder: (context, tx, child) {
                return tx.spendings.isEmpty
                    // if the list is empty then it will show this message
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'No transactions at the moment',
                              textScaleFactor: 1.6,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Press the '+' button to add",
                              textScaleFactor: 1.2,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    // else it will show the spending list
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 50.0),
                        physics: const BouncingScrollPhysics(),
                        itemCount: tx.spendings.length,
                        itemBuilder: (ctx, i) {
                          return Dismissible(
                            key: ValueKey(tx.spendings[i].id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) async {
                              return showDialog(
                                context: context,
                                builder: (ctx) => ConfirmDialog(
                                  id: tx.spendings[i].id,
                                  title: tx.spendings[i].title,
                                ),
                              );
                            },
                            child: SpendCard(
                              spending: tx.spendings[i],
                              color: rdmColor,
                            ),
                          );
                        },
                      );
              },
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    required this.id,
    required this.title,
  }) : super(key: key);
  final int id;
  final String title;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Dbprovider>(context, listen: false);
    return AlertDialog(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Text('Delete $title ?'),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                'Don\'t delete',
                textScaleFactor: 1.1,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
          //
          const SizedBox(width: 15.0),
          //
          ElevatedButton(
            onPressed: () {
              provider.deleteSpending([id]);
              Navigator.of(context).pop(true);
            },
            child: const Text(
              'Delete',
              textScaleFactor: 1.1,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
