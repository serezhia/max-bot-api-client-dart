/// Composer class for Max Bot API middleware
library;

import 'dart:async';

import 'context.dart';
import 'core/network/api/api.dart';
import 'filters.dart';
import 'middleware.dart';

/// Trigger type - can be string or RegExp
typedef Triggers = Object;

/// Composer class for building middleware chains
class Composer<Ctx extends Context> implements MiddlewareObj<Ctx> {
  late MiddlewareFn<Ctx> _handler;

  Composer([List<Middleware<Ctx>>? middlewares]) {
    _handler = compose(middlewares ?? []);
  }

  @override
  MiddlewareFn<Ctx> middleware() => _handler;

  /// Use middleware
  Composer<Ctx> use(List<Middleware<Ctx>> middlewares) {
    _handler = compose([_handler, ...middlewares]);
    return this;
  }

  /// Handle specific update types
  Composer<Ctx> on(Object filters, List<Middleware<Ctx>> middlewares) {
    return use([filter(filters, middlewares)]);
  }

  /// Handle command
  Composer<Ctx> command(Triggers command, List<Middleware<Ctx>> middlewares) {
    final normalizedTriggers = _normalizeTriggers(command);
    final textFilter = createdMessageBodyHas(['text']);
    final handler = compose(middlewares);

    return use([
      filter(textFilter, [
        (Ctx ctx, NextFn next) async {
          final msg = ctx.message;
          if (msg == null) return next();

          var text = _extractTextFromMessage(msg, ctx.myId);
          if (text == null || !text.startsWith('/')) return next();

          text = text.substring(1); // Remove leading '/'

          for (final trigger in normalizedTriggers) {
            final match = trigger(text);
            if (match != null) {
              ctx.match = match;
              return handler(ctx, next);
            }
          }
          return next();
        },
      ]),
    ]);
  }

  /// Handle text patterns
  Composer<Ctx> hears(Triggers triggers, List<Middleware<Ctx>> middlewares) {
    final normalizedTriggers = _normalizeTriggers(triggers);
    final textFilter = createdMessageBodyHas(['text']);
    final handler = compose(middlewares);

    return use([
      filter(textFilter, [
        (Ctx ctx, NextFn next) async {
          final msg = ctx.message;
          if (msg == null) return next();

          final text = _extractTextFromMessage(msg, ctx.myId);
          if (text == null) return next();

          for (final trigger in normalizedTriggers) {
            final match = trigger(text);
            if (match != null) {
              ctx.match = match;
              return handler(ctx, next);
            }
          }
          return next();
        },
      ]),
    ]);
  }

  /// Handle callback actions
  Composer<Ctx> action(Triggers triggers, List<Middleware<Ctx>> middlewares) {
    final normalizedTriggers = _normalizeTriggers(triggers);
    final handler = compose(middlewares);

    return use([
      filter(UpdateType.messageCallback, [
        (Ctx ctx, NextFn next) async {
          if (ctx.update is! MessageCallbackUpdate) return next();
          final payload =
              (ctx.update as MessageCallbackUpdate).callback.payload;
          if (payload == null) return next();

          for (final trigger in normalizedTriggers) {
            final match = trigger(payload);
            if (match != null) {
              ctx.match = match;
              return handler(ctx, next);
            }
          }
          return next();
        },
      ]),
    ]);
  }

  /// Create a filter middleware
  MiddlewareFn<Ctx> filter(Object filters, List<Middleware<Ctx>> middlewares) {
    final handler = compose(middlewares);
    return (Ctx ctx, NextFn next) {
      return ctx.has(filters) ? handler(ctx, next) : next();
    };
  }

  /// Flatten middleware
  static MiddlewareFn<C> flatten<C extends Context>(Middleware<C> mw) {
    return mw;
  }

  /// Concatenate two middlewares
  static MiddlewareFn<C> concat<C extends Context>(
    MiddlewareFn<C> first,
    MiddlewareFn<C> andThen,
  ) {
    return (C ctx, NextFn next) async {
      var nextCalled = false;
      await first(ctx, () async {
        if (nextCalled) {
          throw StateError('`next` already called before!');
        }
        nextCalled = true;
        await andThen(ctx, next);
      });
    };
  }

  /// Pass middleware (no-op)
  static Future<void> pass<C extends Context>(C ctx, NextFn next) {
    return next();
  }

  /// Compose middlewares
  static MiddlewareFn<C> compose<C extends Context>(
    List<Middleware<C>> middlewares,
  ) {
    if (middlewares.isEmpty) {
      return pass;
    }
    return middlewares.map(flatten<C>).reduce(concat);
  }

  /// Normalize triggers to list of matcher functions
  List<RegExpMatch? Function(String)> _normalizeTriggers(Triggers triggers) {
    final triggerList = triggers is List ? triggers : [triggers];
    return triggerList.map((trigger) {
      if (trigger is RegExp) {
        return (String value) {
          return trigger.firstMatch(value.trim());
        };
      }
      if (trigger is String) {
        final regex = RegExp('^$trigger\$');
        return (String value) => regex.firstMatch(value.trim());
      }
      throw ArgumentError('Invalid trigger type: ${trigger.runtimeType}');
    }).toList();
  }

  /// Extract text from message, handling mentions
  String? _extractTextFromMessage(Message message, int? myId) {
    final text = message.body.text;
    if (text == null) return null;

    final markup = message.body.markup;
    if (markup != null) {
      for (final m in markup) {
        if (m is UserMentionMarkup && m.from == 0 && m.userId == myId) {
          return text.substring(m.length).trim();
        }
      }
    }

    return text;
  }
}
