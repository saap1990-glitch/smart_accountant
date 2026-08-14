class SalesTarget {
  final String id;
  final String name;
  final double monthlyTarget;
  final double yearlyTarget;
  final double achievedMonth;
  final double achievedYear;
  final String? salespersonId;
  final String? salespersonName;

  SalesTarget({
    required this.id,
    required this.name,
    this.monthlyTarget = 0,
    this.yearlyTarget = 0,
    this.achievedMonth = 0,
    this.achievedYear = 0,
    this.salespersonId,
    this.salespersonName,
  });

  double get monthPercentage =>
      monthlyTarget > 0 ? (achievedMonth / monthlyTarget * 100) : 0;
  double get yearPercentage =>
      yearlyTarget > 0 ? (achievedYear / yearlyTarget * 100) : 0;
  double get monthRemaining => monthlyTarget - achievedMonth;
  double get yearRemaining => yearlyTarget - achievedYear;
  int get monthDaysLeft =>
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
          .difference(DateTime.now())
          .inDays;
}

class TargetService {
  final List<SalesTarget> _targets = [];

  List<SalesTarget> get allTargets => List.unmodifiable(_targets);

  void setTarget(SalesTarget target) {
    final index = _targets.indexWhere((t) => t.id == target.id);
    if (index >= 0) {
      _targets[index] = target;
    } else {
      _targets.add(target);
    }
  }

  SalesTarget? getTarget(String id) {
    try {
      return _targets.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  // الهدف العام (كل المندوبين)
  SalesTarget get overallTarget {
    double totalMonthTarget = 0, totalYearTarget = 0;
    double totalMonthAchieved = 0, totalYearAchieved = 0;

    for (var t in _targets) {
      totalMonthTarget += t.monthlyTarget;
      totalYearTarget += t.yearlyTarget;
      totalMonthAchieved += t.achievedMonth;
      totalYearAchieved += t.achievedYear;
    }

    return SalesTarget(
      id: 'overall',
      name: 'الهدف العام',
      monthlyTarget: totalMonthTarget,
      yearlyTarget: totalYearTarget,
      achievedMonth: totalMonthAchieved,
      achievedYear: totalYearAchieved,
    );
  }

  List<SalesTarget> get topPerformers {
    final sorted = List<SalesTarget>.from(_targets)
      ..sort((a, b) => b.monthPercentage.compareTo(a.monthPercentage));
    return sorted.take(5).toList();
  }
}
