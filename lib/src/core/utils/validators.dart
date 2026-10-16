class Validators {
  Validators._();

  static String? requiredField(
    String? value, {
    String fieldName = 'Este campo',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio.';
    }

    return null;
  }

  static String? name(String? value) {
    final requiredError = requiredField(value, fieldName: 'El nombre');

    if (requiredError != null) {
      return requiredError;
    }

    if (value!.trim().length < 2) {
      return 'Ingresa un nombre válido.';
    }

    return null;
  }

  static String? email(String? value) {
    final requiredError = requiredField(value, fieldName: 'El correo');

    if (requiredError != null) {
      return requiredError;
    }

    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailPattern.hasMatch(value!.trim())) {
      return 'Ingresa un correo válido.';
    }

    return null;
  }

  static String? password(String? value) {
    final requiredError = requiredField(value, fieldName: 'La contraseña');

    if (requiredError != null) {
      return requiredError;
    }

    if (value!.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }

    return null;
  }

  static String? categoryName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Ingresa un nombre para la categoría.';
    }

    if (text.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres.';
    }

    if (text.length > 30) {
      return 'El nombre no puede superar los 30 caracteres.';
    }

    return null;
  }

  static String? transactionAmount(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Ingresa un monto.';
    }

    final validFormat = RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(text);

    if (!validFormat) {
      return 'Ingresa un monto válido con máximo 2 decimales.';
    }

    final amount = double.tryParse(text.replaceAll(',', '.'));

    if (amount == null || amount <= 0) {
      return 'El monto debe ser mayor a 0.';
    }

    return null;
  }

  static String? transactionDescription(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Ingresa una descripción.';
    }

    if (text.length < 2) {
      return 'La descripción debe tener al menos 2 caracteres.';
    }

    if (text.length > 60) {
      return 'La descripción no puede superar los 60 caracteres.';
    }

    return null;
  }

  static String? transactionNote(String? value) {
    final text = value?.trim() ?? '';

    if (text.length > 200) {
      return 'La nota no puede superar los 200 caracteres.';
    }

    return null;
  }

  static String? budgetLimitAmount(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Ingresa el límite del presupuesto.';
    }

    final validFormat = RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(text);

    if (!validFormat) {
      return 'Ingresa un monto válido con máximo 2 decimales.';
    }

    final amount = double.tryParse(text.replaceAll(',', '.'));

    if (amount == null || amount <= 0) {
      return 'El límite debe ser mayor a 0.';
    }

    return null;
  }
}
