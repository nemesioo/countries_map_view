class ResponseModel {
  String response;
  String errorResponse;

  ResponseModel({this.response});


  ResponseModel.withError({this.errorResponse});

  Map<String, dynamic> toJson() => {
        "error_response": errorResponse,
        "response": response
      };
}
