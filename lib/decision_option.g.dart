// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision_option.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DecisionOption extends DecisionOption {
  @override
  final String description;
  @override
  final String id;

  factory _$DecisionOption([void Function(DecisionOptionBuilder) updates]) =>
      (new DecisionOptionBuilder()..update(updates)).build();

  _$DecisionOption._({this.description, this.id}) : super._() {
    if (description == null) {
      throw new BuiltValueNullFieldError('DecisionOption', 'description');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('DecisionOption', 'id');
    }
  }

  @override
  DecisionOption rebuild(void Function(DecisionOptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DecisionOptionBuilder toBuilder() =>
      new DecisionOptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DecisionOption &&
        description == other.description &&
        id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, description.hashCode), id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DecisionOption')
          ..add('description', description)
          ..add('id', id))
        .toString();
  }
}

class DecisionOptionBuilder
    implements Builder<DecisionOption, DecisionOptionBuilder> {
  _$DecisionOption _$v;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  DecisionOptionBuilder();

  DecisionOptionBuilder get _$this {
    if (_$v != null) {
      _description = _$v.description;
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DecisionOption other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DecisionOption;
  }

  @override
  void update(void Function(DecisionOptionBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DecisionOption build() {
    final _$result =
        _$v ?? new _$DecisionOption._(description: description, id: id);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
