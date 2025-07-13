import 'package:freezed_annotation/freezed_annotation.dart';

part 'farm.freezed.dart';
part 'farm.g.dart';

@freezed
sealed class Farm with _$Farm {
  /// Main constructor.
  ///
  /// Use nullable fields (`String?`) for values that can be absent in Firestore.
  const factory Farm({
    required String id,
    required String name,
    required String location,
    required String owner,
    required String ownerName,

    // Optional metadata
    String? imageUrl,
    String? description,
    String? createdOn,   // ISO‑8601 yyyy‑MM‑dd or full timestamp
    String? updatedOn,
    String? status,      // e.g. “active”, “archived”
  }) = _Farm;

  /// JSON / Firestore helper
  factory Farm.fromJson(Map<String, dynamic> json) => _$FarmFromJson(json);
}
