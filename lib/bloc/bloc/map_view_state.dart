part of 'map_view_bloc.dart';

class MapViewState extends Equatable {
  final bool loading;
  final bool error;
  final bool empty;

  MapViewState({
    this.loading,
    this.error,
    this.empty,
  });

  factory MapViewState.init() {
    return MapViewState(loading: true);
  }

  @override
  List<Object> get props => [
        loading,
        error,
        empty,
      ];
}
