import 'package:flutter/material.dart'; // to access the change notifier
import 'package:sqflite/sqflite.dart'; // for database
import 'package:path/path.dart' as p; // to access the db directory
import './spend.dart';

class Dbprovider with ChangeNotifier {
  // in-app containers for our spendings
  List<Spend> _spendings = [];
  List<Spend> get spendings => [..._spendings.reversed];

  // in-app containers for our userData.
  String _userName = '';
  String get userName => _userName;

  String _imagePath = '';
  String get imagePath => _imagePath;

  // setup the database
  Database? _database;
  Future<Database> get database async {
    // the database location in device
    final dbpath = await getDatabasesPath();
    // the database name
    const dbname = 'spends.db';

    // full path of the database, => example - data/documents/spends.db
    final path = p.join(dbpath, dbname);

    _database = await openDatabase(
      path, // the database full path
      version: 1,
      onCreate: _createDb, //  defined separately below
    );

    return _database!;
  }

  static const spendTable = 'spendings'; // our table for the spendings
  static const userTable = 'user'; //  table for userdata.
  // create tables
  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute('''
      CREATE TABLE $spendTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount TEXT,
        date TEXT
      )
      ''');

      await txn.execute('''CREATE TABLE $userTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        img TEXT
      )''');
    });
  }

  // function to add and update the user
  Future<void> addUser(String name, String img) async {
    // get the database
    final db = await database;
    await db.transaction((txn) async {
      // add or replace the user data
      await txn
          .insert(
        userTable,
        {
          'id': 1,
          'name': name,
          'img': img,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then((_) {
        _userName = name;
        _imagePath = img;
        notifyListeners();
      });
    });
  }

  // function to set User data when the app starts.
  Future<void> fetchAndSetUser() async {
    // get the database
    final db = await database;
    await db.transaction((txn) async {
      // fetch the userdata from database
      await txn.query(userTable).then((List<Map<String, dynamic>> userData) {
        if (userData.isNotEmpty) {
          // set the data to in-app containers
          _userName = userData[0]['name'];
          _imagePath = userData[0]['img'];
          notifyListeners();
        }
      });
    });
  }

  // function to add spending
  Future<void> addSpending(Spend spend) async {
    // get the database
    final db = await database;

    await db.transaction((txn) async {
      // add the data to database
      await txn
          .insert(
        spendTable,
        spend.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      )
          .then((value) {
        // create a new spending variable with the autogenerated id (value)
        var newSpending = Spend(
            id: value,
            title: spend.title,
            amount: spend.amount,
            date: spend.date);
        // add to the in-app memory
        _spendings.add(newSpending);
        notifyListeners();
      });
    });
  }

  // function to delete spending
  // passing the list of ids instead of just a single id,
  // so that we can delete multiple spendings or a single spending from the same function
  Future<void> deleteSpending(List<int> ids) async {
    // get the database
    final db = await database;

    await db.transaction((txn) async {
      // only delete the spending where the id of the spending matches the id of the argument
      for (int i = 0; i < ids.length; i++) {
        await txn.delete(spendTable,
            where: 'id == ?', whereArgs: [ids[i]]).then((value) {
          // delete the spending from the in-app memory too
          _spendings.removeWhere((element) => element.id == ids[i]);
          notifyListeners();
        });
      }
    });
  }

  // function to fetch and set the spending data when the app starts
  Future<void> fetchAndSetSpendingData() async {
    // get the database
    final db = await database;

    await db.transaction((txn) async {
      // fetch the data from database
      await txn
          .query(spendTable)
          .then((List<Map<String, dynamic>> fetchedData) {
        // convert the data from List<Map<String, dynamic>> to List<Spending>

        List<Spend> newList = List.generate(
            fetchedData.length,
            (index) => Spend(
                  id: fetchedData[index]['id'],
                  title: fetchedData[index]['title'],
                  amount: double.parse(
                      fetchedData[index]['amount']), // text to double
                  date: DateTime.parse(
                      fetchedData[index]['date']), // text to DateTime
                ));
        // set the in-app list to the new list generated above
        _spendings = newList;
        notifyListeners();
      });
    });
  }
}
