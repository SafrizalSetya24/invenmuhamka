import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../pages/notification/notification_page.dart';
import '../pages/profile/profile_page.dart';
import '../utils/nav_helper.dart';

class HeaderNotificationBell extends StatelessWidget {
  final UserModel user;
  final int count;

  const HeaderNotificationBell({
    super.key,
    required this.user,
    this.count = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF4B5563),
          ),
          onPressed: () {
            NavHelper.navigateTo(context, NotificationPage(user: user));
          },
        ),
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class HeaderUserPill extends StatelessWidget {
  final UserModel user;
  final bool isDesktop;

  const HeaderUserPill({
    super.key,
    required this.user,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavHelper.navigateTo(context, ProfilePage(user: user));
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFF0038A8),
              child: Text(
                user.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isDesktop) ...[
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  Text(
                    user.role,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
