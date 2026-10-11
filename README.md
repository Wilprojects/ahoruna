# Ahoruna

**Tus finanzas, más simples.**

Ahoruna es una aplicación móvil de gestión de finanzas personales
desarrollada con Flutter para Android y iOS.

## Tecnologías

- Flutter
- Dart
- Riverpod
- GoRouter
- Firebase (próximas fases)

## Arquitectura

El proyecto utiliza una arquitectura Feature First combinada con una
Clean Architecture simplificada.

Cada funcionalidad podrá dividirse en:

- Presentation
- Domain
- Data

## Ramas

- `main`: versión estable.
- `develop`: integración y desarrollo activo.

## Requisitos

- Flutter SDK
- Android Studio
- Android SDK
- Git

## Ejecutar el proyecto

```bash
flutter pub get
flutter run
```

## Validaciones

```bash
flutter analyze
flutter test
```

## Estado del proyecto

### Fase 1 - Completada

- Configuración inicial de Flutter.
- Arquitectura base Feature First.
- Riverpod.
- GoRouter.
- Configuración inicial de Light/Dark Theme.

### Fase 2 - Completada

- Sistema visual de Ahoruna.
- Paleta de colores centralizada.
- Gradientes.
- Espaciados y radios.
- Sistema tipográfico.
- ThemeExtension con colores personalizados.
- Tema claro.
- Tema oscuro.
- ThemeMode administrado con Riverpod.
- Componentes reutilizables:
    - AhorunaBrandMark
    - AhorunaButton
    - AhorunaCard
    - AhorunaTextField
    - AhorunaAppBar
    - AhorunaBottomNavigationBar
    - LoadingView
    - EmptyView
    - ErrorView
- Pantalla temporal de validación del Design System.

### Fase 3 - Completada

- Implementación de Splash Screen.
- Persistencia local del estado de onboarding.
- Uso de SharedPreferencesAsync.
- Arquitectura Data / Domain / Presentation para onboarding.
- Repository Pattern.
- Casos de uso:
  - GetOnboardingStatus.
  - CompleteOnboarding.
- Inyección de dependencias mediante Riverpod.
- Onboarding interactivo de tres páginas.
- Navegación inicial con GoRouter.
- Pantallas:
  - Login.
  - Registro.
  - Recuperación de contraseña.
  - Home provisional.
- Validaciones reutilizables de formularios.
- Flujo de autenticación simulado.
- Pruebas unitarias del dominio.
- Prueba de widget de Login.

### Fase 4 - Completada

- Integración de Firebase Core.
- Configuración mediante FlutterFire CLI.
- Firebase Authentication con Email/Password.
- Cloud Firestore.
- Registro real de usuarios.
- Inicio de sesión real.
- Persistencia automática de sesión.
- Cierre de sesión.
- Recuperación real de contraseña.
- Creación de perfil de usuario en Firestore.
- Protección de rutas con GoRouter.
- Gestión de autenticación mediante Riverpod.
- Implementación de Clean Architecture para Authentication:
  - Data Sources.
  - Repository.
  - Use Cases.
  - Domain Entity.
  - Controller.
  - Providers.
- Traducción de errores Firebase a mensajes de dominio.
- Reglas iniciales de seguridad de Firestore.
- Pruebas unitarias de casos de uso.

#### Modelo inicial de Firestore

users/{uid}

- displayName
- email
- photoUrl
- createdAt
- updatedAt