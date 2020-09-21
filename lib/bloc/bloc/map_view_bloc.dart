import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'map_view_event.dart';
part 'map_view_state.dart';

class MapViewBloc extends Bloc<MapViewEvent, MapViewState> {
  MapViewBloc() : super(MapViewState.init());

  @override
  Stream<MapViewState> mapEventToState(
    MapViewEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
