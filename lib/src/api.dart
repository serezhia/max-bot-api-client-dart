/// API wrapper for Max Bot API
library;

import 'core/helpers/attachments.dart';
import 'core/network/api/api.dart';

/// Send message options
class SendMessageExtra {
  final List<Map<String, dynamic>>? attachments;
  final Map<String, dynamic>? link;
  final bool? notify;
  final String? format;
  final bool? disableLinkPreview;

  const SendMessageExtra({
    this.attachments,
    this.link,
    this.notify,
    this.format,
    this.disableLinkPreview,
  });
}

/// Edit message options
class EditMessageExtra {
  final String? text;
  final List<Map<String, dynamic>>? attachments;
  final Map<String, dynamic>? link;
  final bool? notify;
  final String? format;

  const EditMessageExtra({
    this.text,
    this.attachments,
    this.link,
    this.notify,
    this.format,
  });
}

/// Answer on callback options
class AnswerOnCallbackExtra {
  final Map<String, dynamic>? message;
  final String? notification;

  const AnswerOnCallbackExtra({
    this.message,
    this.notification,
  });
}

/// Get messages options
class GetMessagesExtra {
  final List<String>? messageIds;
  final int? from;
  final int? to;
  final int? count;

  const GetMessagesExtra({
    this.messageIds,
    this.from,
    this.to,
    this.count,
  });
}

/// Get all chats options
class GetAllChatsExtra {
  final int? count;
  final int? marker;

  const GetAllChatsExtra({
    this.count,
    this.marker,
  });
}

/// Edit chat options
class EditChatExtra {
  final PhotoAttachmentRequestPayload? icon;
  final String? title;
  final String? pin;
  final bool? notify;

  const EditChatExtra({
    this.icon,
    this.title,
    this.pin,
    this.notify,
  });
}

/// Get chat members options
class GetChatMembersExtra {
  final List<int>? userIds;
  final int? marker;
  final int? count;

  const GetChatMembersExtra({
    this.userIds,
    this.marker,
    this.count,
  });
}

/// Pin message options
class PinMessageExtra {
  final bool? notify;

  const PinMessageExtra({this.notify});
}

/// High-level API wrapper
class Api {
  final RawApi raw;

  Api(Client client) : raw = RawApi(client);

  /// Get bot info
  Future<BotInfo> getMyInfo() async {
    return raw.bots.getMyInfo();
  }

  /// Edit bot info
  Future<BotInfo> editMyInfo({
    String? name,
    String? description,
    List<BotCommand>? commands,
    PhotoAttachmentRequestPayload? photo,
  }) async {
    return raw.bots.editMyInfo(
      name: name,
      description: description,
      commands: commands,
      photo: photo,
    );
  }

  /// Set bot commands
  Future<BotInfo> setMyCommands(List<BotCommand> commands) async {
    return editMyInfo(commands: commands);
  }

  /// Delete bot commands
  Future<BotInfo> deleteMyCommands() async {
    return editMyInfo(commands: []);
  }

  /// Get all chats
  Future<GetAllChatsResponse> getAllChats([GetAllChatsExtra? extra]) async {
    return raw.chats.getAll(
      count: extra?.count,
      marker: extra?.marker,
    );
  }

  /// Get chat by ID
  Future<Chat> getChat(int id) async {
    return raw.chats.getById(chatId: id);
  }

  /// Get chat by link
  Future<Chat> getChatByLink(String link) async {
    return raw.chats.getByLink(chatLink: link);
  }

  /// Edit chat info
  Future<Chat> editChatInfo(int chatId, EditChatExtra extra) async {
    return raw.chats.edit(
      chatId: chatId,
      icon: extra.icon,
      title: extra.title,
      pin: extra.pin,
      notify: extra.notify,
    );
  }

  /// Send message to chat
  Future<Message> sendMessageToChat(
    int chatId,
    String text, [
    SendMessageExtra? extra,
  ]) async {
    final response = await raw.messages.send(
      chatId: chatId,
      text: text,
      attachments: extra?.attachments,
      link: extra?.link,
      notify: extra?.notify,
      format: extra?.format,
      disableLinkPreview: extra?.disableLinkPreview,
    );
    return response.message;
  }

  /// Send message to user
  Future<Message> sendMessageToUser(
    int userId,
    String text, [
    SendMessageExtra? extra,
  ]) async {
    final response = await raw.messages.send(
      userId: userId,
      text: text,
      attachments: extra?.attachments,
      link: extra?.link,
      notify: extra?.notify,
      format: extra?.format,
      disableLinkPreview: extra?.disableLinkPreview,
    );
    return response.message;
  }

  /// Get messages
  Future<GetMessagesResponse> getMessages(
    int chatId, [
    GetMessagesExtra? extra,
  ]) async {
    return raw.messages.getMessages(
      chatId: chatId,
      messageIds: extra?.messageIds?.join(','),
      from: extra?.from,
      to: extra?.to,
      count: extra?.count,
    );
  }

