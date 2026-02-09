import 'package:flutter/material.dart';

import 'package:roguelike_dungeon/ui/hub/hub_screen.dart';
import 'package:roguelike_dungeon/ui/settings/settings_screen.dart';

/// Main menu with New Game / Continue / Settings.
/// Layout: panel takes ~30–40% of the screen width over a background.
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final panelWidth = size.width * 0.35; // between 30–40%

    return Scaffold(
      body: Stack(
        children: [
          // Background placeholder; will be replaced by your pixel-art image.
          Positioned.fill(
            child: Container(
              color: Colors.black,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: panelWidth,
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.7),
                border: Border.fromBorderSide(
                  BorderSide(color: Colors.white, width: 2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Roguelike Dungeon',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 24),
                  _MenuButton(
                    label: 'New Game',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const HubScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _MenuButton(
                    label: 'Continue',
                    onPressed: () {
                      // TODO(ch12): Open save slot selection / load and go to hub.
                    },
                  ),
                  const SizedBox(height: 12),
                  _MenuButton(
                    label: 'Settings',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 2),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}

