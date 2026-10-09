import 'package:flutter/material.dart';

class AhorunaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AhorunaAppBar({
    required this.title,
    super.key,
    this.actions,
    this.showBackButton = false,
  });

  final String title;
  final List<Widget>? actions;
  final bool showBackButton;

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      actions: actions,
    );
  }
}
