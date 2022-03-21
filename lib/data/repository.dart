import 'package:covid19app/data/models/covid_data.dart';
import 'package:covid19app/data/network_service.dart';
import 'package:covid19app/services/location_service.dart';

class Repository {
  final NetworkService networkService;
  final LocationService locationService;

  Repository({required this.networkService, required this.locationService});

  Future<List<CovidData>> fetchByCountry(String value) async {
    var country;
    country = await locationService.determinePosition().catchError((error) =>
    country = "USA"
    );
    print(country);
    var covidData = await networkService.fetchByCountry(country, value);
    return covidData.map((e) => CovidData.fromJson(e)).toList();
  }
}