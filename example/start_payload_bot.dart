import 'dart:io';

import 'package:max_bot_api/max_bot_api.dart';

void main() async {
  final token = Platform.environment['BOT_TOKEN'];
  if (token == null) {
    throw Exception('Token not provided');
  }

  final bot = Bot(token);

  // Handle bot started event with payload
  bot.on(UpdateType.botStarted, [
    (ctx, next) async {
      await ctx.reply('Bot started with payload: ${ctx.startPayload}');
    },
  ]);

  // Handle any message
  bot.on(UpdateType.messageCreated, [
    (ctx, next) async {
      await ctx.reply(
          'Hello! This bot only handles bot_started events with payloads.');
    },
  ]);

  // Error handling
  bot.catch_((error, trace, ctx) {
    // ignore: avoid_print
    print('Error processing update: $error');
  });

  // ignore: avoid_print
  print('Starting start payload bot...');
  await bot.start();
}
