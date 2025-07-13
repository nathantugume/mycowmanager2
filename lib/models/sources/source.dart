import 'package:freezed_annotation/freezed_annotation.dart';

part 'source.freezed.dart';
part 'source.g.dart';

@freezed
sealed class Source with _$Source {
  const factory Source({
    required String id,
    required String name,
    required String farmId,
    String? createdAt,
  }) = _Source;

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
}
