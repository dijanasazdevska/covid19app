import 'package:covid19app/blocs/user_cubit.dart';
import '../blocs/covid_data_bloc.dart';
import '../blocs/covid_data_event.dart';
import '../blocs/covid_data_state.dart';
import '../data/models/covid_data.dart';
import '../widget/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/cupertino.dart';


class ChartPage extends StatelessWidget {
  late FocusNode focusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CovidDataBloc, CovidDataState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Covid19 App'),
              ),
              floatingActionButton:  Visibility(visible:state is! LoadingCovidDataState,
                  child:
                  FloatingActionButton(
                    onPressed: () {
                      BlocProvider.of<CovidDataBloc>(context).add(LoadCovidDataEvent());
                    },
                    child: const Icon(Icons.refresh),
                  )),
              drawer: BlocProvider.value(
                  value: BlocProvider.of<UserCubit>(context),
                  child: NavigationDrawerWidget()
              ),
              body: buildBody(context, state));
        });
  }

  Widget buildBody(BuildContext context, CovidDataState state) {
    if (state is LoadingCovidDataState) {
      return const Center(child: CircularProgressIndicator());
    }
    else if (state is LoadedCovidDataState) {
      final data = state.data;
      return Column(children: [
        DropdownButton<String>(
          value: BlocProvider
              .of<CovidDataBloc>(context)
              .type,
          focusNode: focusNode,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.blue),
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (String? newValue) {
            BlocProvider.of<CovidDataBloc>(context).add(
                LoadCovidDataEvent(type: newValue!));
            focusNode.unfocus();
          },
          isExpanded: true,
          items: <String>[
            'All time',
            '2 weeks',
            '30 days',
            '3 months',
            '6 months'
          ]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SingleChildScrollView(child: Column(children: [
          SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              // Chart title
              title: ChartTitle(text: 'Cases of Covid per date in ${BlocProvider
                  .of<CovidDataBloc>(context)
                  .country}'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<CovidData, DateTime>>[
                LineSeries<CovidData, DateTime>(
                    dataSource: data,
                    xValueMapper: (CovidData data, _) => data.date,
                    yValueMapper: (CovidData data, _) => data.confirmed,
                    name: 'Confirmed',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true)),
                LineSeries<CovidData, DateTime>(
                    dataSource: data,
                    xValueMapper: (CovidData data, _) => data.date,
                    yValueMapper: (CovidData data, _) => data.active,
                    name: 'Active',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
          SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<CovidData, DateTime>>[
                LineSeries<CovidData, DateTime>(
                    dataSource: data,
                    xValueMapper: (CovidData data, _) => data.date,
                    yValueMapper: (CovidData data, _) => data.deaths,
                    name: 'Recovered',
                    dataLabelSettings: DataLabelSettings(isVisible: true)),
                LineSeries<CovidData, DateTime>(
                    dataSource: data,
                    xValueMapper: (CovidData data, _) => data.date,
                    yValueMapper: (CovidData data, _) => data.recovered,
                    name: 'Deaths',
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]

          )
        ]))
      ]);
    }
    else {
      return const Center(
        child:
        Text('Please check your internet connection.'),
      );
    }
  }
}