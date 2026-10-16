import 'package:flutter_test/flutter_test.dart';
import 'package:radiance_institute/data/models/attendance_model.dart';

void main() {
  group('Attendance Deterministic Session Key Tests', () {
    test('generateId produces deterministic, collision-free key for session and student', () {
      const batchId = 'batch_c11_phys_a';
      const date = '2026-10-15';
      const studentId = 'RAD-2026-0042';

      final key1 = AttendanceModel.generateId(batchId, date, studentId);
      final key2 = AttendanceModel.generateId(batchId, date, studentId);

      expect(key1, 'batch_c11_phys_a_2026-10-15_RAD-2026-0042');
      expect(key1, equals(key2));
    });

    test('different students in same session have distinct keys', () {
      const batchId = 'batch_c11_phys_a';
      const date = '2026-10-15';

      final keyStudent1 = AttendanceModel.generateId(batchId, date, 'RAD-2026-0042');
      final keyStudent2 = AttendanceModel.generateId(batchId, date, 'RAD-2026-0089');

      expect(keyStudent1, isNot(equals(keyStudent2)));
    });
  });
}
