import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mesio_map_view/models/response_model.dart';
import 'package:mesio_map_view/utils/misc.dart';
import 'package:http/http.dart' as http;

class ServiceProvider {
  Future<ResponseModel> getRequestToNetwork(
      {String url, String auth, bool isBytes = false}) async {
    Misc.debugP(tag: this, message: url);
    Misc.debugP(tag: this, message: auth);

    ResponseModel response;
    http.Response res;

    try {
      res = await http.get(url,
          headers: auth == null ? {} : {"authorization": auth});
      Misc.debugP(tag: this, message: res.body);
      if (res.statusCode == 200) {
        response = ResponseModel(
            response: isBytes ? utf8.decode(res.bodyBytes) : res.body);
      } else {
        response = ResponseModel.withError(
            errorResponse: isBytes ? utf8.decode(res.bodyBytes) : res.body);
      }
    } on TimeoutException catch (_) {
      response = ResponseModel.withError(
          errorResponse: isBytes ? utf8.decode(res.bodyBytes) : res.body);
    } on SocketException catch (_) {
      response = ResponseModel.withError(
          errorResponse: isBytes ? utf8.decode(res.bodyBytes) : res.body);
    } catch (e) {
      Misc.debugP(tag: this, message: e);
      response = ResponseModel.withError(
          errorResponse: isBytes ? utf8.decode(res.bodyBytes) : res.body);
    }

    return response;
  }
}
