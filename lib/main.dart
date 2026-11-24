import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:window_manager/window_manager.dart';

/// Adresse du backoffice chargé dans la fenêtre.
const backofficeUrl = 'https://backoffice.marche2yama.com';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  await windowManager.waitUntilReadyToShow(
    const WindowOptions(
      title: 'Marché de Yama - Backoffice',
      minimumSize: Size(1024, 700),
      center: true,
    ),
    () async {
      await windowManager.maximize();
      await windowManager.show();
      await windowManager.focus();
    },
  );

  runApp(const BackofficeApp());
}

class BackofficeApp extends StatelessWidget {
  const BackofficeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marché de Yama - Backoffice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF7B1B1E), useMaterial3: true),
      home: const BackofficePage(),
    );
  }
}

/// Le backoffice occupe toute la fenêtre : aucune barre d'application, la page web est l'interface.
class BackofficePage extends StatefulWidget {
  const BackofficePage({super.key});

  @override
  State<BackofficePage> createState() => _BackofficePageState();
}

class _BackofficePageState extends State<BackofficePage> {
  final _controller = WebviewController();
  final _subscriptions = <StreamSubscription<dynamic>>[];
  bool _ready = false;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await _controller.initialize();

      _subscriptions
        ..add(_controller.loadingState.listen((state) {
          if (mounted) setState(() => _loading = state == LoadingState.loading);
        }))
        ..add(_controller.onLoadError.listen((status) {
          if (mounted) setState(() => _error = 'Impossible de charger le backoffice ($status). Vérifiez votre connexion.');
        }));

      await _controller.setBackgroundColor(Colors.white);
      // Les liens qui s'ouvriraient dans une nouvelle fenêtre restent dans celle-ci.
      await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.sameWindow);
      await _controller.loadUrl(backofficeUrl);

      if (mounted) setState(() => _ready = true);
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Le composant WebView2 de Windows est indisponible : installez « Microsoft Edge WebView2 Runtime » puis relancez l\'application.');
      }
    }
  }

  Future<void> _retry() async {
    setState(() => _error = null);
    await _controller.loadUrl(backofficeUrl);
  }

  @override
  void dispose() {
    for (final s in _subscriptions) {
      s.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (_ready) Positioned.fill(child: Webview(_controller)),
          if (_loading && _error == null) const Positioned(top: 0, left: 0, right: 0, child: LinearProgressIndicator(minHeight: 3)),
          if (_error != null)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off, size: 48),
                      const SizedBox(height: 12),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Text(_error!, textAlign: TextAlign.center)),
                      const SizedBox(height: 16),
                      FilledButton(onPressed: _ready ? _retry : null, child: const Text('Réessayer')),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
