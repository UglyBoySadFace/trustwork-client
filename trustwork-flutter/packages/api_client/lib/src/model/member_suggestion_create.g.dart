// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_suggestion_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberSuggestionCreate extends MemberSuggestionCreate {
  @override
  final String suggestedMatrixId;
  @override
  final String? message;

  factory _$MemberSuggestionCreate(
          [void Function(MemberSuggestionCreateBuilder)? updates]) =>
      (MemberSuggestionCreateBuilder()..update(updates))._build();

  _$MemberSuggestionCreate._({required this.suggestedMatrixId, this.message})
      : super._();
  @override
  MemberSuggestionCreate rebuild(
          void Function(MemberSuggestionCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberSuggestionCreateBuilder toBuilder() =>
      MemberSuggestionCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberSuggestionCreate &&
        suggestedMatrixId == other.suggestedMatrixId &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, suggestedMatrixId.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemberSuggestionCreate')
          ..add('suggestedMatrixId', suggestedMatrixId)
          ..add('message', message))
        .toString();
  }
}

class MemberSuggestionCreateBuilder
    implements Builder<MemberSuggestionCreate, MemberSuggestionCreateBuilder> {
  _$MemberSuggestionCreate? _$v;

  String? _suggestedMatrixId;
  String? get suggestedMatrixId => _$this._suggestedMatrixId;
  set suggestedMatrixId(String? suggestedMatrixId) =>
      _$this._suggestedMatrixId = suggestedMatrixId;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  MemberSuggestionCreateBuilder() {
    MemberSuggestionCreate._defaults(this);
  }

  MemberSuggestionCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _suggestedMatrixId = $v.suggestedMatrixId;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberSuggestionCreate other) {
    _$v = other as _$MemberSuggestionCreate;
  }

  @override
  void update(void Function(MemberSuggestionCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberSuggestionCreate build() => _build();

  _$MemberSuggestionCreate _build() {
    final _$result = _$v ??
        _$MemberSuggestionCreate._(
          suggestedMatrixId: BuiltValueNullFieldError.checkNotNull(
              suggestedMatrixId,
              r'MemberSuggestionCreate',
              'suggestedMatrixId'),
          message: message,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
