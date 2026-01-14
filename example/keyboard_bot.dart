import 'dart:io';

import 'package:max_bot_api/max_bot_api.dart';

void main() async {
  final token = Platform.environment['BOT_TOKEN'];
  if (token == null) {
    throw Exception('Token not provided');
  }

  final bot = Bot(token);

  await bot.api.setMyCommands([
    const BotCommand(name: 'callback', description: 'Send callback keyboard'),
    const BotCommand(
        name: 'geoLocation', description: 'Send geoLocation request'),
    const BotCommand(name: 'contact', description: 'Send contact request'),
    const BotCommand(name: 'createChat', description: 'Create chat'),
  ]);

  // Default keyboard buttons
  List<List<Button>> defaultKeyboard() {
    return [
      [Keyboard.button.link('❤️', 'https://dev.max.ru/')],
      [
        Keyboard.button.callback('Remove message', 'remove_message',
            intent: ButtonIntent.negative)
      ],
    ];
  }

  // Handle remove_message callback
  bot.action('remove_message', [
    (ctx, next) async {
      final result = await ctx.deleteMessage();
      await ctx.answerOnCallback(AnswerOnCallbackExtra(
        notification: result.success
            ? 'Successfully removed message'
            : 'Failed to remove message',
      ));
    },
  ]);

  // Callback keyboard command
  bot.command('callback', [
    (ctx, next) async {
      final keyboard = Keyboard.inlineKeyboard([
        [
          Keyboard.button.callback('default', 'color:default'),
          Keyboard.button.callback('positive', 'color:positive',
              intent: ButtonIntent.positive),
          Keyboard.button.callback('negative', 'color:negative',
              intent: ButtonIntent.negative),
        ],
        ...defaultKeyboard(),
      ]);
      await ctx.reply(
          'Callback keyboard', SendMessageExtra(attachments: [keyboard]));
    },
  ]);

  // Handle color callback
  bot.action(RegExp(r'color:(.+)'), [
    (ctx, next) async {
      final color = ctx.match?.group(1) ?? 'unknown';
      await ctx.answerOnCallback(AnswerOnCallbackExtra(
        message: {
          'text': 'Your choice: $color color',
          'attachments': [],
        },
      ));
    },
  ]);

  // GeoLocation keyboard command
  bot.command('geoLocation', [
    (ctx, next) async {
      final keyboard = Keyboard.inlineKeyboard([
        [Keyboard.button.requestGeoLocation('Send geoLocation')],
        ...defaultKeyboard(),
      ]);
      await ctx.reply(
          'GeoLocation keyboard', SendMessageExtra(attachments: [keyboard]));
    },
  ]);

  // Handle location
  bot.on(UpdateType.messageCreated, [
    (ctx, next) async {
      final location = ctx.location;
      if (location == null) return next();
      await ctx
          .reply('Your location: ${location.latitude}, ${location.longitude}');
    },
  ]);

  // Contact keyboard command
  bot.command('contact', [
    (ctx, next) async {
      final keyboard = Keyboard.inlineKeyboard([
        [Keyboard.button.requestContact('Send my contact')],
        ...defaultKeyboard(),
      ]);
      await ctx.reply(
          'Contact keyboard', SendMessageExtra(attachments: [keyboard]));
    },
  ]);

  // Handle contact
  bot.on(UpdateType.messageCreated, [
    (ctx, next) async {
      final contactInfo = ctx.contactInfo;
      if (contactInfo == null) return next();
      await ctx.reply(
          'Your name: ${contactInfo.fullName}\nYour phone: ${contactInfo.tel}');
    },
  ]);

  // CreateChat keyboard command
  bot.command(RegExp(r'createChat(.+)?'), [
    (ctx, next) async {
      final chatTitle = ctx.match?.group(1)?.trim();
      if (chatTitle == null || chatTitle.isEmpty) {
        await ctx.reply('Enter chat title after command');
        return;
      }
      final keyboard = Keyboard.inlineKeyboard([
        [Keyboard.button.chat('Create chat "$chatTitle"', chatTitle)],
      ]);
      await ctx.reply(
          'Create chat keyboard', SendMessageExtra(attachments: [keyboard]));
    },
  ]);

  // Fallback handler for unrecognized messages
  bot.on(UpdateType.messageCreated, [
    (ctx, next) async {
      await ctx.reply(
        'Available commands:\n'
        '/callback - Show callback keyboard\n'
        '/geoLocation - Request location\n'
        '/contact - Request contact\n'
        '/createChat <title> - Create chat',
      );
    },
  ]);

  // Error handling
  bot.catch_((error, ctx) {
    // ignore: avoid_print
    print('Error processing update: $error');
  });

  // ignore: avoid_print
  print('Starting keyboard bot...');
  await bot.start();
}
