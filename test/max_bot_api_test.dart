import 'package:test/test.dart';
import 'package:max_bot_api/max_bot_api.dart';

void main() {
  group('BotCommand', () {
    test('should serialize to JSON', () {
      const command = BotCommand(
        name: 'start',
        description: 'Start the bot',
      );
      final json = command.toJson();
      expect(json['name'], equals('start'));
      expect(json['description'], equals('Start the bot'));
    });

    test('should deserialize from JSON', () {
      final command = BotCommand.fromJson({
        'name': 'help',
        'description': 'Show help',
      });
      expect(command.name, equals('help'));
      expect(command.description, equals('Show help'));
    });
  });

  group('Keyboard', () {
    test('should create inline keyboard', () {
      final keyboard = Keyboard.inlineKeyboard([
        [Keyboard.button.callback('Button 1', 'btn1')],
        [Keyboard.button.link('Link', 'https://example.com')],
      ]);
      expect(keyboard['type'], equals('inline_keyboard'));
      expect(keyboard['payload']['buttons'], isA<List>());
      expect(keyboard['payload']['buttons'].length, equals(2));
    });
  });

  group('Button', () {
    test('should create callback button', () {
      final button = Keyboard.button.callback('Test', 'payload');
      expect(button.text, equals('Test'));
      expect(button.payload, equals('payload'));
      expect(button.type, equals('callback'));
    });

    test('should create link button', () {
      final button = Keyboard.button.link('Link', 'https://example.com');
      expect(button.text, equals('Link'));
      expect(button.url, equals('https://example.com'));
      expect(button.type, equals('link'));
    });

    test('should create request contact button', () {
      final button = Keyboard.button.requestContact('Share contact');
      expect(button.text, equals('Share contact'));
      expect(button.type, equals('request_contact'));
    });

    test('should create request geo location button', () {
      final button = Keyboard.button.requestGeoLocation('Share location');
      expect(button.text, equals('Share location'));
      expect(button.type, equals('request_geo_location'));
    });

    test('should create chat button', () {
      final button = Keyboard.button.chat('Create chat', 'Chat Title');
      expect(button.text, equals('Create chat'));
      expect(button.chatTitle, equals('Chat Title'));
      expect(button.type, equals('chat'));
    });
  });

  group('AttachmentHelper', () {
    test('should create image attachment', () {
      final image = ImageAttachmentHelper(url: 'https://example.com/image.png');
      final json = image.toJson();
      expect(json['type'], equals('image'));
      expect(json['payload']['url'], equals('https://example.com/image.png'));
    });

    test('should create sticker attachment', () {
      final sticker = StickerAttachmentHelper(code: 'abc123');
      final json = sticker.toJson();
      expect(json['type'], equals('sticker'));
      expect(json['payload']['code'], equals('abc123'));
    });

    test('should create location attachment', () {
      final location = LocationAttachmentHelper(latitude: 55.75, longitude: 37.62);
      final json = location.toJson();
      expect(json['type'], equals('location'));
      expect(json['latitude'], equals(55.75));
      expect(json['longitude'], equals(37.62));
    });
  });

  group('UpdateType', () {
    test('should parse from string', () {
      expect(
        UpdateType.fromString('message_created'),
        equals(UpdateType.messageCreated),
      );
      expect(
        UpdateType.fromString('bot_started'),
        equals(UpdateType.botStarted),
      );
    });
  });

  group('Update', () {
    test('should parse MessageCreatedUpdate', () {
      final update = Update.fromJson({
        'update_type': 'message_created',
        'timestamp': 1234567890,
        'message': {
          'sender': {
            'user_id': 1,
            'name': 'Test User',
            'username': 'testuser',
            'is_bot': false,
            'last_activity_time': 1234567890,
          },
          'recipient': {
            'chat_id': 123,
            'chat_type': 'dialog',
          },
          'timestamp': 1234567890,
          'body': {
            'mid': 'msg-1',
            'seq': 1,
            'text': 'Hello',
          },
        },
      });
      expect(update, isA<MessageCreatedUpdate>());
      expect(update.updateType, equals(UpdateType.messageCreated));
    });

    test('should parse BotStartedUpdate', () {
      final update = Update.fromJson({
        'update_type': 'bot_started',
        'timestamp': 1234567890,
        'chat_id': 123,
        'user': {
          'user_id': 1,
          'name': 'Test User',
          'username': 'testuser',
          'is_bot': false,
          'last_activity_time': 1234567890,
        },
        'payload': 'start_payload',
      });
      expect(update, isA<BotStartedUpdate>());
      final botStarted = update as BotStartedUpdate;
      expect(botStarted.payload, equals('start_payload'));
    });
  });
}
