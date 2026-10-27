import 'package:flutter/material.dart';

import '../services/app_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const _currencies = ['\$', '€', '£', '₹', '¥'];

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete all expenses?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await appState.clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.system,
                            label: Text('System'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            label: Text('Light'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            label: Text('Dark'),
                          ),
                        ],
                        selected: {appState.themeMode},
                        onSelectionChanged: (selection) =>
                            appState.setThemeMode(selection.first),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Currency',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    DropdownButton<String>(
                      value: appState.currency,
                      items: [
                        for (final symbol in _currencies)
                          DropdownMenuItem(value: symbol, child: Text(symbol)),
                      ],
                      onChanged: (value) {
                        if (value != null) appState.setCurrency(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Delete all expenses'),
                onTap: () => _confirmClear(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
