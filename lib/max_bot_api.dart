/// Max Bot API Client for Dart
///
/// A framework for building bots for Max messenger.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:max_bot_api/max_bot_api.dart';
///
/// void main() async {
///   final bot = Bot(Platform.environment['BOT_TOKEN']!);
///
///   // Set bot commands
///   await bot.api.setMyCommands([
///     BotCommand(name: 'ping', description: 'Play ping-pong'),
///   ]);
///
///   // Handle bot started event
///   bot.on(UpdateType.botStarted, [
///     (ctx, next) => ctx.reply('Hello! Send /ping to play ping-pong'),
///   ]);
///
///   // Handle /ping command
///   bot.command('ping', [(ctx, next) => ctx.reply('pong')]);
///
///   // Handle 'hello' text
///   bot.hears('hello', [(ctx, next) => ctx.reply('world')]);
///
///   // Handle all other messages
///   bot.on(UpdateType.messageCreated, [
///     (ctx, next) => ctx.reply(ctx.message?.body.text ?? 'No text'),
///   ]);
///
///   await bot.start();
/// }
/// ```
library;

export 'src/api.dart';
export 'src/bot.dart';
export 'src/composer.dart';
export 'src/context.dart';
export 'src/core/helpers/helpers.dart';
export 'src/core/network/api/api.dart'
    show
        BotAddedUpdate,
        BotCommand,
        BotInfo,
        BotRemovedUpdate,
        BotStartedUpdate,
        Button,
        ButtonIntent,
        Callback,
        CallbackButton,
        Chat,
        ChatButton,
        ChatMember,
        ChatPermissions,
        ChatStatus,
        ChatTitleChangedUpdate,
        ChatType,
        ClientOptions,
        LinkButton,
        MaxError,
        Message,
        MessageBody,
        MessageCallbackUpdate,
        MessageChatCreatedUpdate,
        MessageConstructedUpdate,
        MessageConstructionRequestUpdate,
        MessageCreatedUpdate,
        MessageEditedUpdate,
        MessageLinkType,
        MessageRemovedUpdate,
        RequestContactButton,
        RequestGeoLocationButton,
        SenderAction,
        Update,
        UpdateType,
        User,
        UserAddedUpdate,
        UserRemovedUpdate;
export 'src/filters.dart';
export 'src/middleware.dart';
