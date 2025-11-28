class MoveVersionDetail {
  final int levelLearned;
  final String learningMethod;
  final String versionGroup;

  MoveVersionDetail({
    required this.levelLearned,
    required this.learningMethod,
    required this.versionGroup,
  });

  String get formattedLearningMethod {
    if (learningMethod == 'level-up') return 'Level Up';
    return learningMethod.replaceAll('-', ' ')[0].toUpperCase() +
        learningMethod.replaceAll('-', ' ').substring(1);
  }
}
