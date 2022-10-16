import 'package:flutter/material.dart';
//
import './chart_box.dart';

class SpendingTitleAndChart extends StatelessWidget {
  const SpendingTitleAndChart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Transactions',
          textScaleFactor: 1.2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => const ChartBox(),
            );
          },
          child: Icon(
            Icons.stacked_line_chart_rounded,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
