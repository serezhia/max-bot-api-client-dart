/// Context class for Max Bot API
library;

import 'api.dart';
import 'core/network/api/api.dart';

/// Contact info extracted from update
class ContactInfo {
  final String? tel;
  final String? fullName;

  const ContactInfo({this.tel, this.fullName});
}

/// Location extracted from update
class Location {
  final double latitude;
  final double longitude;

  const Location({required this.latitude, required this.longitude});
}

/// Sticker info extracted from update
class Sticker {
  final int width;
  final int height;
  final String url;
  final String code;

  const Sticker({
    required this.width,
    required this.height,
    required this.url,
    required this.code,
  });
}

/// Guard function type
typedef Guard<T> = bool Function(T value);

/// Context class for handling updates
class Context<U extends Update> {
  final U update;
  final Api api;
  final BotInfo? botInfo;
  RegExpMatch? match;

  Context(this.update, this.api, [this.botInfo]);

  /// Check if context matches a filter
  bool has(Object filter) {
    if (filter is UpdateType) {
      return filter == update.updateType;
    }
    if (filter is bool Function(Update)) {
      return filter(update);
    }
    if (filter is List) {
      for (final f in filter) {
        if (has(f)) return true;
      }
      return false;
    }
    return false;
  }

  /// Assert a value is not null
  T assertValue<T>(T? value, String method) {
    if (value == null) {
      throw StateError('Max: "$method" isn\'t available for "${update.updateType}"');
    }
    return value;
  }

  /// Get update type
  UpdateType get updateType => update.updateType;

  /// Get bot ID
  int? get myId => botInfo?.userId;

  /// Get start payload (for bot_started update)
  String? get startPayload {
    if (update is BotStartedUpdate) {
      return (update as BotStartedUpdate).payload;
    }
    return null;
  }

  /// Get chat from update
  Chat? get chat {
    if (update is MessageChatCreatedUpdate) {
      return (update as MessageChatCreatedUpdate).chat;
    }
    return null;
  }

  /// Get chat ID from update
  int? get chatId {
    // Check for chat_id property
    if (update is MessageRemovedUpdate) {
      return (update as MessageRemovedUpdate).chatId;
    }
    if (update is BotAddedUpdate) {
      return (update as BotAddedUpdate).chatId;
    }
    if (update is BotRemovedUpdate) {
      return (update as BotRemovedUpdate).chatId;
    }
    if (update is UserAddedUpdate) {
      return (update as UserAddedUpdate).chatId;
    }
    if (update is UserRemovedUpdate) {
      return (update as UserRemovedUpdate).chatId;
    }
    if (update is BotStartedUpdate) {
      return (update as BotStartedUpdate).chatId;
    }
    if (update is ChatTitleChangedUpdate) {
      return (update as ChatTitleChangedUpdate).chatId;
    }
    if (update is MessageChatCreatedUpdate) {
      return (update as MessageChatCreatedUpdate).chat.chatId;
    }

    // Check for message with recipient
    final msg = message;
    if (msg != null) {
      return msg.recipient.chatId;
    }

    // Check for callback message
    if (update is MessageCallbackUpdate) {
      return (update as MessageCallbackUpdate).message?.recipient.chatId;
    }

    return null;
  }

  /// Get message from update
  Message? get message {
    if (update is MessageCreatedUpdate) {
      return (update as MessageCreatedUpdate).message;
    }
    if (update is MessageEditedUpdate) {
      return (update as MessageEditedUpdate).message;
    }
    if (update is MessageCallbackUpdate) {
      return (update as MessageCallbackUpdate).message;
    }
    return null;
  }

  /// Get message ID from update
  String? get messageId {
    if (update is MessageRemovedUpdate) {
      return (update as MessageRemovedUpdate).messageId;
    }
    if (update is MessageChatCreatedUpdate) {
      return (update as MessageChatCreatedUpdate).messageId;
    }
    final msg = message;
    if (msg != null) {
      return msg.body.mid;
    }
    return null;
  }

  /// Get callback from update
  Callback? get callback {
    if (update is MessageCallbackUpdate) {
      return (update as MessageCallbackUpdate).callback;
    }
    return null;
  }

  /// Get user from update
  User? get user {
    if (update is BotAddedUpdate) {
      return (update as BotAddedUpdate).user;
    }
    if (update is BotRemovedUpdate) {
      return (update as BotRemovedUpdate).user;
    }
    if (update is UserAddedUpdate) {
      return (update as UserAddedUpdate).user;
    }
    if (update is UserRemovedUpdate) {
      return (update as UserRemovedUpdate).user;
    }
    if (update is BotStartedUpdate) {
      return (update as BotStartedUpdate).user;
    }
    if (update is ChatTitleChangedUpdate) {
      return (update as ChatTitleChangedUpdate).user;
    }
    if (update is MessageConstructionRequestUpdate) {
      return (update as MessageConstructionRequestUpdate).user;
    }
    if (update is MessageConstructedUpdate) {
      return (update as MessageConstructedUpdate).user;
    }
    if (update is MessageCallbackUpdate) {
      return (update as MessageCallbackUpdate).callback.user;
    }
    if (update is MessageCreatedUpdate) {
      return (update as MessageCreatedUpdate).message.sender;
    }
    return null;
  }

  ContactInfo? _contactInfo;

