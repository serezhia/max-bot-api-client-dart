/// Chats API module for Max Bot API
library;

import '../base_api.dart';
import '../types/types.dart';

/// API for chat-related operations
class ChatsApi extends BaseApi {
  ChatsApi(super.client);

  /// Get all chats
  Future<GetAllChatsResponse> getAll({int? count, int? marker}) async {
    final query = <String, dynamic>{};
    if (count != null) query['count'] = count;
    if (marker != null) query['marker'] = marker;

    final result = await get('chats', query: query);
    return GetAllChatsResponse.fromJson(result);
  }

  /// Get chat by ID
  Future<Chat> getById({required int chatId}) async {
    final result = await get(
      'chats/{chat_id}',
      path: {'chat_id': chatId},
    );
    return Chat.fromJson(result);
  }

  /// Get chat by link
  Future<Chat> getByLink({required String chatLink}) async {
    final result = await get(
      'chats/{chat_link}',
      path: {'chat_link': chatLink},
    );
    return Chat.fromJson(result);
  }

  /// Edit chat info
  Future<Chat> edit({
    required int chatId,
    PhotoAttachmentRequestPayload? icon,
    String? title,
    String? pin,
    bool? notify,
  }) async {
    final body = <String, dynamic>{};
    if (icon != null) body['icon'] = icon.toJson();
    if (title != null) body['title'] = title;
    if (pin != null) body['pin'] = pin;
    if (notify != null) body['notify'] = notify;

    final result = await patch(
      'chats/{chat_id}',
      path: {'chat_id': chatId},
      body: body,
    );
    return Chat.fromJson(result);
  }

  /// Get chat membership
  Future<ChatMember> getChatMembership({required int chatId}) async {
    final result = await get(
      'chats/{chat_id}/members/me',
      path: {'chat_id': chatId},
    );
    return ChatMember.fromJson(result);
  }

  /// Get chat admins
  Future<GetChatAdminsResponse> getChatAdmins({required int chatId}) async {
    final result = await get(
      'chats/{chat_id}/members/admins',
      path: {'chat_id': chatId},
    );
    return GetChatAdminsResponse.fromJson(result);
  }

  /// Add chat members
  Future<ActionResponse> addChatMembers({
    required int chatId,
    required List<int> userIds,
  }) async {
    final result = await post(
      'chats/{chat_id}/members',
      path: {'chat_id': chatId},
      body: {'user_ids': userIds},
    );
    return ActionResponse.fromJson(result);
  }

  /// Get chat members
  Future<GetChatMembersResponse> getChatMembers({
    required int chatId,
    String? userIds,
    int? marker,
    int? count,
  }) async {
    final query = <String, dynamic>{};
    if (userIds != null) query['user_ids'] = userIds;
    if (marker != null) query['marker'] = marker;
    if (count != null) query['count'] = count;

    final result = await get(
      'chats/{chat_id}/members',
      path: {'chat_id': chatId},
      query: query,
    );
    return GetChatMembersResponse.fromJson(result);
  }

  /// Remove chat member
  Future<ActionResponse> removeChatMember({
    required int chatId,
    required int userId,
    bool? block,
  }) async {
    final body = <String, dynamic>{'user_id': userId};
    if (block != null) body['block'] = block;

    final result = await delete(
      'chats/{chat_id}/members',
      path: {'chat_id': chatId},
      body: body,
    );
    return ActionResponse.fromJson(result);
  }

  /// Get pinned message
  Future<GetPinnedMessageResponse> getPinnedMessage({
    required int chatId,
  }) async {
    final result = await get(
      'chats/{chat_id}/pin',
      path: {'chat_id': chatId},
    );
    return GetPinnedMessageResponse.fromJson(result);
  }

  /// Pin message
  Future<ActionResponse> pinMessage({
    required int chatId,
    required String messageId,
    bool? notify,
  }) async {
    final body = <String, dynamic>{'message_id': messageId};
    if (notify != null) body['notify'] = notify;

    final result = await put(
      'chats/{chat_id}/pin',
      path: {'chat_id': chatId},
      body: body,
    );
    return ActionResponse.fromJson(result);
  }

  /// Unpin message
  Future<ActionResponse> unpinMessage({required int chatId}) async {
    final result = await delete(
      'chats/{chat_id}/pin',
      path: {'chat_id': chatId},
    );
    return ActionResponse.fromJson(result);
  }

  /// Send action
  Future<ActionResponse> sendAction({
    required int chatId,
    required SenderAction action,
  }) async {
    final result = await post(
      'chats/{chat_id}/actions',
      path: {'chat_id': chatId},
      body: {'action': action.value},
    );
    return ActionResponse.fromJson(result);
  }

  /// Leave chat
  Future<ActionResponse> leaveChat({required int chatId}) async {
    final result = await delete(
      'chats/{chat_id}/members/me',
      path: {'chat_id': chatId},
    );
    return ActionResponse.fromJson(result);
  }
}

/// Response for getting all chats
class GetAllChatsResponse {
  final List<Chat> chats;
  final int? marker;

  const GetAllChatsResponse({required this.chats, this.marker});

  factory GetAllChatsResponse.fromJson(Map<String, dynamic> json) {
    return GetAllChatsResponse(
      chats: (json['chats'] as List<dynamic>)
          .map((e) => Chat.fromJson(e as Map<String, dynamic>))
          .toList(),
      marker: json['marker'] as int?,
    );
  }
}

/// Response for getting chat admins
class GetChatAdminsResponse {
  final List<ChatMember> members;
  final int? marker;

  const GetChatAdminsResponse({required this.members, this.marker});

  factory GetChatAdminsResponse.fromJson(Map<String, dynamic> json) {
    return GetChatAdminsResponse(
      members: (json['members'] as List<dynamic>)
          .map((e) => ChatMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      marker: json['marker'] as int?,
    );
  }
}

/// Response for getting chat members
class GetChatMembersResponse {
  final List<ChatMember> members;
  final int? marker;

  const GetChatMembersResponse({required this.members, this.marker});

  factory GetChatMembersResponse.fromJson(Map<String, dynamic> json) {
    return GetChatMembersResponse(
      members: (json['members'] as List<dynamic>)
          .map((e) => ChatMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      marker: json['marker'] as int?,
    );
  }
}

/// Response for getting pinned message
class GetPinnedMessageResponse {
  final Message? message;

  const GetPinnedMessageResponse({this.message});

  factory GetPinnedMessageResponse.fromJson(Map<String, dynamic> json) {
    return GetPinnedMessageResponse(
      message: json['message'] != null
          ? Message.fromJson(json['message'] as Map<String, dynamic>)
          : null,
    );
  }
}
