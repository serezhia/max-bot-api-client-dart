/// Messages API module for Max Bot API
library;

import '../base_api.dart';
import '../error.dart';
import '../types/types.dart';

/// API for message-related operations
class MessagesApi extends BaseApi {
  MessagesApi(super.client);

  /// Get messages
  Future<GetMessagesResponse> getMessages({
    int? chatId,
    String? messageIds,
    int? from,
    int? to,
    int? count,
  }) async {
    final query = <String, dynamic>{};
    if (chatId != null) query['chat_id'] = chatId;
    if (messageIds != null) query['message_ids'] = messageIds;
    if (from != null) query['from'] = from;
    if (to != null) query['to'] = to;
    if (count != null) query['count'] = count;

    final result = await get('messages', query: query);
    return GetMessagesResponse.fromJson(result);
  }

  /// Get message by ID
  Future<Message> getById({required String messageId}) async {
    final result = await get(
      'messages/{message_id}',
      path: {'message_id': messageId},
    );
    return Message.fromJson(result);
  }

  /// Send message
  Future<SendMessageResponse> send({
    int? chatId,
    int? userId,
    String? text,
    List<Map<String, dynamic>>? attachments,
    Map<String, dynamic>? link,
    bool? notify,
    String? format,
    bool? disableLinkPreview,
  }) async {
    final query = <String, dynamic>{};
    if (chatId != null) query['chat_id'] = chatId;
    if (userId != null) query['user_id'] = userId;
    if (disableLinkPreview != null) {
      query['disable_link_preview'] = disableLinkPreview;
    }

    final body = <String, dynamic>{};
    if (text != null) body['text'] = text;
    if (attachments != null) body['attachments'] = attachments;
    if (link != null) body['link'] = link;
    if (notify != null) body['notify'] = notify;
    if (format != null) body['format'] = format;

    try {
      final result = await post('messages', query: query, body: body);
      return SendMessageResponse.fromJson(result);
    } on MaxError catch (e) {
      if (e.code == 'attachment.not.ready') {
        await Future<void>.delayed(const Duration(seconds: 1));
        return send(
          chatId: chatId,
          userId: userId,
          text: text,
          attachments: attachments,
          link: link,
          notify: notify,
          format: format,
          disableLinkPreview: disableLinkPreview,
        );
      }
      rethrow;
    }
  }

  /// Edit message
  Future<ActionResponse> edit({
    required String messageId,
    String? text,
    List<Map<String, dynamic>>? attachments,
    Map<String, dynamic>? link,
    bool? notify,
    String? format,
  }) async {
    final body = <String, dynamic>{};
    if (text != null) body['text'] = text;
    if (attachments != null) body['attachments'] = attachments;
    if (link != null) body['link'] = link;
    if (notify != null) body['notify'] = notify;
    if (format != null) body['format'] = format;

    final result = await put(
      'messages',
      query: {'message_id': messageId},
      body: body,
    );
    return ActionResponse.fromJson(result);
  }

  /// Delete message
  Future<ActionResponse> deleteMessage({required String messageId}) async {
    final result = await delete(
      'messages',
      query: {'message_id': messageId},
    );
    return ActionResponse.fromJson(result);
  }

  /// Answer on callback
  Future<ActionResponse> answerOnCallback({
    required String callbackId,
    Map<String, dynamic>? message,
    String? notification,
  }) async {
    final body = <String, dynamic>{};
    if (message != null) body['message'] = message;
    if (notification != null) body['notification'] = notification;

    final result = await post(
      'answers',
      query: {'callback_id': callbackId},
      body: body,
    );
    return ActionResponse.fromJson(result);
  }
}

/// Response for getting messages
class GetMessagesResponse {
  final List<Message> messages;

  const GetMessagesResponse({required this.messages});

  factory GetMessagesResponse.fromJson(Map<String, dynamic> json) {
    return GetMessagesResponse(
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Response for sending message
class SendMessageResponse {
  final Message message;

  const SendMessageResponse({required this.message});

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      message: Message.fromJson(json['message'] as Map<String, dynamic>),
    );
  }
}
