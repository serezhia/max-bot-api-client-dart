/// Message type definitions for Max Bot API
library;

import 'attachment.dart';
import 'chat.dart';
import 'markup.dart';
import 'user.dart';

/// Message sender alias
typedef MessageSender = User;

/// Message recipient
class MessageRecipient {
  final int? chatId;
  final ChatType chatType;

  const MessageRecipient({
    this.chatId,
    required this.chatType,
  });

  factory MessageRecipient.fromJson(Map<String, dynamic> json) {
    return MessageRecipient(
      chatId: json['chat_id'] as int?,
      chatType: ChatType.fromString(json['chat_type'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'chat_type': chatType.value,
    };
  }
}

/// Message body
class MessageBody {
  final String mid;
  final int seq;
  final String? text;
  final List<Attachment>? attachments;
  final List<MarkupElement>? markup;

  const MessageBody({
    required this.mid,
    required this.seq,
    this.text,
    this.attachments,
    this.markup,
  });

  factory MessageBody.fromJson(Map<String, dynamic> json) {
    return MessageBody(
      mid: json['mid'] as String,
      seq: json['seq'] as int,
      text: json['text'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      markup: (json['markup'] as List<dynamic>?)
          ?.map((e) => MarkupElement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mid': mid,
      'seq': seq,
      'text': text,
      'attachments': attachments?.map((e) => e.toJson()).toList(),
      'markup': markup?.map((e) => e.toJson()).toList(),
    };
  }
}

/// Message link type enumeration
enum MessageLinkType {
  forward('forward'),
  reply('reply');

  final String value;
  const MessageLinkType(this.value);

  static MessageLinkType fromString(String value) {
    return MessageLinkType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => MessageLinkType.reply,
    );
  }
}

/// Linked message
class LinkedMessage {
  final MessageLinkType type;
  final MessageSender? sender;
  final int? chatId;
  final MessageBody message;

  const LinkedMessage({
    required this.type,
    this.sender,
    this.chatId,
    required this.message,
  });

  factory LinkedMessage.fromJson(Map<String, dynamic> json) {
    return LinkedMessage(
      type: MessageLinkType.fromString(json['type'] as String),
      sender: json['sender'] != null
          ? User.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      chatId: json['chat_id'] as int?,
      message: MessageBody.fromJson(json['message'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'sender': sender?.toJson(),
      'chat_id': chatId,
      'message': message.toJson(),
    };
  }
}

/// Message statistics
class MessageStat {
  final int views;

  const MessageStat({required this.views});

  factory MessageStat.fromJson(Map<String, dynamic> json) {
    return MessageStat(views: json['views'] as int);
  }

  Map<String, dynamic> toJson() => {'views': views};
}

/// Message constructor alias
typedef MessageConstructor = User;

/// Message
class Message {
  final MessageSender? sender;
  final MessageRecipient recipient;
  final int timestamp;
  final LinkedMessage? link;
  final MessageBody body;
  final MessageStat? stat;
  final String? url;
  final MessageConstructor? constructor;

  const Message({
    this.sender,
    required this.recipient,
    required this.timestamp,
    this.link,
    required this.body,
    this.stat,
    this.url,
    this.constructor,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'] != null
          ? User.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      recipient:
          MessageRecipient.fromJson(json['recipient'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as int,
      link: json['link'] != null
          ? LinkedMessage.fromJson(json['link'] as Map<String, dynamic>)
          : null,
      body: MessageBody.fromJson(json['body'] as Map<String, dynamic>),
      stat: json['stat'] != null
          ? MessageStat.fromJson(json['stat'] as Map<String, dynamic>)
          : null,
      url: json['url'] as String?,
      constructor: json['constructor'] != null
          ? User.fromJson(json['constructor'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender?.toJson(),
      'recipient': recipient.toJson(),
      'timestamp': timestamp,
      'link': link?.toJson(),
      'body': body.toJson(),
      'stat': stat?.toJson(),
      'url': url,
      'constructor': constructor?.toJson(),
    };
  }
}

/// Constructed message (subset of Message)
class ConstructedMessage {
  final MessageSender? sender;
  final int timestamp;
  final LinkedMessage? link;
  final MessageBody body;

  const ConstructedMessage({
    this.sender,
    required this.timestamp,
    this.link,
    required this.body,
  });

  factory ConstructedMessage.fromJson(Map<String, dynamic> json) {
    return ConstructedMessage(
      sender: json['sender'] != null
          ? User.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as int,
      link: json['link'] != null
          ? LinkedMessage.fromJson(json['link'] as Map<String, dynamic>)
          : null,
      body: MessageBody.fromJson(json['body'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender?.toJson(),
      'timestamp': timestamp,
      'link': link?.toJson(),
      'body': body.toJson(),
    };
  }
}
