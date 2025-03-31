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

    final escena5_1 = DecisionNode(videoName: 'Escena5_1');
    final escena5_2 = DecisionNode(videoName: 'Escena5_2');

    final escena5 = DecisionNode(videoName: 'Escena5');
    escena5_1.positiveDecision = escena5;
    escena5_1.negativeDecision = escena5;
    escena5_2.positiveDecision = escena5;
    escena5_2.negativeDecision = escena5;

    final escena4_1 = DecisionNode(
      videoName: 'Escena4_1',
      positiveDecision: escena5_2,
      negativeDecision: escena5_1,
    );
    final escena4_2 = DecisionNode(
      videoName: 'Escena4_2',
      positiveDecision: escena5_2,
      negativeDecision: escena5_1,
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

  DecisionNode get currentNode => _currentNode;
  int get positiveCount => _positiveCount;
  int get negativeCount => _negativeCount;

  void makeDecision(bool isPositive) {
    if (_currentNode.isFinal) return;

    if (_currentNode.videoName == 'Escena5') {
      if (_positiveCount >= 2) {
        _currentNode = DecisionNode(videoName: 'FinalBueno');
      } else if (_negativeCount >= 2) {
        _currentNode = DecisionNode(videoName: 'FinalMalo');
      } else {
        _currentNode = DecisionNode(videoName: 'FinalNeutro');
      }
      return;
    }

    if (isPositive) {
      _positiveCount++;
      _currentNode = _currentNode.positiveDecision!;
    } else {
      _negativeCount++;
      _currentNode = _currentNode.negativeDecision!;
    }
  }

  void reset() {
    _initializeFlow();
    _positiveCount = 0;
    _negativeCount = 0;
  }
}
