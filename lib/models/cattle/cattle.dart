import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle.freezed.dart';
part 'cattle.g.dart';

@freezed
sealed class Cattle with _$Cattle {
  const factory Cattle({
    /// Firestore document ID
    required String id,

    /// Foreign‑key to farm document
     String? farmId,
    required String farmName,
    required String name,
    required String breed,
    required String tag,

    /// Dates are kept as ISO‑strings to match your Java model;
    /// change to DateTime if you prefer.
    required String dob,

    String? weight,
    required String gender,
    required String cattleGroup,
    String? addGroup,
    required String source,
    String? motherTag,
    String? fatherTag,
    required String createdOn,
    required String updatedOn,
    required String status,
  }) = _Cattle;



  /// JSON / Firestore ↔︎ Dart
  factory Cattle.fromJson(Map<String, dynamic> json) => _$CattleFromJson(json);
}
