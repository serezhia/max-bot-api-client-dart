/// Bot class for Max Bot API
library;

import 'dart:async';

import 'api.dart';
import 'composer.dart';
import 'context.dart';
import 'core/network/api/api.dart';
import 'core/network/polling.dart';

/// Bot configuration
class BotConfig<Ctx extends Context> {
  final ClientOptions? clientOptions;
  final Context Function(Update update, Api api, BotInfo? botInfo)? contextFactory;

  const BotConfig({
    this.clientOptions,
    this.contextFactory,
  });
}

/// Launch options
class LaunchOptions {
  final List<UpdateType>? allowedUpdates;

  const LaunchOptions({this.allowedUpdates});
}

/// Bot class for creating and running Max bots
class Bot<Ctx extends Context> extends Composer<Ctx> {
  final Api api;
  final BotConfig<Ctx> _config;

  BotInfo? botInfo;
  Polling? _polling;
  bool _pollingIsStarted = false;

  late void Function(Object error, Ctx ctx) _handleError;

  Bot(
    String token, {
    BotConfig<Ctx>? config,
  })  : _config = config ?? const BotConfig(),
        api = Api(createClient(token, config?.clientOptions)),
        super() {
    _handleError = _defaultErrorHandler;
  }

  void _defaultErrorHandler(Object error, Ctx ctx) {
    // ignore: avoid_print
    print('Unhandled error while processing ${ctx.update}');
    throw error;
  }

  /// Set custom error handler
  Bot<Ctx> catch_(void Function(Object error, Ctx ctx) handler) {
    _handleError = handler;
    return this;
  }

  /// Start the bot
  Future<void> start([LaunchOptions? options]) async {
    if (_pollingIsStarted) {
      return;
    }

    _pollingIsStarted = true;

    botInfo ??= await api.getMyInfo();
    _polling = Polling(api, options?.allowedUpdates);

    await _polling!.loop(_handleUpdate);
  }

  /// Stop the bot
  void stop() {
    if (!_pollingIsStarted) {
      return;
    }

    _polling?.stop();
    _pollingIsStarted = false;
  }

  Future<void> _handleUpdate(Update update) async {
    Ctx ctx;
    if (_config.contextFactory != null) {
      ctx = _config.contextFactory!(update, api, botInfo) as Ctx;
    } else {
      ctx = Context(update, api, botInfo) as Ctx;
    }

    try {
      await middleware()(ctx, () => Future.value());
    } catch (err) {
      _handleError(err, ctx);
    }
  }
}
