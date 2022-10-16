import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//
import '../models/spend.dart';

class SpendCard extends StatelessWidget {
  const SpendCard({Key? key, required this.spending, required this.color})
      : super(key: key);
  final Spend spending;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: color,
      ),
      height: 90.0,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          //
          // the amount area,
          // with the fitted box, when the amount gets bigger, then the size get's scaled down
          //
          Expanded(
            flex: 35,
            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.scaleDown,
              child: Text(
                NumberFormat.currency(
                        locale: 'en-In', symbol: '₹', decimalDigits: 2)
                    .format(spending.amount),
                textScaleFactor: 1.1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  // color: textColor,
                ),
              ),
            ),
          ),
          //
          // a divider
          //
          const SizedBox(height: 50.0, child: VerticalDivider()),
          //
          // the title and date area
          //
          Expanded(
            flex: 65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //
                // title of the spending
                //
                Text(
                  spending.title,
                  textScaleFactor: 1.3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: textColor,
                  ),
                ),
                const SizedBox(height: 8.0),
                //
                // date of the spending
                //
                Text(
                  'Date: ${DateFormat('MMM dd, yyyy').format(spending.date)}',
                ),
              ],
            ),
          ),
          //
        ],
      ),
    );
  }
}
