import 'package:freezed_annotation/freezed_annotation.dart';

part 'cattle_group.freezed.dart';
part 'cattle_group.g.dart';

@freezed
sealed class CattleGroup with _$CattleGroup {
  /// Core constructor
  const factory CattleGroup({
    required String id,
    required String name,

    /// Foreign‑key to farm
    required String farmId,
    required String farmName,

    /// ISO‑8601 timestamps (nullable if you create them later)
    String? createdOn,
    String? updatedOn,
  }) = _CattleGroup;

  /// JSON / Firestore helper
  factory CattleGroup.fromJson(Map<String, dynamic> json) =>
      _$CattleGroupFromJson(json);
}
