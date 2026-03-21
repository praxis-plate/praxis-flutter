import 'package:cached_network_image/cached_network_image.dart';
import 'package:praxis/core/utils/constants.dart';
import 'package:praxis/domain/models/user/user_profile_model.dart';
import 'package:flutter/material.dart';

class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({super.key, required this.userProfile});

  final UserProfileModel userProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarUrl = userProfile.avatarUrl;
    final hasAvatar = avatarUrl != null && avatarUrl.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: hasAvatar
                        ? CachedNetworkImage(
                            height: 120,
                            width: 120,
                            alignment: Alignment.topCenter,
                            fit: BoxFit.cover,
                            imageUrl: avatarUrl,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              Constants.placeholderProfileImagePath,
                            ),
                          )
                        : Image.asset(
                            // Avatar is optional until the user uploads one.
                            Constants.placeholderProfileImagePath,
                            height: 120,
                            width: 120,
                            alignment: Alignment.topCenter,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: -10,
                  child: IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(Icons.image),
                  ),
                ),
              ],
            ),
            Text(userProfile.name, style: theme.textTheme.bodyMedium),
            Text(userProfile.email, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
