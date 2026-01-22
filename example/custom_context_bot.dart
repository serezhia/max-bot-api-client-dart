import 'dart:io';

import 'package:max_bot_api/max_bot_api.dart';

/// Custom context with additional logging
class CustomContext extends Context {
  CustomContext(super.update, super.api, [super.botInfo]);

  @override
  Future<Message> reply(String text, [SendMessageExtra? extra]) {
    // ignore: avoid_print
    print('Reply to $chatId with text: $text');
    return super.reply(text, extra);
  }
}

void main() async {
  final token = Platform.environment['BOT_TOKEN'];
  if (token == null) {
    throw Exception('Token must be provided');
  }

  // Create bot with custom context factory
  final bot = Bot<CustomContext>(
    token,
    config: BotConfig(
      contextFactory: (update, api, botInfo) =>
          CustomContext(update, api, botInfo),
    ),
  );

  await bot.api.setMyCommands([
    const BotCommand(name: 'start'),
  ]);

  bot.command('start', [(ctx, next) => ctx.reply('Hello!')]);

  // Handle any other message
  bot.on(UpdateType.messageCreated, [
    (ctx, next) async {
      await ctx.reply('Send /start to begin');
    },
  ]);

  // Error handling
    bot.catch_((error, trace, ctx) {
    // ignore: avoid_print
    print('Error processing update: $error');
  });

  // ignore: avoid_print
  print('Starting custom context bot...');
  await bot.start();
}
