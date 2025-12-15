import 'package:flutter/material.dart';

class StepBaseWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<Widget>? children;

  const StepBaseWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children ?? [],
      ),
    );
  }
}
