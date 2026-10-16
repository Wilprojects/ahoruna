class Budget {
  const Budget({
    required this.id,
    required this.categoryId,
    required this.limitAmount,
    required this.currency,
    required this.period,
    required this.alertPercent,
    required this.isActive,
  });

  final String id;
  final String categoryId;

  /// Límite definido por el usuario.
  final double limitAmount;

  /// Moneda asociada al presupuesto.
  final String currency;

  /// Formato YYYY-MM.
  final String period;

  /// Porcentaje a partir del cual mostramos alerta.
  final int alertPercent;

  final bool isActive;
}
