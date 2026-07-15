import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const LiteFApp());

// ✅ Alamat Frenzo yang benar
const String linkSitus = 'https://tikotok.webze.eu.org/';

class LiteFApp extends StatelessWidget {
  const LiteFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frenzo Lite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
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
  late final WebViewController kontrol;
  bool sedangMuat = true;

  @override
  void initState() {
    super.initState();
    kontrol = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => sedangMuat = true),
        onPageFinished: (_) => setState(() => sedangMuat = false),
      ))
      ..loadRequest(Uri.parse(linkSitus));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: kontrol),
          if (sedangMuat)
            const Center(child: CircularProgressIndicator(color: Colors.deepPurple)),
        ],
      ),
    );
  }
}
