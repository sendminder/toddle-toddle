enum GoalFilterType {
  all,
  active,
  completed,
}

extension GoalFilterTypeExtension on GoalFilterType {
  GoalFilterType getRightFilterType() {
    switch (this) {
      case GoalFilterType.all:
        return GoalFilterType.active;
      case GoalFilterType.active:
        return GoalFilterType.completed;
      case GoalFilterType.completed:
        return GoalFilterType.all;
    }
  }

  GoalFilterType getLeftFilterType() {
    switch (this) {
      case GoalFilterType.all:
        return GoalFilterType.completed;
      case GoalFilterType.active:
        return GoalFilterType.all;
      case GoalFilterType.completed:
        return GoalFilterType.active;
    }
  }
}
