/// Raw API for Max Bot API
library;

import 'client.dart';
import 'modules/modules.dart';

/// Raw API class providing access to all API modules
class RawApi {
  final Client client;

  RawApi(this.client);

  BotsApi? _bots;
  ChatsApi? _chats;
  MessagesApi? _messages;
  SubscriptionsApi? _subscriptions;
  UploadsApi? _uploads;

  /// Bots API
  BotsApi get bots => _bots ??= BotsApi(client);

  /// Chats API
  ChatsApi get chats => _chats ??= ChatsApi(client);

  /// Messages API
  MessagesApi get messages => _messages ??= MessagesApi(client);

  /// Subscriptions API
  SubscriptionsApi get subscriptions =>
      _subscriptions ??= SubscriptionsApi(client);

  /// Uploads API
  UploadsApi get uploads => _uploads ??= UploadsApi(client);
}
