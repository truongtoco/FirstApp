import 'package:flutter/material.dart';
import 'package:task_manager_app/services/shared_prefs_service.dart';

class OnboardingProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  final SharedPrefsService _prefsService = SharedPrefsService();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final int totalPages;

  OnboardingProvider({required this.totalPages});

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  bool get isLastPage => _currentIndex == totalPages - 1;

  void nextPage() {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  Future<void> completeOnboarding() async {
    await _prefsService.setFirstLaunch(false);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}