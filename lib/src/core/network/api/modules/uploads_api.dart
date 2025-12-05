/// Uploads API module for Max Bot API
library;

import '../base_api.dart';
import '../types/types.dart';

/// API for upload-related operations
class UploadsApi extends BaseApi {
  UploadsApi(super.client);

  /// Get upload URL
  Future<GetUploadUrlResponse> getUploadUrl({
    required UploadType type,
  }) async {
    final result = await post(
      'uploads',
      query: {'type': type.value},
    );
    return GetUploadUrlResponse.fromJson(result);
  }
}

/// Response for getting upload URL
class GetUploadUrlResponse {
  final String url;
  final String? token;

  const GetUploadUrlResponse({required this.url, this.token});

  factory GetUploadUrlResponse.fromJson(Map<String, dynamic> json) {
    return GetUploadUrlResponse(
      url: json['url'] as String,
      token: json['token'] as String?,
    );
  }
}
