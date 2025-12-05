/// Filters for Max Bot API
library;

import 'core/network/api/api.dart';

/// Check if created message body has specific keys
bool Function(Update) createdMessageBodyHas(List<String> keys) {
  return (Update update) {
    if (update is! MessageCreatedUpdate) return false;
    final body = update.message.body;
    for (final key in keys) {
      switch (key) {
        case 'text':
          if (body.text == null) return false;
        case 'attachments':
          if (body.attachments == null || body.attachments!.isEmpty) {
            return false;
          }
        // Add more keys as needed
      }
    }
    return true;
  };
}
