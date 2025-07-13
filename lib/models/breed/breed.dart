import 'package:freezed_annotation/freezed_annotation.dart';

part 'breed.freezed.dart';
part 'breed.g.dart';

@freezed
sealed class Breed with _$Breed {
  /// Core constructor
  const factory Breed({
    required String id,
    required String name,

    /// Foreign‑key to farm
    required String farmId,
    required String farmName,

    /// ISO‑8601 timestamps (nullable if not set yet)
    String? createdOn,
    String? updatedOn,
  }) = _Breed;

  /// JSON / Firestore helper
  factory Breed.fromJson(Map<String, dynamic> json) => _$BreedFromJson(json);
}
