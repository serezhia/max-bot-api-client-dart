import 'dart:io';

import 'package:max_bot_api/max_bot_api.dart';

void main() async {
  final token = Platform.environment['BOT_TOKEN'];
  if (token == null) {
    throw Exception('Token not provided');
  }

  final bot = Bot(token);

  // Set bot commands
  await bot.api.setMyCommands([
    const BotCommand(name: 'start', description: 'Start the bot'),
    const BotCommand(name: 'ping', description: 'Play ping-pong'),
    const BotCommand(name: 'help', description: 'Show help'),
  ]);

  // Handle bot started event
  bot.on(UpdateType.botStarted, [
    (ctx, next) => ctx
        .reply('Привет! Отправь мне команду /ping, чтобы сыграть в пинг-понг'),
  ]);

  // Handle /ping command
  bot.command('ping', [(ctx, next) => ctx.reply('pong')]);

  // Handle /start command
  bot.command('start', [
    (ctx, next) => ctx.reply('Добро пожаловать! Используйте /help для справки'),
  ]);

  // Handle /help command
  bot.command('help', [
    (ctx, next) => ctx.reply(
          'Доступные команды:\n'
          '/start - Запустить бота\n'
          '/ping - Играть в пинг-понг\n'
          '/help - Показать эту справку',
        ),
  ]);

  // Handle 'hello' text
  bot.hears('hello', [(ctx, next) => ctx.reply('world')]);

  // Handle all other messages
  bot.on(UpdateType.messageCreated, [
    (ctx, next) => ctx.reply(ctx.message?.body.text ?? 'Не понимаю'),
  ]);

  // Error handling
  bot.catch_((error, trace, ctx) {
    // ignore: avoid_print
    print('Error: $error');
  });

  // ignore: avoid_print
  print('Starting bot...');
  await bot.start();
}
