import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/common/nav_item.dart';

class NavMenu extends StatelessWidget {
  final List<NavItem> items;
  const NavMenu(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<NavItem>(
      tooltip: '',
      offset: const Offset(0, 40),
      icon: const Icon(Icons.menu),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).iconTheme.color,
      ),
      onSelected: (item) {
        (item.onTap ?? () => context.go(item.route))();
      },
      itemBuilder: (context) => items
          .map(
            (item) => PopupMenuItem<NavItem>(
              value: item,
              child: Row(
                children: [
                  Icon(item.icon, size: 18),
                  const SizedBox(width: 8),
                  Text(item.label),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
