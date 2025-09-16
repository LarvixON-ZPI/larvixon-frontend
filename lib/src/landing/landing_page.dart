import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:larvixon_frontend/src/landing/presentation/background.dart';

import '../authentication/presentation/auth_page.dart';
import 'presentation/about_section.dart';
import 'presentation/contact_section.dart';
import 'presentation/footer.dart';
import 'presentation/landing_content.dart';
import 'presentation/landing_navbar.dart';

class LandingPage extends StatefulWidget {
  static const String route = '/';
  static const String name = 'landing';

  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToKey(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Background(),
          Column(
            children: [
              LandingNavBar(
                onAboutPressed: () => _scrollToKey(_aboutKey),
                onContactPressed: () => _scrollToKey(_contactKey),
                onSignInPressed: () => context.go(AuthPage.route),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(key: _heroKey, child: const LandingContent()),
                      Padding(
                        key: _aboutKey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 48,
                        ),
                        child: AboutSection(),
                      ),
                      Padding(
                        key: _contactKey,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 48,
                        ),
                        child: ContactSection(),
                      ),
                      const Footer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
