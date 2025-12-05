/// Keyboard helpers for Max Bot API
library;

import '../network/api/types/types.dart';
import 'buttons.dart';

/// Keyboard helper class
class Keyboard {
  const Keyboard._();

  /// Create an inline keyboard attachment
  static Map<String, dynamic> inlineKeyboard(List<List<Button>> buttons) {
    return {
      'type': 'inline_keyboard',
      'payload': {
        'buttons': buttons
            .map((row) => row.map((b) => b.toJson()).toList())
            .toList(),
      },
    };
  }

  /// Button helper access
  static const ButtonHelper button = ButtonHelper();
}
