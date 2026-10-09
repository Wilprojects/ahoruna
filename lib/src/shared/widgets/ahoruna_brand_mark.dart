import 'package:flutter/material.dart';

import 'package:ahoruna/src/app/theme/app_gradients.dart';
import 'package:ahoruna/src/app/theme/app_shadows.dart';

class AhorunaBrandMark extends StatelessWidget {
  const AhorunaBrandMark({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppGradients.brand,
        borderRadius: BorderRadius.circular(size * 0.34),
        boxShadow: AppShadows.primary,
      ),
      child: Icon(
        Icons.account_balance_wallet_rounded,
        color: Colors.white,
        size: size * 0.48,
      ),
    );
  }
}
