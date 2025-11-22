import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PdfCard extends StatelessWidget {
  final String title;
  final DateTime date;
  final VoidCallback onTap;
  final bool isPremium;

  const PdfCard({
    super.key,
    required this.title,
    required this.date,
    required this.onTap,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isPremium ? const Color(0xFF00BFA6) : const Color(0xFF3D5AFE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPremium ? LucideIcons.star : LucideIcons.fileText,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${date.day}/${date.month}/${date.year}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (isPremium)
                const Chip(
                  label: Text("Premium", style: TextStyle(fontSize: 10)),
                  backgroundColor: Color(0xFF00BFA6),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
