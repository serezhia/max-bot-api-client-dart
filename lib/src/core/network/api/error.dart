/// Max API error class
library;

/// Response from the Max API when an error occurs
class ApiErrorResponse {
  final String code;
  final String message;

  const ApiErrorResponse({required this.code, required this.message});

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      code: json['code'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'code': code, 'message': message};
}

/// Error class for Max API errors
class MaxError implements Exception {
  final int status;
  final ApiErrorResponse response;

  const MaxError(this.status, this.response);

  factory MaxError.fromJson(int status, Map<String, dynamic> json) {
    return MaxError(status, ApiErrorResponse.fromJson(json));
  }

  String get code => response.code;
  String get description => response.message;

  @override
  String toString() => 'MaxError($status): ${response.message}';
}
