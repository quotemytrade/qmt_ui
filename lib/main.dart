import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotemytrade/pages/landing/landing_page.dart';
import 'package:quotemytrade/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:quotemytrade/router.dart';
import 'package:quotemytrade/core/config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await FirebaseConfig.initialize();
  runApp(
    ProviderScope(
      child: MaterialApp.router(
        title: 'QuoteMyTrade',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuoteMyTrade',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LandingPage(),
    );
  }
}
