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
}
