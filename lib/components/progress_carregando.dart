import 'package:flutter/material.dart';

class ProgressBarCarregando extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          Text("Carregando")
        ],
      ),
    );
  }
}
