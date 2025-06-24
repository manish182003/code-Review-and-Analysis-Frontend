import 'package:code_review_and_analysis/utils/theme/app_color.dart';
import 'package:flutter/material.dart';

class AnimatedTypingDots extends StatefulWidget {
  const AnimatedTypingDots({Key? key}) : super(key: key);

  @override
  State<AnimatedTypingDots> createState() => _AnimatedTypingDotsState();
}

class _AnimatedTypingDotsState extends State<AnimatedTypingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    // Create 3 animation controllers with staggered delays
    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    // Create animations for each dot
    _animations =
        _controllers.map((controller) {
          return Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );
        }).toList();

    // Start animations with staggered delays
    _startAnimations();
  }

  void _startAnimations() async {
    while (mounted) {
      for (int i = 0; i < _controllers.length; i++) {
        if (mounted) {
          _controllers[i].forward();
          await Future.delayed(
            const Duration(milliseconds: 150),
          ); // Stagger delay
        }
      }

      // Wait for all animations to complete
      await Future.delayed(const Duration(milliseconds: 600));

      // Reset all controllers
      for (var controller in _controllers) {
        if (mounted) {
          controller.reset();
        }
      }

      // Small pause before restarting
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -8 * _animations[index].value),
              child: Opacity(
                opacity: 0.4 + (0.6 * _animations[index].value),
                child: Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: AppColor.textColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// Alternative simpler approach using your existing method but with proper looping
class SimpleTypingDots extends StatefulWidget {
  const SimpleTypingDots({Key? key}) : super(key: key);

  @override
  State<SimpleTypingDots> createState() => _SimpleTypingDotsState();
}

class _SimpleTypingDotsState extends State<SimpleTypingDots> {
  int _currentDot = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    while (mounted) {
      for (int i = 0; i < 3; i++) {
        if (mounted) {
          setState(() {
            _currentDot = i;
          });
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return _buildTypingDot(index);
      }),
    );
  }

  Widget _buildTypingDot(int index) {
    bool isActive = index == _currentDot;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      transform: Matrix4.translationValues(0, isActive ? -4 : 0, 0),
      decoration: BoxDecoration(
        color: AppColor.textColor,
        shape: BoxShape.circle,
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isActive ? 1.0 : 0.5,
      ),
    );
  }
}