  /// Get contact info from update
  ContactInfo? get contactInfo {
    if (_contactInfo != null) return _contactInfo;

    final msg = message;
    if (msg == null) return null;

    final attachments = msg.body.attachments;
    if (attachments == null) return null;

    for (final attachment in attachments) {
      if (attachment is ContactAttachment) {
        final vcfInfo = attachment.vcfInfo;
        if (vcfInfo == null) return null;

        // Simple vCard parsing
        String? tel;
        String? fullName;

        for (final line in vcfInfo.split('\n')) {
          if (line.startsWith('TEL:') || line.startsWith('TEL;')) {
            tel = line.split(':').last.trim();
          }
          if (line.startsWith('FN:')) {
            fullName = line.substring(3).trim();
          }
        }

        _contactInfo = ContactInfo(tel: tel, fullName: fullName);
        return _contactInfo;
      }
    }
    return null;
  }

  Location? _location;

  /// Get location from update
  Location? get location {
    if (_location != null) return _location;

    final msg = message;
    if (msg == null) return null;

    final attachments = msg.body.attachments;
    if (attachments == null) return null;

    for (final attachment in attachments) {
      if (attachment is LocationAttachment) {
        _location = Location(
          latitude: attachment.latitude,
          longitude: attachment.longitude,
        );
        return _location;
      }
    }
    return null;
  }

  Sticker? _sticker;

  /// Get sticker from update
  Sticker? get sticker {
    if (_sticker != null) return _sticker;

    final msg = message;
    if (msg == null) return null;

    final attachments = msg.body.attachments;
    if (attachments == null) return null;

    for (final attachment in attachments) {
      if (attachment is StickerAttachment) {
        _sticker = Sticker(
          width: attachment.width,
          height: attachment.height,
          url: attachment.url,
          code: attachment.code,
        );
        return _sticker;
      }
    }
    return null;
  }

  /// Reply to the current chat
  Future<Message> reply(String text, [SendMessageExtra? extra]) async {
    final id = assertValue(chatId, 'reply');
    return api.sendMessageToChat(id, text, extra);
  }

  /// Get all chats
  Future<GetAllChatsResponse> getAllChats([GetAllChatsExtra? extra]) async {
    return api.getAllChats(extra);
  }

  /// Get chat by ID or current chat
  Future<Chat> getChat([int? id]) async {
    if (id != null) {
      return api.getChat(id);
    }
    final currentChatId = assertValue(chatId, 'getChat');
    return api.getChat(currentChatId);
  }

  /// Get chat by link
  Future<Chat> getChatByLink(String link) async {
    return api.getChatByLink(link);
  }

  /// Edit chat info
  Future<Chat> editChatInfo(EditChatExtra extra) async {
    final id = assertValue(chatId, 'editChatInfo');
    return api.editChatInfo(id, extra);
  }

  /// Get message by ID
  Future<Message> getMessage(String id) async {
    return api.getMessage(id);
  }

  /// Get messages from current chat
  Future<GetMessagesResponse> getMessages([GetMessagesExtra? extra]) async {
    final id = assertValue(chatId, 'getMessages');
    return api.getMessages(id, extra);
  }

  /// Get pinned message
  Future<GetPinnedMessageResponse> getPinnedMessage() async {
    final id = assertValue(chatId, 'getPinnedMessage');
    return api.getPinnedMessage(id);
  }

  /// Edit current message
  Future<ActionResponse> editMessage([EditMessageExtra? extra]) async {
    final id = assertValue(messageId, 'editMessage');
    return api.editMessage(id, extra);
  }

  /// Delete message
  Future<ActionResponse> deleteMessage([String? id]) async {
    if (id != null) {
      return api.deleteMessage(id);
    }
    final currentMessageId = assertValue(messageId, 'deleteMessage');
    return api.deleteMessage(currentMessageId);
  }

  /// Answer on callback
  Future<ActionResponse> answerOnCallback([AnswerOnCallbackExtra? extra]) async {
    final cb = assertValue(callback, 'answerOnCallback');
    return api.answerOnCallback(cb.callbackId, extra);
  }

  /// Get chat membership
  Future<ChatMember> getChatMembership() async {
    final id = assertValue(chatId, 'getChatMembership');
    return api.getChatMembership(id);
  }

  /// Get chat admins
  Future<GetChatAdminsResponse> getChatAdmins() async {
    final id = assertValue(chatId, 'getChatAdmins');
    return api.getChatAdmins(id);
  }

  /// Add chat members
  Future<ActionResponse> addChatMembers(List<int> userIds) async {
    final id = assertValue(chatId, 'addChatMembers');
    return api.addChatMembers(id, userIds);
  }

  /// Get chat members
  Future<GetChatMembersResponse> getChatMembers([GetChatMembersExtra? extra]) async {
    final id = assertValue(chatId, 'getChatMembers');
    return api.getChatMembers(id, extra);
  }

  /// Remove chat member
  Future<ActionResponse> removeChatMember(int userId) async {
    final id = assertValue(chatId, 'removeChatMember');
    return api.removeChatMember(id, userId);
  }

  /// Pin message
  Future<ActionResponse> pinMessage(String msgId, [PinMessageExtra? extra]) async {
    final id = assertValue(chatId, 'pinMessage');
    return api.pinMessage(id, msgId, extra);
  }

  /// Unpin message
  Future<ActionResponse> unpinMessage() async {
    final id = assertValue(chatId, 'unpinMessage');
    return api.unpinMessage(id);
  }

  /// Send action
  Future<ActionResponse> sendAction(SenderAction action) async {
    final id = assertValue(chatId, 'sendAction');
    return api.sendAction(id, action);
  }

  /// Leave chat
  Future<ActionResponse> leaveChat() async {
    final id = assertValue(chatId, 'leaveChat');
    return api.leaveChat(id);
  }
}
