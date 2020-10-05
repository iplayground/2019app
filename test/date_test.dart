import 'package:flutter_test/flutter_test.dart';
import 'package:iplayground19/bloc/notification.dart';

void main() {
  test("Test date 1", () {
    final datetime = NotificationHelper.getTime(1, "10:30").toUtc();
    expect(datetime.year == 2020, isTrue);
    expect(datetime.month == 11, isTrue);
    expect(datetime.day == 9, isTrue);
    expect(datetime.hour == 2, isTrue);
    expect(datetime.minute == 20, isTrue);
  });

  test("Test date 2", () {
    final datetime = NotificationHelper.getTime(2, "12:00").toUtc();
    expect(datetime.year == 2020, isTrue);
    expect(datetime.month == 11, isTrue);
    expect(datetime.day == 10, isTrue);
    expect(datetime.hour == 3, isTrue);
    expect(datetime.minute == 50, isTrue);
  });
}
