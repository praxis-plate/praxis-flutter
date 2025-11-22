import 'package:codium/core/widgets/svg_asset.dart';
import 'package:flutter/material.dart';

class AssetsTestScreen extends StatelessWidget {
  const AssetsTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assets Test')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, 'Onboarding Illustrations', [
            _buildAssetCard(
              context,
              'Onboarding 1 - Welcome',
              const OnboardingAsset(pageNumber: 1, size: 200),
            ),
            _buildAssetCard(
              context,
              'Onboarding 2 - AI Feature',
              const OnboardingAsset(pageNumber: 2, size: 200),
            ),
            _buildAssetCard(
              context,
              'Onboarding 3 - Progress',
              const OnboardingAsset(pageNumber: 3, size: 200),
            ),
          ]),
          const SizedBox(height: 32),
          _buildSection(context, 'Empty State Illustrations', [
            _buildAssetCard(
              context,
              'Empty Library',
              const EmptyStateAsset(type: EmptyStateType.library, size: 150),
            ),
            _buildAssetCard(
              context,
              'Empty History',
              const EmptyStateAsset(type: EmptyStateType.history, size: 150),
            ),
            _buildAssetCard(
              context,
              'Empty Bookmarks',
              const EmptyStateAsset(type: EmptyStateType.bookmarks, size: 150),
            ),
            _buildAssetCard(
              context,
              'No Internet',
              const EmptyStateAsset(type: EmptyStateType.noInternet, size: 150),
            ),
            _buildAssetCard(
              context,
              'Search Empty',
              const EmptyStateAsset(
                type: EmptyStateType.searchEmpty,
                size: 150,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildAssetCard(BuildContext context, String title, Widget asset) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            asset,
          ],
        ),
      ),
    );
  }
}
