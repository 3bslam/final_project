import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleDashItem extends StatelessWidget {
  final String title, subtitle;
  final void Function()? onPressed;
  const SingleDashItem(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Card(
        child: Container(
          width: double.infinity,
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: subtitle == "Earning" ? 28 : 35.0,
                ),
              ),
              Text(subtitle, style: const TextStyle(fontSize: 20.0)),
            ],
          ),
        ),
      ),
    );
  }
}
