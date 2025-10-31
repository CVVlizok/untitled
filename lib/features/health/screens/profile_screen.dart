// lib/features/health/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _avatarUrl =
      'https://cdn-icons-png.flaticon.com/128/10438/10438143.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: 96,
              height: 96,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(48),
                child: CachedNetworkImage(
                  imageUrl: _avatarUrl,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (_, __, ___) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, __, ___) =>
                  const Center(child: Icon(Icons.error, color: Colors.red)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Профиль',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}