class BugReport {
  BugReport({
    required this.description,
    this.stepsToReproduce,
    this.expectedBehavior,
    this.issueType,
    this.screen,
    this.frequency,
  });

  final String description;
  final List<String>? stepsToReproduce;
  final String? expectedBehavior;
  final String? issueType;
  final String? screen;
  final String? frequency;
}
