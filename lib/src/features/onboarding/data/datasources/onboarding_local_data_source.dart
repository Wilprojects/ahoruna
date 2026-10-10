import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnboardingLocalDataSource {
  Future<bool> isCompleted();

  Future<void> complete();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  OnboardingLocalDataSourceImpl(this._preferences);

  static const String _onboardingCompletedKey = 'onboarding_completed';

  final SharedPreferencesAsync _preferences;

  @override
  Future<bool> isCompleted() async {
    final completed = await _preferences.getBool(_onboardingCompletedKey);

    return completed ?? false;
  }

  @override
  Future<void> complete() {
    return _preferences.setBool(_onboardingCompletedKey, true);
  }
}
