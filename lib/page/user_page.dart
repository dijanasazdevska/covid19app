import '../data/models/user.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  User user;
   UserPage({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(user.name),
          centerTitle: true,
        ),
  body: Container(
    constraints: const BoxConstraints.expand(),
    decoration: BoxDecoration(
        image: DecorationImage(
            image: user.urlImage,
            fit: BoxFit.cover)
    ),
  )
      );
}
