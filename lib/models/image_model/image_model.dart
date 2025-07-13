import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_model.freezed.dart';
part 'image_model.g.dart';

@freezed
sealed class ImageModel with _$ImageModel {
  /// Primary constructor
  const factory ImageModel({
    required String id,
    required String base64Data,
  }) = _ImageModel;

  /// JSON / Firestore helper
  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);
}

/*──────────────────────────  Extensions  ──────────────────────────*/
/// Handy helpers for converting between Base64 and raw bytes
extension ImageModelX on ImageModel {
  /// Decode the Base64 string into raw bytes.
  Uint8List get bytes => base64Decode(base64Data);

  /// Create a copy with `base64Data` generated from raw bytes.
  ImageModel copyWithBytes(Uint8List data) =>
      copyWith(base64Data: base64Encode(data));
}
