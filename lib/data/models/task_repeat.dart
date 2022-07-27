enum Repeat { none, repeatDaily, repeatWeekly, repeatMonthly }

const Map<int, Repeat> taskRepeats = {
  0: Repeat.none,
};

String getRepeat(int repeatIndex) {
  switch (repeatIndex) {
    case 0:
      return 'None';
    case 1:
      return 'Daily';
    case 2:
      return 'Weekly';
    case 3:
      return 'Monthly';
    default:
      return 'None';
  }
}
