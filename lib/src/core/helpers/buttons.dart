/// Button helpers for Max Bot API
library;

import '../network/api/types/types.dart';

/// Button helper class for creating buttons
class ButtonHelper {
  /// Creates a ButtonHelper
  const ButtonHelper();

  /// Create a callback button
  CallbackButton callback(
    String text,
    String payload, {
    ButtonIntent? intent,
  }) {
    return CallbackButton(
      text: text,
      payload: payload,
      intent: intent,
    );
  }

  /// Create a link button
  LinkButton link(String text, String url) {
    return LinkButton(text: text, url: url);
  }

  /// Create a request contact button
  RequestContactButton requestContact(String text) {
    return RequestContactButton(text: text);
  }

  /// Create a request geo location button
  RequestGeoLocationButton requestGeoLocation(
    String text, {
    bool? quick,
  }) {
    return RequestGeoLocationButton(text: text, quick: quick);
  }

  /// Create a chat button
  ChatButton chat(
    String text,
    String chatTitle, {
    String? chatDescription,
    String? startPayload,
    String? uuid,
  }) {
    return ChatButton(
      text: text,
      chatTitle: chatTitle,
      chatDescription: chatDescription,
      startPayload: startPayload,
      uuid: uuid,
    );
  }
}
