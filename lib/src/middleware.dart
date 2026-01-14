/// Middleware types for Max Bot API
library;

import 'dart:async';

import 'context.dart';

/// Next function type
typedef NextFn = Future<void> Function();

/// Middleware function type
typedef MiddlewareFn<Ctx extends Context> = FutureOr<void> Function(
  Ctx ctx,
  NextFn next,
);

/// Middleware object interface
abstract class MiddlewareObj<Ctx extends Context> {
  MiddlewareFn<Ctx> middleware();
}

/// Middleware type - can be function or object
typedef Middleware<Ctx extends Context> = MiddlewareFn<Ctx>;
