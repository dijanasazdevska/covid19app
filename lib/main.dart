
import 'package:covid19app/blocs/user_cubit.dart';

import '/blocs/covid_data_bloc.dart';
import '/blocs/covid_data_event.dart';
import 'package:covid19app/data/repository.dart';
import 'package:covid19app/page/chart_page.dart';
import 'package:covid19app/services/location_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/network_service.dart';
import 'package:flutter/material.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Navigation Drawer';

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: MultiBlocProvider(
      providers:
      [BlocProvider(create: (context) =>
      CovidDataBloc(repository: Repository(networkService: NetworkService(), locationService: LocationService()))..add(LoadCovidDataEvent())),
        BlocProvider(create: (context) =>
        UserCubit())
  ],
        child:ChartPage())
  );
}
