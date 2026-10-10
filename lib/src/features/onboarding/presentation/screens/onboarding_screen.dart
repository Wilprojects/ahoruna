import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_router.dart';
import 'package:ahoruna/src/app/theme/app_colors.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:ahoruna/src/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() {
    return _OnboardingScreenState();
  }
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;
  bool _isCompleting = false;

  static const _pages = [
    _OnboardingContent(
      icon: Icons.receipt_long_rounded,
      title: 'Entiende a dónde va tu dinero',
      description:
          'Registra tus ingresos y gastos de forma simple '
          'y mantén tus finanzas siempre bajo control.',
    ),
    _OnboardingContent(
      icon: Icons.pie_chart_rounded,
      title: 'Organiza tus presupuestos',
      description:
          'Define límites para tus categorías y descubre '
          'cuánto puedes gastar antes de excederte.',
    ),
    _OnboardingContent(
      icon: Icons.flag_rounded,
      title: 'Convierte tus planes en metas',
      description:
          'Crea objetivos de ahorro, registra tus aportes '
          'y visualiza tu progreso paso a paso.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    if (_isCompleting) {
      return;
    }

    setState(() {
      _isCompleting = true;
    });

    try {
      final completeOnboarding = ref.read(completeOnboardingUseCaseProvider);

      await completeOnboarding();

      ref.invalidate(onboardingCompletedProvider);

      if (!mounted) {
        return;
      }

      context.go(AppRoutes.login);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isCompleting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No pudimos guardar tu configuración. '
            'Inténtalo nuevamente.',
          ),
        ),
      );
    }
  }

  Future<void> _nextPage() async {
    if (_currentPage == _pages.length - 1) {
      await _completeOnboarding();
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 12, 0),
              child: Row(
                children: [
                  Text(
                    'Ahoruna',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _isCompleting ? null : _completeOnboarding,
                    child: const Text('Omitir'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];

                  return OnboardingPage(
                    icon: page.icon,
                    title: page.title,
                    description: page.description,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final selected = index == _currentPage;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: selected ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : colors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  AhorunaButton(
                    label: _currentPage == _pages.length - 1
                        ? 'Comenzar'
                        : 'Continuar',
                    icon: _currentPage == _pages.length - 1
                        ? Icons.check_rounded
                        : Icons.arrow_forward_rounded,
                    isLoading: _isCompleting,
                    onPressed: _isCompleting ? null : _nextPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingContent {
  const _OnboardingContent({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
