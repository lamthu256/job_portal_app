import 'package:flutter/material.dart';
import 'package:job_portal_app/theme/app_theme.dart';

class ThemePreviewScreen extends StatelessWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('🎨 Theme Preview'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text("displayLarge", style: textTheme.displayLarge),
              const SizedBox(height: 8),
              Text("displayMedium", style: textTheme.displayMedium),
              const SizedBox(height: 8),
              Text("headlineLarge", style: textTheme.headlineLarge),
              const SizedBox(height: 8),
              Text("headlineMedium", style: textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text("headlineSmall", style: textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text("titleLarge", style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text("titleMedium", style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text("titleSmall", style: textTheme.titleSmall),
              const SizedBox(height: 8),
              Text("bodyLarge", style: textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text("bodyMedium", style: textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text("bodySmall", style: textTheme.bodySmall),
              const SizedBox(height: 8),
              Text("labelLarge", style: textTheme.labelLarge),
              const SizedBox(height: 8),
              Text("labelMedium", style: textTheme.labelMedium),
              const SizedBox(height: 8),
              Text("labelSmall", style: textTheme.labelSmall),

              const Text('Buttons', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () {}, child: const Text('Elevated Button')),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: () {}, child: const Text('Outlined Button')),
              const SizedBox(height: 8),
              TextButton(onPressed: () {}, child: const Text('Text Button')),

              const SizedBox(height: 24),
              const Text('Input Field'),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter something...',
                  labelText: 'Label',
                ),
              ),

              const SizedBox(height: 24),
              const Text('Status Colors (Chip Preview):'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(label: Text('Success'), backgroundColor: AppColors.success),
                  Chip(label: Text('Warning'), backgroundColor: AppColors.warning),
                  Chip(label: Text('Error'), backgroundColor: AppColors.error),
                  Chip(label: Text('Primary'), backgroundColor: AppColors.primary, labelStyle: TextStyle(color: Colors.white)),
                ],
              ),

              const SizedBox(height: 24),
              const Text('Surface Example:'),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('This is a Card'),
                      SizedBox(height: 4),
                      Text('Using surface color + border radius'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
