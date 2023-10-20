import 'package:flutter/material.dart';

class FeedLoadingWidget extends StatelessWidget {
  const FeedLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: CircularProgressIndicator.adaptive()),
        Text(
          "Please wait\n We are loading Cat Facts.",
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
