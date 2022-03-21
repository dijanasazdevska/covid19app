import 'package:covid19app/blocs/user_cubit.dart';
import 'package:covid19app/blocs/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../data/models/user.dart';
import '../page/user_page.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Material(
        color: Colors.blue,
        child: BlocBuilder<UserCubit, UserState>(builder:
        (context,state) {
          return ListView(
            children: <Widget>[
              buildHeader(
                  context,
                  onClicked: () async {
                    if (state is UserLoggedOutState) {
                      BlocProvider.of<UserCubit>(context).login();
                    }
                    else {
                      PickedFile? pickedFile = await ImagePicker().getImage(
                        source: ImageSource.camera,
                        maxWidth: 1800,
                        maxHeight: 1800,
                      );
                      if(pickedFile != null) {
                        BlocProvider.of<UserCubit>(context).changeProfilePicture(pickedFile);
                      }
                    }
                  }),
              Container(
                padding: padding,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const SizedBox(height: 24),
                    buildMenuItem(
                      text: 'Profile',
                      icon: Icons.person,
                      onClicked: () {
                        Navigator.of(context).pop();
                        if(state is UserLoggedInState){
                          final user = BlocProvider.of<UserCubit>(context).getUser();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                UserPage(
                                    user: user
                                ),
                          ));
                        }
                        else {
                          BlocProvider.of<UserCubit>(context).login();

                      }}
                    ),
                    const SizedBox(height: 16),
                    buildMenuItem(
                      text: state is UserLoggedOutState?'Login':'Log out',
                      icon: state is UserLoggedOutState? Icons.login: Icons.logout,
                      onClicked: () => {
                        state is UserLoggedOutState?BlocProvider.of<UserCubit>(context).login():BlocProvider.of<UserCubit>(context).logout()
                      }
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        )
    ));
  }

  Widget buildHeader(BuildContext context,{
    required VoidCallback onClicked,
  })
  {
    var name='';
    ImageProvider urlImage = const AssetImage('assets/images/user.png');
    var email='';
    User? user;
    if(BlocProvider.of<UserCubit>(context).state is UserLoggedInState){
       user = BlocProvider.of<UserCubit>(context).getUser();
      name = user.name;
      urlImage = user.urlImage;
      email = user.email;
    }

    return InkWell(
      onTap: onClicked,
      child: Container(
        padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: urlImage),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ],
            ),
            Spacer()
          ],
        ),
      ),
    );
  }


  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}
