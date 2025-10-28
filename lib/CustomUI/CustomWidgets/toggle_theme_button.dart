import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mytravaly_flutter_assesment/Utils/theme_manager.dart';

class ThemeToggle extends StatefulWidget {
  const ThemeToggle({super.key});

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _rotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _scale = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animate() {
    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return GestureDetector(
      onTap: () {
        themeManager.toggleTheme();
        _animate();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotation.value * 3.14,
            child: Transform.scale(
              scale: 1 + (0.1 * _scale.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeManager.isDarkMode
                      ? Colors.amber.withOpacity(0.2)
                      : Colors.indigo.withOpacity(0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: themeManager.isDarkMode
                          ? Colors.orangeAccent.withOpacity(0.4)
                          : Colors.indigoAccent.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  themeManager.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                  size: 30,
                  color: themeManager.isDarkMode
                      ? Colors.amberAccent
                      : Colors.indigoAccent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
