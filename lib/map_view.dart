import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mesio_map_view/bloc/bloc/map_view_bloc.dart';
import 'package:mesio_map_view/models/country_model.dart';
import 'package:mesio_map_view/utils/misc.dart';

class MapView extends StatefulWidget {
  final CountryModel country;
  MapView({this.country});
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapViewBloc _mapViewBloc;
  MapViewState _state;
  TextEditingController _searchQuery;
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    _mapViewBloc = MapViewBloc();
    _mapViewBloc.add(GetCountries());
    _searchQuery = TextEditingController();
    _searchQuery.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _mapViewBloc.close();
    _searchQuery.removeListener(_onSearchChanged);
    _searchQuery.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(
      Duration(milliseconds: 500),
      () {
        _mapViewBloc.add(
          SearchCountries(query: _searchQuery.text),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _mapViewBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "${widget.country != null ? widget.country.name : "Countries"}"),
          centerTitle: true,
        ),
        body: BlocBuilder<MapViewBloc, MapViewState>(
          builder: (context, state) {
            this._state = state;

            return state.loading
                ? Misc.loader()
                : state.error
                    ? Misc.reload(func: () {})
                    : state.empty
                        ? Misc.empty(message: "No Response")
                        : _mapView();
          },
        ),
      ),
    );
  }

  Widget _mapView() {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: widget.country != null ? _countryInfo() : _countryListView(),
    );
  }

  Widget _countryListView() {
    Widget _flag(CountryModel country) {
      // Widget _widget;
      return Builder(
        builder: (BuildContext context) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            Misc.debugP(tag: this, message: errorDetails);
            return Container(width: 50.0, child: Icon(Icons.error));
          };
          return SvgPicture.network(
            country.flag,
            height: 50.0,
            placeholderBuilder: (BuildContext context) => Container(
              padding: EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 30.0,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[300]),
              child: Icon(
                Icons.more_horiz,
                color: Colors.grey,
              ),
            ),
          );
        },
      );
      // try {

      // } on StackOverflowError catch (_) {
      //   _widget =
      // } on PlatformException catch (_) {
      //   _widget = Container(width: 50.0, child: Icon(Icons.error));
      // } catch (_) {
      //   Misc.debugP(tag: this, message: _);
      //   _widget = Container(width: 50.0, child: Icon(Icons.error));
      // }

      // return _widget;
    }

    Widget _search() {
      return TextField(
        controller: _searchQuery,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xff707070),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          fillColor: Color(0xffF2F2F2),
          filled: true,
          labelText: "Country name or Country capital",
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _search(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _state.filteredCountries.map((country) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => MapView(
                                country: country,
                              )));
                    },
                    child: Card(
                      elevation: 2.0,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(child: Text("${country.name}")),
                            _flag(country),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _countryInfo() {
    Misc.debugP(tag: this, message: _state.mapController);
    Misc.debugP(tag: this, message: _state.ph);

    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Card(
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150.0,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  _state.mapController.complete(controller);
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.country.latlng[0],
                    widget.country.latlng[1],
                  ),
                  zoom: 4.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(widget.country.numericCode),
                    position: LatLng(
                      widget.country.latlng[0],
                      widget.country.latlng[1],
                    ),
                    infoWindow: InfoWindow(title: widget.country.name),
                  )
                },
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8, bottom: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "Capital: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text("${widget.country.capital}"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8, bottom: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "Region: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text("${widget.country.region}"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8, bottom: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "Abbreviation: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text("${widget.country.alpha3Code}"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8, bottom: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Calling Codes: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.country.callingCodes.map((item) {
                                return Text("$item");
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8, bottom: 8.0, right: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Population: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text("${widget.country.population}"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8, bottom: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Currencies: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.country.currencies.map((item) {
                                return Text("${item.symbol} - ${item.name}");
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8, bottom: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LngLat: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.country.latlng.map((item) {
                                return Text("$item");
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8, bottom: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Languages: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.country.languages.map((item) {
                                return Text("${item.name}");
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8, bottom: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Borders: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.country.borders.map((item) {
                                return Text("$item");
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
