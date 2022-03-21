import 'package:flutter/cupertino.dart';

class User {
  final String name;
  var urlImage;
  final String email;

  User({ this.name='',  this.email='',  this.urlImage = const AssetImage('assets/images/user.png')});
}