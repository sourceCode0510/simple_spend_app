import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
//
import '../models/db_provider.dart';
import '../models/spend.dart';

class SpendForm extends StatefulWidget {
  const SpendForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SpendForm> createState() => _SpendFormState();
}

class _SpendFormState extends State<SpendForm> {
  DateTime _currentDate = DateTime(2022);
  _selectDate() async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
    ).then((selected) {
      if (selected != null || selected != _currentDate) {
        setState(() {
          _currentDate = selected!;
        });
      }
    });
  }

  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 70.0),
          const Text(
            'Keep track of your spendings',
            textScaleFactor: 2.8,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50.0),
          const Text(
            'How much are you spending?',
            textScaleFactor: 1.1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              prefixText: '₹ ',
              prefixStyle: TextStyle(fontSize: 22.0),
              hintText: '10000.00',
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 50.0),
          const Text(
            'What are you spending on?',
            textScaleFactor: 1.1,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            controller: _titleController,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: 'ex. - Bought a Monitor',
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentDate == DateTime(2022)
                    ? 'no date selected'
                    : DateFormat('MMM dd, yyyy').format(_currentDate),
                textScaleFactor: 1.1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                  onPressed: _selectDate,
                  child: const Text(
                    'Select Date',
                    textScaleFactor: 1.1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
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
                  if (_amountController.text.trim() == '' ||
                      _titleController.text.trim() == '') {
                    return;
                  } else {
                    if (_currentDate == DateTime(2022)) {
                      _currentDate = DateTime.now();
                    }
                    var newSpending = Spend(
                        id: 0,
                        title: _titleController.text,
                        amount: double.parse(_amountController.text),
                        date: _currentDate);
                    Navigator.of(context).pop();
                    Provider.of<Dbprovider>(context, listen: false)
                        .addSpending(newSpending);
                  }
                },
                child: const Text(
                  'Add Spending',
                  textScaleFactor: 1.1,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
