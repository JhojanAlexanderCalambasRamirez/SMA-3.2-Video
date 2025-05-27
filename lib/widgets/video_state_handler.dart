import '../utils/decision_flow.dart';

class VideoStateHandler {
  final DecisionFlowController controller;

  VideoStateHandler(this.controller);

  String getFinalFeedbackImage() {
    if (controller.positiveCount == 3) {
      return 'assets/Imagenes/Final_Positivo.png';
    } else if (controller.negativeCount == 3) {
      return 'assets/Imagenes/Final_Negativo.png';
    } else {
      return 'assets/Imagenes/Final_Neutral.png';
    }
  }

  void makeDecision(bool isPositive) {
    controller.makeDecision(isPositive);
  }

  void resetFlow() {
    controller.reset();
  }
}