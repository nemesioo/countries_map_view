part of 'map_view_bloc.dart';

abstract class MapViewEvent extends Equatable {
  const MapViewEvent();

  @override
  List<Object> get props => [];
}

class GetCountries extends MapViewEvent {
  @override
  List<Object> get props => null;
}

class SearchCountries extends MapViewEvent {
  final String query;
  SearchCountries({this.query});

  @override
  List<Object> get props => [query];
}