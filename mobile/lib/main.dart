import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/subscription_manager.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize subscription manager in background without blocking
  try {
    await SubscriptionManager().init().timeout(
      const Duration(seconds: 5),
      onTimeout: () => print('Subscription init timed out'),
    );
  } catch (e) {
    print('Subscription init error: $e');
  }

  runApp(const ProviderScope(child: IntelliLearnApp()));
}

class IntelliLearnApp extends StatelessWidget {
  const IntelliLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IntelliLearn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3D5AFE)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
