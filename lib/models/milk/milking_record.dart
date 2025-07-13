import 'package:freezed_annotation/freezed_annotation.dart';

part 'milking_record.freezed.dart';
part 'milking_record.g.dart';

@freezed
sealed class MilkingRecord with _$MilkingRecord {
  // ───── Main constructor ──────────────────────────────────────────
  const factory MilkingRecord({
    String? id,

    // Farm info
    required String farmName,
    required String farmId,
    required String owner,

    // Cow info
    String? cowId,
    String? cowName,

    /// Date stored as ISO‑8601 `yyyy‑MM‑dd`.
    required String date,

    // Yield fields (litres)
    required double morning,
    required double afternoon,
    required double evening,
    required double milkForCalf,

    /// Cached total (could be computed in UI instead).
    required double total,
    String? scope,
    String? notes,
  }) = _MilkingRecord;

  // ───── JSON helper ───────────────────────────────────────────────
  factory MilkingRecord.fromJson(Map<String, dynamic> json) =>
      _$MilkingRecordFromJson(json);
}
