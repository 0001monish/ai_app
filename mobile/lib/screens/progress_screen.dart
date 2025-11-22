// mobile/lib/screens/progress_screen.dart
import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Progress")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Quiz Accuracy Over Time",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(child: Text("Quiz 1")),
                        Container(
                          width: 150,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey.shade300,
                          ),
                          child: FractionallySizedBox(
                            widthFactor: 0.85,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 60,
                          child: Text('85%', textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(child: Text("Quiz 2")),
                        Container(
                          width: 150,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey.shade300,
                          ),
                          child: FractionallySizedBox(
                            widthFactor: 0.72,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 60,
                          child: Text('72%', textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Detailed History",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                child: Text("85%"),
              ),
              title: const Text("Sample Textbook - Chapter 1"),
              subtitle: const Text("Streak: 5 correct"),
              trailing: const Icon(Icons.trending_up, color: Colors.green),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text("72%"),
              ),
              title: const Text("Advanced Topics"),
              subtitle: const Text("Streak: 3 correct"),
              trailing: const Icon(Icons.trending_down, color: Colors.orange),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
