part of 'map_view_bloc.dart';

class MapViewState extends Equatable {
  final bool loading;
  final bool error;
  final bool empty;
  final List<CountryModel> countries;
  final List<CountryModel> filteredCountries;
  final Completer<GoogleMapController> mapController;
  final LatLng ph;

  MapViewState({
    this.loading,
    this.error,
    this.empty,
    this.countries,
    this.ph,
    this.mapController,
    this.filteredCountries,
  });

  factory MapViewState.init() {
    return MapViewState(
        loading: true,
        mapController: Completer(),
        ph: LatLng(
          13.00,
          122.00,
        ));
  }

  MapViewState update({
    bool loading,
    bool error,
    bool empty,
    List<CountryModel> countries,
    List<CountryModel> filteredCountries
  }) {
    return MapViewState(
      loading: loading ?? false,
      error: error ?? false,
      empty: empty ?? false,
      countries: countries ?? this.countries,
      ph: this.ph,
      mapController: this.mapController,
      filteredCountries: filteredCountries ?? this.filteredCountries,
    );
  }

  @override
  List<Object> get props => [
        loading,
        error,
        empty,
        countries,
        mapController,
        ph,
        filteredCountries,
      ];
}
