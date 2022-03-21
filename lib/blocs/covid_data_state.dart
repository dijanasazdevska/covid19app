import '../data/models/covid_data.dart';

abstract class CovidDataState {}

class LoadingCovidDataState extends CovidDataState{}

class LoadedCovidDataState extends CovidDataState{
  final List<CovidData> data;

  LoadedCovidDataState({required this.data});
}

class FailedToLoadCovidDataState extends CovidDataState{
}