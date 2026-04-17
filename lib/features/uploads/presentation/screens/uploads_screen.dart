import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../shared/models/upload_item.dart';

class UploadsScreen extends ConsumerWidget {
  const UploadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploads = ref.watch(uploadItemsProvider);
    final doneCount = uploads.where((item) => item.isDone).length;
    final failedCount = uploads.where((item) => item.isFailed).length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Uploads',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 20,
                runSpacing: 8,
                children: [
                  Text('Total: ${uploads.length}'),
                  Text('Ready: $doneCount'),
                  Text('Failed: $failedCount'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...uploads.map((item) => _UploadCard(item: item)),
        ],
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({required this.item});

  final UploadItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.fileName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                _StatusChip(status: item.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('Category: ${item.category}'),
            if (item.sizeBytes != null)
              Text('Size: ${(item.sizeBytes! / 1000000).toStringAsFixed(2)} MB'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: item.progress / 100,
              minHeight: 6,
            ),
            const SizedBox(height: 6),
            Text('Progress: ${item.progress}%'),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final UploadStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      UploadStatus.uploading => 'Uploading',
      UploadStatus.ready => 'Ready',
      UploadStatus.failed => 'Failed',
    };

    final color = switch (status) {
      UploadStatus.uploading => Theme.of(context).colorScheme.secondaryContainer,
      UploadStatus.ready => Theme.of(context).colorScheme.primaryContainer,
      UploadStatus.failed => Theme.of(context).colorScheme.errorContainer,
    };

    return Chip(
      label: Text(label),
      backgroundColor: color,
    );
  }
}
