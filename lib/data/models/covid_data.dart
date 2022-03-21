class CovidData {
  late String country;
  late DateTime date;
  late int active;
  late int confirmed;
  late int deaths;
  late int recovered;


  CovidData.fromJson(Map json) :
    country = json["Country"],
    date = DateTime.parse(json["Date"]),
    active = json["Active"],
    confirmed = json["Confirmed"],
    deaths = json["Deaths"],
    recovered = json["Recovered"];

}