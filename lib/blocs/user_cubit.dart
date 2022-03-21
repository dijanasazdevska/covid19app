import 'dart:io';

import 'package:covid19app/blocs/user_state.dart';
import 'package:covid19app/data/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class UserCubit extends Cubit<UserState>{
  late User _user;
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ]);
  UserCubit() : super(UserLoggedOutState());

  login() async {
    try {
      await _googleSignIn.signIn();
      GoogleSignInAccount? account = _googleSignIn.currentUser;
      if (account!=null) {
        GoogleSignInAccount account = _googleSignIn.currentUser!;
        _user = User(email: account.email, name: account.displayName ?? "", urlImage: NetworkImage(account.photoUrl!));
        emit(UserLoggedInState());
      }
    }
    on Error catch(e) {
      emit(UserLoggedOutState());
    }
  }

  logout() async {
    await _googleSignIn.signOut();
    if(await _googleSignIn.isSignedIn()){
      emit(UserLoggedInState());
    }
    else {
      emit(UserLoggedOutState());
    }
  }

  User getUser() {
    return _user;
  }

  void changeProfilePicture(PickedFile pickedFile) {
    _user.urlImage = FileImage(File(pickedFile.path));
    emit(UserLoggedInState());
  }
}