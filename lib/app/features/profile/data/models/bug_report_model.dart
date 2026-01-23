import '../../domain/entities/bug_report.dart';

class BugReportModel {
  const BugReportModel({
    required this.description,
    this.stepsToReproduce,
    this.expectedBehavior,
    this.issueType,
    this.screen,
    this.frequency,
  });

  factory BugReportModel.fromEntity(BugReport bugReport) => BugReportModel(
    description: bugReport.description,
    stepsToReproduce: bugReport.stepsToReproduce,
    expectedBehavior: bugReport.expectedBehavior,
    issueType: bugReport.issueType,
    screen: bugReport.screen,
    frequency: bugReport.frequency,
  );

  final String description;
  final List<String>? stepsToReproduce;
  final String? expectedBehavior;
  final String? issueType;
  final String? screen;
  final String? frequency;

  Map<String, dynamic> toJson() => {
    'description': description,
    'stepsToReproduce': stepsToReproduce,
    'expectedBehavior': expectedBehavior,
    'issueType': issueType,
    'screen': screen,
    'frequency': frequency,
  };
}
