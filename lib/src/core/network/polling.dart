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
  final void Function(int)? _onMarkerChanged;
  bool _isRunning = false;
  int? _marker;

  Polling(
    this._api, {
    List<UpdateType>? allowedUpdates,
    int? marker,
    void Function(int)? onMarkerChanged,
  })  : _allowedUpdates = allowedUpdates ?? [],
        _marker = marker,
        _onMarkerChanged = onMarkerChanged;

  /// Start the polling loop
  Future<void> loop(Future<void> Function(Update) handleUpdate) async {
    _isRunning = true;
    // ignore: avoid_print
    print('Polling started${_marker != null ? ' with marker: $_marker' : ''}');

    while (_isRunning) {
      try {
        final typesString = _allowedUpdates.isEmpty
            ? null
            : _allowedUpdates.map((t) => t.value).join(',');

        final response = await _api.getUpdates(
          types: typesString,
          marker: _marker,
        );

        if (_marker != response.marker) {
          _marker = response.marker;
          _onMarkerChanged?.call(_marker!);
        }

        await Future.wait(response.updates.map(handleUpdate));
      } on MaxError catch (e) {
        // ignore: avoid_print
        print('Polling error (MaxError): $e');
        if (e.status == 429 || e.status >= 500) {
          await Future<void>.delayed(_retryInterval);
          continue;
        }
        rethrow;
      } catch (e) {
        // ignore: avoid_print
        print('Polling error: $e');
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
