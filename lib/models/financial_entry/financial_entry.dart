import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_entry.freezed.dart';
part 'financial_entry.g.dart';

@freezed
sealed class FinancialEntry with _$FinancialEntry {
  /*───────────────────────────────────────────────────────────────────┐
  │ Variant: Expense                                                  │
  └───────────────────────────────────────────────────────────────────*/
  const factory FinancialEntry.expense({
    required String id,
    required String title,
    required double amount,
    required String category,
    String?  description,
    required String date,           // ISO‑8601
    String? farmId,

    /* extra field */
    required String expenseType,
  }) = ExpenseEntry;

  /*───────────────────────────────────────────────────────────────────┐
  │ (Optional) Variant: Income                                        │
  │ Leave it out if you truly never need it.                          │
  └───────────────────────────────────────────────────────────────────*/
  const factory FinancialEntry.income({
    required String id,
    required String title,
    required double amount,
    required String category,
    String?  description,
    required String date,
    String? farmId,

    /* extra field */
    required String source,
  }) = IncomeEntry;

  factory FinancialEntry.fromJson(Map<String, dynamic> json) =>
      _$FinancialEntryFromJson(json);
}
