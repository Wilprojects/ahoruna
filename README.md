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

### Fase 5 - Completada

- Gestión de perfil de usuario.
- Edición de nombre.
- Sincronización de displayName entre Firebase Auth y Firestore.
- Pantalla de configuración.
- Preferencia de moneda.
- Preferencia de idioma.
- Preferencia de notificaciones.
- Configuración del porcentaje de alerta de presupuesto.
- Tema Sistema, Claro y Oscuro.
- Persistencia local del tema.
- Sincronización de preferencias mediante Firestore.
- Pantalla de seguridad.
- Recuperación/cambio de contraseña mediante Firebase.
- Cierre de sesión.
- Rutas privadas para perfil y configuración.

#### Modelo de preferencias

users/{uid}/settings/preferences

- currency
- language
- theme
- notificationsEnabled
- budgetAlertPercent
- createdAt
- updatedAt

### Fase 6 - Completada

Se implementó la gestión completa de categorías
financieras.

#### Funcionalidades

- Categorías de gastos.
- Categorías de ingresos.
- Categorías compatibles con ambos tipos.
- Categorías predeterminadas por usuario.
- Creación automática de categorías iniciales.
- Creación de categorías personalizadas.
- Edición de categorías.
- Eliminación de categorías personalizadas.
- Protección de categorías predeterminadas.
- Selector de iconos.
- Selector de colores.
- Vista previa de categoría.
- Prevención de nombres duplicados.
- Filtros por tipo.
- Sincronización en tiempo real con Firestore.

#### Firestore

Las categorías se almacenan en:

users/{uid}/categories/{categoryId}

Campos:

- name
- nameNormalized
- iconKey
- colorHex
- type
- isDefault
- isActive
- createdAt
- updatedAt

#### Arquitectura

La feature Categories utiliza:

- Data Sources.
- Repository Pattern.
- Domain Entities.
- Use Cases.
- Riverpod.
- AsyncNotifier.
- StreamProvider.
- Cloud Firestore en tiempo real.

#### Categorías predeterminadas

- Alimentación.
- Transporte.
- Hogar.
- Salud.
- Entretenimiento.
- Servicios.
- Sueldo.
- Freelance.
- Inversiones.
- Otros.

#### Validaciones

- No se permiten nombres vacíos.
- No se permiten nombres duplicados.
- Las categorías predeterminadas no pueden eliminarse.
- Las categorías pertenecen únicamente al usuario autenticado.

### Fase 7 - Completada

Se implementó el CRUD completo de movimientos
financieros.

#### Funcionalidades

- Registro de gastos.
- Registro de ingresos.
- Edición de movimientos.
- Eliminación de movimientos.
- Listado en tiempo real.
- Asociación con categorías.
- Filtrado automático de categorías según tipo.
- Selección de fecha.
- Notas opcionales.
- Validación de montos.
- Persistencia de moneda.
- Protección de categorías utilizadas.

#### Modelo Firestore

users/{uid}/transactions/{transactionId}

Campos:

- type
- amount
- currency
- description
- categoryId
- date
- note
- createdAt
- updatedAt

#### Reglas del modelo

- amount siempre se almacena positivo.
- type determina si es ingreso o gasto.
- Los gastos se representan visualmente con signo negativo.
- Los ingresos se representan visualmente con signo positivo.
- Cada movimiento pertenece exclusivamente al usuario autenticado.
- Cada movimiento referencia una categoría mediante categoryId.
- No se puede eliminar una categoría que tenga movimientos asociados.

#### Arquitectura

La feature Transactions utiliza:

- Data Sources.
- Repository Pattern.
- Domain Entities.
- Use Cases.
- Riverpod.
- AsyncNotifier.
- StreamProvider.
- Cloud Firestore en tiempo real.

### Fase 8 - Completada

Se implementó el Dashboard financiero en tiempo real
de Ahoruna utilizando los movimientos almacenados en
Cloud Firestore.

#### Funcionalidades

- Balance financiero real.
- Balance histórico.
- Ingresos del mes actual.
- Gastos del mes actual.
- Movimientos recientes.
- Máximo de cinco movimientos recientes.
- Acceso rápido para registrar movimientos.
- Acceso rápido al historial.
- Acceso rápido a categorías.
- Actualización automática mediante Riverpod y Firestore.
- Soporte de múltiples monedas sin mezclar importes.

