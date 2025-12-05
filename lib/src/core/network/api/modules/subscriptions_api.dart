/// Subscriptions API module for Max Bot API
library;

import '../base_api.dart';
import '../types/types.dart';

/// API for subscription-related operations (polling)
class SubscriptionsApi extends BaseApi {
  SubscriptionsApi(super.client);

  /// Get updates
  Future<GetUpdatesResponse> getUpdates({
    int? limit,
    int? timeout,
    int? marker,
    String? types,
  }) async {
    final query = <String, dynamic>{};
    if (limit != null) query['limit'] = limit;
    if (timeout != null) query['timeout'] = timeout;
    if (marker != null) query['marker'] = marker;
    if (types != null) query['types'] = types;

    final result = await get('updates', query: query);
    return GetUpdatesResponse.fromJson(result);
  }
}

/// Response for getting updates
class GetUpdatesResponse {
  final List<Update> updates;
  final int marker;

  const GetUpdatesResponse({required this.updates, required this.marker});

  factory GetUpdatesResponse.fromJson(Map<String, dynamic> json) {
    return GetUpdatesResponse(
      updates: (json['updates'] as List<dynamic>)
          .map((e) => Update.fromJson(e as Map<String, dynamic>))
          .toList(),
      marker: json['marker'] as int,
    );
  }
}
