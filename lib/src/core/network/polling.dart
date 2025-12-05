/// Long polling implementation for Max Bot API
library;

import 'dart:async';

import '../../api.dart' show Api;
import 'api/api.dart';

const _retryInterval = Duration(milliseconds: 5000);

/// Long polling class
class Polling {
  final Api _api;
  final List<UpdateType> _allowedUpdates;
  bool _isRunning = false;
  int? _marker;

  Polling(this._api, [List<UpdateType>? allowedUpdates])
      : _allowedUpdates = allowedUpdates ?? [];

  /// Start the polling loop
  Future<void> loop(Future<void> Function(Update) handleUpdate) async {
    _isRunning = true;

    while (_isRunning) {
      try {
        final typesString = _allowedUpdates.isEmpty
            ? null
            : _allowedUpdates.map((t) => t.value).join(',');

        final response = await _api.getUpdates(
          types: typesString,
          marker: _marker,
        );

        _marker = response.marker;

        await Future.wait(response.updates.map(handleUpdate));
      } on MaxError catch (e) {
        if (e.status == 429 || e.status >= 500) {
          await Future<void>.delayed(_retryInterval);
          continue;
        }
        rethrow;
      } catch (e) {
        if (e.toString().contains('AbortError')) return;
        await Future<void>.delayed(_retryInterval);
      }
    }
  }

  /// Stop polling
  void stop() {
    _isRunning = false;
  }
}
