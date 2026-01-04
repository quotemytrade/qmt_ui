import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:quotemytrade/core/providers/chat_provider.dart';
import 'package:quotemytrade/theme/app_colors.dart';

class ContractorButtonWidget extends ConsumerWidget {
  const ContractorButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.handyman, size: 22),
        label: const Text(
          "Find Local Contractors",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentAlt,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
        onPressed: () async {
          final locationService = ref.read(locationServiceProvider);
          final contractors = await locationService.getLocalContractors(
            'trade',
          );

          if (contractors != null &&
              contractors.isNotEmpty &&
              context.mounted) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text(
                  "Top Local Contractors",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  height: 400,
                  child: ListView.builder(
                    itemCount: contractors.length,
                    itemBuilder: (ctx, i) {
                      final c = contractors[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.accent.withOpacity(0.2),
                            child: Text(
                              "${i + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          title: Text(
                            c['name'],
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "${c['rating']} ⭐ (${c['reviews']} reviews)",
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          onTap: () => launchUrl(Uri.parse(c['link'])),
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Close"),
                  ),
                ],
              ),
            );
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Unable to retrieve local contractors at this time.",
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
