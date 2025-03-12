import 'package:flutter/material.dart';

class MyDisplayContainer extends StatelessWidget {
  final Widget left;
  final Widget right;
  const MyDisplayContainer(
      {super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onPrimaryFixed,
            blurRadius: 4,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          left,
          right,
        ],
      ),
    );
  }
}
