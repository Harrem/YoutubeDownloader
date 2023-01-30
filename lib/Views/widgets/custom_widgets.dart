import 'package:flutter/material.dart';

class CardWithSideButtion extends StatefulWidget {
  final String btnText;
  final String titleText;
  final String subtitleText;
  final Function onPressed;
  const CardWithSideButtion({
    super.key,
    required this.titleText,
    required this.subtitleText,
    required this.btnText,
    required this.onPressed,
  });

  @override
  State<CardWithSideButtion> createState() => _CardWithSideButtionState();
}

class _CardWithSideButtionState extends State<CardWithSideButtion> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.titleText,
                    style: Theme.of(context).textTheme.titleMedium),
                Text(widget.subtitleText,
                    style: Theme.of(context).textTheme.caption),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(widget.btnText),
            )
          ],
        ),
      ),
    );
  }
}
