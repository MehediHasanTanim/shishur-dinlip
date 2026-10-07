import 'package:shishur_dinlipi/core/domain/models/milestone.dart';

enum MilestoneTemplate {
  firstCrawl,
  firstStand,
  firstStep,
  firstWalk,
  firstRun,
  firstBicycle,
  firstWord,
  firstSentence,
  wroteOwnName,
}

extension MilestoneTemplateX on MilestoneTemplate {
  bool get opensFirstWord => this == MilestoneTemplate.firstWord;

  String get category => switch (this) {
    MilestoneTemplate.firstCrawl ||
    MilestoneTemplate.firstStand ||
    MilestoneTemplate.firstStep ||
    MilestoneTemplate.firstWalk ||
    MilestoneTemplate.firstRun ||
    MilestoneTemplate.firstBicycle => MilestoneCategories.movement,
    MilestoneTemplate.firstWord ||
    MilestoneTemplate.firstSentence => MilestoneCategories.speech,
    MilestoneTemplate.wroteOwnName => MilestoneCategories.learning,
  };
}
