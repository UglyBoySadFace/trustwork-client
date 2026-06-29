// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocked_contact_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BlockedContactRequest extends BlockedContactRequest {
  @override
  final int id;
  @override
  final ContactProfile requester;
  @override
  final DateTime? blockedAt;

  factory _$BlockedContactRequest(
          [void Function(BlockedContactRequestBuilder)? updates]) =>
      (BlockedContactRequestBuilder()..update(updates))._build();

  _$BlockedContactRequest._(
      {required this.id, required this.requester, this.blockedAt})
      : super._();
  @override
  BlockedContactRequest rebuild(
          void Function(BlockedContactRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BlockedContactRequestBuilder toBuilder() =>
      BlockedContactRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BlockedContactRequest &&
        id == other.id &&
        requester == other.requester &&
        blockedAt == other.blockedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, requester.hashCode);
    _$hash = $jc(_$hash, blockedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BlockedContactRequest')
          ..add('id', id)
          ..add('requester', requester)
          ..add('blockedAt', blockedAt))
        .toString();
  }
}

class BlockedContactRequestBuilder
    implements Builder<BlockedContactRequest, BlockedContactRequestBuilder> {
  _$BlockedContactRequest? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  ContactProfileBuilder? _requester;
  ContactProfileBuilder get requester =>
      _$this._requester ??= ContactProfileBuilder();
  set requester(ContactProfileBuilder? requester) =>
      _$this._requester = requester;

  DateTime? _blockedAt;
  DateTime? get blockedAt => _$this._blockedAt;
  set blockedAt(DateTime? blockedAt) => _$this._blockedAt = blockedAt;

  BlockedContactRequestBuilder() {
    BlockedContactRequest._defaults(this);
  }

  BlockedContactRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _requester = $v.requester.toBuilder();
      _blockedAt = $v.blockedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BlockedContactRequest other) {
    _$v = other as _$BlockedContactRequest;
  }

  @override
  void update(void Function(BlockedContactRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BlockedContactRequest build() => _build();

  _$BlockedContactRequest _build() {
    _$BlockedContactRequest _$result;
    try {
      _$result = _$v ??
          _$BlockedContactRequest._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'BlockedContactRequest', 'id'),
            requester: requester.build(),
            blockedAt: blockedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'requester';
        requester.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BlockedContactRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
