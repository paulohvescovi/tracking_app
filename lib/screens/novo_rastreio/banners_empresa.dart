import 'package:flutter/material.dart';

class BannersEmpresa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'images/rede_sul.png',
          width: 100,
        ),
        Image.asset(
          'images/correios.jpg',
          width: 100,
        ),
        Image.asset(
          'images/sequoia.jpg',
          width: 100,
        ),
      ],
    );
  }
}
