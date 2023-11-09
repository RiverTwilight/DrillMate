import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_handler/share_handler.dart';
import 'package:hgeology_app/utils/cache_helper.dart';
import 'package:hgeology_app/utils/native/platform_check.dart';
import 'package:hgeology_app/provider/persistance_provider.dart';
import 'package:hgeology_app/gen/strings.g.dart';

StreamSubscription? _sharedMediaSubscription;

/// Will be called before the MaterialApp started
Future<PersistenceService> preInit(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final persistenceService = await PersistenceService.initialize();

  // Register default plural resolver
  for (final locale in AppLocale.values) {
    if ([AppLocale.en].contains(locale)) {
      continue;
    }

    LocaleSettings.setPluralResolver(
      locale: locale,
      cardinalResolver: (n, {zero, one, two, few, many, other}) {
        if (n == 0) {
          return zero ?? other ?? n.toString();
        }
        if (n == 1) {
          return one ?? other ?? n.toString();
        }
        return other ?? n.toString();
      },
      ordinalResolver: (n, {zero, one, two, few, many, other}) {
        return other ?? n.toString();
      },
    );
  }

  return persistenceService;
}

/// Will be called when home page has been initialized
Future<void> postInit(BuildContext context, WidgetRef ref, bool appStart,
    void Function(SharedMedia) handleReceiveShare) async {
  bool hasInitialShare = false;

  if (checkPlatformCanReceiveShareIntent()) {
    final shareHandler = ShareHandlerPlatform.instance;

    if (appStart) {
      final initialSharedPayload = await shareHandler.getInitialSharedMedia();
      if (initialSharedPayload != null) {
        hasInitialShare = true;
        unawaited(
          _handleSharedIntent(initialSharedPayload, ref),
        );
      }
    }

    _sharedMediaSubscription?.cancel(); // ignore: unawaited_futures
    _sharedMediaSubscription =
        shareHandler.sharedMediaStream.listen((SharedMedia payload) {
      _handleSharedIntent(payload, ref);
      handleReceiveShare(payload);
    });
  }

  if (appStart &&
      !hasInitialShare &&
      (checkPlatformWithGallery() || checkPlatformCanReceiveShareIntent())) {
    // Clear cache on every app start.
    // If we received a share intent, then don't clear it, otherwise the shared file will be lost.
    clearCache();
  }
}

Future<void> _handleSharedIntent(SharedMedia payload, WidgetRef ref) async {
  // final message = payload.content;
}
