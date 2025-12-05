/// Bots API module for Max Bot API
library;

import '../base_api.dart';
import '../types/types.dart';

/// API for bot-related operations
class BotsApi extends BaseApi {
  BotsApi(super.client);

  /// Get bot info
  Future<BotInfo> getMyInfo() async {
    final result = await get('me');
    return BotInfo.fromJson(result);
  }

  /// Edit bot info
  Future<BotInfo> editMyInfo({
    String? name,
    String? description,
    List<BotCommand>? commands,
    PhotoAttachmentRequestPayload? photo,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (description != null) body['description'] = description;
    if (commands != null) {
      body['commands'] = commands.map((c) => c.toJson()).toList();
    }
    if (photo != null) body['photo'] = photo.toJson();

    final result = await patch('me', body: body);
    return BotInfo.fromJson(result);
  }
}
