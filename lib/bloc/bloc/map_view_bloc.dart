import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mesio_map_view/models/country_model.dart';
import 'package:mesio_map_view/repository/map_view_repository.dart';

part 'map_view_event.dart';
part 'map_view_state.dart';

class MapViewBloc extends Bloc<MapViewEvent, MapViewState> {
  MapViewRepository _mapViewRepository = MapViewRepository();

  MapViewBloc() : super(MapViewState.init());

  @override
  Stream<MapViewState> mapEventToState(
    MapViewEvent event,
  ) async* {
    if (event is GetCountries) {
      yield* _mapGetCountriesToState();
    }
    if (event is SearchCountries) {
      yield* _mapSearchCountriesToState(event.query);
    }
  }

  Stream<MapViewState> _mapSearchCountriesToState(String query) async* {
    if (query != "") {
      List<CountryModel> _filteredCountries = [];

      state.countries.forEach((country) {
        if (country.name.toString().toLowerCase().contains(query) ||
            country.capital.toString().toLowerCase().contains(query)) {
          _filteredCountries.add(country);
        }
      });

      yield state.update(
        filteredCountries: _filteredCountries,
      );
    } else {
      yield state.update(
        filteredCountries: state.countries,
      );
    }
  }

  Stream<MapViewState> _mapGetCountriesToState() async* {
    yield state.update(loading: true);

    await Future.delayed(Duration(milliseconds: 200));

    List<CountryModel> _countries = await _mapViewRepository.getCountries();

    try {
      yield state.update(
        empty: _countries.isEmpty,
        countries: _countries,
        filteredCountries: _countries,
      );
    } catch (_) {
      yield state.update(error: true);
    }
  }
}
