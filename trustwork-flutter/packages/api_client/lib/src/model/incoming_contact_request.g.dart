// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_contact_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$IncomingContactRequest extends IncomingContactRequest {
  @override
  final int id;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final ContactProfile requester;
  @override
  final SharingPreferences requesterSharingPreferences;
  @override
  final String? initialMessage;

  factory _$IncomingContactRequest(
          [void Function(IncomingContactRequestBuilder)? updates]) =>
      (IncomingContactRequestBuilder()..update(updates))._build();

  _$IncomingContactRequest._(
      {required this.id,
      required this.status,
      required this.createdAt,
      required this.requester,
      required this.requesterSharingPreferences,
      this.initialMessage})
      : super._();
  @override
  IncomingContactRequest rebuild(
          void Function(IncomingContactRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  IncomingContactRequestBuilder toBuilder() =>
      IncomingContactRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IncomingContactRequest &&
        id == other.id &&
        status == other.status &&
        createdAt == other.createdAt &&
        requester == other.requester &&
        requesterSharingPreferences == other.requesterSharingPreferences &&
        initialMessage == other.initialMessage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, requester.hashCode);
    _$hash = $jc(_$hash, requesterSharingPreferences.hashCode);
    _$hash = $jc(_$hash, initialMessage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'IncomingContactRequest')
          ..add('id', id)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('requester', requester)
          ..add('requesterSharingPreferences', requesterSharingPreferences)
          ..add('initialMessage', initialMessage))
        .toString();
  }
}

class IncomingContactRequestBuilder
    implements Builder<IncomingContactRequest, IncomingContactRequestBuilder> {
  _$IncomingContactRequest? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ContactProfileBuilder? _requester;
  ContactProfileBuilder get requester =>
      _$this._requester ??= ContactProfileBuilder();
  set requester(ContactProfileBuilder? requester) =>
      _$this._requester = requester;

  SharingPreferencesBuilder? _requesterSharingPreferences;
  SharingPreferencesBuilder get requesterSharingPreferences =>
      _$this._requesterSharingPreferences ??= SharingPreferencesBuilder();
  set requesterSharingPreferences(
          SharingPreferencesBuilder? requesterSharingPreferences) =>
      _$this._requesterSharingPreferences = requesterSharingPreferences;

  String? _initialMessage;
  String? get initialMessage => _$this._initialMessage;
  set initialMessage(String? initialMessage) =>
      _$this._initialMessage = initialMessage;

  IncomingContactRequestBuilder() {
    IncomingContactRequest._defaults(this);
  }

  IncomingContactRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _requester = $v.requester.toBuilder();
      _requesterSharingPreferences = $v.requesterSharingPreferences.toBuilder();
      _initialMessage = $v.initialMessage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(IncomingContactRequest other) {
    _$v = other as _$IncomingContactRequest;
  }

  @override
  void update(void Function(IncomingContactRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  IncomingContactRequest build() => _build();

  _$IncomingContactRequest _build() {
    _$IncomingContactRequest _$result;
    try {
      _$result = _$v ??
          _$IncomingContactRequest._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'IncomingContactRequest', 'id'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'IncomingContactRequest', 'status'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'IncomingContactRequest', 'createdAt'),
            requester: requester.build(),
            requesterSharingPreferences: requesterSharingPreferences.build(),
            initialMessage: initialMessage,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'requester';
        requester.build();
        _$failedField = 'requesterSharingPreferences';
        requesterSharingPreferences.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'IncomingContactRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
