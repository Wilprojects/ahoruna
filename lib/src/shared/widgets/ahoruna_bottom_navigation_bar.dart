import 'package:flutter/material.dart';

import 'package:ahoruna/src/app/theme/app_colors.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';

class AhorunaBottomNavigationBar extends StatelessWidget {
  const AhorunaBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<_NavigationItem> _items = [
    _NavigationItem(icon: Icons.home_rounded, label: 'Inicio'),
    _NavigationItem(icon: Icons.receipt_long_rounded, label: 'Movimientos'),
    _NavigationItem(
      icon: Icons.account_balance_wallet_rounded,
      label: 'Presupuesto',
    ),
    _NavigationItem(icon: Icons.bar_chart_rounded, label: 'Reportes'),
    _NavigationItem(icon: Icons.person_rounded, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final selected = index == currentIndex;

              final color = selected ? AppColors.primary : colors.textSecondary;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, size: 21, color: color),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: color,
                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
