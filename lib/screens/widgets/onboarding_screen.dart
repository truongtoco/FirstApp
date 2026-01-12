import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/onboarding_provider.dart';
import 'package:task_manager_app/screens/home_screens.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Giả sử có 3 trang
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(totalPages: 3),
      child: Scaffold(
        body: Consumer<OnboardingProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: provider.pageController,
                    onPageChanged: provider.onPageChanged,
                    children: const [
                      Center(child: Text("Page 1")), // Thay bằng Widget thật của bạn
                      Center(child: Text("Page 2")),
                      Center(child: Text("Page 3")),
                    ],
                  ),
                ),

                // Nút Next / Get Started
                ElevatedButton(
                  onPressed: () async {
                    if (provider.isLastPage) {
                      // 1. Gọi Provider lưu trạng thái
                      await provider.completeOnboarding();

                      // 2. UI tự chuyển trang (Tách biệt logic và giao diện)
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreens()),
                        );
                      }
                    } else {
                      provider.nextPage();
                    }
                  },
                  child: Text(provider.isLastPage ? "Get Started" : "Next"),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}