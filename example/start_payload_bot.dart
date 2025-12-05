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
      return ctx.reply('Bot started with payload: ${ctx.startPayload}');
    },
  ]);

  // ignore: avoid_print
  print('Starting start payload bot...');
  await bot.start();
}
