import 'covid_data_event.dart';
import 'covid_data_state.dart';
import '/data/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CovidDataBloc extends Bloc<CovidDataEvent, CovidDataState> {
  final Repository repository;
  String type = "All time";
  String country = "";
  CovidDataBloc({required this.repository}) :super(LoadingCovidDataState()){
    on<LoadCovidDataEvent>((event,emit) async {
      emit(LoadingCovidDataState());
        if(type != event.type) {
          type = event.type;
        }
        var data;
        await repository.fetchByCountry(type).then(
            (d){
              data = d;
              if(data.isNotEmpty){
                country = data[0].country;
              }
              emit(LoadedCovidDataState(data: data));
            },
            onError: (e) {
              emit(FailedToLoadCovidDataState());
            });
      });
    }
}