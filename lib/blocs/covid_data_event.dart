abstract class CovidDataEvent{

}

class LoadCovidDataEvent extends CovidDataEvent{
  String type;
  LoadCovidDataEvent({this.type='All time'});

}

class LoadingCovidDataEvent extends CovidDataEvent{}

class CovidDataLoadedEvent extends CovidDataEvent{

}