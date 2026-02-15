import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quotemytrade/pages/landing/landing_page.dart';
import 'package:quotemytrade/pages/quote_assistance/quote_assistance_page.dart';
import 'package:quotemytrade/pages/how_it_works/how_it_works_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LandingPage()),
    GoRoute(
      path: '/quote-assistance',
      builder: (context, state) => const QuoteAssistancePage(),
    ),
    GoRoute(
      path: '/how-it-works',
      builder: (context, state) => const HowItWorksPage(),
    ),
  ],
);
