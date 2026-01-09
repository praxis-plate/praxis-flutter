import 'package:codium/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ).copyWith(top: 64),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Section(title: 'Colors', widget: _ColorsPreview()),
            Section(title: 'Typography', widget: _TypographyPreview()),
            Section(title: 'Buttons', widget: _ButtonsPreview()),
            // Section(
            //   title: 'Cards',
            //   widget: _CardsPreview(),
            // ),
            // Section(
            //   title: 'Textfields',
            //   widget: _TextFieldsPreview(),
            // ),
            Section(title: 'Avatars', widget: _AvatarsPreview()),
          ],
        ),
      ),
    );
  }
}

class _ColorsPreview extends StatelessWidget {
  const _ColorsPreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final swatches = {
      'Primary': theme.colorScheme.primary,
      'Secondary': theme.colorScheme.primaryContainer,
      'Card': theme.cardColor,
      'On primary': theme.colorScheme.onPrimary,
      'On secondary': theme.colorScheme.onSecondary,
      'Divider': theme.dividerColor,
      'Error': theme.colorScheme.error,
      'Surface': theme.colorScheme.surface,
    };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: swatches.entries
          .map((e) => _ColorSwatch(name: e.key, color: e.value))
          .toList(),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.name, required this.color});

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: color == theme.colorScheme.surface
                ? Border.all(color: theme.colorScheme.primary, width: 1)
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _TypographyPreview extends StatelessWidget {
  const _TypographyPreview();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Display Large', style: textTheme.displayLarge),
        // Text('Display Medium', style: textTheme.displayMedium),
        // Text('Display Small', style: textTheme.displaySmall),
        // Text('Headline Large', style: textTheme.headlineLarge),
        // Text('Headline Medium', style: textTheme.headlineMedium),
        // Text('Headline Small', style: textTheme.headlineSmall),
        // Text('Title Large', style: textTheme.titleLarge),
        Text('Title Medium', style: textTheme.titleMedium),
        Text('Title Small', style: textTheme.titleSmall),
        // Text('Body Large', style: textTheme.bodyLarge),
        Text('Body Medium', style: textTheme.bodyMedium),
        Text('Body Small', style: textTheme.bodySmall),
        // Text('Label Large', style: textTheme.labelLarge),
        // Text('Label Medium', style: textTheme.labelMedium),
        Text('Label Small', style: textTheme.labelSmall),
      ],
    );
  }
}

class _ButtonsPreview extends StatelessWidget {
  const _ButtonsPreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('ElevatedButton')),
        FilledButton(onPressed: () {}, child: const Text('FilledButton')),
        OutlinedButton(onPressed: () {}, child: const Text('OutlinedButton')),
        TextButton(onPressed: () {}, child: const Text('TextButton')),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.star, color: theme.colorScheme.primary),
        ),
      ],
    );
  }
}

class _AvatarsPreview extends StatelessWidget {
  const _AvatarsPreview();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primary,
          child: const Icon(Icons.person),
        ),
      ],
    );
  }
}
