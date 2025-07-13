// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseEntry _$ExpenseEntryFromJson(Map<String, dynamic> json) => ExpenseEntry(
  id: json['id'] as String,
  title: json['title'] as String,
  amount: (json['amount'] as num).toDouble(),
  category: json['category'] as String,
  description: json['description'] as String?,
  date: json['date'] as String,
  farmId: json['farmId'] as String?,
  expenseType: json['expenseType'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$ExpenseEntryToJson(ExpenseEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'category': instance.category,
      'description': instance.description,
      'date': instance.date,
      'farmId': instance.farmId,
      'expenseType': instance.expenseType,
      'runtimeType': instance.$type,
    };

IncomeEntry _$IncomeEntryFromJson(Map<String, dynamic> json) => IncomeEntry(
  id: json['id'] as String,
  title: json['title'] as String,
  amount: (json['amount'] as num).toDouble(),
  category: json['category'] as String,
  description: json['description'] as String?,
  date: json['date'] as String,
  farmId: json['farmId'] as String?,
  source: json['source'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$IncomeEntryToJson(IncomeEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'category': instance.category,
      'description': instance.description,
      'date': instance.date,
      'farmId': instance.farmId,
      'source': instance.source,
      'runtimeType': instance.$type,
    };
