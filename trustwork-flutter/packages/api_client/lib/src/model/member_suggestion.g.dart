// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_suggestion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberSuggestion extends MemberSuggestion {
  @override
  final int id;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final ContactProfile suggester;
  @override
  final String suggestedMatrixId;
  @override
  final ContactProfile? suggested;
  @override
  final bool adminKnowsSuggested;
  @override
  final String? message;

  factory _$MemberSuggestion(
          [void Function(MemberSuggestionBuilder)? updates]) =>
      (MemberSuggestionBuilder()..update(updates))._build();

  _$MemberSuggestion._(
      {required this.id,
      required this.status,
      required this.createdAt,
      required this.suggester,
      required this.suggestedMatrixId,
      this.suggested,
      required this.adminKnowsSuggested,
      this.message})
      : super._();
  @override
  MemberSuggestion rebuild(void Function(MemberSuggestionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberSuggestionBuilder toBuilder() =>
      MemberSuggestionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberSuggestion &&
        id == other.id &&
        status == other.status &&
        createdAt == other.createdAt &&
        suggester == other.suggester &&
        suggestedMatrixId == other.suggestedMatrixId &&
        suggested == other.suggested &&
        adminKnowsSuggested == other.adminKnowsSuggested &&
        message == other.message;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, suggester.hashCode);
    _$hash = $jc(_$hash, suggestedMatrixId.hashCode);
    _$hash = $jc(_$hash, suggested.hashCode);
    _$hash = $jc(_$hash, adminKnowsSuggested.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MemberSuggestion')
          ..add('id', id)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('suggester', suggester)
          ..add('suggestedMatrixId', suggestedMatrixId)
          ..add('suggested', suggested)
          ..add('adminKnowsSuggested', adminKnowsSuggested)
          ..add('message', message))
        .toString();
  }
}

class MemberSuggestionBuilder
    implements Builder<MemberSuggestion, MemberSuggestionBuilder> {
  _$MemberSuggestion? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ContactProfileBuilder? _suggester;
  ContactProfileBuilder get suggester =>
      _$this._suggester ??= ContactProfileBuilder();
  set suggester(ContactProfileBuilder? suggester) =>
      _$this._suggester = suggester;

  String? _suggestedMatrixId;
  String? get suggestedMatrixId => _$this._suggestedMatrixId;
  set suggestedMatrixId(String? suggestedMatrixId) =>
      _$this._suggestedMatrixId = suggestedMatrixId;

  ContactProfileBuilder? _suggested;
  ContactProfileBuilder get suggested =>
      _$this._suggested ??= ContactProfileBuilder();
  set suggested(ContactProfileBuilder? suggested) =>
      _$this._suggested = suggested;

  bool? _adminKnowsSuggested;
  bool? get adminKnowsSuggested => _$this._adminKnowsSuggested;
  set adminKnowsSuggested(bool? adminKnowsSuggested) =>
      _$this._adminKnowsSuggested = adminKnowsSuggested;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  MemberSuggestionBuilder() {
    MemberSuggestion._defaults(this);
  }

  MemberSuggestionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _suggester = $v.suggester.toBuilder();
      _suggestedMatrixId = $v.suggestedMatrixId;
      _suggested = $v.suggested?.toBuilder();
      _adminKnowsSuggested = $v.adminKnowsSuggested;
      _message = $v.message;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberSuggestion other) {
    _$v = other as _$MemberSuggestion;
  }

  @override
  void update(void Function(MemberSuggestionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberSuggestion build() => _build();

  _$MemberSuggestion _build() {
    _$MemberSuggestion _$result;
    try {
      _$result = _$v ??
          _$MemberSuggestion._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'MemberSuggestion', 'id'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'MemberSuggestion', 'status'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'MemberSuggestion', 'createdAt'),
            suggester: suggester.build(),
            suggestedMatrixId: BuiltValueNullFieldError.checkNotNull(
                suggestedMatrixId, r'MemberSuggestion', 'suggestedMatrixId'),
            suggested: _suggested?.build(),
            adminKnowsSuggested: BuiltValueNullFieldError.checkNotNull(
                adminKnowsSuggested,
                r'MemberSuggestion',
                'adminKnowsSuggested'),
            message: message,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'suggester';
        suggester.build();

        _$failedField = 'suggested';
        _suggested?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MemberSuggestion', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
