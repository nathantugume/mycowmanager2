// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
FinancialEntry _$FinancialEntryFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'expense':
          return ExpenseEntry.fromJson(
            json
          );
                case 'income':
          return IncomeEntry.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'FinancialEntry',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$FinancialEntry {

 String get id; String get title; double get amount; String get category; String? get description; String get date;// ISO‑8601
 String? get farmId;
/// Create a copy of FinancialEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialEntryCopyWith<FinancialEntry> get copyWith => _$FinancialEntryCopyWithImpl<FinancialEntry>(this as FinancialEntry, _$identity);

  /// Serializes this FinancialEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.farmId, farmId) || other.farmId == farmId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,amount,category,description,date,farmId);

@override
String toString() {
  return 'FinancialEntry(id: $id, title: $title, amount: $amount, category: $category, description: $description, date: $date, farmId: $farmId)';
}


}

/// @nodoc
abstract mixin class $FinancialEntryCopyWith<$Res>  {
  factory $FinancialEntryCopyWith(FinancialEntry value, $Res Function(FinancialEntry) _then) = _$FinancialEntryCopyWithImpl;
@useResult
$Res call({
 String id, String title, double amount, String category, String? description, String date, String? farmId
});




}
/// @nodoc
class _$FinancialEntryCopyWithImpl<$Res>
    implements $FinancialEntryCopyWith<$Res> {
  _$FinancialEntryCopyWithImpl(this._self, this._then);

  final FinancialEntry _self;
  final $Res Function(FinancialEntry) _then;

/// Create a copy of FinancialEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? category = null,Object? description = freezed,Object? date = null,Object? farmId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,farmId: freezed == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialEntry].
extension FinancialEntryPatterns on FinancialEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExpenseEntry value)?  expense,TResult Function( IncomeEntry value)?  income,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExpenseEntry() when expense != null:
return expense(_that);case IncomeEntry() when income != null:
return income(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExpenseEntry value)  expense,required TResult Function( IncomeEntry value)  income,}){
final _that = this;
switch (_that) {
case ExpenseEntry():
return expense(_that);case IncomeEntry():
return income(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExpenseEntry value)?  expense,TResult? Function( IncomeEntry value)?  income,}){
final _that = this;
switch (_that) {
case ExpenseEntry() when expense != null:
return expense(_that);case IncomeEntry() when income != null:
return income(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  String title,  double amount,  String category,  String? description,  String date,  String? farmId,  String expenseType)?  expense,TResult Function( String id,  String title,  double amount,  String category,  String? description,  String date,  String? farmId,  String source)?  income,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExpenseEntry() when expense != null:
return expense(_that.id,_that.title,_that.amount,_that.category,_that.description,_that.date,_that.farmId,_that.expenseType);case IncomeEntry() when income != null:
return income(_that.id,_that.title,_that.amount,_that.category,_that.description,_that.date,_that.farmId,_that.source);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  String title,  double amount,  String category,  String? description,  String date,  String? farmId,  String expenseType)  expense,required TResult Function( String id,  String title,  double amount,  String category,  String? description,  String date,  String? farmId,  String source)  income,}) {final _that = this;
switch (_that) {
case ExpenseEntry():
return expense(_that.id,_that.title,_that.amount,_that.category,_that.description,_that.date,_that.farmId,_that.expenseType);case IncomeEntry():
return income(_that.id,_that.title,_that.amount,_that.category,_that.description,_that.date,_that.farmId,_that.source);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  String title,  double amount,  String category,  String? description,  String date,  String? farmId,  String expenseType)?  expense,TResult? Function( String id,  String title,  double amount,  String category,  String? description,  String date,  String? farmId,  String source)?  income,}) {final _that = this;
switch (_that) {
case ExpenseEntry() when expense != null:
return expense(_that.id,_that.title,_that.amount,_that.category,_that.description,_that.date,_that.farmId,_that.expenseType);case IncomeEntry() when income != null:
return income(_that.id,_that.title,_that.amount,_that.category,_that.description,_that.date,_that.farmId,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ExpenseEntry implements FinancialEntry {
  const ExpenseEntry({required this.id, required this.title, required this.amount, required this.category, this.description, required this.date, this.farmId, required this.expenseType, final  String? $type}): $type = $type ?? 'expense';
  factory ExpenseEntry.fromJson(Map<String, dynamic> json) => _$ExpenseEntryFromJson(json);

@override final  String id;
@override final  String title;
@override final  double amount;
@override final  String category;
@override final  String? description;
@override final  String date;
// ISO‑8601
@override final  String? farmId;
/* extra field */
 final  String expenseType;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of FinancialEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseEntryCopyWith<ExpenseEntry> get copyWith => _$ExpenseEntryCopyWithImpl<ExpenseEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.expenseType, expenseType) || other.expenseType == expenseType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,amount,category,description,date,farmId,expenseType);

@override
String toString() {
  return 'FinancialEntry.expense(id: $id, title: $title, amount: $amount, category: $category, description: $description, date: $date, farmId: $farmId, expenseType: $expenseType)';
}


}

/// @nodoc
abstract mixin class $ExpenseEntryCopyWith<$Res> implements $FinancialEntryCopyWith<$Res> {
  factory $ExpenseEntryCopyWith(ExpenseEntry value, $Res Function(ExpenseEntry) _then) = _$ExpenseEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, double amount, String category, String? description, String date, String? farmId, String expenseType
});




}
/// @nodoc
class _$ExpenseEntryCopyWithImpl<$Res>
    implements $ExpenseEntryCopyWith<$Res> {
  _$ExpenseEntryCopyWithImpl(this._self, this._then);

  final ExpenseEntry _self;
  final $Res Function(ExpenseEntry) _then;

/// Create a copy of FinancialEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? category = null,Object? description = freezed,Object? date = null,Object? farmId = freezed,Object? expenseType = null,}) {
  return _then(ExpenseEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,farmId: freezed == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String?,expenseType: null == expenseType ? _self.expenseType : expenseType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class IncomeEntry implements FinancialEntry {
  const IncomeEntry({required this.id, required this.title, required this.amount, required this.category, this.description, required this.date, this.farmId, required this.source, final  String? $type}): $type = $type ?? 'income';
  factory IncomeEntry.fromJson(Map<String, dynamic> json) => _$IncomeEntryFromJson(json);

@override final  String id;
@override final  String title;
@override final  double amount;
@override final  String category;
@override final  String? description;
@override final  String date;
@override final  String? farmId;
/* extra field */
 final  String source;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of FinancialEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomeEntryCopyWith<IncomeEntry> get copyWith => _$IncomeEntryCopyWithImpl<IncomeEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IncomeEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomeEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.date, date) || other.date == date)&&(identical(other.farmId, farmId) || other.farmId == farmId)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,amount,category,description,date,farmId,source);

@override
String toString() {
  return 'FinancialEntry.income(id: $id, title: $title, amount: $amount, category: $category, description: $description, date: $date, farmId: $farmId, source: $source)';
}


}

/// @nodoc
abstract mixin class $IncomeEntryCopyWith<$Res> implements $FinancialEntryCopyWith<$Res> {
  factory $IncomeEntryCopyWith(IncomeEntry value, $Res Function(IncomeEntry) _then) = _$IncomeEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, double amount, String category, String? description, String date, String? farmId, String source
});




}
/// @nodoc
class _$IncomeEntryCopyWithImpl<$Res>
    implements $IncomeEntryCopyWith<$Res> {
  _$IncomeEntryCopyWithImpl(this._self, this._then);

  final IncomeEntry _self;
  final $Res Function(IncomeEntry) _then;

/// Create a copy of FinancialEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? category = null,Object? description = freezed,Object? date = null,Object? farmId = freezed,Object? source = null,}) {
  return _then(IncomeEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,farmId: freezed == farmId ? _self.farmId : farmId // ignore: cast_nullable_to_non_nullable
as String?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
