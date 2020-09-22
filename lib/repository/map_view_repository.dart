import 'package:mesio_map_view/models/country_model.dart';
import 'package:mesio_map_view/repository/service_provider.dart';

class MapViewRepository {
  Future<List<CountryModel>> getCountries() async {
    List<CountryModel> _countries;

    final _res = await ServiceProvider().getRequestToNetwork(
      url: "https://restcountries.eu/rest/v2/all",
    );

    try {
      _countries = countryModelFromJson(_res.response);
    } catch (_) {}

    return _countries;
  }
}
