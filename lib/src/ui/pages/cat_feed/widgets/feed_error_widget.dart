import 'package:catfact/src/cubits/index_cubit.dart';
import 'package:flutter/material.dart';

class FeedErrorWidegt extends StatelessWidget {
  const FeedErrorWidegt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Something went wrong.\nPlease try again',
            textAlign: TextAlign.center,
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            onPressed: catFeedCubit.getFactsForFeed,
            child: const Text(
              'Try again',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
