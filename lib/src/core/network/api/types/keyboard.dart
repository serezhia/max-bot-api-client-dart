/// Keyboard type definitions for Max Bot API
library;

/// Button intent enumeration
enum ButtonIntent {
  defaultIntent('default'),
  positive('positive'),
  negative('negative');

  final String value;
  const ButtonIntent(this.value);

  static ButtonIntent fromString(String value) {
    return ButtonIntent.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ButtonIntent.defaultIntent,
    );
  }
}

/// Base button class
sealed class Button {
  final String type;
  final String text;

  const Button({required this.type, required this.text});

  Map<String, dynamic> toJson();

  static Button fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    return switch (type) {
      'callback' => CallbackButton.fromJson(json),
      'link' => LinkButton.fromJson(json),
      'request_contact' => RequestContactButton.fromJson(json),
      'request_geo_location' => RequestGeoLocationButton.fromJson(json),
      'chat' => ChatButton.fromJson(json),
      _ => throw ArgumentError('Unknown button type: $type'),
    };
  }
}

/// Callback button
class CallbackButton extends Button {
  final String payload;
  final ButtonIntent? intent;

  const CallbackButton({
    required super.text,
    required this.payload,
    this.intent,
  }) : super(type: 'callback');

  factory CallbackButton.fromJson(Map<String, dynamic> json) {
    return CallbackButton(
      text: json['text'] as String,
      payload: json['payload'] as String,
      intent: json['intent'] != null
          ? ButtonIntent.fromString(json['intent'] as String)
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
      'payload': payload,
      if (intent != null) 'intent': intent!.value,
    };
  }
}

/// Link button
class LinkButton extends Button {
  final String url;

  const LinkButton({
    required super.text,
    required this.url,
  }) : super(type: 'link');

  factory LinkButton.fromJson(Map<String, dynamic> json) {
    return LinkButton(
      text: json['text'] as String,
      url: json['url'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
      'url': url,
    };
  }
}

/// Request contact button
class RequestContactButton extends Button {
  const RequestContactButton({
    required super.text,
  }) : super(type: 'request_contact');

  factory RequestContactButton.fromJson(Map<String, dynamic> json) {
    return RequestContactButton(
      text: json['text'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
    };
  }
}

/// Request geo location button
class RequestGeoLocationButton extends Button {
  final bool? quick;

  const RequestGeoLocationButton({
    required super.text,
    this.quick,
  }) : super(type: 'request_geo_location');

  factory RequestGeoLocationButton.fromJson(Map<String, dynamic> json) {
    return RequestGeoLocationButton(
      text: json['text'] as String,
      quick: json['quick'] as bool?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
      if (quick != null) 'quick': quick,
    };
  }
}

/// Chat button
class ChatButton extends Button {
  final String chatTitle;
  final String? chatDescription;
  final String? startPayload;
  final String? uuid;

  const ChatButton({
    required super.text,
    required this.chatTitle,
    this.chatDescription,
    this.startPayload,
    this.uuid,
  }) : super(type: 'chat');

  factory ChatButton.fromJson(Map<String, dynamic> json) {
    return ChatButton(
      text: json['text'] as String,
      chatTitle: json['chat_title'] as String,
      chatDescription: json['chat_description'] as String?,
      startPayload: json['start_payload'] as String?,
      uuid: json['uuid'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
      'chat_title': chatTitle,
      if (chatDescription != null) 'chat_description': chatDescription,
      if (startPayload != null) 'start_payload': startPayload,
      if (uuid != null) 'uuid': uuid,
    };
  }
}
