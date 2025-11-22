import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_manager.dart';
import '../providers/app_providers.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(subscriptionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Go Premium")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.star, color: Colors.amber),
                title: Text("Premium"),
                subtitle: Text("• Unlimited PDFs\n• Voice Tutor\n• Analytics\n• Cloud Backup"),
              ),
            ),
            const SizedBox(height: 20),
            if (manager.products.isNotEmpty)
              ElevatedButton(
                onPressed: manager.purchasePending ? null : manager.purchasePremium,
                child: manager.purchasePending
                    ? const CircularProgressIndicator()
                    : Text("Buy ${manager.products.first.price}/month"),
              ),
            if (manager.isPremium)
              const Chip(label: Text("Premium Active"), backgroundColor: Colors.green),
          ],
        ),
      ),
    );
  }
}
