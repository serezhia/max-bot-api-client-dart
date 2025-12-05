/// Common type definitions for Max Bot API
library;

/// Success response
class SuccessResponse {
  final bool success;

  const SuccessResponse({required this.success});

  factory SuccessResponse.fromJson(Map<String, dynamic> json) {
    return SuccessResponse(success: json['success'] as bool);
  }

  Map<String, dynamic> toJson() => {'success': success};
}

/// Error response
class ErrorResponse {
  final bool success;
  final String message;

  const ErrorResponse({required this.success, required this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'success': success, 'message': message};
}

/// Action response (success or error)
class ActionResponse {
  final bool success;
  final String? message;

  const ActionResponse({required this.success, this.message});

  factory ActionResponse.fromJson(Map<String, dynamic> json) {
    return ActionResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
    };
  }
}

/// Upload type enumeration
enum UploadType {
  image('image'),
  video('video'),
  audio('audio'),
  file('file');

  final String value;
  const UploadType(this.value);

  static UploadType fromString(String value) {
    return UploadType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => UploadType.file,
    );
  }
}
