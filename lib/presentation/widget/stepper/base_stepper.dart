import 'package:flutter/material.dart';
import 'package:stepper_a/stepper_a.dart';

class BaseStepper extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final Function(int) onStepTap;

  const BaseStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.onStepTap,
  });

  @override
  State<BaseStepper> createState() => _BaseStepperState();
}

class _BaseStepperState extends State<BaseStepper> {
  final StepperAController _controller = StepperAController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StepperA(
          stepperSize: const Size(70, 350),
          //stepperSize: const Size(300, 95),
          borderShape: BorderShape.circle,
          borderType: BorderType.straight,
          stepperAxis: Axis.vertical,
          lineType: LineType.dotted,
          stepperBackgroundColor: Colors.transparent,
          stepperAController: _controller,
          stepHeight: 40,
          stepWidth: 40,
          stepBorder: true,
          pageSwipe: true,
          formValidation: false,

          previousButton: (int index) => StepperAButton(
            width: 40,
            height: 40,
            onTap: (int currentIndex) {
              debugPrint("Previous Button Current Index $currentIndex");
            },
            buttonWidget: const Icon(Icons.arrow_back, color: Colors.white),
          ),

          forwardButton: (index) => StepperAButton(
            onComplete: () {
              debugPrint("Forward Button click complete step call back!");
            },
            width: 40,

            height: 40,
            onTap: (int currentIndex) {
              debugPrint("Forward Button Current Index $currentIndex");
            },
            boxDecoration: BoxDecoration(
              color: index == 3 ? Colors.indigo : Colors.green,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            buttonWidget: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
          customSteps: const [
            CustomSteps(stepsIcon: Icons.login, title: "LogIn"),
            CustomSteps(stepsIcon: Icons.home, title: "Home"),
            CustomSteps(stepsIcon: Icons.account_circle, title: "Account"),
            CustomSteps(stepsIcon: Icons.account_circle, title: "Account"),
          ],
          step: const StepA(
            currentStepColor: Colors.green,
            completeStepColor: Colors.indigo,
            inactiveStepColor: Colors.black45,

            margin: EdgeInsets.all(5),
          ),
          stepperBodyWidget: [
            Center(child: Text('step 1')),
            Center(child: Text('step 2')),
            Center(child: Text('step 3')),
            Center(child: Text('step 4')),
          ],
        ),
      ],
    );
  }
}
