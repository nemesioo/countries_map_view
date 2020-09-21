import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mesio_map_view/bloc/bloc/map_view_bloc.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  MapViewBloc _mapViewBloc;
  MapViewState _state;

  @override
  void initState() {
    super.initState();
    _mapViewBloc = MapViewBloc();
  }

  @override
  void dispose() {
    _mapViewBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _mapViewBloc,
      child: Container(),
    );
  }
}
