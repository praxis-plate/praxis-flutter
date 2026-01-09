import 'package:codium/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AssetsTestScreen extends StatelessWidget {
  const AssetsTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assets Test')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _AssetsSection(
            title: 'Onboarding Illustrations',
            children: [
              _AssetCard(
                title: 'Onboarding 1 - Welcome',
                asset: OnboardingAsset(pageNumber: 1, size: 200),
              ),
              _AssetCard(
                title: 'Onboarding 2 - AI Feature',
                asset: OnboardingAsset(pageNumber: 2, size: 200),
              ),
              _AssetCard(
                title: 'Onboarding 3 - Progress',
                asset: OnboardingAsset(pageNumber: 3, size: 200),
              ),
            ],
          ),
          SizedBox(height: 32),
          _AssetsSection(
            title: 'Empty State Illustrations',
            children: [
              _AssetCard(
                title: 'Empty Library',
                asset: EmptyStateAsset(type: EmptyStateType.library, size: 150),
              ),
              _AssetCard(
                title: 'Empty History',
                asset: EmptyStateAsset(type: EmptyStateType.history, size: 150),
              ),
              _AssetCard(
                title: 'Empty Bookmarks',
                asset: EmptyStateAsset(
                  type: EmptyStateType.bookmarks,
                  size: 150,
                ),
              ),
              _AssetCard(
                title: 'No Internet',
                asset: EmptyStateAsset(
                  type: EmptyStateType.noInternet,
                  size: 150,
                ),
              ),
              _AssetCard(
                title: 'Search Empty',
                asset: EmptyStateAsset(
                  type: EmptyStateType.searchEmpty,
                  size: 150,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _AssetsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
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
}

class _AssetCard extends StatelessWidget {
  final String title;
  final Widget asset;

  const _AssetCard({required this.title, required this.asset});

  @override
  Widget build(BuildContext context) {
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