#### Cálculos

Balance:

total ingresos - total gastos

El balance utiliza todo el historial de movimientos
de la moneda seleccionada.

Ingresos y gastos mensuales utilizan únicamente los
movimientos correspondientes al mes actual.

#### Monedas

Los totales del Dashboard solamente consideran los
movimientos cuya moneda coincide con la moneda
configurada actualmente.

Los movimientos de otras monedas conservan su valor
original y pueden aparecer en el historial reciente,
pero no se mezclan en los totales.

#### Arquitectura

El Dashboard no tiene colección propia en Firestore.

Se deriva de:

- transactionsProvider.
- userPreferencesProvider.
- CalculateDashboardSummary.
- dashboardSummaryProvider.

Esto mantiene transactions como fuente de verdad.

#### Tiempo real

Los cambios en movimientos provocan automáticamente
el recálculo del Dashboard:

- Crear movimiento.
- Editar movimiento.
- Eliminar movimiento.

También se recalcula al cambiar la moneda configurada.

### Fase 9 - Completada

Se mejoró el historial de movimientos con búsqueda
y filtros avanzados.

#### Búsqueda

La búsqueda permite encontrar movimientos por:

- Descripción.
- Nota.
- Nombre de categoría.

La búsqueda:

- No distingue mayúsculas/minúsculas.
- Tolera acentos comunes.
- Admite coincidencias parciales.
- Permite múltiples términos.

#### Filtros

Se incorporaron filtros por:

- Todos los movimientos.
- Gastos.
- Ingresos.
- Categoría.
- Mes actual.
- Últimos 30 días.
- Rango personalizado de fechas.

Los filtros pueden combinarse.

#### Historial

- Resultados ordenados por fecha descendente.
- Agrupación por día.
- Encabezados Hoy y Ayer.
- Contador de resultados.
- Estado vacío.
- Estado sin coincidencias.
- Persistencia temporal de filtros durante navegación.

#### Arquitectura

Se incorporaron:

- TransactionFilter.
- TransactionFilterController.
- FilterTransactions.
- filteredTransactionsProvider.
- TransactionFiltersSheet.

El Dashboard continúa utilizando transactionsProvider
sin verse afectado por los filtros del historial.

#### Firestore

No se agregaron nuevas colecciones ni índices.

Los filtros se aplican localmente sobre el stream
de movimientos del usuario.

### Fase 10 - Completada

Se implementó la gestión de presupuestos mensuales
por categoría.

#### Funcionalidades

- Creación de presupuestos.
- Edición de presupuestos.
- Eliminación de presupuestos.
- Presupuestos mensuales.
- Navegación entre períodos.
- Planificación de meses futuros.
- Presupuestos por categoría.
- Compatibilidad con múltiples monedas.
- Límite mensual.
- Porcentaje configurable de alerta.
- Estado En orden.
- Estado Alerta.
- Estado Excedido.
- Resumen total de presupuestos.
- Total gastado.
- Saldo disponible.
- Protección de categorías utilizadas.

#### Modelo Firestore

users/{uid}/budgets/{budgetId}

Campos:

- categoryId
- limitAmount
- currency
- period
- alertPercent
- isActive
- createdAt
- updatedAt

No se almacena spentAmount.

#### Cálculo

El monto gastado se deriva de los movimientos:

- type = expense
- categoryId = categoría del presupuesto
- currency = moneda del presupuesto
- date = período del presupuesto

Esto mantiene Transactions como fuente de verdad.

#### Alertas

Cada presupuesto contiene alertPercent.

Mientras:

spent / limit < alertPercent

el presupuesto permanece En orden.

Cuando:

spent / limit >= alertPercent

se muestra Alerta.

Cuando:

spent / limit >= 100%

se muestra Excedido.

Las notificaciones push reales se implementarán en
la Fase 13.

#### Arquitectura

Se incorporaron:

- Budget.
- BudgetOverview.
- BudgetProgress.
- BudgetRepository.
- BudgetsRemoteDataSource.
- CalculateBudgetOverview.
- BudgetPeriodController.
- BudgetsController.
- budgetsForPeriodProvider.
- selectedBudgetOverviewProvider.