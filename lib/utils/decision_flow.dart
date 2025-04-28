import 'package:flutter/foundation.dart';

class DecisionNode {
  final String videoName;
  DecisionNode? positiveDecision;
  DecisionNode? negativeDecision;

  DecisionNode({
    required this.videoName,
    this.positiveDecision,
    this.negativeDecision,
  });

  bool get isFinal => positiveDecision == null && negativeDecision == null;
}

class DecisionFlowController {
  static final DecisionFlowController _instance = DecisionFlowController._internal();
  factory DecisionFlowController() => _instance;
  DecisionFlowController._internal() {
    _initializeFlow();
  }

  late DecisionNode _startNode;
  late DecisionNode _currentNode;
  int _positiveCount = 0;
  int _negativeCount = 0;

  void _initializeFlow() {
    debugPrint('Inicializando el flujo de decisiones...');

    final finalBueno = DecisionNode(videoName: 'FinalBueno');
    final finalMalo = DecisionNode(videoName: 'FinalMalo');
    final finalNeutro = DecisionNode(videoName: 'FinalNeutro');

    final escena5_1 = DecisionNode(
      videoName: 'Escena5_1',
      positiveDecision: finalMalo,
      negativeDecision: finalMalo,
    );

    final escena5_2 = DecisionNode(
      videoName: 'Escena5_2',
      positiveDecision: finalBueno,
      negativeDecision: finalBueno,
    );

    final escena5 = DecisionNode(
      videoName: 'Escena5',
      positiveDecision: escena5_2,
      negativeDecision: escena5_1,
    );

    final escena4_1 = DecisionNode(
      videoName: 'Escena4_1',
      positiveDecision: escena5,
      negativeDecision: escena5,
    );

    final escena4_2 = DecisionNode(
      videoName: 'Escena4_2',
      positiveDecision: escena5,
      negativeDecision: escena5,
    );

    final escena4 = DecisionNode(
      videoName: 'Escena4',
      positiveDecision: escena4_2,
      negativeDecision: escena4_1,
    );

    final escena3_1 = DecisionNode(
      videoName: 'Escena3_1',
      positiveDecision: escena4,
      negativeDecision: escena4,
    );

    final escena3_2 = DecisionNode(
      videoName: 'Escena3_2',
      positiveDecision: escena4,
      negativeDecision: escena4,
    );

    final escena3 = DecisionNode(
      videoName: 'Escena3',
      positiveDecision: escena3_2,
      negativeDecision: escena3_1,
    );

    final escena2 = DecisionNode(
      videoName: 'Escena2',
      positiveDecision: escena3,
      negativeDecision: escena3,
    );

    _startNode = DecisionNode(
      videoName: 'Escena1',
      positiveDecision: escena2,
      negativeDecision: escena2,
    );

    _currentNode = _startNode;
  }

  DecisionNode getFinal() {
    debugPrint('Evaluando el final...');
    if (_positiveCount == 3) {
      debugPrint('Final positivo alcanzado: FinalBueno');
      return DecisionNode(videoName: 'FinalBueno');
    }
    if (_negativeCount == 3) {
      debugPrint('Final negativo alcanzado: FinalMalo');
      return DecisionNode(videoName: 'FinalMalo');
    }
    debugPrint('Final neutro alcanzado: FinalNeutro');
    return DecisionNode(videoName: 'FinalNeutro');
  }

  DecisionNode get currentNode => _currentNode;
  int get positiveCount => _positiveCount;
  int get negativeCount => _negativeCount;

  void setCurrentNode(DecisionNode node) {
    _currentNode = node;
    debugPrint('Nodo actual actualizado a: ${node.videoName}');
  }

  void makeDecision(bool isPositive) {
    debugPrint('Haciendo decisión: ${isPositive ? "Positiva" : "Negativa"}');
    if (_currentNode.isFinal) return;

    if (isPositive) {
      _positiveCount++;
      debugPrint('Decisión positiva tomada. Contador positivo: $_positiveCount');
      _currentNode = _currentNode.positiveDecision!;
    } else {
      _negativeCount++;
      debugPrint('Decisión negativa tomada. Contador negativo: $_negativeCount');
      _currentNode = _currentNode.negativeDecision!;
    }
  }

  void reset() {
    debugPrint('Reiniciando flujo...');
    _positiveCount = 0;
    _negativeCount = 0;
    _initializeFlow();
  }
}
