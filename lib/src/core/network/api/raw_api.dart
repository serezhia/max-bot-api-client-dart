/// Raw API for Max Bot API
library;

import 'client.dart';
import 'modules/modules.dart';

/// Raw API class providing access to all API modules
class RawApi {
  final Client _client;

  RawApi(this._client);

  BotsApi? _bots;
  ChatsApi? _chats;
  MessagesApi? _messages;
  SubscriptionsApi? _subscriptions;
  UploadsApi? _uploads;

  /// Bots API
  BotsApi get bots => _bots ??= BotsApi(_client);

  /// Chats API
  ChatsApi get chats => _chats ??= ChatsApi(_client);

  /// Messages API
  MessagesApi get messages => _messages ??= MessagesApi(_client);

  /// Subscriptions API
  SubscriptionsApi get subscriptions =>
      _subscriptions ??= SubscriptionsApi(_client);

  /// Uploads API
  UploadsApi get uploads => _uploads ??= UploadsApi(_client);
}