  /// Get message by ID
  Future<Message> getMessage(String id) async {
    return raw.messages.getById(messageId: id);
  }

  /// Edit message
  Future<ActionResponse> editMessage(
    String messageId, [
    EditMessageExtra? extra,
  ]) async {
    return raw.messages.edit(
      messageId: messageId,
      text: extra?.text,
      attachments: extra?.attachments,
      link: extra?.link,
      notify: extra?.notify,
      format: extra?.format,
    );
  }

  /// Delete message
  Future<ActionResponse> deleteMessage(String messageId) async {
    return raw.messages.deleteMessage(messageId: messageId);
  }

  /// Answer on callback
  Future<ActionResponse> answerOnCallback(
    String callbackId, [
    AnswerOnCallbackExtra? extra,
  ]) async {
    return raw.messages.answerOnCallback(
      callbackId: callbackId,
      message: extra?.message,
      notification: extra?.notification,
    );
  }

  /// Get chat membership
  Future<ChatMember> getChatMembership(int chatId) async {
    return raw.chats.getChatMembership(chatId: chatId);
  }

  /// Get chat admins
  Future<GetChatAdminsResponse> getChatAdmins(int chatId) async {
    return raw.chats.getChatAdmins(chatId: chatId);
  }

  /// Add chat members
  Future<ActionResponse> addChatMembers(int chatId, List<int> userIds) async {
    return raw.chats.addChatMembers(chatId: chatId, userIds: userIds);
  }

  /// Get chat members
  Future<GetChatMembersResponse> getChatMembers(
    int chatId, [
    GetChatMembersExtra? extra,
  ]) async {
    return raw.chats.getChatMembers(
      chatId: chatId,
      userIds: extra?.userIds?.join(','),
      marker: extra?.marker,
      count: extra?.count,
    );
  }

  /// Remove chat member
  Future<ActionResponse> removeChatMember(int chatId, int userId) async {
    return raw.chats.removeChatMember(chatId: chatId, userId: userId);
  }

  /// Get updates
  Future<GetUpdatesResponse> getUpdates({
    String? types,
    int? marker,
    int? limit,
    int? timeout,
  }) async {
    return raw.subscriptions.getUpdates(
      types: types,
      marker: marker,
      limit: limit,
      timeout: timeout,
    );
  }

  /// Get pinned message
  Future<GetPinnedMessageResponse> getPinnedMessage(int chatId) async {
    return raw.chats.getPinnedMessage(chatId: chatId);
  }

  /// Pin message
  Future<ActionResponse> pinMessage(
    int chatId,
    String messageId, [
    PinMessageExtra? extra,
  ]) async {
    return raw.chats.pinMessage(
      chatId: chatId,
      messageId: messageId,
      notify: extra?.notify,
    );
  }

  /// Unpin message
  Future<ActionResponse> unpinMessage(int chatId) async {
    return raw.chats.unpinMessage(chatId: chatId);
  }

  /// Send action
  Future<ActionResponse> sendAction(int chatId, SenderAction action) async {
    return raw.chats.sendAction(chatId: chatId, action: action);
  }

  /// Leave chat
  Future<ActionResponse> leaveChat(int chatId) async {
    return raw.chats.leaveChat(chatId: chatId);
  }

  /// Upload image
  Future<ImageAttachmentHelper> uploadImage({
    String? url,
    List<int>? bytes,
    String? filename,
  }) async {
    if (url != null) {
      return ImageAttachmentHelper(url: url);
    }
    if (bytes != null) {
      final uploadInfo = await raw.uploads.getUploadUrl(type: UploadType.image);
      final response = await raw.client.upload(
        uploadInfo.url,
        bytes,
        filename: filename ?? 'image.png',
      );
      // The upload response might not contain the token directly if it's just a success message.
      // However, the token from getUploadUrl is the one we need to use for the attachment.
      // If the upload response contains a token, we use it, otherwise we fall back to the initial token.
      var token = response['token'] as String?;

      // Check for photos map in response (common for image uploads)
      if (token == null && response['photos'] is Map) {
        final photos = response['photos'] as Map<String, dynamic>;
        if (photos.isNotEmpty) {
          final photoData = photos.values.first;
          if (photoData is Map && photoData.containsKey('token')) {
            token = photoData['token'] as String?;
          }
        }
      }

      token ??= uploadInfo.token;

      // Fallback: try to extract from URL query parameters if token is still null
      if (token == null) {
        try {
          final uri = Uri.parse(uploadInfo.url);
          token = uri.queryParameters['photoIds'];
        } catch (_) {
          // ignore
        }
      }

      return ImageAttachmentHelper(
        token: token,
      );
    }
    throw ArgumentError('Either url or bytes must be provided');
  }
}
