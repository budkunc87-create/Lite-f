import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const LiteFApp());
}

const String situsFrenzo = 'https://shortcut.webze.eu.org/halaman/login.php';
const Color warnaUtama = Color(0xFF6D28D9);

class LiteFApp extends StatelessWidget {
  const LiteFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lite F',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: warnaUtama,
        useMaterial3: true,
      ),
      home: const HalamanWeb(),
    );
  }
}

class HalamanWeb extends StatefulWidget {
  const HalamanWeb({super.key});

  @override
  State<HalamanWeb> createState() => _HalamanWebState();
}

class _HalamanWebState extends State<HalamanWeb> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Mobile Safari/537.36',
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _loading = true;
            _error = false;
          }),
          onPageFinished: (_) => setState(() => _loading = false),
          onWebResourceError: (_) => setState(() {
            _loading = false;
            _error = true;
          }),
        ),
      )
      ..loadRequest(Uri.parse(situsFrenzo));
  }

  Future<bool> _tanganiTombolKembali() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  void _muatUlang() {
    setState(() {
      _error = false;
      _loading = true;
    });
    _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final bolehKeluar = await _tanganiTombolKembali();
        if (bolehKeluar && context.mounted) {
          Navigator.of(context).maybePop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              if (!_error) WebViewWidget(controller: _controller),

              if (_loading && !_error)
                Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Lite F',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: warnaUtama,
                        ),
                      ),
                      SizedBox(height: 16),
                      CircularProgressIndicator(color: warnaUtama),
                    ],
                  ),
                ),

              if (_error)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 12),
                        const Text(
                          'Tidak bisa terhubung.\nCek koneksi internet kamu.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _muatUlang,
                          style: ElevatedButton.styleFrom(backgroundColor: warnaUtama),
                          child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
