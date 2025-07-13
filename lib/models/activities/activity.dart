import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
sealed class Activity with _$Activity {
  /// Main constructor.
  ///
  /// Most fields are nullable because many activities (e.g. a vaccination)
  /// won’t need *all* the extra data (symptoms, medications, weight, …).
  const factory Activity({
    // ─── Identifiers ────────────────────────────────────────────────
    required String id,
    required String farmId,
    String? farmName,
    required String cattleId,
    String? cattleName,

    // ─── Category & timing ──────────── ──────────────────────────────
    required String type,           // e.g. “Vaccination”, “Breeding”, “Treatment”
    required String date,           // ISO‑8601 string; change to DateTime if you prefer
    String? createdOn,      // when the record itself was created
    String? performedBy,

    // ─── Medical / breeding details ────────────────────────────────
    String? diagnosis,
    List<String>? symptoms,
    List<String>? medications,

    String? treatmentMethod,
    String? recoveryStatus,
    String? nextCheckupDate,

    // Vaccination‑specific
    String? vaccineName,
    String? vaccineDose,

    // Breeding‑specific
    String? breedingType,           // e.g. “AI”, “Natural”
    String? sireTag,

    // Weight check
    String? weight,
    String? weightUnit,

    // Misc
    String? notes,
  }) = _Activity;

  /// JSON / Firestore helper.
  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
